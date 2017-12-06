From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Date: Tue, 5 Dec 2017 20:45:49 -0800
Message-ID: <20171206044549.GO26021@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EnJdXNexBVBNMjscEhKYzD99YU59XKwdaKDR8a2tExk=; b=tCkHPqgc28hbtXpn5ilZOXKpE
        UIVvP5MLVCrXakYACuH6Hdu1veswncxQOgM5YM8LlaS3EtwyVg5WdMgPnyea8SkMjAWcm4OeVwCb7
        ml7UJnSelhZrS/06ABuNYTtxbCT5teHXuPoHh1XgOFenyx1Z3b3fmVjoJCHJDXNJxLCRfcoVMtWzz
        FB1fA2k83ptHCfXeGlSU+3tjp+TCtjxO7q9AMZ3hfNHfPE8sS/fl41a1FsivtujbkRLO2LVh5wm48
        h+FLxuXBArKDgYhmodgIvgNnXobsVzCYuV3Pl2TXxnJNlvVcsLSgs485Yah/WlDPTZUO9EFa5/sxE
    
Content-Disposition: inline
In-Reply-To: <20171206031456.GE4094@dastard>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 06, 2017 at 02:14:56PM +1100, Dave Chinner wrote:
> > The other conversions use the normal API instead of the advanced API, so
> > all of this gets hidden away.  For example, the inode cache does this:
> 
> Ah, OK, that's not obvious from the code changes. :/

Yeah, it's a lot easier to understand (I think!) if you build the
docs in that tree and look at
file:///home/willy/kernel/xarray-3/Documentation/output/core-api/xarray.html
(mutatis mutandi).  I've tried to tell a nice story about how to put
all the pieces together from the normal to the advanced API.

> However, it's probably overkill for XFS. In all the cases, when we
> insert there should be no entry in the tree - the
> radix tree insert error handling code there was simply catching
> "should never happen" cases and handling it without crashing.

I thought it was probably overkill to be using xa_cmpxchg() in the
pag_ici patch.  I didn't want to take away your error handling as part
of the conversion, but I think a rational person implementing it today
would just call xa_store() and not even worry about the return value
except to check it for IS_ERR().

That said, using xa_cmpxchg() in the dquot code looked like the right
thing to do?  Since we'd dropped the qi mutex and the ILOCK, it looks
entirely reasonable for another thread to come in and set up the dquot.
But I'm obviously quite ignorant of the XFS internals, so maybe there's
something else going on that makes this essentially a "can't happen".

> Now that I've looked at this, I have to say that having a return
> value of NULL meaning "success" is quite counter-intuitive. That's
> going to fire my "that looks so wrong" detector every time I look at
> the code and notice it's erroring out on a non-null return value
> that isn't a PTR_ERR case....

It's the same convention as cmpxchg().  I think it's triggering your
"looks so wrong" detector because it's fundamentally not the natural
thing to write.  I certainly don't cmpxchg() new entries into an array
and check the result was NULL ;-)

> Also, there's no need for irqsave/restore() locking contexts here as
> we never access these caches from interrupt contexts. That's just
> going to be extra overhead, especially on workloads that run 10^6
> inodes inodes through the cache every second. That's a problem
> caused by driving the locks into the XA structure and then needing
> to support callers that require irq safety....

I'm quite happy to have normal API variants that don't save/restore
interrupts.  Just need to come up with good names ... I don't think
xa_store_noirq() is a good name, but maybe you do?

> > It's the design pattern I've always intended to use.  Naturally, the
> > xfs radix trees weren't my initial target; it was the page cache, and
> > the page cache does the same thing; uses the tree_lock to protect both
> > the radix tree and several other fields in that same data structure.
> > 
> > I'm open to argument on this though ... particularly if you have a better
> > design pattern in mind!
> 
> I don't mind structures having internal locking - I have a problem
> with leaking them into contexts outside the structure they protect.
> That way lies madness - you can't change the internal locking in
> future because of external dependencies, and the moment you need
> something different externally we've got to go back to an external
> lock anyway.
> 
> This is demonstrated by the way you converted the XFS dquot tree -
> you didn't replace the dquot tree lock with the internal xa_lock
> because it's a mutex and we have to sleep holding it. IOWs, we've
> added another layer of locking here, not simplified the code.

