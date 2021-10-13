From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 21/29] reiserfs: use bdev_nr_sectors instead of open
 coding it
Date: Wed, 13 Oct 2021 12:43:43 +0200
Message-ID: <20211013104343.GF19200@quack2.suse.cz>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-22-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634121823; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=91hISCii4Or1ILPgadTSW2G7i/WxLx55yWUH14ngMGo=;
        b=urePYUhd5OF9+eOS15sOdNKf/9CEfoiJF0sOJ+CUtOdrV78ouAHrD22Jwd1x7RDJ1X7NXU
        38K6W/8xGxP7iJLbOT3v2KEmBRctpIhbWooGrkxGTpdozRprjw2uPy1C7rv4VVv0/JqU+P
        /z6fu4NATPhJE4NTFVWUnjzU7Jcj6qw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634121823;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=91hISCii4Or1ILPgadTSW2G7i/WxLx55yWUH14ngMGo=;
        b=iV9JFoqqPxqNVUQiZzwRblLXbUXiC4lcfVm33k6YuJt29JfUmlOuSAxx4ULbDL3QwDFt/o
        bWYhIgn68fkyB0Bw==
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-22-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.ker

On Wed 13-10-21 07:10:34, Christoph Hellwig wrote:
> Use the proper helper to read the block device size and remove two
> cargo culted checks that can't be false.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/reiserfs/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
> index 58481f8d63d5b..6c9681e2809f0 100644
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -1986,8 +1986,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
>  	 * smaller than the filesystem. If the check fails then abort and
>  	 * scream, because bad stuff will happen otherwise.
>  	 */
> -	if (s->s_bdev && s->s_bdev->bd_inode
> -	    && i_size_read(s->s_bdev->bd_inode) <
> +	if ((bdev_nr_sectors(s->s_bdev) << SECTOR_SHIFT) <
>  	    sb_block_count(rs) * sb_blocksize(rs)) {
>  		SWARN(silent, s, "", "Filesystem cannot be "
>  		      "mounted because it is bigger than the device");
> -- 
> 2.30.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
