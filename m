From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/4] nilfs-utils: cldconfig add an option to set minimal
 free blocks
Date: Mon, 20 Jan 2014 14:14:59 +0400
Message-ID: <1390212899.3034.66.camel@slavad-ubuntu>
References: <cover.1390139797.git.andreas.rohner@gmx.net>
	 <685e5c720189d1e451ed8a0d65581aa8c5a3f7f0.1390139797.git.andreas.rohner@gmx.net>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=kRlNlrU3xAOpw0Px9lrh+VFOW1NsCQNenKFlrk5g8FA=;
	b=mLMLqg/z8D9uqrmMA55LftsJpyoEkKHq3Qs7ytXoKEp887ckcLSPmUNNi4ggqFqm/8SikwycGnt5eHqB7TOj1AwJJo4dwvxPMRHj1JX96TDqhxn2LE9wvN60op3q1qWs;
In-Reply-To: <685e5c720189d1e451ed8a0d65581aa8c5a3f7f0.1390139797.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 2014-01-19 at 15:01 +0100, Andreas Rohner wrote:

It is expected "From: <author name and name>" and "Subject: <subject>"
in the begin of patch.

> With this option the user can specify the minimal number of free/dead
> blocks, which is a threshold for the GC. If there are less free blocks
> to gain from cleaning a segment than the specified number, the GC will
> abort and try again with a different segment.
> 

What will be under stress? I mean situation when we processed all
segments that it is valuable for cleaning on threshold basis. Then we
need to clean segments for space allocation but all "dirty" segments not
reasonable choice for cleaning because of threshold.

What will we have in situation when an user selects not proper value of
threshold?

I worried about situation of skipping sibling segments from cleaning. Is
NILFS2 driver really ready for this? Did you think about efficiency of
free space allocation after such cleaning and about file system
consistency? Are you sure that all will be good after such approach of
cleaning? I simply want to be sure that you have analyzed this.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
