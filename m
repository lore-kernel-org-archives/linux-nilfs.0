From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [PATCH] nilfs2: remove double bio_put() in
 nilfs_end_bio_write() for BIO_EOPNOTSUPP error
Date: Tue, 23 Jul 2013 11:46:51 +0400
Message-ID: <1374565611.2220.11.camel@slavad-ubuntu>
References: <1374480134.5175.6.camel@slavad-ubuntu>
	 <20130723.032458.480817929.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=q7ZL2jNm4PkTEg9yddcY4fYDgye2DudS3Y1vbOAtIrA=;
	b=mJa4HqfamDq4FWpBUi/cuHH5guoUO19JL0zIjYDFAlgoZ/ldVRgFTHsEucor+WOgGJC+PYYetHSdKBueQilsIbvWUdepdlXFJdHU7Ah+zYyU3kAHI3ckFPfJE2LFRYBT;
In-Reply-To: <20130723.032458.480817929.konishi.ryusuke@lab.ntt.co.jp>
Sender: kernel-janitors-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, DanCarpenter <dan.carpenter@oracle.com>, linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org, akpm@linux-foundation.org

Hi Ryusuke,

On Tue, 2013-07-23 at 03:24 +0900, Ryusuke Konishi wrote:

[snip]
> 
> Thank you for following the issue.  I reviewed the code around bio.
> 
> In conclusion, Dan Carpenter's patch looks correct because
> nilfs_segbuf_submit_bio() does not increment the number of flying bio
> (segbuf->sb_nbio) for EOPNOTSUPP/BIO_EOPNOTSUPP case.
> 

I worry that nilfs_end_bio_write() is called asynchronously. And, as I
understand, the BIO_EOPNOTSUPP flag is set during nilfs_end_bio_write()
call. It means for me that sometimes segbuf->sb_nbio will be not
incremented in nilfs_segbuf_submit_bio() but sometimes this field can be
incremented and for BIO_EOPNOTSUPP case.

> If nilfs_end_bio_write() function reaches the complete() call for the
> EOPNOTSUPP/BIO_EOPNOTSUPP case (as the current implementation), the
> number of complete() calls and that of wait_for_complete() will not
> balance.
> 

I think that it is dangerous to return without complete() call because
of asynchronous nature of nilfs_end_bio_write() call.

What do you think?

With the best regards,
Vyacheslav Dubeyko.

> Do you have a comment?
> 
> Regards,
> Ryusuke Konishi
> 
> > ---
> >  fs/nilfs2/segbuf.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> > index dc9a913..5bacf46 100644
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
> > -- 
> > 1.7.9.5
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


