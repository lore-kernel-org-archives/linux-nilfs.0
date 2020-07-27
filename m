From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] nilfs2 updates
Date: Mon, 27 Jul 2020 23:28:28 +0900
Message-ID: <1595860111-3920-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HabJRMADlao94yEJSHvnaFVFEzocZspVEhiAVrZ3aoQ=;
        b=EiK/d5uDMNQE9vA1GyKcPJPFxOOm+RbyqY0iYHtKHqhk2ffuujz6UNYW1/cqPpvYfZ
         gU3F5MFFPtqU45FZKE/tg/H+j0MXV8L2UjDlzTaP3cpzOjc3r7cGwTO56lSda8fexDMO
         9mLL/KhNY7Kb+TgTsMa9JWKbCS6fu7VZs5kX+QjdvZw9VVIl15AlmcQ4p6ogFq97gSV5
         BvDtJZ8s99qTPau/B1aB/B52LMH5VkipFeRkIutLMCh5v6fb1UnhXy8RfFBjnveTEnNH
         moDN1EA2OOV4ZKxnOjV30eZi57X0aQD5TvGToA97VmyjJzFHZH/Ca/jvsAVMeLu/6W6j
         WvXw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Andrew,

Please queue the following changes for the next merge window:

Eric Biggers (1):
  nilfs2: only call unlock_new_inode() if I_NEW

Joe Perches (2):
  nilfs2: Convert __nilfs_msg to integrate the level and format
  nilfs2: Use a more common logging style

In this series,

>  nilfs2: only call unlock_new_inode() if I_NEW

fixes wrong unlock_new_inode() call and related WARNING which can be
triggered from error paths of nilfs_new_inode().

>  nilfs2: Convert __nilfs_msg to integrate the level and format
>  nilfs2: Use a more common logging style

reduce object size and use more common kernel logging styles.

Thanks,
Ryusuke Konishi
--
 fs/nilfs2/alloc.c     | 38 +++++++++++------------
 fs/nilfs2/btree.c     | 42 ++++++++++++-------------
 fs/nilfs2/cpfile.c    | 10 +++---
 fs/nilfs2/dat.c       | 14 ++++-----
 fs/nilfs2/direct.c    | 14 +++++----
 fs/nilfs2/gcinode.c   |  2 +-
 fs/nilfs2/ifile.c     |  4 +--
 fs/nilfs2/inode.c     | 32 +++++++++----------
 fs/nilfs2/ioctl.c     | 37 +++++++++++-----------
 fs/nilfs2/mdt.c       |  2 +-
 fs/nilfs2/namei.c     |  6 ++--
 fs/nilfs2/nilfs.h     | 18 ++++++++---
 fs/nilfs2/page.c      | 11 +++----
 fs/nilfs2/recovery.c  | 32 +++++++++----------
 fs/nilfs2/segbuf.c    |  2 +-
 fs/nilfs2/segment.c   | 38 +++++++++++------------
 fs/nilfs2/sufile.c    | 29 ++++++++----------
 fs/nilfs2/super.c     | 73 ++++++++++++++++++++++---------------------
 fs/nilfs2/sysfs.c     | 29 ++++++++----------
 fs/nilfs2/the_nilfs.c | 85 ++++++++++++++++++++++++---------------------------
 20 files changed, 256 insertions(+), 262 deletions(-)

-- 
1.8.3.1

