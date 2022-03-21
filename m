From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] nilfs2: get rid of nilfs_mapping_init()
Date: Mon, 21 Mar 2022 21:57:07 +0900
Message-ID: <1647867427-30498-4-git-send-email-konishi.ryusuke@gmail.com>
References: <1647867427-30498-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aGt0QOXNwCSbtFJRf/ayuNuD4ICQ9tLB6ZQAMSZA3fQ=;
        b=YOIqisPIdsOV4AXIAJlVXH7XAbldaJ4R2x9i2Or0eaf2szg9q8357OFBJJtaEd+hVI
         CejP+TuHCj+pB2qiM+u6XokNVAVvwj/aQJsEgY0C2JvhW+n3jpxhu6j5t7JF6QrUoyeE
         UPjykla2QOOjeDrX1G72k3NfzP5DUMENBpKD891lrsfg3H6mKeQvYKiCNLtLxmkLtfk/
         77LJJ/H+NnaZ0z/J2qj3MruVZ7PmWcObIFkSj+oSsJYzQvI6OfdcYjnQMN+8THfObjrv
         oA/yYttT+VirTpWtYXF3NqFKIW6k0sFjkHBJjVRSnsRUuddzfbTRYDJs5Ih+pVKry/tc
         C6+g==
In-Reply-To: <1647867427-30498-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

After applying the lockdep warning fixes, nilfs_mapping_init() is no
longer used, so delete it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/page.c | 9 ---------
 fs/nilfs2/page.h | 1 -
 2 files changed, 10 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 45e079295008..a8e88cc38e16 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -436,15 +436,6 @@ unsigned int nilfs_page_count_clean_buffers(struct page *page,
 	return nc;
 }
 
-void nilfs_mapping_init(struct address_space *mapping, struct inode *inode)
-{
-	mapping->host = inode;
-	mapping->flags = 0;
-	mapping_set_gfp_mask(mapping, GFP_NOFS);
-	mapping->private_data = NULL;
-	mapping->a_ops = &empty_aops;
-}
-
 /*
  * NILFS2 needs clear_page_dirty() in the following two cases:
  *
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 569263b23c0c..21ddcdd4d63e 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -43,7 +43,6 @@ struct buffer_head *nilfs_grab_buffer(struct inode *, struct address_space *,
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
 void nilfs_clear_dirty_page(struct page *, bool);
 void nilfs_clear_dirty_pages(struct address_space *, bool);
-void nilfs_mapping_init(struct address_space *mapping, struct inode *inode);
 unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
 					    unsigned int);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
-- 
1.8.3.1

