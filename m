From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 65/73] dax: Fix sparse warning
Date: Tue,  5 Dec 2017 16:41:51 -0800
Message-ID: <20171206004159.3755-66-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jxcHLOxiA4QqUpiowHNo7PL7PKPF7K7FHtc1VFFYRM0=; b=pRTYGJi5uTMca0Pl4jeNSxxkz
        HIWbmybn/nqVPNOtuFft5nkfsDdUuZ+H3DdEjja8L4Fc5o12XfjP7mGbsNwc5L7rWYublJyWOaII3
        Sm8Nf2MMOPGUrcuJZXjOzGfNuNdVNPsXccRlbJ7SgnMI6PVjq8OBSxBPf3sM/fLXxfepOznahiwou
        dv6cnYY2UCAn3YDW5zrIaTkVrqMRTGQXK/lICN6h/2vYWv9li9OYoly0/VEFsGHAMvp29nHr7cTqs
        Cx5Pgc3ZZ0PnVSZ7J/5VwVTlV0zWV6Zgj4s2x8jItsa6cmGaLt0HBEb23yMXd/lln/tOu5y1g/eHK
    
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

sparse doesn't know that follow_pte_pmd conditionally acquires the ptl,
so add an annotation to let it know what's going on.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dax.c b/fs/dax.c
index c663d82e8ba3..7a86ff1153dd 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -531,6 +531,7 @@ static void dax_mapping_entry_mkclean(struct address_space *mapping,
 		 */
 		if (follow_pte_pmd(vma->vm_mm, address, &start, &end, &ptep, &pmdp, &ptl))
 			continue;
+		__acquire(ptl); /* Conditionally acquired above */
 
 		/*
 		 * No need to call mmu_notifier_invalidate_range() as we are
-- 
2.15.0

