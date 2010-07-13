From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/5] nilfs2 btree tweaks
Date: Tue, 13 Jul 2010 23:33:50 +0900
Message-ID: <1279031635-6717-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series gives additional refactoring and tweaks on the btree code.

The "nilfs2: optimize calculation of min/max number of btree node
children" and "nilfs2: reduce repetitive calculation of max number of
child nodes" and "nilfs2: get maximum number of child nodes from bmap
object" reduce repetitive calculation on maximum number of child
nodes, and revise parameter passing in low level routines of the btree
code.  Other two changes are for cleanups.

I'm now reviewing the btree code, and this is a by-product of the
work.

Ryusuke Konishi
--
Ryusuke Konishi (5):
      nilfs2: remove redundant pointer checks in bmap lookup functions
      nilfs2: optimize calculation of min/max number of btree node children
      nilfs2: reduce repetitive calculation of max number of child nodes
      nilfs2: get maximum number of child nodes from bmap object
      nilfs2: eliminate inline keywords in btree implementation

 fs/nilfs2/bmap.h   |    2 +
 fs/nilfs2/btree.c  |  412 +++++++++++++++++++++++++++-------------------------
 fs/nilfs2/direct.c |    3 +-
 3 files changed, 220 insertions(+), 197 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
