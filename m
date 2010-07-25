From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/2] nilfs2 fix overflow of directory record size with 64KB block size
Date: Mon, 26 Jul 2010 01:00:06 +0900
Message-ID: <1280073608-17772-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This series fixes an overflow issue in directory design against 64KB
block size, which originally comes from the ext2 filesystem.  I took
the same correction with ext2 (or ext3).

By the second patch, a filesystem with unsupproted block size will get
rejected by predefined values in addition to the past sanity checks
related to hardware limitation.

The first patch has an impact on disk format compatibility for 64KB
block size, but this is inevitable to avoid the defect.

For most people, I believe this is NOT a problem because block size is
limited by page size, and it is mostly 4KB on popular architectures.

However, I think this is one of issues that must be resolved while we
have a chance.

Ryusuke Konishi
--
Ryusuke Konishi (2):
      nilfs2: avoid rec_len overflow with 64KB block size
      nilfs2: reject filesystem with unsupported block size

 fs/nilfs2/dir.c           |   26 ++++++++++++++------------
 fs/nilfs2/the_nilfs.c     |    9 ++++++++-
 include/linux/nilfs2_fs.h |   26 +++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 14 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
