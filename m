From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v11 51/63] dax: Fix use of zero page
Date: Sat, 14 Apr 2018 07:13:04 -0700
Message-ID: <20180414141316.7167-52-willy@infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
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
 bh=kO0TY+AG8mnwCvxUavVJq8o2dSt+DO4i4pVBnPyXu0o=; b=cmLUGKQ+fbje8IsO4t6N7q64sb
 JgY1kaf+dfho1RdilcxdkBldzpANaHcjLuz59pbteAX6lcTDt/SncbmGjqagM++L+BcfyRrnys2rT
 gW3Jrd9CgWU47qUn4pozPpunELGtBuzEFCphbheGsIvyWL3qzE8BozJFdLPOC7kYNHG8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=kO0TY+AG8mnwCvxUavVJq8o2dSt+DO4i4pVBnPyXu0o=; b=KoYYcvq0ixN17rn7ul/AajC4r4
 VUdiHcMeUXDXtzwZsx3QAWeTEpbU2IRYtWHMTeAAMIQMQP9/Yj3mvnvN+2z7/p1XzwmsuEhw/xZWg
 U3w1/1wgt5UNH1wWnawkcYhBpWd0kkWbkVKvh7vB6ux2R300u/kFF+9lExxB9CjXalcw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=kO0TY+AG8mnwCvxUavVJq8o2dSt+DO4i4pVBnPyXu0o=; b=Ivjdw/VDHAEI8Zyai5FPArLxj
 L/pWzu8BsdlLzVIe7P9nVpXtjs0uLIkxf8X5qaEeSyYDfvvrl+S9fXSHIJo8BxXDq+/t+xn2vOl3u
 TyZ8Dup6TIJMnFMb5LAtIcIdwEiPejNvUVb4EPLzEQQgw4dp/Tcy1WRDlcJADIJ1h3N0c2YBZrm3l
 jROavAlVLdkX8MQ+NrbVhcoES050lRgADpX7h01GApMsN+JnBjqcR7Y3LapBhxZcPSeXZYHypBZha
 jAgKSPdOfVKMzaHhJJwqg5VbS13bGRSwBSLpaEn0k2Xejk4fBSl9MB43kUK1gNgIFKJWudkGPVfKt
 JEOb/ACpg==;
In-Reply-To: <20180414141316.7167-1-willy@infradead.org>
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

Use my_zero_pfn instead of ZERO_PAGE, and pass the vaddr to it so it
works on MIPS and s390.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index e014c99b21fd..b0efb0a9604a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -909,17 +909,9 @@ static int dax_load_hole(struct address_space *mapping, void *entry,
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
 	int ret = VM_FAULT_NOPAGE;
-	struct page *zero_page;
 	void *entry2;
-	pfn_t pfn;
-
-	zero_page = ZERO_PAGE(0);
-	if (unlikely(!zero_page)) {
-		ret = VM_FAULT_OOM;
-		goto out;
-	}
+	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
 
-	pfn = page_to_pfn_t(zero_page);
 	entry2 = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 			DAX_ZERO_PAGE, false);
 	if (IS_ERR(entry2)) {
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
