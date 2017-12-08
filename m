From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Date: Sat, 9 Dec 2017 09:36:54 +1100
Message-ID: <20171208223654.GP5858@dastard>
References: <fd7130d7-9066-524e-1053-a61eeb27cb36@lge.com>
 <Pine.LNX.4.44L0.1712081228430.1371-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1712081228430.1371-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-Hm3cg6mZ9cc@public.gmane.org

On Fri, Dec 08, 2017 at 12:35:07PM -0500, Alan Stern wrote:
> On Fri, 8 Dec 2017, Byungchul Park wrote:
> 
> > I'm sorry to hear that.. If I were you, I would also get
> > annoyed. And.. thanks for explanation.
> > 
> > But, I think assigning lock classes properly and checking
> > relationship of the classes to detect deadlocks is reasonable.
> > 
> > In my opinion about the common lockdep stuff, there are 2
> > problems on it.
> > 
> > 1) Firstly, it's hard to assign lock classes *properly*. By
> > default, it relies on the caller site of lockdep_init_map(),
> > but we need to assign another class manually, where ordering
> > rules are complicated so cannot rely on the caller site. That
> > *only* can be done by experts of the subsystem.

Sure, but that's not the issue here. The issue here is the lack of
communication with subsystem experts and that the annotation
complexity warnings given immediately by the subsystem experts were
completely ignored...

> > I think if they want to get benifit from lockdep, they have no
> > choice but to assign classes manually with the domain knowledge,
> > or use *lockdep_set_novalidate_class()* to invalidate locks
> > making the developers annoyed and not want to use the checking
> > for them.
> 
> Lockdep's no_validate class is used when the locking patterns are too
> complicated for lockdep to understand.  Basically, it tells lockdep to
> ignore those locks.

Let me just point out two things here:

	1. Using lockdep_set_novalidate_class() for anything other
	than device->mutex will throw checkpatch warnings. Nice. (*)

	2. lockdep_set_novalidate_class() is completely undocumented
	- it's the first I've ever heard of this functionality. i.e.
	nobody has ever told us there is a mechanism to turn off
	validation of an object; we've *always* been told to "change
	your code and/or fix your annotations" when discussing
	lockdep deficiencies. (**)

> The device core uses that class.  The tree of struct devices, each with
> its own lock, gets used in many different and complicated ways.  
> Lockdep can't understand this -- it doesn't have the ability to
> represent an arbitrarily deep hierarchical tree of locks -- so we tell
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

That largely describes the in-memory structure of XFS, except we
have a forest of lock trees, not just one....

> it to ignore the device locks.
> 
> It sounds like XFS may need to do the same thing with its semaphores.

Who-ever adds semaphore checking to lockdep can add those
annotations. The externalisation of the development cost of new
lockdep functionality is one of the problems here.

-Dave.

(*) checkpatch.pl is considered mostly harmful round here, too,
but that's another rant....

(**) the frequent occurrence of "core code/devs aren't held to the
same rules/standard as everyone else" is another rant I have stored
up for a rainy day.

-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
