From: Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org>
Subject: ifile is broken
Date: Tue, 21 Sep 2010 11:23:13 +0200
Message-ID: <AANLkTin1CT82ou1odPRYCDVZSNZGP-wBRG3xKifHqWHt@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:sender:received:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        bh=ctt1cEUP9cGc9/Y2F8TiExdDfyj1rbEcmbYfKfrA0QA=;
        b=XYi7GIiOJa6kT22bVkTFlFGBsn9a0CXepOoW34dIJapTU9FX4+/pAFabCjsMxyxp7x
         16EXQzR7scy5GAA9WSZlbpvmipWPcBnU1B2g8M93p5BHZAMPaCLw5fsqwFWf5S68Seco
         eX3ouzhDq4rCeoDRS5AfvGBuSBrgOpNobTDYA=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
I'm using NILFS2 as root filesystem (it's on /dev/sda2, only /boot was
apart on an EXT2 /dev/sda1, if I recall correctly) on my Archlinux
(with Linux 2.6.35.4 and nilfs-utils 2.0.19).
I got to manually run nilfs_cleanerd anytime I boot (read somewhere
it's because my /usr is on NILFS2 as well).
Yesterday, by mistake, I ran nilfs_cleanerd twice. Shut the system as
soon as I realized but now it's not booting anymore: a kernel oops
gets printed...

Waiting 10 seconds for device /dev/sda2 ...
attempt to access beyond end of device
sda2: rw=16, want=4283850835945523848, limit=15695505
Pid :1, comm: init Not tainted 2.6.35-ARCH #1
Call Trace:
*snip*
NILFS: btree level mismatch: 68 != 1
NILFS error (device sda2): nilfs_ifile_get_inode_block: ifile is broken
ERROR: Root device mounted successfully, but /sbin/init does not exist.
Bailing out, you are on your own. Good luck.

/dev/sda2 gets mounted anyway on ramfs' /new_root, but if I try to
access most of its subdirectories more kernel oops appear, and only
very few files are shown. My home dir is completely gone.

So, uh, other than pointing out this bug (I guess a second
nilfs_cleanerd should just quit, not shred your system...) I'd like to
know if there's any way to get my data back... I'll backup (through
dd) my whole /dev/sda (it's an 8GB SD) hoping to be able to recover it
soon...

Thanks,
Paolo.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
