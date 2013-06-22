From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: cleaner optimization and online defragmentation: status update
Date: Sat, 22 Jun 2013 19:31:36 +0400
Message-ID: <2F76977A-589B-47EB-8818-382477099600@dubeyko.com>
References: <51C0A731.9060509@student.tuwien.ac.at> <1371626223.2221.25.camel@slavad-ubuntu> <51C177A4.3030204@student.tuwien.ac.at>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=vYyvcO/79ZXSqzGf/3XpW69hBa8LYUCiL5SLJz/v1PQ=;
	b=kTZkeqm4C4o2+dONBjPQkPHaSyNVloXNq2gJxY7kwxo+bjrshjRs3nU+NC2zlrPQuJQDJNTRv3n5sbYIvevknXer8xUSkegLAIB1+jAHd4ZYEzsl6IWqsE0x1eAT6xz4;
In-Reply-To: <51C177A4.3030204-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,

On Jun 19, 2013, at 1:19 PM, Andreas Rohner wrote:

> Hi Vyacheslav,
> 
> On 2013-06-19 09:17, Vyacheslav Dubeyko wrote:
>> What tools do you plan to use for testing?
>> 
>> As I know, it is used frequently xfstests, fsstress for testing.
>> Benchmarking tools are very useful also (for example, iozone). But it
>> needs to use a special aging tool for the case of GC testing, I think.
> 
> I have written my own little aging tool, that uses nfs traces and
> replays them. I also plan on doing performance benchmarks, because there
> is some performance degradation to be expected because of the block
> counting. But I am quite busy for the next week or so and won't be able
> to start benchmarking until then.
> 

What benchmarking tool do you plan to use? I think that it needs to use
well-known and widely used tool. Otherwise, it is impossible to check
your results independently and to trust of your results.

[skip]
> 
>> If you suggest implementation of new GC policies then we need to have
>> evidence of efficiency. Do you have any benchmarking results? How can
>> you prove efficiency of your approach?
> 
> First of all the current timestamp approach is clearly inefficient,
> because it does not take the number of live blocks in the segment into
> consideration. Then there is the paper I cited, that suggests the
> Cost/Benefit algorithm. I don't have any results as of yet, but I plan
> on doing thorough benchmarks soon.
> 
>> As I understand, F2FS has slightly different allocation policy. Why do
>> you think that "Greedy" and "Cost/Benefit" policies are useful for the
>> case of NILFS2?
> 
> I didn't get the idea from F2FS, but from the cited paper. I just noted,
> that F2FS as far as I can tell also uses these algorithms. They apply to
> NILFS2, because it is a log-structured file system with segments and a
> cleaner.
> 
>> I am slightly confused trying to understand essence of "Greedy" and
>> "Cost/Benefit" policies. Could you briefly describe how it works?
>> Moreover, you mentioned that "Greedy" policy selects segments with the
>> most free blocks. As I know, F2FS has concept of invalid blocks. So,
>> usually, it makes sense to clean firstly segments that have the most
>> number of invalid blocks. But NILFS2 hasn't concept of invalid blocks.
>> So, what do you mean when you are talking about free blocks in "Greedy"
>> policy?
> 
> When the cleaner cleans a segment, it has to decide on which blocks to
> keep and which blocks to discard. The more blocks the cleaner can
> discard the more efficient it is. To do this the cleaner has to know in
> advance how many live blocks there are in a segment. In the context of
> NILFS2 this means, that blocks that are deleted or overwritten in a file
> and not part of some snapshot, can be discarded. Checkpoints are not
> relevant in this distinction.
> 
> Of course the fs has to keep track of the number of live blocks per
> segment. I implemented that and used the su_nblocks attribute of struct
> nilfs_segment_usage.
> 
> With the tracking in place the cleaner can select the most efficient
> segment to clean. "Greedy" just greedily selects the segment with the
> most discardable/free/invalid number of blocks, whatever you want to
> call them ;).
> 
> In the paper "The design and implementation of a log-structured file
> system" the authors noted, that the greedy approach is not the most
> efficient, because the free space in old segments is more valuable than
> the free space in young segments. It is very likely, that the blocks in
> young segments are less stable and will die off anyway. So cleaning them
> would be a waste of time. They devised the "Cost/Benefit" Algorithm. It
> is basically just a simple formula, that takes age and costs of cleaning
> into consideration.
> 

Yes, I think that "Greedy" and "Cost/Benefit" policies can be used as GC
policies for the case of NILFS2. But, currently, you don't suggest proper
basis for such policies realization. As I understand, "Greedy" policy should
select such segments that contain as lesser valid blocks as possible. Valid
blocks means blocks that will be moved by GC. The "Cost/Benefit" policy
should select segment which has required (calculated by formula range)
correlation between valid and invalid blocks in segment.

