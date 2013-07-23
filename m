From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH] nilfs2: remove double bio_put() in
 nilfs_end_bio_write() for BIO_EOPNOTSUPP error
Date: Wed, 24 Jul 2013 02:24:50 +0900 (JST)
Message-ID: <20130724.022450.27782168.konishi.ryusuke@lab.ntt.co.jp>
References: <1374480134.5175.6.camel@slavad-ubuntu>
	<20130723.032458.480817929.konishi.ryusuke@lab.ntt.co.jp>
	<1374565611.2220.11.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1374565611.2220.11.camel@slavad-ubuntu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, DanCarpenter <dan.carpenter@oracle.com>, linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org, akpm@linux-foundation.org

On Tue, 23 Jul 2013 11:46:51 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> On Tue, 2013-07-23 at 03:24 +0900, Ryusuke Konishi wrote:
> 
> [snip]
>> 
>> Thank you for following the issue.  I reviewed the code around bio.
>> 
>> In conclusion, Dan Carpenter's patch looks correct because
>> nilfs_segbuf_submit_bio() does not increment the number of flying bio
>> (segbuf->sb_nbio) for EOPNOTSUPP/BIO_EOPNOTSUPP case.
>> 
> 
> I worry that nilfs_end_bio_write() is called asynchronously. And, as I
> understand, the BIO_EOPNOTSUPP flag is set during nilfs_end_bio_write()
> call. It means for me that sometimes segbuf->sb_nbio will be not
> incremented in nilfs_segbuf_submit_bio() but sometimes this field can be
> incremented and for BIO_EOPNOTSUPP case.
> 
>> If nilfs_end_bio_write() function reaches the complete() call for the
>> EOPNOTSUPP/BIO_EOPNOTSUPP case (as the current implementation), the
>> number of complete() calls and that of wait_for_complete() will not
>> balance.
>> 
> 
> I think that it is dangerous to return without complete() call because
> of asynchronous nature of nilfs_end_bio_write() call.
> 
> What do you think?

nilfs_end_bio_write() may be called either synchronously or
asynchronously as bio->bi_end_io().  It may be called when
submit_bio() fails or when bio is terminated asynchronously.

Yes, the current nilfs_end_bio_write() implementation is confusing
and dangerous for the EOPNOTSUPP case.

I think nilfs_end_bio_write() should be modified so that
segbuf->sb_nbio is incremented in either case.


Thanks,
Ryusuke Konishi
