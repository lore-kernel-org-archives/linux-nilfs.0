From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 1/1] nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()
Date: Mon, 08 Sep 2014 21:03:02 +0200
Message-ID: <540DFD66.1090904@gmx.net>
References: <5404C686.4070800@gmx.net>	<20140903.093525.810247375407684014.konishi.ryusuke@lab.ntt.co.jp>	<54070A56.9050807@gmx.net> <20140907.141232.2124135104047617747.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140907.141232.2124135104047617747.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hi Ryusuke,

Sorry for the late response I was busy over the weekend.

On 2014-09-07 07:12, Ryusuke Konishi wrote:
> Hi Andreas,
> On Wed, 03 Sep 2014 14:32:22 +0200, Andreas Rohner wrote:
>> On 2014-09-03 02:35, Ryusuke Konishi wrote:
>>> On Mon, 01 Sep 2014 21:18:30 +0200, Andreas Rohner wrote:
>>> On the other hand, we need explicit barrier operation like
>>> smp_mb__after_atomic() if a certain operation is performed after
>>> set_bit() and the changed bit should be visible to other processors
>>> before the operation.
>>
>> Great suggestion. I didn't know about those functions.
> 
> I recommend you read Documentation/memory-barries.txt.  It's an
> excellent document summarizing information on what we should know
> about memory synchronization on smp.  Documentation/atomic_ops.txt
> also contains some information on barriers related to atomic
> operations.
> 
>> Do we also need a call to smp_mb__before_atomic() before
>> clear_nilfs_flushed(nilfs) in segment.c?
> 
> I think the timing restrictions of this flag are not so serve.  The
> only restrictions that the flag must ensure are:
> 
>  1) Bioes for log are completed before this flag is cleared.
>  2) Clearing the flag is propagated to the processor executing
>     nilfs_sync_fs() and nilfs_sync_file() before log writer returns.
> 
> The restriction (1) is guaranteed since nilfs_wait_on_logs() is called
> before nilfs_segctor_complete_write().  This sequence appears at
> nilfs_segctor_wait() function.
> 
> The restriction (2) looks to be satisfied by (at least)
> nilfs_segctor_notify() that nilfs_segctor_construct() calls or
> nilfs_transaction_unlock() that nilfs_construct_dsync_segment() calls.

I agree with both points.

>> I would be happy to provide another version of the patch with
>> set_nilfs_flushed(nilfs) and smp_mb__after_atomic() if you prefer that
>> version over the test_and_set_bit approach...
> 
> Two additional comments:
> 
> - Splitting test_and_set_bit() into test_bit() and set_bit() can
>   introduce a race condition.  Two processors can call test_bit() at
>   the same time and both can call set_bit() and blkdev_issue_flush().
>   But, this race is not critical.  It only allows duplicate
>   blkdev_issue_flush() calls in the rare case, and I think it's
>   ignorable.

I agree.

> - clear_nilfs_flushed() seems to be called more than necessary.
>   Incomplete logs that the mount time recovery of nilfs doesn't
>   salvage do not need to be flushed.  In this sense, it may be enough
>   only for logs containing a super root and those for datasync
>   nilfs_construct_dsync_segment() creates.

Yes you are right I will change that as well.

On the other hand it seems to me, that almost any file operation causes
a super root to be written. Even if you use fdatasync(). If the i_mtime
on the inode has to be changed, then NILFS_I_INODE_DIRTY is set and the
fdatasync() turns into a normal sync(), which always writes a super
root. Every write() to a file causes an update of i_mtime. I could only
make fdatasync() work as intended with mmap(), but maybe I am missing
something. So we may not save us a lot of updates by only updating the
flag in case the log contains a super root...

> By the way, we are using atomic bit operations too much.  Even though
> {set,clear}_bit() don't imply a memory barrier, they still imply a
> lock prefix to protect the flag from other bit operations on ns_flags.
> For load and store of integer variables which are properly aligned to
> a cache line, modern processors naturally satisfy atomicity without
> additional lock operations.  I think we can replace the flag with just
> an integer variable like "int ns_flushed_device".  How do you think ?

I think that is a good idea. I will implement that right away.

br,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
