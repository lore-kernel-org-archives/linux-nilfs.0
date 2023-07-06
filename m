From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 00/89] fs: new accessors for inode->i_ctime
Date: Thu, 06 Jul 2023 12:14:58 -0400
Message-ID: <3948ae7653d1cb7c51febcca26a35775e71a53b4.camel@kernel.org>
References: <20230705185812.579118-1-jlayton@kernel.org>
         <a4e6cfec345487fc9ac8ab814a817c79a61b123a.camel@kernel.org>
         <87ilaxgjek.fsf@email.froward.int.ebiederm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <ecryptfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688660118;
        bh=r5Eqjb/koo4X65bgDBYxDesIkgsRAdhnfATQ4gt2Esk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uOgU9evq5o16T6L6tpJH1n8YSQl4p50BjR5wiJPLoKkMzHgO7DWjFII6ePLp5KpdE
         3SlBOVBQ0Ayb1Ck5njyhQkfK/lBmsjOnzq7A/dE1stN3VqJX7pH6IQsgFKtN1DalJo
         E+zh6oq4S0OPw7rIh8zXpFwi+8/fexgoqLXDvhFUUOG0TWnPj5LM1mmg7dIC7PaCB3
         IOEyQDVn/tGwcs+s3mZaJELn1kEqbOemjyG66rmihhs9u/EaGnd4WvmH/942idbgOQ
         fgiPtHR0C+lrv0o8CzKEzOTX/CaJMpmdnCKaL0ZpaSmvJsFgbp9PEliTkXRbGZddzd
         Fm4yxVau37qTQ==
In-Reply-To: <87ilaxgjek.fsf@email.froward.int.ebiederm.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: jk@ozlabs.org, arnd@arndb.de, mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com, maco@android.com, joel@joelfernandes.org, brauner@kernel.org, cmllamas@google.com, surenb@google.com, dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca, leon@kernel.org, bwarrum@linux.ibm.com, rituagar@linux.ibm.com, ericvh@kernel.org, lucho@ionkov.net, asmadeus@codewreck.org, linux_oss@crudebyte.com, dsterba@suse.com, dhowells@redhat.com, marc.dionne@auristor.com, viro@zeniv.linux.org.uk, raven@themaw.net, luisbg@kernel.org, salah.triki@gmail.com, aivazian.tigran@gmail.com, keescook@chromium.org, clm@fb.com

On Thu, 2023-07-06 at 10:16 -0500, Eric W. Biederman wrote:
> Jeff Layton <jlayton@kernel.org> writes:
>=20
> > On Wed, 2023-07-05 at 14:58 -0400, Jeff Layton wrote:
> > > v2:
> > > - prepend patches to add missing ctime updates
> > > - add simple_rename_timestamp helper function
> > > - rename ctime accessor functions as inode_get_ctime/inode_set_ctime_=
*
> > > - drop individual inode_ctime_set_{sec,nsec} helpers
> > >=20
> > > I've been working on a patchset to change how the inode->i_ctime is
> > > accessed in order to give us conditional, high-res timestamps for the
> > > ctime and mtime. struct timespec64 has unused bits in it that we can =
use
> > > to implement this. In order to do that however, we need to wrap all
> > > accesses of inode->i_ctime to ensure that bits used as flags are
> > > appropriately handled.
> > >=20
> > > The patchset starts with reposts of some missing ctime updates that I
> > > spotted in the tree. It then adds a new helper function for updating =
the
> > > timestamp after a successful rename, and new ctime accessor
> > > infrastructure.
> > >=20
> > > The bulk of the patchset is individual conversions of different
> > > subsysteme to use the new infrastructure. Finally, the patchset renam=
es
> > > the i_ctime field to __i_ctime to help ensure that I didn't miss
> > > anything.
> > >=20
> > > This should apply cleanly to linux-next as of this morning.
> > >=20
> > > Most of this conversion was done via 5 different coccinelle scripts, =
run
> > > in succession, with a large swath of by-hand conversions to clean up =
the
> > > remainder.
> > >=20
> >=20
> > A couple of other things I should note:
> >=20
> > If you sent me an Acked-by or Reviewed-by in the previous set, then I
> > tried to keep it on the patch here, since the respun patches are mostly
> > just renaming stuff from v1. Let me know if I've missed any.
> >=20
> > I've also pushed the pile to my tree as this tag:
> >=20
> >     https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/t=
ag/?h=3Dctime.20230705
> >=20
> > In case that's easier to work with.
>=20
> Are there any preliminary patches showing what you want your introduced
> accessors to turn into?  It is hard to judge the sanity of the
> introduction of wrappers without seeing what the wrappers are ultimately
> going to do.
>=20
> Eric

I have a draft version of the multigrain patches on top of the wrapper
conversion I've already posted in my "mgctime-experimental" branch:

    https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/log/?=
h=3Dmgctime-experimental

The rationale is best explained in this changelog:

    https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/commi=
t/?h=3Dmgctime-experimental&id=3Dface437a144d3375afb7f70c233b0644b4edccba

The idea will be to enable this on a per-fs basis.
--=20
Jeff Layton <jlayton@kernel.org>
