From: =?GB2312?B?1cUgwNo=?= <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Thu, 20 Dec 2012 17:08:40 +0800
Message-ID: <3455B0CD-EF89-4227-90E1-FC6B20F5F8EB@gmail.com>
References: <86B5C141-ACFA-4541-999F-E17E09F22476@gmail.com> <1355983713.2056.3.camel@slavad-ubuntu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:content-type:mime-version:subject:from:in-reply-to:date
         :cc:content-transfer-encoding:message-id:references:to:x-mailer;
        bh=+wKBv6/fqrG8/GhcXErwun3T4wVK0FyIg7ntjl96x+s=;
        b=MKR+pgNmN6nzZOFzj80zcoe4w8XFvcCWBaKzQidohBMVLVrE7GWaB4uMvCrBH12GRD
         ZeUHmHaFFSD2Sn1VdduPoP3T3fESVZE2i0LQnG7whkP2+gHKOZp1tWvO/+WA48qPpBe0
         YUx5/hT8fLjg9nHKFov8uPTKYNkpexCNlV0JaDOQrk0gY2EwWvYbHlSOaDv4HgyzC6ib
         6PncbxYCWv+tS9N9+6E4YfGk7fO/fl12VwjmvB5GNIrrCRC+D8Y9FmYcCdeCl7Rk/EWc
         cNC1N8qrsN86YJ75HPM9UkDby+83tWTCJ051JYezovk1O3cvymm4YSgX1PYtNXvFHDja
         MkVw==
In-Reply-To: <1355983713.2056.3.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I remounted the filesystem, and started the MySQLs. The filesytstem bec=
ame readonly again.

Dec 20 16:03:31 localhost kernel: segctord starting. Construction inter=
val =3D 60 seconds, CP frequency < 30 seconds
Dec 20 16:03:31 localhost kernel: NILFS warning: mounting fs with error=
s
Dec 20 16:03:31 localhost nilfs_cleanerd[29120]: start
Dec 20 16:03:55 localhost kernel: NILFS: bad btree node (blocknr=3D7101=
53406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
Dec 20 16:03:55 localhost kernel: NILFS error (device sdb2): nilfs_bmap=
_lookup_contig: broken bmap (inode number=3D321775)
Dec 20 16:03:55 localhost kernel:
Dec 20 16:03:55 localhost kernel: Remounting filesystem read-only
Dec 20 16:03:55 localhost kernel: NILFS: bad btree node (blocknr=3D7101=
53406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
Dec 20 16:03:55 localhost kernel: NILFS error (device sdb2): nilfs_bmap=
_lookup_contig: broken bmap (inode number=3D321775)
Dec 20 16:03:55 localhost kernel:
Dec 20 16:03:57 localhost nilfs_cleanerd[29120]: cannot clean segments:=
 Read-only file system
Dec 20 16:03:57 localhost nilfs_cleanerd[29120]: shutdown

I remounted the filesystem again, and tried to delete the bad files, bu=
t delete failed.

Dec 20 16:04:02 localhost kernel: segctord starting. Construction inter=
val =3D 60 seconds, CP frequency < 30 seconds
Dec 20 16:04:02 localhost kernel: NILFS warning: mounting fs with error=
s
Dec 20 16:04:02 localhost nilfs_cleanerd[30054]: start
Dec 20 16:12:08 localhost kernel: NILFS: bad btree node (blocknr=3D7101=
53406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
Dec 20 16:12:08 localhost kernel: NILFS error (device sdb2): nilfs_bmap=
_last_key: broken bmap (inode number=3D321775)
Dec 20 16:12:08 localhost kernel:
Dec 20 16:12:08 localhost kernel: Remounting filesystem read-only
Dec 20 16:12:08 localhost kernel: NILFS warning (device sdb2): nilfs_tr=
uncate_bmap: failed to truncate bmap (ino=3D321775, err=3D-5)
Dec 20 16:12:08 localhost nilfs_cleanerd[30054]: cannot clean segments:=
 Read-only file system
Dec 20 16:12:08 localhost nilfs_cleanerd[30054]: shutdown

I tried a third remount, but failed. The server was down, and restarted=
=2E

Dec 20 16:12:42 localhost kernel: NILFS warning (device sdb2): nilfs_de=
tach_log_writer: Hit dirty file after stopped log writer
Dec 20 16:12:42 localhost kernel:

I found that fsck.nilfs2 was added into nilfs-utils v4. Can I try it? W=
here can I download nilfs-utils v4?

=D4=DA 2012-12-20=A3=AC14:08=A3=ACVyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org=
> =D0=B4=B5=C0=A3=BA

> Hi,
>=20
> On Thu, 2012-12-20 at 10:46 +0800, =D5=C5 =C0=DA wrote:
>> Hello.
>> 	My nilfs suddenly become read-only. I saw these logs in /var/log/me=
ssages:
>>=20
>> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D7=
10153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
>> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_b=
map_lookup_contig: broken bmap (inode number=3D321775)
>> Dec 19 11:20:05 localhost kernel:
>> Dec 19 11:20:05 localhost kernel: Remounting filesystem read-only
>> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D7=
10153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
>> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_b=
map_lookup_contig: broken bmap (inode number=3D321775)
>> Dec 19 11:20:05 localhost kernel:
>> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D7=
10153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
>> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_b=
map_lookup_contig: broken bmap (inode number=3D321775)
>> Dec 19 11:20:05 localhost kernel:
>> Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D7=
10153406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
>> Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_b=
map_lookup_contig: broken bmap (inode number=3D321775)
>> Dec 19 11:20:05 localhost kernel:
>> =A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=
=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD
>>=20
>> 	How can I fix this? There is 6TiB data on my disk, I don't want to =
format the disk.
>> 	I found that a lot of people have encountered the same problem. Is =
this a bug of nilfs? How can I avoid this problem? When it happens, I w=
as running multiple MySQL and rsync, and nilfs_cleanerd was cleaning se=
gments.
>>=20
>=20
> Yes, this issue was reported earlier. As I understand, you can simply
> remount your filesystem in read-write mode and to continue using your
> NILFS2 filesystem.
>=20
> If you will encounter any troubles with remounting, please, report ab=
out
> it.
>=20
> With the best regards,
> Vyacheslav Dubeyko.
>=20
>=20
>> Elmer Zhang--
>> To unsubscribe from this list: send the line "unsubscribe linux-nilf=
s" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
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
