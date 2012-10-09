From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Tue, 9 Oct 2012 12:52:39 +0200
Message-ID: <20121009105239.GV28032@wloczykij>
References: <20121008222557.GU28032@wloczykij>
 <1349767793.3427.7.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PtLnLSExlPr13a2X"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1349767793.3427.7.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--PtLnLSExlPr13a2X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 09, 2012 at 11:29:53AM +0400, Vyacheslav Dubeyko wrote:
> Hi,
>=20
> On Tue, 2012-10-09 at 00:25 +0200, Piotr Szymaniak wrote:
> > Hi list.
> >=20
> > I'm using nilfs2 on my Raspberry Pi rootfs. I've played around with
> > Raspberry Pi Turbo Mode and today it refused to boot. It's a headless
> > setup so I moved the SD Card to my other machine and tried to mount
> > rootfs partition:
> >=20
>=20
> As I can understand Raspberry Pi Turbo Mode is a hardware overclocking.
> So, I worry about proper working of SD-card controller. It is possible
> that the reason of the issue can be not proper controller functioning or
> concrete SD-card issue.

It's an =E2=80=9Callowed=E2=80=9D overcloking. I have another SD Card with =
Raspbian (and
without nilfs2) that works fine with Turbo Mode. At least it seems to
work fine. The second card was in Turbo Mode (@900MHz) for a few days
and was working. Yesterday i made it @1000MHz and it didn't boot.


> Could you try to reproduce the issue with using another SD-card in Turbo
> and normal mode?

Not now. Don't have any image of my setup with nilfs2. ):


> I think that first of all it needs to detect that it is NILFS2 issue but
> not hardware or MMC stack issue.

Will connect some screen via HDMI to check if there's some error msg.
The card should be fine, but I will dd it to disk to check for read
errors.

Piotr Szymaniak.


> With the best regards,
> Vyacheslav Dubeyko.
>=20
>=20
> > maszyn ~ # mount.nilfs2 /dev/sdf3 /tmp/rpi
> > mount.nilfs2: Error while mounting /dev/sdf3 on /tmp/rpi: Invalid
> > argument
> >=20
> > dmesg shows:
> > (...)
> > [43893.754525] segctord starting. Construction interval =3D 300 seconds,
> > CP frequency < 30 seconds
> > [43893.760245] NILFS: corrupt root inode.
> >=20
> > Where should I go from here? I can hook it up via HDMI to some screen to
> > see if there's some error msg on rPi.
> >=20
> > I'm using official Raspberry Pi linux 3.2.27 from github [1] (last
> > updated 2-4 days ago).
> >=20
> > [1] https://github.com/raspberrypi/linux
> >=20
> >=20
> > Piotr Szymaniak.
>=20

--=20
  Powiedzieli nam,  =C5=BCe zbrodnia jest czym=C5=9B z=C5=82ym i nieludzkim=
, a p=C3=B3=C5=BAniej
nauczyli nas zabijac.
  -- Wieslaw Gwiazdowski, "Mysliwi"

--PtLnLSExlPr13a2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJQdAH2AAoJEEMpAov1cw9l3lkP/jgIj7ykyaof/QGrac1A9lGi
MW0/oSlsHr8jZJWRPshiF1QtzWYcwyhKg6O+RQDnzq7mCsmH9vxvXqK+mcveATAM
/zHeHIEfikiu3XpM7hgytMgFuCEgwKIwhhArNFxRysk7sEm7cFGDkW50uICtoPew
YgJwJIoSCgtJqnxY4JFiNhl/6fhkDWj43tESIQo3jtHAju+5KesW48C5hYbM1GEq
iPvjNCSSHHcMTA4iln5un6IzOfSnd5NLCIsnfOiePwCw1tfBvmngCiV5owHT60kg
0Zh1yTbD8OwNLjMHLnAxzf6xlAbrJ0q/eefBpSVy1WRCoAtTY8ocwGSZwEJeTQ88
IOD1KUruU2Y5SJH6KnXQOP3AUHocoBy4yc7mBJnuFQy18SGN2myiAYDVSVpybvjy
ZDpjMK4o0PTzCdIwR3yImmrgcUyf6sAB3+XDwlQczIiOFzMd4S0ANVsmxHRpEv2w
fQShrQKR1ACSM8eGN9f+pveYdx7CZJ4dAJoF2U3OTr3L4Z5Yk3802hyuJjP4H6w7
O7lvh4hTTVz+t3kFLsGDbf+EmVbxsmBER2GgsxTd+9RETQTQ78Oz4CYDMvbgWAxq
V+khWJmdQjcxz43y3E/mASZtudSeBQ48LL471FMxThC8Nzb65GmIODZma5IPmw3r
dLMVOWvSxZEylhPmHOMh
=FoHN
-----END PGP SIGNATURE-----

--PtLnLSExlPr13a2X--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
