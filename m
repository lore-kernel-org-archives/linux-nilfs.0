From: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Subject: [PATCH] nilfs2: constify nilfs_sc_operations structures
Date: Sat,  9 Apr 2016 10:28:23 +0200
Message-ID: <1460190503-8672-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The nilfs_sc_operations structures are never modified, so declare them
as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>

---
 fs/nilfs2/segment.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 4317f72..483e663 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -617,7 +617,7 @@ static void nilfs_write_file_node_binfo(struct nilfs_sc_info *sci,
 	*vblocknr = binfo->bi_v.bi_vblocknr;
 }
 
-static struct nilfs_sc_operations nilfs_sc_file_ops = {
+static const struct nilfs_sc_operations nilfs_sc_file_ops = {
 	.collect_data = nilfs_collect_file_data,
 	.collect_node = nilfs_collect_file_node,
 	.collect_bmap = nilfs_collect_file_bmap,
@@ -666,7 +666,7 @@ static void nilfs_write_dat_node_binfo(struct nilfs_sc_info *sci,
 	*binfo_dat = binfo->bi_dat;
 }
 
-static struct nilfs_sc_operations nilfs_sc_dat_ops = {
+static const struct nilfs_sc_operations nilfs_sc_dat_ops = {
 	.collect_data = nilfs_collect_dat_data,
 	.collect_node = nilfs_collect_file_node,
 	.collect_bmap = nilfs_collect_dat_bmap,
@@ -674,7 +674,7 @@ static struct nilfs_sc_operations nilfs_sc_dat_ops = {
 	.write_node_binfo = nilfs_write_dat_node_binfo,
 };
 
-static struct nilfs_sc_operations nilfs_sc_dsync_ops = {
+static const struct nilfs_sc_operations nilfs_sc_dsync_ops = {
 	.collect_data = nilfs_collect_file_data,
 	.collect_node = NULL,
 	.collect_bmap = NULL,
@@ -1043,7 +1043,7 @@ static size_t nilfs_segctor_buffer_rest(struct nilfs_sc_info *sci)
 
 static int nilfs_segctor_scan_file(struct nilfs_sc_info *sci,
 				   struct inode *inode,
-				   struct nilfs_sc_operations *sc_ops)
+				   const struct nilfs_sc_operations *sc_ops)
 {
 	LIST_HEAD(data_buffers);
 	LIST_HEAD(node_buffers);
@@ -1550,7 +1550,7 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 	sector_t blocknr;
 	unsigned long nfinfo = segbuf->sb_sum.nfinfo;
 	unsigned long nblocks = 0, ndatablk = 0;
-	struct nilfs_sc_operations *sc_op = NULL;
+	const struct nilfs_sc_operations *sc_op = NULL;
 	struct nilfs_segsum_pointer ssp;
 	struct nilfs_finfo *finfo = NULL;
 	union nilfs_binfo binfo;

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
