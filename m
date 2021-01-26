From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 03/17] blk-crypto: use bio_kmalloc in
 blk_crypto_clone_bio
Date: Tue, 26 Jan 2021 13:51:04 -0800
Message-ID: <YBCOyBxDnSsT4jzU@sol.localdomain>
References: <20210126145247.1964410-1-hch@lst.de>
 <20210126145247.1964410-4-hch@lst.de>
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
 bh=PVXe/0mnYC9gBx+P4ki/TAy9pdcHveLUHCBkOxpzoLI=; b=DlB/8lOc0iUrGh9yGtKqyPelkt
 heKM75meyu58E7w8neX4ivJDmTXlD9/2kU79t79abCEklXHxkS/gJbw2sJYkZodYkaYUsEM8mQLhm
 kDwbdXnaSG5UtWm6S+TxWW9f3QJNGnHEAt0D8bT1Nbz9W7YAK2xYoZwCdQMp1dPX16zk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=PVXe/0mnYC9gBx+P4ki/TAy9pdcHveLUHCBkOxpzoLI=; b=eYWM1KfJ+9FUjGWQ3iNVYDyWKe
 mUrvI9pEDttmlWCsezwJxJjeEsq8IxQhJVOtYZ5DotuCYoIIOXtDhYB4T/46SZJzA78OFZYXz5jg4
 wAy8hNBa70BDjDY222Sc95afBmgMvCwZKDYwumcpAv4s8QGiVlUPu0ugxJWnOTeyM1aQ=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1611697866;
 bh=uF4Zh493+gdGT/Bg0kWKqJydeGxsHWjFoA7xBs16rsw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=lCGLIreDb/5Hwx8N2JmnAiiS0jiqRFkx5lWB+dYgajzTx5WDO2x1R1zbHYLyQO1UE
 98ScSw7v1shjHJr3DWN8DeVEKxjccGxz8l94yiaaEhvMgOjW92D6rHh7wIPb+Z8Wcf
 /WrH9o9CZLj9VLpBgdfMlPa9On6Ygs1IpZ1Ijf2DQsb5xhrrGFiJVmYaEU6R3mgkut
 QaKR1+XYY5LF7MORkDaq36e+R/ZWRbwey+gnJIfZYHPT0K+eh+0B9d6nRjRnNDd/S0
 dIZkNMAj/KUbyyLBEMzujKws37eYXRnxT13Nwk2S64RN7RIaBpTrze3+70kHOv4aD1
 nwTbNcB4SZj3w==
Content-Disposition: inline
In-Reply-To: <20210126145247.1964410-4-hch@lst.de>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Naohiro Aota <naohiro.aota@wdc.com>, linux-nilfs@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Josef Bacik <josef@toxicpanda.com>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, drbd-dev@tron.linbit.com, Jaegeuk Kim <jaegeuk@kernel.org>, Coly Li <colyli@suse.de>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-nfs@vger.kernel.org, Song Liu <song@kernel.org>, Philipp Reisner <philipp.reisner@linbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-btrfs@vger.kernel.org

On Tue, Jan 26, 2021 at 03:52:33PM +0100, Christoph Hellwig wrote:
> Use bio_kmalloc instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-crypto-fallback.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
> index 50c225398e4d60..e8327c50d7c9f4 100644
> --- a/block/blk-crypto-fallback.c
> +++ b/block/blk-crypto-fallback.c
> @@ -164,7 +164,7 @@ static struct bio *blk_crypto_clone_bio(struct bio *bio_src)
>  	struct bio_vec bv;
>  	struct bio *bio;
>  
> -	bio = bio_alloc_bioset(GFP_NOIO, bio_segments(bio_src), NULL);
> +	bio = bio_kmalloc(GFP_NOIO, bio_segments(bio_src));
>  	if (!bio)
>  		return NULL;
>  	bio->bi_bdev		= bio_src->bi_bdev;
> -- 

Looks good,

Reviewed-by: Eric Biggers <ebiggers@google.com>
