From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: NILFS2: double uuid
Date: Tue, 09 Jun 2015 00:31:27 +0900 (JST)
Message-ID: <20150609.003127.1516615115859573912.konishi.ryusuke@lab.ntt.co.jp>
References: <20150608094559.GB15702@fritha.org>
	<20150608100835.GA16569@fritha.org>
	<55756F17.7080603@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=vRaVzIzwRbxhyLOsky35jYLDBJ75lrwIxa7guK7qZJg=;
        b=MJ2M7md13vra1igQQyTPyILVJw2C+T+tcn/rVywUqeE1mU9J7XGkh2S2StiWDgLQKe
         44vfU0eZ4aRtNcbWI3ipNP7OpJW/3cKiOUHAn2VwzQnR0xMnCF4w1w7lk1JVBonH2t9y
         EZB7pvhouD64hojyf+q/6txW5aTUZRg3lXb+6nD1GNdgHlX0U8a2N62bruG4BWzTiqSE
         gPPt1lq1lF//jNSZui050anwxB4YBJRP0o4FRlYp2ygCpoAKSBRM9GuWo4IRIIYhMB3K
         rg9FRzdEuUNqbJgXHNTeEra4hmDGzWG+FG05kaU0tV9F/NdmG0MO+iOxjfgy6mokEVKn
         WA9Q==
In-Reply-To: <55756F17.7080603-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Heinz Diehl <htd+ml-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(CCed to Karel Zak)
Hi,

I succeeded to reproduce this issue on Fedora 20, 21, 22 and Debian
jessie.  Also, I could narrow down the issue.

