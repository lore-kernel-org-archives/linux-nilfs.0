From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/11] block/bfq-iosched.c: use "false" rather than
 "BLK_RW_ASYNC"
Date: Thu, 10 Feb 2022 11:02:22 +0100
Message-ID: <20220210100222.f2nmwwb5pcfmejvw@quack3.lan>
References: <164447124918.23354.17858831070003318849.stgit@noble.brown>
 <164447147264.23354.2763356897218946255.stgit@noble.brown>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1644487344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lcBtRTov0U4scR5M2Iy2myhqZeOwAIyV54RcClAbhV4=;
        b=UVJHxaJMKmE/DO/JZe3iVbVw3GQe2kQmip1zYFYiRYyI1pZTASyk8ODPUH85ZCuqzCIWsi
        rV6USU5SNQRHNVVtN7czjs/tg9jgYBrlYPUuVDHO/aShUUH/4xIgSIpkWiWmMUD14J4lqn
        gHBmV7fgdq0Mk5zS8kvpWhMAHojnEdM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1644487344;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lcBtRTov0U4scR5M2Iy2myhqZeOwAIyV54RcClAbhV4=;
        b=3uOBgMN4Wr+d5mCyhO6cp6IQhYZtOH8ULuhOgZdIotrLORbzqWHkWV4veZpJWP42oTgmJG
        NOB6bjhLKtWqFVCQ==
Content-Disposition: inline
In-Reply-To: <164447147264.23354.2763356897218946255.stgit@noble.brown>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lis

On Thu 10-02-22 16:37:52, NeilBrown wrote:
> bfq_get_queue() expects a "bool" for the third arg, so pass "false"
> rather than "BLK_RW_ASYNC" which will soon be removed.
> 
> Acked-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: NeilBrown <neilb@suse.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bfq-iosched.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 0c612a911696..4e645ae1e066 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -5448,7 +5448,7 @@ static void bfq_check_ioprio_change(struct bfq_io_cq *bic, struct bio *bio)
>  	bfqq = bic_to_bfqq(bic, false);
>  	if (bfqq) {
>  		bfq_release_process_ref(bfqd, bfqq);
> -		bfqq = bfq_get_queue(bfqd, bio, BLK_RW_ASYNC, bic, true);
> +		bfqq = bfq_get_queue(bfqd, bio, false, bic, true);
>  		bic_set_bfqq(bic, bfqq, false);
>  	}
>  
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
