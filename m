From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: NILFS error after power loss
Date: Sun, 16 Jul 2017 23:47:43 +0100
Message-ID: <22891.60687.912893.618455@tree.ty.sabi.co.uk>
References: <3909a3843e9fc28c7c1f7812f47b7b2b@fripost.org>
        <39eaa9df1d7d61fbcbfba585f26896e5@fripost.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <39eaa9df1d7d61fbcbfba585f26896e5-m2T68/X/qvZAfugRpC6u6w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

[ ... ]

> Apr 24 06:55:22 nixos kernel: NILFS (dm-0): bad btree node (ino=1609, blocknr=13626216): level = 51, flags = 0x44, nchildren = 12298
> Apr 24 06:55:22 nixos kernel: NILFS error (device dm-0): nilfs_bmap_lookup_contig: broken bmap (inode number=1609)
> Apr 24 06:55:22 nixos kernel: Remounting filesystem read-only

The standard NILFS2 recovery is to mount an earlier
checkpoint. This to be done quickly to ensure they don't get
deleted by the cleaner, but then if the system does not start it
should not start either.

Usually corruption like this is because of the storage system
not implementing correctly barriers, and that might related to
the use of DM (some versions lack that implementation). If
barriers do work the previous checkpoint to the faulty one
should always be correct, because it has been checkpointed.

Otherwise there is a a known bug that apparently is triggered
easily only by very high concurrent load, as it involves a race
condition:

  http://marc.info/?l=linux-nilfs&m=149992828611084&w=2
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
