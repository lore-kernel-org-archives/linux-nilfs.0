From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Mon, 09 Jul 2012 13:28:32 +0400
Message-ID: <1341826112.1965.6.camel@slavad-ubuntu-11>
References: <20120709073300.GP1478@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=MbGUP8+l8dfBhqiQfb4JkeWBUTXANy+80pealIy6p34=;
	b=dvgb/0RN0CiUGF9Bo+aQdbbzEAxS3qi8TdJFASd0hWNp2SbqtMn59GbcKOOWxRbinDKfeCLf8WN4Ac/k58YQkh+JUjTp8SUh6BefPbb+2XgNP8y/lxejDDf29g1zUhqY;
In-Reply-To: <20120709073300.GP1478@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Piotr,

Does system journals on your machines contain any interested details
about reported issue? Could you try to extract some error or warning
messages from system journal?

Thanks,
Vyacheslav Dubeyko.


On Mon, 2012-07-09 at 09:33 +0200, Piotr Szymaniak wrote:
> Hi.
>=20
> I've upgraded nilfs-utils (running Gentoo) on 29 july. Today I ran ou=
t
> of space on my / and found that nilfs_cleanerd isn't working. When I
> start it from the command line it exits instantly. Also, all previous
> checkpoints on / (also on two other mountpoints on different machine)
> are gone.
>=20
> What I did? Downgraded nilfs-utils to 2.1.1, remounted mountpoints. O=
n
> the second machine it's runnig fine (cleaned _all_ checkpoints), on t=
he
> first one with disk space issue it exits just like 2.1.3.
>=20
> Here are some fs details. Machine with disk space issues, rootfs:
>     CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
>  147688  2012-07-09 08:38:14   cp    -        11075     242915
>  147689  2012-07-09 08:38:14   cp    -           60     242895
> (=E2=80=A6)
>  148999  2012-07-09 09:13:46   cp    -           60     242888
>  149000  2012-07-09 09:19:45   cp    -           44     242888
>=20
> Filesystem      Size  Used Avail Use% Mounted on
> rootfs           24G   13G   11G  56% /
>=20
> mount shows:
> /dev/sda2 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D15356)
>=20
> There's no nilfs_cleanerd with pid 15356.
>=20
>=20
> Second machine rootfs:
>    CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
>  92246  2012-07-09 08:16:58   cp    -          118      44669
> (=E2=80=A6)
>  92439  2012-07-09 09:19:14   cp    -           29      44668
>  92440  2012-07-09 09:19:46   cp    -           33      44668
>=20
> Filesystem         Size  Used Avail Use% Mounted on
> rootfs             3.7G  888M  2.6G  26% /
>=20
> (it should be around 3G used)
>=20
> Second machine second mountpoint:
>    CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
>   1496  2012-07-09 03:31:23   cp    -         8837     132766
>   1497  2012-07-09 03:31:26   cp    -          468     132766
>   1498  2012-07-09 03:41:27   cp    -         1474     132765
>=20
> (this fs should containt *all* 1498 checkpoints)
>=20
> Filesystem         Size  Used Avail Use% Mounted on
> /dev/dm-2          117G   58G   54G  76% /mnt/home_backup
>=20
> (in this one it should be around 100G of used space)
>=20
> mount:
> /dev/dm-2 on /mnt/home_backup type nilfs2 (rw,gcpid=3D13135)
> /dev/sda3 on / type nilfs2 (rw,noatime,nodiratime,gcpid=3D1363)
>=20
> Both cleaners running (the second mountpoint - /mnt/home_backup - is =
under
> heavy load and I suppose it will end with around 20G used space).
>=20
> Where to go from this point? How to debug nilfs_cleanerd issue?
>=20
>=20
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
