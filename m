From: Marco Stornelli <marco.stornelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/21 v4] drop vmtruncate
Date: Sat, 03 Nov 2012 10:21:29 +0100
Message-ID: <5094E219.5020009@gmail.com>
References: <508295AF.60606@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=DfXqSMgDEUrK09JzPWL1oEuQEcUK7JyR2Ou6t0TKMSM=;
        b=rf2vuw10yhgHEhHbPbLpg+fjW+zLpoJPAUwFf9SD6nfpex5BaD0hgUQMq3Gw8zfPgJ
         rMYTBBoX+pvNRFsc8I4zuo2yg9IyeT2h5tkW209GfAOPhoyaOVWixbmapRv05e1zQecT
         5EHOJsOHDI+cjZ3ftKqjJdZKwOzLcC5q88v6aUpjRAT0a86q6rYlZ1XV4um3jgTxzmAA
         ilOOSjl26ipsYaMMWaKapeh5qWAfDGnbuYGBDcLrlaPcXBfGO5+u6C2d2KXmELK4Gl2U
         XUN3mA+BSIk/izlDgyYu66NBrp+zLeK9k8ioZWkRJlGO7HAn725zpLZjHjIOm43+zSiM
         ERjg==
In-Reply-To: <508295AF.60606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Evgeniy Dushistov <dushistov-JGs/UdohzUI@public.gmane.org>, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bob Copeland <me-aXfl/3sk2vNUbtYUoyoikg@public.gmane.org>, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, "Tigran A. Aivazian" <tigran-ppwZ4lME3+KI6QP4U9MhSdBc4/FLrbF6@public.gmane.org>, Mikulas Patocka <mikulas-TTVWCEgN8Z9G4ohzP4jBZS1Fcj925eT/@public.gmane.org>, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org, Petr Vandrovec <petr-vPk2MGR0e28uaRcfnNAh7A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

I send the fourth patch series to remove vmtruncate. Any 
comments/feedback are welcome.

Changes:
v4: fix an error for ocfs2, silently ignore truncate for procfs as 
suggested by Al
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
   documentation: drop vmtruncate

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
  fs/ocfs2/file.c                   |   18 ------------------
  fs/omfs/file.c                    |   22 +++++++++++++++-------
  fs/proc/base.c                    |    7 -------
  fs/proc/generic.c                 |    9 +--------
  fs/proc/proc_sysctl.c             |    7 -------
  fs/reiserfs/file.c                |    3 +--
  fs/reiserfs/inode.c               |   15 +++++++++++----
  fs/reiserfs/reiserfs.h            |    1 +
  fs/sysv/file.c                    |    5 +++--
  fs/sysv/itree.c                   |   17 ++++++++++++-----
  fs/ufs/inode.c                    |   15 ++++++++++-----
  include/linux/fs.h                |    1 -
  include/linux/mm.h                |    1 -
  mm/truncate.c                     |   23 -----------------------
  39 files changed, 225 insertions(+), 189 deletions(-)

-- 
1.7.3.4
---
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
