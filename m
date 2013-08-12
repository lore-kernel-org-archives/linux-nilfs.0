From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: remove double bio_put() in
 nilfs_end_bio_write() for BIO_EOPNOTSUPP error
Date: Mon, 12 Aug 2013 17:16:28 +0400
Message-ID: <1376313388.2298.33.camel@slavad-ubuntu>
References: <1374847154.3671.70.camel@slavad-ubuntu>
	 <20130727.120232.356926182.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=Id8iNLjaxpNDjsOLcGpUjk7GzynahSEWrzO66VYz3ng=;
	b=hAiKxj2XJspPfc6r8iKBJFkLVEI/lytC5cMxMvm4VS1RwSw4Jnco8u481I6TurtW3kKVT+JjKqMd0sydczm2qDy39W5EJXsS2rvSJjEQSYL2gCQWVAuuLPK3sQYZDvyP;
In-Reply-To: <20130727.120232.356926182.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: DanCarpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hi Ryusuke,

On Sat, 2013-07-27 at 12:02 +0900, Ryusuke Konishi wrote:

> > From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> > Subject: [PATCH v2] nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
> > 
> > This patch removes double call of bio_put() in nilfs_end_bio_write()
> > for the case of BIO_EOPNOTSUPP error detection. The issue was found
> > by Dan Carpenter and he suggests first version of the fix too.
> > 
> > Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> > CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> > ---
> >  fs/nilfs2/segbuf.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> > index dc9a913..0b09ec9 100644
> > --- a/fs/nilfs2/segbuf.c
> > +++ b/fs/nilfs2/segbuf.c
> > @@ -345,8 +345,7 @@ static void nilfs_end_bio_write(struct bio *bio, int err)
> >  
> >  	if (err == -EOPNOTSUPP) {
> >  		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
> > -		bio_put(bio);
> > -		/* to be detected by submit_seg_bio() */
> > +		/* to be detected by nilfs_segbuf_submit_bio() */
> >  	}
> >  
> >  	if (!uptodate)
> > @@ -377,12 +376,13 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
> >  	bio->bi_private = segbuf;
> >  	bio_get(bio);
> >  	submit_bio(mode, bio);
> > +	segbuf->sb_nbio++;
> >  	if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
> 
> > +		segbuf->sb_nbio--;
> 
> This decrement looks wrong.
> 

I tried to understand your vision but I am thinking that my patch is
correct. Maybe, I missed something in my considerations. I describe my
vision in more details.

> Otherwise, your change of nilfs_segbuf_submit_bio() is just a
> equivalent transformation and doesn't fix problem, that is, a mismatch
> of the number of calls between complete() and wait_for_completion().
> 
> In your patch, nilfs_end_bio_write() function calls the complete()
> routine as before even if it received an EOPNOTSUPP error.
> 
> In that case, segbuf->sb_nbio must be incremented to call
> wait_for_completion() the right number of times.
> 

I moved incrementing of sb_nbio nearly after submit_bio(mode, bio). So,
firstly, we call submit_bio(mode, bio) and segbuf->sb_nbio++. Then,
because of asynchronous nature of nilfs_end_bio_write() call, we have
two alternatives: (1) nilfs_end_bio_write() detects that BIO_EOPNOTSUPP
flag is set; (2) BIO_EOPNOTSUPP flag isn't set because bio is not
processed yet or we haven't error.

If nilfs_end_bio_write() method would detect -EOPNOTSUPP error then it
set BIO_EOPNOTSUPP flag, increment sb_err field and to call complete(). 

So, if we detect that BIO_EOPNOTSUPP flag is set in
nilfs_segbuf_submit_bio() then we decrement sb_nbio and to return from
nilfs_segbuf_submit_bio() with error. And if we had submitted
successfully some bios before then it will need to wait theirs
completion.

Otherwise, if BIO_EOPNOTSUPP flag is not set yet during check in
nilfs_segbuf_submit_bio() then sb_nbio is remained incremented. And, for
example, nilfs_segbuf_wait() can end correctly the cycle with
wait_for_completion() call. We will know about error during bio
processing because of sb_err was incremented in nilfs_end_bio_write().

So, I suppose that my logic is right. Please, correct me if I am wrong.

What do you think?

By the way, why sb_err has atomic_t type but sb_nbio is simple int type?
Maybe, sb_nbio should be atomic_t type too?

With the best regards,
Vyacheslav Dubeyko.


> Note that wait_for_completion() is called based on the count of
> segbuf->sb_nbio even if nilfs_segbuf_submit_bio() returns an error.
> This is performed through the following path:
> 
>             nilfs_segbuf_submit_bio
>           nilfs_segbuf_submit_bh
>         nilfs_segbuf_write
>       nilfs_write_logs
>     nilfs_segctor_write
>   nilfs_segctor_do_construct
>     nilfs_segctor_abort_construction
>       nilfs_wait_on_logs
>         nilfs_segbuf_wait
>           wait_for_completion
>             (repeated for the number of times of segbuf->sb_nbio)
> 
> 
> If you think this is a separate problem, then it should be fixed in
> another patch and nilfs_segbuf_submit_bio() should not be touched in
> this patch.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
