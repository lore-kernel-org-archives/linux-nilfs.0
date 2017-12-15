From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 30/78] page cache: Remove stray radix comment
Date: Fri, 15 Dec 2017 14:04:02 -0800
Message-ID: <20171215220450.7899-31-willy@infradead.org>
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
 bh=7IyUF0nPi50kSJ4UlNKqtDM0Q5He4hT1vQEM8VhyBRE=; b=WDInYnmQeNJS/25HFlcljBMiRi
 t16XOSNBD/RMmvoulrf/jzgpc2RU9Do2XOqPj4V5gS6DXlYXO6JaWrICHkKLIHJvB93FeckM+UNbf
 nPebQK09fPv5es0A+lTxJU7YpvgKq5jsdD1g7o2XSrFOCBnjcshPfXhwe5Bm8NnVyIqE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=7IyUF0nPi50kSJ4UlNKqtDM0Q5He4hT1vQEM8VhyBRE=; b=SVh4WxtGGhTnmPUoR4xNssg26c
 qdZB2DEiEhAs2Ef8vQGIpRwMX4A7ItAk2RjrHDI3r9Xagp5fWICTHltTuiw3F/NHN+wQpnjAjzbv2
 X3bMCEuJUQHBgtP/uCgTxg6h0MNEXsAW6VCiaERY1Vejp8/7y8TYusNDl9oTCDFxcLsg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=7IyUF0nPi50kSJ4UlNKqtDM0Q5He4hT1vQEM8VhyBRE=; b=CaCaExazoZUvdbiUDmLpg/eyO
 hcVCG8bA1w/da2UYbMPsUBg7hg/ujXLjhB8X7N6GwVamib4tzRka+FF65W8V0gx2kB+lJKdCauB7y
 tepX98huW2mnKV6sm342em0xn+u3yUEuLxrYi8WHvRRSAyrJtUhtycC3aJ0XLAG/sdTXxb0lWpd60
 J8wDIvlo7TbmjyIkUKv8F8nTaGSwuzOhdvAbVPLPG/ROoXZtlawJndt246+HkTylfFqbyaqizcysg
 2HGr3Ci3bqljXItio31xk3NsywwntZyuk5DJKWIiyDOGlk9PN+fbLMqfif2aPvq2OZ03w9N55saSe
 JE4y3El4A==;
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

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 92ddee25f19b..75d1b32080a4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2603,7 +2603,7 @@ static struct page *do_read_cache_page(struct address_space *mapping,
 			put_page(page);
 			if (err == -EEXIST)
 				goto repeat;
-			/* Presumably ENOMEM for radix tree node */
+			/* Presumably ENOMEM for xarray node */
 			return ERR_PTR(err);
 		}
 
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
