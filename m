From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 2/3] mm: don't TestClearPageError in __filemap_fdatawait_range
Date: Sun,  5 Mar 2017 08:35:34 -0500
Message-ID: <20170305133535.6516-3-jlayton@redhat.com>
References: <20170305133535.6516-1-jlayton@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170305133535.6516-1-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: viro@zeniv.linux.org.uk, konishi.ryusuke@lab.ntt.co.jp
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org

The -EIO returned here can end up overriding whatever error is marked in
the address space. This means that an -ENOSPC error (AS_ENOSPC) can end
up being turned into -EIO if a page gets PG_error set on it during error
handling. Arguably, that's a bug in the writeback code, but...

Read errors are also tracked on a per page level using PG_error. Suppose
we have a read error on a page, and then that page is subsequently
dirtied by overwriting the whole page. Writeback doesn't clear PG_error,
so we can then end up successfully writing back that page and still
return -EIO on fsync.

Since the handling of this bit is somewhat inconsistent across
subsystems, let's just rely on marking the address space when there
are writeback errors.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 mm/filemap.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 3f9afded581b..2b0b4ff4668b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -375,17 +375,16 @@ int filemap_flush(struct address_space *mapping)
 }
 EXPORT_SYMBOL(filemap_flush);
 
-static int __filemap_fdatawait_range(struct address_space *mapping,
+static void __filemap_fdatawait_range(struct address_space *mapping,
 				     loff_t start_byte, loff_t end_byte)
 {
 	pgoff_t index = start_byte >> PAGE_SHIFT;
 	pgoff_t end = end_byte >> PAGE_SHIFT;
 	struct pagevec pvec;
 	int nr_pages;
-	int ret = 0;
 
 	if (end_byte < start_byte)
-		goto out;
+		return;
 
 	pagevec_init(&pvec, 0);
 	while ((index <= end) &&
@@ -402,14 +401,10 @@ static int __filemap_fdatawait_range(struct address_space *mapping,
 				continue;
 
 			wait_on_page_writeback(page);
-			if (TestClearPageError(page))
-				ret = -EIO;
 		}
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-out:
-	return ret;
 }
 
 /**
@@ -429,14 +424,8 @@ static int __filemap_fdatawait_range(struct address_space *mapping,
 int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
 			    loff_t end_byte)
 {
-	int ret, ret2;
-
-	ret = __filemap_fdatawait_range(mapping, start_byte, end_byte);
-	ret2 = filemap_check_errors(mapping);
-	if (!ret)
-		ret = ret2;
-
-	return ret;
+	__filemap_fdatawait_range(mapping, start_byte, end_byte);
+	return filemap_check_errors(mapping);
 }
 EXPORT_SYMBOL(filemap_fdatawait_range);
 
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
