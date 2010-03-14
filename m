From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Sun, 14 Mar 2010 14:26:34 +0900 (JST)
Message-ID: <20100314.142634.172547823.ryusuke@osrg.net>
References: <4B9BFA67.1010501@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B9BFA67.1010501-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sat, 13 Mar 2010 21:49:43 +0100, David Arendt wrote:
> Hi,
> 
> In order to reduce cleaner io, I am thinking it could be usefull to
> implement a parameter where you can specify the minimum free space. If
> this parameter is set, instead of normal cleaning operation, the cleaner
> would wait until there is less than minimum free space available and
> then run one cleaning pass (from first to last segment). If after that,
> there is again more than minimum free space available, continue waiting,
> otherwise run cleaning passes until there is more than minimum free
> space available.
> 
> What would you think about this idea ?
> 
> Bye,
> David Arendt

Well, I think this is one of what cleaner should take in.  It can
prevent cleanerd from moving in-use blocks too often unless the actual
free space is less than the threshold.

It may be the first thing to do since it's not difficult in principle.

I recognize there are more fundamental defects in the current cleaner:

 * It moves blocks in selected segments even if all of their blocks
   are in-use.

 * It doesn't give priority to reclaiming segments which have many
   obsolete blocks.

 * It keeps working without considering io workload of the time.

But, I'd rather take a quick fix like your proposal.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
