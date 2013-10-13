From: Peter Volkov <pva-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: nilfs_cleanerd doesn't get started when /etc/mtab is a symlink
 to /proc/self/mounts
Date: Sun, 13 Oct 2013 23:27:26 +0400
Message-ID: <1381692446.4127.1.camel@i7>
References: <1381597976.9351.22.camel@i7>
	 <20131013.222709.495385407.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131013.222709.495385407.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

=D0=92 =D0=92=D1=81, 13/10/2013 =D0=B2 22:27 +0900, Ryusuke Konishi =D0=
=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Sat, 12 Oct 2013 21:12:56 +0400, Peter Volkov wrote:
> > nifs_cleanerd doesn't get started when /etc/mtab is a symlink
> > to  /proc/self/mounts:
> > # mount -f -o remount /
> > mount.nilfs2: cannot modify /etc/mtab.
> > Please remount the partition with -f option after making /etc/mtab
> > writable.
> > nilfs_cleanerd not started
>=20
> Did you try --enable-libmount option when configuring nilfs-utils ?
>=20
>  $ ./configure --enable-libmount
>=20
> This option uses libmount library and it resolves /etc/mtab related
> problems.

Thank you for help Ryusuke. That's what I was missing. Everything works
now.

--
Peter.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
