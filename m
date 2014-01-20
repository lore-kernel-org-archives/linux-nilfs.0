From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/4] nilfs-utils: new feature to skip inefficient gc
Date: Mon, 20 Jan 2014 14:54:20 +0400
Message-ID: <1390215260.3034.87.camel@slavad-ubuntu>
References: <cover.1390139797.git.andreas.rohner@gmx.net>
	 <1390211015.3034.54.camel@slavad-ubuntu> <52DCFC61.7050608@gmx.net>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=jZY2Ejz5CxyxMNUMx+FcoF5ysvcU9wf+eIlKhxYepoY=;
	b=WVXoYYjXqhJe3NmWsAEcTbWwJ3Mc9z5u55oF6lNJux4fnZNxlSntRyFvMV4U3Xye/059R88dbpxzG6y6T/7Ev9CBtBSsjb+Psc+m7AAB+zci/NhOqtGYUDfM4OV90wEk;
In-Reply-To: <52DCFC61.7050608-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2014-01-20 at 11:37 +0100, Andreas Rohner wrote:

> > I think that it really needs to test this patchset by xfstests and
> > fsstress (part of LTP test suite) tools. What do you think?
> > 
> > Moreover, I think that it makes sense to use well-known benchmark suite
> > (or several) for testing and estimation.
> 
> Yes you are right. I will try to use another benchmark. But it is hard
> to use well-known benchmarks to test the GC, because they are designed
> to test different things. Either not enough data is written and the GC
> never starts or too much and the benchmark crashes with a "not enough
> space left on the device" error.

I don't know concrete reasons of such crashes. But namely efficient GC
policy should resolve such issues, from my point of view. :)

Usually, stable and mature file system should pass through xfstests and
fsstress without any trouble. Namely, such success is our goal, I think.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
