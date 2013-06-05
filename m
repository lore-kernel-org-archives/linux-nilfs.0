From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: My NiLFS2 port to NetBSD: status update
Date: Wed, 5 Jun 2013 11:03:00 +0200
Message-ID: <20130605090300.GA201@diablo.13thmonkey.org>
References: <20130604140257.GA713@diablo.13thmonkey.org>
 <20130605.092130.52167382.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130605.092130.52167382.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ryusuke, hi folks,

On Wed, Jun 05, 2013 at 09:21:30AM +0900, Ryusuke Konishi wrote:
> > I've picked up development, re-starting again, learning from earlier
> > mistakes.  Has anything fundemental changed in the last few months? I've
> > taken in the changes for volume name, the 2nd superblock and such, but is
> > there anything more?
> 
> I think no big changes are made in these days.  Most changes are bug fixes,
> or problem fixes.

Thats reassuring and at the same time worrysome ;)

> > As for the adoption of NiLFS2 in Linux, i've seen mixed responses in
> > reviews.  Most complain about the read/write speed. Since i dont have a
> > reasonable test setup and my implementation is not writing yet, how are
> > your thoughts about this? Is it a fundemental issue or is it more due to
> > way its implemented?
> 
> Yes, it's not satifactory in performance at all, at least for our NILFS2
> implementation of Linux.  Both read and write speed should be improved based
> on measurement.  Unfortunately, I have no time these days to make effort on
> this.  As for performance, at least the following tasks are still remaining.

PS Sorry for the long mail, i think i started getting things thought out for
myself too :) Hopefully they are of some use!

> - fast inode allocator

IIRC there are bitmap blobs detailing free-entries already aren't there?  iWhy
not create a run-length encoded cache of found free space? i know, run-length
encoded list maintenance sucks and is very error prone but if you keep a list
of freed stuff too and merge the two lists at times it can be a lot easier.
Saves a lot of bit-grovelling to get a (next) free spot.

> - fitrim support
i have no idea what this is really, a kind of trunc support? removing
to-be-written-out blocks from the buffer cache/segment writer when possible?

> - btree based directory imlementation
not needed to be bluntly honest and it would complicate stuff quite a lot. As
you might remember from my earlier posts, i've created a hash-table based
directory lookup that gets constructed on initial directory read-in and it
easily speeds up directory operations with a factor 10 to 100.000 in cases. In
the hash-table only the pairs (hash, fileoffset) are recorded. On search, you
hash the name you look for, look it up and one gets interatively a number of
file offsets (on block alignment in this case) to check. Just check those
blocks and see if one can find them, caching does the rest. It transforms
directory lookups from O(n) to O(1). Even small directories are accelerated on
creation since it isn't O(1+2+3+4+5+6+7+8) but O(1+1+1+1+1+1+1+1) speeding it
up from 36 to 8, a factor 5 already for 8 files effectively transforming even
directory creation from O(nlog(n)) to O(n) IIRC. This speed up will be less
dramatic for block aligned results for small directories but would be if the
entries returned were indeed at file offset. Problem with that is deleting
stuff since for some odd reason free-space in a directory block has to be at
the end of the block isn't it? It would complicate renaming/deletion if not
using block aligned.

> - revise gc algorithm
I have to say the current gc algorithm is quite wastefull in its disk updating
yes. Since the number of alive blocks is recorded already, why not go for the
low-hanging fruit first going for the sparsest segments? In more quiet times
the less sparser segments gets handled anyway. It won't then just go round and
round copying segments that are hardly if any touched. If you want a real
optimiser, why not seek essesively chopped up files and explicitly re-lineup
those files? That could be done in parallel to the normal gc or as an extra
service if free space is enough and seen as a nightly maintenance job ;)

> - fsync/osync optimization
I plan on creating a `synchronous' writing implementation and on auto-fsync
flush all dirty buffers from the nodes to the segments. I have a FS wide
rwlock around that uses a multible claimable read lock on every operation
entry/exit and the segment creator optionally aquiring a write lock. This will
assure that no operations are active and the data is consistent if the write
lock is taken/granted. If a snapshot is due or is requested the segment writer
can use the write lock otherwise a read-lock will suffice.

> - direct io (write) support
Actually i have never seen a program use it, but isn't this more a
fire-and-forget? I think its outside the FS in *BSD, i have no idea.

> - improve pre-fetch
On a file/directory read-in my implementation issues the longest continuous
stretch it can get based on translating block numbers to physical block
numbers, upto 64 blocks or so. This gives quite a bonus and is quite easy to
implement. I dont think its worth going over holes, the cost would be too much
and on the next read one can search/readin a chunk in one go again anyway.

> - lock free log write; the currrent segment constructor locks r/w semaphore
> during write, and successive write requests to page cache are blocked.
Ah, your page cache and your segment constructor are intertwined. My plan is
to copy/COW blocks to the segment writer memory space and let the buffer cache
delete their reference if it wants. I plan to use a piggyback snoop to avoid
multiple block updates/reading back in problems. The buffer cache itself can
operate then idecoupled and as long as its not having a miss its not dependent
on the rw lock of the segment constructor for snooping.

> - etc
I really hope you can get some more time to perfect it. It would be a shame if
they let it stay in this state esp. since it has so much more potential.

Sorry for the braindump :) Oh, how is the fsck_nilfs going? i plan on creating
a fsck_nilfs my own as part of the development process, just as an assurance i
dont mess up my btree's :-D That code is still... well, not that good ;)

With regards,
Reinoud


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (NetBSD)

iQEcBAEBAgAGBQJRrv7EAAoJEIKcNwBDyKpo2XUH/RiDofsjuTBZfjeG35HvtKTM
uGM4aCfhkNXLmqVGCYRTiKDXF4cFYiWn3AJoXuTw0Ws7p/nYvHmil+xu+3uqOpIl
K8xxRV9SVhThubbgJ5y56ISZMiX2ajErABf6HQkkz0VBN1Q/N9TDzKLuI2BApOr8
b1ZzdWM4NP4fSUv2IKzG8L7lKJ4fVpFdoDbif9pGvRajnU3S1UBArCvkNfoFULnW
Nx2FkGL3uvhb4usRngGjQlSWjylhcIdZbncqSqQPdanCq7zpTAF9vmCpSl8qv4wp
wTT8DE+Rn7DLEb72YIjTcsvCvVLSDJ+K92e+z0954+FywTvMheQszDHX1tXN8jE=
=tOtU
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
