From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/9 linux-next] nilfs2: remove dir_pages() declaration
Date: Sun, 24 May 2015 17:19:42 +0200
Message-ID: <1432480791-31396-3-git-send-email-fabf@skynet.be>
References: <1432480791-31396-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432480791-31396-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Fabian Frederick <fabf@skynet.be>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

dir_pages() is now declared in pagemap.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/nilfs2/dir.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 0ee0bed..6b8b92b 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -61,11 +61,6 @@ static inline void nilfs_put_page(struct page *page)
 	page_cache_release(page);
 }
 
-static inline unsigned long dir_pages(struct inode *inode)
-{
-	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
-}
-
 /*
  * Return the offset into page `page_nr' of the last valid
  * byte in that page, plus one.
-- 
2.4.1
