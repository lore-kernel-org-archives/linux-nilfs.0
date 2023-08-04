From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/12] nilfs2: use setup_bdev_super to de-duplicate the
 mount code
Date: Fri, 4 Aug 2023 11:01:39 +0900
Message-ID: <CAKFNMomzHg33SHnp6xGMEZY=+k6Y4t7dvBvgBDbO9H3ujzNDCw@mail.gmail.com>
References: <20230802154131.2221419-1-hch@lst.de> <20230802154131.2221419-3-hch@lst.de>
 <20230803114651.ihtqqgthbdjjgxev@quack3>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691114516; x=1691719316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Li4Rr3SDbAWbMC9vqUARkDUxqa5LNmgwNWmtZCQPN7c=;
        b=MoVB1XjmMagsHZzn9G8ftY6HWJZOUd3UQbdoUZGHvxiTrJtRhQmKpY5hMXxXdiDzuq
         zQBrBD4AM2yCz+AjuuOypK1qRVFL8If5W+fTO+cw9XBWSGuM7Hrx2k1cmlpjp62wiDDF
         xmsVPYq08ScKsEB2acJFU2fLVkjAs3OQk4kUojzHHGQtCjQau8BO/IfSPhWz7s7RoG+F
         ObfsdVyd9J6qFm5iu3TH8pCH6XZy+vWbCGwACVvcWshSg7B1v3rxfId451mLVIpY2bVi
         GasCyfXQI0s3z46olnWXSpFmLflSUgwZZScpT/KeG4Ra5OVORJFyNsdv2rD2oRuBkEtE
         dKlA==
In-Reply-To: <20230803114651.ihtqqgthbdjjgxev@quack3>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 3, 2023 at 8:46=E2=80=AFPM Jan Kara wrote:
>
> On Wed 02-08-23 17:41:21, Christoph Hellwig wrote:
> > Use the generic setup_bdev_super helper to open the main block device
> > and do various bits of superblock setup instead of duplicating the
> > logic.  This includes moving to the new scheme implemented in common
> > code that only opens the block device after the superblock has allocate=
d.
> >
> > It does not yet convert nilfs2 to the new mount API, but doing so will
> > become a bit simpler after this first step.
> >
> > Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>
> AFAICS nilfs2 could *almost* use mount_bdev() directly and then just do i=
ts

> snapshot thing after mount_bdev() returns. But it has this weird logic
> that: "if the superblock is already mounted but we can shrink the whole
> dcache, then do remount instead of ignoring mount options". Firstly, this
> looks racy - what prevents someone from say opening a file on the sb just
> after nilfs_tree_is_busy() shrinks dcache? Secondly, it is inconsistent
> with any other filesystem so it's going to surprise sysadmins not
> intimately knowing nilfs2. Thirdly, from userspace you cannot tell what
> your mount call is going to do. Last but not least, what is it really goo=
d
> for? Ryusuke, can you explain please?
>
>                                                                 Honza

I think you are referring to the following part:

>        if (!s->s_root) {
...
>        } else if (!sd.cno) {
>                if (nilfs_tree_is_busy(s->s_root)) {
>                        if ((flags ^ s->s_flags) & SB_RDONLY) {
>                                nilfs_err(s,
>                                          "the device already has a %s mou=
nt.",
>                                          sb_rdonly(s) ? "read-only" : "re=
ad/write");
>                                err =3D -EBUSY;
>                                goto failed_super;
>                        }
>                } else {
>                        /*
>                         * Try remount to setup mount states if the curren=
t
>                         * tree is not mounted and only snapshots use this=
 sb.
>                         */
>                        err =3D nilfs_remount(s, &flags, data);
>                        if (err)
>                                goto failed_super;
>                }
>        }

What this logic is trying to do is, if there is already a nilfs2 mount
instance for the device, and are trying to mounting the current tree
(sd.cno is 0, so this is not a snapshot mount), then will switch
depending on whether the current tree has a mount:

- If the current tree is mounted, it's just like a normal filesystem.
(A read-only mount and a read/write mount can't coexist, so check
that, and reuse the instance if possible)
- Otherwise, i.e. for snapshot mounts only, do whatever is necessary
to add a new current mount, such as starting a log writer.
   Since it does the same thing that nilfs_remount does, so
nilfs_remount() is used there.

Whether or not there is a current tree mount can be determined by
d_count(s->s_root) > 1 as nilfs_tree_is_busy() does.
Where s->s_root is always the root dentry of the current tree, not
that of the mounted snapshot.

I remember that calling shrink_dcache_parent() before this test was to
do the test correctly if there was garbage left in the dcache from the
past current mount.

If the current tree isn't mounted, it just cleans up the garbage, and
the reference count wouldn't have incremented in parallel.

If the current tree is mounted, d_count(s->s_root) will not decrease
to 1, so it's not a problem.
However, this will cause unexpected dcache shrinkage for the in-use
tree, so it's not a good idea, as you pointed out.  If there is
another way of judging without this side effect, it should be
replaced.

I will reply here once.

Regards,
Ryusuke Konishi
