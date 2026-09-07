Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E0251D53E
	for <linux-nilfs@vger.kernel.org>; Mon,  7 Sep 2026 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801446; cv=none; b=REKDfTTA+PmJQM7p7nf9syALFx98Q1W8m8g+t6A/+EFxd72bEIw1nnfkp4uBP7uipPZXfP2FDdFzFFqQtfOvNQdrgjN4jXTd2xj1fbnW3DiVFBAcq7Jbh5tT9uYJvVrHEw155JHvITkFzCdvvvR4p7j3uaLvnRsqVwu6TF0oYJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801446; c=relaxed/simple;
	bh=yiCzprvqT+GPoB0Yp/H5+zGOh8MIQdm4mTZzlW78Fm0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gmow1I7npPe6bijAQB7MWQilpXxq1CLuoRZEGuOMb5GNzI9YQIhqyEZI5d73tJaeIlb49LTz3rQX40Dls0O1mhkKkPWAT5kxV+h/eby+c81eUBiierAi5e/fuqf3MPTwzMS8duZZPipR9KtideJ1HPaGTV20t7gC3/KX4xOpQ6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=N+8r9VTs; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="N+8r9VTs"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-77bf3334d14so2525675137.1
        for <linux-nilfs@vger.kernel.org>; Mon, 07 Sep 2026 10:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1788801439; x=1789406239; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yiCzprvqT+GPoB0Yp/H5+zGOh8MIQdm4mTZzlW78Fm0=;
        b=N+8r9VTskDSffc2qqKJI0azUIIa1VT9TRgysSIfRpHNAV58cQ27AA99FLwtcaxFLiY
         2TrAJ1fu5PS5p5e48wp0w8wn/J8mMxj2GgscAmXEuESPCZrm4YyCISeWpQcUBy6asVgE
         do+mpcbzEzK5EeDPaxVqisF1Zf5RlumNjW18UHLDZDw8WgtkW6KqO1FlcMZ5VE+rSIgw
         0emNx2fmJ9hGyib7XMoTy+musAPiVjGJ6o0hjhDjSImDvLrIagg9mJR49Ox9Fz3eazLX
         Y1fWbbv+uwk6GK2xr8oHXhCxn5AYKiKeoXlb27dJv5cQfZEn+VugnbBi0BEmvRMYLbCa
         E1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788801439; x=1789406239;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yiCzprvqT+GPoB0Yp/H5+zGOh8MIQdm4mTZzlW78Fm0=;
        b=X2wFDU8vi2NFPW637AVr9Rmhu0GLSM7XJa/ESK9pqGCwLEwEibXfK0qEtfcojyQRFv
         p454fCftNNH/4QhGGRd7sRGvbwZvN1gBE/oLn4cYncQpSelwyPvuMo/tomTJJUXhdvB5
         BaU58orPFxkSn/y1pjg7vqfafiKgLVaMTAH1nXYOAXKXOXGHtnlUsHKgf0j64LzH2sDV
         hbGgEwyIg/US4J9pzP8lOh2VT3Nhow7jAgXiV1PdfPk2xau3afxOYexUeovJomlNZMdM
         k7rj9WroCm8nZn9h5rrVLK9CCamUewyb9gELNQiKT7iHNCSl0vHcJiCq+2S99lANbcXF
         Tgcg==
X-Forwarded-Encrypted: i=1; AKwUvBzsFuqL6tUd2mqoLIHH2YLmwODvKVjoyPr38xIS7i1/rjeb7HxiCmgxcUG08bOrHmk2gW+3++NwC6QIyg==@vger.kernel.org
X-Gm-Message-State: AFuF++mt6uH+c19dwJgz9vXAFJ9YhDspHivu5PGFqeVoYkbN7uTp7d96
	MYtE+c3LzQmhR3hEG/vcUvoY+DG+NvC6HkH5nkKtPXUFspdzZU3+UChWjfDl7uMAlog=
X-Gm-Gg: AYBFou1UdQ6/+IFTsfn5h3pPRUMaKtKwVrkxH6bp+HIGCFfZat9+Y6gSODsGvbK0DtP
	3RoqlkTUHSvv7ibelHjnpTFJFZeJSFJwrmdp74lBOS5G7OHREqmiBWnCqTLdepdCaiizCzDFbuK
	jvqBE4WhgvrQbYlW95erwL7wLRCYQLBflGPNWBGMWaEZt3IEzejkDoWYS5lBmSN9Yz5nXMaMp8F
	/vya0qHXLRqEi/+lXn0IYhUEln5innkOxX/W0Rv6fflRh6k1XFCkl6c4lmgXRi90n6uYhmLVnrQ
	0StFCCUrofbHpyuqnEfOJB3ATqz6EkN8mBxLa+fYfmYfOi2TQVmkGZIywLxlhVuxkuerOgEileJ
	uXTtp7e/Wf19Iw4jsPDldFw3ff1cYMyjJLXxmEG+IHOJfZtII+FQ4NMcC4kmZr2mPfhHr+7jXXG
	MkA+7p7PyMz8eWPGaU11zRBqvQ+1XxBgoYYY7d+EC17mLndWUdLK/2UWC8saHAs/aHOGB6ZSUMu
	wN1UDHxo3fRoWK1I3pqxXxOj/fl2Ole4MRylQEYNT+S1QSFT2vs/AVBHLh0LfqYZyM9V56wb5Oh
	xiEgIi2ic8aGdn4Z50/gr+/zdrcDf0LhpFH9J0rf+Gn0+yiVhtkWQw==
