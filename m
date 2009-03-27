From: Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
Subject: Re: continuous backup solution with nilfs
Date: Fri, 27 Mar 2009 19:39:03 +0100
Message-ID: <200903271939.10744.Martin@lichtvoll.de>
References: <4577.84.133.242.204.1237943266.squirrel@ssl.its-beck.de>
	<4701.84.133.208.102.1238029603.squirrel@ssl.its-beck.de>
	(sfid-20090326_101612_833111_B8A09D8C)
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1655605824=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4701.84.133.208.102.1238029603.squirrel-lZV7jZi4TBeO2lRZCxuEEg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============1655605824==
Content-Type: multipart/signed;
  boundary="nextPart23388749.egT63tLng7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart23388749.egT63tLng7
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Donnerstag 26 M=E4rz 2009 schrieb mail-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org:
> Hi,

[...]

> So for now, creating an indestructible block device is a fun thing to
> do and provides a backup solution with features way beyond most backup
> software out there.

Well I can hear myself thinking "Ihr habt doch alle einen an der=20
Waffel!" - roughly "You have all just gone completely nuts!" ;-). One of=20
the standard saying in the company I work.

Crazy stuff you setup there ;-).

> Good:
>  * incremental block-level backup
>  * point-in-time recovery for both, single files and complete volume
>  * works via network, so off-site is possible
>  * real-time backup
>
> Bad:
>  * No cleanerd for this - have to replace volumes by hand
>  * Much backup-space overhead
>  * Probably lots of traffic
>  * No warranty whatsoever, ymmv

inconsistent filesystem in snapshooted loop files? You'd need xfs_freeze=20
before syncing the raid to get a consistent one, I believe.

One thing: Can't you use LVM snapshots in a similar way? Hmmm, I think=20
performance would crawl with more than a few snapshots.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart23388749.egT63tLng7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknNHUcACgkQmRvqrKWZhMcL9gCfbA5kFLQ6KkGopqLHyrWQSUKO
6pgAoJNUsvE6PBazn9c8aLdg4TlILUj2
=NRcj
-----END PGP SIGNATURE-----

--nextPart23388749.egT63tLng7--

--===============1655605824==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1655605824==--
