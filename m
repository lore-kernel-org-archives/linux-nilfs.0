From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/3] nilfs2: support rollback of log scan
Date: Fri, 25 Jun 2010 01:38:36 +0900
Message-ID: <1277397519-6715-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This series adds fallback feature between two super blocks in terms of
search of valid super root during mount.

Although nilfs redundantly uses two super blocks and each may point to
different position on log, the current version of nilfs does not try
fallback to the spare super block when it doesn't find any valid log
at the position that newer super block points to.

This is because such inconsistent situtation will not happen if
underlying block device properly implements barrier semantics, but in
reality, problems have been reported.

The recent series posted by Jiro SEKIBA, changes writeback of super
blocks so that they will be written to the disk in turns to resolve
this issue.  This series complements his work.

The core change appears in the third patch "nilfs2: implement fallback
for super root search", and others are for its preparation.

I will queue these along with Jiro-san's patch set.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (3):
      nilfs2: separate setup of log cursor from init_nilfs
      nilfs2: add missing error code in comment of nilfs_search_super_root
      nilfs2: implement fallback for super root search

 fs/nilfs2/recovery.c  |    2 +
 fs/nilfs2/the_nilfs.c |   97 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 84 insertions(+), 15 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
