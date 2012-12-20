From: =?GB2312?B?1cUgwNo=?= <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: NILFS: bad btree node
Date: Thu, 20 Dec 2012 10:46:54 +0800
Message-ID: <86B5C141-ACFA-4541-999F-E17E09F22476@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:content-type:content-transfer-encoding:subject
         :message-id:date:to:mime-version:x-mailer;
        bh=+h0QYQJHw8fKBL2nrSnVjo5eemG4DWbobQ4gqYJ55Zc=;
        b=VmLFHPklvGXl5TAXyHRJPXJB+yXfxj2IY/R2NM+x8snXzC9M04pe0TTgr9SmdZ8Mxe
         NqbNGbhNE904Wbnv63OZyFIw1ZF9LSl+e3rChJYTNb8zBQ+yg8MwGwTqJFma1gPgULbf
         0VFYEju5NZ/G1Sf+sbrA30TUmSE8zliLTesNhKJJ0I+ZMqgrSvhTV6dVdUZrcfCqz4hN
         oG83JbaFZ/3I8GzwL9ZkGpN7m1g3SPysKoRp/XXzHDma5oHUsMfnDDcSKmAuMV0uCnVy
         5EvP2jehSyUSTXQGsqh01Ao1+9L9CMaqoCKI47v8xKP3QN/ELTANL/snkZbNjpbs9rH/
         LKKA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.
	My nilfs suddenly become read-only. I saw these logs in /var/log/messa=
ges:

Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D7101=
53406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_bmap=
_lookup_contig: broken bmap (inode number=3D321775)
Dec 19 11:20:05 localhost kernel:
Dec 19 11:20:05 localhost kernel: Remounting filesystem read-only
Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D7101=
53406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_bmap=
_lookup_contig: broken bmap (inode number=3D321775)
Dec 19 11:20:05 localhost kernel:
Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D7101=
53406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_bmap=
_lookup_contig: broken bmap (inode number=3D321775)
Dec 19 11:20:05 localhost kernel:
Dec 19 11:20:05 localhost kernel: NILFS: bad btree node (blocknr=3D7101=
53406): level =3D 0, flags =3D 0x2, nchildren =3D 25088
Dec 19 11:20:05 localhost kernel: NILFS error (device sdb2): nilfs_bmap=
_lookup_contig: broken bmap (inode number=3D321775)
Dec 19 11:20:05 localhost kernel:
=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=
=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD=A1=AD

	How can I fix this? There is 6TiB data on my disk, I don't want to for=
mat the disk.
	I found that a lot of people have encountered the same problem. Is thi=
s a bug of nilfs? How can I avoid this problem? When it happens, I was =
running multiple MySQL and rsync, and nilfs_cleanerd was cleaning segme=
nts.

Elmer Zhang--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