You are using the su_nblocks field. As I understand, the su_nblocks keeps
number of blocks in all partial segments that are located in full segment.
So, from my point of view, this value hasn't relation with valid/invalid blocks
correlation. It means that from the su_nblocks point of view segments are
practically identical. Because, usually, allocation policy tries to fill segment
by partial segments till a segment capacity. So, if to compare your implementation
and "timestamp" GC policy then "timestamp" policy is better.

Moreover, current realization of segment allocation algorithm is efficient for the
case of GC "timestamp" policy. But the efficiency of this allocation algorithm degrades
significantly for the case of proper realization of "Greedy" and "Cost/Benefit" GC policies.

>> Does NILFS2 really needs in defragmenting tool? Could you describe
>> reasons of such necessity and concrete use-cases? And could you provide
>> benchmarking results that to prove efficiency this approach and to show
>> enhancement of NILFS2 performance or efficiency?
> 
> Both of these things are on the TODO-List:
> http://www.nilfs.org/en/current_status.html
> * Smarter and more efficient Garbage Collector
> * Online defrag
> 
> NILFS2 fragments very heavily, because everything is copy on write. The
> cleaner does some reordering that's true, but it is quite random. An
> example would be a database file or more concrete the sqlite db files in
> the firefox directory. These files are updated and fsynced quite often.
> I imagine, that this could very well reduce the startup time of firefox
> quite considerable, but I have no benchmark results as of yet.
> The effects of fragmentation are less severe for SSDs, but it still matters.
> 

First of all, I am thinking now and I will think that defragmentation should be
a part of GC activity. Usually, from my point of view, users choose NILFS2
because of using flash storage (SSD and so on). So, GC is a consequence of
log-structured nature of NILFS2. But it needs to think about flash aging, anyway.
Because activity of GC or other auxiliary subsystems should take into account
NAND flash wear-leveling. If activity of auxiliary subsystems will be significant
then NAND flash will fail soon without any clear reasons from an user's
viewpoint.

> You can easily test it with the tool filefrag, which shows you the
> extents of a file. On my test system I have created a file with 100
> extents and defragmented it down to 9. The nilfs-defrag tool also checks
> if a file is already defragmented or partially defragmented and only
> defragments the fragmented parts of a file. So it is better than a
> simple "cp frag_file defrag_file" ;).
> 

I reckon that "cp" command will be better if copying is necessary operation.

From my point of view, the utility is a bad way. Defragmentation should be a part
of file system activity. Anyway, we have GC that is moving blocks. So, namely
GC activity should be corrected with the purpose of defragmentation during
blocks moving. When you make utility that to copy blocks then you increase
GC activity because of necessity to clean segments are processed by
defragmenting utility. User should have transparent defragmenting feature
of file system without necessity to use any special utility. Moreover, if fragmentation
is a reason of GC activity or nature of internal file system operations then such
activity should be corrected by defragmentation logic.

So, I have such remarks about defragmentation utility:

(1) The defragmentation utility receives as input a path to the file. So, it means that
an user should detect and choose files that are needed in defragmentation. But if I have
many files (100,000 - 1,000,000) then it will be really time-consuming and complex
operation. A better way can be a daemon that scans state of files in background and
to process defragmenting. But we have GC daemon yet. So, from the architectural point
of view, namely GC is the proper place for defragmenting activity.

(2) Some files can be rarely accessed and it doesn't make sense to defragment such files.
But how an user can detect files that really needs in defragmenting by simple and fast
way?

(3) In your approach the defragmentation utility doubles GC activity in clearing of segments.
Factually, the utility marks blocks as dirty and then segctor thread copies these blocks in
new segments. So, as a result, GC should clear these source segments, anyway. But you
can't predict moments of time when GC will work. As a result, nilfs_cleanerd can fragment
another files from source segments during defragmenting of some big file. And, moreover,
nilfs_cleanerd can fragment other parts of big file during defragmentation activity.

(4) Your approach is using as basis peculiarities of segctor's algorithms. I mean that segctor
processes all dirty blocks of one dirty file and only after to begin processing of another one.
But if algorithm of segctor will change then the defragmentation utility will fragment files
instead of defragmenting. And fragmenting of files will take place in the case when several
segctor threads will work simultaneously (currently, we have only one segctor thread but this
situation can change potentially). Currently, segctor and nilfs_cleanerd can work
simultaneously. It is not rarely case when users to force to work nilfs_cleanerd without any
sleeping timeout. So, simultaneous working of segctor and nilfs_cleanerd will end in
fragmentation.

(5) Factually, real defragmentation is done by segctor. It means that end of working of
defragmentation utility doesn't mean the end of defragmentation. Because real point of
start of defragmentation will be sync or umount operation. So, I can request defragmentation
of file with 100 - 500 GB in size and, then, I can try to make umount operation immediately after
defragmentation utility execution ending. How long will I wait the end of such umount? I think that
a user will treat such long umount as file system bug because defragmentation utility ended
execution before start of umount.

With the best regards,
Vyacheslav Dubeyko.

> br,
> Andreas Rohner
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
