From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: unrecoverable nilfs?
Date: Fri, 5 May 2017 00:16:06 +0100
Message-ID: <22795.46646.884137.561875@tree.ty.sabi.co.uk>
References: <CAOdi6iYum1qADni5sc2s-YteoTuAs7yFJ8V1MyGdq8VHyLB83w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOdi6iYum1qADni5sc2s-YteoTuAs7yFJ8V1MyGdq8VHyLB83w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Rodrigo Severo <rodrigo-sUXncmUOihszlUgHzu1iJkEOCMrvLtNR@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> [ ... ] the nilfs2 filesystems were affected nonetheless as
> the machine suffered several hard resets. [ ... ]

Most likely then some corrupted data was written to the
filesystem, because of incomplete barrier implementation, or
because of attempts to write damaged sectors or some sectors are
too damaged to read.

> [ ... ] (sdd1): bad btree node (ino=6, blocknr=1500850679): level = 0, flags = 0x0, nchildren = 0
> [ ... ] (device sdd1): nilfs_bmap_lookup_at_level: broken bmap (inode number=6)

Looks like some metadata blocks were zeroed, perhaps because
some sectors became unreadable.

> [ ... ] (sdd1): error -5 reading inode: ino=34057

  $  errno 5
  EIO 5 Input/output error

Indeed that's an IO error: the disk is damaged and some sectors
are unreadable.

> [ ... ] How can I fix

The first thing is to talk with the system administrator of the
system and ask them to check that the disks have no bad blocks,
and to check SMART logs for signs of bad block substitution
(almost certainly there will be some); after that you can
attempt to mount a previous checkpoint, going back in the
checkpoint list until un "undamaged" checkpointn is found.

Howevever NILFS2 already does a checksum verification on
mounting, so it won't mount damaged checkpoints, and the errors
above are not checksum errors. It looks like that because of IO
errors or bad sectors (still present apparently) the metadata
and perhaps also data in the filesystem was corrupted. NILFS2
like most other filesystems does not have built-in per-sector
redundancy like RAID, only checkpoint redundancy, which is not
as comprehensive.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
