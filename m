From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/12] nilfs2: use setup_bdev_super to de-duplicate the
 mount code
Date: Thu, 10 Aug 2023 13:05:47 +0200
Message-ID: <20230810110547.ks62g2flysgwpgru@quack3>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-3-hch@lst.de>
 <20230803114651.ihtqqgthbdjjgxev@quack3>
 <CAKFNMomzHg33SHnp6xGMEZY=+k6Y4t7dvBvgBDbO9H3ujzNDCw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1691665548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1DFh8evqtxspjStydxXxKkjnilpW0tYumnluwrTMIZo=;
        b=vLT7nxhsKaVB+2d6j1Yf5X8t1GLYqRuuN4g6ZutMMICOunL7y0FZNv7gLZiYXzC/l2Xomu
        I8xmm0CPUZCp/iFMbz+eWr+/L/YJb1/utRAjSeiWYdJX1v/2EQl6s2syK6Yg4TzJfLlWXK
        j+SruuD6SzbR8Z3B6IZKMOfh62510CU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1691665548;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1DFh8evqtxspjStydxXxKkjnilpW0tYumnluwrTMIZo=;
        b=gjop8gtt3TnFXcbkSm06MHlxNzKkmd+CJQt27qbqqSRylA/dQexstbBZ/MQ0KnNaiV041a
        Mrb6ToOuPtQHkpAw==
Content-Disposition: inline
In-Reply-To: <CAKFNMomzHg33SHnp6xGMEZY=+k6Y4t7dvBvgBDbO9H3ujzNDCw@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Fri 04-08-23 11:01:39, Ryusuke Konishi wrote:
> On Thu, Aug 3, 2023 at 8:46=E2=80=AFPM Jan Kara wrote:
> >
> > On Wed 02-08-23 17:41:21, Christoph Hellwig wrote:
> > > Use the generic setup_bdev_super helper to open the main block device
> > > and do various bits of superblock setup instead of duplicating the
> > > logic.  This includes moving to the new scheme implemented in common
> > > code that only opens the block device after the superblock has alloca=
ted.
> > >
> > > It does not yet convert nilfs2 to the new mount API, but doing so will
> > > become a bit simpler after this first step.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >
> > AFAICS nilfs2 could *almost* use mount_bdev() directly and then just do=
 its
>=20
> > snapshot thing after mount_bdev() returns. But it has this weird logic
> > that: "if the superblock is already mounted but we can shrink the whole
> > dcache, then do remount instead of ignoring mount options". Firstly, th=
is
> > looks racy - what prevents someone from say opening a file on the sb ju=
st
> > after nilfs_tree_is_busy() shrinks dcache? Secondly, it is inconsistent
> > with any other filesystem so it's going to surprise sysadmins not
> > intimately knowing nilfs2. Thirdly, from userspace you cannot tell what
> > your mount call is going to do. Last but not least, what is it really g=
ood
> > for? Ryusuke, can you explain please?
> >
> >                                                                 Honza
>=20
> I think you are referring to the following part:
>=20
> >        if (!s->s_root) {
> ...
> >        } else if (!sd.cno) {
> >                if (nilfs_tree_is_busy(s->s_root)) {
> >                        if ((flags ^ s->s_flags) & SB_RDONLY) {
> >                                nilfs_err(s,
> >                                          "the device already has a %s m=
ount.",
> >                                          sb_rdonly(s) ? "read-only" : "=
read/write");
> >                                err =3D -EBUSY;
> >                                goto failed_super;
> >                        }
> >                } else {
> >                        /*
> >                         * Try remount to setup mount states if the curr=
ent
> >                         * tree is not mounted and only snapshots use th=
is sb.
> >                         */
> >                        err =3D nilfs_remount(s, &flags, data);
> >                        if (err)
> >                                goto failed_super;
> >                }
> >        }
>=20
> What this logic is trying to do is, if there is already a nilfs2 mount
> instance for the device, and are trying to mounting the current tree
> (sd.cno is 0, so this is not a snapshot mount), then will switch
> depending on whether the current tree has a mount:
>=20
> - If the current tree is mounted, it's just like a normal filesystem.
> (A read-only mount and a read/write mount can't coexist, so check
> that, and reuse the instance if possible)
> - Otherwise, i.e. for snapshot mounts only, do whatever is necessary
> to add a new current mount, such as starting a log writer.
>    Since it does the same thing that nilfs_remount does, so
> nilfs_remount() is used there.
>=20
> Whether or not there is a current tree mount can be determined by
> d_count(s->s_root) > 1 as nilfs_tree_is_busy() does.
> Where s->s_root is always the root dentry of the current tree, not
> that of the mounted snapshot.

I see now, thanks for explanation! But one thing still is not clear to me.
If you say have a snapshot mounted read-write and then you mount the
current snapshot (cno =3D=3D 0) read-only, you'll switch the whole superblo=
ck
to read-only state. So also the mounted snapshot is suddently read-only
which is unexpected and actually supposedly breaks things because you can
still have file handles open for writing on the snapshot etc.. So how do
you solve that?

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
