From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 08/12] fs: export fs_holder_ops
Date: Thu, 3 Aug 2023 15:16:39 +0200
Message-ID: <20230803131639.eq6i7hq7mo4nvinr@quack3>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=u354+D6fXMwflzIguDkXJwfsSkO6vRI2JZd9gBpk1w8=; b=TzP3KvYs7yhz1z2EgDViSM6BwI
 NiwA2Svv/fppkFCjAavWSqymyTCx1i0Fe1mJGaX9+mFQvV2c9djC7K1u9Eu+vzMCbZRpdmycyuds7
 iWis/32U/N7Z7jPOO/iJMEWf7/vvXdsrMlFOQtDokoAH1hM8kPIbyAOUC/jEPy/fDKTI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=u354+D6fXMwflzIguDkXJwfsSkO6vRI2JZd9gBpk1w8=; b=ACpvFHyPyKWnw70Zoi4IpA36to
 r9k8yCsOYMgC3F65TKorb8xAkwjqiZMAkjWN+aFKtPBLTEd3TmfM/EpEfuA763j+fk3bEtkHvSYGD
 jJtRXkDgGz37f+Q/twIkl2siIVoQB/wK6j2oNuuxLy1KU0Si14zCPEjDx4mKMT0pJa5U=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1691068600; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=u354+D6fXMwflzIguDkXJwfsSkO6vRI2JZd9gBpk1w8=;
 b=OInI+ey5VB7bzlioGeMTFK6cIMQcbmPzuBjm1cod6P5t4UnAeQVLtUmUu1ow9TDDPGWiPS
 atDqYLDfOQiSeLf9a8Mxe+jzJt4kWnT5rRiebmQjJeWOqxCO++WGDUVBxHjKk+yd1qbRDm
 s/39yG0lPvvzKys6HDoWqHVcWWAMeF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1691068600;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=u354+D6fXMwflzIguDkXJwfsSkO6vRI2JZd9gBpk1w8=;
 b=SmreZ91bm3h8DRDbHSeo79QkJcwnmaQYt9hiZl0HQQG8+NzwgUM1M7+nZhg4RER1VLY2aq
 a6c0libI9aZYmsBQ==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-9-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, Jaegeuk Kim <jaegeuk@kernel.org>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-btrfs@vger.kernel.org

On Wed 02-08-23 17:41:27, Christoph Hellwig wrote:
> Export fs_holder_ops so that file systems that open additional block
> devices can use it as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/super.c             | 3 ++-
>  include/linux/blkdev.h | 2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 0cda4af0a7e16c..dac05f96ab9ac8 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1244,9 +1244,10 @@ static void fs_mark_dead(struct block_device *bdev)
>  	up_read(&sb->s_umount);
>  }
>  
> -static const struct blk_holder_ops fs_holder_ops = {
> +const struct blk_holder_ops fs_holder_ops = {
>  	.mark_dead		= fs_mark_dead,
>  };
> +EXPORT_SYMBOL_GPL(fs_holder_ops);
>  
>  static int set_bdev_super(struct super_block *s, void *data)
>  {
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ed44a997f629f5..83262702eea71a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1464,6 +1464,8 @@ struct blk_holder_ops {
>  	void (*mark_dead)(struct block_device *bdev);
>  };
>  
> +extern const struct blk_holder_ops fs_holder_ops;
> +
>  /*
>   * Return the correct open flags for blkdev_get_by_* for super block flags
>   * as stored in sb->s_flags.
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
