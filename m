From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] NILFS utils 2.1.4 release
Date: Fri, 06 Jul 2012 12:59:20 +0900 (JST)
Message-ID: <20120706.125920.169805378.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs-utils-2.1.4 was released on:

 http://www.nilfs.org/en/download.html

Main changes from nilfs-utils-2.1.3 are as follows:

 * umount.nilfs2: use binary exponential backoff for waiting for
   cleanerd's shutdown in order to speed up "umount".  Previously,
   umount.nilfs2 took one or more seconds.  This shortens the time to
   milli-seconds order.

 * mount.nilfs2: fix wrong error handling in a mount routine; this
   fixes the bug that "gcpid=" attribute was not updated properly in
   the mtab file when cleanerd restarted after a rw->ro or a rw->rw
   remount.  The bug was causing busy errors of successive unmount
   because of mismatch of the cleanerd's process id.

 * nilfs-resize: do not use sync() system call.  This reduces
   unnecessary disk io resulting from system-wide synchronizations.

 * nilfs-resize: fix early give-up of fs-shrinking.

 * mount.nilfs2 (non-libmount version): support context, fscontext,
   defcontext, and rootcontext SELinux mount options.  This feature is
   optional, which is applied only when "--with-selinux" new
   configuration option is specified.  Note that these options are
   already supported in another mount.nilfs2 using libmount.

Please see the following changelog for details:

 http://www.nilfs.org/download/ChangeLog-utils-v2


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
