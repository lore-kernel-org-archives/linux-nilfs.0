From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Date: Wed, 6 Dec 2017 06:06:48 -0800
Message-ID: <20171206140648.GB32044@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
 <20171206084404.GF4094@dastard>
Mime-Version: 1.0
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VSvVlYkb8avmDxETKC56wfq+di+p26QrzaiZUgEnZYk=; b=Mb/OWdL0DaRdaqkT8XijyJa22
        V9t/JjXh5cpc/dfiMWZJAUxiMHQb2kbZYBMEfB6KR8vpsE7LWHTarf+omkc7JKGJu2SV/tJFm4XGN
        7Ympp7Umt9JNzBelevKYk6hQqHMFJJVnYlW0Uo7y/6TvTq1Xx86WvpFusBG6StOkPoK463LQ68kLV
        Ws1jfi62dD39rTXcBW3+E0f4O6aBK9wNLT5auTSdhNBZJb9PThCP9sZexxXxHMALYMDZ/VaaaS3zh
        7elsbPBv/f0EwuIAjDiODoARLa1kU4EHHD6f2S0fjlRJThNTG/x2vKYMHQk1rHLCSu5VrgR14Ruo+
    
Content-Disposition: inline
In-Reply-To: <20171206084404.GF4094@dastard>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 06, 2017 at 07:44:04PM +1100, Dave Chinner wrote:
> On Tue, Dec 05, 2017 at 08:45:49PM -0800, Matthew Wilcox wrote:
> > That said, using xa_cmpxchg() in the dquot code looked like the right
> > thing to do?  Since we'd dropped the qi mutex and the ILOCK, it looks
> > entirely reasonable for another thread to come in and set up the dquot.
> > But I'm obviously quite ignorant of the XFS internals, so maybe there's
> > something else going on that makes this essentially a "can't happen".
> 
> It's no different to the inode cache code, which drops the RCU
> lock on lookup miss, instantiates the new inode (maybe reading it
> off disk), then locks the tree and attempts to insert it. Both cases
> use "insert if empty, otherwise retry lookup from start" semantics.

Ah.  I had my focus set a little narrow on the inode cache code and didn't
recognise the pattern.

Why do you sleep for one jiffy after encountering a miss, then seeing
someone else insert the inode for you?

> cmpxchg is for replacing a known object in a store - it's not really
> intended for doing initial inserts after a lookup tells us there is
> nothing in the store.  The radix tree "insert only if empty" makes
> sense here, because it naturally takes care of lookup/insert races
> via the -EEXIST mechanism.
> 
> I think that providing xa_store_excl() (which would return -EEXIST
> if the entry is not empty) would be a better interface here, because
> it matches the semantics of lookup cache population used all over
> the kernel....

I'm not thrilled with xa_store_excl(), but I need to think about that
a bit more.

> > I'm quite happy to have normal API variants that don't save/restore
> > interrupts.  Just need to come up with good names ... I don't think
> > xa_store_noirq() is a good name, but maybe you do?
> 
> I'd prefer not to have to deal with such things at all. :P
> 
> How many subsystems actually require irq safety in the XA locking
> code? Make them use irqsafe versions, not make everyone else use
> "noirq" versions, as is the convention for the rest of the kernel
> code....

Hard to say how many existing radix tree users require the irq safety.
Also hard to say how many potential users (people currently using
linked lists, people using resizable arrays, etc) need irq safety.
My thinking was "make it safe by default and let people who know better
have a way to opt out", but there's definitely something to be said for
"make it fast by default and let people who need the unusual behaviour
type those extra few letters".

So, you're arguing for providing xa_store(), xa_store_irq(), xa_store_bh()
and xa_store_irqsafe()?  (at least on demand, as users come to light?)
At least the read side doesn't require any variants; everybody can use
RCU for read side protection.

("safe", not "save" because I wouldn't make the caller provide the
"flags" argument).

> > At least, not today.  One of the future plans is to allow xa_nodes to
> > be allocated from ZONE_MOVABLE.  In order to do that, we have to be
> > able to tell which lock protects any given node.  With the XArray,
> > we can find that out (xa_node->root->xa_lock); with the radix tree,
> > we don't even know what kind of lock protects the tree.
> 
> Yup, this is a prime example of why we shouldn't be creating
> external dependencies by smearing the locking context outside the XA
> structure itself. It's not a stretch to see something like a
> ZONE_MOVEABLE dependency because some other object indexed in a XA
> is stored in the same page as the xa_node that points to it, and
> both require the same xa_lock to move/update...

That is a bit of a stretch.  Christoph Lameter and I had a discussion about it
here: https://www.spinics.net/lists/linux-mm/msg122902.html

There's no situation where you need to acquire two locks in order to
free an object; you'd create odd locking dependencies between objects
if you did that (eg we already have a locking dependency between pag_ici
and perag from __xfs_inode_set_eofblocks_tag).  It'd be a pretty horrible
shrinker design where you had to get all the locks on all the objects,
regardless of what locking order the real code had.

> > There are other costs to not having a lock.  The lockdep/RCU
> > analysis done on the radix tree code is none.  Because we have
> > no idea what lock might protect any individual radix tree, we use
> > rcu_dereference_raw(), disabling lockdep's ability to protect us.
> 
> Unfortunately for you, I don't find arguments along the lines of
> "lockdep will save us" at all convincing.  lockdep already throws
> too many false positives to be useful as a tool that reliably and
> accurately points out rare, exciting, complex, intricate locking
> problems.

But it does reliably and accurately point out "dude, you forgot to take
the lock".  It's caught a number of real problems in my own testing that
you never got to see.

> That problem has not gone away - very few people who read and have
> to maintain this code understandxs all the nasty little intricacies
> of RCU lookups.  Hiding /more/ of the locking semantics from the
> programmers makes it even harder to explain why the algorithm is
> safe. If the rules are basic (e.g. all radix tree lookups use RCU
> locking) then it's easier for everyone to understand, review and
> keep the code working correctly because there's almost no scope for
> getting it wrong.

Couldn't agree more.  Using RCU is subtle, and the parts of the kernel
that use calls like radix_tree_lookup_slot() are frequently buggy,
not least because the sparse annotations were missing until I added
them recently.  That's why the XArray makes sure it has the RCU lock
for you on anything that needs it.

Not that helps you ... you need to hold the RCU lock yourself because
your data are protected by RCU.  I did wonder if you could maybe
improve performance slightly by using something like the page cache's
get_speculative, re-check scheme, but I totally understand your desire
to not make this so hard to understand.

> BTW, something else I just noticed: all the comments in XFS that
> talk about the radix trees would need updating.

I know ... I've been trying to resist the urge to fix comments and spend
more of my time on getting the code working.  It's frustrating to see
people use "radix tree" when what they really mean was "page cache".
Our abstractions leak like sieves.

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
