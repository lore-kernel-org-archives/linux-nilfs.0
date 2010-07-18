From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/4] nilfs2 read ahead btree sibling nodes
Date: Sun, 18 Jul 2010 10:42:22 +0900
Message-ID: <1279417346-9688-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This series introduces readahead for btree lookup function and
mitigates read performance penalty that nilfs incurs on some devices.

As a result of performance analysis, I found access to btree node
blocks at leaf level slows down the speed of sequential read of file
data or directory.  Data blocks are already read ahead by Linux
pagecache code, and significant part of the penalty above seems to
come from the btree design and implementation of nilfs.

This patchset improves the implementation so that sibling nodes at the
lowest level of btrees are read ahead during continuous lookup of data
block addresses.

The following measurement results show the effect of this patchset for
dd read on a 512 Mega-bytes file:

  38.5 MB/s -> 67.0 MB/s  (a scsi hard drive)
  188 MB/s -> 200 MB/s (Intel SSD)

I will queue up this for the next merge window after some more tune
up.

Ryusuke Konishi
--
Ryusuke Konishi (4):
      nilfs2: add read ahead mode to nilfs_btnode_submit_block
      nilfs2: add btree get block function with readahead option
      nilfs2: introduce check flag to btree node buffer
      nilfs2: apply read-ahead for nilfs_btree_lookup_contig

 fs/nilfs2/btnode.c  |   17 +++++-
 fs/nilfs2/btnode.h  |    4 +-
 fs/nilfs2/btree.c   |  153 ++++++++++++++++++++++++++++++++++++--------------
 fs/nilfs2/gcinode.c |    6 +-
 fs/nilfs2/page.c    |    5 +-
 fs/nilfs2/page.h    |    2 +
 6 files changed, 136 insertions(+), 51 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
