From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH 4/4] nilfs-utils: nilfs-tune: implement
 functionality of xafile initialization
Date: Fri, 10 Jan 2014 16:11:41 +0400
Message-ID: <1389355901.3938.145.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=OM6ZoYUAbf+Fk7pqFkS07wBQn3qRKu4fX2oFucpHb4o=;
	b=KqDi3tE5Q3sbWOXpNfffpQyEN/saX6pSJUO9X0WJR6uyXxHZUzMNv4jV35HjDmMSFc4dtqR00eId0TewRTSmoO+PE/4JJuJy3ECkuL7dm7jjXnfK0jqW/is7dKgx5FJm;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH 4/4] nilfs-utils: nilfs-tune: implement functionality of xafile initialization

This patch implements functionality of request xafile creation
on existed NILFS2 volume by means of nilfs-tune utility.

The nilfs-tune utility simply modify superblock of such volume by
means of setting NILFS_FEATURE_COMPAT_INIT_XAFILE in
s_feature_compat field of superblock. Then, file system driver
creates xafile in the case of presence above-mentioned flag
(NILFS_FEATURE_COMPAT_INIT_XAFILE).

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/nilfs-tune.8             |    9 +++++++++
 sbin/nilfs-tune/nilfs-tune.c |   20 ++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/man/nilfs-tune.8 b/man/nilfs-tune.8
index 47dc1b3..e0ed198 100644
--- a/man/nilfs-tune.8
+++ b/man/nilfs-tune.8
@@ -52,6 +52,15 @@ Enable block count per checkpoint.
 After setting this option, fsck should be run on the filesystem to
 make the counts right, but no fsck tool is available yet, sorry.
 .RE
+.RS
+.TP
+.B xafile_init
+Enable xafile creation (if it doesn't exist).
+After setting this option, superblock will keep flag that it requests
+xafile creation. Creation request will fail if a NILFS2 volume contains
+xafile yet. The xafile will be created during nearest operation of
+segment creation.
+.RE
 .TP
 .B \-U \fIUUID\fP
 Set the universally unique identifier (UUID) of the file system to UUID.
diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
index 0698649..bc70681 100644
--- a/sbin/nilfs-tune/nilfs-tune.c
+++ b/sbin/nilfs-tune/nilfs-tune.c
@@ -84,7 +84,7 @@ static void nilfs_tune_usage(void)
 
 const static __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
-	0,
+	NILFS_FEATURE_COMPAT_INIT_XAFILE,
 	/* Read-only compat */
 	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
 	/* Incompat */
@@ -93,7 +93,7 @@ const static __u64 ok_features[NILFS_MAX_FEATURE_TYPES] = {
 
 const static __u64 clear_ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
-	0,
+	NILFS_FEATURE_COMPAT_INIT_XAFILE,
 	/* Read-only compat */
 	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
 	/* Incompat */
@@ -454,6 +454,10 @@ static void show_nilfs_sb(struct nilfs_super_block *sbp)
 	printf("CRC check data size:\t  0x%08x\n", le32_to_cpu(sbp->s_bytes));
 }
 
+#define NILFS_HAS_XAFILE(features) \
+	(((__u64 *)features)[NILFS_FEATURE_TYPE_COMPAT_RO] & \
+	 NILFS_FEATURE_COMPAT_RO_XAFILE)
+
 static int update_feature_set(struct nilfs_super_block *sbp,
 			      struct nilfs_tune_options *opts)
 {
@@ -487,6 +491,18 @@ static int update_feature_set(struct nilfs_super_block *sbp,
 				nilfs_feature2string(bad_type, bad_mask));
 		}
 	} else {
+		if ((features[NILFS_FEATURE_TYPE_COMPAT] &
+		     NILFS_FEATURE_COMPAT_INIT_XAFILE) &&
+		    (features[NILFS_FEATURE_TYPE_COMPAT_RO] &
+		     NILFS_FEATURE_COMPAT_RO_XAFILE)) {
+			fprintf(stderr,
+				"feature %s is not allowed to be set\n",
+				nilfs_feature2string(NILFS_FEATURE_TYPE_COMPAT,
+					NILFS_FEATURE_COMPAT_INIT_XAFILE));
+			ret = -1;
+			return ret;
+		}
+
 		sbp->s_feature_compat =
 			cpu_to_le64(features[NILFS_FEATURE_TYPE_COMPAT]);
 		sbp->s_feature_compat_ro =
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
