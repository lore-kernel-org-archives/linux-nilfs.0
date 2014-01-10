From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH 3/4] nilfs-utils: mkfs: implement creation
 empty xafile functionality
Date: Fri, 10 Jan 2014 16:11:30 +0400
Message-ID: <1389355890.3938.144.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=uRYCxtwkutNio9f1BiN5bc9mhM5o4juajb2atLqMow0=;
	b=ksUljx9IXHmIjuz936t16v8/+ke0kgmdBXylZK1BrWO5OiAr7DbQo14DC/+XJoY812v8QBYic9gFTiTScjNe8gfBRmesNgi+7jdsBDJobHe9J3v7wyAONsUQurAJGgsS;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH 3/4] nilfs-utils: mkfs: implement creation empty xafile functionality

This patch implements functionality of creation empty
xafile on mkfs phase.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/mkfs.nilfs2.8 |    9 +++++++++
 sbin/mkfs/mkfs.c  |   55 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/man/mkfs.nilfs2.8 b/man/mkfs.nilfs2.8
index a42d5b4..f63b0c5 100644
--- a/man/mkfs.nilfs2.8
+++ b/man/mkfs.nilfs2.8
@@ -50,6 +50,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
 [
 .B \-V
 ]
+[
+.B \-x
+]
 .I device
 .sp
 .B mkfs.nilfs2
@@ -97,6 +100,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
 [
 .B \-V
 ]
+[
+.B \-x
+]
 .I device
 .SH DESCRIPTION
 .B mkfs.nilfs2
@@ -182,6 +188,9 @@ Verbose execution.
 Print the version number of
 .B mkfs.nilfs2
 and exit.
+.TP
+.B \-x
+Create empty xafile on NILFS volume.
 .SH AUTHOR
 This version of
 .B mkfs.nilfs2
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index 8eb00bf..bccabf1 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -134,6 +134,7 @@ static __u64 compat_array[NILFS_MAX_FEATURE_TYPES] = {
 	/* Incompat */
 	0
 };
+static int create_xafile = 0;
 
 static void parse_options(int argc, char *argv[]);
 
@@ -420,6 +421,16 @@ static unsigned count_dat_blocks(unsigned nr_dat_entries)
 	return nblocks;
 }
 
+static unsigned count_xafile_blocks(void)
+{
+	unsigned nblocks;
+
+	nblocks = count_blockgrouped_file_blocks(blocksize, 0);
+	if (nblocks > NILFS_MAX_BMAP_ROOT_PTRS)
+		perr("Internal error: too many xanodes");
+	return nblocks;
+}
+
 static __attribute__((used)) void nilfs_check_ondisk_sizes(void)
 {
 	BUILD_BUG_ON(sizeof(struct nilfs_inode) > NILFS_MIN_BLOCKSIZE);
@@ -566,7 +577,8 @@ static void fix_disk_layout(struct nilfs_disk_info *di)
 
 			if (fi->ino != NILFS_DAT_INO &&
 			    fi->ino != NILFS_SUFILE_INO &&
-			    fi->ino != NILFS_CPFILE_INO)
+			    fi->ino != NILFS_CPFILE_INO &&
+			    fi->ino != NILFS_XATTR_INO)
 				di->nblocks_used += fi->nblocks;
 		}
 		if (di->nblocks_to_write < si->start + si->nblocks)
@@ -633,7 +645,12 @@ int main(int argc, char *argv[])
 	add_file(si, NILFS_NILFS_INO, 0, 0);
 	add_file(si, NILFS_ATIME_INO, 0, 0);
 	add_file(si, 1, 0, 0);
-	add_file(si, 8, 0, 0);
+
+	if (create_xafile)
+		add_file(si, NILFS_XATTR_INO, count_xafile_blocks(), 0);
+	else
+		add_file(si, 8, 0, 0);
+
 	add_file(si, 9, 0, 0);
 	add_file(si, 10, 0, 0);
 	add_file(si, NILFS_IFILE_INO, count_ifile_blocks(), 0);
