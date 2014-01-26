From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 4/5] nilfs-utils: add support for NILFS_IOCTL_SET_SUINFO
 ioctl
Date: Sun, 26 Jan 2014 12:24:06 +0100
Message-ID: <52E4F056.3020502@gmx.net>
References: <72f8c37258d08ba9793b0c1bb0374dd8efcd4756.1390310509.git.andreas.rohner@gmx.net>	<20140125.032633.184837411.konishi.ryusuke@lab.ntt.co.jp>	<52E2C643.3070704@gmx.net> <20140126.190004.443429632.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140126.190004.443429632.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-26 11:00, Ryusuke Konishi wrote:
> On Fri, 24 Jan 2014 21:00:03 +0100, Andreas Rohner wrote:
>> On 2014-01-24 19:26, Ryusuke Konishi wrote:
>>>> +		ret = nilfs_set_suinfo(nilfs, supv, n);
>>>> +		free(supv);
>>>> +		if (ret >= 0) {
>>>> +			/* success, tell caller
>>>> +			 * to try another segment/s */
>>>> +			ret = -EGCTRYAGAIN;
>>>> +			goto out_lock;
>>>> +		}
> 
> Returning -EGCTRYAGAIN looks confusing, since posix error code Exxxxx
> is usually stored in errno variable in userland.  It also looks a bit
> hacky.

True. Vyacheslav had similar concerns.

> How about handling this as follows ?
> 
>  - Add a new structure to return result of GC, for instance, as
>    follows:
> 
> struct nilfs_reclaim_status {
> 	unsigned int	ncleanedsegs; /* number of segments cleaned
> 					 with nilfs_clean_segments() */
> 	unsigned int	ndeferredsegs;/* number of segments deferred
> 					 with nilfs_set_suinfo() */
> 	unsigned long	nliveblocks;  /* sum of live virtual blocks and live
> 					 DAT blocks */
> 	unsigned long	ndeadblocks;  /* number of reclaimable blocks */
> 	unsigned long	nlivevblocks; /* live virtual blocks */
> 	unsigned long	nfreevblocks; /* freed virtual block addresses */
> 	...
> };
> 
>  - Use the structure as an argument of the "new" API function
>    (i.e. variant of nilfs_reclaim_segment() )
> 
>  - Rewrite the variant API function so that it returns a success value
>    (0) also for the EGCTRYAGAIN case.
> 
>  - Store other status information in nilfs_reclaim_status structures.
> 
> 
> And, I think adding nilfs_set_suinfo() API should be a separate patch.

Yes EGCTRYAGAIN is not necessary for the nilfs_set_suinfo() API to work.
It is a good idea to use a separate patch for this.

br,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
