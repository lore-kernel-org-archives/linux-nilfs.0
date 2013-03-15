From: Alexander Bezrukov <nilfs-issues-tvrqcU/I3+LBxmVkcvZ8vQ@public.gmane.org>
Subject: Re: Corrupted nilfs2 volume
Date: Sat, 16 Mar 2013 03:21:57 +0400
Message-ID: <20130315232157.GC1542@black>
References: <20130315024019.7DC1BD00@mail.dragonworks.ru>
 <1363328491.2078.21.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1363328491.2078.21.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hi Vyacheslav,

> Had you any snapshots on this volume?

Unfortunately no. I had had one but have recently converted
t to an ordinary cp.

> It needs to investigate the issue more deeply. Could you
> try to mount this volume under another system? I hope that
> it gives opportunity to get more details about the issue
> from system log. So, could you share NILFS2 related messages
> for such try?

This is what I've indeed done in the first place.

>> NILFS: Invalid checkpoint (checkpoint number=5439464)
>> NILFS: error loading last checkpoint (checkpoint number=5439464)

In fact, these lines I have copied from the system log of another
system (with some some debian distro kernel 3.2.0). But this is
exactly how my original kernel complains too.

> > To my best knowledge there is no "official" fsck tool for nilfs2
> > but at times nilfs2 has just been added to the mainline kernel I
> > read somewhere about some "unofficial" version at some developer
> > branch.
>
> I send you personally archive with actual state of fsck.nilfs2.
> I need in debug output of the fsck.nilfs2 for analysis of situation
> on the volume.

I am sorry, I didn't receive any archive.

> I hope that we can recover your volume. But, anyway, we need to analyze
> the issue and try to cure the volume.

For me the latter is even more important.

Best regards.
Alexander Bezrukov

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
