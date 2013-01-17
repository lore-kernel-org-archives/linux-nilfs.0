From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: Work around uncleanable full filesystem
Date: Thu, 17 Jan 2013 13:19:42 +0400
Message-ID: <1358414382.2513.20.camel@slavad-ubuntu>
References: <1358178899-26347-1-git-send-email-sven@narfation.org>
	 <2312125.8JVqXAGppa@bentobox> <1358409438.2513.14.camel@slavad-ubuntu>
	 <10139628.nRTq3A6E4L@bentobox>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=2uno14J7CW2PilboNCc9+PD/+15yBtwieEFB5iqZtSU=;
	b=FzX7WBn0MdxeZr32SwioCugIYEHi40XbOOKfEV4tYBMidcDTSYtXnhUobqVDoF0w13LItw7/JRyntxiM/EvQCjFsvD8eDonCDWcPIORf0x/rE6h1qneSIZy2Wp7LdK3z;
In-Reply-To: <10139628.nRTq3A6E4L@bentobox>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2013-01-17 at 09:32 +0100, Sven Eckelmann wrote:
> On Thursday 17 January 2013 11:57:18 Vyacheslav Dubeyko wrote:
> [...]
> > If you do so by the hands then, from my point of view, you know what you
> > are doing.
> 
> You asked for a way to easily reproduce it and now say it is my fault? Sry, 
> but it happened in a real world scenario and I only provided a testcase for 
> you.
> 

No, I don't say that it is your fault. The timestamp policy of GC has
some limitation and peculiarities because of nature of the time. So, you
described one of such use-case. But, from my point of view, such
use-case has very low probability of occurrence. And proper fix can be
adding of another GC policy. That's all I said.

With the best regards,
Vyacheslav Dubeyko.

> Kind regards,
> 	Sven


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
