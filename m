From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/3] a few nilfs2 cleanups for 2.6.34
Date: Wed, 10 Feb 2010 00:46:20 +0900
Message-ID: <1265730383-31290-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This is a series of cleanups toward the next merge window.

The "nilfs2: get rid of nilfs_segctor_req struct" and the "nilfs2:
move iterator to write log into segment buffer" correct log writer a
bit for further revision.

The "nilfs2: get rid of s_dirt flag use" stops using the sop->s_dirt
flag which became obsolete in nilfs by the removal of
nilfs_write_super.

Ryusuke Konishi
--
Ryusuke Konishi (3):
      nilfs2: get rid of nilfs_segctor_req struct
      nilfs2: get rid of s_dirt flag use
      nilfs2: move iterator to write log into segment buffer

 fs/nilfs2/segbuf.c    |   18 +++++++++
 fs/nilfs2/segbuf.h    |    5 +--
 fs/nilfs2/segment.c   |   99 ++++++++++++++++++++++--------------------------
 fs/nilfs2/segment.h   |    2 +
 fs/nilfs2/super.c     |    4 +-
 fs/nilfs2/the_nilfs.h |    2 +
 6 files changed, 70 insertions(+), 60 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
