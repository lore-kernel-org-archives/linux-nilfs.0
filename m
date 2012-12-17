From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Contributing to NILFS
Date: Mon, 17 Dec 2012 10:30:09 +0400
Message-ID: <1355725809.2502.29.camel@slavad-ubuntu>
References: <1355169902.803.19.camel@terok>
	 <1355208388.2627.16.camel@slavad-ubuntu> <1355234065.803.61.camel@terok>
	 <1355296112.2042.35.camel@slavad-ubuntu> <1355679932.761.57.camel@terok>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=PahASIrsFcXP7JGdHmhtjONJ/ncBSoWo69+04y3a9OM=;
	b=Xp90QrOXJtLYy4vXFxblRJgqdPWMbLauEwPdWe7AbsLHto/bWacRPHhnt0LCG9Fr8BnMG9KixJ6x3IZ3Cza/1Mq5fnw1+nCfnAkRa78YrUr4AxmHTZh2QvGXobxapsnS;
In-Reply-To: <1355679932.761.57.camel@terok>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,

On Sun, 2012-12-16 at 18:45 +0100, Andreas Rohner wrote:

[snip]
> > 
> > Also, it is a very important to choose a point of defragmentation. I
> > mean that it is possible to try to prevent fragmentation or to correct
> > fragmentation after flushing on the volume. It is possible to have a
> > some hybrid technique, I think. An I/O pattern or file type can be a
> > basis for such decision, I think.
> 
> Yes I agree. It is of course a good idea to reorder the data before
> flushing and probably also to reorder it with the cleaner, but I
> thought, that was already implemented and optimized. Is it?
> 

I misunderstand slightly about what implementation you are talking.
Could you point out NILFS2 source code that implement this technique? As
I understand, if we have implemented data reordering before flush and
during the cleaning then it means that we have implemented online
defragmenting. But, if so, why this task is in TODO list?


> Instead I imagined a tool like xfs_fsr for XFS. So the user can decide
> when to defragment the file system, by running it manually or with a
> cron job.

If you are talking about user-space tool then it means that you are
talking about offline defragmenter. I think that offline defragmenter is
not so interesting for users. The most important objections are:

(1) Usually, NILFS2 is used for NAND-based devices (SSD, SD-card and so
on). So, as a result, offline defragmenter will decrease NAND lifetime
by means of its activity.

(2) Even if you will use NILFS2 on HDD then offline defragmenter will
decrease available free space by means of its operations because NILFS2
is log-structured file system. It means that every trying to write
results in writing into new free block (COW technique) and new segments
creations. So, the probability to exhaust free space by means of offline
defragmenter is very high.


> Maybe this is a bit naive, since I probably don't know enough
> about NILFS. Couldn't we just calculate the number of segments a file
> uses if it is stored optimally and compare that to the actual number of
> segments the file is spread out. For example, file A has 16MB. Lets
> assume segments are of size 8MB. So (ignoring the metadata) file A
> should use 2 segments. Now we count the different segments where the
> blocks of file A really are, lets say 10, and calculate 1-(2/10)=0.8 So
> it is 80% fragmented.
> 

I think that if parts of file are placed in sibling segments then it
doesn't make sense to do defragmenting. So, if you can detect some file
as fragmented by means of your technique then it is not possible to
decide about necessity to defragment. Moreover, how do you plan to
answer on such simple question: If you know block number then how to
detect what file contain it? 

> I wouldn't do that in the cleaner or in the background. Just a tool like
> xfs_fsr, that the user can run once a month in the middle of the night
> with a cron job. The tool would go through every file, calculate the
> fragmentation and collect other statistics and decide if it is worth
> defragmenting it or not.
> 
> If the user has a SSD he/she can decide not to defragment at all.
> 

I think that online defragmenter can be very useful for SSD case also.

> > As I understand, F2FS [1] has some defragmenting approaches. I think
> > that it needs to discuss more deeply about technique of detecting
> > fragmented files and fragmentation degree. But maybe hot data tracking
> > patch [2,3] will be a basis for such discussion.
> 
> I did a quick search for F2FS defragmentation, but I couldn't find
> anything. Did you mean this section of the article? "...it provides
> large-scale write gathering so that when lots of blocks need to be
> written at the same time they are collected into large sequential
> writes..." Maybe I missed something, but isn't this just the inherent
> property of a log-structured file system and not defragmentation?
> 

I meant that F2FS has architecture which it its basis contains
defragmenting opportunities, from my point of view. And I think that
this approaches can be a basis for online defragmenting technique
elaboration.

> Hot data tracking could be extremely useful for the cleaner. This paper
> [1] suggests, that the best cleaner performance can be achieved by
> distinguishing between hot and cold data. Is something like that already
> implemented? Maybe I could do that for my masters thesis instead of the
> defragmentation task... ;)
> 

The F2FS uses technique of distinguishing between hot and cold data very
deeply. It is a base technique of this filesystem.

With the best regards,
Vyacheslav Dubeyko.

> Thanks for the links. 
> 
> best regards,
> Andreas Rohner
> 
> [1] http://www.cs.berkeley.edu/~brewer/cs262/LFS.pdf
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
