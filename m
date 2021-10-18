From: Christoph Hellwig <hch@lst.de>
Subject: Re: don't use ->bd_inode to access the block device size v3
Date: Mon, 18 Oct 2021 19:49:01 +0200
Message-ID: <20211018174901.GA3990@lst.de>
References: <20211018101130.1838532-1-hch@lst.de> <4a8c3a39-9cd3-5b2f-6d0f-a16e689755e6@kernel.dk> <20211018171843.GA3338@lst.de> <2f5dcf79-8419-45ff-c27c-68d43242ccfe@kernel.dk>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2f5dcf79-8419-45ff-c27c-68d43242ccfe@kernel.dk>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.ke

On Mon, Oct 18, 2021 at 11:40:51AM -0600, Jens Axboe wrote:
>  static inline loff_t bdev_nr_bytes(struct block_device *bdev)
>  {
> -	return i_size_read(bdev->bd_inode);
> +	return bdev->bd_nr_sectors;

This hunk needs to go into bdev_nr_sectors, and the bdev_nr_bytes
probably wants to call bdev_nr_sectors and do the shifting.