This turned out to be an issue of libblkid in util-linux and
introduced by the commit 5f77ce6f3269 ("libblkid: (nilfs2) check also
backup superblock"):

 * commit 1a38ad5c3271a59c7e51580242a2fbd3b0f16495 --> OK

$ sudo LD_LIBRARY_PATH=/usr/local/lib lsblk --version
lsblk from util-linux 2.24.153-1a38
$ sudo LD_LIBRARY_PATH=/usr/local/lib lsblk -f
NAME   FSTYPE  LABEL           UUID                                 MOUNTPOINT
[...]
sdb
`-sdb1 nilfs2                  c6cd2c9c-0291-4f9f-be9b-10ff8e2acbe6 /test

 * commit 5f77ce6f32692b473ffcec4c6f63dbd38cd5eeda  --> NG

$ sudo LD_LIBRARY_PATH=/usr/local/lib lsblk --version
lsblk from util-linux 2.24.154-5f77c
$ sudo LD_LIBRARY_PATH=/usr/local/lib lsblk -f
NAME   FSTYPE  LABEL           UUID                                 MOUNTPOINT
[...]
sdb    nilfs2                  c6cd2c9c-0291-4f9f-be9b-10ff8e2acbe6
`-sdb1 nilfs2                  c6cd2c9c-0291-4f9f-be9b-10ff8e2acbe6 /test

Here, the backup super block of /dev/sdb1 got detected also for
/dev/sdb by the commit 5f77ce6f3269.

This change has been applied between v2.24 and v2.24.1 of util-linux,
and not yet fixed in the mainline.

It causes the duplicate uuid and leads the UUID mount written in the
fstab file to mount the device itself (i.e. /dev/sdb in this example).
Thus the mount failure happens.

It looks like the backup super block should be dropped from candidates
if its device size (sbp->s_dev_size) doesn't match the partition size.

Regards,
Ryusuke Konishi

On Mon, 08 Jun 2015 19:31:51 +0900, Ryusuke Konishi wrote:
> Hi,
> 
> On 2015/06/08 19:08, Heinz Diehl wrote:
>> On 08.06.2015, Heinz Diehl wrote:
>>
>> To be more precise, here's what works and what don't, in detail
>> (and after a fresh install of Arch):
>>
>> The USB memory is xfs formatted and works fine:
>>
>> [root@alarmpi /]# lsblk -f
>> NAME FSTYPE LABEL UUID MOUNTPOINT
>> sda
>> `-sda1      xfs          ff17dda9-fcae-42e7-a438-9087de58902e
>> mmcblk0
>> |-mmcblk0p1 vfat         EA5B-4477                            /boot
>> `-mmcblk0p2 ext4         c4ddc925-15ab-4465-ac78-967a845e98d5 /
>>
>>
>> Now, it's nilfs2 formatted:
>>
>> [root@alarmpi /]# mkfs.nilfs2 /dev/sda1
>> WARNING: Device /dev/sda1 appears to contain an existing xfs
>> superblock.
>> WARNING: All data will be lost after format!
>>
>> DO YOU REALLY WANT TO FORMAT DEVICE /dev/sda1?
>>
>> Continue? [y/N] y
>> mkfs.nilfs2 (nilfs-utils 2.2.3)
>> Start writing file system initial data to the device
>>         Blocksize:4096  Device:/dev/sda1  Device Size:32026656768
>> File system initialization succeeded !!
>>
>> After that, all seems to be ok. lsblk shown no double uuid:
>>
>> [root@alarmpi /]# lsblk -f
>> NAME FSTYPE LABEL UUID MOUNTPOINT
>> sda
>> `-sda1      nilfs2       98da384c-392e-4551-98c0-d076524f5d8b
>> mmcblk0
>> |-mmcblk0p1 vfat         EA5B-4477                            /boot
>> `-mmcblk0p2 ext4         c4ddc925-15ab-4465-ac78-967a845e98d5 /
>> [root@alarmpi /]#
>>
>>
>> Now the USB drive gets manually mounted, all is ok:
>>
>> [root@alarmpi /]# mount /dev/sda1 /USBDRIVE
>> [root@alarmpi /]# lsblk -f
>> NAME FSTYPE LABEL UUID MOUNTPOINT
>> sda
>> `-sda1 nilfs2 98da384c-392e-4551-98c0-d076524f5d8b /USBDRIVE
>> mmcblk0
>> |-mmcblk0p1 vfat         EA5B-4477                            /boot
>> `-mmcblk0p2 ext4         c4ddc925-15ab-4465-ac78-967a845e98d5 /
>>
>>
>> Now, the newly formatted drive is registered in fstab to be
>> automatically mounted on boot:
>>
>> UUID=ff17dda9-fcae-42e7-a438-9087de58902e /USBDRIVE nilfs2 defaults 0
>> 0
>>
>> After rebooting the machine, nothing is mounted, and lsblk shows the
>> double uuid:
>>
>> [root@alarmpi /]# lsblk -f
>> NAME FSTYPE LABEL UUID MOUNTPOINT
>> sda                      98da384c-392e-4551-98c0-d076524f5d8b
>> `-sda1      nilfs2       98da384c-392e-4551-98c0-d076524f5d8b
>> mmcblk0
>> |-mmcblk0p1 vfat         EA5B-4477                            /boot
>> `-mmcblk0p2 ext4         c4ddc925-15ab-4465-ac78-967a845e98d5 /
>>
>> The logs say:
>>
>> Jun 08 11:23:47 alarmpi mount: mount.nilfs2: Error while mounting
>> /dev/sda on /USBDRIVE: Device or resource busy
>> Jun 08 11:23:47 alarmpi systemd: Failed to mount /USBDRIVE.
>>
>> Here it becomes clear what happens: the system wants to mount /dev/sda
>> rather than /dev/sda1, and thus fails.
>>
>> Out of curiosity, I tried both xfs, ext4 and btrfs, and all of them
>> just work.
> 
> I've tested the same steps as you wrote above (first created an
> xfs partition, overrode it with a nilfs2 partition, wrote a similar
> entry to fstab, and reboot),  but didn't reproduce the issue.
> 
> On my CentOS 7 environment, lsblk and default mount are perfectly
> working.
> 
> So, it may be a version dependent issue of util-linux.
> I will try to reproduce and nallow down the issue with newer
> util-linux
> packages.
> 
> Thanks,
> Ryusuke Konishi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
