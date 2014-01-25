From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 4/5] nilfs-utils: add support for
 NILFS_IOCTL_SET_SUINFO ioctl
Date: Sun, 26 Jan 2014 03:52:08 +0900 (JST)
Message-ID: <20140126.035208.213987573.konishi.ryusuke@lab.ntt.co.jp>
References: <72f8c37258d08ba9793b0c1bb0374dd8efcd4756.1390310509.git.andreas.rohner@gmx.net>
	<20140125.032633.184837411.konishi.ryusuke@lab.ntt.co.jp>
	<52E2C643.3070704@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52E2C643.3070704-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 24 Jan 2014 21:00:03 +0100, Andreas Rohner wrote:
> On 2014-01-24 19:26, Ryusuke Konishi wrote:
>> You should design the new reclaim function so that it turns off the
>> logic using nilfs_set_suinfo() once nilfs_set_suinfo() returned a
>> status code < 0 and errno was ENOTTY.
>> 
>> This fallback logic is needed to keep compatibility for old kernel.
> 
> Thanks for your review. I am quite devastated how much needs to be fixed
> :). I implemented most of your suggestions. I will test them tomorrow
> and compose a new version of the patch set.
> 
>> In addition, whether applying the optimization or not, should be
>> selectable in /etc/nilfs_cleanerd.conf.
> 
> You can set the two options to 0, which would completely disable the
> optimization.
> 
> # Minimum number of free blocks before a segment
> # can be cleaned. Set to 0 to disable it.
> min_free_blocks_threshold	0
> 
> # Minimum number of free blocks before a segment
> # can be cleaned. Set to 0 to disable it.
> # if clean segments < min_clean_segments
> mc_min_free_blocks_threshold	0
> 
> Is that enough or should I add an additional switch, like the use_mmap
> switch?

Yes, please do so.  The flag name would be "use_set_suinfo"
(NILFS_OPT_SET_SUINFO flag for nilfs object)

If nilfs_set_suinfo() returned error with errno=ENOTTY, the gc library
should automatically turns it off (with a warning message).

If NILFS_OPT_SET_SUINFO was off from the start, this optimization
should be never tried regardless of the above threshold values.

And, for the above theshold declarations, proper default values should
be written in nilfs_cleanerd.conf.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
