From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v4 6/6] nilfs-utils: add a no_timeout flag to enable faster
 loop
Date: Thu, 06 Feb 2014 16:07:00 +0100
Message-ID: <52F3A514.6090501@gmx.net>
References: <cover.1391566347.git.andreas.rohner@gmx.net>	<cover.1391566347.git.andreas.rohner@gmx.net>	<43f9673512b7a2e95d3036f2e829aa80fb2cca03.1391566347.git.andreas.rohner@gmx.net> <20140206.101641.184822830.konishi.ryusuke@lab.ntt.co.jp> <52F39E20.8000803@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52F39E20.8000803-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-02-06 15:37, Andreas Rohner wrote:
> On 2014-02-06 02:16, Ryusuke Konishi wrote:
>> On Wed,  5 Feb 2014 03:16:39 +0100, Andreas Rohner wrote:
>>> This patch adds a flag, that enables the GC to skip the timeout in
>>> certain situations. For example if the cleaning of some segments
>>> was deferred to a later time, then no real progress has been
>>> made. Apart from reading a few summary blocks, no data was read or
>>> written to disk. In this situation it makes sense to skip the
>>> normal timeout once and immediately try to clean the next set of
>>> segments.
>>>
>>> Unfortunately it is not possible, to directly continue the cleaning
>>> loop, because this would lead to an unresponsive GC process.
>>> Therefore the timeout is simply set to 0 seconds.
>>>
>>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>>> ---
>>>  sbin/cleanerd/cleanerd.c | 27 ++++++++++++++++-----------
>>>  1 file changed, 16 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
>>> index 1374e38..e1bd558 100644
>>> --- a/sbin/cleanerd/cleanerd.c
>>> +++ b/sbin/cleanerd/cleanerd.c
>>> @@ -167,6 +167,7 @@ struct nilfs_cleanerd {
>>>  	int running;
>>>  	int fallback;
>>>  	int retry_cleaning;
>>> +	int no_timeout;
>>
>> Corresponding comment is missing for this one, too.
>>
>>>  	int shutdown;
>>>  	long ncleansegs;
>>>  	struct timeval cleaning_interval;
>>> @@ -894,7 +895,7 @@ static int nilfs_cleanerd_recalc_interval(struct nilfs_cleanerd *cleanerd,
>>>  	interval = nilfs_cleanerd_cleaning_interval(cleanerd);
>>>  	/* timercmp() does not work for '>=' or '<='. */
>>>  	/* curr >= target */
>>> -	if (!timercmp(&curr, &cleanerd->target, <)) {
>>> +	if (!timercmp(&curr, &cleanerd->target, <) || cleanerd->no_timeout) {
>>>  		cleanerd->timeout.tv_sec = 0;
>>>  		cleanerd->timeout.tv_usec = 0;
>>>  		timeradd(&curr, interval, &cleanerd->target);
>>> @@ -1395,6 +1396,7 @@ static int nilfs_cleanerd_clean_segments(struct nilfs_cleanerd *cleanerd,
>>>  		       "number: %m");
>>>  		goto out;
>>>  	}
>>> +	cleanerd->no_timeout = 0;
>>
>> This one is needed for the else case of nilfs_cleanerd_clean_loop() ?
>>
>>                 if (ns > 0) {
>>                         ret = nilfs_cleanerd_clean_segments(
>>                                 cleanerd, segnums, ns, sustat.ss_prot_seq,
>>                                 prottime, &ndone);
>>                         if (ret < 0)
>>                                 return -1;
>>                 } else {
>>                         cleanerd->retry_cleaning = 0;
>> + 			cleanerd->no_timeout = 0;
>>                 }
> 
> It is important to make sure that no_timeout is set to 1 for only one
> iteration of nilfs_cleanerd_clean_loop. Otherwise it would permanently
> disable the timeout. But you are right, this is probably not a good
> place to do it. In version 5 I moved it.

Sorry I misunderstood you there. Yes it is definitely needed in the else
case of nilfs_cleanerd_clean_loop. In version 5 I moved it to the top of
the loop altogether.

Regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
