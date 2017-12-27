From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 03/78] xarray: Add the xa_lock to the radix_tree_root
Date: Tue, 26 Dec 2017 19:58:15 -0800
Message-ID: <20171227035815.GD24828@bombadil.infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-4-willy@infradead.org>
 <20171226165440.tv6inwa2fgk3bfy6@node.shutemov.name>
 <20171227034340.GC24828@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FFVt8mzBJWlSl8Ypxv8Gk/0vBqVG3Y8PbvCnW1SP5lM=; b=N49pY/wQFk1CmOWPfNwppeAUL
        Cru5AqWNitHk5cpS9hq/lWWia1RjrUVKz/k1m0u+PIjyTenbCLlyNtcGT4AlgnXtZdU16cloX+Ytc
        H6jznsgwA+bJegirRPFDIAGqYMh1/fSgfzBEzqQ9FQlDkTm+QvaUZSfH78u4UWgXcj2jQNEz5Vhdj
        snKKSHgwQ4Ww1LVbQqj9qclwu0qS5rEvXu7bvtPFfJU08gWC9kLjssg7vbfzsDCL5j5t8ijWOLcs2
        caxNSN0hXzYReqzLfGGqv7/yYhe/9X3LqJIJ2JfZGgU3WYyQAxf6Hi+cA0Ua5jXBSfK8U5mifOana
    
Content-Disposition: inline
In-Reply-To: <20171227034340.GC24828@bombadil.infradead.org>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Tue, Dec 26, 2017 at 07:43:40PM -0800, Matthew Wilcox wrote:
>     Also add the xa_lock() and xa_unlock() family of wrappers to make it
>     easier to use the lock.  If we could rely on -fplan9-extensions in
>     the compiler, we could avoid all of this syntactic sugar, but that
>     wasn't added until gcc 4.6.

Oh, in case anyone's wondering, here's how I'd do it with plan9 extensions:

struct xarray {
        spinlock_t;
        int xa_flags;
        void *xa_head;
};

...
        spin_lock_irqsave(&mapping->pages, flags);
        __delete_from_page_cache(page, NULL);
        spin_unlock_irqrestore(&mapping->pages, flags);
...

The plan9 extensions permit passing a pointer to a struct which has an
unnamed element to a function which is expecting a pointer to the type
of that element.  The compiler does any necessary arithmetic to produce 
a pointer.  It's exactly as if I had written:

        spin_lock_irqsave(&mapping->pages.xa_lock, flags);
        __delete_from_page_cache(page, NULL);
        spin_unlock_irqrestore(&mapping->pages.xa_lock, flags);

More details here: https://9p.io/sys/doc/compiler.html
