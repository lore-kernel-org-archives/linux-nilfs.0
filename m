From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 03/78] xarray: Add the xa_lock to the radix_tree_root
Date: Tue, 26 Dec 2017 19:43:40 -0800
Message-ID: <20171227034340.GC24828@bombadil.infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-4-willy@infradead.org>
 <20171226165440.tv6inwa2fgk3bfy6@node.shutemov.name>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=LkpX01Y26Wny44Hpk2zisvdnsJu1sWO+nGCBTYh9Jro=; b=A/2zCSbJy4PYOdaf9InnwSgoq
	HhrBKpKTy7rKkJNo+3LP737iIZW1aEc0QoIZEl8Sej53kXPFW0mUGKP+DkxJhPTqku40Kme3ZFAul
	I86vbyXYS9mhQr7iT7Y1d+4c1LphKzpaZagXWcVq0L92BMuDJxJUEsTIZOxkkvLCPnicE0H7R2vjQ
	2lkRYvk+yaVpDhpvziNOlB52DcGHvxAovQcM548rVB28IQ19FKh+szr6IbPJpY7A8iyis/l5sjn8e
	K4FCotXnnx5kOhfz1cVndCxIq7WTCMvjMwCToGMeMUSX7i5uIi5BhUEQtt56NEeetZALLQumZCfkM
	IGK8T/djw==;
Content-Disposition: inline
In-Reply-To: <20171226165440.tv6inwa2fgk3bfy6@node.shutemov.name>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Tue, Dec 26, 2017 at 07:54:40PM +0300, Kirill A. Shutemov wrote:
> On Fri, Dec 15, 2017 at 02:03:35PM -0800, Matthew Wilcox wrote:
> > From: Matthew Wilcox <mawilcox@microsoft.com>
> > 
> > This results in no change in structure size on 64-bit x86 as it fits in
> > the padding between the gfp_t and the void *.
> 
> The patch does more than described in the subject and commit message. At first
> I was confused why do you need to touch idr here. It took few minutes to figure
> it out.
> 
> Could you please add more into commit message about lockname and xa_ locking
> interface since you introduce it here?

Sure!  How's this?

    xarray: Add the xa_lock to the radix_tree_root
    
    This results in no change in structure size on 64-bit x86 as it fits in
    the padding between the gfp_t and the void *.
    
    Initialising the spinlock requires a name for the benefit of lockdep,
    so RADIX_TREE_INIT() now needs to know the name of the radix tree it's
    initialising, and so do IDR_INIT() and IDA_INIT().
    
    Also add the xa_lock() and xa_unlock() family of wrappers to make it
    easier to use the lock.  If we could rely on -fplan9-extensions in
    the compiler, we could avoid all of this syntactic sugar, but that
    wasn't added until gcc 4.6.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
