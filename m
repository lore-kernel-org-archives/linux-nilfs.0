From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 6/7] nilfs2: add helper to find existent block on metadata file
Date: Thu, 12 Mar 2015 23:38:13 +0900
Message-ID: <1426171094-27414-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1426171094-27414-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=DIDuUsoxTQW7SUlnmhSrT9DrvpZx0pto/phjuwu9aXM=;
        b=FUBSaYkMJjZcmgDMoAjzl95naqpVaBa2Pyeeg4apvZBUe3+DKbq0N++69VUnDzuwhG
         BYdncYa6fvukjk0D5IpyJEhdATvcJ4RulepWFhr6fGCjYVFBwDCW7u84KW9JT5or+rMR
         5zYpgwuixOccFSdSpMpDRwaBVAJxAcxinGMxRFCxdfDVOY5rSRYTrAAlrbxyoZ/4PjAz
         oUHE9em0S+3SWX3yj3VzRFBnTQZNwSAEAPzTCkPA0Meaje4u5UPcss350yfkeK1WCrpp
         VGnIWwKsjFi4xLXk36gGVIzt6u6d2Qv1ZjEOW3klcuQbGQEoeoVI1ve9RKcf9s0hSFUV
         muxg==
In-Reply-To: <1426171094-27414-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Add a new metadata file function, nilfs_mdt_find_block(), which finds
an existent block on a metadata file in a given range of blocks.  This
function skips continuous hole blocks efficiently by using
nilfs_bmap_seek_key().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/mdt.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/mdt.h |  3 +++
 2 files changed, 57 insertions(+)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 892cf5f..dee34d9 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -261,6 +261,60 @@ int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
 }
 
 /**
+ * nilfs_mdt_find_block - find and get a buffer on meta data file.
+ * @inode: inode of the meta data file
+ * @start: start block offset (inclusive)
+ * @end: end block offset (inclusive)
+ * @blkoff: block offset
+ * @out_bh: place to store a pointer to buffer_head struct
+ *
+ * nilfs_mdt_find_block() looks up an existing block in range of
+ * [@start, @end] and stores pointer to a buffer head of the block to
+ * @out_bh, and block offset to @blkoff, respectively.  @out_bh and
+ * @blkoff are substituted only when zero is returned.
+ *
+ * Return Value: On success, it returns 0. On error, the following negative
+ * error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOENT - no block was found in the range
+ */
+int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
+			 unsigned long end, unsigned long *blkoff,
+			 struct buffer_head **out_bh)
+{
+	__u64 next;
+	int ret;
+
+	if (unlikely(start > end))
+		return -ENOENT;
+
+	ret = nilfs_mdt_read_block(inode, start, true, out_bh);
+	if (!ret) {
+		*blkoff = start;
+		goto out;
+	}
+	if (unlikely(ret != -ENOENT || start == ULONG_MAX))
+		goto out;
+
+	ret = nilfs_bmap_seek_key(NILFS_I(inode)->i_bmap, start + 1, &next);
+	if (!ret) {
+		if (next <= end) {
+			ret = nilfs_mdt_read_block(inode, next, true, out_bh);
+			if (!ret)
+				*blkoff = next;
+		} else {
+			ret = -ENOENT;
+		}
+	}
+out:
+	return ret;
+}
+
+/**
  * nilfs_mdt_delete_block - make a hole on the meta data file.
  * @inode: inode of the meta data file
  * @block: block offset
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index a294ea3..fe529a8 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -78,6 +78,9 @@ int nilfs_mdt_get_block(struct inode *, unsigned long, int,
 			void (*init_block)(struct inode *,
 					   struct buffer_head *, void *),
 			struct buffer_head **);
+int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
+			 unsigned long end, unsigned long *blkoff,
+			 struct buffer_head **out_bh);
 int nilfs_mdt_delete_block(struct inode *, unsigned long);
 int nilfs_mdt_forget_block(struct inode *, unsigned long);
 int nilfs_mdt_mark_block_dirty(struct inode *, unsigned long);
-- 
1.8.3.1
