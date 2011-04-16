From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] NILFS utils 2.0.22 released
Date: Sat, 16 Apr 2011 14:16:23 +0900 (JST)
Message-ID: <20110416.141623.213622230.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi folks,

nilfs-utils-2.0.22 is now available at:

  http://www.nilfs.org/en/download.html

This release eliminated the need for .nilfs file and supported `block
count per checkpoint' feature which will become available on the
upcoming kernel (2.6.39).

mkfs.nilfs2 still creates the .nilfs file, but the cleaner daemon and
other nilfs tools no longer require it.  This resolves problems that
occurs on the partitions where .nilfs was deleted, especially a stuck
problem on a disk full condition.

See changelog ( http://www.nilfs.org/download/ChangeLog-utils-v2 )
for details.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
