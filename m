From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] nilfs2: add detailed comment about description of  DAT
 meta-data file's blocks in on-disk segment summary
Date: Thu, 24 May 2012 16:22:03 +0400
Message-ID: <1337862123.2628.32.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:To:From:Subject; bh=Ba+mmUkgc7CQlvjoquvh8M4G0Je3EkCJuuinQ+AHfek=;
	b=jdJX07LgMpoHrZT91hrTOS0ZieEmmNaLguUX0ZJomauxJNIP99lArmMoMKi2lqCf4m8XVYziJv0OM/2RwAYRxbizLEL8ZvbmDxzJriJgaU+lXPffkz5nc7pWuU+/+1pI;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I suggest to add comment with more details about description of data and
b-tree intermediate blocks of the DAT meta-data file in on-disk segment
summary. I think that absence of such comment can lead to
misunderstanding of segment summary's on-disk layout.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] nilfs2: add detailed comment about description of
DAT meta-data file's blocks in on-disk segment summary

This patch adds comment with more details about description of data and
b-tree intermediate blocks of the DAT meta-data file in on-disk segment
summary.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/nilfs2_fs.h |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 655213e..630f550 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -372,7 +372,18 @@ struct nilfs_binfo_v {
 };
 
 /**
- * struct nilfs_binfo_dat - information for the block which belongs to
the DAT file
+ * Description of DAT meta-data file's blocks is a special case of
segment summary.
+ * The description can contain as data blocks as b-tree intermediate
blocks.
+ * The whole number of blocks (including intermediate blocks) is
described
+ * by fi_nblocks field of nilfs_finfo structure. The fi_ndatablk field
keeps
+ * count of data blocks. Firstly, it is described data blocks by means
of
+ * 64-bit block offset number (__le64) which is allocated per block.
+ * Finally, b-tree intermediate blocks are described by nilfs_binfo_dat
+ * structure which is allocated per block.
+ */
+
+/**
+ * struct nilfs_binfo_dat - information for b-tree intermediate block
of the DAT meta-data file
  * @bi_blkoff: block offset
  * @bi_level: level
  * @bi_pad: padding
--


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
