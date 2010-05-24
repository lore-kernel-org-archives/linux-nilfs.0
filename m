From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/6] nilfs2: refactor recovery code
Date: Tue, 25 May 2010 01:39:03 +0900
Message-ID: <1274719149-24371-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This is a series of cleanups that should come before discussed changes
to improve robustness of mount, disk usage on osync writes, and to
minimize update frequency of super blocks, and so forth.

We are now in the merge window for the 2.6.35 kernel, so this and the
planned changes will not be sent upstream until some time later.

But, I'd like to do this now, to shift our focus to the subsequent
work early.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (6):
      nilfs2: add blocksize member to nilfs object
      nilfs2: refactor recovery logic routines
      nilfs2: rename nilfs_recover_logical_segments function
      nilfs2: divide load_segment_summary function
      nilfs2: do not use nilfs_segsum_info structure in recovery code
      nilfs2: get rid of macros for segment summary information

 fs/nilfs2/recovery.c  |  350 +++++++++++++++++++++++++++----------------------
 fs/nilfs2/segbuf.h    |   24 ++--
 fs/nilfs2/segment.c   |    8 +-
 fs/nilfs2/segment.h   |   10 +-
 fs/nilfs2/the_nilfs.c |   12 +-
 fs/nilfs2/the_nilfs.h |    2 +
 6 files changed, 224 insertions(+), 182 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
