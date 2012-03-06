From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000048
Date: Tue, 06 Mar 2012 23:54:04 +0900 (JST)
Message-ID: <20120306.235404.52180631.ryusuke@osrg.net>
References: <CAMRzUtxbOXWOyZ1wMRmxSsRs67FoDq_hf7Pg_UrAi4P=DnhqsA@mail.gmail.com>
	<20120305.233028.248350005.ryusuke@osrg.net>
	<CAMRzUtwpZQ_ZmZoGzOA0wkmTVQKVJRwA7OB3X_ktRXPj9MJoXA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMRzUtwpZQ_ZmZoGzOA0wkmTVQKVJRwA7OB3X_ktRXPj9MJoXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: slicky.dvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 6 Mar 2012 16:24:40 +0300, Slicky Devil wrote:
> Luckily, I seem to have been able to reproduce the bug (after
> shrinking the partition down to some hundred MB). Your patch seems to
> have fixed it!
>=20
> Now I get the following, which, I think, is pretty much expected,
> since I chopped a large part of the filesystem off:
>=20
> 15:52 root ~ # mount /dev/1/buggy-home test
> [  461.137823] NILFS: error searching super root.
> mount.nilfs2: Error while mounting /dev/mapper/1-buggy--home on
> /root/test: Input/output error

Hmmm.  Did you shrink the filesystem with nilfs-resize tool
before shrinking the partition ?

This error (I/O error) also looks undesirable to me.

=20
> Please, fix the bug in the official kernel sources, too. Your
> filesystem proved very useful here for storing documents and other
> changeable stuff -- we don't want it get broken unexpectedly. :)

Sure, I will send the fix upstream (and stable trees).

Thanks,
Ryusuke Konishi


> Still, thanks a lot! The things you are doing here are really cool!
>=20
> Cheers!
>=20
>=20
>=20
> On Mon, Mar 5, 2012 at 5:30 PM, Ryusuke Konishi
> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> >
> > Thank you for reporting this issue.
> >
> > I found a bug in the nilfs_load_super_block function which has
> > potential to cause this oops.
> >
> > Could you try the following patch if you still have the partition ?
> >
> >
> > Thanks,
> > Ryusuke Konishi
> >
> > diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> > index d327140..35a8970 100644
> > --- a/fs/nilfs2/the_nilfs.c
> > +++ b/fs/nilfs2/the_nilfs.c
> > @@ -515,6 +515,7 @@ static int nilfs_load_super_block(struct the_ni=
lfs *nilfs,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brelse(sbh[1]);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sbh[1] =3D NULL;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sbp[1] =3D NULL;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 valid[1] =3D 0;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0swp =3D 0;
> > =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0if (!valid[swp]) {
> > --
> > 1.7.7.4
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
