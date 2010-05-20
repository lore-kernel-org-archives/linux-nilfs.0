From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: newbie question
Date: Fri, 21 May 2010 07:30:26 +0900 (JST)
Message-ID: <20100521.073026.88488718.ryusuke@osrg.net>
References: <4BF5A6E0.6040703@palm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BF5A6E0.6040703-C65YXLrEp3M@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: rich.pixley-C65YXLrEp3M@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 20 May 2010 14:17:20 -0700, Rich Pixley wrote:
> Can nilfs "roll back" to a previous state of the file system?
> 
> For example, at some time = T(N), I have a file system in a known good 
> state.  So I check point it before taking a risky action.  Then I take a 
> risky action which leads me to the file system state at T(N+1).
> 
> Sometimes, my risky action will be fine and I'll want to continue on.  
> Other times, my risky action will result in a polluted, useless 
> collection of data which I would like to discard.
> 
> I understand that at time T(N+1) nilfs will allow me to create a 
> checkpoint of T(N) which can be mounted read-only.  What I'm asking is 
> if nilfs can discard the state at T(N+1) and "roll back" to the state at 
> T(N) as though T(N+1) had never happened.
> 
> Can nilfs do this kind of "roll back"?
> 
> --rich

The "roll back" feature is one of our todo items, and not yet
supported.  At present, nilfs needs user's "copy back" operation to
roll back the state at T(N).

I think offline rollback is feasible, but I don't know whether it's
true of online rollback because the online rollback needs to discard
memory states of some sort or instead ensure consistency for the
processes which reside in the namespace of nilfs.  This may be done
in the same manner as file removal, but I don't know yet.

Cheers,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
