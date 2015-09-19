From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/7] nilfs2: use nilfs_warning() in allocator implementation
Date: Sat, 19 Sep 2015 19:32:57 +0900
Message-ID: <1442658782-3147-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1442658782-3147-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=3hNKcjMefN9PAE5CakOw0C9XrwRDENAalOqljwDsK44=;
        b=c0183X4BU++mjxNTmhzgz1grj1d0MOteRXpx97++gt/Ahafrqi0FjeuqX8h7/tDgUi
         m0vZRIE2QNQQZNgcGVfQztrMtZSrlyEKVsiKZMzCSUi3YoOQd/UbSvk6LhrFkwEfNJVP
         y7KDIioZf3xPnKzRVhCQWw/XLoTOBMQfLxVnLFPDYie7vU7wPXC8qx6T+PKWh/mfJAY0
         3XRFJ3ip4Kzy1hnducrDIasnv+4L5PL4DEkDsdCgUreS64RdnEijigo9ABhU/gtTd/z4
         bnYHlAEpVmXIrsQXMWsZzcbfBTh2WmzBsGniDNfwGQQ0+VrcDZbOdaesC9rleY18MmEY
         iSew==
In-Reply-To: <1442658782-3147-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This uses nilfs_warning() to replace "printk(KERN_WARNING ...);" in
the bitmap based allocator implementation of nilfs2.  The warning
messages are modified to include the device name and the inode number
in each message.  This makes it clear which metadata file of which
device has output warnings such as "entry number xxxx already freed".

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 8df0f3b..afe98364 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -583,8 +583,10 @@ void nilfs_palloc_commit_free_entry(struct inode *inode,
 
 	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
 				    group_offset, bitmap))
-		printk(KERN_WARNING "%s: entry number %llu already freed\n",
-		       __func__, (unsigned long long)req->pr_entry_nr);
+		nilfs_warning(inode->i_sb, __func__,
+			      "entry number %llu already freed: ino=%lu\n",
+			      (unsigned long long)req->pr_entry_nr,
+			      (unsigned long)inode->i_ino);
 	else
 		nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
 
@@ -620,8 +622,10 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
 				    group_offset, bitmap))
-		printk(KERN_WARNING "%s: entry number %llu already freed\n",
-		       __func__, (unsigned long long)req->pr_entry_nr);
+		nilfs_warning(inode->i_sb, __func__,
+			      "entry number %llu already freed: ino=%lu\n",
+			      (unsigned long long)req->pr_entry_nr,
+			      (unsigned long)inode->i_ino);
 	else
 		nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
 
@@ -734,10 +738,10 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 			if (!nilfs_clear_bit_atomic(
 				    nilfs_mdt_bgl_lock(inode, group),
 				    group_offset, bitmap)) {
-				printk(KERN_WARNING
-				       "%s: entry number %llu already freed\n",
-				       __func__,
-				       (unsigned long long)entry_nrs[j]);
+				nilfs_warning(inode->i_sb, __func__,
+					      "entry number %llu already freed: ino=%lu\n",
+					      (unsigned long long)entry_nrs[j],
+					      (unsigned long)inode->i_ino);
 			} else {
 				n++;
 			}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
