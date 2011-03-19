From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Regarding ``problem with nilfs_cleanerd - part 2'' and ``Nilfs_cleanerd err=-17''
Date: Sat, 19 Mar 2011 20:04:14 +0100
Message-ID: <201103192004.14947.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=KCdwTlYoiSJqwtHGqBZ5DkAq4MeMOM9ft5R+mpz7n2k=;
        b=SkKfIuN49JIH5ZwGRmJV4bVLI1qZFcALCUIWpQbzWwJpT8fVdcZjDyh0efs+zs+Srm
         8DhxNMu36N0dJt/sqvFALv/B0kRNSxwdVe8bsRyP8OktnKTSHntd92EwjLkKDMEDpkW6
         nhiPlWno+tI5U695P+3yKQMUrKRNuHrnk1pL0=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,


I had same problems as bryce and =C5=81ukasz W=C3=B3jcicki described ea=
rlier:

[41045.664120] nilfs_ioctl_move_inode_block: conflicting node buffer: i=
no=3D79, cno=3D6, offset=3D0, blocknr=3D206010, vblocknr=3D94783
[41045.664129] NILFS: GC failed during preparation: cannot read source =
blocks: err=3D-17
and nilfs_cleanerd dies.


=46irst round of digging indicates this can be reproduced by running tw=
o
nilfs_cleanerd instances at the same time.
I'm not sure if that was the original cause, but I'm going to investing=
ate a bit more;
please hint me at what to pay attention to, if you would.


Regards,
--=20
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
