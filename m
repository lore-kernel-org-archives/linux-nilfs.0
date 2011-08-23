From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: lscp - what's NBLKINC and ICNT? (and the i FLG)
Date: Tue, 23 Aug 2011 10:53:30 +0200
Message-ID: <20110823085330.GA1472@wloczykij>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

I just started (~2 weeks ago) to use nilfs2 on my / and i'm missing
some information about those last two attritubes of lscp. Looking back
at the list it seems that the first one (NBLKINC) is changed blocks
between checkpoints, but i'm unable to find what's the last one (ICNT).

wloczykij ~ # lscp
            CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
          27193  2011-08-19 15:25:38   cp    -         87      37613
          27194  2011-08-19 15:27:39   cp    -         20      37612
          27195  2011-08-19 15:30:09   cp    -         58      37615
          27196  2011-08-19 15:32:09   cp    -         38      37612
(...)

Some checkpoints also are marked with "i" FLG. I think this also was
answered on the list before, but i cant dig the answer.

Is there some doc on nilfs homepage about those attributes that i'm
missing? (or man?) I would appreciate if someone could point me to
some answers. Thanks. (-:


Piotr Szymaniak.
--=20
 - =C5=BBona? Id=C5=BA si=C4=99 pan leczy=C4=87!
 - A =C5=BCona, gnido. Twoja pewnie trzyma ci=C4=99 za pysk, gdera, psuje k=
rew i=20
to ty, frajerze, wkr=C3=B3tce b=C4=99dziesz musia=C5=82 si=C4=99 leczy=C4=
=87. A moja jest z gumy=20
i nic nie m=C3=B3wi.
  -- Andrzej St=C4=99pniewski, "Ojciec"

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5TaooACgkQ9xNbxaeWTTwAeACeLrNfY+wTFHOzY5/LmmRjer8/
F94An2cs01sGhjSig92gsM6OB/ERqgco
=Erhq
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
