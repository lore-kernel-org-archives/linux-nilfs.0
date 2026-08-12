Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C6D339365
	for <linux-nilfs@vger.kernel.org>; Wed, 12 Aug 2026 22:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786573956; cv=pass; b=i3Rjholhx96P6bURy3TeELy8+S8BE437yzD4Q9/Uymhb/zB8NxFJxDRsMnHprxT950T9HtZJ1dzsf1eg3eYbPeqzaD539qeVQDCuNPc2UvMFr2eCurZG9SOdUFmmb7aw2af2eCQpRDpMgp9F69NuRdR3gPWPnTjWRc3nGvMr+uI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786573956; c=relaxed/simple;
	bh=oSTYv2sVf1bkkoxp97HICf2yboacaRxnJk8a3OFa+/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hf8+EnbPkeMbBs0mMDTjAjtkpqGrGHT2N5Ev0BZ4rHWM9AfULZA6RuHkX8MYzLgv8IB/KUq7XYZoSwplb2dEjsvJYvag01Ghx5NO3omyVfJzOXABpP96FSYby83sKh1Q9+T76jekh9/0eUfxe/tuffWwhUV4tGqnVgW93pl3t8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q8/euR1W; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q8/euR1W"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6688dfaed31so2121973d50.3
        for <linux-nilfs@vger.kernel.org>; Wed, 12 Aug 2026 15:32:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786573954; cv=none;
        d=google.com; s=arc-20260327;
        b=ZcrwXiFSWvzYIptAtlPzFqRsyT07JRGvdzTlmL8RoTYJaqCJh92GTsaVvjQDSSan2z
         V3hZ4W20Enzd0TvVB1hgz0m5BXBmaTiWRa9sp8RbQbexghVxi/m/rQ+GmVaW+pP2/ELK
         dyIL2+euygd0UfahZk3P8jrkuu9E7AGj5ewu9JdxLCLFnDdKZWvCGoIw2CY+1KfMVp42
         1byp9ZcCaKsl4izoQsmmrwWI7FsgQduT7yloaja09KEPyCYzxCRdlOSbVSQQfr0a3MPa
         1GuorsCzk2yhyqsVD/1K8zkJGuI9rcCavC2pejOA/m7kPq/ijN+XdwSFRJ8UVN6N8d77
         YODw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WCRZCWfytLSRScu4X9gBOGJQTnOOUBgQA+JvgLiaPoQ=;
        fh=CI+146yP4Od0EIxVKsz+fiK6YpRiudgtT2IsQEC1F4c=;
        b=WcsdqKzchGcfep+qTV/d8dc0M/ETp+S6PLefjMCDSn66rMAkL1LqHPYdCNvVuNjoFt
         LhYkb8C79gbHjoRYX/yXOobBb7Zg9M6jDsbDl0K6tWMiOnRiSmTJGEAOqIpYwndX64gb
         ql2k0+QpdohM5EoYhtjsiCaAKrlHDsQFvTCudMO0FRZb3CXJZ5QLthD5RSWX2PrnUzws
         G7jNOfy8uDRlS+0ncKdcxm1okKh5b7MnuJmkmNKDW3eZ5sGfZFbUHz4nSkCFu/dB0JI8
         Bcx4E1CUkQyjM9v3sdAuq5abdoktpk1EHGIArjMlfoIAQfUHFGUE3/Z3TXKWM6lxV/ju
         59kg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786573954; x=1787178754; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WCRZCWfytLSRScu4X9gBOGJQTnOOUBgQA+JvgLiaPoQ=;
        b=Q8/euR1WVdXFg84WAyfC63pUk8ziOyfxHAoOjNB6ceMN6P8MSqfva0pYmDzwdv6KAN
         q2xVLx77xY7jYZtNam1ufzHPncyUIvZdL9wT1dEV2CEloN7Rt/w42FtvOi26X12KJ1AQ
         lulnOKYdP/rq219DkWznk8CT2A9l2NWBrjHwcSg1kzrYrNiHkiN5G9slr7LdZAnA3xTO
         Z/EOP9SxTbfxmbyOihv6/g9rrRgwOtFu82t9w9iN7Tsdwdma+azKB1HWuRauKvZxstF4
         xTNAgraLi9nEoleQj4KMekpwWbyvfDFJ+3Q2uVYtOWDtp1585iHShE4AW8dFAiGgEl1k
         4tjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786573954; x=1787178754;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WCRZCWfytLSRScu4X9gBOGJQTnOOUBgQA+JvgLiaPoQ=;
        b=UpaG3bc4nnmioIVGr9RHZ2A0F0dBb0u6uv5sizq0Q+Pwgk1DN9kCGB2DGB2JlJcfaf
         1ZLkIcT5nftF9iOHIqKc5FUsDDQ21KX1TRuuNMxiuFJkYhixdghhH5QbTAR8nKRHDnt1
         QyWDRh88QZrQg69KyF/tMfPH6xAd7wVi+mwK0RLVUBGErYDEblJA3ACTabaYraAntvH6
         b+BOxH1fowibc09FSRWtStzuqb/hoSNAQHiLlW9nks+gAe6l2FszNZyCq+/0wI6IXFvR
         NEpRxZ68+Sb6cczBrS82IpwSAxl17X4lcgE33myOssFsrWFYWQzA/52bykEr8NSWImjA
         qm/A==
