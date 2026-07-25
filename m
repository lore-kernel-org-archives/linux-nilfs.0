Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2772EF66B
	for <linux-nilfs@vger.kernel.org>; Sat, 25 Jul 2026 22:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785018814; cv=pass; b=Dtj03jQxs7Ny927m11iglqk8Ho9oaPFHJUB/dRkUFmLsA5ANT3v7PaIgKcz/XHJHEmJXQjPpeKy0l6oPfPYNJbwy0fVmUabOGEWtilVJYW/mpjCWO8HlpKsYqr222alr8PjEIQepLgKABCOLRnxqJ5zMQC3Jsp++JXD3nxurbZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785018814; c=relaxed/simple;
	bh=hrX/GHPtSW8MahqWAwnwi59WaV6gzxfxpmaCWpKubtw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KPWhWLuBEw55y99Cze+0VfXKt/ARzVjmAp4HRE61cUZBWL4yBvSerrRvRRbbGm1ltATPqq7OVl9siFa819eRHELPH7DRQ7QrtOl0rMHGT2EFu5JLW9kShtFQFN0dHpBhu/yTu5oPbyDNJrN59DZfj8uR0hV7h25I4VYTLUvnWG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oft5Ozh2; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oft5Ozh2"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b2a22c52c1so1756427e87.3
        for <linux-nilfs@vger.kernel.org>; Sat, 25 Jul 2026 15:33:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785018811; cv=none;
        d=google.com; s=arc-20260327;
        b=jKFRFJBYYjkIpLxegDUAlBmQxqmgjMh5d1qOofp6/sAFWKUw8W1u9RU6dsl+2quNim
         jFl0Obp06HIacTwnFcDjMGYABq9gB1Hmb0TyShUvAiTXGukSnEBbi8C7CQGeA9gTYM7h
         gz8wPhjk7M91NNt7jbCjxuqwcSCWeBoXMGfVk5Sc0DUyp5HJGKw2ACQejEniAU6suUih
         58QhIRZtGWVRuvXlUVWPn8rXs6qwvLr5bj9cYelmzSjqTr8YcqgsKNPPDzdiBf3OnjBe
         hxCSqCTKBR3Dm2TK68TK9KJ/diwcQAmps9+iI5NCr1Ti2UhJI7vF2kyKeZkbtyZlyMrS
         N4xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FP8dtM0nBvg/LgTgo8RSUeOidpO9ilyWEJOaeWPTvWo=;
        fh=d3gdp9Zv0HUnxDHzt9Q4uk7AM5tyNocecTb27XlTS7Y=;
        b=PbE0s9mpGtohdB47QxRHXaZTZinqDP3inkdvAnkc7Akd4a9qQ40DJTwlcZ71OYMqXg
         IOcalNvxGUPOHApLdwm5m8WfxT+SWkCEXZJHDPavVvQMAuiVcxA7mR77wxqFJNIiYqDy
         bohjLtzMTz6K9ic5kczFMUfQcTTgIaqfqDxsCCbBnW1N2OZDrlDaBlqm7MYAhz4d+Fvi
         lTabKaMgg6S9/Ost7LnXpcCaVMRdBb7jVn+7njy5gZPU0seoHb0FmqYOaTX5FM4pf2VY
         S3dw1x/ozelNvDzJNURe9P/LTGcaOLB4Y8ZWlIN+7gKgJKRX6KCsD0GZx6BfNX7kg+My
         FFtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785018811; x=1785623611; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FP8dtM0nBvg/LgTgo8RSUeOidpO9ilyWEJOaeWPTvWo=;
        b=Oft5Ozh2acPEBEAjUVltuEq5b7MkHVvzWA+4k+3kqkKaWrjfGny+a7x0wXGDe32BxB
         zMOdI1sAGGo3v0c8k3Sb/WeKbn1PfkCH1yk3/X4SEGaEEaJDyQerqflOhMzZSdpV4C+Q
         /1F5InVq5LGAXXCbhskk7YwK9Jg/nGYaFnL0AceJaCH2PL8OVP7TYLXEoEJZXcm5qRnL
         Ppo5rTPnKLFEB3G3HHBrNpqlIkbqNYxMlBqPB9+zzM2ZLGjy2UuO2dEnjJbRIQ2LW3Xy
         FUUVrWGpkuuBGCK8rjz77SW5aIT43yjxUQ8IvN2voaaCDIbk1SQPmwaAxlVJq4xd2reT
         1NRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785018811; x=1785623611;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FP8dtM0nBvg/LgTgo8RSUeOidpO9ilyWEJOaeWPTvWo=;
        b=O0IT8pzYjDBHlaHcDuVH5gox+o3mHNWA0avCJIGQZv/1XuJlf6FEZnVtqn2KIRODTM
         +SXk6GhB4EfJR1AYg0dhe7xbBW0h/zMGiojmRZSxxlakbB42AWLne9ToBbYB8eB+T0t8
         l+OIHc4iDR6BqLfY+hBJgDwZyQECyRZSteT/uzjOc5MP5XUt1EVM8xyGwUMxDSyKvptm
         1OaDOXpxdDgoKktYHu6/8Pbf23qHopHhG6XiPBlSVliABsEgcMsMZu9jpYs6G7lpbJoh
         Eo1GacUpkI1rAVLUB6Pr3juDb0IKnhMNHAIqxbChI8Hk3f5K9Ogj7L90pW6r+/Ez4wz+
         PN4w==
