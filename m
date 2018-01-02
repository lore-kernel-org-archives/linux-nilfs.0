From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5 03/78] xarray: Add the xa_lock to the radix_tree_root
Date: Tue, 2 Jan 2018 14:41:37 -0800
Message-ID: <20180102224137.GC20405@bombadil.infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-4-willy@infradead.org>
 <20171226165440.tv6inwa2fgk3bfy6@node.shutemov.name>
 <20171227034340.GC24828@bombadil.infradead.org>
 <20171227035815.GD24828@bombadil.infradead.org>
 <20180102180155.GD4857@magnolia>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=71ryAc2YCHXn/6W1kyfhYxoUH/zA8jnKY23Ii/LJVxI=; b=cZenRAUzNAlbaSH90J07/mTq3
        bActKxY7o2m/U8dRo9btX+uXKs1iTg7t3q0hKt6NA4IIDhHmImNDYk16KThvnmRkjKY8Odcuk87oY
        Rm2CJ0tynYXAxkxB7G9ZJUMSwAO1tPubTAz6lKtjVI3k05KNrnuAqjeq9KA/lVmLG+dQyYtndnbuo
        GSEi38sr+UGXPkh2soSApsbWjG6C6rFVOQEU4wMLcf9eJG1422NzfOg/G5WiYYwgl90VaEU8qbTmo
        5P59GKdyyLcEsGYUu/siFdTfkRVd0oDnbeJeo0OslMuVWMJ/GeVnMNBmoFbQ2Jr0nlxmGcE0VJZBB
    
Content-Disposition: inline
In-Reply-To: <20180102180155.GD4857@magnolia>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 02, 2018 at 10:01:55AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 26, 2017 at 07:58:15PM -0800, Matthew Wilcox wrote:
> >         spin_lock_irqsave(&mapping->pages, flags);
> >         __delete_from_page_cache(page, NULL);
> >         spin_unlock_irqrestore(&mapping->pages, flags);
> >
> > More details here: https://9p.io/sys/doc/compiler.html
> 
> I read the link, and I understand (from section 3.3) that replacing
> foo.bar.baz.goo with foo.goo is less typing, but otoh the first time I
> read your example above I thought "we're passing (an array of pages |
> something that doesn't have the word 'lock' in the name) to
> spin_lock_irqsave? wtf?"

I can see that being a bit jarring initially.  If you think about what
object-oriented languages were offering in the nineties, this is basically
C++ multiple-inheritance / Java interfaces.  So when I read the above
example, I think "lock the mapping pages, delete from page cache, unlock
the mapping pages", and I don't have a wtf moment.  It's just simpler to
read than "lock the mapping pages lock", and less redundant.

> I suppose it does force me to go dig into whatever mapping->pages is to
> figure out that there's an unnamed spinlock_t and that the compiler can
> insert the appropriate pointer arithmetic, but now my brain trips over
> 'pages' being at the end of the selector for parameter 1 which slows
> down my review reading...
> 
> OTOH I guess it /did/ motivate me to click the link, so well played,
> sir. :)

Now if only I can trick you into giving your ACK on patch 1,
"xfs: Rename xa_ elements to ail_"
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
