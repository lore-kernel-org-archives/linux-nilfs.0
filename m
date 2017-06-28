From: Rodrigo Severo <rodrigo-sUXncmUOihszlUgHzu1iJkEOCMrvLtNR@public.gmane.org>
Subject: nilfs bad btree node and broken bmap
Date: Wed, 28 Jun 2017 16:19:01 -0300
Message-ID: <CAOdi6ianj9cgMHwjSzAkd=f2o3-i5KX4mznnR5hDzsN7ggKLdg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fabricadeideias-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=Xa8Innf7eNo8VmaPsH3tV7STTx/WjeJ9BXPH4koTt9w=;
        b=o/MnX0j8uA527TCWzAwVEi2r8qfF7g1uO28rMkj2T+f4MKJZyNY1Of3dXZtrkTg3gm
         8GbfVKZxhS1hWCqXeADlLWI6rOXH7QmAydxj31z1AdZvqbrgHqR+eUwVK7m/P1ib93Xt
         BZMPKZSPCmOUWegc72jH0NfCO7Fqmw1GOpA2pcqXENLxE2j4AWuYtQyXG9Kiqt2I2zv8
         9IVH49ltfAMiDygrfqwx+P/vUM3DVlVN1OZXuIwpcMxTcOrs2b6e+XQR9VXDoh/GcLww
         G+xoHNgQP7KaQrjrNVNAKYJllibJrf6fT5P+ZyQZ5txo+eJSS2HsuVDiqtoKuXcob/xR
         A8Dw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,


I have a 8TG nilfs2 disk with started changing to read-only by itself.

My log files are full of the following error messages:

Jun 28 15:57:08 c1-df kernel: [ 1637.138168] NILFS (sdd1): bad btree
node (ino=6069196, blocknr=446552325): level = 69, flags = 0x24,
nchildren = 8203
Jun 28 15:57:08 c1-df kernel: [ 1637.139363] NILFS error (device
sdd1): nilfs_bmap_lookup_contig: broken bmap (inode number=6069196)

I have already checked and there are not errors on the disk.

How can I fix this?


Regards,

Rodrigo Severo
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
