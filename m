From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv5 0/5] nilfs2: asynchronous sb update
Date: Mon, 28 Jun 2010 17:49:28 +0900
Message-ID: <1277714973-12136-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This is v5 revision of the series that makes super block writeback
alternately.  This series is originally written by Jiro SEKIBA, and I
revised it to resolve some issues and to simplify the core change by
improving the patch organization.

changes from v5:
- fix missing endian conversion for s_last_cno.
- fix issue that nilfs_sync_super never updates ns_prot_seq when
  NILFS_SB_COMMIT is specified.
- rename "nilfs_sb_need_swap" to "nilfs_sb_will_flip" to avoid confusion.
- separate patch to add nilfs_cleanup_super, which writes out
  filesystem state for cleanup.
- separate patch to add nilfs_set_error, which sets error state
  on the filesystem.
- separate patch to add nilfs_set_log_cursor, which advances log
  pointer.

I hope this will help to settle the confusion and move things forward.

 fs/nilfs2/nilfs.h     |   13 +++
 fs/nilfs2/segment.c   |   10 ++-
 fs/nilfs2/super.c     |  216 ++++++++++++++++++++++++++++++++++---------------
 fs/nilfs2/the_nilfs.c |    9 +-
 fs/nilfs2/the_nilfs.h |   17 ++--
 5 files changed, 183 insertions(+), 82 deletions(-)

Regards,
Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
