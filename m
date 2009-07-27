From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH]nilfs2: Don't load/check invalid cno
Date: Tue, 28 Jul 2009 02:40:35 +0900 (JST)
Message-ID: <20090728.024035.102951444.ryusuke@osrg.net>
References: <4A6D7273.5010906@gmail.com>
	<977a2be20907270226s7c7037b5v38830e1ba68cefcb@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <977a2be20907270226s7c7037b5v38830e1ba68cefcb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Content-Type: text/plain; charset="iso-8859-9"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: qiang.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanhai.zhu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

Hi!
On Mon, 27 Jul 2009 17:26:58 +0800, Zhu Yanhai wrote:
> Below inconsistent error messages will be reported without this patch.
> =

> [root@zyh-fedora ~]# mount -t nilfs2 /dev/loop0 ./mount1
> mount.nilfs2: WARNING! - The NILFS on-disk format may change at any time.
> mount.nilfs2: WARNING! - Do not place critical data on a NILFS filesystem.
> [root@zyh-fedora ~]# lscp
>                  CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
>                    1  2009-07-26 16:14:26   cp    -         11          3
>                    2  2009-07-26 16:16:12   cp    -        637        144
>                    3  2009-07-26 16:16:47   cp    -         17        143
>                    4  2009-07-26 16:16:52   cp    -         16        142
>                    5  2009-07-26 16:16:58   cp    -         11        142
>                    6  2009-07-26 16:17:08   cp    -         18        141
> [root@zyh-fedora ~]# mount -t nilfs2 -r -o cp=3D10 /dev/loop0 ./mount2
> mount.nilfs2: Error while mounting /dev/loop0 on ./mount2: Invalid argume=
nt
> [root@zyh-fedora ~]# mount -t nilfs2 -r -o cp=3D20 /dev/loop0 ./mount2
> mount.nilfs2: Error while mounting /dev/loop0 on ./mount2: Invalid argume=
nt
> [root@zyh-fedora ~]# mount -t nilfs2 -r -o cp=3D30 /dev/loop0 ./mount2
> mount.nilfs2: Error while mounting /dev/loop0 on ./mount2: No such
> file or directory
> [root@zyh-fedora ~]# mount -t nilfs2 -r -o cp=3D40 /dev/loop0 ./mount2
> mount.nilfs2: Error while mounting /dev/loop0 on ./mount2: No such
> file or directory
> [root@zyh-fedora ~]# mount -t nilfs2 -r -o cp=3D25 /dev/loop0 ./mount2
> mount.nilfs2: Error while mounting /dev/loop0 on ./mount2: No such
> file or directory
> [root@zyh-fedora ~]# mount -t nilfs2 -r -o cp=3D21 /dev/loop0 ./mount2
> mount.nilfs2: Error while mounting /dev/loop0 on ./mount2: No such
> file or directory
 =

Thank you for pointing out the inconsistency.

Your patch noticed me that a few problems exist around the
nilfs_cpfile_is_snapshot() function:

 1) For invalid checkpoints it should return an ENOENT error, but this
    check is missing; a test with nilfs_checkpoint_invalid() should
    come before the nilfs_checkpoint_snapshot() test.

 2) If nilfs_cpfile_is_snapshot() returned an ENOENT error,
    nilfs_fill_super() should convert it to -EINVAL, but this is
    missing too.  (the ENOENT code is for internal use)

 3) Snapshots can be mounted concurrently with a writable mount.  So,
    the call site of nilfs_cpfile_is_snapshot() must be protected from
    segment writer.  I mean it should hold read lock for
    nilfs->ns_segctor_sem during the call-out like:

     down_read(&nilfs->ns_segctor_sem);
     err =3D nilfs_cpfile_is_snapshot(nilfs->ns_cpfile, sbi->s_snapshot_cno=
);
     up_read(&nilfs->ns_segctor_sem);

    This is needed even to protect the use of nilfs_mdt_cno().


Then, (1) and (2) would fix the inconsistency problem.

But I think your patch is still needed to exclude the next checkpoint
for snapshot mount.

A little bit problematic.. up to four fixes.

I would appreciate it if you could rewrite patches taking the above
into account.

Thanks in advance,
Ryusuke Konishi


> 2009/7/27 Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > nilfs2: Don't load/check cp block if specified cno is larger than the
> > largest exist one.
> > nilfs2 would load invalid cp block, and report random inconsistent error
> > message under this situation before.
> >
> > Signed-off-by: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> > ---
> > =A0fs/nilfs2/cpfile.c | =A0 =A07 ++++---
> > =A01 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
> > index aec942c..43978a9 100644
> > --- a/fs/nilfs2/cpfile.c
> > +++ b/fs/nilfs2/cpfile.c
> > @@ -814,9 +814,10 @@ int nilfs_cpfile_is_snapshot(struct inode *cpfile,=
 __u64 cno)
> > =A0 =A0 =A0 =A0struct nilfs_checkpoint *cp;
> > =A0 =A0 =A0 =A0void *kaddr;
> > =A0 =A0 =A0 =A0int ret;
> > -
> > - =A0 =A0 =A0 if (cno =3D=3D 0)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOENT; /* checkpoint number 0 is=
 invalid */
> > +
> > + =A0 =A0 =A0 /* return ENOENT if cno is invalid. */
> > + =A0 =A0 =A0 if (cno =3D=3D 0 || cno >=3D nilfs_mdt_cno(cpfile))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOENT;
> > =A0 =A0 =A0 =A0down_read(&NILFS_MDT(cpfile)->mi_sem);
> >
> > =A0 =A0 =A0 =A0ret =3D nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0=
, &bh);
> > --
> > 1.6.2.2
> >