X-Received: by 2002:a05:6102:334f:b0:786:dfc0:2ece with SMTP id ada2fe7eead31-78a4ab0d88emr9516251137.11.1788801439421;
        Mon, 07 Sep 2026 10:17:19 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:51d3:d0fc:6793:303f? ([2600:1700:6476:1430:51d3:d0fc:6793:303f])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9808ed1dc86sm7633385241.5.2026.09.07.10.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 10:17:18 -0700 (PDT)
Message-ID: <e38d46ab4f54b8622ee13a6d42ad070a9a91f474.camel@dubeyko.com>
Subject: Re: [PATCH v2] nilfs2: remove '#if 0' code blocks
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Joshua Crofts <joshua.crofts1@gmail.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 07 Sep 2026 10:17:17 -0700
In-Reply-To: <CAKFNMo=AHjHpQdzMXtH-TbE-1OFCRmRLaOcSm=87YJYHo2M=EA@mail.gmail.com>
References: <20260907-nilfs2-dead-code-cleanup-v2-1-fa1ab5b0abd6@gmail.com>
	 <CAKFNMo=AHjHpQdzMXtH-TbE-1OFCRmRLaOcSm=87YJYHo2M=EA@mail.gmail.com>
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

On Mon, 2026-09-07 at 17:23 +0900, Ryusuke Konishi wrote:
> On Mon, Sep 7, 2026 at 2:34=E2=80=AFPM Joshua Crofts wrote:
> >=20
> > There are two instances of '#if 0' code blocks that are dead code.
> > Remove these code blocks.
> >=20
> > Additionally, remove a commented out section containing similar
> > code
> > as the '#if 0' block and unnecessary brackets around a single-
> > statement
> > if per checkpatch rules.
> >=20
> > Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
> > ---
> > Changes in v2:
> > - remove block of commented out code (Ryusuke).
>=20
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>=20
> Viacheslav, could you please apply this directly to your tree for the
> next cycle?
>=20
> Thanks,
> Ryusuke Konishi
>=20
> > ---
> > =C2=A0fs/nilfs2/inode.c | 7 -------
> > =C2=A0fs/nilfs2/super.c | 8 ++------
> > =C2=A02 files changed, 2 insertions(+), 13 deletions(-)
> >=20
> > diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> > index 34e6096069ad..778274203f4c 100644
> > --- a/fs/nilfs2/inode.c
> > +++ b/fs/nilfs2/inode.c
> > @@ -342,8 +342,6 @@ struct inode *nilfs_new_inode(struct inode
> > *dir, umode_t mode)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ii->i_flags =3D nilfs_mask_f=
lags(
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 mode, NILFS_I(dir)->i_flags & NILFS_FL_INHERITED);
> >=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* ii->i_file_acl =3D 0; */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* ii->i_dir_acl =3D 0; */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ii->i_dir_start_lookup =3D 0=
;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs_set_inode_flags(inode)=
;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode->i_generation =3D get_=
random_u32();
> > @@ -422,11 +420,6 @@ int nilfs_read_inode_common(struct inode
> > *inode,
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode->i_blocks =3D le64_to_=
cpu(raw_inode->i_blocks);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ii->i_flags =3D le32_to_cpu(=
raw_inode->i_flags);
> > -#if 0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ii->i_file_acl =3D le32_to_cpu(ra=
w_inode->i_file_acl);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ii->i_dir_acl =3D S_ISREG(inode->=
i_mode) ?
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 : le32_to_cpu(raw_inode->i_dir_acl);
> > -#endif
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ii->i_dir_start_lookup =3D 0=
;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode->i_generation =3D le32=
_to_cpu(raw_inode->i_generation);
> >=20
> > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > index 893a504cb80c..89fa6faa34d2 100644
> > --- a/fs/nilfs2/super.c
> > +++ b/fs/nilfs2/super.c
> > @@ -824,13 +824,9 @@ static int nilfs_setup_super(struct
> > super_block *sb, int is_mount)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 max_mnt_count =3D le16_to_cp=
u(sbp[0]->s_max_mnt_count);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mnt_count =3D le16_to_cpu(sb=
p[0]->s_mnt_count);
> >=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (nilfs->ns_mount_state & NILFS=
_ERROR_FS) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (nilfs->ns_mount_state & NILFS=
_ERROR_FS)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 nilfs_warn(sb, "mounting fs with errors");
> > -#if 0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (max_mnt_count >=3D 0 &=
& mnt_count >=3D
> > max_mnt_count) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 nilfs_warn(sb, "maximal mount count reached");
> > -#endif
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!max_mnt_count)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 sbp[0]->s_max_mnt_count =3D
> > cpu_to_le16(NILFS_DFL_MAX_MNT_COUNT);
> >=20
> >=20
> > ---
> > base-commit: 4d7d9486c04d917265f64c55bd23b2cc4fe7749c
> > change-id: 20260905-nilfs2-dead-code-cleanup-cefbe2773172
> >=20
> > Best regards,
> > --
> > Kind regards,
> > Joshua Crofts
> >=20

Applied.

Thanks,
Slava.
