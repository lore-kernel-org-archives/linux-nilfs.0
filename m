From: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Subject: Re: Contributing to NILFS
Date: Sun, 16 Dec 2012 18:45:32 +0100
Message-ID: <1355679932.761.57.camel@terok>
References: <1355169902.803.19.camel@terok>
	 <1355208388.2627.16.camel@slavad-ubuntu> <1355234065.803.61.camel@terok>
	 <1355296112.2042.35.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1355296112.2042.35.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

> I think that this task hides many difficult questions. How does it
> define what files fragmented or not? How does it measure the
> fragmentation degree? What fragmentation degree should be a basis for
> defragmentation activity? When does it need to detect fragmentation and
> how to keep this knowledge? How does it make defragmentation without
> performance degradation?
>
> As I understand, when we are talking about defragmentation then we
> expect a performance enhancement as a result. But defragmenter activity
> can be a background reason of performance degradation. Not every
> workload or I/O pattern can be a reason of significant fragmentation.
> 
> Also, it is a very important to choose a point of defragmentation. I
> mean that it is possible to try to prevent fragmentation or to correct
> fragmentation after flushing on the volume. It is possible to have a
> some hybrid technique, I think. An I/O pattern or file type can be a
> basis for such decision, I think.

Yes I agree. It is of course a good idea to reorder the data before
flushing and probably also to reorder it with the cleaner, but I
thought, that was already implemented and optimized. Is it?

Instead I imagined a tool like xfs_fsr for XFS. So the user can decide
when to defragment the file system, by running it manually or with a
cron job. Maybe this is a bit naive, since I probably don't know enough
about NILFS. Couldn't we just calculate the number of segments a file
uses if it is stored optimally and compare that to the actual number of
segments the file is spread out. For example, file A has 16MB. Lets
assume segments are of size 8MB. So (ignoring the metadata) file A
should use 2 segments. Now we count the different segments where the
blocks of file A really are, lets say 10, and calculate 1-(2/10)=0.8 So
it is 80% fragmented.

I wouldn't do that in the cleaner or in the background. Just a tool like
xfs_fsr, that the user can run once a month in the middle of the night
with a cron job. The tool would go through every file, calculate the
fragmentation and collect other statistics and decide if it is worth
defragmenting it or not.

If the user has a SSD he/she can decide not to defragment at all.

> As I understand, F2FS [1] has some defragmenting approaches. I think
> that it needs to discuss more deeply about technique of detecting
> fragmented files and fragmentation degree. But maybe hot data tracking
> patch [2,3] will be a basis for such discussion.

I did a quick search for F2FS defragmentation, but I couldn't find
anything. Did you mean this section of the article? "...it provides
large-scale write gathering so that when lots of blocks need to be
written at the same time they are collected into large sequential
writes..." Maybe I missed something, but isn't this just the inherent
property of a log-structured file system and not defragmentation?

Hot data tracking could be extremely useful for the cleaner. This paper
[1] suggests, that the best cleaner performance can be achieved by
distinguishing between hot and cold data. Is something like that already
implemented? Maybe I could do that for my masters thesis instead of the
defragmentation task... ;)

Thanks for the links. 

best regards,
Andreas Rohner

[1] http://www.cs.berkeley.edu/~brewer/cs262/LFS.pdf

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
