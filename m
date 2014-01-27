From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v3 0/4] nilfs-utils: shortcut for certain GC operations
Date: Mon, 27 Jan 2014 16:47:32 +0100
Message-ID: <52E67F94.9010208@gmx.net>
References: <cover.1390813175.git.andreas.rohner@gmx.net> <20140128.000336.27790167.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140128.000336.27790167.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-27 16:03, Ryusuke Konishi wrote:
> Hi Andreas,
> On Mon, 27 Jan 2014 10:58:52 +0100, Andreas Rohner wrote:
>> Hi,
>>
>> This is the third version of this patch set. It basically fixes a 
>> lot of bugs.
>>
>> v2->v3
>> * Alignment in nilfs_suinfo_update
>> * Add missing comments
>> * nilfs2: Extra validity checks in nilfs_sufile_set_suinfo
>> * nilfs2: Update sh_ncleansegs, sh_ndirtysegs if flags change
>> * nilfs2: Fix bugs in nilfs_sufile_set_suinfo
>> * nilfs2: Use vmalloc instead of ioctl_wrap_copy
>> * nilfs-utils: Separate nilfs_relaim_segments_with_threshold
>> * nilfs-utils: Allow different units for min_reclaimable_blocks
>> * nilfs-utils: Introduce flag to disable the optimization
>> * nilfs-utils: Disable optimization if kernel retruns ENOTTY
>> * nilfs-utils: Remove EGCTRYAGAIN error return code
>> * nilfs-utils: Rename option to min_reclaimable_blocks
>> v1->v2
>> * Implementation of NILFS_IOCTL_SET_SUINFO
>> * Added mc_min_free_blocks_threshold config option
>>   (if clean segments < min_clean_segments)
>> * Added new command line param for nilfs-clean
>> * Update man- and config-file
>>
>> This patch set adds an optimized version of 
>> nilfs_reclaim_segments, which has an additional parameter 
>> min_reclaimable. This parameter specifies the minimum number of 
>> reclaimable blocks in a segment, before it can be cleaned. If a 
>> segment is below this threshold, it is considered to be not worth 
>> cleaning, because all the live blocks would need to be moved to a 
>> new segment, which is expensive, and the number of reclaimable 
>> blocks is too low. But it is still necessary to update the segment 
>> usage information to turn the old segment into a new one.
>>     
>> This is basically a shortcut to cleaning the segment. It is still 
>> necessary to read the segment summary information, but the writing 
>> of the live blocks can be skipped if it's not worth it.
>>
>> Additionally new options are introduced for the configuration file 
>> and nilfs-clean to allow the user to specify the threshold. 
>>
>> This is potentially useful for all gc policies, but it is especially
>> beneficial for the timestamp policy. Lets assume for example a NILFS2
>> volume with 20% static files and lets assume these static files 
>> are in the oldest segments. The current timestamp policy will 
>> select the oldest segments and, since the data is static, move 
>> them mostly unchanged to new segments. After a while they will 
>> become the oldest segments again. Then timestamp will move them 
>> again. These moving operations are expensive and unnecessary.
>>
>> The benchmarks are currently running. I will give you the results
>> shortly.
> 
> The kernel patchset didn't apply to the mainline as is because
> Vyacheslav's ioctl commentary patch just has been merged.  Please
> rebase your patchset on the current master branch next time.  Also,
> nilfs_ioctl_set_suinfo() function needs summary comment as for the
> current master branch.

Sorry for that, I based it on 3.13. I will rebase it immediateley and
add the summary comment.

> Anyway, I will review the kernel patches first, and then look into
> the userland patches.

Thanks. By the way, is it ok to use one cover letter for both the
userland and kernel patches?

br,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
