From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/10] ext4: Convert
 mpage_release_unused_pages() to use filemap_get_folios()
Date: Wed, 8 Jun 2022 01:02:22 -0700
Message-ID: <YqBXjjkRZsP8K8fO@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-4-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=SX9n5EnTUOKOzk0atnH01/6aCdLXi/kHksLRZ+/slrg=; b=Bb4UwXowKA3xbvKhip0bsToXdD
 S5/H5eYpcfn0V+FlnEFgVOcsyoIHiN/esWpjLEsd9epxo7AfJ9mMIszI6umXbi5dQy0ZvZ9T1sTXH
 1J0QOlh3BdcNbW9q/HpFajFhTJAr98kxr2F6NMcLj7k6ckTiB48IcPlQ1uwGka3vpoYI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=SX9n5EnTUOKOzk0atnH01/6aCdLXi/kHksLRZ+/slrg=; b=FABiMhGi3hntPlS3gKb+da0zJu
 mm2ntVkG77SeMbyAPIhfDZHfI351O4rCDTdpTDsSzzIvEKbU/0hOXWWDcYGHih+aQe342Crdik8lb
 /2MrZlEbJtM97kxqEYLUhzuiwYghQy2hMmObknc2PX4vP8IptAxmtrcLo1g1iSw3h6w8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=SX9n5EnTUOKOzk0atnH01/6aCdLXi/kHksLRZ+/slrg=; b=jysUfxHITvm5qME5kby7gEknda
 NniSqrjlYB/5FZ0sOB9SGdPN609Xc7Tio/met/HczsNX9IUlMHrvgiUDv4mHlaFTvBucMZTcxWuFM
 aGqA9GeGAxtC3R6lF2w/B87y6Wk6GgZNyLeH3AxjbiUcPe9vcD+G8iLkjHXT78FVtD6XmTe1cYmlt
 ngowBhuCCZ4lWWbh04Jl3QN6dGjrZt3zoJA55lgwd6zmbPrMu2DmXkzmdU0CAIYcq9FAdHR+U6sjS
 kvj5dDbrm/lmbPQZoKx97x7Y9QNcHlDLf2o8pDHQXCZgt2fdrKxTBoK/16KCB/EAF4EZ/7y1pxpfD
 Fds+rOEQ==;
Content-Disposition: inline
In-Reply-To: <20220605193854.2371230-4-willy@infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Sun, Jun 05, 2022 at 08:38:47PM +0100, Matthew Wilcox (Oracle) wrote:
> If the folio is large, it may overlap the beginning or end of the
> unused range.  If it does, we need to avoid invalidating it.

It's never going to be larger for ext4, is it?  But either way,
those precautions looks fine.

Reviewed-by: Christoph Hellwig <hch@lst.de>
