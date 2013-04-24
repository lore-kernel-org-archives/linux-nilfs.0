From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] nilfs2: add logic for the case of file growing (old size <=
 new size) in nilfs_truncate()
Date: Wed, 24 Apr 2013 15:44:26 +0400
Message-ID: <1366803866.2146.2.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=z0tHcoCVoNDSw/MtEQaa4ykEYta0g5MIIDhzUF4CZp8=;
	b=hdaykj4RYT7EOmOL83CwzQYIwgbbbxZuLBP5CZzKHrEHdQ39IT7ENmcCITHuFd6CB+o1JvjNV08wyW7I5bKzcn03+Vwb/mnsA4CRug1gFNa2p9LbfaheQnBQZM9bKS25;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] nilfs2: add logic for the case of file growing (old size <= new size) in nilfs_truncate()

There are situations when nilfs_truncate() is called with new value of i_size that is greater than old one. This patch adds logic for such case.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/inode.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6b49f14..5ccaace 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -698,6 +698,36 @@ void nilfs_truncate(struct inode *inode)
 
 	blocksize = sb->s_blocksize;
 	blkoff = (inode->i_size + blocksize - 1) >> sb->s_blocksize_bits;
+
+	if (blkoff > inode->i_blocks) {
+		int err;
+		struct address_space *mapping = inode->i_mapping;
+		struct page *page;
+		void *fsdata;
+		loff_t size = inode->i_size;
+
+		err = pagecache_write_begin(NULL, mapping, size, 0,
+						AOP_FLAG_UNINTERRUPTIBLE,
+						&page, &fsdata);
+		if (err) {
+			printk(KERN_ERR
+			    "NILFS: pagecache_write_begin() failed: err %d",
+			    err);
+			return;
+		}
+		err = pagecache_write_end(NULL, mapping, size,
+						0, 0, page, fsdata);
+		if (err < 0) {
+			printk(KERN_ERR
+			    "NILFS: pagecache_write_end() failed: err %d",
+			    err);
+			return;
+		}
+		mark_inode_dirty(inode);
+		return;
+	} else if (blkoff == inode->i_blocks)
+		return;
+
 	nilfs_transaction_begin(sb, &ti, 0); /* never fails */
 
 	block_truncate_page(inode->i_mapping, inode->i_size, nilfs_get_block);
-- 
1.7.9.5



