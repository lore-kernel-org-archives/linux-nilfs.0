From: "K. Richard Pixley" <rich-pBcMlXao8V4@public.gmane.org>
Subject: Re: newbie question
Date: Fri, 28 May 2010 14:14:20 -0700
Message-ID: <4C00322C.5020205@noir.com>
References: <4BF5A6E0.6040703@palm.com>	<20100521.073026.88488718.ryusuke@osrg.net>	<4BFEAE99.3030100@noir.com> <87vda8po3l.wl%jir@sekiba.com> <4C00071A.4010508@noir.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C00071A.4010508-pBcMlXao8V4@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Jiro SEKIBA wrote:
 > Hi, Richard
 >
 > At Thu, 27 May 2010 10:40:41 -0700,
 > K. Richard Pixley wrote:
 >
 >> Ryusuke Konishi wrote:
 >>
 >>> The "roll back" feature is one of our todo items, and not yet
 >>> supported.
 >>>
 >> Is this something that could be accelerated by a suitable 
application of
 >> money?
 >>
 >
 > I may not understand your question, but technically speaking
 > it is possible to support roll back feature.
 > It's just a matter of work force to do as far as I think.
 >
 > Still, there are some concerns about what the "roll back" sould be.
 >
 > For instance, if you just want to restore from a specific snapshot 
you took,
 > you can simply read-only mount the snapshot and copy the contents you
 > want to restore.  That is done without any filesystem level roll back 
support.
 >

Yes, but the copying requires a significant amount of time that I'm 
trying to avoid.

I start with a known good file system.  I snapshot it.  I take some 
speculative action.  And then, based on the result of the speculative 
action, I either want to create a new snapshot and continue on from 
there, or I want to "roll back" to the snapshot as though the 
speculative action had never taken place.

Effectively, I want to start with known good data and then "try 
something".  If the trial succeeds, then I have a new good state.  But 
if it fails, then my entire sub tree is polluted and needs to be 
replaced or rolled back before I can try something else.

This is akin to a parser with 1 item lookahead or to an AI search tree 
of depth 1.  That is, I'm looking for a cheap backtracking mechanism.

My first strategy involved rsync'ing a subtree elsewhere in the file 
system as my snapshotting mechanism and then using rsync to replace my 
current subtree when I needed to "roll back".  This costs two large 
copies and the copies take as much or more time than my transforms do. 
This means that the copies are the most expensive thing my system does.

My second strategy has been to use LVM snapshots.  The cost of rolling 
back is effectively zero, but I have a small problem in that snapshots 
can't be snapshotted, (that is, no recursion).  Instead, when the 
speculative action is successful, I either need to copy the successful 
data back to the original device or I need to repeat the speculative 
action on the original device, either of which are slow operations 
comparable to copying my entire subtree again.

What I really want is the ability to make a snapshot, take my 
speculative action, and then pick which one I want to keep moving 
forward, without needing to copy all of the data.

If I'm understanding nilfs2 semantics, then it's trivial to discard the 
snapshot but discarding the most recent state of the file system 
requires a long copy in user space.  I would expect that "roll back" 
would allow me to simply discard everything that has happened in the 
file system after a particular snapshot, (permanently and with no 
mechanism for recovery), returning the file system to that snapshot's 
state with read-write ability, and would do so significantly faster than 
copying my entire file system.

 > Or you want to undone what you did in filesystem, you may be able to
 > delete log and set proper super block.  That is tricky, but possible
 > without filesystem level support if it's not mounted.

It this is true, then I'd like to see it in one of the utility programs.

 > The hard one is live "roll back", I think, which undone the things on
 > mounted filesystem, or maybe at the boot time by specifying a checkpoint.

For my application, it would be sufficient to "roll back" while the 
system was unmounted, or to somehow mark the portions to be discarded 
and then remount at the checkpoint I want to keep.

 > In any cases, there should be some utility programs to achieve the
 > functionalities above even it doesn't require any filesystem 
modifications.

It seems to me that there's not really any conflict about what might be 
provided, but more a question of the degree to which guarantees are kept 
during the process.

"Rolling back" is a clearly desirable feature.  The declarations should 
be made using one of the utility programs.  Doing so on an unmounted 
file system is a win over not doing it at all.  And doing it on a 
mounted file system is a win over doing it on an unmounted file system.

--rich
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
