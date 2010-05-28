From: "K. Richard Pixley" <rich-pBcMlXao8V4@public.gmane.org>
Subject: Re: newbie question
Date: Fri, 28 May 2010 14:16:31 -0700
Message-ID: <4C0032AF.9040704@noir.com>
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

I don't know nilfs2 internals, but it occurs to me that a "forward" or 
"leap frog" mechanism might work too.

That is, if a file system is in a state at time T(0), and is in another 
state at time T(1), then what I'm looking for is the ability to return 
to a read-write file system with state T(0).

One way to do that might be to "roll back" from state T(1), thereby 
discarding state T(1).  But another way to accomplish this might be to 
surgically construct a state T(2) which occurs after T(1) and was 
identical to T(0), leaving T(1) available as a read-only snapshot.

We do this in source control.  Rather than backing out a particular 
change to your source tree, many source control systems require you to 
commit a reverse diff.  This creates a new revision, but a new revision 
which is identical to an earlier revision which has the apparent affect 
of removing a change.

I don't know if this would be any easier, but it's a thought.

--rich
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
