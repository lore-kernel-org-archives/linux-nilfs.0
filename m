From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/6] nilfs2 bmap cleanups
Date: Sun, 11 Jul 2010 00:01:48 +0900
Message-ID: <1278774114-17917-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series cleans up block mapping code.

The "nilfs2: get rid of private conversion macros on bmap key and
pointer" unfolds some conversion macros for simplicity.

Other changes are for unifying four similar structures and union
around the block mapping layer, i.e nilfs_bmap, nilfs_btree, nilfs_direct,
and nilfs_bmap_union.  These patches allow removal of
nilfs_bmap_union.h file and eliminate pointer casts among these
structures.

Ryusuke Konishi
--
Ryusuke Konishi (6):
      nilfs2: get rid of private conversion macros on bmap key and pointer
      nilfs2: remove constant qualifier from argument of bmap propagate
      nilfs2: get rid of nilfs_direct uses
      nilfs2: get rid of nilfs_btree uses
      nilfs2: unify bmap set_target_v operations
      nilfs2: get rid of nilfs_bmap_union

 fs/nilfs2/bmap.c       |    6 +-
 fs/nilfs2/bmap.h       |   14 +-
 fs/nilfs2/bmap_union.h |   42 ------
 fs/nilfs2/btree.c      |  355 +++++++++++++++++++++---------------------------
 fs/nilfs2/btree.h      |   10 +--
 fs/nilfs2/direct.c     |   93 +++++--------
 fs/nilfs2/direct.h     |   11 --
 fs/nilfs2/gcinode.c    |    2 +
 fs/nilfs2/mdt.c        |    1 +
 fs/nilfs2/nilfs.h      |    7 +-
 fs/nilfs2/super.c      |    4 +-
 11 files changed, 212 insertions(+), 333 deletions(-)
 delete mode 100644 fs/nilfs2/bmap_union.h

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
