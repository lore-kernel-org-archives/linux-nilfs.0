From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 1/1] nilfs2: add missing blkdev_issue_flush() to
 nilfs_sync_fs()
Date: Sun, 07 Sep 2014 14:12:32 +0900 (JST)
Message-ID: <20140907.141232.2124135104047617747.konishi.ryusuke@lab.ntt.co.jp>
References: <5404C686.4070800@gmx.net>
	<20140903.093525.810247375407684014.konishi.ryusuke@lab.ntt.co.jp>
	<54070A56.9050807@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=BIcVd//EasW1zUhBY2mOEvzYPQ9OwX9hIzmD84SIdAw=;
        b=jOKrrF6MPLVYXmedUH5D3IoB1yzm1GtvWos741sKUAbrZWJCBJams3Ny3rzYbJ9Fij
         k0jqGa9BncSEuo82kOAy+KPjyn04t6Hi/v8dBzA8+Vozbdow+QyF1aHiNIpSePbAOTkn
         ULVU8heMUPxjrsRDdyWAUxOHez0USn7ZNpx6bx7OKnIZKujR1baqIAAqAO0mQEKmddik
         4lxi1pTP404XqNdJh+BOj7slwJKtIhOUcmAq2Gf39bz1qTD+SFClonwtpLUR7b3gTZB3
         hjnohOTZTUx4PjrnJgMkuD0bgTLn/CyXbw54oEq0QUVYX8LkPHamn5gZyIDSB9Z5d6Ro
         hkrw==
In-Reply-To: <54070A56.9050807-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,
On Wed, 03 Sep 2014 14:32:22 +0200, Andreas Rohner wrote:
> On 2014-09-03 02:35, Ryusuke Konishi wrote:
>> On Mon, 01 Sep 2014 21:18:30 +0200, Andreas Rohner wrote:
>> On the other hand, we need explicit barrier operation like
>> smp_mb__after_atomic() if a certain operation is performed after
>> set_bit() and the changed bit should be visible to other processors
>> before the operation.
> 
> Great suggestion. I didn't know about those functions.

I recommend you read Documentation/memory-barries.txt.  It's an
excellent document summarizing information on what we should know
about memory synchronization on smp.  Documentation/atomic_ops.txt
also contains some information on barriers related to atomic
operations.

> Do we also need a call to smp_mb__before_atomic() before
> clear_nilfs_flushed(nilfs) in segment.c?

I think the timing restrictions of this flag are not so serve.  The
only restrictions that the flag must ensure are:

 1) Bioes for log are completed before this flag is cleared.
 2) Clearing the flag is propagated to the processor executing
    nilfs_sync_fs() and nilfs_sync_file() before log writer returns.

The restriction (1) is guaranteed since nilfs_wait_on_logs() is called
before nilfs_segctor_complete_write().  This sequence appears at
nilfs_segctor_wait() function.

The restriction (2) looks to be satisfied by (at least)
nilfs_segctor_notify() that nilfs_segctor_construct() calls or
nilfs_transaction_unlock() that nilfs_construct_dsync_segment() calls.

> I would be happy to provide another version of the patch with
> set_nilfs_flushed(nilfs) and smp_mb__after_atomic() if you prefer that
> version over the test_and_set_bit approach...

Two additional comments:

- Splitting test_and_set_bit() into test_bit() and set_bit() can
  introduce a race condition.  Two processors can call test_bit() at
  the same time and both can call set_bit() and blkdev_issue_flush().
  But, this race is not critical.  It only allows duplicate
  blkdev_issue_flush() calls in the rare case, and I think it's
  ignorable.

- clear_nilfs_flushed() seems to be called more than necessary.
  Incomplete logs that the mount time recovery of nilfs doesn't
  salvage do not need to be flushed.  In this sense, it may be enough
  only for logs containing a super root and those for datasync
  nilfs_construct_dsync_segment() creates.

By the way, we are using atomic bit operations too much.  Even though
{set,clear}_bit() don't imply a memory barrier, they still imply a
lock prefix to protect the flag from other bit operations on ns_flags.
For load and store of integer variables which are properly aligned to
a cache line, modern processors naturally satisfy atomicity without
additional lock operations.  I think we can replace the flag with just
an integer variable like "int ns_flushed_device".  How do you think ?


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
