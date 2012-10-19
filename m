From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Fri, 19 Oct 2012 10:43:11 +0400
Message-ID: <1350628991.2028.25.camel@slavad-ubuntu>
References: <20121011092300.GB27763@wloczykij>
	 <1349950320.1908.11.camel@slavad-ubuntu> <20121011180332.GE27763@wloczykij>
	 <1350025832.2026.43.camel@slavad-ubuntu> <20121012103119.GF27763@wloczykij>
	 <1350040053.2026.47.camel@slavad-ubuntu> <20121012114043.GG27763@wloczykij>
	 <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
	 <20121014200836.GK27763@wloczykij> <1350281888.2488.9.camel@slavad-ubuntu>
	 <20121018201528.GS27763@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=MEiJtF9/ALY0RB5LeebtluwWZu+bNQQeKxZJfl3k2Eg=;
	b=puRa9pG12uOOfTPrtD/2tQo+06Ivp0MvPMGGgpfto0nvWKAFSNeooUNRl3LXHUvfGbShZYV6hfeiEGI+Of+V+oBROQ4ej3xf839wfHDWth8HUIyijOiyJJT0yn0yWtd7;
In-Reply-To: <20121018201528.GS27763@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2012-10-18 at 22:15 +0200, Piotr Szymaniak wrote:
> On Mon, Oct 15, 2012 at 10:18:08AM +0400, Vyacheslav Dubeyko wrote:
> > On Sun, 2012-10-14 at 22:08 +0200, Piotr Szymaniak wrote:
> > > On Sun, Oct 14, 2012 at 06:55:59PM +0400, Vyacheslav Dubeyko wrot=
e:
> > > >=20
> > > > So, it is clear that #359 segment is empty. Moreover, #357 segm=
ent doesn't contain ifile block with blkoff =3D 2 as I can see from dum=
pseg output. Currently, I know that #358 segment contains empty ifile b=
lock with blkoff =3D 2. It needs to find segment which contains not emp=
ty block of ifile for blkoff =3D 2. Could you share dumpseg output of a=
ll previous segments (for #358)?
> > >=20
> > > dumpseg of blocks 340 =E2=86=92 357 attached (I hope, the file is=
 ~200KB).
> > >=20
> >=20
> > As I can see, checkpoints #1843 and #1819 contain ifile's block wit=
h blkoff =3D 2.
> >=20
> > Could you check state of blocks 719300 and 698817? If any of these =
blocks are not empty then, please, send the raw dump of non-empty block=
(s).
>=20
> Both dumps attached.
>=20

As I can see, both dumps contains blocks of ifile with inodes
description.

I check previous e-mails and can see that maybe you dump not proper
block. Maybe it is my misspelling in some e-mail. It needed to dump
#734205 but as I can see you share dump of #743205 block. Firstly, to
check that block #734205 is really empty. Because if it is not empty
then the situation is different.

If the block #734205 is empty then I suggest to make some experiment:

1. Prepare dump of the corrupted partition:

dd if=3D<partition (/dev/sdb1)> of=3D<image file>

2. Setup loop device for the image:

losetup /dev/loop0 <image file>

3. Copy block #719300 of ifile (ino =3D 6) with blkoff =3D 2 of checkpo=
int
#1843 into empty block #734205 (checkpoint #1874):

dd if=3D/dev/loop0 of=3D/dev/loop0 bs=3D4096 skip=3D719300 seek=3D73420=
5 count=3D1

4. Try to mount the loop device.

Please, share results (console output and dmesg output) of this trying
to mount.

But, please, first of all, CHECK THAT TARGET BLOCK IS REALLY EMPTY. Thi=
s
manual manipulation can lead to loosing some filesystem state. Moreover=
,
it can't fully recover filesystem but maybe driver can recover
filesystem and to mount.

With the best regards,
Vyacheslav Dubeyko.

> Piotr Szymaniak.



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
