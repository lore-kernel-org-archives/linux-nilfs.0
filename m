From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [RFC] nilfs2: double bio_put() in nilfs_end_bio_write()
Date: Sun, 21 Jul 2013 00:40:43 +0300
Message-ID: <20130720214043.GC5636@mwanda>
References: <20130719092603.GB22147@longonot.mountain>
 <8D04BC36-EF1A-4ED9-86CC-50F17A0EAA11@dubeyko.com>
Mime-Version: 1.0
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8D04BC36-EF1A-4ED9-86CC-50F17A0EAA11@dubeyko.com>
Sender: kernel-janitors-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, kernel-janitors@vger.kernel.org

On Sat, Jul 20, 2013 at 01:10:23PM +0400, Vyacheslav Dubeyko wrote:
> > diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> > index dc9a913..a660fd7 100644
> > --- a/fs/nilfs2/segbuf.c
> > +++ b/fs/nilfs2/segbuf.c
> > @@ -346,7 +346,8 @@ static void nilfs_end_bio_write(struct bio *bio, int err)
> > 	if (err == -EOPNOTSUPP) {
> > 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
> > 		bio_put(bio);
> > -		/* to be detected by submit_seg_bio() */
> > +		/* to be detected by nilfs_segbuf_submit_bio() */
> > +		return;
> 
> I think that simple return from the function is not right way. As I understand the code,
> then we increment error count in segbuf's sb_err field and signalize about completion of
> operation. So, from my viewpoint, it needs to remove the bio_put() call for the case of
> (err == -EOPNOTSUPP) instead of return from function.
> 

Do you think you could send that patch and give me a reported-by
tag?  I feel weird signing off on it when I don't really understand
this code...

regards,
dan carpenter
