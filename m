From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: error mounting, input/output error
Date: Sun, 3 Dec 2017 20:46:33 +0000
Message-ID: <23076.25257.852880.921888@tree.ty.sabi.co.uk>
References: <ec8264d8-fb4c-b584-88c1-41ba293aa826@rapidbsure.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ec8264d8-fb4c-b584-88c1-41ba293aa826-F+CjGebjtwRZroRs9YW3xA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> There is no fsck function available, and I failed to copy the
> image and reinstall to a reformated partition- as explained
> below.

The traditional recovery technique is to mount an earlier
checkpoint, and then to make it  by turning it
into a snapshot. Something like:

  lscp /dev/sdb2 | less
  mount -t nilfs -o ro,nogc,norecvovery,cp=... /dev/sdb2 /mnt/sdb2
  chcp ss /dev/sdb2 ...

It is quite important to specify 'nogc' to make sure that
earlier possibly "good" checkpoints are not deleted by the
cleaner daemon.

> Can someone please suggest how to recover the data?
> [ ... ]
> [ 3527.536887] print_req_error: I/O error, dev sdb, sector 3820642528

Well, the disk has hardware issues (around the end, that sector
is about 1.8TiB from the beginning), and the easiest thing would
be to restore from backup onto a new disk.

Investigasting the extent of disk damage with 'smartctl -x
/dev/sdb | less' might be useful, as well as any other standard
disk damage investigation and mitigation technique.

Then you can use 'ddrescue' to image the block device onto a
new known-good block device and then mount a checkpoint from
that.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
