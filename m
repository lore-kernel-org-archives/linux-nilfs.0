From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 4/5] nilfs-utils: add support for NILFS_IOCTL_SET_SUINFO
 ioctl
Date: Fri, 24 Jan 2014 21:00:03 +0100
Message-ID: <52E2C643.3070704@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net>	<cover.1390310509.git.andreas.rohner@gmx.net>	<72f8c37258d08ba9793b0c1bb0374dd8efcd4756.1390310509.git.andreas.rohner@gmx.net> <20140125.032633.184837411.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140125.032633.184837411.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-24 19:26, Ryusuke Konishi wrote:
>> +	freeblocks = (nilfs_get_blocks_per_segment(nilfs) * n)
>> +				- (nilfs_vector_get_size(vdescv)
>> +				+ nilfs_vector_get_size(bdescv));
>> +
>> +	/* if there are less free blocks than the
>> +	 * minimal threshold try to update suinfo
>> +	 * instead of cleaning */
>> +	if (freeblocks < minblocks * n) {
>> +		ret = gettimeofday(&tv, NULL);
>> +		if (ret < 0)
>> +			goto out_lock;
>> +
>> +		supv = malloc(sizeof(struct nilfs_suinfo_update) * n);
>> +		if (supv == NULL) {
>> +			ret = -1;
>> +			goto out_lock;
>> +		}
>> +
>> +		for (i = 0; i < n; ++i) {
>> +			supv[i].sup_segnum = segnums[i];
>> +			supv[i].sup_flags = 0;
>> +			nilfs_suinfo_update_set_lastmod(&supv[i]);
>> +			supv[i].sup_sui.sui_lastmod = tv.tv_sec;
>> +		}
>> +
>> +		ret = nilfs_set_suinfo(nilfs, supv, n);
>> +		free(supv);
>> +		if (ret >= 0) {
>> +			/* success, tell caller
>> +			 * to try another segment/s */
>> +			ret = -EGCTRYAGAIN;
>> +			goto out_lock;
>> +		}
> 
> You should design the new reclaim function so that it turns off the
> logic using nilfs_set_suinfo() once nilfs_set_suinfo() returned a
> status code < 0 and errno was ENOTTY.
> 
> This fallback logic is needed to keep compatibility for old kernel.

Thanks for your review. I am quite devastated how much needs to be fixed
:). I implemented most of your suggestions. I will test them tomorrow
and compose a new version of the patch set.

> In addition, whether applying the optimization or not, should be
> selectable in /etc/nilfs_cleanerd.conf.

You can set the two options to 0, which would completely disable the
optimization.

# Minimum number of free blocks before a segment
# can be cleaned. Set to 0 to disable it.
min_free_blocks_threshold	0

# Minimum number of free blocks before a segment
# can be cleaned. Set to 0 to disable it.
# if clean segments < min_clean_segments
mc_min_free_blocks_threshold	0

Is that enough or should I add an additional switch, like the use_mmap
switch?

br,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
