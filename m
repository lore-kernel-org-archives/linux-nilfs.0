From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v5 5/6] nilfs-utils: add optimized version of
 nilfs_xreclaim_segments
Date: Fri, 07 Feb 2014 14:34:24 +0900 (JST)
Message-ID: <20140207.143424.27783987.konishi.ryusuke@lab.ntt.co.jp>
References: <cover.1391692941.git.andreas.rohner@gmx.net>
	<a2aaefaedbeee6fd8727c2f3bfec5f2a0a048941.1391692941.git.andreas.rohner@gmx.net>
	<20140207.135656.15669706.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140207.135656.15669706.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 07 Feb 2014 13:56:56 +0900 (JST), Ryusuke Konishi wrote:
> On Thu,  6 Feb 2014 15:17:25 +0100, Andreas Rohner wrote:
>> @@ -1415,6 +1419,17 @@ static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
>>  		nilfs_cleanerd_progress(cleanerd, stat.cleaned_segs);
>>  		cleanerd->fallback = 0;
>>  		cleanerd->retry_cleaning = 0;
>> +
>> +		*ndone = stat.cleaned_segs;
>> +	} else if (stat.deferred_segs > 0) {
>> +		for (i = 0; i < stat.deferred_segs; i++)
>> +			syslog(LOG_DEBUG, "segment %llu deferred",
>> +			       (unsigned long long)segnums[i]);
>> +		nilfs_cleanerd_progress(cleanerd, stat.deferred_segs);
>> +		cleanerd->fallback = 0;
>> +		cleanerd->retry_cleaning = 0;
>> +
>> +		*ndone = stat.deferred_segs;
>>  	} else {
>>  		syslog(LOG_DEBUG, "no segments cleaned");
>>  
>> @@ -1428,8 +1443,9 @@ static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
>>  		} else {
>>  			cleanerd->retry_cleaning = 0;
>>  		}
>> +		*ndone = 0;
> 
> This condition judgment supposes that stat.deferred_segs and
> stat.cleaned_segs are exclusive.  It is correct in the current
> implementation, but I don't want to define the semantics of
> nilfs_xreclaim_segment() as such.
> 
> Can you rewrite this patch ?
> Or, I will change this post handling.
> 

Uum, it needs to introduce another semantics or new arguments
to realize this since we don't know which segments are 
deferred.

I am thinking of doing this by sorting segnum[] array as follows:

 - cleand segs:
    segnum[0] .. segnum[cleaned_segs - 1]

 - deferred segs:
    segnum[cleaned_segs] .. segnum[cleaned_segs + deferred_segs - 1]

 - prorected segs:
    segnum[cleaned_segs + deferred_segs] ..
      segnum[cleaned_segs + deferred_segs + protected_segs - 1]

Actually, protected segments are moved behind segnums of cleaned
segments in the current implementation.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
