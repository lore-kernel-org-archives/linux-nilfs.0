From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Re-capturing space
Date: Thu, 11 Nov 2010 10:03:59 +0900 (JST)
Message-ID: <20101111.100359.179929646.ryusuke@osrg.net>
References: <AANLkTi=6k2_v4Ga+4V8EQEsGQ5oNTn_wnc=bbdB94k27@mail.gmail.com>
	<AANLkTi=+FiC=y2jpV-rJmgxdsMEdVBkk9E2_3SZGed3L@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=+FiC=y2jpV-rJmgxdsMEdVBkk9E2_3SZGed3L-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jasonjwwilliams-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 10 Nov 2010 12:10:25 -0700, "Jason J. W. Williams" wrote:
> Hello,
> I'm looking at NILFS as a possible alternative to BTRFS for our move
> off of ZFS. Looking at the description of how NILFS works, it seems
> like it's one big log. New records go on the front. My question is how
> does space eventually get recaptured when you delete files? Does the
> log get rewritten/compacted regularly?
> 
> -J

Yes, a garbage collector daemon does that.  It copies "live" blocks to
the tail from the head of the log, and then frees some obsolete
segments from the log head.

Try "lssu" command to see how it works.

By default, the garbage collector (nilfs_clearned) will start when the
amount of free space falls below 10% of the disk space.

You can change it by modifying /etc/nilfs_cleanered.conf.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
