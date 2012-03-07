From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Re: Questions on nilfs_cleanerd
Date: Wed, 07 Mar 2012 09:31:05 +0000
Message-ID: <4F572AD9.3080705@bobich.net>
References: <CAHmELnXB7LFwDRR53G_kCWb9t5wfWQOXDq=0xRC5bh9Z3TJuuw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHmELnXB7LFwDRR53G_kCWb9t5wfWQOXDq=0xRC5bh9Z3TJuuw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

These sound similar to the questions/concerns I raised a while back.

> 1) Does the daemon read/write the entire drive to look for dead blocks to clean?

Yes - sequentially (and then it rolls over to the beginning again).

> 2) What if there aren't any dead blocks to clean and the free space in
> the drive is still less than 10% (the default min_clean_segments in
> the conf file), does the daemon still process the drive? If so, how do
> I change the cleaning interval so that it doesn't process the drive as
> often?

The only worthwhile suggestion I heard is to set the minimum history 
retention rate (the FS is continuously snapshotting) to 1 day. That way 
you can guarantee the churn rate will never exceed the capacity of the 
disk per day. Not ideal, but at least it puts some kind of a hard limit 
on how quickly it'll waste your flash - at the expense of making the 
problem of the non-determinism of free space a little worse.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
