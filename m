From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 08/92] fs: new helper: simple_rename_timestamp
Date: Wed, 05 Jul 2023 20:04:41 -0400
Message-ID: <7c783969641b67d6ffdfb10e509f382d083c5291.camel__26962.892564346$1688601921$gmane$org@kernel.org>
References: <20230705185812.579118-1-jlayton@kernel.org>
         <20230705185812.579118-3-jlayton@kernel.org>
         <3b403ef1-22e6-0220-6c9c-435e3444b4d3@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688601900;
        bh=GKAf3Connag2H1A96+MWJO2m2+AGoi4e2L0TCmV0twI=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=nET3i8K9cAN9JzAYu5D5DtIfnZyBNqxFT5kCHd94dYOZfZeH8zavR0WF9u4ITY0NE
         D66ZLzqp4+stDYQ/wxgM6SsxM/mS2+y3IUBNv7xe18KIH1uVzQrdLce3r3dWIKwzol
         tzsq2RPKrA+bg24p5zLD3xKS/7A/1zvUDDnXMEpHEaKwvlUXOn9bI/FS6RRj0UTu+c
         vTGpq6dtXG1Xauh+ol1hFuB35FDh/rjrnsJWBkr2MVf6wx5gZoGZefJEl0qBVioA6j
         WnKwlad8ofPwwEPXaYXs/neOdGw/YH9YOfEVdEl8lvP9rCQ6lvqx2NeiiLr9bjccc4
         eOxUKsWaspoTQ==
In-Reply-To: <3b403ef1-22e6-0220-6c9c-435e3444b4d3-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, christophe.leroy-2tlSp11Fh4xulxpn9UvDqw@public.gmane.org, hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bwarrum-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, rituagar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, ericvh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org, asmadeus-9aU+PIKW3UvdtAWm4Da02A@public.gmane.org, linux_oss-kKOvUW9iAPtl57MIdRCFDg@public.gmane.org, dsterba-IBi9RG/b67k@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, marc.dionne-hRzEac23uH1Wk0Htik3J/w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org, luisbg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, salah.triki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aivazian.tigran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu, 2023-07-06 at 08:19 +0900, Damien Le Moal wrote:
> On 7/6/23 03:58, Jeff Layton wrote:
> > A rename potentially involves updating 4 different inode timestamps. Ad=
d
> > a function that handles the details sanely, and convert the libfs.c
> > callers to use it.
> >=20
> > Signed-off-by: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  fs/libfs.c         | 36 +++++++++++++++++++++++++++---------
> >  include/linux/fs.h |  2 ++
> >  2 files changed, 29 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/fs/libfs.c b/fs/libfs.c
> > index a7e56baf8bbd..9ee79668c909 100644
> > --- a/fs/libfs.c
> > +++ b/fs/libfs.c
> > @@ -692,6 +692,31 @@ int simple_rmdir(struct inode *dir, struct dentry =
*dentry)
> >  }
> >  EXPORT_SYMBOL(simple_rmdir);
> > =20
> > +/**
> > + * simple_rename_timestamp - update the various inode timestamps for r=
ename
> > + * @old_dir: old parent directory
> > + * @old_dentry: dentry that is being renamed
> > + * @new_dir: new parent directory
> > + * @new_dentry: target for rename
> > + *
> > + * POSIX mandates that the old and new parent directories have their c=
time and
> > + * mtime updated, and that inodes of @old_dentry and @new_dentry (if a=
ny), have
> > + * their ctime updated.
> > + */
> > +void simple_rename_timestamp(struct inode *old_dir, struct dentry *old=
_dentry,
> > +			     struct inode *new_dir, struct dentry *new_dentry)
> > +{
> > +	struct inode *newino =3D d_inode(new_dentry);
> > +
> > +	old_dir->i_mtime =3D inode_set_ctime_current(old_dir);
> > +	if (new_dir !=3D old_dir)
> > +		new_dir->i_mtime =3D inode_set_ctime_current(new_dir);
> > +	inode_set_ctime_current(d_inode(old_dentry));
> > +	if (newino)
> > +		inode_set_ctime_current(newino);
> > +}
> > +EXPORT_SYMBOL_GPL(simple_rename_timestamp);
> > +
> >  int simple_rename_exchange(struct inode *old_dir, struct dentry *old_d=
entry,
> >  			   struct inode *new_dir, struct dentry *new_dentry)
> >  {
> > @@ -707,11 +732,7 @@ int simple_rename_exchange(struct inode *old_dir, =
struct dentry *old_dentry,
> >  			inc_nlink(old_dir);
> >  		}
> >  	}
> > -	old_dir->i_ctime =3D old_dir->i_mtime =3D
> > -	new_dir->i_ctime =3D new_dir->i_mtime =3D
> > -	d_inode(old_dentry)->i_ctime =3D
> > -	d_inode(new_dentry)->i_ctime =3D current_time(old_dir);
> > -
> > +	simple_rename_timestamp(old_dir, old_dentry, new_dir, new_dentry);
>=20
> This is somewhat changing the current behavior: before the patch, the mti=
me and
> ctime of old_dir, new_dir and the inodes associated with the dentries are=
 always
