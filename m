From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs_cleanerd not running
Date: Wed, 31 Aug 2016 13:03:18 +0900 (JST)
Message-ID: <20160831.130318.2237136741600829685.konishi.ryusuke@lab.ntt.co.jp>
References: <2a90bda59a98d4f35e8dbab5534c014e@fripost.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LG0QM2wUCuJnH1sXQ6E4+PGF8j76BYRNyj/dB2WEDzo=;
        b=plKxQDE7mfDtBse6CRXDfGJGrB0T0YpqNpZPx229Tl2Qm8uOGdjynVVvPlhdik4x4B
         flFYb+DW3HGtRIhLHtbOKnqP0PTP+1dWy7Pvv9s/fXuPrcU+N7uvNi7hiVj9Y/CBGNba
         XmI+A0XdKd4yxKkxffeRETE3C5sruCb+FOSzfqC2Mjlpodu/2PXgVvPc0WMOH+W+/QN8
         FLxP0V+PvcjfyRPRd96K6qCTXLk/zWu8H+KI1EL/WrNxLTFx5pCiZOIV4GFyK7/l3dji
         M+7w/aVxsYx7oaPHMbdv8SUPQzV8SspXAZutsqEefKztBRT88RprvTmp3nvKLs6WEFVr
         ZVDg==
In-Reply-To: <2a90bda59a98d4f35e8dbab5534c014e-m2T68/X/qvZAfugRpC6u6w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mikael-m2T68/X/qvZAfugRpC6u6w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 30 Aug 2016 22:01:09 +0200, mikael-m2T68/X/qvZAfugRpC6u6w@public.gmane.org wrote:
> Hi,
> 
> It seems my NILFS is not garbage collected. The other day I was not
> able to boot up my NixOS due to a full disk. I booted on a USB stick
> and ran nilfs-clean which freed about 20 Gbytes. I suppose there
> should always be a process nilfs_cleanerd running on a system in order
> to clean up old check points. I have actually not read on the NILFS
> web site that nilfs_cleanerd should be running normally, but maybe I
> have missed this. Should it not be running normally?
> 
> When I am running nilfs-clean on my device, I get:
> 
> 'No cleaner found on /dev/dm-0.'
> 
> mount | grep nilfs gives:
> 
> /dev/mapper/cryptroot on / type nilfs2 (rw,relatime)
> /dev/mapper/cryptroot on /nix/store type nilfs2 (ro,relatime)
> 
> nilfs-clean -V gives:
> 
> nilfs-clean version 2.2.3
> 
> I am only able to run nilfs_cleanerd after setting LD_LIBRARY_PATH to
> /nix/store/*-nilfs-utils-2.2.3/lib
> 
> nilfs_cleanerd /dev/mapper/cryptroot
> NILFS_CLEANERD_PID=24468
> 
> It seems however like the process terminates since there does not seem
> to exist any process when running 'ps aux | grep nilfs'
> 
> When trying 'sudo mount -t nilfs2 -o remount,pp=1
> /dev/mapper/cryptroot /', I get:
> 
> /nix/store/y0ldq0j9qpax23d6g5iww7nz17xgx32q-nilfs-utils-2.2.3/sbin/nilfs_cleanerd:
> error while loading shared libraries: libnilfs.so.0: cannot open

I don't know the detail of NixOS, but the reason why nilfs_cleanerd
aborted looks to be in this environmental issue.

> shared object file: No such file or directory
> mount.nilfs2: Warning: cannot get pid of cleanerd

This message indicates mount.nilfs2 failed to receive pid
from nilfs_cleanerd.  It looks like nilfs_cleanerd aborted before
handing over the pid completes.

> mount.nilfs2: cannot modify /etc/mtab.
> Please remount the partition with -f option after making /etc/mtab
> writable.

Is /etc/mtab a symlink to /proc/self/mounts ?

If so, this mount.nilfs2 (NixOS distro package ?) looks to be
wrongly built.

There are two version with regards to mount.nilfs2, one uses /etc/mtab
and another uses libmount.  The latter doesn't rewrite /etc/mtab.

The latter version of mount.nilfs2 can be built with "--with-libmount"
configure option from the nilfs-utils source package.

 $ ./configure --with-libmount
 $ make

Regards,
Ryusuke Konishi

> 
> I am running NixOS 16.03
> 
> 'uname -r' gives:
> 4.4.14
> 
> Any ideas?
> 
> Thanks in advance.
> 
> Kind regards,
> 
> Mikael Andersson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
