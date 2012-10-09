From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Tue, 09 Oct 2012 16:08:34 +0400
Message-ID: <1349784514.1921.9.camel@slavad-ubuntu>
References: <20121008222557.GU28032@wloczykij>
	 <1349767793.3427.7.camel@slavad-ubuntu> <20121009105239.GV28032@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=Cun1xintqh9kEE3QiJnL/77P4JZsnDqJkBfitSwp0Lg=;
	b=Z0USfYaIyqEtEY8srBt43Dbi3+549N+kj/cFqM9d0y8+9c9fuCemjN9m2PTaxE+XxhmV+nwG14oYj96NrI6X9nAk2kM5hF846Eq8SqZDLWErBDZXIj4jIlAYCr59Dkhk;
In-Reply-To: <20121009105239.GV28032@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Piotr,

On Tue, 2012-10-09 at 12:52 +0200, Piotr Szymaniak wrote:
> On Tue, Oct 09, 2012 at 11:29:53AM +0400, Vyacheslav Dubeyko wrote:
> > Hi,
> >=20
> > On Tue, 2012-10-09 at 00:25 +0200, Piotr Szymaniak wrote:
> > > Hi list.
> > >=20
> > > I'm using nilfs2 on my Raspberry Pi rootfs. I've played around wi=
th
> > > Raspberry Pi Turbo Mode and today it refused to boot. It's a head=
less
> > > setup so I moved the SD Card to my other machine and tried to mou=
nt
> > > rootfs partition:
> > >=20
> >=20
> > As I can understand Raspberry Pi Turbo Mode is a hardware overclock=
ing.
> > So, I worry about proper working of SD-card controller. It is possi=
ble
> > that the reason of the issue can be not proper controller functioni=
ng or
> > concrete SD-card issue.
>=20
> It's an =E2=80=9Callowed=E2=80=9D overcloking. I have another SD Card=
 with Raspbian (and
> without nilfs2) that works fine with Turbo Mode. At least it seems to
> work fine. The second card was in Turbo Mode (@900MHz) for a few days
> and was working. Yesterday i made it @1000MHz and it didn't boot.
>=20
>=20
> > Could you try to reproduce the issue with using another SD-card in =
Turbo
> > and normal mode?
>=20
> Not now. Don't have any image of my setup with nilfs2. ):
>=20
>=20
> > I think that first of all it needs to detect that it is NILFS2 issu=
e but
> > not hardware or MMC stack issue.
>=20
> Will connect some screen via HDMI to check if there's some error msg.
> The card should be fine, but I will dd it to disk to check for read
> errors.
>=20

=46irst of all, I need some details about your NILFS2 partition for iss=
ue analysis.

I need in:
1. Full output of "lscp -a".
2. Full output of "lssu -a".
3. Output of dumpseg for segment #0.

Could you share these outputs?

Maybe, you will have some troubles with getting of outputs. So, I need =
in your segment #0 (first 8 MB) raw output for issue analysis beginning=
, anyway.

With the best regards,
Vyacheslav Dubeyko.


> Piotr Szymaniak.
>=20
>=20
> > With the best regards,
> > Vyacheslav Dubeyko.
> >=20
> >=20
> > > maszyn ~ # mount.nilfs2 /dev/sdf3 /tmp/rpi
> > > mount.nilfs2: Error while mounting /dev/sdf3 on /tmp/rpi: Invalid
> > > argument
> > >=20
> > > dmesg shows:
> > > (...)
> > > [43893.754525] segctord starting. Construction interval =3D 300 s=
econds,
> > > CP frequency < 30 seconds
> > > [43893.760245] NILFS: corrupt root inode.
> > >=20
> > > Where should I go from here? I can hook it up via HDMI to some sc=
reen to
> > > see if there's some error msg on rPi.
> > >=20
> > > I'm using official Raspberry Pi linux 3.2.27 from github [1] (las=
t
> > > updated 2-4 days ago).
> > >=20
> > > [1] https://github.com/raspberrypi/linux
> > >=20
> > >=20
> > > Piotr Szymaniak.
> >=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
