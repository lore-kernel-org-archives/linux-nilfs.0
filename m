From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Sun, 19 Jan 2014 02:08:36 +0300
Message-ID: <04877EE1-F5BF-41CE-AC92-CD9C3ED0B8A4@dubeyko.com>
References: <W9375626839227141389894521@atl4webmail02>	<1389940315.2731.16.camel@slavad-ubuntu> <20140118.104703.356941870.konishi.ryusuke@lab.ntt.co.jp> <52DA696D.6010206@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=Ks827cMZCyaKpVLlTvqISygvZ3GnOLPYDGOgkn+3H+U=;
	b=q6lNJPFEDd1FBLYLWFc+eiUXaHjNUH2BmrIa87X5pH/ppAgpVFDnw4r79Ji8ta7GpuPPqBvm1NOJ5F9KQbP6b5JFEwAIjolRYunGo0SsHS96SbY5u0Z4T9STz6kWlB69;
In-Reply-To: <52DA696D.6010206-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


On Jan 18, 2014, at 2:45 PM, Andreas Rohner wrote:

> If you are interested I could clean up my code and submit a patch set
> for review. I am sure there are lots of things, that need to be changed,
> but maybe it can give you some ideas...
> 
> It would also be possible, to improve timestamp by allowing the cleaner
> to abort if there is nothing to gain from cleaning a particular segment.
> Instead it could just updated the su_lastmod in the SUFILE without doing
> anything else. This would be a fairly simple change. I could provide a
> patch for that too.
> 

I think that it is very desirable to share patches for the review on early
stages because it is possible to achieve a valuable results by means of
open and continuos discussion. So, you are welcome to share your
vision and your patches.

As I remember, I had made many remarks about your approach and about
your code last time. So, I hope that you rework your approach significantly.

> Regards,
> Andreas Rohner
> 
> [1] https://www.dropbox.com/s/3ued8g5xaktnpbq/replay_parallel_ssd_line.pdf

To be honest, I completely misunderstand this diagram. It is hard to understand
it without additional description, from my point of view.

> [2] http://iotta.snia.org/historical_section?tracetype_id=2
> [3]
> https://www.dropbox.com/s/nwfixlzzzvf93v2/replay_parallel_stats_write.pdf

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
