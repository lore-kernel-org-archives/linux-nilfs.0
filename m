From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 0/2] nilfs2: asynchronous super block updates
Date: Sun,  6 Jun 2010 07:19:07 +0900
Message-ID: <1275776349-22820-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Hi,

These are patches to update super blocks in turns.

First patch separates super block validity check from nilfs_commit_super,
and moved the function into callers.

Second patch separates super block pointer updates from nilfs_commit_super.

Callers which intend to update super root pointer in super block must call
before calling nilfs_commit_super.  Now nilfs_commit_super replicates
the super block information except super root pointer information when
passed dupsb as non-0.  When dupsb is 0, nilfs_commit_super just clears
the dirty flag and calls nilfs_sync_super.

 fs/nilfs2/nilfs.h     |    2 +
 fs/nilfs2/segment.c   |    8 +++-
 fs/nilfs2/super.c     |   98 +++++++++++++++++++++++++++++++++++++++----------
 fs/nilfs2/the_nilfs.c |    9 +++-
 4 files changed, 92 insertions(+), 25 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
