From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: prevent general protection fault in nilfs_clear_dirty_page()
Date: Mon, 12 Jun 2023 11:14:56 +0900
Message-ID: <20230612021456.3682-1-konishi.ryusuke@gmail.com>
References: <000000000000da4f6b05eb9bf593@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686536087; x=1689128087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwR+Br//mM4TJi0nAuK5n5aI7xVUDVwbzD2JoLH3tEk=;
        b=PXDJpBTHA65AcsByKj3qIbsDGTBrzv/cIP0WWsyYTbifSRsMn2EKrGuV6JrC1xx3v0
         7ysn33KTQuyb1hoSAYtq5bU4rvsKiC3M8ZPITZUG6kYLIjvoEr+FIpyRjGlQOGz2m9N5
         OGDo0U4P4nJHg6OOOWB75XuUh/2X+GzOFVhIe+X3E0r4mpLOgt4z53KlmDyY80B3oBUq
         1Sfon+W614AYqd5wRse3I/xCmiUChfG/xJXExqkI7BxWYTa1sdIt+Pg8xYXbLfdyrety
         9O7khHrt013zGI1GoSDkX+4/Arogi8iezBGs9Wnwcu/2PQuFHK9KTwpVDOhj2Rjdq/v2
         g/uw==
In-Reply-To: <000000000000da4f6b05eb9bf593-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot <syzbot+53369d11851d8f26735c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

In a syzbot stress test that deliberately causes file system errors on
nilfs2 with a corrupted disk image, it has been reported that
nilfs_clear_dirty_page() called from nilfs_clear_dirty_pages() can cause
a general protection fault.

In nilfs_clear_dirty_pages(), when looking up dirty pages from the page
cache and calling nilfs_clear_dirty_page() for each dirty page/folio
retrieved, the back reference from the argument page to "mapping" may have
been changed to NULL (and possibly others).  It is necessary to check
this after locking the page/folio.

So, fix this issue by not calling nilfs_clear_dirty_page() on a page/folio
after locking it in nilfs_clear_dirty_pages() if the back reference
"mapping" from the page/folio is different from the "mapping" that held
the page/folio just before.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+53369d11851d8f26735c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Closes: https://lkml.kernel.org/r/000000000000da4f6b05eb9bf593-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/page.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 5cf30827f244..b4e54d079b7d 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -370,7 +370,15 @@ void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
 			struct folio *folio = fbatch.folios[i];
 
 			folio_lock(folio);
-			nilfs_clear_dirty_page(&folio->page, silent);
+
+			/*
+			 * This folio may have been removed from the address
+			 * space by truncation or invalidation when the lock
+			 * was acquired.  Skip processing in that case.
+			 */
+			if (likely(folio->mapping == mapping))
+				nilfs_clear_dirty_page(&folio->page, silent);
+
 			folio_unlock(folio);
 		}
 		folio_batch_release(&fbatch);
-- 
2.34.1

