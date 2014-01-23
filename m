From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 2/5] nilfs-utils: cleanerd: add custom error value
 to enable fast retry
Date: Thu, 23 Jan 2014 20:08:45 +0100
Message-ID: <52E168BD.4090706@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <e9d3dd17318a994fe7e2c100368212e0b4029e13.1390310509.git.andreas.rohner@gmx.net> <FE7FB751-68F4-48C3-A97A-782F4F6E69FE@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <FE7FB751-68F4-48C3-A97A-782F4F6E69FE-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-23 18:49, Vyacheslav Dubeyko wrote:
> 
> On Jan 21, 2014, at 4:59 PM, Andreas Rohner wrote:
> 
>> This patch adds the custom error value EGCTRYAGAIN, which signals to
>> cleanerd to retry the GC process as soon as possible with no timeout.
>>
>> If the GC decides not to do any real work and only changes a few
>> metadata bytes, there is no need for a timeout. Furthermore if the GC is
>> running, there is probably not enough free space on the device and it is
>> crucial to retry quickly.
>>
> 
> What does it defend us from eating 100% of CPU?

Nothing really, but I don't think it's a big problem, because there is
no possibility that you have constant 100% CPU. For every segment the
timestamp is updated, so it will be protected by the protection period
for a while. But you could be right. Maybe it is better to use a smaller
timout instead of no timeout. I think I will change that in the next
version of my patch.

>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>> include/nilfs_gc.h       |  2 ++
>> sbin/cleanerd/cleanerd.c | 10 +++++++++-
>> 2 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/nilfs_gc.h b/include/nilfs_gc.h
>> index 72e9947..7628ce1 100644
>> --- a/include/nilfs_gc.h
>> +++ b/include/nilfs_gc.h
>> @@ -27,4 +27,6 @@ static inline int nilfs_suinfo_reclaimable(const struct nilfs_suinfo *si)
>>
>> extern void (*nilfs_gc_logger)(int priority, const char *fmt, ...);
>>
>> +#define EGCTRYAGAIN 513
> 
> Why do you declare a new constant? What does it means value of 513?
> What bad in EAGAIN?

I just thought that it's not a good idea to use an error code, that
really could be returned from some system call. 513 is just 512+1. I
wanted to make sure, that my error code does not conflict with any other
existing errors < 512.

Come to think of it, maybe you are right. I don't think that any of the
calls in nilfs_reclaim_segment would return EAGAIN. So we could use it
theoretically. But if a real error occurred, that returned EAGAIN for
some reason, we could end up with very undesirable results.

br,
Andreas Rohner


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
