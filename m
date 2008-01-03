From: Gergely =?UTF-8?B?R8OhYm9y?= <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: __udivdi3
Date: Thu, 3 Jan 2008 03:41:54 +0100
Message-ID: <20080103034154.bf6c74be.elentirmo.gilgalad@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0020702589=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:subject:message-id:x-mailer:mime-version:content-type;
	bh=nwusxPO+SKoNX4VlSPyhd5lSIP3RhHnev5N2j+NpNp4=;
	b=EU4yMF/YgOfOBwfNS456Y0NGQHa3vr4Mapb8qJp11KMweQkvBzZQG00xstBsREusY091JMMaUR3ecsgrCT8eBU/Mq9COpq+8+a7e3mwd4/WtiHPTbt6nslM+ZdBtmuXn+/Tb9fW7w6M3awwN8zNhXStpsEJj4ZCoLrcKCAoo21w=
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============0020702589==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Thu__3_Jan_2008_03_41_54_+0100_4lr_YO.d9fMORpM2"

--Signature=_Thu__3_Jan_2008_03_41_54_+0100_4lr_YO.d9fMORpM2
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hello

i was about to try nilfs (testing-8) but altough it compiles, it doesnt wor=
k, as it can't find a symbol:

  Building modules, stage 2.
  MODPOST 1 modules
WARNING: "__udivdi3" [/home/ggergely/tmp/nilfs/nilfs-2.0.0-testing-8/fs/nil=
fs2.ko] undefined!
WARNING: "__umoddi3" [/home/ggergely/tmp/nilfs/nilfs-2.0.0-testing-8/fs/nil=
fs2.ko] undefined!
  CC      /home/ggergely/tmp/nilfs/nilfs-2.0.0-testing-8/fs/nilfs2.mod.o

insmod also complains about this. Found a latter on this list, but I couldn=
't find a solution. Serche the net but i couldn't solve the problem (I didn=
t even find where is a reference to this symbol....)

Regards: G=C3=A1bor Gergely

--=20
Gergely G=C3=A1bor <elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--Signature=_Thu__3_Jan_2008_03_41_54_+0100_4lr_YO.d9fMORpM2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHfEt5lZGsj+xzT3kRAgTwAKC+4gIPf0WZ7uqFlwzNVnXITuqfRgCgnIcS
eaVMY7M2rqJ8Tps5gh+mCx0=
=eMjK
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jan_2008_03_41_54_+0100_4lr_YO.d9fMORpM2--

--===============0020702589==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0020702589==--
