From: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Subject: Re: cleaner optimization and online defragmentation: status update
Date: Wed, 19 Jun 2013 11:19:32 +0200
Message-ID: <51C177A4.3030204@student.tuwien.ac.at>
References: <51C0A731.9060509@student.tuwien.ac.at> <1371626223.2221.25.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371626223.2221.25.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

On 2013-06-19 09:17, Vyacheslav Dubeyko wrote:
> What tools do you plan to use for testing?
> 
> As I know, it is used frequently xfstests, fsstress for testing.
> Benchmarking tools are very useful also (for example, iozone). But it
> needs to use a special aging tool for the case of GC testing, I think.

I have written my own little aging tool, that uses nfs traces and
replays them. I also plan on doing performance benchmarks, because there
is some performance degradation to be expected because of the block
counting. But I am quite busy for the next week or so and won't be able
to start benchmarking until then.

> Please, use scripts/checkpatch.pl script for checking your code (as
> kernel-space as user-space). As I can see, you break some code style
> rules in your code.

Thanks for the tip. I guess I should have read the "The newbie's guide
to hacking the Linux kernel" first. Sorry for that. I didn't intend to
submit a patch right now.


> If you suggest implementation of new GC policies then we need to have
> evidence of efficiency. Do you have any benchmarking results? How can
> you prove efficiency of your approach?

First of all the current timestamp approach is clearly inefficient,
because it does not take the number of live blocks in the segment into
consideration. Then there is the paper I cited, that suggests the
Cost/Benefit algorithm. I don't have any results as of yet, but I plan
on doing thorough benchmarks soon.

> As I understand, F2FS has slightly different allocation policy. Why do
> you think that "Greedy" and "Cost/Benefit" policies are useful for the
> case of NILFS2?

I didn't get the idea from F2FS, but from the cited paper. I just noted,
that F2FS as far as I can tell also uses these algorithms. They apply to
NILFS2, because it is a log-structured file system with segments and a
cleaner.

> I am slightly confused trying to understand essence of "Greedy" and
> "Cost/Benefit" policies. Could you briefly describe how it works?
> Moreover, you mentioned that "Greedy" policy selects segments with the
> most free blocks. As I know, F2FS has concept of invalid blocks. So,
> usually, it makes sense to clean firstly segments that have the most
> number of invalid blocks. But NILFS2 hasn't concept of invalid blocks.
> So, what do you mean when you are talking about free blocks in "Greedy"
> policy?

When the cleaner cleans a segment, it has to decide on which blocks to
keep and which blocks to discard. The more blocks the cleaner can
discard the more efficient it is. To do this the cleaner has to know in
advance how many live blocks there are in a segment. In the context of
NILFS2 this means, that blocks that are deleted or overwritten in a file
and not part of some snapshot, can be discarded. Checkpoints are not
relevant in this distinction.

Of course the fs has to keep track of the number of live blocks per
segment. I implemented that and used the su_nblocks attribute of struct
nilfs_segment_usage.

With the tracking in place the cleaner can select the most efficient
segment to clean. "Greedy" just greedily selects the segment with the
most discardable/free/invalid number of blocks, whatever you want to
call them ;).

In the paper "The design and implementation of a log-structured file
system" the authors noted, that the greedy approach is not the most
efficient, because the free space in old segments is more valuable than
the free space in young segments. It is very likely, that the blocks in
young segments are less stable and will die off anyway. So cleaning them
would be a waste of time. They devised the "Cost/Benefit" Algorithm. It
is basically just a simple formula, that takes age and costs of cleaning
into consideration.

> Does NILFS2 really needs in defragmenting tool? Could you describe
> reasons of such necessity and concrete use-cases? And could you provide
> benchmarking results that to prove efficiency this approach and to show
> enhancement of NILFS2 performance or efficiency?

Both of these things are on the TODO-List:
http://www.nilfs.org/en/current_status.html
* Smarter and more efficient Garbage Collector
* Online defrag

NILFS2 fragments very heavily, because everything is copy on write. The
cleaner does some reordering that's true, but it is quite random. An
example would be a database file or more concrete the sqlite db files in
the firefox directory. These files are updated and fsynced quite often.
I imagine, that this could very well reduce the startup time of firefox
quite considerable, but I have no benchmark results as of yet.
The effects of fragmentation are less severe for SSDs, but it still matters.

You can easily test it with the tool filefrag, which shows you the
extents of a file. On my test system I have created a file with 100
extents and defragmented it down to 9. The nilfs-defrag tool also checks
if a file is already defragmented or partially defragmented and only
defragments the fragmented parts of a file. So it is better than a
simple "cp frag_file defrag_file" ;).

br,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
