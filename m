From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 2/5] nilfs-utils: cleanerd: add custom error value to enable fast retry
Date: Thu, 23 Jan 2014 20:49:21 +0300
Message-ID: <FE7FB751-68F4-48C3-A97A-782F4F6E69FE@dubeyko.com>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <e9d3dd17318a994fe7e2c100368212e0b4029e13.1390310509.git.andreas.rohner@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=h6nBFIQK5T9o4BDJhuNCg0sxTzEu60ghp33XM0Z35kc=;
	b=fnUpzgetTeHKvM3z+i9K6icCz6VpqoUnUmdQ1iMvuwYSj74KNJRhf3MAuH225uLBkf4mQxHIeRF71bouu4NjjggGe4708B/92fwxPVspH2y4nReiQlfdrwpQXbpDJjun;
In-Reply-To: <e9d3dd17318a994fe7e2c100368212e0b4029e13.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Jan 21, 2014, at 4:59 PM, Andreas Rohner wrote:

> This patch adds the custom error value EGCTRYAGAIN, which signals to
> cleanerd to retry the GC process as soon as possible with no timeout.
> 
> If the GC decides not to do any real work and only changes a few
> metadata bytes, there is no need for a timeout. Furthermore if the GC is
> running, there is probably not enough free space on the device and it is
> crucial to retry quickly.
> 

What does it defend us from eating 100% of CPU?

> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
> include/nilfs_gc.h       |  2 ++
> sbin/cleanerd/cleanerd.c | 10 +++++++++-
> 2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/nilfs_gc.h b/include/nilfs_gc.h
> index 72e9947..7628ce1 100644
> --- a/include/nilfs_gc.h
> +++ b/include/nilfs_gc.h
> @@ -27,4 +27,6 @@ static inline int nilfs_suinfo_reclaimable(const struct nilfs_suinfo *si)
> 
> extern void (*nilfs_gc_logger)(int priority, const char *fmt, ...);
> 
> +#define EGCTRYAGAIN 513

Why do you declare a new constant? What does it means value of 513?
What bad in EAGAIN?

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
