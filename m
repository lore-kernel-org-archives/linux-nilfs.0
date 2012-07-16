From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/2] NILFS2: add omitted comments for structures
Date: Mon, 16 Jul 2012 23:51:23 +0400
Message-ID: <6BEB7CF8-EFA5-4559-9054-159807A2B067@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=S6avAgmEvNkZsQTR7xQEDyVp9hB0NjOtR5PJTEuzxCc=;
	b=cxWi6NzoR4NFvJy1QU9M06y2l1PqLhLIv+z97WiFJEkTDcbPfTZueRiWpsgx47D815QDy0JvCyiHh4KQSAXCvIb/fnyhZ464qkIvrV5p0/lLA2MWWDL9cZTQlYioUwsR;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

This patchset adds omitted comments for different structures in NILFS file system driver.

With the best regards,
Vyacheslav Dubeyko.
--
 fs/nilfs2/alloc.h         |   12 +++++++-
 fs/nilfs2/bmap.h          |    7 +++++
 fs/nilfs2/btnode.h        |    8 +++++-
 fs/nilfs2/dat.c           |    6 ++++
 fs/nilfs2/export.h        |    8 +++++
 fs/nilfs2/ifile.c         |    6 +++-
 fs/nilfs2/inode.c         |    7 +++++
 fs/nilfs2/mdt.h           |    7 +++++
 fs/nilfs2/nilfs.h         |   15 ++++++++++-
 fs/nilfs2/sufile.c        |    8 +++++-
 fs/nilfs2/the_nilfs.h     |    1 -
 include/linux/nilfs2_fs.h |   63 +++++++++++++++++++++++++++-----------------
 12 files changed, 117 insertions(+), 31 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
