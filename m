From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Fri, 29 Mar 2013 08:42:49 +0100
Message-ID: <20130329074249.GL1672@wloczykij>
References: <50A65588.3000205@li.ru>
 <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com>
 <20121127151924.GW4028@wloczykij>
 <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com>
 <20121128142116.GY4028@wloczykij>
 <1354113560.2017.11.camel@slavad-ubuntu>
 <20121128205943.GZ4028@wloczykij>
 <1354172459.2077.11.camel@slavad-ubuntu>
 <20130328120700.GK1672@wloczykij>
 <E24177B1-2EF0-4274-BD13-4642E3663D08@dubeyko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="aWauiwyUFlp3+edf"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E24177B1-2EF0-4274-BD13-4642E3663D08-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--aWauiwyUFlp3+edf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2013 at 10:22:52PM +0300, Vyacheslav Dubeyko wrote:
> Thank you for additional details. Unfortunately, your sysrq-trigger
> output is not complete. So, I can't make conclusion about what
> operation was a reason of issue on your side. Could you send to me the
> full log of sysrq-trigger output?

How to generete more verbose log?

Btw looking at ps aux output it seems, that this flush is hanging there
almost from first boot:
root       937 88.2  0.0      0     0 ?        S    Feb17 50160:39 [flush-8=
:0]

And an uptime:
08:25:18 up 39 days, 10:57,  4 users,  load average: 0.72, 0.89, 0.98

Also I don't know if this isn't some kind of regression. I'm using nilfs
for, well, some time now (looking at fs creation date Aug 2011) and
didn't noticed any strange behaviour before. I think I won't be able to
check this, but before that last boot I used (95% sure) vanilla kernel
3.4.4 and it was not flushing things or I didn't noticed. I could go to
some older LTS kernel on other machine and check that.


> I can easily reproduce the issue by big file (100 - 500 GB) deletion
> or truncation. Please, find description in:
> http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01504.html.

If this brings something new - I'm not using huge files like that (this
flush above is a 3.7G device). But if this reproduces the issue, it
could be related.  (:


Piotr Szymaniak.
--=20
Og=C3=B3lnie  rzecz  bior=C4=85c,  chodzi o r=C3=B3=C5=BCnice w obj=C4=99to=
=C5=9Bci  i  spiczasto=C5=9Bci.
Kiedy ogl=C4=85dam zdj=C4=99cia w "National  Geographic",  widz=C4=99, =C5=
=BCe cycki kobiet
niewiele  si=C4=99 r=C3=B3=C5=BCni=C4=85 od tego,  co ma koza czy krowa - t=
yle =C5=BCe s=C4=85 troch=C4=99
bardziej niewygodne.
  -- William Wharton, "Birdy"

--aWauiwyUFlp3+edf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRVUX4AAoJEEMpAov1cw9lr2cQAJztjYjZ97AFP743mPLZchvv
QAiXckrCCg0iaQ4dHVwZI6jgI7fZ4RWNtw1lkUm7Fq6vvMkZb5A7rX7xKkUT7iY8
KJQ3lubHgcJUaDfBiTxXGq7anOjOKcJb3HXkvZxC3HfyQihe1OjmALQectTG3FUx
7Jt0rJI0JovReKNOB19pbmoMVe0xdqfhm1aUQoCWL9B1TREtiQLIwLoj3+apdV0c
qLLKv6hVsl6G3nB6+fV9ZgDA04P1ohKNsFDHruDn5eVgATXMyqVjiBA2hB9XEM65
W2hXHNS+W7G6N4eKyOhOvsABs4z51RqAbc3TW1g0TeHuV54o/JLJ86HWqBph+exW
cHmGXzBScY5KMEnbjEUjfMS94go+pScWNqlfn6YWNpP6Uj4pODoJv+PBHw1pQB2t
49AKHeEFjtFaZFkbRE7AcuiFROkJ+q7n797qbwAFogHZlQjHEyFcHI0yFxromKHE
cjC9MexcWDLNku7dacpVs2oM8nujzmWS+7IQGimWOs1kXCVp6zXgTXRSlsftTZs3
QWENuyGFrZhvxtlF7cXkEXh712vC2gsST9EW34Dh7x7TivPNiagkFtQnoEQEhb84
VIZo2NjdyRBDNkZFO+b1DGj8PwyQu7rmZwoJat8LSmR3eTqotPjPP/EM4TlZjNC+
vTXhGy+4rbRHysDaDA9J
=5aEm
-----END PGP SIGNATURE-----

--aWauiwyUFlp3+edf--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
