From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Sun, 31 Mar 2013 15:26:09 +0200
Message-ID: <20130331132609.GA1781@wloczykij>
References: <20121128205943.GZ4028@wloczykij>
 <1354172459.2077.11.camel@slavad-ubuntu>
 <20130328120700.GK1672@wloczykij>
 <E24177B1-2EF0-4274-BD13-4642E3663D08@dubeyko.com>
 <20130329074249.GL1672@wloczykij>
 <1364544910.11128.9.camel@slavad-ubuntu>
 <20130329103710.GM1672@wloczykij>
 <1364556557.11128.28.camel@slavad-ubuntu>
 <20130329135722.GN1672@wloczykij>
 <1D751B59-8E60-4D32-80CA-734BD25EE12C@dubeyko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1D751B59-8E60-4D32-80CA-734BD25EE12C-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 31, 2013 at 03:14:00PM +0400, Vyacheslav Dubeyko wrote:
> Your sysrq-triger output is really strange. The sysrq-triger takes
> momentary system state snapshot. So, this output makes sense only
> inside issue occurrence. And I feel that this output was taken after
> issue ending. Or, maybe, it needs to make several trying of getting
> sysrq-triger output during issue reproducibility.
>=20
> I think so because flusher doesn't make something NILFS2 related and, mor=
eover, it simply sleeps:
> *snip*
> The nilfs_cleanerd daemons sleep also:
> *snip*
> The segctor thread sleeps too:
>=20
> Maybe I misunderstand something but your sysrq-triger output doesn't
> contain info about any NILFS2 related activity. So, I can't see any
> details about the issue with kernel flusher thread in shared
> sysrq-triger output.

Hrm, maybe this is btrfs realated then? But I suppose I don't have any
btrfs on the second machine with flush issues.

I had a system freeze yesterday and right after reboot flush is back.
So it looks like I can reproduce it (something makes the flush thing
while booting. Maybe I can catch some debug info there?). Right now I'm
going back to 3.4.x series kernel.


Piotr Szymaniak.
--=20
Siedzia=C5=82em z (...) takim, co w=C5=82ama=C5=82 si=C4=99 do budki z piwe=
m i ca=C5=82=C4=85 noc
wiadrami nosi=C5=82 piwo do domu. Mia=C5=82 pe=C5=82n=C4=85 wann=C4=99 i ak=
warium, kiedy rano
go z=C5=82apali.
  -- Jacek Hugo-Bader, "Egzamin na =C5=9Bwira"

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRWDlwAAoJEEMpAov1cw9lHpgP/3XxQBJo7o00mkpRMmqVnxxo
7odY/P6/0INzRzU9UrUqjMUuxfGeMikI7Bd+9VvGZl85Svejcp6baiBrov9Pk6Rn
DstFHu01OaR/sD/9T6DUoKIHvoQBPslIKU7molCL9IxGzZlJAItBPaiom6wZxKWA
aSqPPhu+cYIGyOMaHBYfhzuE/Rd87CpfJ5k2GKzxvzlkt/nPKaFgF4JGmybiV5lt
u499Op8UruUuP5qLly0Y0ZzEdNZuT3LyRn6D3bQoMhFJ0xnf9IKTs73Sxv4n/Lg2
XRM08O3qDlbqXATe8lG9cqwV3YpnGnv+eYIpiJlTXJitiBW09MEouP/YxSriR07T
qmlreo/LaNV1ANA16uC5ld4pzd4oWAKCTnDpGT/nnWB7ybGnxd/L3NsZpgcaIqy1
p1emLd6oEIuNtEMC7p4N8P/IPsE5/uzpXmlmgoAFF8eYzxbW6XzoCcpPaLrbo78x
o+Va0EhIahZ3ZrACgjhlTWyUwQjw6nYsxkATd3l6YlLcmxLPuNThqL6ML/k+Fywb
oGNFQhTPIc9/B/mn0O3HdpArp1Dsr+e8MweKYaYWedoXKzMr7itIyDb/Zk1ppGaU
UDo0JLIJHhh7wK/fH+8Pd/nDqaq9KdnAP9X/iauuuUeKSWXIcJkGNwrDQh+mq89x
wLPbRecMnygFIcih2eQj
=CYa1
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
