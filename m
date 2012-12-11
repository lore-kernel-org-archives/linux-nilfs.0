From: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Subject: Re: Contributing to NILFS
Date: Tue, 11 Dec 2012 14:54:25 +0100
Message-ID: <1355234065.803.61.camel@terok>
References: <1355169902.803.19.camel@terok>
	 <1355208388.2627.16.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1355208388.2627.16.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

Thanks for your response.

> > 2. Is there some fundamental difficulty that makes it hard to implement
> > for a log-structured fs?
> 
> I think that the most fundamental possible issue can be a possible
> performance degradation. But first of all, from my point of view, it
> needs to discuss what the online defrag is and how it is possible to
> implement it. What do you mean personally by online defrag? And how do
> you imagine online defrag mechanism for NILFS2 in particular? When you
> describe your understanding then it will be possible to discuss about
> difficulties, I think. :-)

One way would be to just write out heavily fragmented files sequentially
and atomically switch to the new blocks. But as you suggested this
simple approach would probably result in performance degradation,
because it would eat up free segments and the segments of the old blocks
would contain more unusable free space, that has to be cleaned first.
This could result in an undesirable situation where most of the segments
are 60% full and for every clean segment the cleaner has to read in 4
half full segments. I think the difficult part is to find a suitable
heuristic to decide if it is beneficial to defragment a file or not. My
aim would be to produce as many clean or nearly clean segments as
possible in the process. I would try to implement and test different
heuristics and algorithms with differently aged file systems and compare
the results.

> > 3. How much work would it entail? Is it doable for one well versed C
> > programmer in 2 to 3 months? 
> > 
> 
> I think that it is more easy to predict duration of some implementation
> task when you know something about a developer. But, as I understand,
> you don't familiar with NILFS2 source code. And how deep your experience
> in Linux kernel implementation? So, it is not so easy to forecast
> something. :-) I suggest to begin implementation. Anyway, it will be
> very useful for your masters thesis, I think.

I am not familiar with the NILFS2 source code and I am not a kernel
developer, but I am very confident in my abilities as a C programmer. I
am more concerned that there is some huge obstacle to the
implementation, that I don't know of. 

best regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
