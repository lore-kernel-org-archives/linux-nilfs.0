From: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Subject: Re: Contributing to NILFS
Date: Mon, 17 Dec 2012 11:23:36 +0100
Message-ID: <1355739816.738.35.camel@terok>
References: <1355169902.803.19.camel@terok>
	 <1355208388.2627.16.camel@slavad-ubuntu> <1355234065.803.61.camel@terok>
	 <1355296112.2042.35.camel@slavad-ubuntu> <1355679932.761.57.camel@terok>
	 <1355725809.2502.29.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1355725809.2502.29.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

> I misunderstand slightly about what implementation you are talking.
> Could you point out NILFS2 source code that implement this technique? As
> I understand, if we have implemented data reordering before flush and
> during the cleaning then it means that we have implemented online
> defragmenting. But, if so, why this task is in TODO list?

I guess I just assumed it. But I would connect these issues more with
the first item on the TODO-List "Smarter and more efficient Garbage
Collector".

> > Instead I imagined a tool like xfs_fsr for XFS. So the user can decide
> > when to defragment the file system, by running it manually or with a
> > cron job.
> 
> If you are talking about user-space tool then it means that you are
> talking about offline defragmenter. I think that offline defragmenter is
> not so interesting for users. The most important objections are:

I am sorry about the misunderstanding. I thought the term "online" just
means that the file system is mounted, while the defragmentation tool is
running. So offline defragmentation would be if you had to unmount the
file system for defragmentation. EXT4 [1] and XFS both do "online"
defragmentation with a user-space tool. I assumed, that the item on the
TODO-List means something similar. Such a tool could be useful to reduce
aging effects. It should be very conservative and probably not run every
day, but instead once a month.

[1] http://lwn.net/Articles/317787/

> (1) Usually, NILFS2 is used for NAND-based devices (SSD, SD-card and so
> on). So, as a result, offline defragmenter will decrease NAND lifetime
> by means of its activity.

Yes that is true. If most users use NAND-based devices such a tool would
be useless.

> (2) Even if you will use NILFS2 on HDD then offline defragmenter will
> decrease available free space by means of its operations because NILFS2
> is log-structured file system. It means that every trying to write
> results in writing into new free block (COW technique) and new segments
> creations. So, the probability to exhaust free space by means of offline
> defragmenter is very high.

Yes that is also true, I was talking about that in my second mail. The
defragmentation tool could try to avoid that as much as possible and
clean up after itself. But the latter would again decrease NAND
lifetime.

> 
> > Maybe this is a bit naive, since I probably don't know enough
> > about NILFS. Couldn't we just calculate the number of segments a file
> > uses if it is stored optimally and compare that to the actual number of
> > segments the file is spread out. For example, file A has 16MB. Lets
> > assume segments are of size 8MB. So (ignoring the metadata) file A
> > should use 2 segments. Now we count the different segments where the
> > blocks of file A really are, lets say 10, and calculate 1-(2/10)=0.8 So
> > it is 80% fragmented.
> > 
> 
> I think that if parts of file are placed in sibling segments then it
> doesn't make sense to do defragmenting. So, if you can detect some file
> as fragmented by means of your technique then it is not possible to
> decide about necessity to defragment. Moreover, how do you plan to
> answer on such simple question: If you know block number then how to
> detect what file contain it? 

Yes I agree if parts of the file are in sibling segments we should not
defragment.

About your second point, unfortunately I don't know enough about NILFS2
to answer that. I would have to study the source code first. But I trust
your assessment that its difficult.

> > I wouldn't do that in the cleaner or in the background. Just a tool like
> > xfs_fsr, that the user can run once a month in the middle of the night
> > with a cron job. The tool would go through every file, calculate the
> > fragmentation and collect other statistics and decide if it is worth
> > defragmenting it or not.
> > 
> > If the user has a SSD he/she can decide not to defragment at all.
> > 
> 
> I think that online defragmenter can be very useful for SSD case also.
> 
> > > As I understand, F2FS [1] has some defragmenting approaches. I think
> > > that it needs to discuss more deeply about technique of detecting
> > > fragmented files and fragmentation degree. But maybe hot data tracking
> > > patch [2,3] will be a basis for such discussion.
> > 
> > I did a quick search for F2FS defragmentation, but I couldn't find
> > anything. Did you mean this section of the article? "...it provides
> > large-scale write gathering so that when lots of blocks need to be
> > written at the same time they are collected into large sequential
> > writes..." Maybe I missed something, but isn't this just the inherent
> > property of a log-structured file system and not defragmentation?
> > 
> 
> I meant that F2FS has architecture which it its basis contains
> defragmenting opportunities, from my point of view. And I think that
> this approaches can be a basis for online defragmenting technique
> elaboration.
> 
> > Hot data tracking could be extremely useful for the cleaner. This paper
> > [1] suggests, that the best cleaner performance can be achieved by
> > distinguishing between hot and cold data. Is something like that already
> > implemented? Maybe I could do that for my masters thesis instead of the
> > defragmentation task... ;)
> > 
> 
> The F2FS uses technique of distinguishing between hot and cold data very
> deeply. It is a base technique of this filesystem.

Ok so to sum up: The task would be to implement reordering/defragmenting
abilities in the cleaner and before flushing. Additionally one could use
the information from hot data tracking to improve the cleaner like in
F2FS. The defragmenting activities of the cleaner should cause minimal
overhead and no extra writes to prevent reduction of NAND lifetime. An
extra user space utility is probably useless.

I am sorry for the confusion, but with EXT4 and XFS, online
defragmentation is done with a user-space tool. It seems we were talking
about two different things the whole time :). I am glad we cleared that
up.

best regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
