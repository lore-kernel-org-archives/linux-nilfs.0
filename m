Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A61200110
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 00:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785199567; cv=none; b=Vcd8ZJ/KftQzdfuOw7npu9pJLv6arbijf2J4wEzkYEchJ9mgsUW9lvQ9SUsnGLADBPRrrioAFuxzINc5at9zwjmAMZe/P0/SPlisMfzzwPHXnFuGw32SG4urhaNNfr8u29yad6NpsIir+h7tHkG0H567iOOU9OFSROKil7G1lFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785199567; c=relaxed/simple;
	bh=3Ky5jrsDcGX7zuXSAqk3cHvj0f6WkOjzrywJuCL9AVc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JtVdVYYipj6yyHj1ltaI5Wh0AnNOEnKbBMXPiD/W4U+1kPRvXd7rfiA+YjNOJoxba+uUiF2vcz9bw68cMgG34OV+LJ/EilfGeo+HoTT5WFGX2pMcJPpIe6xdWJ8i3rP5Xo7+5DCsTLDWaiT1QujyKJSwYooAjjYH+wt6TJGF2y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=Krf+qLtw; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="Krf+qLtw"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7ff05e5d009so34429027b3.1
        for <linux-nilfs@vger.kernel.org>; Mon, 27 Jul 2026 17:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1785199564; x=1785804364; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Ky5jrsDcGX7zuXSAqk3cHvj0f6WkOjzrywJuCL9AVc=;
        b=Krf+qLtwgD7M1JtWaws70QizEod2p7MLDtvwM6xtzJuE0fBkcvlOwhEOBwiraukRkd
         HlkFm6z2pvVUfQXMjVg8Knq5c7cZHzaxjbwV2oa726GqZqbf+cfC27l05WPsKiB6Vrhe
         4+dGmQ6dgkJ8it0f+vNC/RYHS+VLbQSTBuFahzbu3jKkneUYgSwf/nun7Ir6tlX5HTmw
         ThRwJVw4jo4bN4lD73w6aT6B0CAxSe0y9ijMs8Gn5y6PEMPZC2NUiTC1S/CTuNFslICe
         OPPUNTfAcPUGpfLa95s6IIVWzwE6uzalWAsNQOcGNoqlBPMTN6ASefIIlqXAA62Ba+sV
         0y1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785199564; x=1785804364;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3Ky5jrsDcGX7zuXSAqk3cHvj0f6WkOjzrywJuCL9AVc=;
        b=CoHFCk883z5lFHN7Yhdg5BoCS9LnNM4t7tPCYy/KseRDLfqAkvcuAoA98x7M+ZNJ+5
         PgbsSb3Kz4KmiXZHqnwILwbgNPRfui3s9oEtAgeWIRDp+GUdAqokX4v2Z95UNTMlfCR/
         shEfPweRNKSwSmG2gklYkx/eDpid6B45xyJnnmHKc9mm0ta1zk6wbDBY7I8vPPjklyfW
         pWS1/MqUHrZUCiRl13YX1IGcdT3KEnK2fwQJuVZJpJFnxhV5c96DO7h7lMRQD91R3/fP
         W06usUaLoEEBiTQaIJPnwdLqXvVx7L9vELxsnMDmyIuOip6ZSl9dTDqcTrhLx8ST/5LF
         VbDA==
X-Forwarded-Encrypted: i=1; AHgh+RrcDsX66seewsL/2M9LiVOmzJrBpppo8bIbMvNK49GsF0zXHMDh5lmnJUpljRXMQjm4LmWqSOHaaYmnrw==@vger.kernel.org
X-Gm-Message-State: AOJu0YylJmrMwjWEn7FXV8rMpj44D0Wx4Q6lg3gFas2vCuxlT5zE927I
	9KihPfr23ZGbrUwk0T4Ro8B2QbcuAr22yaYDgbVJadT7mKIXCuwfMTJ+lh0+4pN9PeY=
