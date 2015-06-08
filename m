From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: NILFS2: double uuid
Date: Mon, 08 Jun 2015 19:31:51 +0900
Message-ID: <55756F17.7080603@lab.ntt.co.jp>
References: <20150608064314.GA3172@fritha.org> <55754FDA.10406@lab.ntt.co.jp> <20150608094559.GB15702@fritha.org> <20150608100835.GA16569@fritha.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150608100835.GA16569-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Heinz Diehl <htd+ml-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 2015/06/08 19:08, Heinz Diehl wrote:
> On 08.06.2015, Heinz Diehl wrote:
>
> To be more precise, here's what works and what don't, in detail
> (and after a fresh install of Arch):
>
> The USB memory is xfs formatted and works fine:
>
> [root@alarmpi /]# lsblk -f
> NAME        FSTYPE LABEL UUID                                 MOUNTPOINT
> sda
> `-sda1      xfs          ff17dda9-fcae-42e7-a438-9087de58902e
> mmcblk0
> |-mmcblk0p1 vfat         EA5B-4477                            /boot
> `-mmcblk0p2 ext4         c4ddc925-15ab-4465-ac78-967a845e98d5 /
>
>
> Now, it's nilfs2 formatted:
>
> [root@alarmpi /]# mkfs.nilfs2 /dev/sda1
> WARNING: Device /dev/sda1 appears to contain an existing xfs superblock.
> WARNING: All data will be lost after format!
>
> DO YOU REALLY WANT TO FORMAT DEVICE /dev/sda1?
>
> Continue? [y/N] y
> mkfs.nilfs2 (nilfs-utils 2.2.3)
> Start writing file system initial data to the device
>         Blocksize:4096  Device:/dev/sda1  Device Size:32026656768
> File system initialization succeeded !!
>
> After that, all seems to be ok. lsblk shown no double uuid:
>
> [root@alarmpi /]# lsblk -f
> NAME        FSTYPE LABEL UUID                                 MOUNTPOINT
> sda
> `-sda1      nilfs2       98da384c-392e-4551-98c0-d076524f5d8b
> mmcblk0
> |-mmcblk0p1 vfat         EA5B-4477                            /boot
> `-mmcblk0p2 ext4         c4ddc925-15ab-4465-ac78-967a845e98d5 /
> [root@alarmpi /]#
>
>
> Now the USB drive gets manually mounted, all is ok:
>
> [root@alarmpi /]# mount /dev/sda1 /USBDRIVE
> [root@alarmpi /]# lsblk -f
> NAME        FSTYPE LABEL UUID                                 MOUNTPOINT
> sda
> `-sda1      nilfs2       98da384c-392e-4551-98c0-d076524f5d8b /USBDRIVE
> mmcblk0
> |-mmcblk0p1 vfat         EA5B-4477                            /boot
> `-mmcblk0p2 ext4         c4ddc925-15ab-4465-ac78-967a845e98d5 /
>
>
> Now, the newly formatted drive is registered in fstab to be
> automatically mounted on boot:
>
> UUID=ff17dda9-fcae-42e7-a438-9087de58902e	/USBDRIVE	nilfs2	defaults	0	0
>
> After rebooting the machine, nothing is mounted, and lsblk shows the
> double uuid:
>
> [root@alarmpi /]# lsblk -f
> NAME        FSTYPE LABEL UUID                                 MOUNTPOINT
> sda                      98da384c-392e-4551-98c0-d076524f5d8b
> `-sda1      nilfs2       98da384c-392e-4551-98c0-d076524f5d8b
> mmcblk0
> |-mmcblk0p1 vfat         EA5B-4477                            /boot
> `-mmcblk0p2 ext4         c4ddc925-15ab-4465-ac78-967a845e98d5 /
>
> The logs say:
>
> Jun 08 11:23:47 alarmpi mount: mount.nilfs2: Error while mounting /dev/sda on /USBDRIVE: Device or resource busy
> Jun 08 11:23:47 alarmpi systemd: Failed to mount /USBDRIVE.
>
> Here it becomes clear what happens: the system wants to mount /dev/sda
> rather than /dev/sda1, and thus fails.
>
> Out of curiosity, I tried both xfs, ext4 and btrfs, and all of them
> just work.

I've tested the same steps as you wrote above (first created an
xfs partition, overrode it with a nilfs2 partition, wrote a similar
entry to fstab, and reboot),  but didn't reproduce the issue.

On my CentOS 7 environment, lsblk and default mount are perfectly
working.

So, it may be a version dependent issue of util-linux.
I will try to reproduce and nallow down the issue with newer util-linux
packages.

Thanks,
Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