@@ -1087,7 +1104,7 @@ static void parse_options(int argc, char *argv[])
 	int c, show_version_only = 0;
 	char *fs_features = NULL;
 
-	while ((c = getopt(argc, argv, "b:B:cfhKL:m:nqvO:P:V")) != EOF) {
+	while ((c = getopt(argc, argv, "b:B:cfhKL:m:nqvO:P:Vx")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = atol(optarg);
@@ -1133,6 +1150,9 @@ static void parse_options(int argc, char *argv[])
 		case 'V':
 			show_version_only = 1;
 			break;
+		case 'x':
+			create_xafile = 1;
+			break;
 		default:
 			usage();
 			exit(EXIT_FAILURE);
@@ -1175,7 +1195,7 @@ static void usage(void)
 		"Usage: %s [-b block-size] [-B blocks-per-segment] [-c] [-f] \n"
 		"       [-L volume-label] [-m reserved-segments-percentage] \n"
 		"       [-O feature[,...]] \n"
-		"       [-hnqvKV] device\n",
+		"       [-hnqvxKV] device\n",
 		progname);
 }
 
@@ -1319,7 +1339,10 @@ static void nilfs_mkfs_make_reserved_files(void)
 {
 	init_inode(NILFS_ATIME_INO, DT_REG, 0, 0);
 	init_inode(1, DT_REG, 0, 0);
-	init_inode(8, DT_REG, 0, 0);
+
+	if (!create_xafile)
+		init_inode(8, DT_REG, 0, 0);
+
 	init_inode(9, DT_REG, 0, 0);
 	init_inode(10, DT_REG, 0, 0);
 }
@@ -1564,6 +1587,19 @@ static void commit_sufile(void)
 	su->su_nblocks = cpu_to_le32(nilfs.current_segment->nblocks);
 }
 
+static void prepare_xafile(void)
+{
+	struct nilfs_file_info *fi = nilfs.files[NILFS_XATTR_INO];
+	blocknr_t blocknr = fi->start;
+
+	prepare_blockgrouped_file(blocknr);
+
+	/* Reserve block for invalid xanode number */
+	alloc_blockgrouped_file_entry(blocknr, 0);
+
+	init_inode(NILFS_XATTR_INO, DT_REG, 0, 0);
+}
+
 static void prepare_dat(void)
 {
 	struct nilfs_file_info *fi = nilfs.files[NILFS_DAT_INO];
@@ -1651,11 +1687,15 @@ static void prepare_segment(struct nilfs_segment_info *si)
 
 	nilfs.files[NILFS_CPFILE_INO]->raw_inode = &sr->sr_cpfile;
 	nilfs.files[NILFS_SUFILE_INO]->raw_inode = &sr->sr_sufile;
+	if (create_xafile)
+		nilfs.files[NILFS_XATTR_INO]->raw_inode = &sr->sr_xafile;
 	nilfs.files[NILFS_DAT_INO]->raw_inode = &sr->sr_dat;
 
 	prepare_dat();
 	prepare_sufile();
 	prepare_cpfile();
+	if (create_xafile)
+		prepare_xafile();
 	prepare_ifile();
 }
 
@@ -1771,6 +1811,11 @@ static void prepare_super_block(struct nilfs_disk_info *di)
 
 	raw_sb->s_feature_compat =
 		cpu_to_le64(compat_array[NILFS_FEATURE_TYPE_COMPAT]);
+
+	if (create_xafile) {
+		compat_array[NILFS_FEATURE_TYPE_COMPAT_RO] |=
+					NILFS_FEATURE_COMPAT_RO_XAFILE;
+	}
 	raw_sb->s_feature_compat_ro =
 		cpu_to_le64(compat_array[NILFS_FEATURE_TYPE_COMPAT_RO]);
 	raw_sb->s_feature_incompat =
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
