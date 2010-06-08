From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 0/2] nilfs2: asynchronous super block updates
Date: Wed,  9 Jun 2010 07:15:56 +0900
Message-ID: <1276035358-24284-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Hi,

This is revised patch series to update super block asynchronously.

First patch separates super block validity check from nilfs_commit_super,
and moved the function into callers.

Second patch introduces nilfs_write_log_cursor to advance log cursor
for one of super blocks.  This patch also define a macro that generates
inline function to update information both super blocks for convenience.


 fs/nilfs2/nilfs.h     |    2 +
 fs/nilfs2/segment.c   |    8 +--
 fs/nilfs2/super.c     |  144 ++++++++++++++++++++++++++++++++++---------------
 fs/nilfs2/the_nilfs.c |   11 +++-
 fs/nilfs2/the_nilfs.h |   23 +++++---
 5 files changed, 128 insertions(+), 60 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