X-Gm-Gg: AR+sD12m5JHqjmUjI43dqUqeGjAkSPhjo1Xx3xSPTKsiKLcTODKmH2l5MwdCAQG71l/
	9cECdTHF5iujDwzgGrEnC3JRU3Lr+lJEKH25Bj4rhHLd5ekBDQ5c1WNrk2dJBCAsFBD2Sg9bHZW
	9QpOYAKS+Oaxb+CtLT/zva9AIepu1KcuCyaK7xdesn+yAddzwKaP6pO1zGCYajCwBnPt0LFHepy
	BzN39jqR2MXw58+HTVG4ScpJcnpM6wG3720jbM+HnGw43Nij0lqe5gGdNa58xn6ntXaGiCWZz8k
	OYJYtThj2Zgm0zjrBlegoxwFJqyzCuHEvTtcL73YTgc8EHS1h5BnnQ2wp/odAGboPPrPjK0dHsF
	R4wXPp/eLxMTSsgiHPUztRU2vs4sX+mu4FCJvkhReJ4EXLcO+XbUk6Ys0sEuPCsF6a+MRpQdczZ
	Ka6cLHBGyzEvp76QE5fKDBZPAPTWTMonkW37jvmcQ0l378SxEU7df1AMB2pQWXx+2yuEXxJaHPc
	KKuyOM0OBgcCOumFhZjNg8c0OmrrdHOvA==
X-Received: by 2002:a05:690c:4b0b:b0:7db:ccda:a409 with SMTP id 00721157ae682-81f991858eemr729237b3.9.1785199564339;
        Mon, 27 Jul 2026 17:46:04 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:273a:c0af:6af:54a7])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f657a14d9sm40034897b3.13.2026.07.27.17.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 17:46:02 -0700 (PDT)
Message-ID: <81011aff679fbb673a35a4b049f65b59eed7a233.camel@dubeyko.com>
Subject: Re: [PATCH 1/2] nilfs2: add iomap operations for direct I/O reads
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: hch@lst.de, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Mon, 27 Jul 2026 17:46:00 -0700
In-Reply-To: <CAKFNMok2Op3dAAU8zGWLNPLeh8wj42MgQZbEdP1wSj8jnsO_+Q@mail.gmail.com>
References: <20260724222745.2107464-1-slava@dubeyko.com>
	 <20260724222745.2107464-2-slava@dubeyko.com>
	 <CAKFNMok2Op3dAAU8zGWLNPLeh8wj42MgQZbEdP1wSj8jnsO_+Q@mail.gmail.com>
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

Hi Ryusuke,

On Sun, 2026-07-26 at 07:33 +0900, Ryusuke Konishi wrote:
> Hi Viacheslav,
>=20
> On Sat, Jul 25, 2026 at 7:28=E2=80=AFAM Viacheslav Dubeyko wrote:
> >=20
> > Add iomap.c and iomap.h with a read-only nilfs_iomap_ops,
> > wrapping the existing nilfs_bmap_lookup_contig() lookup
> > to report a mapped range, a real hole, or an EOF-clamped
> > range to iomap core.
> >=20
> > NILFS2 is a log-structured, copy-on-write filesystem:
> > newly allocated blocks are only given a real disk address
> > when the segment constructor writes them out as part of a log,
> > which walks buffer_head lists directly and is not integrated
> > with the generic address_space writeback path. Because of that,
> > only the read-only side of the mapping is added - buffered writes,
> > writeback, and mmap's ->page_mkwrite() will stay on the existing
> > buffer_head based path (nilfs_get_block(), nilfs_write_begin/end(),
> > nilfs_writepages(), nilfs_dirty_folio(), block_page_mkwrite()).
> >=20
> > Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
> > cc: Christoph Hellwig <hch@lst.de>
> > cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> > cc: linux-nilfs@vger.kernel.org
> > cc: linux-fsdevel@vger.kernel.org
> > ---
> > =C2=A0fs/nilfs2/Makefile |=C2=A0 2 +-
> > =C2=A0fs/nilfs2/iomap.c=C2=A0 | 71
> > ++++++++++++++++++++++++++++++++++++++++++++++
> > =C2=A0fs/nilfs2/iomap.h=C2=A0 | 13 +++++++++
> > =C2=A03 files changed, 85 insertions(+), 1 deletion(-)
> > =C2=A0create mode 100644 fs/nilfs2/iomap.c
> > =C2=A0create mode 100644 fs/nilfs2/iomap.h
> >=20
> > diff --git a/fs/nilfs2/Makefile b/fs/nilfs2/Makefile
> > index 43b60b8a4d07..516e6b85a03c 100644
> > --- a/fs/nilfs2/Makefile
> > +++ b/fs/nilfs2/Makefile
> > @@ -3,4 +3,4 @@ obj-$(CONFIG_NILFS2_FS) +=3D nilfs2.o
> > =C2=A0nilfs2-y :=3D inode.o file.o dir.o super.o namei.o page.o mdt.o \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btnode.o bmap.o btree.o dire=
ct.o dat.o recovery.o \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 the_nilfs.o segbuf.o segment=
.o cpfile.o sufile.o \
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ifile.o alloc.o gcinode.o ioctl.o=
 sysfs.o
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ifile.o alloc.o gcinode.o ioctl.o=
 sysfs.o iomap.o
> > diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
> > new file mode 100644
> > index 000000000000..3ae3bf6ed368
> > --- /dev/null
> > +++ b/fs/nilfs2/iomap.c
> > @@ -0,0 +1,71 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * NILFS iomap support implementation.
> > + *
> > + * Written by Viacheslav Dubeyko.
> > + */
> > +
> > +#include <linux/iomap.h>
> > +#include <linux/pagemap.h>
> > +#include "nilfs.h"
> > +#include "mdt.h"
> > +#include "iomap.h"
> > +
> > +static int nilfs_iomap_begin(struct inode *inode, loff_t offset,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 loff_t length, unsigned int flags,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 struct iomap *iomap, struct iomap
> > *srcmap)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct the_nilfs *nilfs =3D inode=
->i_sb->s_fs_info;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct nilfs_inode_info *ii =3D N=
ILFS_I(inode);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sector_t blkoff =3D offset >> ino=
de->i_blkbits;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int maxblocks;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u64 blknum =3D 0;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Completely beyond EOF. Treat a=
s hole */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (i_size_read(inode) <=3D offse=
t) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->type =3D IOMAP_HOLE;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->addr =3D IOMAP_NULL_ADDR;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->offset =3D offset;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->length =3D length;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return 0;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Clamp length if the requested =
range goes beyond i_size
> > */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (offset + length > i_size_read=
(inode)) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 loff_t i_size =3D i_size_read(inode);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 unsigned int blocksize =3D i_blocksize(inode);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 length =3D round_up(i_size, blocksize) - offset;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 maxblocks =3D min_t(loff_t, lengt=
h >> inode->i_blkbits,
> > INT_MAX);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (maxblocks =3D=3D 0)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 maxblocks =3D 1;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 down_read(&NILFS_MDT(nilfs->ns_da=
t)->mi_sem);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D nilfs_bmap_lookup_contig(=
ii->i_bmap, blkoff, &blknum,
> > maxblocks);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up_read(&NILFS_MDT(nilfs->ns_dat)=
->mi_sem);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -ENOENT) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->type =3D IOMAP_HOLE;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->addr =3D IOMAP_NULL_ADDR;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->offset =3D offset;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iomap->length =3D min_t(loff_t, length,
> > i_blocksize(inode));
>=20
> After encountering a hole, I think we should use
> nilfs_bmap_seek_key()
> -- as nilfs_mdt_find_block() does for metadata files -- to
> efficiently
> determine its length.
>=20
> However, if you are short on time, I am fine with the current
> approach as well.

I think we can rework it later. I am starting a new job today and I am
attending FMS 2026 next week. So, I am expecting to be really busy at
minimum two weeks (probably, slightly more). So, let's keep it as TODO.
Please, remind me to rework it later. :)

Thanks,
Slava.

