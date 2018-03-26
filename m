From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v9 00/61] XArray v9
Date: Mon, 26 Mar 2018 16:26:34 -0700
Message-ID: <20180326232634.GA10054@bombadil.infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
 <20180326153648.27f53e9a1398812203745257@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wYjeX3lCT3BPFdg62HQEnRvtf2UCMF6rFyoWqS3xi48=; b=KnYdjsKSdZjBUlrc28sgjrFZ9
        qoNfbJcLC2WyMAXRl+wiGq5V5/0st4VjRWBL7P6z+ruTZtT9il+zSb+ZXU4QFYXBij8K7L1Bo9APa
        U7jGtSbEDKrgD8pBjjK7dn5r3mtiCMRJKXTOs/NNNnzXqBIK/ROMJPdhuoC+Nz4eWdgimCqfi+ox9
        fa0EX/+bG8GyR0SQLSUF5SFOGL5Besi74m1XBOmEsH5luIo6LqtsxLuRd94XCzhu/4MEk2NqYwClt
        WGzhtx89Sh2it1WMUABMGY5Ia38iIcowTTxWAshcL1Xw3p0d8f3Xh5NDDwgTQWsHIqgwvsUEyeHvm
    
Content-Disposition: inline
In-Reply-To: <20180326153648.27f53e9a1398812203745257@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Mon, Mar 26, 2018 at 03:36:48PM -0700, Andrew Morton wrote:
> I looked at this from a for-4.17 POV and ran out of nerve at "[PATCH v9
> 09/61] xarray: Replace exceptional entries".  It's awfully late.

I did post v7 five weeks ago ... it wasn't late at the time.

> "[PATCH v9 08/61] page cache: Use xa_lock" looks sufficiently
> mechanical to be if-it-compiles-it-works, although perhaps that
> shouldn't be in 4.17 either.  Mainly because it commits us to merging
> the rest of XArray and there hasn't been a ton of review and test
> activity.

I think we should commit to that.  The API has had a pretty thorough
review, and nobody's stepped up to say "Hey, no, I prefer the old API,
I don't want to see it change".  Merging patch 8 would move us a good
chunk of the way towards getting the IDA in a position where it can
be converted.  Patch 9 would get us even further, but I'm willing to
respin in order to build on just patch 8.

> It looks like btrfs has changed in -next:
> 
> --- a/fs/btrfs/inode.c~page-cache-use-xa_lock-fix
> +++ a/fs/btrfs/inode.c
> @@ -7445,7 +7445,7 @@ out:
>  
>  bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end)
>  {
> -	struct radix_tree_root *root = &inode->i_mapping->page_tree;
> +	struct radix_tree_root *root = &inode->i_mapping->i_pages;
>  	bool found = false;
>  	void **pagep = NULL;
>  	struct page *page = NULL;

btrfs_page_exists_in_range() has been deleted -- David Sterba merged the
patch v8-0006-btrfs-Use-filemap_range_has_page.patch ... which was dropped
from v9 of the patchset, so I'm not sure what you're actually looking at?
