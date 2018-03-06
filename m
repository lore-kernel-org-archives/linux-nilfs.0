From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 32/63] page cache: Remove stray radix comment
Date: Tue,  6 Mar 2018 11:23:42 -0800
Message-ID: <20180306192413.5499-33-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k0ZkVOtROhQu3s1lA/RSwFQRIGhf+HdAuG6bbbDKLvs=; b=JLX7d4RZ0ly1+0VKUDmG5qfvK
        QHSB7KBvQNYxDWQYtGAdiiGvQTiCd6VkQSQQgOZMwLvey648nhsGVZgCUmVGqcCfA7a6TPsojWTaz
        4m+AtjVE9g7aRGt7ZAXRLychEVhmMoxBs7WtQm0yr7u6KochYGTw0GGSvWhg9jUwMBiZ3AmuSC8kw
        jwmwQA4NtPx62yQO6G+YUP/OlwwI+2+OzF7zEgdJQHudppAxgtMZJkBwGsr94R+JheSR5Hf+ZLNE0
        IX43qZRnb8qwLn3tQcRg8uFmLeEmWiQmax3hc7dg+oYl3l/UtutVEcC83WMSfGim4w/qXHHjPe10T
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 0635e9cdbc06..86c83014c909 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2579,7 +2579,7 @@ static struct page *do_read_cache_page(struct address_space *mapping,
 			put_page(page);
 			if (err == -EEXIST)
 				goto repeat;
-			/* Presumably ENOMEM for radix tree node */
+			/* Presumably ENOMEM for xarray node */
 			return ERR_PTR(err);
 		}
 
-- 
2.16.1

