From: Heinz Diehl <htd+ml-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>
Subject: Re: NILFS2: double uuid
Date: Mon, 8 Jun 2015 11:45:59 +0200
Message-ID: <20150608094559.GB15702@fritha.org>
References: <20150608064314.GA3172@fritha.org>
 <55754FDA.10406@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55754FDA.10406-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 08.06.2015, Ryusuke Konishi wrote: 

> Could you tell us the version information of distro,
> lsblk, libblkid, nilfs-utils, and kernel you are using ?

It happens on two different systems:

The first one is bog-standard Fedora 21:

[htd@chiara ~]$ rpm -qa | egrep 'lsblk|libblkid|nilfs'
libblkid-devel-2.25.2-3.fc21.x86_64
libblkid-2.25.2-3.fc21.x86_64
nilfs-utils-2.2.3-1.fc21.x86_64

[htd@chiara ~]$ lscp -V
lscp (nilfs-utils 2.2.3)

[htd@chiara ~]$ lsblk --version
lsblk from util-linux 2.25.2

[htd@chiara ~]$ uname -a
Linux chiara.fritha.org 4.0.5-rc1 #1 SMP PREEMPT Wed Jun 3 20:41:46 CEST 2015 x86_64 x86_64 x86_64 GNU/Linux


The second one is Arch Linux on a Raspberry Pi:

[root@keera ~]# pacman -Q | egrep 'libutil|nilfs'
libutil-linux 2.26.2-1
nilfs-utils 2.2.3-1

[root@keera ~]# lsblk --version
lsblk from util-linux 2.26.2

[root@keera ~]# lscp -V
lscp (nilfs-utils 2.2.3)

[root@keera ~]# uname -a
Linux keera 3.18.14-2-ARCH #1 SMP PREEMPT Thu May 28 07:19:33 MDT 2015 armv7l GNU/Linux

Tried to re-format the home partition on a Fedora 21 laptop with
nilfs2 and ran into the same problem as with USB memory as a samba
share on the Pi: the system tried to mount the block device rather
than the partition due to the uuid as shown in my previous email.

Thanks, Heinz.

-- 
OpenPGP Fingerprint: 531E 8E75 4395 ED38 CEC2  FD75 A1EB 6944 60F4 A92C
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
