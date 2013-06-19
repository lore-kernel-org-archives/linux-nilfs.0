From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: cleaner optimization and online defragmentation: status update
Date: Wed, 19 Jun 2013 11:17:03 +0400
Message-ID: <1371626223.2221.25.camel@slavad-ubuntu>
References: <51C0A731.9060509@student.tuwien.ac.at>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=rcl2QfDo0zp+2A9EXLgJfHyaNXHlReQS/8pnxpWU6XY=;
	b=dV4ON2Uj1X9hcb70Qle78NvOoVQ/HymbAnpWOCr8R/gzRPY+zglNLQlXkip67poaez2d21go/zVkV8TgpS4DltOE0ebbu2fFf33eSNnIRDN7Kes0gUMi7Kg2NVqbhRXq;
In-Reply-To: <51C0A731.9060509-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,

On Tue, 2013-06-18 at 20:30 +0200, Andreas Rohner wrote:
> Hi,
> 
> I have written a simple defragmentation tool and some extensions to the
> cleaner. 

Thank you for your efforts. But I feel necessity to have answer on some
questions before diving in your code. I need to have common
understanding of your approaches, firstly.

> The implementations are not tested enough yet, but I thought I
> could use some feedback if I am headed into the right direction.

What tools do you plan to use for testing?

As I know, it is used frequently xfstests, fsstress for testing.
Benchmarking tools are very useful also (for example, iozone). But it
needs to use a special aging tool for the case of GC testing, I think.

>  I am
> very happy about any suggestions for improvement, because I am quite new
> to kernel development.

Please, use scripts/checkpatch.pl script for checking your code (as
kernel-space as user-space). As I can see, you break some code style
rules in your code.

> 
> * Cleaner:
> 
> Links to Commits: [1] [2]
> 
> I have implemented two new policies for the cleaner. Namely "Greedy",
> which selects the segments with the most free blocks, and
> "Cost/Benefit", which is inspired by this paper [3]. f2fs uses
> apparently the same algorithms.
> 

If you suggest implementation of new GC policies then we need to have
evidence of efficiency. Do you have any benchmarking results? How can
you prove efficiency of your approach?

As I understand, F2FS has slightly different allocation policy. Why do
you think that "Greedy" and "Cost/Benefit" policies are useful for the
case of NILFS2?

I am slightly confused trying to understand essence of "Greedy" and
"Cost/Benefit" policies. Could you briefly describe how it works?
Moreover, you mentioned that "Greedy" policy selects segments with the
most free blocks. As I know, F2FS has concept of invalid blocks. So,
usually, it makes sense to clean firstly segments that have the most
number of invalid blocks. But NILFS2 hasn't concept of invalid blocks.
So, what do you mean when you are talking about free blocks in "Greedy"
policy?

By the way, I think that GC doesn't be a "greedy". :-) What do you
think?

> Unfortunately both of them require, that the file system keeps track of
> the free blocks per segment. This is not trivial, mainly because of
> snapshots. I chose to simply ignore snapshots altogether. That way the
> tracking is simple. The problem is of course, that the
> selection policy goes wrong sometimes, because the actual number of free
> blocks is less than reported. But it should still perform better, than
> the "Timestamp" policy.
> 
> If a block is part of a snapshot, gets deleted, is cleaned and then the
> snapshot is deleted, this block is actually free, but is not counted as
> such.
> 
> Steps:
> 1. Block A is part of a snapshot
> 2. A gets deleted
> 3. A is cleaned (it is considered live because it is in the snapshot)
> 4. the snapshot is deleted
> 5. A is counted in su_nblocks, but it will never be decremented
> 
> If there is a whole segment full of these uncounted blocks they
> will never be cleaned. To prevent this kind of starvation I just reset
> all the counters to zero after a snapshot gets deleted. This makes the
> deletion of snapshots quite expensive and temporarily degrades the
> performance of "Cost/Benefit" policy to "Timestamp". This solution is
> quite ugly and I would prefer something better, but I found no
> other way to prevent this problem.
> 
> There is one additional potential problem though. To track the used
> blocks per segment I used the su_nblocks attribute of struct
> nilfs_segment_usage. This value is currently never used, except once in
> the cleaner. But since the cleaner only cleans segments that are not
> active or dirty, I assume that it always will be a full segment with
> nilfs_get_blocks_per_segment(nilfs) blocks. I haven't tested that enough
> yet, but it seems to work. Alternatively I could just add another
> attribute su_live_nblocks to struct nilfs_segment_usage.
> 
> * Defragmentation:
> 
> Links to Commits: [4] [5]
> 
> It's just a simple proof-of-concept tool called nilfs-defrag [filename].
> It takes the file to defragment as an argument.
> 

Does NILFS2 really needs in defragmenting tool? Could you describe
reasons of such necessity and concrete use-cases? And could you provide
benchmarking results that to prove efficiency this approach and to show
enhancement of NILFS2 performance or efficiency?

Thanks,
Vyacheslav Dubeyko.

> It tries to find the mount point and get a pointer to struct nilfs, to
> find out the block size and the number of segments per block. It uses
> the FIEMAP ioctl to get the extent information, and if the number of
> extents per segment exceeds a certain value, it tries to defragment
> those extents.
> 
> I added a simple new NILFS_IOCTL_MARK_EXTENT_DIRTY, which just reads in
> the corresponding blocks and marks them dirty. The dirty blocks are
> automatically written out to a new segment and will be hopefully less
> fragmented. It seems to work quite nicely, but it needs more testing. I
> am not quite sure if I got the locking right in the kernel code.
> 
> Sorry for the long post
> 
> Best Regards,
> Andreas Rohner
> 
> [1]
> https://github.com/zeitgeist87/linux/commit/bc763ac47c04893d3fece4f2db59f46187415cc4
> [2]
> https://github.com/zeitgeist87/nilfs-utils/commit/ec8281964b3b57b1b79452d9cb03887e04a089b3
> [3] http://dl.acm.org/citation.cfm?id=121137
> [4]
> https://github.com/zeitgeist87/linux/commit/9ce900df854b1cbc968d35fd7ed892d9bf3b52d8
> [5]
> https://github.com/zeitgeist87/nilfs-utils/commit/d32c43e26ad5059b79c0ecc3ff167a78b0f6c814
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
