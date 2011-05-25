From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/2] nilfs2: fix two long-standing bugs on btree block removal
Date: Thu, 26 May 2011 00:22:40 +0900
Message-ID: <1306336962-14030-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series fixes two long standing bugs related to block removal code
of nilfs2 btree.

The first patch fixes potential filesystem corruption after having
deleted block.  This may be a root cause of checkpoint file corruption
after garbage collection.

Another is a leak bug which doesn't terminate btree node block address
properly when shrinking a btree into a childless root node.  This one
is harmless except it chips away free disk space in the long run.

I'll send them upstream, and forward to stable if needed.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (2):
      nilfs2: fix incorrect block address termination in node concatenation
      nilfs2: fix missing block address termination in btree node shrinking

 fs/nilfs2/btree.c |   39 +++++++++++++++++++++++++++------------
 1 files changed, 27 insertions(+), 12 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
