From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: add mount option that reduces super block writes
Date: Thu, 30 Jan 2014 09:36:37 +0300
Message-ID: <127C78C3-9D47-439C-9639-263BC453D98D@dubeyko.com>
References: <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com> <cover.1391048231.git.andreas.rohner@gmx.net> <75ceb45c464097ab556baacf2d15d6ae4b792bb2.1391048231.git.andreas.rohner@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=3VIigz07dAq1Fzq98yieqMV7uFAy1eOWasgizfMf5w0=;
	b=ZyCufFXHsvP83+9x2mzFjKkm8bc4hH7pv66tEPUJkrlsGc5vsdC5Pl8h0CACFMCy1JRTMJ+pVFAcnXl6YOnZeW6PGlyhd6KGTTx+V8rQsA/Hxj5jQiiMp0uxWEJP7Dkz;
In-Reply-To: <75ceb45c464097ab556baacf2d15d6ae4b792bb2.1391048231.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,

On Jan 30, 2014, at 5:47 AM, Andreas Rohner wrote:

> This patch introduces a mount option bad_ftl that disables the
> periodic overwrites of the super block to make the file system better
> suitable for bad flash memory with a bad FTL. The super block is only
> written at umount time. So if there is a power outage the file system
> needs to be recovered by a linear scan of all segment summary blocks.
> 
> The linear scan is only necessary if the file system wasn't umounted
> properly. So the normal mount time is not affected.
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
> ---
> fs/nilfs2/segbuf.c        |  3 ++-
> fs/nilfs2/segment.c       |  3 ++-
> fs/nilfs2/super.c         | 10 +++++++--
> fs/nilfs2/the_nilfs.c     | 54 ++++++++++++++++++++++++++++++++++++++++++++---
> include/linux/nilfs2_fs.h |  4 +++-
> 5 files changed, 66 insertions(+), 8 deletions(-)
> 

As far as I can judge, conceptually it is simply rollback of the fix [1].

Thanks,
Vyacheslav Dubeyko.

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a9bae189542e71f91e61a4428adf6e5a7dfe8063

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
