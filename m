From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: Split some metadata onto separate device?
Date: Tue, 14 Jun 2011 13:18:52 +0200
Message-ID: <20110614111852.GA1263@heethoofdje.13thmonkey.org>
References: <20110608.214852.237935973.ryusuke@osrg.net> <20110608.215803.224753719.ryusuke@osrg.net> <201106081508.39345.dexen.devries@gmail.com> <20110608.224906.85409768.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110608.224906.85409768.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dexen, hi Ryusuke,

been a while since i was active on the list or active with NiLFS in general
but the last vacation did remind me why i started working on NiLFS for NetBSD
again! Using FFS, even with logging, UDF or msdosfs just doesn't work well on
Flash media ;)

On Wed, Jun 08, 2011 at 10:49:06PM +0900, Ryusuke Konishi wrote:
> > > > Yes, but extents will decrease the amount of metadata, and this has
> > > > potential for speed up.
> > > > 
> > > > NILFS2 uses 32 bytes metadata per disk block at present.  I guess you
> > > > know that the number of DAT blocks are actually indispensable through
> > > > analysis using the dumpseg tool.
> > > 
> > > Oh, looks confusing.  I meant the amount of DAT blocks is not
> > > negligible.
> > 
> > Understood ;-)
> > 
> > Anyway, isn't some fragmentation avoidance necessary to profit from extents 
> > (that we hope we'll use at some point)?
> 
> I guess it doesn't become a big issue unless we do many small random
> writes like database.
> 
> > AFAIK, an extent is only good to describe file blocks if they are laid out 
> > continuous on the block device.
> 
> Yep.  And, we know files are enough continuous in most cases.
> 
> We use at least 16 bytes per 4 kiro-bytes disk block to point the
> block (16KB for 8MB segment); btrees of nilfs2 use an 8 bytes key and
> an 8 bytes pointer for a disk block.
> 
> In typical case, this can be reduced to 16 bytes per file (16 bytes
> for 8MB segment) with the extents.
> 
> IMO, 64-bit filesystems have a reasonable reason to adopt extents
> though nilfs2 did not apply it.
> 
> I guess applying extents to the DAT file is especially effective.

I've used extents a lot in UDF since its all-extent based, and yes, it CAN be
a lot smaller indeed :) BUT only when files are NOT sparse and NOT fragmented.

Anyway, my sugestion is an intermediate one since it doesn't change the disc
format: on garbage collection, make an extra pass to seek (very) fragmented
extents in the DAT, how much might be a parameter, read it all in and then
relocate/write out a whole (or partial) segment with it. This could also be
done with the CP and SU files although those files are relatively tiny. This
will leave the DAT file in just a few segments when the filesystem has been
garbage collected and (hopefully) most references only within the segment also
easing cachability.

Other files could also be un-sparsified this way but i think the DAT will have
the most benefit and it's relatively easy to do this way.

With regards,
Reinoud


--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (NetBSD)

iQEcBAEBAgAGBQJN90OcAAoJEIKcNwBDyKpoYGAH/isK6BxXO5MIyn7SwJvCf+kF
dkH8PlewFsKDsTeKi+e/CEudf4vA9H5cctUkq9mgQLMjtsHHCZiNQAg/sokjGFej
W0xNxT5NB+dhrpQA/QgvSTQQOeJTIO0g/n9Ap2jmUlZqAgAuB3cO4zWGDDHgh6FR
qjiCGB88ltGjuwcl+sUnJchoUjT/futvT/ekkf/rwQWe0lltaX064sZtG5igHNCP
oQ1wIWX6j9qMed40BYHkXeDYBKkbBpXRyDStUyvnI6BBmvuR/Xy+4aS1LRAHT5+K
l7Hk46bQ/fwB1nuCiTlqwvQV0yjNqdpk6aSmMgJk2mQM56SUKathrucZNfG38RI=
=+JYR
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
