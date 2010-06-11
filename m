From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 0/2v2] nilfs2: asynchronous super block updates
Date: Fri, 11 Jun 2010 23:30:37 +0900
Message-ID: <1276266639-15913-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Hi,

This is re-revised patch series to update super block asynchronously.

First patch separates super block validity check from nilfs_commit_super,
and moved the function into callers.

Second patch introduces nilfs_write_log_cursor to advance log cursor
for one of super blocks.  This patch also define a macro that generates
inline function to update information both super blocks for convenience.

diffs aganist previous set are
- change macro name NILFS_SUPER_SET_FN -> NILFS_SB_SET_FN
 * change inline function name as nilfs_sb_set_##name
- introduce enum for nilfs_commit_super and nilfs_sync_super
 * NILFS_SB_COMMIT and NILFS_SB_COMMIT_ALL
 * use flag instead of dupsb in nilfs_commit_super/sync_super

 fs/nilfs2/nilfs.h     |    6 ++
 fs/nilfs2/segment.c   |    8 +--
 fs/nilfs2/super.c     |  155 ++++++++++++++++++++++++++++++++++---------------
 fs/nilfs2/the_nilfs.c |   11 +++-
 fs/nilfs2/the_nilfs.h |   23 +++++---
 5 files changed, 138 insertions(+), 65 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
