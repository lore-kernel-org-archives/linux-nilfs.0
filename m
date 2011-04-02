From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: checkpoints to often
Date: Sat, 02 Apr 2011 10:49:09 +0900 (JST)
Message-ID: <20110402.104909.22905984.ryusuke@osrg.net>
References: <AANLkTinq052P2vvTfuTSuFgTWHKuZRyqDj=g2tFha0ZM@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinq052P2vvTfuTSuFgTWHKuZRyqDj=g2tFha0ZM-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: krzf83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 31 Mar 2011 21:19:27 +0200, "krzf83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org " wrote:
> There should be a way to make automatic checkpoints less frequent. On
> the busy ssd I have about 7 cp every second. If it were for example
> once every 5 minutes then one could set garbage removal every few
> days.

If your application does't issue fsync, this can be done by increasing
"commit-interval" and "watermark" parameters:

The commit-interval is creation cycle of checkpoints while there is
some change.  The watermark is a threshold count of dirty data blocks.
When the number of dirty blocks exceeds this threshold, a checkpoint
creation will be triggered.

These parameters are adjustable by "nilfs-tune" tool which is included
in the recent nilfs-utils.  For instance, you can change the
commit-interval to 60 seconds by

  # nilfs-tune -i 60 /dev/sdb1

where /dev/sdb1 is the target nilfs partition.

And, watermark is ajustable by

  # nilfs-tune -m <watermark> /dev/sdb1


See manpage of nilfs-tune for details.

> Also garbage removal should have option to clean only if like 90% of
> drive is used. there is no need to remove cp-s when there is still
> many GB of space left.

The cleaner included in the recent nilfs-utils already supports this
feature.


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
