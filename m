From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 01/32] block: Provide blkdev_get_handle_* functions
Date: Tue, 4 Jul 2023 13:43:51 +0100
Message-ID: <ZKQUB4rU8Gebhq6R@casper.infradead.org>
References: <20230629165206.383-1-jack@suse.cz>
 <20230704122224.16257-1-jack@suse.cz>
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MTt8zrAicdNCIRJKdOYeAgLwlWREbjuubDrB9LDLoHk=; b=FQ7AVaBk1GiVkQjqboSqkOGPBq
        D5twh1rJ7Iuli9ASCg3UlAH0AvBtBUwBmFvGFlq65Bob5lYyyxVWcYsI1kpmfheq88Wy3j6xoPYkH
        Yr8SWDhirVenxTbYcufP9aI7qtE9tPtw2HdVYrOWl8KhXSL1///8tHp1coXORoa2/ua7NUKFkm8+i
        dZTW2mGKIGBkD8nw9XAEiECk0hIGw3K+rH1tSbKt2yF6JFa6PpHTgJc3LTGgE/JGwL7FWrIxLj7Op
        grzKnmKKjadKIKnXmQRg0cnlXA7KWmhAcv93Lftb6rhIWGVuVJI8IrHKh1M51oSxQqR7AKzuvj0MI
        qnUduz9Q==;
Content-Disposition: inline
In-Reply-To: <20230704122224.16257-1-jack@suse.cz>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Alasdair Kergon <agk@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Anna Schumaker <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Darrick J. Wong" <djwong@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, David Sterba <dsterba@suse.com>, dm-devel@redhat.com, drbd-dev@lists.linbit.com, Gao Xiang <xiang@kernel.org>, Jack Wang <jinpu.wang@ionos.com>, Jaegeuk Kim <jaegeuk@kernel.org>, jfs-discussion@lists.sourceforge.net, Joern Engel <joern@lazybastard.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On Tue, Jul 04, 2023 at 02:21:28PM +0200, Jan Kara wrote:
> +struct bdev_handle *blkdev_get_handle_by_dev(dev_t dev, blk_mode_t mode,
> +		void *holder, const struct blk_holder_ops *hops)
> +{
> +	struct bdev_handle *handle = kmalloc(sizeof(struct bdev_handle),
> +					     GFP_KERNEL);
> +	struct block_device *bdev;
> +
> +	if (!handle)
> +		return ERR_PTR(-ENOMEM);
> +	bdev = blkdev_get_by_dev(dev, mode, holder, hops);
> +	if (IS_ERR(bdev))
> +		return ERR_CAST(bdev);

Would we be better off with a handle->error (and a NULL return from this
function means "we couldn't allocate a handle")?  I have no objection
to what you've done here, just wondering if it might end up nicer for
the users.

