From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v14 33/74] page cache: Remove stray radix comment
Date: Sat, 16 Jun 2018 19:00:11 -0700
Message-ID: <20180617020052.4759-34-willy@infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
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
 bh=YHsOiVwnmmM+fD+x7PtECscr6uRZQGKoEocT4gLsYkk=; b=ZS7oJpfjELnp/H58+1qJe1M9L4
 S+SplcvsRx7FLEwrDYAjarA6EfXkmETJUtLiInhGeP/nT/RO9HMvQvanomVDIeiY7cZKQBlOinKQQ
 9Dr58t4u2rnjXntODftgeMyC8XqzalNVCkZJ20rtKE5yyKZEOzjhdmBY4zGKI1EHyWcM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=YHsOiVwnmmM+fD+x7PtECscr6uRZQGKoEocT4gLsYkk=; b=ap/vam1+XoaNXZZNXR58qh77Q+
 kfJ2fDv+Avf3utstRtC8TLdnhTBsrIzIneIcliPbYBpz6p3Cak3BWkFez8IciwH2EIj/Ubs6BdMC3
 +GAVQK2g0sXVlPgVQLS2UcjvmZFRgOwg42U7/eoGCJbJ1zqo1dMCFzYNUqGZdBXeVYnw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=YHsOiVwnmmM+fD+x7PtECscr6uRZQGKoEocT4gLsYkk=; b=Z2eL/ci4pQIttdp3e5p1kbETS
 WyWGwKJsIz+sLvsUST4d5UzI1Asf3ZSDxm+0ZgBUtZNMQIGvJQRyzIhgvRcrwy3EBFZlGAdg7q1G5
 JsRuIN7qqQ+rTX3m8ZeF6WTZx9HcuaC+hD9HybrRyY8H9hWCSB9i17wLckiaECGZKqgsl3vB5gyqf
 2ukL42QAoduQMl/YkZ0A7xc2/o9Go0Mmf/BptE0wS2FS46q4z5GUitanlaHhyuk7fHJK9tpS32zyd
 5Xl0zyhqDFu425G6H5ZQX59jIcqu+3t7QsETkIdyjyOrDd48GvKBIjE8C3VqeiPA4Oa2kRLxZECzO
 M/2BcKRdw==;
In-Reply-To: <20180617020052.4759-1-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 025077bc82be..e447dd2d0f5c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2682,7 +2682,7 @@ static struct page *do_read_cache_page(struct address_space *mapping,
 			put_page(page);
 			if (err == -EEXIST)
 				goto repeat;
-			/* Presumably ENOMEM for radix tree node */
+			/* Presumably ENOMEM for xarray node */
 			return ERR_PTR(err);
 		}
 
-- 
2.17.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
