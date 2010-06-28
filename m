From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv2 0/3] nilfs2: support rollback of log scan
Date: Mon, 28 Jun 2010 19:15:23 +0900
Message-ID: <1277720126-13463-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

The former series does not apply to the latest "nilfs2: asynchronous
sb update" patchset.  This series fixes the issue.

changes from v1:
- rebased onto the v5 series of "nilfs2: asynchronous sb update"
- fix compilation error in load_nilfs()

Thanks,
Ryusuke Konishi
--
 fs/nilfs2/recovery.c  |    2 +
 fs/nilfs2/the_nilfs.c |   97 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 84 insertions(+), 15 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
