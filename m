From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Contributing to NILFS
Date: Tue, 11 Dec 2012 10:46:28 +0400
Message-ID: <1355208388.2627.16.camel@slavad-ubuntu>
References: <1355169902.803.19.camel@terok>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject:Message-ID; bh=k/35qyPlMgDrx9C8og0+GFl/lpOOGK5KccFLESvo/7k=;
	b=KgMAcG5yuKLp+Q42BurGqFtxxwkmTROW2nK/Doe35oV7dQP0wnFyDcNjdxOLNKFW+G6jndY0djfAHUjpS9vZSMNVm7dVi7626j82ocvY2tPQrLPvNDEaQ46gEFYLj3Wl;
In-Reply-To: <1355169902.803.19.camel@terok>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,

On Mon, 2012-12-10 at 21:05 +0100, Andreas Rohner wrote:
> Hi,
> 
> I am a computer science student from Austria and I am looking for a
> topic for my masters thesis. I am very interested in log-structured file
> systems and I thought of doing a few things from the TODO list on the
> website: http://www.nilfs.org/en/current_status.html
> I am particularly interested in the "Online defrag" feature, but I
> haven't looked into the source code yet. I have a few questions
> concerning that and any help would be greatly appreciated:
> 
> 1. Has someone already started working on it?

As I know, you will be the first. :-)

> 2. Is there some fundamental difficulty that makes it hard to implement
> for a log-structured fs?

I think that the most fundamental possible issue can be a possible
performance degradation. But first of all, from my point of view, it
needs to discuss what the online defrag is and how it is possible to
implement it. What do you mean personally by online defrag? And how do
you imagine online defrag mechanism for NILFS2 in particular? When you
describe your understanding then it will be possible to discuss about
difficulties, I think. :-)

> 3. How much work would it entail? Is it doable for one well versed C
> programmer in 2 to 3 months? 
> 

I think that it is more easy to predict duration of some implementation
task when you know something about a developer. But, as I understand,
you don't familiar with NILFS2 source code. And how deep your experience
in Linux kernel implementation? So, it is not so easy to forecast
something. :-) I suggest to begin implementation. Anyway, it will be
very useful for your masters thesis, I think.

With the best regards,
Vyacheslav Dubeyko.

> best regards,
> Andreas Rohner
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
