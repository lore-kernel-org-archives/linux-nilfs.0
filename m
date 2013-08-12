From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2] nilfs2: remove double bio_put() in
 nilfs_end_bio_write() for BIO_EOPNOTSUPP error
Date: Mon, 12 Aug 2013 23:57:28 +0900 (JST)
Message-ID: <20130812.235728.12298149.konishi.ryusuke@lab.ntt.co.jp>
References: <1374847154.3671.70.camel@slavad-ubuntu>
	<20130727.120232.356926182.konishi.ryusuke@lab.ntt.co.jp>
	<1376313388.2298.33.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376313388.2298.33.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: DanCarpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Mon, 12 Aug 2013 17:16:28 +0400, Vyacheslav Dubeyko wrote:
>> Otherwise, your change of nilfs_segbuf_submit_bio() is just a
>> equivalent transformation and doesn't fix problem, that is, a mismatch
>> of the number of calls between complete() and wait_for_completion().
>> 
>> In your patch, nilfs_end_bio_write() function calls the complete()
>> routine as before even if it received an EOPNOTSUPP error.
>> 
>> In that case, segbuf->sb_nbio must be incremented to call
>> wait_for_completion() the right number of times.
>> 
> 
> I moved incrementing of sb_nbio nearly after submit_bio(mode, bio). So,
> firstly, we call submit_bio(mode, bio) and segbuf->sb_nbio++. Then,
> because of asynchronous nature of nilfs_end_bio_write() call, we have
> two alternatives: (1) nilfs_end_bio_write() detects that BIO_EOPNOTSUPP
> flag is set; (2) BIO_EOPNOTSUPP flag isn't set because bio is not
> processed yet or we haven't error.
> 
> If nilfs_end_bio_write() method would detect -EOPNOTSUPP error then it
> set BIO_EOPNOTSUPP flag, increment sb_err field and to call complete(). 
> 
> So, if we detect that BIO_EOPNOTSUPP flag is set in
> nilfs_segbuf_submit_bio() then we decrement sb_nbio and to return from
> nilfs_segbuf_submit_bio() with error. And if we had submitted
> successfully some bios before then it will need to wait theirs

sb_nbio must be incremented exactly the same number of times as
complete() function was called (or will be called) because
nilfs_segbuf_wait() will call wail_for_completion() for the number of
times set to sb_nbio:

        do {
	        wait_for_completion(&segbuf->sb_bio_event);
	} while (--segbuf->sb_nbio > 0);


Two functions complete() and wait_for_completion() must be called the
same number of times for the same sb_bio_event.  Otherwise,
wait_for_completion() will hang or leak.

In your patch, nilfs_end_bio_write() will call complete() even in the
case "(1) nilfs_end_bio_write() detects that BIO_EOPNOTSUPP flag is
set" (like the current implementation).  Therefore, sb_nbio must be
incremented for that count.


This looks another issue of the current implemention and the second
bug can be fixed as follows:

        submit_bio(mode, bio);
+       segbuf->sb_nbio++;
        if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
                bio_put(bio);
                err = -EOPNOTSUPP;
                goto failed;
        }
-       segbuf->sb_nbio++;
        bio_put(bio);



> By the way, why sb_err has atomic_t type but sb_nbio is simple int type?
> Maybe, sb_nbio should be atomic_t type too?

No, the current implementation is correct.

sb_err is incremented asynchronously by nilfs_end_bio_write(), so it
is implemented with atomic_t type.  On the other hand, sb_nbio is
operated sequentially and therefore it doesn't need to use atomic_t
type.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
