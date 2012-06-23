From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] NILFS utils 2.1.3 release
Date: Sat, 23 Jun 2012 22:37:12 +0900 (JST)
Message-ID: <20120623.223712.37575656.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs-utils-2.1.3 was released on:

 http://www.nilfs.org/en/download.html

This is a maintenance release of nilfs-utils-2.1.  Main
changes from nilfs-utils-2.1.2 are as follows:

 * mount.nilfs2 (non libmount version): fix problems related
   to /etc/mtab by importing bug fixes from util-linux.

 * livnilfsgc: try the last hit snapshot number first in
   live/dead determination of disk blocks in order to reduce
   its overhead for numerous snapshots.

 * nilfs_cleanerd: fix an early-termination issue of one
   pass GC kicked by nilfs-clean.

Please see the following changelog for details:

 http://www.nilfs.org/download/ChangeLog-utils-v2


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
