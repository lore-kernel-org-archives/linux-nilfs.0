From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 23/29] block: use bdev_nr_sectors instead of open coding
 it in blkdev_fallocate
Date: Wed, 13 Oct 2021 12:44:18 +0200
Message-ID: <20211013104418.GG19200@quack2.suse.cz>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-24-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634121859; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zr+6GWAq4WHObb17AbfzF2g6D5dZWO9Bq1HBuEblypg=;
        b=eLskz6PijM+w1QR0FogCwoNbWHGIbDqPk11o5Plo63JrH+/zYhBLZAvjCjGbvg+FaHrAO1
        2MItOoVCCqy/eSD4BHnsY6nRdla76FH0BHq27f3sDbJ1DzV6pFCfyBZpRPpFGPRCCh0xa4
        czgRKzRX3m+40beJL4a/KrNBrdujeeM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634121859;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zr+6GWAq4WHObb17AbfzF2g6D5dZWO9Bq1HBuEblypg=;
        b=x5s0VxGQeYv5jpSqKQu6Szg9BQXfylxBjtyoa4NDCPTywZNk9ARh5l9vZobiI0QDQou1eF
        Tr8ZILBVFT/OSBDg==
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-24-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.ker

On Wed 13-10-21 07:10:36, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
