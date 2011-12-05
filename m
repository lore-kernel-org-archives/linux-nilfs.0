From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Initial mount fails
Date: Mon, 05 Dec 2011 13:23:26 +0900 (JST)
Message-ID: <20111205.132326.69345131.ryusuke@osrg.net>
References: <CAN67vW2nSDWfESF1o2umuqduJY-MKL1da0oboDy04tyT4FEL5g@mail.gmail.com>
	<20111205.021311.06955058.ryusuke@osrg.net>
	<CAN67vW2C3d5Byinib97otyCk9rujPhLSOmLXkC01juHo6e=nVA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN67vW2C3d5Byinib97otyCk9rujPhLSOmLXkC01juHo6e=nVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: zavi05-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 4 Dec 2011 20:01:25 +0200, Zavi wrote:
> Here's the result
>=20
> > sudo nilfs-tune -l /dev/sdc
> nilfs-tune 2.1.0-rc1
> /dev/sdc: cannot open NILFS

Hmm, seems like super blocks are not written to disk.

Does the following option ('-K' option) affect the results ?

 $ sudo mkfs -t nilfs2 -v -K /dev/sdc
 $ sudo nilfs-tune -l /dev/sdc

This option stops issuing discard command to disk just before writing
new super blocks.

Regards,
Ryusuke Konishi

> On Sun, Dec 4, 2011 at 7:13 PM, Ryusuke Konishi
> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> > On Sun, 4 Dec 2011 18:38:58 +0200, Zavi wrote:
> >> Thank you Ryusuke for the quick reply
> >>
> >> Of course dmesg is the first thing I looked at.
> >> All I see is a not very informative message
> >> > NILFS: Can't find nilfs on dev sdc.
> >>
> >
> > This message is printed when no super blocks are found on the devic=
e.
> > Does nilfs-tune command work for the partition ?
> >
> > =A0$ sudo nilfs-tune -l /dev/sdc
> >
> > It tries to read super block, and displays file system information =
if
> > a valid super block was found.
> >
> > Regards,
> > Ryusuke Konishi
> >
> >> On Sun, Dec 4, 2011 at 3:29 PM, Ryusuke Konishi
> >> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> >> > Hi,
> >> > On Sun, 4 Dec 2011 11:10:12 +0200, Zavi wrote:
> >> >> Hi all,
> >> >>
> >> >> I'm trying yo mount nilfs on a device without success.
> >> >> mkfs works just fine, but when I try to mount I keep getting an=
 error
> >> >> > sudo mkfs -t nilfs2 /dev/sdc
> >> >> > sudo mount -t nilfs2 /dev/sdc ~/nilfs
> >> >> mount.nilfs2: Error while mounting /dev/sdc on ~/nilfs: Invalid=
 argument
> >> >>
> >> >
> >> > Were there any related messages in logs? =A0Please try dmesg com=
mand or
> >> > make sure system logs:
> >> >
> >> > =A0$ dmesg
> >> >
> >> > =A0or
> >> >
> >> > =A0$ sudo cat /var/log/{messages,syslog}
> >> >
> >> > Regards,
> >> > Ryusuke Konishi
> >> >
> >> >> I've installed nilfs-utils, and this is what I get from fsck
> >> >> > sudo fsck0.nilfs2 -f -v /dev/sdc
> >> >> fsck0.nilfs2: cannot read super block (device=3D/dev/sdc)
> >> >>
> >> >> just to be sure the problem is not in the device, I mounted ext=
4 on it
> >> >> successfuly.
> >> >> I can also do block requests (dd, iometer) without a problem.
> >> >>
> >> >> I'd appreciate any suggestion.
> >> >>
> >> >> Thanks,
> >> >> Zavi
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux=
-nilfs" in
> >> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ni=
lfs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
