From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Nilfs2 crash debugging
Date: Fri, 30 Aug 2013 09:58:53 +0400
Message-ID: <1377842333.2343.25.camel@slavad-ubuntu>
References: <51F2A8A4.4020400@antoneliasson.se>
	  <51F2A945.6050909@antoneliasson.se>
	  <9016EBD5-1E01-476F-B1B9-66AE593F4728@dubeyko.com>
	  <520CB032.2000602@antoneliasson.se>
	  <FEA41B6A-7D82-4563-AAF5-D5AFA3734D79@dubeyko.com>
	  <521A1C88.9080100@antoneliasson.se>
	 <1377510966.2621.3.camel@slavad-ubuntu> <521BA084.80901@antoneliasson.se>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=we3CE+9eB6oY3rm15D8e1B8EiZXgQL/b8YOvhhEwfaQ=;
	b=os049CP1BpDr9fnifB1VRnMbgx6FXi1HDmbFprdkHr+cy6Zxqn65likK1CR2grrOws6nzLqUZmTygmQMaY+l5/uYhww6Oxlp+Bufmw07J1eVeQMuBP6Ma6k7T7uQHnCV;
In-Reply-To: <521BA084.80901-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2013-08-26 at 20:37 +0200, Anton Eliasson wrote:

> >
> >
> You're welcome. And thank you for your thorough instructions. It's been 
> very informative and worthwhile for me to patch and build a kernel with 
> custom options. Let me know if you need more experiments run on the 
> damaged filesystem. Otherwise I'll delete the stored disk images in a 
> month or two.
> 

As I remember, you reproduced the issue by means of starting of two
virtual machines. I think that I will try to reproduce the issue by this
way. But I am investigating the another issue currently and,
unfortunately, I haven't opportunities for investigating this issue in
parallel.

I don't fully confident that it is possible to do it. But, does it
possible to collect strace output of virtual machines starting for the
case of reproduced issue? What do you think? You have shared kernel log
for the reproduced issue case, currently. But strace output can give
interesting details from the user-space point of view.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
