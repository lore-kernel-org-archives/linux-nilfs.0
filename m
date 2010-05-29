From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Re: SSD and non-SSD Suitability
Date: Sat, 29 May 2010 09:45:39 +0100
Message-ID: <4C00D433.2010406@bobich.net>
References: <4BFCF55A.80205@bobich.net>	<87typspmiq.wl%jir@sekiba.com>	<4BFF91E7.9000102@bobich.net> <87d3wf17vj.wl%jir@sekiba.com> <4C00C745.6050903@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C00C745.6050903-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

David Arendt wrote:

>>>>> 4) As the data gets expired, and snapshots get deleted, this will 
>>>>> inevitably lead to fragmentation, which will de-linearize writes as they 
>>>>> have to go into whatever holes are available in the data. How does this 
>>>>> affect nilfs write performance?
>>>>>         
>>>> For now, my understanding, nilfs garbage collector moves the live (in use)
>>>> blocks to the end of logs, so holes are not created (it is correct?).
>>>> However, it leads another issue that garbage collector process, which is
>>>> nilfs_cleanerd, will consume the I/O.  This is major I/O performance
>>>> bottle neck current implementation.
>>>>       
>>> Since this moves files, it sounds like this could be a major issue for 
>>> flash media since it unnecessarily creates additional writes. Can this 
>>> be suppressed?
>>>     
>> You can simply kill the nilfs_clearnerd after you mount the nilfs partition.
>>   
> If you use the latest nilfs_utils, killing nilfs_cleanerd is no longer
> necessary. You can use mount -o nogc. This will not start
> nilfs_cleanerd. Another possibility is to let nilfs_cleanerd start and
> tweak min_free_segments and max_free_segments so that cleanerd will only
> do cleaning if necessary.

What about making the gc run only if the disk has been idle for, say, 
20ms, unless min_free_segments is reached?

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
