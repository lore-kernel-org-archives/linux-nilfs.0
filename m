From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv4 0/2] nilfs2: asynchronous sb update
Date: Fri, 25 Jun 2010 00:27:38 +0900
Message-ID: <1277393260-19835-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, ryusuke-sG5X7nlA6pw@public.gmane.org, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Hi,

This is v4 patch series to update super block asynchronously.

First patch separates super block validity check from nilfs_commit_super,
and moved the function into callers.

Second patch introduces swapping code in nilfs_prepare_super.
Caller of the function must specify whether swapping super blocks or not
explicitly.  To advance log pointer, the caller uses nilfs_set_log_cursor
to advance specified super block after calling nilfs_prepare_super.

changes from v3
- move swapping code to nilfs_prepare_super from nilfs_sync_super
- check last_cno of super blocks to advance protection period
- introduce nilfs_sb_need_swap function

changes from v2
- restore super block in nilfs_prepare_super
- introduce nilfs_set_error
 * used in nilfs_error
- introduce nilfs_set_log_cursor instead of write_log_cursor
 * instead of writing error, set log cursor to specified sb pointer
 * used followed by nilfs_commit_super
- introduce ns_sbwcount
 * swap super blocks based on the counter
 * swap all most all the time, still asymmetric(9:7 ratio)
- delete ns_sbwtime[2]
 * introduce ns_sbwtime instead of array of both super blocks
- synchronize super blocks when mount/remount
- abandon NILFS_SB_SET_FN
 * only used in nilfs_set_error, so assign directly in the function
- misc style fix
- misc comment fix

changes from v1
- change macro name NILFS_SUPER_SET_FN -> NILFS_SB_SET_FN
 * change inline function name as nilfs_sb_set_##name
- introduce enum for nilfs_commit_super and nilfs_sync_super
 * NILFS_SB_COMMIT and NILFS_SB_COMMIT_ALL
 * use flag instead of dupsb in nilfs_commit_super/sync_super

 fs/nilfs2/nilfs.h     |   12 +++
 fs/nilfs2/segment.c   |   10 ++-
 fs/nilfs2/super.c     |  182 ++++++++++++++++++++++++++++++++++---------------
 fs/nilfs2/the_nilfs.c |   17 +++--
 fs/nilfs2/the_nilfs.h |   17 ++---
 5 files changed, 166 insertions(+), 72 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
