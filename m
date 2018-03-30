From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v10 23/62] page cache: Remove stray radix comment
Date: Thu, 29 Mar 2018 20:42:06 -0700
Message-ID: <20180330034245.10462-24-willy@infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
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
 bh=OG6bkstH+ZtFTmDvpfqJ1wDwHBncOY+1HTlZtDPb9Ng=; b=RwVus+ltn6i+Vtoz8XpnIT9tTD
 Qx96XuaG7Od7DaH02KPW8RyN8js+fkJv+kZPzJ1cEM8nqtYRLeiv8KGNfmoisPgqNXw4FACeWFVI5
 86NswePzFmTXSCY1nyllIwR+/D0uQx7zxlYzVXeq1qkg1dhTxjTY60r2aHBtw6gvwEHg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=OG6bkstH+ZtFTmDvpfqJ1wDwHBncOY+1HTlZtDPb9Ng=; b=KdX5rcfdGp4W+3Zvl3m8vM8tkO
 rrZ381WbiM52DqQQ0PYuoHB/kzR5wk+DNKjYSWay6/yNjIfJtzpxKLOESILvP3VJy2+Hb8HNM6r86
 7Sxix660l1fmVHGHU9/C0fywgEOGyjfyGSoQ5xORCXteQGEwACrYyax7Xe7KqRchzyf8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=OG6bkstH+ZtFTmDvpfqJ1wDwHBncOY+1HTlZtDPb9Ng=; b=VXT8qbT2ZYL9UVYoluWXfNNPM
 dqNsdoIEeG7xnnMVImqSwwyJFk970bIh/ku5OdIAJjYDdWSmFy2cHBxGA9TprrXbuDYxcNtSFIczg
 6SSlasZQLYO0DtvEJ0GKNFDOIuG6XAVqMl6saaXevNdxtmO35dNJBMXoNH3lhojBvGcNWROPmBFSa
 VtnYHwbpE3C/hDI8DCq17m2AX+qdLtXLunJdUu/F95jWT0bhcHRt52+KtMqnYE683U02Ty2bTxsnv
 0Bd+d9IG2O5M1OdW8vGvNkxvn+EOaohM0nkvah1IsGDAdr2z9LjWgPHP7Cv6WLvMMnSlxy+qWKrvN
 K52Q3WuvQ==;
In-Reply-To: <20180330034245.10462-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

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
2.16.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
