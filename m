From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 1/2] nilfs2: add nilfs_sufile_trim_fs to trim clean segs
Date: Mon, 17 Feb 2014 10:17:57 +0100
Message-ID: <5301D3C5.6040704@gmx.net>
References: <cover.1392470644.git.andreas.rohner@gmx.net>	<cover.1392470644.git.andreas.rohner@gmx.net>	<02d463460388a9bdc1413aa4d6fdfa5a402b9452.1392470644.git.andreas.rohner@gmx.net> <20140217.120000.397306175.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140217.120000.397306175.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-02-17 04:00, Ryusuke Konishi wrote:
>> +	if (end > nilfs->ns_nsegments)
>> +		end = nilfs->ns_nsegments;
> 
> Yes, this adjustment is what we should do here, but 'end' segnum was
> rounded down to segment alighment before.  So, it should be:
> 
>   if (end >= nilfs->ns_nsegments)
> 	end = nilfs->ns_nsegments - 1;
> 
>> +	if (end == segnum)
>> +		goto out;
> 
> and
> 
>   if (end < segnum)
> 	goto out;
> 
>> +
>> +	down_read(&NILFS_MDT(sufile)->mi_sem);
>> +
>> +	while (segnum < end) {
> 
> and
> 
>   while (segnum <= end) {
> 
>> +		n = min_t(unsigned long,
>> +			  segusages_per_block -
>> +				  nilfs_sufile_get_offset(sufile, segnum),
>> +			  end - segnum);
> 
> Then, we can reuse nilfs_sufile_segment_usages_in_block() to calculate
> 'n'.

Actually I don't think that is correct. What if range->start = 0 and
range->end = 8MB. Then segnum = 0 and end = 1. Your code would discard
segment 0 and segment 1, whereas my version would discard only segment
0, which seems to be more reasonable.

br,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
