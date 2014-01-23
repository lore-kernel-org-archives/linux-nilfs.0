From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 4/5] nilfs-utils: add support for NILFS_IOCTL_SET_SUINFO ioctl
Date: Thu, 23 Jan 2014 20:49:29 +0300
Message-ID: <62FA32DB-83AC-4570-BD73-618C169390FE@dubeyko.com>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <72f8c37258d08ba9793b0c1bb0374dd8efcd4756.1390310509.git.andreas.rohner@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=LroJPxguBGGyCBbDE7j6QAza8zGtsZbGxNHJVgy5hg0=;
	b=B+SkYvjI09mhqGOzWeSBvE6EBN5S1pkAOG/nXT7g5+HKMSLDEjN13L3YXR8YbwUwy4k2iPzpmtRs31qTIJGnnZXUgn5r9thaKKFytKct/DicOrmlb3FkIPqoJunoPXrc;
In-Reply-To: <72f8c37258d08ba9793b0c1bb0374dd8efcd4756.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Jan 21, 2014, at 4:59 PM, Andreas Rohner wrote:

[snip]
> diff --git a/lib/gc.c b/lib/gc.c
> index 0b0e2d6..ebbe0ca 100644
> --- a/lib/gc.c
> +++ b/lib/gc.c
> @@ -29,6 +29,10 @@
> #include <syslog.h>
> #endif	/* HAVE_SYSLOG_H */
> 
> +#if HAVE_SYS_TIME_H
> +#include <sys/time.h>
> +#endif	/* HAVE_SYS_TIME */
> +
> #include <errno.h>
> #include <assert.h>
> #include <stdarg.h>
> @@ -615,7 +619,10 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
> {
> 	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv;
> 	sigset_t sigset, oldset, waitset;
> -	ssize_t n, ret = -1;
> +	ssize_t n, i, ret = -1;
> +	__u32 freeblocks;
> +	struct nilfs_suinfo_update *supv;
> +	struct timeval tv;
> 
> 	if (nsegs == 0)
> 		return 0;
> @@ -678,6 +685,41 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
> 		goto out_lock;
> 	}
> 
> +	freeblocks = (nilfs_get_blocks_per_segment(nilfs) * n)
> +				- (nilfs_vector_get_size(vdescv)
> +				+ nilfs_vector_get_size(bdescv));
> +
> +	/* if there are less free blocks than the
> +	 * minimal threshold try to update suinfo
> +	 * instead of cleaning */
> +	if (freeblocks < minblocks * n) {
> +		ret = gettimeofday(&tv, NULL);
> +		if (ret < 0)
> +			goto out_lock;
> +
> +		supv = malloc(sizeof(struct nilfs_suinfo_update) * n);

Is it enough to allocate memory without zeroing?
Do you free allocated memory in the case of error? 

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
