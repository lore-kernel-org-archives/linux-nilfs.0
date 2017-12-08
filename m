From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Date: Fri, 8 Dec 2017 18:25:00 +1100
Message-ID: <20171208072500.GO5858@dastard>
References: <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
 <20171206084404.GF4094@dastard>
 <20171206140648.GB32044@bombadil.infradead.org>
 <20171207160634.il3vt5d6a4v5qesi@thunk.org>
 <20171207222216.GH4094@dastard> <20171208044552.GA32473@X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=pNACCbWymzypVtrXMvYWon165Q04qYHnmoU0sP7idd8=; b=GZqeOO0zeV9C9160DAD/5sNdmi
 yqQP5n1Je1l4IYsHNcfmA0KI2WUPEDRRJ0igHbNX7/BUrV59oYeTDxruQT1YY1n4+EohoVmrr6YRN
 EfeusEj9NvgKkHJpcfq/jxQwI4sF9zALeTtWsNeIMR3yee5rL0vicInIPVUcDx+RLzSU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=pNACCbWymzypVtrXMvYWon165Q04qYHnmoU0sP7idd8=; b=TTLGg21q1y0QR7NDtdGARah09J
 hlIsNGVJM2qUo2LCsyp6+Bn+eGDaz4BdLZtSrH9DfS2/76Lw2Ia2wsghYW72JcGaItPo2pnz0Rj6/
 NjSLHGidaeqMDBpHRSllEz/yFWM+JT4ft5HE4yOAJkblkHjupJOtMi9R5agD5kfuokhw=;
Content-Disposition: inline
In-Reply-To: <20171208044552.GA32473@X58A-UD3R>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Byungchul Park <byungchul.park@lge.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-nilfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, linux-usb@vger.kernel.org, kernel-team@lge.com, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, linux-btrfs@vger.kernel.org

On Fri, Dec 08, 2017 at 01:45:52PM +0900, Byungchul Park wrote:
> On Fri, Dec 08, 2017 at 09:22:16AM +1100, Dave Chinner wrote:
> > On Thu, Dec 07, 2017 at 11:06:34AM -0500, Theodore Ts'o wrote:
> > > On Wed, Dec 06, 2017 at 06:06:48AM -0800, Matthew Wilcox wrote:
> > > > > Unfortunately for you, I don't find arguments along the lines of
> > > > > "lockdep will save us" at all convincing.  lockdep already throws
> > > > > too many false positives to be useful as a tool that reliably and
> > > > > accurately points out rare, exciting, complex, intricate locking
> > > > > problems.
> > > > 
> > > > But it does reliably and accurately point out "dude, you forgot to take
> > > > the lock".  It's caught a number of real problems in my own testing that
> > > > you never got to see.
> > > 
> > > The problem is that if it has too many false positives --- and it's
> > > gotten *way* worse with the completion callback "feature", people will
> > > just stop using Lockdep as being too annyoing and a waste of developer
> > > time when trying to figure what is a legitimate locking bug versus
> > > lockdep getting confused.
> > > 
> > > <Rant>I can't even disable the new Lockdep feature which is throwing
> > > lots of new false positives --- it's just all or nothing.</Rant>
> > > 
> > > Dave has just said he's already stopped using Lockdep, as a result.
> > 
> > This is compeltely OT, but FYI I stopped using lockdep a long time
> > ago.  We've spend orders of magnitude more time and effort to shut
> > up lockdep false positives in the XFS code than we ever have on
> > locking problems that lockdep has uncovered. And still lockdep
> > throws too many false positives on XFS workloads to be useful to me.
> > 
> > But it's more than that: I understand just how much lockdep *doesn't
> > check* and that means *I know I can't rely on lockdep* for potential
> > deadlock detection. e.g.  it doesn't cover semaphores, which means
> 
> Hello,
> 
> I'm careful in saying the following since you seem to feel not good at
> crossrelease and even lockdep. Now that cross-release has been
> introduced, semaphores can be covered as you might know. Actually, all
> general waiters can.

And all it will do is create a whole bunch more work for us XFS guys
to shut up all the the false positive crap that falls out from it
because the locking model we have is far more complex than any of
the lockdep developers thought was necessary to support, just like
happened with the XFS inode annotations all those years ago.

e.g. nobody has ever bothered to ask us what is needed to describe
XFS's semaphore locking model.  If you did that, you'd know that we
nest *thousands* of locked semaphores in compeltely random lock
order during metadata buffer writeback. And that this lock order
does not reflect the actual locking order rules we have for locking
buffers during transactions.

Oh, and you'd also know that a semaphore's lock order and context
can change multiple times during the life time of the buffer.  Say
we free a block and the reallocate it as something else before it is
reclaimed - that buffer now might have a different lock order. Or
maybe we promote a buffer to be a root btree block as a result of a
join - it's now the first buffer in a lock run, rather than a child.
Or we split a tree, and the root is now a node and so no longer is
the first buffer in a lock run. Or that we walk sideways along the
leaf nodes siblings during searches.  IOWs, there is no well defined
static lock ordering at all for buffers - and therefore semaphores -
in XFS at all.

And knowing that, you wouldn't simply mention that lockdep can
support semaphores now as though that is necessary to "make it work"
for XFS.  It's going to be much simpler for us to just turn off
lockdep and ignore whatever crap it sends our way than it is to
spend unplanned weeks of our time to try to make lockdep sorta work
again. Sure, we might get there in the end, but it's likely to take
months, if not years like it did with the XFS inode annotations.....

> > it has zero coverage of the entire XFS metadata buffer subsystem and
> > the complex locking orders we have for metadata updates.
> > 
> > Put simply: lockdep doesn't provide me with any benefit, so I don't
> > use it...
> 
> Sad..

I don't think you understand. I'll try to explain.

The lockdep infrastructure by itself doesn't make lockdep a useful
tool - it mostly generates false positives because it has no
concept of locking models that don't match it's internal tracking
assumptions and/or limitations.

That means if we can't suppress the false positives, then lockdep is
going to be too noisy to find real problems.  It's taken the XFS
developers months of work over the past 7-8 years to suppress all
the *common* false positives that lockdep throws on XFS. And despite
all that work, there's still too many false positives occuring
because we can't easily suppress them with annotations. IOWs, the
signal to noise ratio is still too low for lockdep to find real
problems.

That's why lockdep isn't useful to me - the noise floor is too high,
and the effort to lower the noise floor further is too great.

This is important, because cross-release just raised the noise floor
by a large margin and so now we have to spend the time to reduce it
again back to where it was before cross-release was added.  IOWs,
adding new detection features to lockdep actually makes lockdep less
useful for a significant period of time. That length of time is
dependent on the rate at which subsystem developers can suppress the
false positives and lower the noise floor back down to an acceptible
level. And there is always the possibility that we can't get the
noise floor low enough for lockdep to be a reliable, useful tool for
some subsystems....

That's what I don't think you understand - that the most important
part of lockdep is /not the core infrastructure/ you work on. The
most important part of lockdep is the annotations that suppress the
noise floor and allow the real problems to stand out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
