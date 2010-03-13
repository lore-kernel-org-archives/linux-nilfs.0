From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS 2.0.19 and NILFS utils 2.0.16 released
Date: Sat, 13 Mar 2010 15:06:12 +0900 (JST)
Message-ID: <20100313.150612.265919879.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I have released nilfs-2.0.19 and nilfs-utils-2.0.16.

nilfs-2.0.19 is the latest standalone module maintained for older
kernels.  This release backported several bug fixes and some
problem-solving updates from the mainline kernel; the following
changes are included:

 * fix potential hang in nilfs_error on errors=remount-ro
 * add missing reader's lock in nilfs_ioctl_sync
 * fix potential leak of dirty data on umount
 * show missing mount options in /proc/mounts.
 * change mount option to disable write barriers; "nobarrier" is
   used instead of "barrier=off".
 * add "norecovery" mount option
 * use mnt_want_write in ioctls where write access is needed
 * apply readahead for recovery on mount
 * sync superblock by nilfs thread instead of periodic write_super
   callback
 * update mailing list address
 * coding style fixes

The changes of nilfs-utils include manpage updates, a build fix for
newer glibc, and a mount option to set protection_period.

The updated packages are available at

 http://www.nilfs.org/en/download.html

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
