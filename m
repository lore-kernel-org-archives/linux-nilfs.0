From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: nilfs bad btree node and broken bmap
Date: Fri, 30 Jun 2017 19:41:24 +0100
Message-ID: <22870.39764.148116.59757@tree.ty.sabi.co.uk>
References: <CAOdi6ianj9cgMHwjSzAkd=f2o3-i5KX4mznnR5hDzsN7ggKLdg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOdi6ianj9cgMHwjSzAkd=f2o3-i5KX4mznnR5hDzsN7ggKLdg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> I have a 8TG nilfs2 disk with started changing to read-only by itself.

Highly unlikely.

> My log files are full of the following error messages:

> Jun 28 15:57:08 c1-df kernel: [ 1637.138168] NILFS (sdd1): bad btree node (ino=6069196, blocknr=446552325): level = 69, flags = 0x24, nchildren = 8203
> Jun 28 15:57:08 c1-df kernel: [ 1637.139363] NILFS error (device sdd1): nilfs_bmap_lookup_contig: broken bmap (inode number=6069196)

These are typical of some IO error, even a transient one, or
more simply the outcome of a crash with not well implemented
barriers. I notice that the errors happen with a time offset of
"1637" seconds, that is less than 30 minutes after a reboot.

> I have already checked and there are not errors on the disk.

How did you check?

> How can I fix this?

Mount earlier checkpoints until you find a "clean" one, then
delete later "unclean" checkpoints.  If there is no earlier
"clean" checkpoint, some IO error has damaged existing data.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