X-Forwarded-Encrypted: i=1; AHgh+RqE5RV7XIJJUq8LJ0c3/Zl0RsRGfoBo/9u9/ZR0XBfqF664/oG9wUDqE3j3lrK4TO9tTMbXdo33cZ9dJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcX8bWar8w6lqn6G99yjZKYl1xTZ2+iPJSZiIdH1E0X14jXcYZ
	51D83TkskQHQU4weryX8zY/WM4QdYBkkuHGTMUs9zT0dAjbiH3lWNSheyeY/FbOp2+LXzR3wsAg
	OkNEGxixFzjyOGki+TqH5clXpv4uaHsZLxpCZ
X-Gm-Gg: AR+sD11F8VbXUjwheWI/Hi1U5AXShC0b8sr5kfpIruhN1q8eyVjcyKu6ZuwDGbrcdj1
	Fr/1MIsYg/9499SwU8TdVDb6JB5eACCfQMXuDsTjRllgeDwdzJAi0dgFr8mhClbdzFGZ/euSGBW
	pqmCkncv1RbtafH8Xrwm4R29RjwfmkytNbNpmVuKVclYo2vsENJNyRjAa05llfF4ZsfQW7DPl6+
	L9WUHk/5qpL/MLNBZfp5CjcFN7PfzVXeWWN+ZdmxgmcXqmiEaxHOdILZkFuGMI=
X-Received: by 2002:a05:6512:1243:b0:5aa:6f0e:8404 with SMTP id
 2adb3069b0e04-5b2c1b2d3d4mr681704e87.21.1785018810460; Sat, 25 Jul 2026
 15:33:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724222745.2107464-1-slava@dubeyko.com> <20260724222745.2107464-2-slava@dubeyko.com>
In-Reply-To: <20260724222745.2107464-2-slava@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 26 Jul 2026 07:33:08 +0900
X-Gm-Features: AUfX_mzIPrNobk7Go-ZnbDpswNyGJpyERIxr2hvGlO8G1sA6x_EZWM8CLTWHH3g
Message-ID: <CAKFNMok2Op3dAAU8zGWLNPLeh8wj42MgQZbEdP1wSj8jnsO_+Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] nilfs2: add iomap operations for direct I/O reads
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: hch@lst.de, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Viacheslav,

On Sat, Jul 25, 2026 at 7:28=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> Add iomap.c and iomap.h with a read-only nilfs_iomap_ops,
> wrapping the existing nilfs_bmap_lookup_contig() lookup
> to report a mapped range, a real hole, or an EOF-clamped
> range to iomap core.
>
> NILFS2 is a log-structured, copy-on-write filesystem:
> newly allocated blocks are only given a real disk address
> when the segment constructor writes them out as part of a log,
> which walks buffer_head lists directly and is not integrated
> with the generic address_space writeback path. Because of that,
> only the read-only side of the mapping is added - buffered writes,
> writeback, and mmap's ->page_mkwrite() will stay on the existing
> buffer_head based path (nilfs_get_block(), nilfs_write_begin/end(),
> nilfs_writepages(), nilfs_dirty_folio(), block_page_mkwrite()).
>
> Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
> cc: Christoph Hellwig <hch@lst.de>
> cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> cc: linux-nilfs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/nilfs2/Makefile |  2 +-
>  fs/nilfs2/iomap.c  | 71 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/nilfs2/iomap.h  | 13 +++++++++
>  3 files changed, 85 insertions(+), 1 deletion(-)
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
> index 000000000000..3ae3bf6ed368
> --- /dev/null
> +++ b/fs/nilfs2/iomap.c
> @@ -0,0 +1,71 @@
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
> +               iomap->offset =3D offset;
> +               iomap->length =3D min_t(loff_t, length, i_blocksize(inode=
));

After encountering a hole, I think we should use nilfs_bmap_seek_key()
-- as nilfs_mdt_find_block() does for metadata files -- to efficiently
determine its length.

However, if you are short on time, I am fine with the current approach as w=
ell.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi

> +               return 0;
> +       } else if (ret < 0)
> +               return ret;
> +
> +       iomap->bdev =3D inode->i_sb->s_bdev;
> +       iomap->offset =3D offset;
> +       iomap->length =3D min_t(loff_t, length, (loff_t)ret << inode->i_b=
lkbits);
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
