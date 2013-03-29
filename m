From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Fri, 29 Mar 2013 11:37:10 +0100
Message-ID: <20130329103710.GM1672@wloczykij>
References: <20121127151924.GW4028@wloczykij>
 <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com>
 <20121128142116.GY4028@wloczykij>
 <1354113560.2017.11.camel@slavad-ubuntu>
 <20121128205943.GZ4028@wloczykij>
 <1354172459.2077.11.camel@slavad-ubuntu>
 <20130328120700.GK1672@wloczykij>
 <E24177B1-2EF0-4274-BD13-4642E3663D08@dubeyko.com>
 <20130329074249.GL1672@wloczykij>
 <1364544910.11128.9.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="G23JYFG0d77Z6i/3"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1364544910.11128.9.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--G23JYFG0d77Z6i/3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 29, 2013 at 12:15:10PM +0400, Vyacheslav Dubeyko wrote:
> I meant that sysrq-trigger output ends with resume about runnable tasks
> and locks in the system (for example):
> *snip*
> So, I need in full sysrq-trigger output for understanding situation on
> your side. Could you share it?

If this should be in echo t > /proc/sysrq-trigger then I shared full
output already. Maybe I'm missing some (debug?) features in kernel for
more verbose output.


> > Btw looking at ps aux output it seems, that this flush is hanging there
> > almost from first boot:
> > root       937 88.2  0.0      0     0 ?        S    Feb17 50160:39 [flu=
sh-8:0]
> >=20
>=20
> Could you share "cat /proc/partitions" and "mount" outputs? I need to
> understand what partition is processed by [flush-8:0].

~ # cat /proc/partitions
major minor  #blocks  name

   8        0    3915776 sda
   8        1      32768 sda1
   8        2      65536 sda2
   8        3    3816448 sda3
   8       16  156290904 sdb
   8       17    4200966 sdb1
   8       18     273105 sdb2
   8       19  146810002 sdb3
   8       20    5004247 sdb4
 254        0      65536 dm-0
 254        1  146808974 dm-1


~ # mount
rootfs on / type rootfs (rw)
/dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D16150)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
tmpfs on /run type tmpfs (rw,nosuid,nodev,relatime,mode=3D755)
udev on /dev type devtmpfs (rw,nosuid,relatime,size=3D10240k,nr_inodes=3D22=
1714,mode=3D755)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=3D5,mode=3D62=
0)
shm on /dev/shm type tmpfs (rw,nosuid,nodev,noexec,relatime)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
/dev/mapper/chome on /home type btrfs (rw,noatime)


> > > I can easily reproduce the issue by big file (100 - 500 GB) deletion
> > > or truncation. Please, find description in:
> > > http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01504.html.
> >=20
> > If this brings something new - I'm not using huge files like that (this
> > flush above is a 3.7G device). But if this reproduces the issue, it
> > could be related.  (:
> >=20
>=20
> Yes, it is really important to understand the situation on your side.
> Because you can have another reason of the issue with similar symptoms.
> So, we need to investigate your case more deeply, I think.

Got this issue on two different machines, but none of them uses nilfs2 at
device bigger then 60G (in fact, the partitions are, afair, around 30G and =
the
mentioned 3.7G).


Piotr Szymaniak.
--=20
I ten smr=C3=B3d. Diabli wiedz=C4=85, co tam gni=C5=82o, w tym mi=C4=99siwi=
e, ale Redowi
wyda=C5=82o si=C4=99, =C5=BCe sto tysi=C4=99cy rozbitych cuchn=C4=85cych ja=
j wylanych na sto
tysi=C4=99cy cuchn=C4=85cych rybich =C5=82b=C3=B3w i zdech=C5=82ych kot=C3=
=B3w nie mo=C5=BCe =C5=9Bmierdzie=C4=87
tak, jak =C5=9Bmierdzia=C5=82a ta ma=C5=BA.
 -- Arkadij i Borys Strugaccy, =E2=80=9EPiknik na skraju drogi=E2=80=9D

--G23JYFG0d77Z6i/3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRVW7VAAoJEEMpAov1cw9l32IP/R7O7mMQ4KQKZqVrpEVEv/cj
8zCzCXr+ggOfU7sNfL6tRY157NgInbegJ/gRymP+7cXbabWDVqEoWxtGLwbwPvn8
M7CWO/B5VHSzl0aMpdhjoO69el6k+QkQ2mzVXlv5jgkH79P5Zdi+gGcqIP0extpN
aby/ndZG5mxkho/6q5vDFcvlET9NLiIyPNFmFWIlxYH8zz/3/d3pWmZ9F3DqeYSA
5FBik+A5shxrIcUXJUBu152/F0YivbhQMMYlv28p+xzaXIj5ikJXhoG1IWzGqee+
53hVpzYlMWdS62ulbRQYMfvskH3gv+cOLxWufVRz4paABn+nvge+50E3x2vvpRGN
l0i00zF3qP2bIy3G5SlA0Z/SsuEMw3ASPMfLRlQEuZZ45y7Cl20bdh4DCT9gFWTj
Q8FZ+MFW7tfsy42+541dd4btWJXk0uICAFVFCAlcf8zlufDhfjesycnpzFW8NuGM
VhSjtK70gH3TrMbbfAdpf8z0qH4J48wWoaTKqSi/xeS4xXDvokX1w/KqRl2bSgZF
9En2AsqQLAbauW7dtqqMX/E7Tzb1HmdF/x0z3Fdy4Nh70jYghfcTO4Y910Yg0axk
ovi6W/IqgP2Wy+jC+WiLRExahSbu5+CnWaEo+xKnF8zRr6Xw5lhoH050+IzOdAHM
MCJSDyvx2l4RxgAqko8K
=CMrD
-----END PGP SIGNATURE-----

--G23JYFG0d77Z6i/3--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
