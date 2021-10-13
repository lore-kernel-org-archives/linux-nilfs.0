From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 25/29] ext4: use sb_bdev_nr_blocks
Date: Wed, 13 Oct 2021 12:46:33 +0200
Message-ID: <20211013104633.GI19200@quack2.suse.cz>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-26-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634121993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Or278HaFHEJv4/IhQug3hRkzHhUD8W5YgLbP9FdDHU8=;
        b=igbm5YOuwvGUnm5YF9v3OxajvvQP7jBsiBdfXK5rgG5a6bYDqSa3nJFvVxE9ZDjgosFlir
        VwX4dh+eUwDv7Jdmf0TOwS6aEkmZoqgcOnZom2x4FySVNc8YFic+9884rXAg/s0JQrcfuQ
        kRxymIjtXZ63HsNGIhgkFuaKA5ZOxjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634121993;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Or278HaFHEJv4/IhQug3hRkzHhUD8W5YgLbP9FdDHU8=;
        b=aXuMntUzmnD5JLBsUCJJVzyYr5CaLfp9W5noNZX1vQovb0idmDG3YgACaOSj1ZlRTSNYY4
        7wEIQwm8Z7QhHLBw==
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-26-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.ker

On Wed 13-10-21 07:10:38, Christoph Hellwig wrote:
> Use the sb_bdev_nr_blocks helper instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
