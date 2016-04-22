From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/1] nilfs2: constify nilfs_sc_operations structures
Date: Fri, 22 Apr 2016 23:08:27 +0900
Message-ID: <1461334107-4694-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461334107-4694-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=uVhrjTH3Wn9DLTIT+cNLnguaAdmw6AqsbSG2S+ik3so=;
        b=F2n7GQzLtUldITYv+/9fcvITrkm6DMZSJjSu1fDQx2clkO8giEzR1blxl0Qddm5+Gy
         W7GHlF144vrrTMtADQZ06ypHdIalWvEUEtOG1RGyVfPpJkA59VWKMj/VKT7sS2CVorSi
         QyWHv7gmtsVOeGyiTUzoK9kAITiKtM4QoLC5wlMSOddnYsMA08laWDedtBAYSmen0G0f
         /TprSMwfPac3V+zlv1C/tW/x128ra22O6E9iThE+u86lOw/lkf9zjpIHwzNfZEh+p/z+
         fqQhBKHmiwy9+EmR6VsAiIWvO2ZFOQlEZkGk31EVTfYd/M8gpxdB/nq3c5jpWQur79Qw
         YHvA==
In-Reply-To: <1461334107-4694-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

From: Julia Lawall <Julia.Lawall@lip6.fr>

The nilfs_sc_operations structures are never modified, so declare them
as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/segment.c | 10 +++++-----
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
1.8.3.1

