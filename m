From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 1/2] NILFS2: add omitted comments for structures in
 nilfs2_fs.h
Date: Thu, 19 Jul 2012 14:01:41 +0400
Message-ID: <1342692101.1982.9.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:Cc:To:From:Subject; bh=RvUJD0X/c4JGUeCY494QHYYRqEDsr7KqJk7jrR98cy8=;
	b=crt66EaAsET+48qKsJ8HS21dJcNa4B7T5l9jIgOwv2iyZpTOMHzVM6a6AQySrL0q9CUMNIVanS7I0MxXPF6iS03V7OyrrbWR4/nkxZGQTQMJljx9PWVE0Jt1enBVKjUr;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi,

This second version of patch adds omitted comments for structures in
nilfs2_fs.h.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 1/2] NILFS2: add omitted comments for structures in
nilfs2_fs.h

This patch adds omitted comments for structures in nilfs2_fs.h.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 89bd4a4..84b4245 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -293,7 +293,7 @@ struct nilfs_dir_entry {
 	__le64	inode;			/* Inode number */
 	__le16	rec_len;		/* Directory entry length */
 	__u8	name_len;		/* Name length */
-	__u8	file_type;
+	__u8	file_type;		/* Dir entry type (file, dir, special) */
 	char	name[NILFS_NAME_LEN];	/* File name */
 	char    pad;
 };
@@ -395,7 +395,7 @@ union nilfs_binfo {
 };
 
 /**
- * struct nilfs_segment_summary - segment summary
+ * struct nilfs_segment_summary - segment summary header
  * @ss_datasum: checksum of data
  * @ss_sumsum: checksum of segment summary
  * @ss_magic: magic number
@@ -683,9 +683,9 @@ struct nilfs_sufile_header {
 
 /**
  * nilfs_suinfo - segment usage information
- * @sui_lastmod:
- * @sui_nblocks:
- * @sui_flags:
+ * @sui_lastmod: timestamp of last modification
+ * @sui_nblocks: number of written blocks in segment
+ * @sui_flags: segment usage flags
  */
 struct nilfs_suinfo {
 	__u64 sui_lastmod;
@@ -716,9 +716,10 @@ enum {
 };
 
 /**
- * struct nilfs_cpmode -
- * @cc_cno:
- * @cc_mode:
+ * struct nilfs_cpmode - change checkpoint mode structure
+ * @cm_cno: checkpoint number
+ * @cm_mode: mode of checkpoint
+ * @cm_pad: padding
  */
 struct nilfs_cpmode {
 	__u64 cm_cno;
@@ -728,11 +729,11 @@ struct nilfs_cpmode {
 
 /**
  * struct nilfs_argv - argument vector
- * @v_base:
- * @v_nmembs:
- * @v_size:
- * @v_flags:
- * @v_index:
+ * @v_base: pointer on data array from userspace
+ * @v_nmembs: number of members in data array
+ * @v_size: size of data array in bytes
+ * @v_flags: flags
+ * @v_index: start number of target data items
  */
 struct nilfs_argv {
 	__u64 v_base;
@@ -743,9 +744,9 @@ struct nilfs_argv {
 };
 
 /**
- * struct nilfs_period -
- * @p_start:
- * @p_end:
+ * struct nilfs_period - period of checkpoint numbers
+ * @p_start: start checkpoint number (inclusive)
+ * @p_end: end checkpoint number (exclusive)
  */
 struct nilfs_period {
 	__u64 p_start;
@@ -753,7 +754,7 @@ struct nilfs_period {
 };
 
 /**
- * struct nilfs_cpstat -
+ * struct nilfs_cpstat - checkpoint statistics
  * @cs_cno: checkpoint number
  * @cs_ncps: number of checkpoints
  * @cs_nsss: number of snapshots
@@ -765,7 +766,7 @@ struct nilfs_cpstat {
 };
 
 /**
- * struct nilfs_sustat -
+ * struct nilfs_sustat - segment usage statistics
  * @ss_nsegs: number of segments
  * @ss_ncleansegs: number of clean segments
  * @ss_ndirtysegs: number of dirty segments
@@ -784,10 +785,10 @@ struct nilfs_sustat {
 
 /**
  * struct nilfs_vinfo - virtual block number information
- * @vi_vblocknr:
- * @vi_start:
- * @vi_end:
- * @vi_blocknr:
+ * @vi_vblocknr: virtual block number
+ * @vi_start: start checkpoint number (inclusive)
+ * @vi_end: end checkpoint number (exclusive)
+ * @vi_blocknr: disk block number
  */
 struct nilfs_vinfo {
 	__u64 vi_vblocknr;
@@ -797,7 +798,15 @@ struct nilfs_vinfo {
 };
 
 /**
- * struct nilfs_vdesc -
+ * struct nilfs_vdesc - descriptor of virtual block number
+ * @vd_ino: inode number
+ * @vd_cno: checkpoint number
+ * @vd_vblocknr: virtual block number
+ * @vd_period: period of checkpoint numbers
+ * @vd_blocknr: disk block number
+ * @vd_offset: logical block offset inside a file
+ * @vd_flags: flags (data or node block)
+ * @vd_pad: padding
  */
 struct nilfs_vdesc {
 	__u64 vd_ino;
@@ -811,7 +820,13 @@ struct nilfs_vdesc {
 };
 
 /**
- * struct nilfs_bdesc -
+ * struct nilfs_bdesc - descriptor of disk block number
+ * @bd_ino: inode number
+ * @bd_oblocknr: disk block address (for skipping dead blocks)
+ * @bd_blocknr: disk block address
+ * @bd_offset: logical block offset inside a file
+ * @bd_level: level in the b-tree organization
+ * @bd_pad: padding
  */
 struct nilfs_bdesc {
 	__u64 bd_ino;
--


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
