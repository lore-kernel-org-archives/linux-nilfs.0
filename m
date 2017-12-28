From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: changing CP's create time
Date: Thu, 28 Dec 2017 15:12:12 +0000
Message-ID: <23109.2508.875917.216412@tree.ty.sabi.co.uk>
References: <20171228120336.2b53a10c@babalu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171228120336.2b53a10c@babalu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> But when I rsync the data do another nilfs2 partition,
> snapshot by snapshot,

Are you using something like '--compare-dest' or '--link-dest'?

> each "cp_create" is stamped with today's date.

RSYNC is a POSIX command, checkpoints are not part of POSIX.

> Since I have a script that deletes all CP's older than 60
> days, it will be a problem to guess what do delete as all CP's
> will have almost the same timestamp. I probably doing it the
> wrong way [ ... ]

Perhaps some meditation on the difference between checkpoints
and snapshots, and the role of checkpoints in NILFS2, might be
of benefit here. Including the realization that you can turn
checkpoints into snapshots *on the target*.

Hint: NILFS2 checkpoints/snapshots are not quite the same as
"checkins" in a version control system or Btrfs snapshots.

> So I decided to thought changing the cp_create values back in
> time to resemble the original time of creation and hence the
> first question.

That could be done by adding some new 'ioctl' and modifying
'rsync' too, but looks messy to me, because checkpoints on the
source and checkpoints on the destination need not happen at the
same intervals, and checkpointing is "automatic" so far.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
