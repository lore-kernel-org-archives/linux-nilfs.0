From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/8] nilfs2: emit error message when I/O error is detected
Date: Thu,  2 Jun 2016 22:58:09 +0900
Message-ID: <1464875891-5443-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1464875891-5443-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=+pDixEOFpaUPzM2YI3b3CDXfDqokpCjzPYH0slv2K9A=;
        b=JA8nTL0tJmiouZ5KEJlpwdTaaxCpmcsxPpT8ppXkm4DaAXHfEQ4f04bTA/FOFJ2gkc
         r8E6Y+jXRa9p/lVYz/TDQe5st3BMDNwTc1aQZbzOVRVulXpDs9Vejr4C0ZgJCz5iwXQR
         7C4M+zzupeAK854BTQ2y+IxQFZFAwtzr05OQt+t4U5FJDFU54ST+pilHB0y3ZViyalJo
         oIhVBagKdjkztnEIBCy7BwIET3AyCflEfIDcD5y4yLP/n+BgNct0P/9ddLTda1/fp/lB
         wOTj5QbQDcjC3jQcPUhHIMMQoJeMFt0gVoFRVZWhc2t9Llz/hlc2F2tGTQJh6Q9l2ZR4
         y0tg==
In-Reply-To: <1464875891-5443-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

When nilfs returned -EIO as an error code, it's not always clear if it
came from the underlying block device or not.  This will mend the
issue by having low level I/O routines of nilfs output an error
message when they detected an I/O error.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c   | 3 +++
 fs/nilfs2/gcinode.c | 9 ++++++++-
 fs/nilfs2/mdt.c     | 6 +++++-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 4816c5a..493e699 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -515,6 +515,9 @@ static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 
  out_no_wait:
 	if (!buffer_uptodate(bh)) {
+		nilfs_msg(btree->b_inode->i_sb, KERN_ERR,
+			  "I/O error reading b-tree node block (ino=%lu, blocknr=%llu)",
+			  btree->b_inode->i_ino, (unsigned long long)ptr);
 		brelse(bh);
 		return -EIO;
 	}
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 693aded..b94db89 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -147,8 +147,15 @@ int nilfs_gccache_submit_read_node(struct inode *inode, sector_t pbn,
 int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *bh)
 {
 	wait_on_buffer(bh);
-	if (!buffer_uptodate(bh))
+	if (!buffer_uptodate(bh)) {
+		struct inode *inode = bh->b_page->mapping->host;
+
+		nilfs_msg(inode->i_sb, KERN_ERR,
+			  "I/O error reading %s block for GC (ino=%lu, vblocknr=%llu)",
+			  buffer_nilfs_node(bh) ? "node" : "data",
+			  inode->i_ino, (unsigned long long)bh->b_blocknr);
 		return -EIO;
+	}
 	if (buffer_dirty(bh))
 		return -EEXIST;
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 3417d85..27ba7c7 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -206,8 +206,12 @@ static int nilfs_mdt_read_block(struct inode *inode, unsigned long block,
 
  out_no_wait:
 	err = -EIO;
-	if (!buffer_uptodate(first_bh))
+	if (!buffer_uptodate(first_bh)) {
+		nilfs_msg(inode->i_sb, KERN_ERR,
+			  "I/O error reading meta-data file (ino=%lu, block-offset=%lu)",
+			  inode->i_ino, block);
 		goto failed_bh;
+	}
  out:
 	*out_bh = first_bh;
 	return 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
