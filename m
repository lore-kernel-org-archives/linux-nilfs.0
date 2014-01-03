From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix segctor bug that causes file system corruption
Date: Fri, 03 Jan 2014 20:37:03 +0100
Message-ID: <52C7115F.3000209@gmx.net>
References: <W743292615760561388774897@atl4webmail03>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <W743292615760561388774897@atl4webmail03>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mark Trumpold <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-03 19:48, Mark Trumpold wrote:
> On Thu, 02 Jan 2014, Andreas Rohner wrote:
>>> If you follow the 10 steps I outlined in my commit message, 
>>> you should be able to see the problem. If some of the steps are unclear, 
>>> I am happy to provide a more thorough explanation.
> 
> Hi Andreas,
> Would it be possible to share the 10 steps to reproducing the problem?
> I want to evaluate the risk in my context before going through another
> kernel spin.
> Regards and thanks,
> Mark T.

Hi Mark,

I wasn't referring to 10 steps to reproduce the problem, but to the 10
steps in my commit message, which describe how the problem occurs in the
code. But of course I can share my setup and my benchmark.

I use a 100 GB Volume and fill it with dd up to 20GB. Then I replay the
Lair62 NFS Traces from the IOTTA Repository [1]. In Parallel to that I
run a script, that selects every 5 minutes a random checkpoint and
converts it into a snapshot. If there are more than 3 snapshots, the
oldest snapshot is converted back to a checkpoint. One run of this takes
a little more than 4 hours. But it takes about three runs for the bug to
be reproduced. It is quite hard to reproduce it, since a lot of things
need to go wrong at the same time.

There should be a simpler way to trigger it. If the volume is nearly
full and most of the data is protected from the cleaner by a snapshot
and the cleaner runs at a high frequency and lots of DAT-Entries need to
be written out (e.g.: Deletion of a large file).

best regards,
Andreas Rohner

[1] http://iotta.snia.org/historical_section?tracetype_id=2
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
