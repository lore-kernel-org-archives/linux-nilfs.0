From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: directory entries
Date: Mon, 1 Sep 2008 13:07:30 +0200
Message-ID: <20080901110730.GA21008@aardappel.13thmonkey.org>
References: <20080825155243.GA12855@aardappel.13thmonkey.org>
	<20080826.192942.104752679.ryusuke@osrg.net>
	<20080826132944.GA17045@aardappel.13thmonkey.org>
	<20080901.143956.08023399.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1826381291=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080901.143956.08023399.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org


--===============1826381291==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Dear folks, dear Ryusuke,

On Mon, Sep 01, 2008 at 02:39:56PM +0900, Ryusuke Konishi wrote:
> Or, we can just think the ``main'' stream was replaced by the
> continued snapshot every time it is mounted in rw-mode.  In this case,
> the head is regarded to be moved to the new (latest) checkpoint.  This
> is actually convenient for the recovery in which a user pushed
> ``recover button'' for the snapshot.
> 
> Note that even the old head becomes a plain checkpoint, it's still
> mountable and continuable again by being changed to a snapshot.

sounds reasonable yes... but why would that give problems with the DAT 
file? If you allways load the DAT, CP and SU descriptors from the latest 
checkpoint as recorded in the superroot even when mounting a snapshot 
read-write all is ok i think. The `old head' will be preserved initially as 
will be all allocations. If you want to keep the old head you'll have to 
make it a snapshot and thus protect all entries that have the old head 
snapshot in their intervals.

Changing the `old head' snapshot to a checkpoint will just result in the 
cleaned up AFAICS. Do you expect trouble with the current interval code in 
the cleaner? I can't see why the DAT would need change.

> To that end, this file must be extended to handle multiple lifetimes
> per block, and this would complicate the DAT.  Without the DAT file,
> things are not so difficult.  This would be achieved in a future, but
> in the meantime, I'll use rsync to continue snapshots ;)

are you thinking about removing the DAT file?? I thought it was the 
addition to v2.0 :)

> > We could also give snapshot/head a name; then 
> > increasing checkpoints is no issue if you keep the head name
> 
> Yeah, this would be possible by adding another meta data file
> (e.g. tag file) which maps the HEAD names to checkpoint numbers of
> snapshots.  When keeping multiple writeable snapshots, this kind of
> extension would be demanded than now.  However, I'd rather do this in
> userland with a regular file (i.e. a DB file) or with TAG files each
> of which simply records a checkpoint number.

The extra meta file sounds good but i dont like the `userland' DB solution; 
it would make nilfs dependent on DB4 (or the like) and it could make it 
non-selfcontaining.

With regards,
Reinoud

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (NetBSD)

iQEVAwUBSLvM8YKcNwBDyKpoAQKVJggAtSG0lIAbkBGDypgS5Y7SvJ0u8D77VlUC
kP0tofpQ99bjOICqvPWNTS8+VQEQR0lQawXh/M0iO6sqgS6q+SEhzF+0a7UWTOF4
2s/qLEHYNfNmL1nM17ghiXeBwF0DEdiO3KeJpkxqZRptKp89tRLNsXT87j4pGgIQ
Jr180KYguEsEClNg2Hs91rxIJ5xAhoy2HeyjxPKsbZEpFHP/Fv7HnhAw8gxp9bT1
+nnszfqlzMEdIKVytoRat7mQbYqA/VnEMMw88MrRllPldzWOrb7Li2sUwU0YsvgS
+Tvc6ENwXP2XwN5+jD8tU4KPEPT9j3xe7M2S455zvcoCQrE9/Us+hQ==
=y7oq
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--

--===============1826381291==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1826381291==--
