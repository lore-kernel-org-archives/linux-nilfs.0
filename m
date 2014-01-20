From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/4] nilfs-utils: cleanerd: add custom error value to
 enable fast retry
Date: Mon, 20 Jan 2014 14:46:04 +0400
Message-ID: <1390214764.3034.81.camel@slavad-ubuntu>
References: <cover.1390139797.git.andreas.rohner@gmx.net>
	 <a203a9d8105dc1b449e469158fb07fbffbf2da18.1390139797.git.andreas.rohner@gmx.net>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=pb+rT0oOTPhe46tduJYiwdGgjcn+LM3tPTXtKWggqao=;
	b=KG/bFDFz5LFNsFgF/wzwqKWWApsylph3+1jcH9z8LmFDEvNIe6JvG6Z+LonbBciPJY7kBDg+WVE3O4xGMQvXz0v0qOcos8b41Sk5iq6ikJkXTzeL+v5d6qlj5xK3y5Wi;
In-Reply-To: <a203a9d8105dc1b449e469158fb07fbffbf2da18.1390139797.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 2014-01-19 at 15:01 +0100, Andreas Rohner wrote:
> This patch adds the custom error value EGCTRYAGAIN, which signals to
> cleanerd to retry the gc process as soon as possible with no timeout.
> 
> If the GC decides not to do any real work and only changes a few
> metadata bytes, there is no need for a timeout. Furthermore if the GC is
> running, there is probably not enough free space on the device and it is
> crucial to retry quickly.

Now GC really decrease performance very frequently. So, you suggest
don't use timeout. :) I am afraid that it can decrease performance more.
Why do you think in opposite manner?

If we doesn't relate with idle system state or I/O load then rigid
timeout can really decrease performance, as far as I can judge. The main
problem of GC that it works in the background of main file system
operations and, as a result, decrease the whole performance. So, how the
"no-timeout" does correlate with main file system operation or with the
whole system load? 

Could you describe your vision how it will work?

I think that it makes sense to have in this patch as declarations as
implementation of concept. Otherwise, it is hard to understand the goal
of such suggestion.

> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  include/nilfs_gc.h       |  2 ++
>  sbin/cleanerd/cleanerd.c | 10 +++++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/nilfs_gc.h b/include/nilfs_gc.h
> index 72e9947..7628ce1 100644
> --- a/include/nilfs_gc.h
> +++ b/include/nilfs_gc.h
> @@ -27,4 +27,6 @@ static inline int nilfs_suinfo_reclaimable(const struct nilfs_suinfo *si)
>  
>  extern void (*nilfs_gc_logger)(int priority, const char *fmt, ...);
>  
> +#define EGCTRYAGAIN 513

Is it really need to add special constant? Why don't use EAGAIN?

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
