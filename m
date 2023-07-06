From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/32] block: Provide blkdev_get_handle_* functions
Date: Thu, 6 Jul 2023 08:38:40 -0700
Message-ID: <ZKbgAG5OoHVyUKOG@infradead.org>
References: <20230629165206.383-1-jack@suse.cz>
 <20230704122224.16257-1-jack@suse.cz>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YwAEpZO7Vu5hoax5tz5QpnX5k8pjtsK6yDO/dOzPntw=; b=LJt1aHPpR1VtNNU97F662mFcBQ
        04pv5pjmhELPxcfY8IU2J9oyhfgQvItd1fUo/P+Wom3ADKBICTxeaU2ubravoUlJ9bJKThqcbtmZO
        YHZ6Bq5JNF5Oy1kZk0vGrojv9a9LNU4bL+WXTD5k/gljEqzdXg69aNBObe/lnHCHtRlMc6Ppc7Hqe
        +NefvxaKjDH4eBZ/aYpgK8N4uyEQGVFSG36iqC/zjMjHjPuCdtgFFvp4F+STCUxI3HsTMMx8Jecfh
        X5dQPxytEjbEWkMaTy11b/rkROV7wOirXDfTif06nI996QOXUgedgb0owSphnlvJb3u4X61SBTklq
        DymCsIxA==;
Content-Disposition: inline
In-Reply-To: <20230704122224.16257-1-jack@suse.cz>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Alasdair Kergon <agk@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Anna Schumaker <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Darrick J. Wong" <djwong@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, David Sterba <dsterba@suse.com>, dm-devel@redhat.com, drbd-dev@lists.linbit.com, Gao Xiang <xiang@kernel.org>, Jack Wang <jinpu.wang@ionos.com>, Jaegeuk Kim <jaegeuk@kernel.org>, jfs-discussion@lists.sourceforge.net, Joern Engel <joern@lazybastard.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On Tue, Jul 04, 2023 at 02:21:28PM +0200, Jan Kara wrote:
> Create struct bdev_handle that contains all parameters that need to be
> passed to blkdev_put() and provide blkdev_get_handle_* functions that
> return this structure instead of plain bdev pointer. This will
> eventually allow us to pass one more argument to blkdev_put() without
> too much hassle.

Can we use the opportunity to come up with better names?  blkdev_get_*
was always a rather horrible naming convention for something that
ends up calling into ->open.

What about:

struct bdev_handle *bdev_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
		const struct blk_holder_ops *hops);
struct bdev_handle *bdev_open_by_path(dev_t dev, blk_mode_t mode,
		void *holder, const struct blk_holder_ops *hops);
void bdev_release(struct bdev_handle *handle);

?
