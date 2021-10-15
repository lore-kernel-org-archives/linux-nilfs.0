From: Anton Altaparmakov <anton@tuxera.com>
Subject: Re: [PATCH 02/30] block: add a bdev_nr_bytes helper
Date: Fri, 15 Oct 2021 14:37:41 +0000
Message-ID: <7C4AC4BD-B62D-41B3-AAF7-46125D1A1146@tuxera.com>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20211015132643.1621913-3-hch@lst.de>
Content-Language: en-US
Content-ID: <CA141EBD26CA2142955225C1A7459553@ex13.tuxera.com>
List-ID: <linux-nilfs.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kernel.org

Hi Christoph,

> On 15 Oct 2021, at 14:26, Christoph Hellwig <hch@lst.de> wrote:
> 
> Add a helpe to query the size of a block device in bytes.  This
> will be used to remove open coded access to ->bd_inode.

Matthew already pointed out the return type for bdev_nr_bytes() but also your commit message has a typo: "Add a helpe" -> "Add a helper".

Best regards,

	Anton

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> include/linux/genhd.h | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 082a3e5fd8fa1..f67db3c5a04b3 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -235,9 +235,14 @@ static inline sector_t get_start_sect(struct block_device *bdev)
> 	return bdev->bd_start_sect;
> }
> 
> +static inline sector_t bdev_nr_bytes(struct block_device *bdev)
> +{
> +	return i_size_read(bdev->bd_inode);
> +}
> +
> static inline sector_t bdev_nr_sectors(struct block_device *bdev)
> {
> -	return i_size_read(bdev->bd_inode) >> 9;
> +	return bdev_nr_bytes(bdev) >> SECTOR_SHIFT;
> }
> 
> static inline sector_t get_capacity(struct gendisk *disk)
> -- 
> 2.30.2
> 

