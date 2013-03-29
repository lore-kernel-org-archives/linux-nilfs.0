From: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Fri, 29 Mar 2013 14:57:22 +0100
Message-ID: <20130329135722.GN1672@wloczykij>
References: <20121128142116.GY4028@wloczykij>
 <1354113560.2017.11.camel@slavad-ubuntu>
 <20121128205943.GZ4028@wloczykij>
 <1354172459.2077.11.camel@slavad-ubuntu>
 <20130328120700.GK1672@wloczykij>
 <E24177B1-2EF0-4274-BD13-4642E3663D08@dubeyko.com>
 <20130329074249.GL1672@wloczykij>
 <1364544910.11128.9.camel@slavad-ubuntu>
 <20130329103710.GM1672@wloczykij>
 <1364556557.11128.28.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="yFtM4vvgVM46ytb2"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1364556557.11128.28.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--yFtM4vvgVM46ytb2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 29, 2013 at 03:29:17PM +0400, Vyacheslav Dubeyko wrote:
> I haven't any special additional configuration options for MagicSysRq in
> my kernel configuration. It is simply enabled.
>=20
> As I see (https://www.kernel.org/doc/Documentation/sysrq.txt), it is
> possible to define log level by means of setting value
> in /proc/sys/kernel/sysrq. I have "1" (enable all functions of sysrq) in
> this file. Maybe, have you another log level on your side?

Than this must depend on some different option as I also have "1" in
/proc/sys/kernel/sysrq.


> > ~ # mount
> > rootfs on / type rootfs (rw)
> > /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D16150)
> > proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
> > tmpfs on /run type tmpfs (rw,nosuid,nodev,relatime,mode=3D755)
> > udev on /dev type devtmpfs (rw,nosuid,relatime,size=3D10240k,nr_inodes=
=3D221714,mode=3D755)
> > devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=3D5,mode=
=3D620)
> > shm on /dev/shm type tmpfs (rw,nosuid,nodev,noexec,relatime)
> > sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
> > /dev/mapper/chome on /home type btrfs (rw,noatime)
> >=20
>=20
> I see two nilfs_cleanerd deamons from "ps ax" output:
>=20
> 1520 ?        Ss     0:25 /sbin/nilfs_cleanerd -c /etc/nilfs_cleanerd.con=
f /dev/disk/by-uuid/f18e80b1-f3c1-49ec-baa5-39c0edc4c0b9
> 16150 ?        Ss     0:00 /sbin/nilfs_cleanerd -n /dev/sda3 /
>=20
> But I can't understand what partition is serviced by nilfs_cleanerd with
> pid #1520. Could you share more details about it?

~ # readlink /dev/disk/by-uuid/f18e80b1-f3c1-49ec-baa5-39c0edc4c0b9
=2E./../sda3

I suppose that this is caused by manually (well, by script, but it's not
"remount") running nilfs_cleanerd on system startup on that device.
After that there was a remount that started second cleaner. And it seems
that this was yesterday:
~ # ps aux | grep nilfs
root      1520  0.0  0.0   2572  1032 ?        Ss   Feb17   0:25
/sbin/nilfs_cleanerd -c /etc/nilfs_cleanerd.conf
/dev/disk/by-uuid/f18e80b1-f3c1-49ec-baa5-39c0edc4c0b9
root     16150  0.0  0.0   2348   796 ?        Ss   Mar28   0:00
/sbin/nilfs_cleanerd -n /dev/sda3 /

I think that running cleanerd manually is already changed to -o remount
on my second machine with nilfs and I just forgot about this one. I had
some issues with that because of missing /dev/root.


Piotr Szymaniak.
--=20
Na  kazda  strzelanine   zakonczona  czyjas  smiercia  przypadaja  trzy
strzelaniny  bez ofiar.  To po prostu  niemozliwe  do  zaakceptowania w
Ameryce. Po prostu nie do zaakceptowania. Musimy cos z tym zrobic.
  -- George W. Bush

--yFtM4vvgVM46ytb2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRVZ3CAAoJEEMpAov1cw9lUboQAMPTVBWTLoDSeF8p1IBDP23f
OqHeHZ53GORWIBMMo+c0AV8tl97hmqtR715Px1XcFTQhlWawED1oaBclq7URF73g
JBsy3+WFn7+8erDP8nbCtpH3pfhycHB7qZ7IFk9wu+XpgvBXkiQK2NOcVv5L6mgm
rnPYKWJLNxUfpos++8R40ssJVn2xj3apUqiDOM772T8idHaIeZ5297jxL8+pSTmC
Pky4Fk2UlwIMTfU/Frwa9R6ja49c1AJJY6FR1nlL0fTbQ2mR8HgIuuaMvNbD1xL1
y9LbXmucvGbK5ExSsWIZRdbqnbVF2sumYREjBzYRWc6uIo312ksWzlOMwRDkLJYQ
JUVJl+LF+deNRLe5Is/kbEEvTylU/YWrv3R+C7K8CAzzRsCvxv1jNHg/7BGS8agC
33vnjYFI6cQfmsGPDqBMnlKC6Zt65cmxCfZ3jVktDXGC1S8p/r64j68lcnVqi8ej
m/O8H2MYlzIMZA+f6Jo0zsRJCNw6dFFvdC2SilZK6Xfh2IrSdRYnyWiEpvaqlzW7
VC9jTSWxNiRWAsO/KQAXsumNZ3t5pyhS/7Z3x6wtfVjs/nTyi7N9/NHDPKTjeQZN
nFUPCMZhcFS7dIP2WwZUSf4JUOn6uzSpzXOAuuCI3bwn1/vpytc5oBrIV2jEehu1
PpGlyi4KVJk0o8KhI3AR
=wYOn
-----END PGP SIGNATURE-----

--yFtM4vvgVM46ytb2--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
