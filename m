From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: snapshots contain the same rrd database
Date: Wed, 26 Feb 2014 15:21:40 +0100
Message-ID: <20140226142140.GD2022@wloczykij>
References: <20140226133201.GA2022@wloczykij>
 <1393422861.5481.9.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EgVrEAR5UttbsTXg"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1393422861.5481.9.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--EgVrEAR5UttbsTXg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2014 at 05:54:21PM +0400, Vyacheslav Dubeyko wrote:
> Hi Piotr,
>=20
> On Wed, 2014-02-26 at 14:32 +0100, Piotr Szymaniak wrote:
> > Hi,
> >=20
> > I got a system crash after some 160+ days uptime. After a hard reboot I
> > noticed my rrd database looks corrupted.
> >=20
> > So I changed some recent checkpoints to snapshots, mounted them and...
> > all the rrd files are the same!
> >=20
>=20
> To be honest, I don't understand clearly:
> (1) How did you get the issue?

To me it looks like the file hasn't changed since the first boot. Like
it's not written at all? Is there a way to check something like "file
position" on disk in specific snapshot?

rrds are a bit weird databases. When created they are, ie. size A. And
all the way in time they gather some data and are always in that size A.
The size doesn't change. Maybe this is related?


> (2) Did you create snapshots after crash?

Yes.


> (3) Had you some snapshots before crash?

No.


> If you had a crash then you should have some error messages in the
> system log. Have you something? Or did you lose all error messages
> during the crash?

The crash was related to a process running on a different filesystem. My
syslog has only garbage, so yes, it is lost.


> Anyway, I need to have the reproducing path for investigate the issue.
> Of course, I am not going to wait 160 days before achieving the issue
> reproducibility. :) One of the possible way is to share some small
> NILFS2 volume with good issue reproducibility. But, currently, I don't
> quite follow in what way I can reproduce the issue.

I suppose this could be related to this "size A" mentioned above. Will
try to figure out some reproducibility path.

Piotr Szymaniak.
--=20
Jest  tam  jedno  powiedzenie...  nie pamietam go dokladnie,  ale brzmi
mniej wiecej tak:  "Czlowiek wyczuwajacy wiatr zmian winien budowac nie
oslony od wiatru, lecz mlyny".
  -- Stephen King, "The Dead Zone"

--EgVrEAR5UttbsTXg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDfhzAAoJEEMpAov1cw9lQnkP/3/cHVmdKIzhf/WJYvFNXFAf
opPJ+j3N+G1Z8H+SttoZ6gIND6LK/9Gxm2cLw5iOYcAKr4z1hg7mA4LrvGgtoxKO
uk7Qc6y7OSayHQZvycghOzHInje5VVRmlaabAsYz3Ls5ztYDzV1XBFxG7dguVfdB
/XlDl8fjcKEBd2f7jgykxqjtSF9d4I0slKOZzLBF2h6cJpyyjBLB2pva8FD9UsCr
NJHdsgdCV1wnBhOtnrAKSykyEXCCP//rSUNPoUMxW5kK3bFzPRW1DgvIDdWrWEky
IWoHFpdCMl9pRZampDl/U8jGtbwGUKK44P41A0Hij0zeUa2ZL7CZQldpmQyrmX3/
M73rmsev/0xQ/mQI8DZHQl9Xqv3U/Mkt26AbqsqNIYQ1o65AMe+oEr8km0QdkoWW
I1e3x9xhwaEh64JWn9ruXtxO167zJlzY1CH9JamCYPRifuZnIsJFEYHWt8HjRlBO
EpNbV/Lndh8vvR2d0+l0+d/I3TFDzuAEQZo2YLgOsosjEVV75HDBLM8XZYwGDg5F
advZ8cKW7nLotzmk6G8rKzYrgaNd/y2+y8K8maN6gFyl93fpXcBLOtap+Co+YNey
zPBHNZZO6Uf2961euLtSFTNDuc09vY/2U5lZhWR7cr3xXWsfsJmrCnP5vsSV9E7Q
vCSepFQKbyWoFm2S0Lwt
=xgEe
-----END PGP SIGNATURE-----

--EgVrEAR5UttbsTXg--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
