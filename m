From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: NiLFS2 partial segment finfo
Date: Tue, 4 Jun 2013 21:47:13 +0200
Message-ID: <20130604194713.GA3311@diablo.13thmonkey.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

would the Linux implementation grock multiple finfo's about one file even with
overlapping blocks ? say a finfo of ino 12345, followed by some finfo's of say
ino 123400, followed by some more of ino 12345? Or does it implicitly assume a
kind of ordering in the blocks?

In *BSD, and especally in NetBSD, buffer cache and memory mapping is done FS
agnostic by UVM/UBC. If a piece of file-mapped memory is deemed not needed
anymore its pushed out as buffer, basicly a memory extent and its file/disc
information. The pages describing that buffer are thus NOT at the FSs control
and will only be released after it gets signalled its written out.

I hope to save duplicating the written out data in memory by putting it
directly into the to-be-written-out segment, this *might* result in
pre-pending and moving data around if earlier blocks are written out later but
can also mean that other file write pieces are interleaved. The block number
assigning and its inode update and recording in the DAT i'll cache for sure
since thats nearly no data.

The reason for the mumbo jumbo is to avoid multiple storage of data: its in
the buffer cache until its given the signal its written out. Normally this is
just passed to the device and that shedules it and we're done and can/will be
automagically released later. Since we want to create a log however and like
to write out synchronous it has be copied and the buffer released ASAP to
avoid possible long delays. If i would just write out all the blocks after a
(yet) unfilled/unwritten partial segment header it would solve it but would
also create heaps of disc write transactions and a retrace of the head on
physical disks or a re-flash/relocation on SSD for the missing partial segment
header. Performance would suffer a lot.

Having best of both worlds would mean keeping two empty partial segment spaces
around easily eating a few (possibly scarse) megabytes. One for construction,
one for storage/overflow. You don't want to lose 4Mb for each mounted FS or is
that not an issue you think?

In short: what do you folks recommend? I like the two partial segment spaces
and having a backup-way by direct writing for memory challenged machines, but
would the linux way be and what would be a sane way?

With regards,
Reinoud Zandijk


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (NetBSD)

iQEcBAEBAgAGBQJRrkRBAAoJEIKcNwBDyKpojK4H/0khbak1a9DN8WwSje2SI+ey
AxO5mHSKsthvkeJwIntIXP0bMwsSLVcbYAGmw/f5KQCB19H7MA5R/um0L72f5Q05
P4RON8plWddRoRHs38Gyk7eWZRWAZmtcu6wQND/ygHmN+I+xlXOr7k0ApVpPPMt9
fA+48omvCV+6glbBRzaPVrOfebR+R7D2AfvQODEAWSfbCd2dT4oRteKuCUliQta9
4stnuGSNhqzGUZQGfG1MHtEa6s4rryEz3dmemyKX8Lz6r69uD6OQufO1s8a4TsCU
LRdOQSpsCaqSe/rE4mLXogZORaVkQ8OpVxujFnhfn8NWKRDwl9bKUv2mk14rDrs=
=g9jQ
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
