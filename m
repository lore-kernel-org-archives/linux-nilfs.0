From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH v2 0/2] nilfs2: super root block fixes
Date: Sat, 30 Apr 2011 20:11:49 +0900
Message-ID: <1304161911-12046-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This is a revised patch set which fixes minor issues on write routines
of super root block.  The first patch properly sets size of super root
structure in ->sr_bytes field depending on inode size.  The second
patch zero fills unused portion of super root block and prevents
random data from running into there.

Thanks,
Ryusuke Konishi
---
Ryusuke Konishi (2):
      nilfs2: super root size should change depending on inode size
      nilfs2: zero fill unused portion of super root block

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
