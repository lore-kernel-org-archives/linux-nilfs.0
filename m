Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AE11F1537
	for <linux-nilfs@vger.kernel.org>; Mon,  3 Aug 2026 00:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785717204; cv=none; b=eTXVBQI83C7mEdbCXAAJ3cvPcwrdjWTrmHH3jHRBrJCkfy0v3o/3vf3M7D+ub7XTLx488TQ8RwMPEraFUZ2R90ER8RG5HdAQdpQ9lMBdFPpvVg8yjKJ64wQhRhCGzvx1EFITQKI6F1rfnoiZiCHQt4mkl8/7iWtDcEKAvmiCsxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785717204; c=relaxed/simple;
	bh=LADF072cLdK/+64/Ekd02wL+MzoV9QyyfJmYLdsCsBs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V9JpLSZlzATfL0VU1pJpxKxkdpTAhW35sC9JSnNTjr3ZUZjbO1RRGJmcTQjNUig/+U8fE2smhq6LS0+wpz7s7O0nQa/UIsXN0AFsVEg53gvSVKN7dlogzb7iy58eZP3kKZ31CfDcVbyzIwUNF/8HvE7cY6Jh2s35GY57HCjHEn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=bb7lkrWZ; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="bb7lkrWZ"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cbb85186d43so1248733a12.3
        for <linux-nilfs@vger.kernel.org>; Sun, 02 Aug 2026 17:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1785717202; x=1786322002; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LADF072cLdK/+64/Ekd02wL+MzoV9QyyfJmYLdsCsBs=;
        b=bb7lkrWZeVLFca3zBcZ3xnmhYJI1aErzgF/+ajxQ5EVfCV9c8pCAl8rLcp5zevbxLN
         Anxjz8bcIXk2gEeD/6zoHa/nU4t4IJ2nB22TUrDO8wYLxvnUWh9VvERQhXIBFvGBSQS+
         tElLUFX69/KzO1xaIYvw8eVpc+SZOuNN4sn1I6JdYDt6+lFlBIq7HYpKOvBTrTmlqouV
         FBbi+0Z1udR0LsxcEl5aipnEVYrdiicUVq+224ZN5JTKYONx6k7R87nc6kEFKQLaIPpp
         BN/eybNq4wAeJ9nFP1iWDJgbsHb1xz0vRpZBVX9OWSVtxTtj6cDIPedxrXOSs6TuSJq2
         sIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785717202; x=1786322002;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LADF072cLdK/+64/Ekd02wL+MzoV9QyyfJmYLdsCsBs=;
        b=KhxQ9lFPPX+aba3bXVgCqt5UX+TyK2Pen7opiQCv31Yo4sln3SKOgr89iCOL35PVKl
         PZENRX7+PA8WMcQxd7x/d2dJFBK/9a/YiLTNjanbSP3YJ6koO2OC+foomwrUixAWL2k5
         A8SK43k02BMQVsyQjujzStwJ6FMchmry17FGW3PxpwHl8rnRiy5vpFHmwPbWtZf7ci6B
         R/g/dX+bOm41LrpIB9DEzybQCr3XdoJji7gMglr791FHLWCFfDId61QdTM/DUIeiJ+rN
         scI4tmto1OKIYtUgqAZ5GW84CLdNQqTKPVd/2ubeKAfnPMRDGDdR0QujOqwP9as5pbN0
         ldzQ==
X-Forwarded-Encrypted: i=1; AHgh+RqvXcsZ4T3LIXjaOtzUrmmuyFB7wV2+N2/2tYCE0/9n2wGK6eX7VIaFFFWJJIY7NBQWTQQJpMg/qssd0A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzyoi4J4Q5ZoTKEAAj60pFu2H7NQN6YPK6RC5rQ04tXxTLG7S6+
	8G2DdNflw5JPG9RbpMmVruzZHvuxP7pd6YaB9jhdwloPj7NUhaRblibDseQBBU/0U/A=
X-Gm-Gg: AR+sD10mumXlpG6sI+vuyiPDTQ2w3YLXwfo2ckpVHyhm4tIyJFcaBhdIbpG3gdakBeJ
	r/4mgnFRgmlO9VMQQt4CYCXar2jMBCcjftnEYkkcNe4MBQkzGkmioVqjV/9MCmI3wtuyQnaNNQ5
	6dJcfgVMDgXJw9KowRJRK6oStz+Wqg2VqkaleaWAZcb7X14TlpgCBS0znMpmKz1BzMAwScS1pDR
	xrDNfymhCwJ4AbiwCA0bluGYG25Xeq/BsB3lwTSsCJI5Gn1/WGsBzHR4m3zlQdI3MEY7ANWsqo6
	ifdScpkxmzzRzVUv7opWBYV13ZggXryoUVCdzo6Y3nc/jza/tRpBF0GZ2mfLl+K3d1RFXRgMxlq
	PubYcZdOM1Dr4KH8sZxZdFKWaR7nRO6X1f6hwCru2wr7Eexyjw+2pTtYe1uYGWxgplWTAGBKeto
	Ly3Ilq+MWBdZT9MvKdGFnwQdbGuJc+mKxfsJac6H7QEm4aLrpk/UAiLmTOVTFYDPZwAnSkxR0Ge
	O8pSGcTwE3w9GNqIF90p0Eupv9peKZ/iBHfziX6hIhkMfcAh0jgqh1cxWn3Huz5LJGEfUdWcSsm
	e87bslKmxu4kpPTSKgDGFahX9fasDmYDPcsOIuIdDGlzBjIG5CnXIWg=
