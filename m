From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 09/24] nilfs2: implement GC subsystem debugging output
Date: Mon, 17 Jun 2013 16:23:56 +0400
Message-ID: <1371471836.2075.139.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=yYOmADXdxUV1mGkkNTkg590QgX10AEPAiLA0pYpi8B4=;
	b=d8tmA6dTdjSS6VeihHDLkS/q/VTQpBVt7QUyeuRrQeSWYrRWu2mtiXmQvwozvYti+lT1MQSCwnEeDnv3NmCyQD6M4VWp1CGgMhRcPTZdlYPspJd4pVLd9dMdpak3lmR5;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 09/24] nilfs2: implement GC subsystem debugging output

This patch adds debugging output by means of nilfs2_debug() method
into modules that are grouped by GC subsystem debugging output
option (CONFIG_NILFS2_DEBUG_GC_SUBSYSTEM).

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/gcinode.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 57ceaf3..3f8eb77 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -76,6 +76,10 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 	struct buffer_head *bh;
 	int err;
 
+	nilfs2_debug(DBG_GCINODE,
+		"i_ino %lu, blkoff %lu, pbn %lu, vbn %llu, out_bh %p\n",
+		inode->i_ino, blkoff, pbn, vbn, out_bh);
+
 	bh = nilfs_grab_buffer(inode, inode->i_mapping, blkoff, 0);
 	if (unlikely(!bh))
 		return -ENOMEM;
@@ -142,6 +146,10 @@ int nilfs_gccache_submit_read_node(struct inode *inode, sector_t pbn,
 {
 	int ret;
 
+	nilfs2_debug(DBG_GCINODE,
+		"i_ino %lu, pbn %lu, vbn %llu, out_bh %p\n",
+		inode->i_ino, pbn, vbn, out_bh);
+
 	ret = nilfs_btnode_submit_block(&NILFS_I(inode)->i_btnode_cache,
 					vbn ? : pbn, pbn, READ, out_bh, &pbn);
 	if (ret == -EEXIST) /* internal code (cache hit) */
@@ -169,6 +177,8 @@ int nilfs_init_gcinode(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 
+	nilfs2_debug(DBG_GCINODE, "i_ino %lu\n", inode->i_ino);
+
 	inode->i_mode = S_IFREG;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
 	inode->i_mapping->a_ops = &empty_aops;
@@ -190,6 +200,7 @@ void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs)
 
 	while (!list_empty(head)) {
 		ii = list_first_entry(head, struct nilfs_inode_info, i_dirty);
+		nilfs2_debug(DBG_GCINODE, "i_ino %lu\n", ii->vfs_inode.i_ino);
 		list_del_init(&ii->i_dirty);
 		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
 		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
