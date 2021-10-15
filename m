From: Anton Altaparmakov <anton@tuxera.com>
Subject: Re: [PATCH 28/30] ntfs: use sb_bdev_nr_blocks
Date: Fri, 15 Oct 2021 14:35:40 +0000
Message-ID: <7644804B-2081-4A1E-A40D-9A5C7BF72E2E@tuxera.com>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-29-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20211015132643.1621913-29-hch@lst.de>
Content-Language: en-US
Content-ID: <3668CC17B52D274985AE4DAF6C11620E@ex13.tuxera.com>
List-ID: <linux-nilfs.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kernel.org

Hi Christoph,

Looks good, thank you.

Best regards,

	Anton

> On 15 Oct 2021, at 14:26, Christoph Hellwig <hch@lst.de> wrote:
> 
> Use the sb_bdev_nr_blocks helper instead of open coding it and clean up
> ntfs_fill_super a bit by moving an assignment a little earlier that has
> no negative side effects.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Acked-by: Anton Altaparmakov <anton@tuxera.com>

> ---
> fs/ntfs/super.c | 8 +++-----
> 1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 0d7e948cb29c9..5ae8de09b271b 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -2772,13 +2772,12 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
> 	ntfs_debug("Set device block size to %i bytes (block size bits %i).",
> 			blocksize, sb->s_blocksize_bits);
> 	/* Determine the size of the device in units of block_size bytes. */
> -	if (!i_size_read(sb->s_bdev->bd_inode)) {
> +	vol->nr_blocks = sb_bdev_nr_blocks(sb);
> +	if (!vol->nr_blocks) {
> 		if (!silent)
> 			ntfs_error(sb, "Unable to determine device size.");
> 		goto err_out_now;
> 	}
> -	vol->nr_blocks = i_size_read(sb->s_bdev->bd_inode) >>
> -			sb->s_blocksize_bits;
> 	/* Read the boot sector and return unlocked buffer head to it. */
> 	if (!(bh = read_ntfs_boot_sector(sb, silent))) {
> 		if (!silent)
> @@ -2816,8 +2815,7 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
> 			goto err_out_now;
> 		}
> 		BUG_ON(blocksize != sb->s_blocksize);
> -		vol->nr_blocks = i_size_read(sb->s_bdev->bd_inode) >>
> -				sb->s_blocksize_bits;
> +		vol->nr_blocks = sb_bdev_nr_blocks(sb);
> 		ntfs_debug("Changed device block size to %i bytes (block size "
> 				"bits %i) to match volume sector size.",
> 				blocksize, sb->s_blocksize_bits);
> -- 
> 2.30.2
> 



-- 
Anton Altaparmakov <anton at tuxera.com> (replace at with @)
Lead in File System Development, Tuxera Inc., http://www.tuxera.com/
Linux NTFS maintainer

