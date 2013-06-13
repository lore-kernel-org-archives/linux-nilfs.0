From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Thu, 13 Jun 2013 14:01:55 +0400
Message-ID: <1371117715.2268.12.camel@slavad-ubuntu>
References: <1369809573.2253.31.camel@slavad-ubuntu>
	  <20130529.233757.27789741.konishi.ryusuke@lab.ntt.co.jp>
	  <1369894385.2255.8.camel@slavad-ubuntu>
	  <20130530.155543.480320022.konishi.ryusuke@lab.ntt.co.jp>
	 <1370501769.2202.36.camel@slavad-ubuntu>
	 <51B8DA8E.6020802@antoneliasson.se>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=vcaNpqXsMOak1lwL0gSfuOGMnHqCqpvsdRslcGVnpho=;
	b=GdrwmPYjnthBw37EkXFlubSCK9Dv/wzWuU2c7GYb6jUXKS8X5S/9EyFxUsR8JDV1xtDEbnR4kTLE5O5ifxbVoX0uvPoluobuMqp3N6Euv5TgwDREsm9tGZUNjIV7EweG;
In-Reply-To: <51B8DA8E.6020802-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2013-06-12 at 22:31 +0200, Anton Eliasson wrote:

[snip]
> > I tried to make LVM environment as it was described by Anton. But I
> > didn't catch the issue in this environment. So, I think that I haven't
> > properly aged NILFS2 volume state and I tried not proper workload. It
> > needs to think about proper workload more deeply. As I can see from
> > Anton's system log that it took place frequent update and git activity.
> > Moreover, update and git were nearly before crash:

> I'm not so sure that my issues are caused by aging of the filesystem. As 
> I described in my third e-mail on May 30 
> (http://article.gmane.org/gmane.comp.file-systems.nilfs.user/2957), I 
> was able to trash my new /home which was only a week old. I'm starting 
> to think it has something to do with either VMware or bup (which is git 
> based) or a combination of both.

As I understand, the issue takes place on GC side. This fact complicates
the situation because the real problem can be far from detected
symptoms. I mean that a real issue can occur earlier without detection.
So, I assume that possible reasons can be: (1) special file system aging
state; (2) race condition. Any of these reason can be reproduced only by
clear and strict reproducing path. So, I have to find the reproducing
path, firstly.

Soon, I'll finish the preparation of debugging output patch set. I hope
that this patch set can give more details about the issue by reproducing
it on your side.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
