From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/7] nilfs2: refactor nilfs_palloc_find_available_slot()
Date: Sat, 19 Sep 2015 19:32:59 +0900
Message-ID: <1442658782-3147-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1442658782-3147-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=qSBAD82pgroPJfgjw4OktSI+HT+RkdAZUT2L6vW5Ww0=;
        b=FrVDszaOqjAaRiVuEP42UZIo+YMJG0gvlJCl7udNxrnG22BYeLvQuwEUpswFjmvUCk
         564XIwvCRGQozeZI+eyRkrKKNHX3NtmB2XeZ/DvNakxgQLpJjF9G3oPE9In2MmKVOe/f
         72ihpyp8KCQrFOqWmU1BnxCZNfD1wp6L3u+k2NnLZjCbtMXEVguzlvsQvVZGtZoohuWL
         246gT8kwv2qfO5hWzrYAt6ARJedJXgnSExWIwUwYb0hepbVHZtG7MlOUEUrxmeZn0fN3
         0H1VW5e03wtxNNFXw3nuc5oTGujbaWr4U0x5fjLiSv7gNgK7+MhhzVC32KaaaGgPT780
         zZqQ==
In-Reply-To: <1442658782-3147-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The current implementation of nilfs_palloc_find_available_slot()
function is overkill.  The underlying bit search routine is well
optimized, so this uses it more simply in
nilfs_palloc_find_available_slot().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c | 48 +++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index ff0d62c..b15daf8 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -335,39 +335,33 @@ void *nilfs_palloc_block_get_entry(const struct inode *inode, __u64 nr,
  */
 static int nilfs_palloc_find_available_slot(unsigned char *bitmap,
 					    unsigned long target,
-					    int bsize,
+					    unsigned bsize,
 					    spinlock_t *lock)
 {
-	int curr, pos, end, i;
+	int pos, end = bsize;
 
-	if (target > 0) {
-		end = (target + BITS_PER_LONG - 1) & ~(BITS_PER_LONG - 1);
-		if (end > bsize)
-			end = bsize;
-		pos = nilfs_find_next_zero_bit(bitmap, end, target);
-		if (pos < end && !nilfs_set_bit_atomic(lock, pos, bitmap))
-			return pos;
-	} else {
-		end = 0;
+	if (likely(target < bsize)) {
+		pos = target;
+		do {
+			pos = nilfs_find_next_zero_bit(bitmap, end, pos);
+			if (pos >= end)
+				break;
+			if (!nilfs_set_bit_atomic(lock, pos, bitmap))
+				return pos;
+		} while (++pos < end);
+
+		end = target;
 	}
 
-	for (i = 0, curr = end;
-	     i < bsize;
-	     i += BITS_PER_LONG, curr += BITS_PER_LONG) {
-		/* wrap around */
-		if (curr >= bsize)
-			curr = 0;
-		while (*((unsigned long *)bitmap + curr / BITS_PER_LONG)
-		       != ~0UL) {
-			end = curr + BITS_PER_LONG;
-			if (end > bsize)
-				end = bsize;
-			pos = nilfs_find_next_zero_bit(bitmap, end, curr);
-			if (pos < end &&
-			    !nilfs_set_bit_atomic(lock, pos, bitmap))
-				return pos;
-		}
+	/* wrap around */
+	for (pos = 0; pos < end; pos++) {
+		pos = nilfs_find_next_zero_bit(bitmap, end, pos);
+		if (pos >= end)
+			break;
+		if (!nilfs_set_bit_atomic(lock, pos, bitmap))
+			return pos;
 	}
+
 	return -ENOSPC;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
