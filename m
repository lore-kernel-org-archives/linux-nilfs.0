From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Nilfs2 and Grub2
Date: Thu, 03 May 2012 15:49:04 +0900 (JST)
Message-ID: <20120503.154904.13275655.konishi.ryusuke@lab.ntt.co.jp>
References: <1335868737.71789.YahooMailNeo@web161905.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335868737.71789.YahooMailNeo-/W4/QBBOCLIMe+d1jY/0H5EhsgyP+Z75VpNB7YpNyf8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 1 May 2012 03:38:57 -0700 (PDT), Sven-G=F6ran_Bergh wrote:
> Hi list,
>=20
> I have done some observations with the combination
> grub2 and nilfs2 on the boot partition. It would
> be valuable to know if anyone else has done similar
> observations or if this is a {,/un}known problem.
>=20
>=20
> After some harsh handling the system is rebooted
> and grub2 hangs during stage 1.5-2. Once grub2 has
> encountered this problem it is consistent. It will
> hang on every consecutive boot.
>=20
> However, if the filesystem (on a CF) is mounted by
> another system there are no problems reported.
> Furthermore, once the filesystem has been mounted
> by another system grub2 has no problems booting it
> again afterwards. There is no need to do anything
> else with the fs than mounting it by another system
> and then umount it again.
> My preliminary analysis is:
> =A0* Nilfs2 is left in a disturbed state, due to some
> =A0=A0 rough handling (still unknown in detail).
> =A0* A normal mount has no problem to recover the fs
> =A0=A0 in such case.
> =A0* Grub2 lacks some of the recovery features
> =A0=A0 performed during a normal mount and will have
> =A0=A0 problem reading files on the fs.
>=20
> Currently I do not have a more exact description of
> the problem. I still have to figure out exactly what
> handling that triggers this state for the fs.
>=20
> This is an embedded project and a previous version
>=20
> is running grub legacy and ext2 without any signs of
> similar problems. Grub legacy has never failed, even
> with a (partly) corrupt ext2.
>=20
> My own knowledge in the nilfs2/grub2 internals is
> limited and it is hard to troubleshoot since I
> have no recipe reproduction. However, I have observed
> it on several occasions on our test systems. I am on
> a tight schedule, but when time permits, I will try
> to find a way to reproduce this.
>=20
> Have anyone experienced similar behavior?
>=20
> Brgds
> /Sven

Thank you for reporting the issue in the nilfs2 boot loader of grub2.

Your analysis seems right to me.

The nilfs2 grub code looks to be lacking roll forwarding and crc
verification (the latter both for super blocks and log blocks).

It is incomplete, or rather I should say it took a good trade-off
between simplicity and reliability as an early practicable
implementation.

Actually it works without trouble in most cases since most checkpoints
coherently include files needed to boot up system even though that
omission may lead the boot loader to read not-updated files after
unclean shutdown.

In my opinion, nilfs2 grub code does not have to do recovery, but it
should scan the latest checkpoint in order to minimize troubles.
However, I don't know whether it's possible or not in the boot loader.

Of course, there is a possibility that simply an unknown bug caused
your trouble.  In that case, inserting debug print functions in the
nilfs2 grub code and booting up with it, would be helpful to narrow
down the cause of the problem.


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
