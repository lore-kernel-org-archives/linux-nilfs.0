From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/6] nilfs2 cleanups
Date: Mon, 27 Dec 2010 01:02:36 +0900
Message-ID: <1293379362-3340-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Here are some changes for cleanup purpose for the merge window.

I have more cleanup patches that will eliminate nilfs_sb_info
structure and reduce the number of indirect memory accesses to core
nilfs structure.  But, I will skip them for now since they make a bit
more changes.

Ryusuke Konishi
--
Ryusuke Konishi (6):
      nilfs2: fix a checkpatch error in page.c
      nilfs2: get rid of loaded flag from nilfs object
      nilfs2: simplify nilfs_mdt_freeze_buffer
      nilfs2: get rid of nilfs_mount_options structure
      nilfs2: do not pass sbi to functions which can get it from inode
      nilfs2: unfold nilfs_dat_inode function

 fs/nilfs2/bmap.c      |    2 +-
 fs/nilfs2/btnode.c    |    3 +--
 fs/nilfs2/dir.c       |    3 +--
 fs/nilfs2/inode.c     |   29 +++++++++++++----------------
 fs/nilfs2/ioctl.c     |   12 +++++-------
 fs/nilfs2/mdt.c       |   26 ++++++++++++--------------
 fs/nilfs2/nilfs.h     |   11 ++---------
 fs/nilfs2/page.c      |    2 +-
 fs/nilfs2/recovery.c  |    2 +-
 fs/nilfs2/sb.h        |    8 --------
 fs/nilfs2/segment.c   |   11 +++++------
 fs/nilfs2/super.c     |    6 +++---
 fs/nilfs2/the_nilfs.c |    6 ++----
 fs/nilfs2/the_nilfs.h |    3 ---
 14 files changed, 47 insertions(+), 77 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