X-Forwarded-Encrypted: i=1; AHgh+RoA6HOT1LP7d4MPmvrcVhez4/SF47yB8RmozuVd9pgmnAsj3PJm0OLxntVadpsBckwbC29eqbvFfKtOGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoyW503SlvXSb7vwUSH4ubqI5SjJtJ6cf2aJ/pWIIauuD8rMv9
	XOroO+NRpqdLAqbxqOvqTSpCuISqy9bqB1B/Wv5f15Iw5JpKyKJpgl0KDekAbq1Xi+8ZnCfbuqX
	//DO3vr37673TaorlKwa6bnt35JkUtJQ=
X-Gm-Gg: AR+sD11JFRL0krry5u5Vk9vUu9n/kHY+9OiUEd7EUEQaxPIhO/cuhzrq1wlxCZ5xcxK
	Lp9eYSMymKkqBJ5w8GBE2urcTf9kmrCh4d0Uk5UqY8aMxYCF9lCTRjHJWHYsoozpZIEPpsDteDo
	n0yRmGmE1GSxJHg/hXYPSZjGAtO11SdTUGQsyryJ22SOG8L3p7/f743qAZPlpYlFcJgYrPgRgBG
	4ZCtTJWG4W6KmtRU8lHhqTAjB8KqI+/fzUshsZ0/Mzy/aOC+ayyln9D9Rz+5I431bew66VKObny
	Ouy1ex7zaMNsdgxqMs3ciY6LC13F26iNJaxp57mYUEBM0E4UJEnm8D4g
X-Received: by 2002:a53:e64b:0:b0:664:ed6f:4eb1 with SMTP id
 956f58d0204a3-66c514c0eb9mr559932d50.16.1786573953678; Wed, 12 Aug 2026
 15:32:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812221154.1119137-1-slava@dubeyko.com> <20260812221154.1119137-2-slava@dubeyko.com>
In-Reply-To: <20260812221154.1119137-2-slava@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 13 Aug 2026 07:32:11 +0900
X-Gm-Features: AUfX_mya_MUmAADUdOKOT6nsLUWD2pikTmL2Uj0KJM18LgmJAZGzgjM4bdTMrm4
Message-ID: <CAKFNMokgEToO6Hm=3pVYLA6BFBJfnysK6KmxK4k0=xU1ttGGCw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] nilfs2: add iomap operations for direct I/O
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: hch@lst.de, brauner@kernel.org, linux-nilfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, lilinmao@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 7:12=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> The patch adds iomap.h with declaration of iomaps
> operations and iomap.c with implementation of
> nilfs_iomap_begin(). This method is based on calling
> the nilfs_bmap_lookup_contig() method. It resolves
> the file's block-mapping to find the sequence of
> physically-contiguous blocks starting at starting
> block. Offsets at or beyond i_size are reported
> as a hole. For offsets within i_size, the requested
> length is first clamped to the block-aligned end of the file.
> Both the hole and mapped cases then report iomap->offset
> aligned to the containing block (blkoff << i_blkbits)
> rather than the raw request offset.
>
> Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Co-developed-by: Linmao Li <lilinmao@kylinos.cn>
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> cc: Christoph Hellwig <hch@lst.de>
> cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> cc: linux-nilfs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> ---

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi

