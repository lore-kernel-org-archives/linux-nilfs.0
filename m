From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Thu, 20 Dec 2012 13:38:30 +0400
Message-ID: <1355996310.2056.28.camel@slavad-ubuntu>
References: <86B5C141-ACFA-4541-999F-E17E09F22476@gmail.com>
	 <1355983713.2056.3.camel@slavad-ubuntu>
	 <3455B0CD-EF89-4227-90E1-FC6B20F5F8EB@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=l7QScKlEdMemgpZSl4vt5sQLNfbhdT0akQvUAubl+MM=;
	b=MTqn+0V6p6JWFXFJetI+Szwr+DRLk1E0q/P7+dVE7xYoOXYuiaEuI8nu/CPhWY9697A7MRlsPsktSeWFVD4LD4hgirtL1vIbnUUIYHFhOQPnnd6Euseo6TuulQo0UqeI;
In-Reply-To: <3455B0CD-EF89-4227-90E1-FC6B20F5F8EB-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=E5=BC=A0_=E7=A3=8A?= <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2012-12-20 at 17:08 +0800, =E5=BC=A0 =E7=A3=8A wrote:
> Hi,
>=20
> I remounted the filesystem, and started the MySQLs. The filesytstem b=
ecame readonly again.
>=20
> Dec 20 16:03:31 localhost kernel: segctord starting. Construction int=
erval =3D 60 seconds, CP frequency < 30 seconds
> Dec 20 16:03:31 localhost kernel: NILFS warning: mounting fs with err=
ors
> Dec 20 16:03:31 localhost nilfs_cleanerd[29120]: start
> Dec 20 16:03:55 localhost kernel: NILFS: bad btree node (blocknr=3D71=
0153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> Dec 20 16:03:55 localhost kernel: NILFS error (device sdb2): nilfs_bm=
ap_lookup_contig: broken bmap (inode number=3D321775)
> Dec 20 16:03:55 localhost kernel:
> Dec 20 16:03:55 localhost kernel: Remounting filesystem read-only
> Dec 20 16:03:55 localhost kernel: NILFS: bad btree node (blocknr=3D71=
0153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> Dec 20 16:03:55 localhost kernel: NILFS error (device sdb2): nilfs_bm=
ap_lookup_contig: broken bmap (inode number=3D321775)
> Dec 20 16:03:55 localhost kernel:
> Dec 20 16:03:57 localhost nilfs_cleanerd[29120]: cannot clean segment=
s: Read-only file system
> Dec 20 16:03:57 localhost nilfs_cleanerd[29120]: shutdown
>=20
> I remounted the filesystem again, and tried to delete the bad files, =
but delete failed.
>=20
> Dec 20 16:04:02 localhost kernel: segctord starting. Construction int=
erval =3D 60 seconds, CP frequency < 30 seconds
> Dec 20 16:04:02 localhost kernel: NILFS warning: mounting fs with err=
ors
> Dec 20 16:04:02 localhost nilfs_cleanerd[30054]: start
> Dec 20 16:12:08 localhost kernel: NILFS: bad btree node (blocknr=3D71=
0153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> Dec 20 16:12:08 localhost kernel: NILFS error (device sdb2): nilfs_bm=
ap_last_key: broken bmap (inode number=3D321775)
> Dec 20 16:12:08 localhost kernel:
> Dec 20 16:12:08 localhost kernel: Remounting filesystem read-only
> Dec 20 16:12:08 localhost kernel: NILFS warning (device sdb2): nilfs_=
truncate_bmap: failed to truncate bmap (ino=3D321775, err=3D-5)
> Dec 20 16:12:08 localhost nilfs_cleanerd[30054]: cannot clean segment=
s: Read-only file system
> Dec 20 16:12:08 localhost nilfs_cleanerd[30054]: shutdown
>=20
> I tried a third remount, but failed. The server was down, and restart=
ed.
>=20
> Dec 20 16:12:42 localhost kernel: NILFS warning (device sdb2): nilfs_=
detach_log_writer: Hit dirty file after stopped log writer
> Dec 20 16:12:42 localhost kernel:
>=20

Yes, it is bad. The remount solves the trouble earlier.

As a result, do you have NILFS2 volume mounted as read-only?

Could you share more details about your environment? It needs for
understanding situation and trying to reproduce. I need to know:
1. Linux kernel version.
2. nilfs-utils version.
3. "mount" output.
4. "df -h" output.
5. "lscp" output.
6. "lssu" output.
7. "nilfs-tune -l" output (superblock content)

> I found that fsck.nilfs2 was added into nilfs-utils v4. Can I try it?=
 Where can I download nilfs-utils v4?
>=20

Last version of nilfs-utils is 2.1.4. Currently, fsck.nilfs2 is on earl=
y
stage of development. The v4 is a fsck.nilfs2 patchset version. You can
try fsck.nilfs2 after applying this patchset on source code of
nilfs-utils of 2.1.4 version. But fsck.nilfs2 can check only superblock=
s
and segment summary headers and can't recover completely. So, I think
that it will be useless for you.

With the best regards,
Vyacheslav Dubeyko.

> =E5=9C=A8 2012-12-20=EF=BC=8C14:08=EF=BC=8CVyacheslav Dubeyko <slava@=
dubeyko.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> > Hi,
> >=20
> > On Thu, 2012-12-20 at 10:46 +0800, =E5=BC=A0 =E7=A3=8A wrote:
> >> Hello.
> >> 	My nilfs suddenly become read-only. I saw these logs in /var/log/=
messages:
> >>=20
> >> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D=
710153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> >> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs=
_bmap_lookup_contig: broken bmap (inode number=3D321775)
> >> Dec 19 11:20:05 localhost kernel:
> >> Dec 19 11:20:05 localhost kernel: Remounting filesystem read-only
> >> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D=
710153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> >> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs=
_bmap_lookup_contig: broken bmap (inode number=3D321775)
> >> Dec 19 11:20:05 localhost kernel:
> >> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D=
710153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> >> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs=
_bmap_lookup_contig: broken bmap (inode number=3D321775)
> >> Dec 19 11:20:05 localhost kernel:
> >> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D=
710153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
> >> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs=
_bmap_lookup_contig: broken bmap (inode number=3D321775)
> >> Dec 19 11:20:05 localhost kernel:
> >> =E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=
=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=
=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6
> >>=20
> >> 	How can I fix this? There is 6TiB data on my disk, I don't want t=
o format the disk.
> >> 	I found that a lot of people have encountered the same problem. I=
s this a bug of nilfs? How can I avoid this problem? When it happens, I=
 was running multiple MySQL and rsync, and nilfs_cleanerd was cleaning =
segments.
> >>=20
> >=20
> > Yes, this issue was reported earlier. As I understand, you can simp=
ly
> > remount your filesystem in read-write mode and to continue using yo=
ur
> > NILFS2 filesystem.
> >=20
> > If you will encounter any troubles with remounting, please, report =
about
> > it.
> >=20
> > With the best regards,
> > Vyacheslav Dubeyko.
> >=20
> >=20
> >> Elmer Zhang--
> >> To unsubscribe from this list: send the line "unsubscribe linux-ni=
lfs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nil=
fs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