> equal. But given that simple_rename_timestamp() calls inode_set_ctime_cur=
rent()
> 4 times, the times could potentially be different.
>=20
> I am not sure if that is an issue, but it seems that calling
> inode_set_ctime_current() once, recording the "now" time it sets and usin=
g that
> value to set all times may be more efficient and preserve the existing be=
havior.
>=20

I don't believe it's an issue. I've seen nothing in the POSIX spec that
mandates that timestamp updates to different inodes involved in an
operation be set to the _same_ value. It just says they must be updated.

It's also hard to believe that any software would depend on this either,
given that it's very inconsistent across filesystems today. AFAICT, this
was mostly done in the past just as a matter of convenience.

The other problem with doing it that way is that it assumes that
current_time(inode) should always return the same value when given
different inodes. Is it really correct to do this?

	inode_set_ctime(dir, inode_set_ctime_current(inode));

"dir" and "inode" are different inodes, after all, and you're setting
dir's timestamp to "inode"'s value. It's not a big deal today since
they're always on the same sb, but the ultimate goal of these changes is
to implement multigrain timestamps. That will mean that fetching a fine-
grained timestamp for an update when the existing mtime or ctime value
has been queried via getattr.

With that change, I think it's best that we treat updates to different
inodes individually, as some of them may require updating with a fine-
grained timestamp and some may not.

> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(simple_rename_exchange);
> > @@ -720,7 +741,6 @@ int simple_rename(struct mnt_idmap *idmap, struct i=
node *old_dir,
> >  		  struct dentry *old_dentry, struct inode *new_dir,
> >  		  struct dentry *new_dentry, unsigned int flags)
> >  {
> > -	struct inode *inode =3D d_inode(old_dentry);
> >  	int they_are_dirs =3D d_is_dir(old_dentry);
> > =20
> >  	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
> > @@ -743,9 +763,7 @@ int simple_rename(struct mnt_idmap *idmap, struct i=
node *old_dir,
> >  		inc_nlink(new_dir);
> >  	}
> > =20
> > -	old_dir->i_ctime =3D old_dir->i_mtime =3D new_dir->i_ctime =3D
> > -		new_dir->i_mtime =3D inode->i_ctime =3D current_time(old_dir);
> > -
> > +	simple_rename_timestamp(old_dir, old_dentry, new_dir, new_dentry);
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL(simple_rename);
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index bdfbd11a5811..14e38bd900f1 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2979,6 +2979,8 @@ extern int simple_open(struct inode *inode, struc=
t file *file);
> >  extern int simple_link(struct dentry *, struct inode *, struct dentry =
*);
> >  extern int simple_unlink(struct inode *, struct dentry *);
> >  extern int simple_rmdir(struct inode *, struct dentry *);
> > +void simple_rename_timestamp(struct inode *old_dir, struct dentry *old=
_dentry,
> > +			     struct inode *new_dir, struct dentry *new_dentry);
> >  extern int simple_rename_exchange(struct inode *old_dir, struct dentry=
 *old_dentry,
> >  				  struct inode *new_dir, struct dentry *new_dentry);
> >  extern int simple_rename(struct mnt_idmap *, struct inode *,
>=20

--=20
Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
