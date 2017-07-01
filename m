From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: nilfs bad btree node and broken bmap
Date: Sun, 2 Jul 2017 00:33:46 +0100
Message-ID: <22872.12634.189129.959335@tree.ty.sabi.co.uk>
References: <CAOdi6ianj9cgMHwjSzAkd=f2o3-i5KX4mznnR5hDzsN7ggKLdg@mail.gmail.com>
        <22870.39764.148116.59757@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <22870.39764.148116.59757-HsBtKtDIwYdYO2OccljXW7VCufUGDwFn@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

[ ... ]
>> Jun 28 15:57:08 c1-df kernel: [ 1637.138168] NILFS (sdd1): bad btree node (ino=6069196, blocknr=446552325): level = 69, flags = 0x24, nchildren = 8203
>> Jun 28 15:57:08 c1-df kernel: [ 1637.139363] NILFS error (device sdd1): nilfs_bmap_lookup_contig: broken bmap (inode number=6069196)
[ ... ]
>> How can I fix this?

> Mount earlier checkpoints until you find a "clean" one, then
> delete later "unclean" checkpoints. If there is no earlier
> "clean" checkpoint, some IO error has damaged existing data.

Further words of caution: the errors above can be merely
inconsistencies in very recent metadata due to a crash, or they
can be the result of some IO error damaging existing data.

In the latter case we know for sure that some NILFS2 metadata
has been corrupted, but we don't know whether some _data_ inside
existing files has been corrupted too, as NILFS2 does not do
consistency checks for data/payload.

As the documentation says, it actually checksums each "block",
but currently this is used only to detect incomplete metadata
after a crash, and no verification of the checksum is made for
data.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
