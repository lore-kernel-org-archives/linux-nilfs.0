From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 02/30] block: add a bdev_nr_bytes helper
Date: Fri, 15 Oct 2021 14:35:15 +0100
Message-ID: <YWmDk8YQKVPRGBfR@casper.infradead.org>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-3-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KanmlaFBwV6DRdQ41vIsGhe17Tn0ouHRuztKUsQZtZ0=; b=Sp0mzcOz6fCy6w+SFxvFJT113O
        5glduGFb7LrPQcGlbPxTVXMdHUuiHlqKZMAdoOUuvr7VmdXF1ZROQXYx/SURx8NNGczFxd78OKEWX
        g1EVnRcaMy66kxGA0Ycz2sVxG+Jq6Xakmu96RSvhrCic177Aboi4kmhdgF1+i/MmTps4PefQxR1U9
        R0lWGSxbM9vlrOVzh3s4+nOS+3Fdq1Tv3nAaot4M9Z7iIxha6Lnwv+o1M6OB/txkN3fli+COyWBGO
        MCf3+V04TrhkegQ0Jg+SGb+t7IWveuPWDgrPUju8wVNJF/jSdrYZ56qZJb0uP40KoBw/AcVk6NLsV
        0KeMg3+w==;
Content-Disposition: inline
In-Reply-To: <20211015132643.1621913-3-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kern

On Fri, Oct 15, 2021 at 03:26:15PM +0200, Christoph Hellwig wrote:
> +static inline sector_t bdev_nr_bytes(struct block_device *bdev)
> +{
> +	return i_size_read(bdev->bd_inode);

Uh.  loff_t, surely?
