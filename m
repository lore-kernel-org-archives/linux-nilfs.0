From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [GIT PULL] nilfs2 fix for 2.6.38
Date: Thu, 03 Mar 2011 21:16:22 +0900 (JST)
Message-ID: <20110303.211622.78542371.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

This will fix a reported regression leading a snapshot management
application to create meaningless snapshots endlessly.

Thanks,

Ryusuke Konishi
--
The following changes since commit dd9c1549edef02290edced639f67b54a25abbe0e:

  Linux 2.6.38-rc7 (2011-03-01 13:55:12 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Ryusuke Konishi (1):
      nilfs2: fix regression that i-flag is not set on changeless checkpoints

 fs/nilfs2/segment.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
