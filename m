From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] nilfs kmod 2.0.22 released
Date: Sun, 19 Jun 2011 20:22:45 +0900 (JST)
Message-ID: <20110619.202245.239001349.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

I just released nilfs-2.0.22 kernel module and made it available at:

 http://www.nilfs.org/en/download.html

This is another release of standalone module for old kernels
(2.6.18~2.6.29), which is mainly intended for centos users.

It backported recent fixes and robustness enhancements including
rollback from the previous checkpoint with spare super block, and so
forth.

Users of the old kernel module are recommended to upgrade the old one
to this version.

For datails, see the changelog on:

 http://www.nilfs.org/download/ChangeLogv2


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
