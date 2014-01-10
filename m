From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH 2/4] nilfs-utils: add xafile_init and
 xafile_exist flags support
Date: Fri, 10 Jan 2014 16:11:20 +0400
Message-ID: <1389355880.3938.143.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=TdnKQU0UiQO7TOcdPgwDd94BG9Bjh4yEFed2DxukyUE=;
	b=Legd+16rwgIhpP4CC8+J/R/pcpUA0GYyjGR1Cof442/PDIo9FC4c1hN+A0+cS789rBVPux0SO62PMpo2TBbiIe2/G8CTuKVmbT0AalZNpzqYopTUGZhEYlRCp9EEfrxi;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH 2/4] nilfs-utils: add xafile_init and xafile_exist flags support

This patch implements support of NILFS_FEATURE_COMPAT_INIT_XAFILE
and NILFS_FEATURE_COMPAT_RO_XAFILE flags support in functionality
of feature set routines.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/feature.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/feature.c b/lib/feature.c
index b3317b7..d3bef8f 100644
--- a/lib/feature.c
+++ b/lib/feature.c
@@ -55,9 +55,13 @@ struct nilfs_feature {
 
 static const struct nilfs_feature features[] = {
 	/* Compat features */
+	{ NILFS_FEATURE_TYPE_COMPAT,
+	  NILFS_FEATURE_COMPAT_INIT_XAFILE, "xafile_init" },
 	/* Read-only compat features */
 	{ NILFS_FEATURE_TYPE_COMPAT_RO,
 	  NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT, "block_count" },
+	{ NILFS_FEATURE_TYPE_COMPAT_RO,
+	  NILFS_FEATURE_COMPAT_RO_XAFILE, "xafile_exist" },
 	/* Incompat features */
 	/* End */
 	{ 0, 0, NULL }
@@ -221,6 +225,7 @@ int nilfs_edit_feature(const char *str, __u64 *compat_array,
 		}
 
 		if (nilfs_string2feature(cp, &type, &mask) < 0) {
+			errno = ENODATA;
 			ret = -1;
 			break;
 		}
@@ -231,6 +236,7 @@ int nilfs_edit_feature(const char *str, __u64 *compat_array,
 						NILFS_FEATURE_TYPE_NEGATE_FLAG;
 				if (bad_mask)
 					*bad_mask = mask;
+				errno = EINVAL;
 				ret = -1;
 				break;
 			}
@@ -241,6 +247,7 @@ int nilfs_edit_feature(const char *str, __u64 *compat_array,
 					*bad_type = type;
 				if (bad_mask)
 					*bad_mask = mask;
+				errno = EINVAL;
 				ret = -1;
 				break;
 			}
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
