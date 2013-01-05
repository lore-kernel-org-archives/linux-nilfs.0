From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Sat, 5 Jan 2013 17:47:52 +0100
Message-ID: <20130105164752.GG2080@wloczykij>
References: <20121129210650.GA4028@wloczykij>
 <1354255744.2090.3.camel@slavad-ubuntu>
 <20121130073219.GB4028@wloczykij>
 <1356415552.2052.11.camel@slavad-ubuntu>
 <20130103214913.GE2080@wloczykij>
 <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB@dubeyko.com>
 <20130104191633.GF2080@wloczykij>
 <C2F4A5DE-538B-4468-9A6A-BA619EDDA462@dubeyko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gDGSpKKIBgtShtf+"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C2F4A5DE-538B-4468-9A6A-BA619EDDA462-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 05, 2013 at 02:40:19PM +0300, Vyacheslav Dubeyko wrote:
> I simply try to collect enough details about the issue for deep
> understanding of it. There are two ways of issue investigation: (1)
> reproducing on my side; (2) preparing special debug output that can
> give more details about the issue on your side. So, I feel necessity
> to prepare a patch with additional debug output that can be enabled in
> NILFS2 in the case of special needs.
>=20
> Currently, I have such understanding of the situation. As I can see
> from the error output and preliminary code analysis, it occurs
> situation when allocation code discovers that memory page is uptodate
> before reading. It can means that we have synchronization issue. But
> it needs to investigate situation more deeply.
>=20
> Now I am preparing patch for another issue with very long mount time.
> So, when I end this activity then I begin more deep investigation of
> the issue with readonly fs.

Ok, I'll wait. Good thing it's just some KDE cache file. (:


Piotr Szymaniak.
--=20
  Czujesz  ostatni oddech opuszczajacy ich ciala.  Patrzysz w ich oczy.
Osoba w takiej sytuacji jest Bogiem!
  -- Theodore Robert Bundy

--gDGSpKKIBgtShtf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQ6Fk4AAoJEEMpAov1cw9l5OMP/iL9jnEimOS0ZaSZplYcyeh6
zFmfTSAvCt9WcNdql4HcyLOecciwCBpzzjPws8poHl8VPuIdKbeygCCyWjklYn1C
b4mV65lPOYGR1fFMTZctPD05dDKYgEXOYbPN8Ih3g0BZtTAqiMVkBITmcz3semFr
QSGB+beuGYxLODFIF0C65ieYrx7td2wyjVzCkMcPyB528YOUdaVPMi1hYsF5vX4g
7rX3y3adtSLaQlf0jQw8jjvv3Ze59k2ZlNy7y3AsmmraGdD1vm/Mzs/hpXbbbz6f
NePzjc1GTmnJaZ/mmiaZe/gJY/kYUfy8XtiwbhwBhm5AzVS+aA6nW9uKpP3jBs7X
mWBM6YQb+vQW5n8H19shORFRCtXlKFaiDX07OAu0I6j5NNIupP7JnKpA5a3IR5tQ
ALB9fwm3uahghI+PObJ1BBrYcT3gfKSll8HKW9miuf1VO7wS0AFBK92YcM5rZQFR
krt4ktTow61uCQhC0vjzU5S3Q0W3GQIwHfrzn1KOBNM2FPxpC/cjEelF4zM8iJbf
ov7DNCkjudlFtxDivs6OWRvragD/XBXkf2wHWkGLPX5fOnViaMg3PNakbigJ4Wjg
z8oCBrV3YxP45k1iT0UHUF/Dj1dUbo9Yvz1cpQZH7xs4OPXDK49gjziIngIqxWrd
nxrf40c8UPzQQHhyKsp8
=LiJ6
-----END PGP SIGNATURE-----

--gDGSpKKIBgtShtf+--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
