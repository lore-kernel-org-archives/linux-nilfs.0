From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: make nilfs_sc_*_ops static
Date: Sat, 24 Apr 2010 01:08:44 +0900
Message-ID: <1272038924-29579-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This kills the following sparse warnings:

fs/nilfs2/segment.c:567:28: warning: symbol 'nilfs_sc_file_ops' was not declared. Should it be static?
fs/nilfs2/segment.c:617:28: warning: symbol 'nilfs_sc_dat_ops' was not declared. Should it be static?
fs/nilfs2/segment.c:625:28: warning: symbol 'nilfs_sc_dsync_ops' was not declared. Should it be static?

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 8b4e280..c920164 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -564,7 +564,7 @@ static void nilfs_write_file_node_binfo(struct nilfs_sc_info *sci,
 	*vblocknr = binfo->bi_v.bi_vblocknr;
 }
 
-struct nilfs_sc_operations nilfs_sc_file_ops = {
+static struct nilfs_sc_operations nilfs_sc_file_ops = {
 	.collect_data = nilfs_collect_file_data,
 	.collect_node = nilfs_collect_file_node,
 	.collect_bmap = nilfs_collect_file_bmap,
@@ -614,7 +614,7 @@ static void nilfs_write_dat_node_binfo(struct nilfs_sc_info *sci,
 	*binfo_dat = binfo->bi_dat;
 }
 
-struct nilfs_sc_operations nilfs_sc_dat_ops = {
+static struct nilfs_sc_operations nilfs_sc_dat_ops = {
 	.collect_data = nilfs_collect_dat_data,
 	.collect_node = nilfs_collect_file_node,
 	.collect_bmap = nilfs_collect_dat_bmap,
@@ -622,7 +622,7 @@ struct nilfs_sc_operations nilfs_sc_dat_ops = {
 	.write_node_binfo = nilfs_write_dat_node_binfo,
 };
 
-struct nilfs_sc_operations nilfs_sc_dsync_ops = {
+static struct nilfs_sc_operations nilfs_sc_dsync_ops = {
 	.collect_data = nilfs_collect_file_data,
 	.collect_node = NULL,
 	.collect_bmap = NULL,
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
