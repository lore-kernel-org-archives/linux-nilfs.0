From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs_clean_segments: segment construction failed. (err=-2)
Date: Fri, 27 Jun 2014 10:30:46 +0400
Message-ID: <1403850646.2588.4.camel@slavad-CELSIUS-H720>
References: <53ABA8F3.3010606@gmail.com>
	 <A863805F-8398-42B1-9BEA-35D4425E2404@dubeyko.com>
	 <53ABB6F4.5050508@gmail.com> <1403789693.2609.14.camel@slavad-CELSIUS-H720>
	 <53ACF691.5090203@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=moGulafLFv5dRnLgEMB36rgw4O7JH838UFVj+9KdUvE=;
	b=ta1Ih6XlTFkqrkr3LmRXWO8lPIGU2vbbSaZcsRHyLMf4C5573gWHxBz5Ai/7PynJ3GRy7I1pKTDZWbzNc5/uxH85//9CvUo+/9Q57McybmBW5CA6JAt7oUxuXCs1nGbk;
In-Reply-To: <53ACF691.5090203-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dE <de.techno-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2014-06-27 at 10:14 +0530, dE wrote:

[snip]
> 
> I can confirm that at 4K block size, this issue never existed. It 
> started happening when I reduced the block size to improve write and 
> read seek performance when very small amounts of data was being 
> read/written.
> 
> Yes, the FS was made at the specified day, but it was running 
> continuously since then.
> 
> This problem triggers after running the programs for long amounts of 
> time. Like 1 day+ with GC running the background at low priority (idle 
> i/o). nilfs_cleanerd.conf --
> 
> clean_check_interval    300
> nsegments_per_clean     1
> mc_nsegments_per_clean  1
> cleaning_interval      0
> mc_cleaning_interval   0
> protection_period       0
> min_clean_segments      100%
> max_clean_segments      100%
> selection_policy        timestamp       # timestamp in ascend order
> retry_interval          300
> use_mmap
> log_priority            warning
> 
> As of the nature of the program which's using files on the FS, it reads 
> and writes very small amounts of data from random places on a set of 
> files (which are reasonably large). Then programs themselves are running 
> at either real time class or normal class.
> 
> The bug triggers when I exit the program (which are all of similar nature).
> 
> I tried to reproduce this issue by doing random write using the 'seeker' 
> tool, but it didn't trigger. So it triggers specifically on existing the 
> program.
> 
> You may like to install the Bitcoin qt wallet from your repositories 
> (maybe it's reproducible with bitcoind client also) and after a day or 2 
> of running with the above nilfs_cleanerd, try exiting the program. You 
> may trigger the bug.

Great. Thank you. I'll try to reproduce the issue.

One more question. Do you use this file system as rootfs or not? I
suppose that it's not rootfs file system, as I remember your previous
description of the issue.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
