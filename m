From: Hideki EIRAKU <hdk1983-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000000000000a8 in nilfs_segctor_do_co
Date: Thu, 30 Apr 2020 21:38:42 +0900 (JST)
Message-ID: <20200430.213842.00392641.hdk1983@gmail.com>
References: <20200328.182640.1933740379722138264.hermes@ceres.dti.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wRkLzyuGtF2Q4xp2VtfmTiBkQlJCTHTwWparYAwfuoU=;
        b=hc8MJ3lIn6hFiDSeQRVBfFF5RjA6A4aKPnMetaQ2cBW3UpKDngHpg7uTPdFQDAC/yv
         3OcBj+GPux+F9egKh2SmpGDxiBzsBgUY/E8N5fh3uG+G41v4lIpFZWysQBIM95+nVzvM
         EOFZWGukCgJi+fi3tRBkGlzTwYeuQwUNv841tdEyCVhF1HXWk0FWreJqAEqwChsowQED
         +2RoXGbP7wAyNBIos5OqBvM//NlO2/Qm2WcM9qxsI9GGQ68+QyR+5lFBDzLNYFHAeEI7
         nZDfcjXr2G2sIcVCNJ1thihIsrN/0NAkczvaVuGuQreOgq5tWbD/JhtvTYTQvhOt+loZ
         XrTg==
In-Reply-To: <20200328.182640.1933740379722138264.hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> In Msg <874kuapb2s.fsf-3l5KtCzVe0PQT0dZR+AlfA@public.gmane.org>;
>    Subject "Re: BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8 in nilfs_segctor_do_construct":
> 
>> Tomas Hlavaty <tom-3l5KtCzVe0PQT0dZR+AlfA@public.gmane.org> writes:
>>>>> 2) Can you mount the corrupted(?) partition from a recent version of
>>>>> kernel ?
>> 
>> I tried the following Linux kernel versions:
>> 
>> - v4.19
>> - v5.4
>> - v5.5.11
>> 
>> and still get the crash

I found conditions to reproduce this issue with Linux 5.7-rc3:

- CONFIG_MEMCG=y *and* CONFIG_BLK_CGROUP=y

- When the NILFS2 file system writes to a device, the device file has
  never written by other programs since boot

The following is an example with CONFIG_MEMCG=y and
CONFIG_BLK_CGROUP=y kernel.  If you do mkfs and mount it, it works
because the mkfs command has written data to the device file before
mounting:

# mkfs -t nilfs2 /dev/sda1
mkfs.nilfs2 (nilfs-utils 2.2.7)
Start writing file system initial data to the device
       Blocksize:4096  Device:/dev/sda1  Device Size:267386880
File system initialization succeeded !! 
# mount /dev/sda1 /mnt
# touch /mnt
# sync
# 

Loopback mount seems to be the same - if you do losetup, mkfs and
mount on a loopback device, it works:

# losetup /dev/loop0 foo
# mkfs -t nilfs2 /dev/loop0
mkfs.nilfs2 (nilfs-utils 2.2.7)
Start writing file system initial data to the device
       Blocksize:4096  Device:/dev/loop0  Device Size:267386880
File system initialization succeeded !! 
# mount /dev/sda1 /mnt
# touch /mnt
# sync
# 

But if you do mkfs on a file and use mount -o loop, it may fail,
depending on whether the loopback device assigned by the mount command
was used or not before mounting:

# /sbin/mkfs.nilfs2 ./foo
mkfs.nilfs2 (nilfs-utils 2.2.7)
Start writing file system initial data to the device
       Blocksize:4096  Device:./foo  Device Size:268435456
File system initialization succeeded !! 
# mount -o loop ./foo /mnt
[   36.371331] NILFS (loop0): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
# touch /mnt
# sync
[   40.252869] BUG: kernel NULL pointer dereference, address: 00000000000000a8
(snip)

After reboot, it fails:

# mount /dev/sda1 /mnt
[   14.021188] NILFS (sda1): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
# touch /mnt
# sync
[   20.576309] BUG: kernel NULL pointer dereference, address: 00000000000000a8
(snip)

But if you do dummy write to the device file before mounting, it
works:

# dd if=/dev/sda1 of=/dev/sda1 count=1
1+0 records in
1+0 records out
512 bytes copied, 0.0135982 s, 37.7 kB/s
# mount /dev/sda1 /mnt
[   52.604560] NILFS (sda1): mounting unchecked fs
[   52.613335] NILFS (sda1): recovery complete
[   52.613877] NILFS (sda1): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
# touch /mnt
# sync
# 

# losetup /dev/loop0 foo
# dd if=/dev/loop0 of=/dev/loop0 count=1
1+0 records in
1+0 records out
512 bytes copied, 0.0243797 s, 21.0 kB/s
# mount /dev/loop0 /mnt
[  271.915595] NILFS (loop0): mounting unchecked fs
[  272.049603] NILFS (loop0): recovery complete
[  272.049724] NILFS (loop0): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
# touch /mnt
# sync
# 

I think the dummy write is a simple workaround for now, unless
mounting NILFS2 at boot time.  But I have been using NILFS2 /home for
years, I would like to know better workarounds.

