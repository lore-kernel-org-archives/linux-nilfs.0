From: Marco Stornelli <marco.stornelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/21 v3] drop vmtruncate
Date: Sat, 20 Oct 2012 14:14:39 +0200
Message-ID: <508295AF.60606@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        bh=Gjx/iQ8NFnwxjUB7IH3LQ+lZXZ9q9FjpbwKXd5zKwaU=;
        b=uQgJvEEqeY+JFSDArZJT7TDuW+gtEF/PKnG/T9KyI1e8tTxvu7QAz26hAfWKz1x8qu
         TTQUQPE1Tts+VckpRC3BzrxzFXo1rRo29iX83L9pk/PcD7pyEPMiCDx/r2Uht1A3Dd9E
         p3yhUNmQX88Ig+P5pDGlz2CsJoV3f7s23Wev6n3YzrJsV3eNRFn2V9sADhX1MUAmdCKG
         lcIqeRfWDXlX+vszqlt+/dxiYL+Vu+GwlVUk+EcWI8g6hNXdIw6GL7LMVGXWvy6uOc+d
         t5q2aNPwN7+YuEvILEWEMj4ZdcaP/Kpv/fwJvNXptanFRDujwRgYOCeSgdGBTmuyvgKj
         Hn6g==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Evgeniy Dushistov <dushistov-JGs/UdohzUI@public.gmane.org>, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bob Copeland <me-aXfl/3sk2vNUbtYUoyoikg@public.gmane.org>, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, "Tigran A. Aivazian" <tigran-ppwZ4lME3+KI6QP4U9MhSdBc4/FLrbF6@public.gmane.org>, Mikulas Patocka <mikulas-TTVWCEgN8Z9G4ohzP4jBZS1Fcj925eT/@public.gmane.org>, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org, Petr Vandrovec <petr-vPk2MGR0e28uaRcfnNAh7A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

I sent the third version of the patch series. After a couple of comments 
by Al and Christoph, now the patches are no more 1:1 replace of 
vmtruncate. A lot of inode_newsize_ok() and truncate_setsize() are now 
gone. For each fs, where needed, I wrote a new fs_write_failed() (as 
suggested by Al watching the ext2 code). The modifications are a bit 
deeper and they are *not* tested. I ask for comments to each fs 
maintainers. I hope the series can be pushed for 3.8.

Changes:
v3: reworked after Al and Christoph comments
v2: add documentation cleaning
v1: first draft

Marco Stornelli (21):
   ufs: drop vmtruncate
   sysv: drop vmtruncate
   reiserfs: drop vmtruncate
   procfs: drop vmtruncate
   omfs: drop vmtruncate
   ocfs2: drop vmtruncate
   adfs: drop vmtruncate
   affs: drop vmtruncate
   bfs: drop vmtruncate
   hfs: drop vmtruncate
   hpfs: drop vmtruncate
   jfs: drop vmtruncate
   hfsplus: drop vmtruncate
   logfs: drop vmtruncate
   minix: drop vmtruncate
   ncpfs: drop vmtruncate
   nilfs2: drop vmtruncate
   ntfs: drop vmtruncate
   vfs: drop vmtruncate
   mm: drop vmtruncate
   Documentation: drop vmtruncate

  Documentation/filesystems/Locking |    6 ------
  Documentation/filesystems/porting |    2 +-
  Documentation/filesystems/vfs.txt |   11 -----------
  fs/adfs/inode.c                   |   15 ++++++++++-----
  fs/affs/file.c                    |   18 ++++++++++++------
  fs/affs/inode.c                   |    5 ++++-
  fs/bfs/file.c                     |   15 ++++++++++-----
  fs/hfs/inode.c                    |   26 ++++++++++++++++++--------
  fs/hfsplus/inode.c                |   27 ++++++++++++++++-----------
  fs/hpfs/file.c                    |   18 ++++++++++++------
  fs/hpfs/inode.c                   |    5 ++++-
  fs/jfs/file.c                     |    6 ++++--
  fs/jfs/inode.c                    |   20 ++++++++++++++------
  fs/libfs.c                        |    2 --
  fs/logfs/readwrite.c              |   10 ++++++++--
  fs/minix/file.c                   |    6 ++++--
  fs/minix/inode.c                  |   17 ++++++++++++-----
  fs/ncpfs/inode.c                  |    4 +---
  fs/nilfs2/file.c                  |    1 -
  fs/nilfs2/inode.c                 |   24 +++++++++++++++---------
  fs/nilfs2/nilfs.h                 |    1 +
  fs/nilfs2/recovery.c              |    3 ++-
  fs/ntfs/file.c                    |   16 +++++++++++++---
  fs/ntfs/inode.c                   |    8 ++++++--
  fs/ntfs/inode.h                   |    4 ++++
  fs/ocfs2/file.c                   |   19 +------------------
  fs/omfs/file.c                    |   22 +++++++++++++++-------
  fs/proc/base.c                    |    3 ++-
  fs/proc/generic.c                 |    3 ++-
  fs/proc/proc_sysctl.c             |    3 ++-
  fs/reiserfs/file.c                |    3 +--
  fs/reiserfs/inode.c               |   15 +++++++++++----
  fs/reiserfs/reiserfs.h            |    1 +
  fs/sysv/file.c                    |    5 +++--
  fs/sysv/itree.c                   |   17 ++++++++++++-----
  fs/ufs/inode.c                    |   15 ++++++++++-----
  include/linux/fs.h                |    1 -
  include/linux/mm.h                |    1 -
  mm/truncate.c                     |   23 -----------------------
  39 files changed, 231 insertions(+), 170 deletions(-)

-- 
1.7.3.4
---

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
