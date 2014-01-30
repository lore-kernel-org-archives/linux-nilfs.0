From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: add mount option that reduces super block writes
Date: Thu, 30 Jan 2014 14:27:15 +0300
Message-ID: <A6830DB2-DC73-4ACC-BE73-7A6EC1AC7C18@dubeyko.com>
References: <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com> <cover.1391048231.git.andreas.rohner@gmx.net> <75ceb45c464097ab556baacf2d15d6ae4b792bb2.1391048231.git.andreas.rohner@gmx.net> <127C78C3-9D47-439C-9639-263BC453D98D@dubeyko.com> <52E9EB06.1000504@gmx.net> <8DBE8E18-F678-44B0-A6A6-5AFEC227AA86@dubeyko.com> <52EA2002.1030809@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=xkA3GYavmHjdP8V6hXw2hSKBHMUQgTso5uQ1xM3MGt0=;
	b=rwUoskKNz2A0iOxE/2BC6e18pB4hQ48azMWsAhObxg/F+Zbd36qFcOXtjhBSh1Nyx4LNvMJy+8Awp/tG4FtP98PY64qFCZ/Tttkgis67lJXuHJvjJmMYIL13JtRNFxq3;
In-Reply-To: <52EA2002.1030809-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Jan 30, 2014, at 12:48 PM, Andreas Rohner wrote:

> 
> I have just finished a test with my  100 GB HDD and SSD. I filled it
> with dd until it was 100% full. Then I cut power to the machine and
> timed the following mount operation:
> 
> 100GB HDD:
> time sudo mount -o bad_ftl /dev/sda1 /mnt/
> 
> real	1m21.068s
> user	0m0.020s
> sys	0m0.770s
> 
> 100GB SSD:
> time sudo mount -o bad_ftl /dev/sdc1 /mnt/
> 
> real	0m2.124s
> user	0m0.010s
> sys	0m0.243s
> 
> So it looks quite bad for hard drives. To scan a 1 TB hard drive would
> take 13 minutes.
> 
> But a 1 TB SSD would only take 20 seconds!
> 

I think that it will be good to have comparable results for the same environment.
I mean, for example, measurement in different situations for SSD (without your
patch and this your patch). How much time do you need for scanning the whole SSD
by your approach? I think that comparison of linear scanning results for the whole
SSD drive and for sudden power-off situation can provide basis for consideration.
But sudden power-off situation can be different, I suppose.

Thanks,
Vyacheslav Dubeyko.

> I will test one of my SD cards next.
> 
> Regards,
> Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
