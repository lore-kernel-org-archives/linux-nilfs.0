From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v13 32/72] page cache: Remove stray radix comment
Date: Mon, 11 Jun 2018 07:05:59 -0700
Message-ID: <20180611140639.17215-33-willy@infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
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
 bh=kt/+7qUnKYsXzc+5idgPVZBKG9R3xFwDZCojf19t9wU=; b=dsS7RfG4PWxV881analbRBSUUh
 xvmx8W6ywMQycdKz+OKAMoHucYAfYpbe4l1jqlFbeOMoQJj4Z4SQ/KP0uZ1CQjdxaI+YUkZj/d/0b
 /6RBg1O0xtzB0xrlFfIC7mHCeHSZVuKFyy9uACPkJ4Iau3I+vyLzE5TISbWvxx/GATjo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=kt/+7qUnKYsXzc+5idgPVZBKG9R3xFwDZCojf19t9wU=; b=iQ+1pTq+jU99sL7Jp5TOW6Xr+w
 srpdUPjzxi4Ss+xJcUY/mJlJ/FpyFvxcyPwVG7ANIaIG4aTuekJaQxXnWshqwoUkYXl4+3Zom/OC2
 /MQSAqM+auyFWCurfNIHTvNenXbKZ1jzuFDMQf0fxi2bmyFKv7Fjl8vLdUcF+vOINphI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=kt/+7qUnKYsXzc+5idgPVZBKG9R3xFwDZCojf19t9wU=; b=gUHDc9DkAlPtTIzNBAmqfzkPF
 LHHZ+NWTxjFa2l/eY0hTGJWTdaAQi/oRhhal6rrUDrSqIiGdGb7PHoHKNmw6bpwkcYPcuA/CYWMJx
 jFdw0dK5OGH8VPjPvdA8PVAAoEgvLQ57lHJfGUr2hpMzh85P4W2nyJ54NQS7/+bY6EXBOhOK3lf3D
 KbFJqOAtW0yU7Asv7DUUo7bfNi6QfYIrnfkZR0BqhVuEVMc/lI8LUA4K5GfnYmL2gO9lpzfvH+Z1Q
 twXSBrexwlh6y7IzvjRm/FQ12RSlmH1dSsJTuVgQDf6MHozbd7gGafat8FSvGOaosudUIrCZ6FK5s
 3KhkQGWQQ==;
In-Reply-To: <20180611140639.17215-1-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
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
