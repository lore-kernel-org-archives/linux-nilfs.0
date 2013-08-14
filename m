From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH v3 2/2] nilfs2: fix issue with counting number of bio
 requests for BIO_EOPNOTSUPP error detection
Date: Wed, 14 Aug 2013 13:52:43 +0900 (JST)
Message-ID: <20130814.135243.168045626.konishi.ryusuke@lab.ntt.co.jp>
References: <1376401851.2274.10.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1376401851.2274.10.camel@slavad-ubuntu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: akpm@linux-foundation.org, Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: DanCarpenter <dan.carpenter@oracle.com>, linux-nilfs@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, kernel-janitors@vger.kernel.org

On Tue, 13 Aug 2013 17:50:51 +0400, Vyacheslav Dubeyko wrote:
> From: Vyacheslav Dubeyko <slava@dubeyko.com>
> Subject: [PATCH v3 2/2] nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection
> 
> This patch fixes the issue with improper counting number of
> flying bio requests for BIO_EOPNOTSUPP error detection case.
> 
> The sb_nbio must be incremented exactly the same number of times as
> complete() function was called (or will be called) because
> nilfs_segbuf_wait() will call wail_for_completion() for the number of
> times set to sb_nbio:
> 
> do {
>     wait_for_completion(&segbuf->sb_bio_event);
> } while (--segbuf->sb_nbio > 0);
> 
> Two functions complete() and wait_for_completion() must be called the
> same number of times for the same sb_bio_event. Otherwise,
> wait_for_completion() will hang or leak.
> 
> Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
> CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

I confirmed that this fixes the leak of wait_for_completion() for the
BIO_EOPNOTSUPP error detection case.

Andrew, please send this upstream along with the companion patch
titled "nilfs2: remove double bio_put() in nilfs_end_bio_write() for
BIO_EOPNOTSUPP error".


Thanks,
Ryusuke Konishi


> CC: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/nilfs2/segbuf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> index 5bacf46..2d8be51 100644
> --- a/fs/nilfs2/segbuf.c
> +++ b/fs/nilfs2/segbuf.c
> @@ -376,12 +376,12 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
>  	bio->bi_private = segbuf;
>  	bio_get(bio);
>  	submit_bio(mode, bio);
> +	segbuf->sb_nbio++;
>  	if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
>  		bio_put(bio);
>  		err = -EOPNOTSUPP;
>  		goto failed;
>  	}
> -	segbuf->sb_nbio++;
>  	bio_put(bio);
>  
>  	wi->bio = NULL;
> -- 
> 1.7.9.5
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
