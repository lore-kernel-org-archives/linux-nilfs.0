From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 2/4] nilfs-utils: cleanerd: add custom error value to
 enable fast retry
Date: Mon, 20 Jan 2014 13:02:50 +0100
Message-ID: <52DD106A.5030502@gmx.net>
References: <cover.1390139797.git.andreas.rohner@gmx.net>	 <a203a9d8105dc1b449e469158fb07fbffbf2da18.1390139797.git.andreas.rohner@gmx.net> <1390214764.3034.81.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390214764.3034.81.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

Thank you for reviewing my patch set so thoroughly. I already have a few
new ideas to improve it from our exchange.

On 2014-01-20 11:46, Vyacheslav Dubeyko wrote:
> On Sun, 2014-01-19 at 15:01 +0100, Andreas Rohner wrote:
>> This patch adds the custom error value EGCTRYAGAIN, which signals to
>> cleanerd to retry the gc process as soon as possible with no timeout.
>>
>> If the GC decides not to do any real work and only changes a few
>> metadata bytes, there is no need for a timeout. Furthermore if the GC is
>> running, there is probably not enough free space on the device and it is
>> crucial to retry quickly.
> 
> Now GC really decrease performance very frequently. So, you suggest
> don't use timeout. :) I am afraid that it can decrease performance more.
> Why do you think in opposite manner?

I don't suggest to eliminate timeout in general. It just adds the option
for nilfs_reclaim_segment to skip the timeout once by returning the
custom error code -EGCTRYAGAIN. This is useful because if the number of
free blocks is below the threshold the cleaner won't write to the device
and won't free any segments, so it is important to retry another segment
quickly. I guess it could be reasonable to use a shorter timeout instead
of no timeout in this case.

> If we doesn't relate with idle system state or I/O load then rigid
> timeout can really decrease performance, as far as I can judge. The main
> problem of GC that it works in the background of main file system
> operations and, as a result, decrease the whole performance. So, how the
> "no-timeout" does correlate with main file system operation or with the
> whole system load? 
> 
> Could you describe your vision how it will work?

Well the GC uses the normal timeout for its normal operation. If the
number of free blocks is below the threshold it skips the current
segment or segments and returns -EGCTRYAGAIN to skip the timeout ONCE.

I thought it is good practice to separate a big patch into logical
units. That's why it is probably not clear what the intent is by just
looking at a single patch in the patch set. I will try to improve my
commit message to make it clearer.

Best regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