>  fs/nilfs2/Makefile |  2 +-
>  fs/nilfs2/iomap.c  | 72 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/iomap.h  | 13 +++++++++
>  3 files changed, 86 insertions(+), 1 deletion(-)
>  create mode 100644 fs/nilfs2/iomap.c
>  create mode 100644 fs/nilfs2/iomap.h
>
> diff --git a/fs/nilfs2/Makefile b/fs/nilfs2/Makefile
> index 43b60b8a4d07..516e6b85a03c 100644
> --- a/fs/nilfs2/Makefile
> +++ b/fs/nilfs2/Makefile
> @@ -3,4 +3,4 @@ obj-$(CONFIG_NILFS2_FS) +=3D nilfs2.o
>  nilfs2-y :=3D inode.o file.o dir.o super.o namei.o page.o mdt.o \
>         btnode.o bmap.o btree.o direct.o dat.o recovery.o \
>         the_nilfs.o segbuf.o segment.o cpfile.o sufile.o \
> -       ifile.o alloc.o gcinode.o ioctl.o sysfs.o
> +       ifile.o alloc.o gcinode.o ioctl.o sysfs.o iomap.o
> diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
> new file mode 100644
> index 000000000000..e130ed63abd9
> --- /dev/null
> +++ b/fs/nilfs2/iomap.c
> @@ -0,0 +1,72 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * NILFS iomap support implementation.
> + *
> + * Written by Viacheslav Dubeyko.
> + */
> +
> +#include <linux/iomap.h>
> +#include <linux/pagemap.h>
> +#include "nilfs.h"
> +#include "mdt.h"
> +#include "iomap.h"
> +
> +static int nilfs_iomap_begin(struct inode *inode, loff_t offset,
> +                            loff_t length, unsigned int flags,
> +                            struct iomap *iomap, struct iomap *srcmap)
> +{
> +       struct the_nilfs *nilfs =3D inode->i_sb->s_fs_info;
> +       struct nilfs_inode_info *ii =3D NILFS_I(inode);
> +       sector_t blkoff =3D offset >> inode->i_blkbits;
> +       loff_t iomap_offset =3D (loff_t)blkoff << inode->i_blkbits;
> +       unsigned int maxblocks;
> +       __u64 blknum =3D 0;
> +       int ret;
> +
> +       /* Completely beyond EOF. Treat as hole */
> +       if (i_size_read(inode) <=3D offset) {
> +               iomap->type =3D IOMAP_HOLE;
> +               iomap->addr =3D IOMAP_NULL_ADDR;
> +               iomap->offset =3D offset;
> +               iomap->length =3D length;
> +               return 0;
> +       }
> +
> +       /* Clamp length if the requested range goes beyond i_size */
> +       if (offset + length > i_size_read(inode)) {
> +               loff_t i_size =3D i_size_read(inode);
> +               unsigned int blocksize =3D i_blocksize(inode);
> +
> +               length =3D round_up(i_size, blocksize) - offset;
> +       }
> +
> +       maxblocks =3D min_t(loff_t, length >> inode->i_blkbits, INT_MAX);
> +       if (maxblocks =3D=3D 0)
> +               maxblocks =3D 1;
> +
> +       down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
> +       ret =3D nilfs_bmap_lookup_contig(ii->i_bmap, blkoff, &blknum, max=
blocks);
> +       up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
> +
> +       if (ret =3D=3D -ENOENT) {
> +               iomap->type =3D IOMAP_HOLE;
> +               iomap->addr =3D IOMAP_NULL_ADDR;
> +               iomap->offset =3D iomap_offset;
> +               iomap->length =3D i_blocksize(inode);
> +               return 0;
> +       } else if (ret < 0)
> +               return ret;
> +
> +       iomap->bdev =3D inode->i_sb->s_bdev;
> +       iomap->offset =3D iomap_offset;
> +       iomap->length =3D (loff_t)ret << inode->i_blkbits;
> +       iomap->addr =3D (loff_t)blknum << inode->i_blkbits;
> +       iomap->type =3D IOMAP_MAPPED;
> +       iomap->flags =3D IOMAP_F_MERGED;
> +
> +       return 0;
> +}
> +
> +const struct iomap_ops nilfs_iomap_ops =3D {
> +       .iomap_begin =3D nilfs_iomap_begin,
> +};
> diff --git a/fs/nilfs2/iomap.h b/fs/nilfs2/iomap.h
> new file mode 100644
> index 000000000000..adef3e22346d
> --- /dev/null
> +++ b/fs/nilfs2/iomap.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * NILFS iomap support declarations.
> + *
> + * Written by Viacheslav Dubeyko.
> + */
> +
> +#ifndef _NILFS_IOMAP_H
> +#define _NILFS_IOMAP_H
> +
> +extern const struct iomap_ops nilfs_iomap_ops;
> +
> +#endif /* _NILFS_IOMAP_H */
> --
> 2.43.0
>