I agree the dquot code is no simpler than it was, but it's also no more
complicated from a locking analysis point of view; the xa_lock is just
not providing you with any useful exclusion.

At least, not today.  One of the future plans is to allow xa_nodes to
be allocated from ZONE_MOVABLE.  In order to do that, we have to be
able to tell which lock protects any given node.  With the XArray,
we can find that out (xa_node->root->xa_lock); with the radix tree,
we don't even know what kind of lock protects the tree.

> What I really see here is that  we have inconsistent locking
> patterns w.r.t. XA stores inside XFS - some have an external mutex
> to cover a wider scope, some use xa_lock/xa_unlock to span multiple
> operations, some directly access the internal xa lock via direct
> spin_lock/unlock(...xa_lock) calls and non-locking XA call variants.
> In some places you remove explicit rcu_read_lock() calls because the
> internal xa_lock implies RCU, but in other places we still need them
> because we have to protect the objects the tree points to, not just
> the tree....
> 
> IOWs, there's no consistent pattern to the changes you've made to
> the XFS code. The existing radix tree code has clear, consistent
> locking, tagging and lookup patterns. In contrast, each conversion
> to the XA code has resulted in a different solution for each radix
> tree conversion. Yes, there's been a small reduction in the amoutn
> of code in converting to the XA API, but it comes at the cost of
> consistency and ease of understanding the code that uses the radix
> tree API.

There are other costs to not having a lock.  The lockdep/RCU
analysis done on the radix tree code is none.  Because we have
no idea what lock might protect any individual radix tree, we use
rcu_dereference_raw(), disabling lockdep's ability to protect us.

It's funny that you see the hodgepodge of different locking strategies
in the XFS code base as being a problem with the XArray.  I see it as
being a consequence of XFS's different needs.  No, the XArray can't
solve all of your problems, but it hasn't made your locking more complex.

And I don't agree that the existing radix tree code has clear, consistent
locking patterns.  For example, this use of RCU was unnecessary:

 xfs_queue_eofblocks(
        struct xfs_mount *mp)
 {
-       rcu_read_lock();
-       if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_EOFBLOCKS_TAG))
+       if (xa_tagged(&mp->m_perag_xa, XFS_ICI_EOFBLOCKS_TAG))
                queue_delayed_work(mp->m_eofblocks_workqueue,
                                   &mp->m_eofblocks_work,
                                   msecs_to_jiffies(xfs_eofb_secs * 1000));
-       rcu_read_unlock();
 }

radix_tree_tagged never required the RCU lock (commit 7cf9c2c76c1a).
I think you're just used to the radix tree pattern of "we provide no
locking for you, come up with your own scheme".

What might make more sense for XFS is coming up with something
intermediate between the full on xa_state-based API and the "we handle
everything for you" normal API.  For example, how would you feel about
xfs_mru_cache_insert() looking like this:

	xa_lock(&mru->store);
	error = PTR_ERR_OR_ZERO(__xa_store(&mru->store, key, elem, GFP_NOFS));
	if (!error)
		_xfs_mru_cache_list_insert(mru, elem);
	xa_unlock(&mru->store);

	return error;

xfs_mru_cache_lookup would look like:

	xa_lock(&mru->store);
	elem = __xa_load(&mru->store, key);
	...

There's no real need for the mru code to be using the full-on xa_state
API.  For something like DAX or the page cache, there's a real advantage,
but the mru code is, I think, a great example of a user who has somewhat
more complex locking requirements, but doesn't use the array in a
complex way.

The dquot code is just going to have to live with the fact that there's
additional locking going on that it doesn't need.  I'm open to getting
rid of the irqsafety, but we can't give up the spinlock protection
without giving up the RCU/lockdep analysis and the ability to move nodes.
I don't suppose the dquot code can 


Thanks for spending so much time on this and being so passionate about
making this the best possible code it can be.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
