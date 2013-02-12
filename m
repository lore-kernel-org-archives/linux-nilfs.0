From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: Time issues with checkpoints resolved?
Date: Tue, 12 Feb 2013 10:29:03 +0100
Message-ID: <20130212092903.GD10316@wloczykij>
References: <20130129221021.GL10316@wloczykij>
 <1359525007.2085.10.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zmbF4WfaG2f6E7cU"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1359525007.2085.10.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--zmbF4WfaG2f6E7cU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 30, 2013 at 09:50:07AM +0400, Vyacheslav Dubeyko wrote:
> Hi Piotr,
>=20
> On Tue, 2013-01-29 at 23:10 +0100, Piotr Szymaniak wrote:
> > Hi,
> >=20
> > Sorry, but I can't find an answer and noticed some checkpoints in the
> > past in the middle of other checkpoints (there was a thread, I think,
> > about similar issue with timezone change).
> >=20
> > Right now I have (Raspberry Pi doesn't have RTC):
> > ~ lscp
> > (...)
> > 7870  2013-01-27 15:12:30   cp    -           22      42174
> > 7871  2013-01-27 15:34:23   cp    -           19      42174
> > 7872  2013-01-27 15:42:29   cp    -           22      42174
> > 7873  1970-01-01 01:05:05   cp    -           93      42176
> > 7874  1970-01-01 01:10:05   cp    -           22      42174
> > 7875  1970-01-01 01:36:36   cp    -           18      42174
> > (...)
> > 8031  1970-01-03 07:08:19   cp    -           57      42183
> > 8032  1970-01-03 07:13:20   cp    -           36      42182
> > 8033  2013-01-29 00:01:57   cp    -           30      42182
> > 8034  2013-01-29 00:19:34   cp    -          599      42313
> >=20
> > I just wonder if cleaner is now smart enough to clean this mess.
> >=20
>=20
> Unfortunately, it is not. Such fix doesn't made yet. I think that it
> needs to modify nilfs-clean utility. But, currently, I am deeply inside
> fixing of issues with flush kernel thread and bad btree node. These
> issues are slightly complex. I tried several solutions but I haven't the
> proper yet. Maybe, a final solution will be a combination of several
> fixes that I tried.
>=20
> But fixing of issue with timezone change in my TODO list.

Ok, can you (or someone else) refresh my memory what will hit me when cp
7872 will be cleaned? cleanerd will stop cleaning?


Piotr Szymaniak.
--=20
W   tamtych   latach   wiejskie   rodziny   chodzi=C5=82y  do  l=C3=B3=C5=
=BCka  bardzo
wcze=C5=9Bnie - "kiedy  robi=C5=82o  si=C4=99  ciemno  pod  sto=C5=82em",  =
jak mawia=C5=82a moja
w=C5=82asna matka - i spa=C5=82y kamiennym snem.
  -- Stephen King, "The Green Mile"

--zmbF4WfaG2f6E7cU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRGgtfAAoJEEMpAov1cw9lWagQALzRE6ZqlSw7GWYoFIeTIJg3
RYq27WicYCoko6Cx1h0A98RBIUabuT9XJ1rOWuPU+v6RyUDizMbOTFFzZhn0bHVX
dbVMuXSbMKIk3y7f9lrmNHyAHOp+Q2gJ4hOm3ute2CzdXBPxIj2E5vVZnBexfjs2
yJu9X3OjSNsmtK5dCraNhJDs+K0dnq/ykS+Pm6D5yQHt+Osq5OGoi/RgT684c4ay
GuITg0oOb+mOZofiHeNYojLZvJzpVzEN0RkSAyC4V01ALrQaba7Po5jXG39WZakE
+0MTMimB+mCG9cVpSyc5YMBR2uVaCvTR1ztm2k5MjC0qL23XQxyjDGdbdnvZpWKs
O2ET0hqSHfHHXy3Zru231VTxBHgtNPdHfAzNRDqsvGEP0X8WJKCEVywQl6DjC6Hx
IhaxEWsOkw7u3AfWTrLGbjt6wUBfuPmKRXcX9owcuscBhKXFKm1I/e+5lndu0oH9
bvzdMG7cM/Ryx0XFYQYAYBxnxQoj8gFC99hojmN2/8RubYbp+xiNF4CPTPGY9N6a
UKr41MJu6VttI4IwL9+VOdiyr1u81cvnPH0mxnFju46A+BduSayA79tM0d8X3GJK
CDOFFS+pOjQslB8btfPcqLvwhTHvHyhCpPASnLNvpmYAsaPF/fa8rOVs4LXjRbtV
ixB8VsyT4wgPrSMYdq6h
=rgzC
-----END PGP SIGNATURE-----

--zmbF4WfaG2f6E7cU--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
