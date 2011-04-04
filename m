From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cleanerd could use some sensible defaults if its conf
 file is empty...
Date: Mon, 04 Apr 2011 19:00:37 +0900 (JST)
Message-ID: <20110404.190037.212385465.ryusuke@osrg.net>
References: <BANLkTi=r2nmV1B9nF=f23fk2YxDch0ewRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=r2nmV1B9nF=f23fk2YxDch0ewRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: sandr8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 3 Apr 2011 13:49:47 -0700, Alessandro Salvatori wrote:
> Hello,
>=20
>     my root nilfs2 filesystem filled and trying and editing
> /etc/nilfs_cleanerd.conf resulted in an empty file.
>=20
> I started the cleanerd but it wasn't freeing up any space.
> Then I converted all of my snapshots back onto checkpoints and remove=
d
> all of my checkpoints.
>=20
> still nothing.

Did you try '-p' option?

nilfs_cleanerd tries to protect recent checkpoints within the period
specified with "protection_period" parameter.

It is set to one hour by default.  So, the effect of converting
snapshots back to checkpoints will not appear soon.

But, you can shorten this period by using the '-p' option for
emergency.
=20
> Then I created a new nilfs_cleanerd.conf with sensible values in my
> home directory and pointed nilfs_cleanerd to that.
>=20
> and finally it worked!!!
>=20
> maybe nilfs_cleanerd could default to some minimum of -say- the least
> between some small amount of gigabytes and some small percentage of
> the disk size as the minimum space to free if no setting is found in
> the configuration file?

The current nilfs_cleanerd.conf has keyword 'min_clean_segments' to
specify percentage of minimum free space, but the effect of
protection_period is prior to that.

So, adding another parameter sounds worth considering as you pointed
out.

=46or instance,

 emerg_clean_segments     5%    # override protection_period
 min_clean_segments      10%
 max_clean_segments      20%

Am I on the right track?

Thanks,
Ryusuke Konishi

> thank you!
> -alessandro-
> =A0Here i am, A young man,
> =A0A crashing computer program,
> =A0Here is a pen, write out my name.
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
