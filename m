From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/2] nilfs2: Logging style changes
Date: Sun, 22 Mar 2020 09:38:09 -0700
Message-ID: <cover.1584894497.git.joe@perches.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Reduce object size and use more common kernel logging styles.

Joe Perches (2):
  nilfs2: Convert __nilfs_msg to integrate the level and format
  nilfs2: Use a more common logging style

 fs/nilfs2/alloc.c     | 38 +++++++++----------
 fs/nilfs2/btree.c     | 42 ++++++++++-----------
 fs/nilfs2/cpfile.c    | 10 ++---
 fs/nilfs2/dat.c       | 14 +++----
 fs/nilfs2/direct.c    | 14 ++++---
 fs/nilfs2/gcinode.c   |  2 +-
 fs/nilfs2/ifile.c     |  4 +-
 fs/nilfs2/inode.c     | 29 +++++++--------
 fs/nilfs2/ioctl.c     | 37 +++++++++----------
 fs/nilfs2/mdt.c       |  2 +-
 fs/nilfs2/namei.c     |  6 +--
 fs/nilfs2/nilfs.h     | 18 ++++++---
 fs/nilfs2/page.c      | 11 +++---
 fs/nilfs2/recovery.c  | 32 +++++++---------
 fs/nilfs2/segbuf.c    |  2 +-
 fs/nilfs2/segment.c   | 38 +++++++++----------
 fs/nilfs2/sufile.c    | 29 +++++++--------
 fs/nilfs2/super.c     | 73 +++++++++++++++++++------------------
 fs/nilfs2/sysfs.c     | 29 +++++++--------
 fs/nilfs2/the_nilfs.c | 85 ++++++++++++++++++++-----------------------
 20 files changed, 254 insertions(+), 261 deletions(-)

-- 
2.24.0

