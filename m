From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 66/78] dax: Fix sparse warning
Date: Fri, 15 Dec 2017 14:04:38 -0800
Message-ID: <20171215220450.7899-67-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=nDYcSE+NuhzGHfCkLxk41aV9zRFTyfrNndBRcB+78Yc=; b=Vn2MtVjFBQbnIO1Cn+ewhvQ5YF
 4GfKWAGtjf474v9cdMrwiDFM4NrApAmBVzVm9U8DzVabVcRv1bG6OCu+QG5T0U5+tevNpshFYjy3o
 6ggKjn3YbmkNZsejkmC2LpxPQkm36CVtgP3vWhpqzISRhUU9KxS70f7ktJOGx8rww4AA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=nDYcSE+NuhzGHfCkLxk41aV9zRFTyfrNndBRcB+78Yc=; b=nBUuWeJYCJMxApeiUY2ZbBZJgx
 AxPwqLwvIxprlkikwuv2Su8ZzpMTvRRkqtbNuvqe+30nDrKHqRkATrp1ZWT2WVVYKEvBr6hZ+koPO
 wPHXznzrdwosQDaVz2ZK6dv8uUXUkH2FvmZGZ5YRwDMsP/kp0xAMiHBPMXrMQxr/jZsg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=nDYcSE+NuhzGHfCkLxk41aV9zRFTyfrNndBRcB+78Yc=; b=a08n2/dnm13ShJINcOFu/ODoU
 qKKX3qPYAo3JqUKd0ZxJb9nZ+55Wom7tepit4Ox+tQTBUajgsg30oAy/sgpri2S+0b0JCv+fPhaIP
 LEdF0BPtUQvq46OV4D7vzDO361/e7ozRPkyKIGNgpby5QdYDfDNk/7/RhAd5YmbfuJpqKAk0MPt7n
 qC8fSLnDZqfcEZlr/nKELeMwMTcEW2VBKGre1fEtqKyjrdhaiOawspyNIf/0f7PmBpuaPBd5qu8K4
 0nz68lYwqfY61yIX5ytZg6WIrI+LTiVEgNR80WdzEqt7a1g1K0uhSe2gXDSEpmfUV+fJMLBvL0HW2
 /bWgbhH1w==;
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

sparse doesn't know that follow_pte_pmd conditionally acquires the ptl,
so add an annotation to let it know what's going on.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dax.c b/fs/dax.c
index f591ab5be590..6ef727af30f0 100644
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
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
