From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Contributing to NILFS
Date: Wed, 12 Dec 2012 11:08:32 +0400
Message-ID: <1355296112.2042.35.camel@slavad-ubuntu>
References: <1355169902.803.19.camel@terok>
	 <1355208388.2627.16.camel@slavad-ubuntu> <1355234065.803.61.camel@terok>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=vfjwfjmdNGiK+cjfl42gU1GIkv9hvl8tQOZnTUmYyGY=;
	b=U2k6lV0o1Timn15MII7VMsn0qQN3eYB8wy4dlHiXtg3DXE2e7QoogK81F5jArYmsooL+qSFFqms15MTydNbgRfzc8CKtG+6AGEbl3p5iPiIkUrlI6JyFZEFm1BZNa3zN;
In-Reply-To: <1355234065.803.61.camel@terok>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,

On Tue, 2012-12-11 at 14:54 +0100, Andreas Rohner wrote:
> Hi Vyacheslav,
> 
> Thanks for your response.
> 
> > > 2. Is there some fundamental difficulty that makes it hard to implement
> > > for a log-structured fs?
> > 
> > I think that the most fundamental possible issue can be a possible
> > performance degradation. But first of all, from my point of view, it
> > needs to discuss what the online defrag is and how it is possible to
> > implement it. What do you mean personally by online defrag? And how do
> > you imagine online defrag mechanism for NILFS2 in particular? When you
> > describe your understanding then it will be possible to discuss about
> > difficulties, I think. :-)
> 
> One way would be to just write out heavily fragmented files sequentially
> and atomically switch to the new blocks. But as you suggested this
> simple approach would probably result in performance degradation,
> because it would eat up free segments and the segments of the old blocks
> would contain more unusable free space, that has to be cleaned first.
> This could result in an undesirable situation where most of the segments
> are 60% full and for every clean segment the cleaner has to read in 4
> half full segments. I think the difficult part is to find a suitable
> heuristic to decide if it is beneficial to defragment a file or not. My
> aim would be to produce as many clean or nearly clean segments as
> possible in the process. I would try to implement and test different
> heuristics and algorithms with differently aged file systems and compare
> the results.
> 

I think that this task hides many difficult questions. How does it
define what files fragmented or not? How does it measure the
fragmentation degree? What fragmentation degree should be a basis for
defragmentation activity? When does it need to detect fragmentation and
how to keep this knowledge? How does it make defragmentation without
performance degradation?

As I understand, when we are talking about defragmentation then we
expect a performance enhancement as a result. But defragmenter activity
can be a background reason of performance degradation. Not every
workload or I/O pattern can be a reason of significant fragmentation.

Also, it is a very important to choose a point of defragmentation. I
mean that it is possible to try to prevent fragmentation or to correct
fragmentation after flushing on the volume. It is possible to have a
some hybrid technique, I think. An I/O pattern or file type can be a
basis for such decision, I think.

As I understand, F2FS [1] has some defragmenting approaches. I think
that it needs to discuss more deeply about technique of detecting
fragmented files and fragmentation degree. But maybe hot data tracking
patch [2,3] will be a basis for such discussion.

I think that it can be a useful some materials about NILFS2. I began a
design document for NILFS2 [4] but unfortunately it is not ended yet. It
was published a review of NILFS2 [5] not so recently.

It exists some defragmentation-related papers but I haven't
comprehensive list. I can mention about "The Effects of Filesystem
Fragmentation" [6]. Maybe it can be useful "A Five-Year Study of
File-System Metadata" [7] and "A File Is Not a File: Understanding the
I/O Behavior of Apple Desktop Applications" [8] papers.

So, I feel necessity to think more deeply about online defragment task
and about what you said. But, anyway, it is a beginning of
discussion. :-) 

[1] http://lwn.net/Articles/518988/
[2] http://lwn.net/Articles/525425/
[3] http://lwn.net/Articles/400029/
[4] http://dubeyko.com/development/FileSystems/NILFS/nilfs2-design.pdf
[5] http://lwn.net/Articles/522507/
[6] http://www.google.ru/url?sa=t&rct=j&q=the%20effects%20of%20filesystem%20fragmentation&source=web&cd=2&ved=0CD0QFjAB&url=http%3A%2F%2Fwww.kernel.org%2Fdoc%2Fols%2F2006%2Fols2006v1-pages-193-208.pdf&ei=6CnIUJeHHYqB4gS6l4GoCQ&usg=AFQjCNFLhxtq89VLzE_fLuX7CDDpk_1Krw&bvm=bv.1355272958,d.bGE&cad=rjt
[7] http://www.google.ru/url?sa=t&rct=j&q=a%20five-year%20study%20of%20file-system%20metadata&source=web&cd=1&ved=0CC0QFjAA&url=http%3A%2F%2Fresearch.microsoft.com%2Fpubs%2F72896%2Ffast07-final.pdf&ei=syvIULepFoWE4ASDmYDIBA&usg=AFQjCNE5mFDPqgEvGYe32RkNyVa2oxVxkw&bvm=bv.1355272958,d.bGE&cad=rjt
[8] http://www.google.ru/url?sa=t&rct=j&q=a%20file%20is%20not%20a%20file%3A%20understanding%20the%20i%2Fo%20behavior%20of%20apple%20desktop%20applications&source=web&cd=1&ved=0CC0QFjAA&url=http%3A%2F%2Fresearch.cs.wisc.edu%2Fwind%2FPublications%2Fibench-1c-sosp11.pdf&ei=NSzIUP3zCKqK4ASU5oCACw&usg=AFQjCNEFr-bw1Ke382_rQBYGQwI88MPkKg&bvm=bv.1355272958,d.bGE&cad=rjt

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
