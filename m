From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 0/2] refactor reclaim function
Date: Tue, 04 Feb 2014 21:46:43 +0100
Message-ID: <52F151B3.2080905@gmx.net>
References: <1391539046-13046-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <20140205.034242.281476472.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140205.034242.281476472.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On 2014-02-04 19:42, Ryusuke Konishi wrote:
> Hi Andreas,
> On Wed,  5 Feb 2014 03:37:24 +0900, Ryusuke Konishi wrote:
>> This series adds nilfs_xreclaim_segment() api function to the GC
>> library, and modifies cleneard so that it uses the extended API
>> function.
>>
>> nilfs_xreclaim_segment() is an enhanced version of the existing GC
>> function (nilfs_reclaim_segment).
>>
>> The nilfs_xreclaim_segment() works like nilfs_reclaim_segment()
>> except the following differences:
>>
>>  - takes GC parameters in an expandable way.
>>    (with nilfs_reclaim_params struct)
>>
>>  - can output statistics information of selected segments,
>>    for instance, the number live or defunct blocks, etc.
>>
>>  - takes a dry-run argument
>>
>>  - no longer returns the number of cleaned segments.  The value will
>>    be stored in cleaned_segs member of nilfs_reclaim_stat struct.
>>
>> This series is intended to give a framework for the forthcoming
>> enhancement of garbage collection library and cleanerd daemon.
>>
>> nilfs_reclaim_segment() function is still maintained for compatibility
>> reason.
> 
> Can you rebase your GC patchset on this?

Yes, I'll send you the patches as soon as possible.

Best regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
