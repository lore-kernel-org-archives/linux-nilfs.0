Received: from mail-yw1-f196.google.com (mail-yw1-f196.google.com [209.85.128.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E6942A168
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 23:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785281835; cv=none; b=R0WziCKvI5DY0/pYCyiVxcC4WHS4ae7j2xphm0HSSUHqhTm04ZjH5C6S1zhQrBELWKm2y++M4Op3pwOSYCGlOmg4AETv51bN5lqWDlIPaFmDBJtuM01DRrNRo+EfBV+wcEu7n1O4PA7IHRpCE5QvCbxIMVJMXqRewiyQt9aMDmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785281835; c=relaxed/simple;
	bh=1US1qTxq9GmHJYcthOuH2cKs+4JHXH/iWKgPtMjjsWc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L4+LoC347ot0HOGDPrdJg142OmpmuufzCKAAi7qx57RuS1p7Enuc6ah6gULOP1V8Imqdq0ympCKgcVxYeAL82pjM5rVzh0l47o6mYeBm7k2SiaCGdtKNSbO5WHyTQmos1KT35KHu1moYm+Pdjxg2e8L2dB263qIvxafnKDPTzdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=ntTxET0T; arc=none smtp.client-ip=209.85.128.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="ntTxET0T"
Received: by mail-yw1-f196.google.com with SMTP id 00721157ae682-81e6f2ee60bso19658217b3.1
        for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 16:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1785281831; x=1785886631; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SRaujrMbpywtr1dUYva+1n03tcFwppXIya1Llu+1I/U=;
        b=ntTxET0TOf5SljKVLg6dMwCLY2Ey+A2iSTlcrXDltoN7fv/sCnTwYBs2RPW3aNsOh3
         g/YrS52X/9UjLFxihSArgaDpsOd4tPGs6dQ+M/7pN8ov37i7eeJtPFyl6X5JweZR9+Da
         YqAEV5gcBTM5eE0qJxosHKNYQG4ZptHRjMOJT8EyXPKiX59fvZlPoCffKMMg1wJqMHyb
         01OiKjWCVGoa/T9Ov+g+0WzWXvsAx93Dfc8UBjh3lDV8rPWxhBQcqNIAbGPhgpw5gIA/
         4sC9+SmFR7wprMoG+5dP+CdiFp8sZhgUHVTUA6GJ0WyC7cMI5j9UzhEYq4Ef69JHMBSC
         gRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785281831; x=1785886631;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SRaujrMbpywtr1dUYva+1n03tcFwppXIya1Llu+1I/U=;
        b=A7OfU9+wH/PrDo0my52ta1vIc9S7SaQPXv9KZ3n2CIvK13jPgSZok+PVsozG93+tR9
         pKsdodIwelNNlOMyODifAwrXVk0HqeCu99TACniv3DhfOUfULBhjhAK+1R3lL/BaKAyH
         fzM8AS1ebATdynRhfl7PrMSRZr6Q8M5p4SmPeUu3gfAiNZ9hNrZmCyPNVA8HlVCX0AE5
         rfEu/Z7IB/9tgM8ckWfZMBHiSw/ci4PlTXIsLoStEzBIyaCzYSpt/sVwoFxS0iWkIm/I
         AT/3xwIV1wxjDXxogDcx5e+l9nE7/6GwyR6gt5785x+uMhCCAuGlqnADMZ22YwZT+5Td
         6i5A==
X-Gm-Message-State: AOJu0Yyi4WmHY/FfogqCU/WkISXD9oik/hYHbnsua5ONSEoKCbZ4G6z+
	LoZlIQ//GFHoXaE3SRpNjVY2hBKMwt9gI9gVUGizbbhIiDO/tXGoLuTeRbxJlXcVEeXKTxLyJNd
	drB80ELWH2WK5154=
X-Gm-Gg: AR+sD12t/yBiv1Dl0hHSWq7NmpIRNjjF6DFfkkWiXo9/jHVqVc6Re1lzoe0wMerBoG7
	WXKBWl4UzxcvyO4kFVAeRpVau+CMB8UuJjPwgcSeY62qjcPB8Qc2nxRUESZkHcO2Gs+lTK0iOFo
	F5IdcLJ661UOolT3b/d4ddnLg6jc6kWNf8LA1jGdyl9ySsMow0tV17V0d2FtToAsLQFdjF6971H
	1Z00Y/3pUDxOZFbxe8cVhdY20xXLKd45rbFyJCyYL7lvfZQLXltHcneoAPUmLxV1PhQoJizjNUT
	YdyelP0k/TvliifRZFXU1Ga7KPsj0mo9FpCUbuSuhmtYJx6+boGuNluno9Kb0Uud8JI7hEHi+x+
	y/bd+MVHi3wX544aJHr18aJ1uiOYtPZDcDnFNBAagzY+HD4FJHV4vfR/fmctpg7W4U6Pc2Vpyeu
	dJfl8LwsmtNURDOSuXhrd/ebdXGE1YjUa5TrR87SE6POSuOc8sdnl1HjGd1w0KBoFl2X3ZRBQ3u
	84+lXHvIl6bHT72P6y5oEJR58VVZe5sUS02zCGapGVB9mqQ9EiQSGs+1yZ2PP4Cp3GUB+Lz00Zv
	5tgCgfsVkknVGNGNTjdbZyA7VOTTB9YagK2pKrUKYzF6K+5B2JmXfu4=
X-Received: by 2002:a05:690c:16:b0:81e:ba92:b253 with SMTP id 00721157ae682-81fa793a33bmr275397b3.4.1785281830719;
        Tue, 28 Jul 2026 16:37:10 -0700 (PDT)
Received: from [10.0.0.3] (162-197-212-70.lightspeed.sntcca.sbcglobal.net. [162.197.212.70])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fa27985cbsm8025017b3.16.2026.07.28.16.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:37:09 -0700 (PDT)
Message-ID: <33a0a3a470941138238e9f0dae537dece1406fc5.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: fix slab-out-of-bounds in
 nilfs_direct_propagate after truncation
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML	
 <linux-kernel@vger.kernel.org>, Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Date: Tue, 28 Jul 2026 16:37:05 -0700
In-Reply-To: <20260717044045.137808-1-konishi.ryusuke@gmail.com>
References: <20260717044045.137808-1-konishi.ryusuke@gmail.com>
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

On Fri, 2026-07-17 at 13:39 +0900, Ryusuke Konishi wrote:
> Shuangpeng Bai reported that KASAN detected a slab-out-of-bounds
> error
> in nilfs_direct_propagate() during testing.
>=20
> Analysis revealed that after truncating a file, a node block
> immediately
> below the B-tree root was not deleted.=C2=A0 Instead, it remained in the
> B-tree
> node cache in a dirty state.=C2=A0 The log writer subsequently detected
> this
> block and incorrectly invoked nilfs_direct_propagate() on it, which
> is
> designed to handle only data blocks in direct mapping.
>=20
> B-tree nodes in the cache are managed by virtual block numbers, and
> their
> logical keys typically exceed the range expected by direct mapping.
> Consequently, processing such a node as a direct mapping entry
> triggers
> a slab-out-of-bounds access.
>=20
> The root cause is that when a B-tree mapping collapses into a direct
> mapping during truncation, an intermediate node block pointed to by
> the
> root node is left behind as garbage instead of being explicitly
> deleted.
>=20
> This resolves the issue by adding a nilfs_btree_discard() operation
> to delete the remaining intermediate node block during the
> conversion.
> A 'deform' flag is added to the bop_delete interface to explicitly
> signal
> that the deletion is part of a mapping transformation.=C2=A0 This allows
> the
> B-tree mapping implementation to perform the necessary cleanup and
> discarding of the residual node structure that would be otherwise be
> left
> orphaned after the transition.
>=20
> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> Closes:
> https://lore.kernel.org/r/08A3603A-ADB6-484C-9015-9AC1340E6FB8@gmail.com
> Fixes: 36a580eb489f ("nilfs2: direct block mapping")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please apply this for the next cycle.
>=20
> This fixes a flaw in the original B-tree implementation related to
> truncation
> and resolves the reported out-of-bounds memory access issue.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/bmap.c=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0fs/nilfs2/bmap.h=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0fs/nilfs2/btree.c=C2=A0 | 39 ++++++++++++++++++++++++++++++++------=
-
> =C2=A0fs/nilfs2/direct.c |=C2=A0 4 ++--
> =C2=A04 files changed, 36 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
> index 5f0f1f283af0..83f6ea30cc8b 100644
> --- a/fs/nilfs2/bmap.c
> +++ b/fs/nilfs2/bmap.c
> @@ -175,7 +175,7 @@ static int nilfs_bmap_do_delete(struct nilfs_bmap
> *bmap, __u64 key)
> =C2=A0			return ret;
> =C2=A0	}
> =C2=A0
> -	return bmap->b_ops->bop_delete(bmap, key);
> +	return bmap->b_ops->bop_delete(bmap, key, false);
> =C2=A0}
> =C2=A0
> =C2=A0/**
> diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
> index 4656df392722..a72f3c308a5d 100644
> --- a/fs/nilfs2/bmap.h
> +++ b/fs/nilfs2/bmap.h
> @@ -63,7 +63,7 @@ struct nilfs_bmap_operations {
> =C2=A0	int (*bop_lookup_contig)(const struct nilfs_bmap *, __u64,
> __u64 *,
> =C2=A0				 unsigned int);
> =C2=A0	int (*bop_insert)(struct nilfs_bmap *, __u64, __u64);
> -	int (*bop_delete)(struct nilfs_bmap *, __u64);
> +	int (*bop_delete)(struct nilfs_bmap *bmap, __u64 key, bool
> deform);
> =C2=A0	void (*bop_clear)(struct nilfs_bmap *);
> =C2=A0
> =C2=A0	int (*bop_propagate)(struct nilfs_bmap *, struct buffer_head
> *);
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 64d5f7c5ab44..64bac66af25b 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -1425,6 +1425,28 @@ static void nilfs_btree_shrink(struct
> nilfs_bmap *btree,
> =C2=A0	path[level].bp_bh =3D NULL;
> =C2=A0}
> =C2=A0
> +/**
> + * nilfs_btree_discard - discard the last node for the mapping
> transformation
> + * @btree: bmap struct of btree
> + * @path: array of nilfs_btree_path struct
> + * @level: level of the B-tree node being operated on
> + * @keyp: argument for passing a key (unused)
> + * @ptrp: argument for passing a pointer (unused)
> + */
> +static void nilfs_btree_discard(struct nilfs_bmap *btree,
> +				struct nilfs_btree_path *path, int
> level,
> +				__u64 *keyp, __u64 *ptrp)
> +{
> +	struct nilfs_btree_node *root =3D nilfs_btree_get_root(btree);
> +
> +	nilfs_btree_node_delete(root, 0, NULL, NULL,
> +				NILFS_BTREE_ROOT_NCHILDREN_MAX);
> +	nilfs_btree_node_set_level(root, level);
> +
> +	nilfs_btnode_delete(path[level].bp_bh);
> +	path[level].bp_bh =3D NULL;
> +}
> +
> =C2=A0static void nilfs_btree_nop(struct nilfs_bmap *btree,
> =C2=A0			=C2=A0=C2=A0=C2=A0 struct nilfs_btree_path *path,
> =C2=A0			=C2=A0=C2=A0=C2=A0 int level, __u64 *keyp, __u64 *ptrp)
> @@ -1435,7 +1457,7 @@ static int nilfs_btree_prepare_delete(struct
> nilfs_bmap *btree,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct nilfs_btree_path *path,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int *levelp,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct nilfs_bmap_stats
> *stats,
> -				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *dat)
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *dat, bool
> deform)
> =C2=A0{
> =C2=A0	struct buffer_head *bh;
> =C2=A0	struct nilfs_btree_node *node, *parent, *sib;
> @@ -1522,15 +1544,17 @@ static int nilfs_btree_prepare_delete(struct
> nilfs_bmap *btree,
> =C2=A0			if (nilfs_btree_node_get_nchildren(node) - 1
> <=3D
> =C2=A0			=C2=A0=C2=A0=C2=A0 NILFS_BTREE_ROOT_NCHILDREN_MAX) {
> =C2=A0				path[level].bp_op =3D
> nilfs_btree_shrink;
> -				stats->bs_nblocks +=3D 2;
> -				level++;
> -				path[level].bp_op =3D nilfs_btree_nop;
> -				goto shrink_root_child;
> +			} else if (deform) {
> +				path[level].bp_op =3D
> nilfs_btree_discard;
> =C2=A0			} else {
> =C2=A0				path[level].bp_op =3D
> nilfs_btree_do_delete;
> =C2=A0				stats->bs_nblocks++;
> =C2=A0				goto out;
> =C2=A0			}
> +			stats->bs_nblocks +=3D 2;
> +			level++;
> +			path[level].bp_op =3D nilfs_btree_nop;
> +			goto shrink_root_child;
> =C2=A0		}
> =C2=A0	}
> =C2=A0
> @@ -1581,7 +1605,7 @@ static void nilfs_btree_commit_delete(struct
> nilfs_bmap *btree,
> =C2=A0		nilfs_bmap_set_dirty(btree);
> =C2=A0}
> =C2=A0
> -static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key)
> +static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key,
> bool deform)
> =C2=A0
> =C2=A0{
> =C2=A0	struct nilfs_btree_path *path;
> @@ -1601,7 +1625,8 @@ static int nilfs_btree_delete(struct nilfs_bmap
> *btree, __u64 key)
> =C2=A0
> =C2=A0	dat =3D NILFS_BMAP_USE_VBN(btree) ? nilfs_bmap_get_dat(btree)
> : NULL;
> =C2=A0
> -	ret =3D nilfs_btree_prepare_delete(btree, path, &level,
> &stats, dat);
> +	ret =3D nilfs_btree_prepare_delete(btree, path, &level,
> &stats, dat,
> +			deform);
> =C2=A0	if (ret < 0)
> =C2=A0		goto out;
> =C2=A0	nilfs_btree_commit_delete(btree, path, level, dat);
> diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
> index 8bd0b1374e25..b8643d3aa2f8 100644
> --- a/fs/nilfs2/direct.c
> +++ b/fs/nilfs2/direct.c
> @@ -144,7 +144,7 @@ static int nilfs_direct_insert(struct nilfs_bmap
> *bmap, __u64 key, __u64 ptr)
> =C2=A0	return ret;
> =C2=A0}
> =C2=A0
> -static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key)
> +static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key,
> bool deform)
> =C2=A0{
> =C2=A0	union nilfs_bmap_ptr_req req;
> =C2=A0	struct inode *dat;
> @@ -234,7 +234,7 @@ int nilfs_direct_delete_and_convert(struct
> nilfs_bmap *bmap,
> =C2=A0	/* no need to allocate any resource for conversion */
> =C2=A0
> =C2=A0	/* delete */
> -	ret =3D bmap->b_ops->bop_delete(bmap, key);
> +	ret =3D bmap->b_ops->bop_delete(bmap, key, true);
> =C2=A0	if (ret < 0)
> =C2=A0		return ret;
> =C2=A0

Applied.

Thanks,
Slava.
