From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 30/61] page cache: Remove stray radix comment
Date: Tue, 13 Mar 2018 06:26:08 -0700
Message-ID: <20180313132639.17387-31-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k0ZkVOtROhQu3s1lA/RSwFQRIGhf+HdAuG6bbbDKLvs=; b=Rwl7QYBPEDLLT4THiY5zpU76U
        fq92Xq9FJmsNyneOZzgAcrmjeayv+6KDzPrm0Lt38raIvNvg7kxOTaytcGy02XU5IUbyW3pfy8zpa
        Xl5UNFeark5d4sWq+lgMNDbCduIfIumfIn71b27fPjrkrY3QxoX4gPVqAgbBr8UVPT8+K7oy/W/7f
        jGkXpuvXaGZ/Ijrhv+IP+CV79A1VXzFZejfG4y2R1QLtRtewaa5mFAKZ+BfU+iTbierenXxFYwpZ/
        blxlhlNQb7y3CFCyZJSQmyeWYTVS3CbrIXH2muo7oZ0no1q3yRc6xwNv4OaKdqKvjuac1CeG/rety
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

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

