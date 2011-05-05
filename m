From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/5] nilfs2 serveral cleanups for 2.6.40
Date: Thu,  5 May 2011 13:13:48 +0900
Message-ID: <1304568833-31021-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

These are cleanup patches for the next merge window, only internal
changes, and no enhancements are included.

Ryusuke Konishi
--
Ryusuke Konishi (5):
      nilfs2: use empty_aops for gc-inodes
      nilfs2: use list_first_entry
      nilfs2: get rid of NILFS_I_NILFS
      nilfs2: always set back pointer to host inode in mapping->host
      nilfs2: use mark_buffer_dirty to mark btnode or meta data dirty

 fs/nilfs2/alloc.c    |   12 ++++++------
 fs/nilfs2/bmap.c     |    4 +++-
 fs/nilfs2/btnode.c   |   19 +++++++------------
 fs/nilfs2/btnode.h   |    4 ----
 fs/nilfs2/btree.c    |   38 +++++++++++++++++++-------------------
 fs/nilfs2/cpfile.c   |   24 ++++++++++++------------
 fs/nilfs2/dat.c      |    4 ++--
 fs/nilfs2/gcinode.c  |   25 +++++++++----------------
 fs/nilfs2/ifile.c    |    4 ++--
 fs/nilfs2/inode.c    |   10 +++++-----
 fs/nilfs2/mdt.c      |    8 ++++----
 fs/nilfs2/mdt.h      |    9 +--------
 fs/nilfs2/nilfs.h    |    6 ------
 fs/nilfs2/page.c     |   26 +++++---------------------
 fs/nilfs2/page.h     |    3 +--
 fs/nilfs2/recovery.c |   12 ++++++------
 fs/nilfs2/segment.c  |   24 +++++++++---------------
 fs/nilfs2/sufile.c   |   26 +++++++++++++-------------
 fs/nilfs2/sufile.h   |    2 +-
 fs/nilfs2/super.c    |    2 +-
 20 files changed, 106 insertions(+), 156 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
