From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Sat, 18 Jan 2014 21:11:16 +0300
Message-ID: <2F4C7008-E7E7-45F6-AD68-C4B1A51FB1DA@dubeyko.com>
References: <CEFFE8EC.9A4A%markt@netqa.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=BgA8qO0qy0RMxOraRRXTeDBuaj/OKs8jqFoIVNSEPc0=;
	b=GmuLm7ghFhgV7hLOcW46WRjZDJ09JQ3qUDqc1lEGTUGiywnkU3j20KQCKwpe46hZolVDOaWY8sxQd4nYQ1VoDvw0TpYPz0TJP2FER+RxB9aLNHMk47/sUFVeOHFwFBfk;
In-Reply-To: <CEFFE8EC.9A4A%markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mark Trumpold <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>
Cc: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


On Jan 18, 2014, at 7:25 PM, Mark Trumpold wrote:

> Hi Clemens and group,
> 
> Good information.  So, is it true that the logging/cow nature of
> nilfs actually improves wear leveling by having 'writes spread out
> evenly'?

Of course, COW policy is much better for flash than in-place update.
But even if NILFS2 (or any other file system) uses COW approach then
namely FTL does wear-leveling. And namely FTL's algorithms define
wear-leveling efficiency. So, I don't think that NILFS2 can improve
wear-leveling. COW policy can leave FTL "cold" and to give opportunity
not to use sophisticated algorithms of wear-leveling and using spare
pool of erase blocks. But, moreover, it is very desirable to use TRIM
command with COW policy also for improving FTL efficiency and
performance.

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
