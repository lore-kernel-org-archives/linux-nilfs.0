From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: remove double bio_put() in
 nilfs_end_bio_write() for BIO_EOPNOTSUPP error
Date: Sat, 27 Jul 2013 12:02:32 +0900 (JST)
Message-ID: <20130727.120232.356926182.konishi.ryusuke@lab.ntt.co.jp>
References: <1374847154.3671.70.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374847154.3671.70.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: DanCarpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hi Vyacheslav,
On Fri, 26 Jul 2013 17:59:14 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> I changed place of increment operation of segbuf->sb_nbio in
> nilfs_segbuf_submit_bio() and adding decrement operation for
> BIO_EOPNOTSUPP case in second version of the patch.
> 
> Could you share your opinion about this version of the patch?
> 
> With the best regards,
> Vyacheslav Dubeyko.
> ---
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH v2] nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
> 
> This patch removes double call of bio_put() in nilfs_end_bio_write()
> for the case of BIO_EOPNOTSUPP error detection. The issue was found
> by Dan Carpenter and he suggests first version of the fix too.
> 
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> ---
>  fs/nilfs2/segbuf.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> index dc9a913..0b09ec9 100644
> --- a/fs/nilfs2/segbuf.c
> +++ b/fs/nilfs2/segbuf.c
> @@ -345,8 +345,7 @@ static void nilfs_end_bio_write(struct bio *bio, int err)
>  
>  	if (err == -EOPNOTSUPP) {
>  		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
> -		bio_put(bio);
> -		/* to be detected by submit_seg_bio() */
> +		/* to be detected by nilfs_segbuf_submit_bio() */
>  	}
>  
>  	if (!uptodate)
> @@ -377,12 +376,13 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
>  	bio->bi_private = segbuf;
>  	bio_get(bio);
>  	submit_bio(mode, bio);
> +	segbuf->sb_nbio++;
>  	if (bio_flagged(bio, BIO_EOPNOTSUPP)) {

> +		segbuf->sb_nbio--;

This decrement looks wrong.

Otherwise, your change of nilfs_segbuf_submit_bio() is just a
equivalent transformation and doesn't fix problem, that is, a mismatch
of the number of calls between complete() and wait_for_completion().

In your patch, nilfs_end_bio_write() function calls the complete()
routine as before even if it received an EOPNOTSUPP error.

In that case, segbuf->sb_nbio must be incremented to call
wait_for_completion() the right number of times.

Note that wait_for_completion() is called based on the count of
segbuf->sb_nbio even if nilfs_segbuf_submit_bio() returns an error.
This is performed through the following path:

            nilfs_segbuf_submit_bio
          nilfs_segbuf_submit_bh
        nilfs_segbuf_write
      nilfs_write_logs
    nilfs_segctor_write
  nilfs_segctor_do_construct
    nilfs_segctor_abort_construction
      nilfs_wait_on_logs
        nilfs_segbuf_wait
          wait_for_completion
            (repeated for the number of times of segbuf->sb_nbio)


If you think this is a separate problem, then it should be fixed in
another patch and nilfs_segbuf_submit_bio() should not be touched in
this patch.


Regards,
Ryusuke Konishi


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
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