X-Received: by 2002:a05:6a21:103:b0:3bf:ab4b:2d34 with SMTP id adf61e73a8af0-3c92a8f3f72mr7354169637.53.1785717202100;
        Sun, 02 Aug 2026 17:33:22 -0700 (PDT)
Received: from [10.0.0.3] (162-197-212-70.lightspeed.sntcca.sbcglobal.net. [162.197.212.70])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab4f83c3sm21441376c88.14.2026.08.02.17.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 17:33:21 -0700 (PDT)
Message-ID: <0235657dcf690b2cf67181d10b4b0086437449db.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: fix block-offset handling in iomap reads
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Linmao Li
 <lilinmao@kylinos.cn>
Cc: Christian Brauner <brauner@kernel.org>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Sun, 02 Aug 2026 17:33:18 -0700
In-Reply-To: <CAKFNMokGmCHO65JVxFwuETFiKE6k10xs4bqfdgu4Gkq1PS9iSg@mail.gmail.com>
References: <20260731083840.3643821-1-lilinmao@kylinos.cn>
	 <CAKFNMokGmCHO65JVxFwuETFiKE6k10xs4bqfdgu4Gkq1PS9iSg@mail.gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-07-31 at 21:05 +0900, Ryusuke Konishi wrote:
> On Fri, Jul 31, 2026 at 5:38=E2=80=AFPM Linmao Li wrote:
> >=20
> > nilfs_iomap_begin() looks up the filesystem block containing the
> > requested
> > offset and returns the physical address of that block.=C2=A0 However, i=
t
> > sets
> > iomap->offset to the original, possibly sub-block, offset while
> > leaving
> > iomap->addr at the start of the physical block.
> >=20
> > iomap_sector() adds the difference between the I/O position and
> > iomap->offset to iomap->addr.=C2=A0 For an O_DIRECT read at offset 512
> > on a
> > filesystem with 4 KiB blocks, the two file offsets are equal and
> > the I/O is
> > therefore submitted at the start of the physical block instead of
> > 512 bytes
> > into it.=C2=A0 iomap direct I/O permits this alignment when the device
> > logical
> > block size is 512 bytes.
> >=20
> > Describe mapped and hole extents from the filesystem-block-aligned
> > file
> > offset.=C2=A0 This makes the physical and file offsets refer to the sam=
e
> > byte.
> > It also prevents a one-block hole mapping from extending into the
> > following
> > block.
> >=20
> > Fixes: b924d8d4e54f ("nilfs2: switch O_DIRECT reads to iomap")
> > Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> > ---
> > =C2=A0fs/nilfs2/iomap.c | 9 +++++----
> > =C2=A01 file changed, 5 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
> > index 3ae3bf6ed3686..e130ed63abd9a 100644
> > --- a/fs/nilfs2/iomap.c
> > +++ b/fs/nilfs2/iomap.c
> > @@ -18,6 +18,7 @@ static int nilfs_iomap_begin(struct inode *inode,
> > loff_t offset,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct the_nilfs *nilfs =3D =
inode->i_sb->s_fs_info;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct nilfs_inode_info *ii =
=3D NILFS_I(inode);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sector_t blkoff =3D offset >=
> inode->i_blkbits;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 loff_t iomap_offset =3D (loff_t)b=
lkoff << inode->i_blkbits;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int maxblocks;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u64 blknum =3D 0;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> > @@ -50,15 +51,15 @@ static int nilfs_iomap_begin(struct inode
> > *inode, loff_t offset,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -ENOENT) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 iomap->type =3D IOMAP_HOLE;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 iomap->addr =3D IOMAP_NULL_ADDR;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->offset =3D offset;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->length =3D min_t(loff_t, length,
> > i_blocksize(inode));
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->offset =3D iomap_offset;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->length =3D i_blocksize(inode);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return 0;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (ret < 0)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return ret;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iomap->bdev =3D inode->i_sb-=
>s_bdev;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iomap->offset =3D offset;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iomap->length =3D min_t(loff_t, l=
ength, (loff_t)ret << inode-
> > >i_blkbits);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iomap->offset =3D iomap_offset;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iomap->length =3D (loff_t)ret << =
inode->i_blkbits;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iomap->addr =3D (loff_t)blkn=
um << inode->i_blkbits;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iomap->type =3D IOMAP_MAPPED=
;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iomap->flags =3D IOMAP_F_MER=
GED;
> >=20
> > base-commit: d5c57d9bf03516d625521cd6cf5acfd93e3e63c7
> > --
> > 2.25.1
>=20
> Hi Linmao,
>=20
> Since the O_DIRECT iomap conversion patch series is currently under
> review and subject to revision, please post your finding as comments
> on the original patch thread in the future, rather than sending a
> standalone patch with a premature Fixes tag.
>=20
> Hi Viacheslav,
> I believe the point being made is that a misalignment occurs because
> iomap->addr is adjusted to the block boundary, whereas iomap->offset
> is not.=C2=A0 Could you take a look at his points ?
>=20

Hi Ryusuke,

The fix makes sense to me. I am attending FMS 2026 (August 4th - 6th).
So, I don't have time for preparing v2 of the patchset with adding
Linmao's fix during this week. Let me try to find the time for pathset
reworking around the end of this week.

Thanks,
Slava.
