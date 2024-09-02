Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD95219CC03;
	Mon,  2 Sep 2024 19:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725306043; cv=none; b=mo6BQDM2d7wuBGvU/lI5by0fUb5pBCVsCRE71ANLAk55lGbH2zsnA5PV5pniY7kud4WiN4rSJzYLlWVfYB6HI1hwjnOAh1TwNUbTRYIPWMU/R7w8tUmeSEKB5008RV7LGzAXHhzkQDgQMBH2wMY6j09qEvRt9Nw5dWFxMm9TWy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725306043; c=relaxed/simple;
	bh=HnOo/lhyYG30a6WcorZmTIcDTZw4joZ5duCIPOEY1lE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a4CB5/iGDSibgue6xDJ94QopPQ8oAOp/W6qPamchyM4RjN8HnxPIWyI8VqnNbpOeQHreEusjfkx0pKqlZNTveYvRHq5jVLA7k0OeTI/g1wuUWgxLkapuPNriTl24w2exUsSice2/ImZEm+3MZUJj9BjLnyZMIVDs+WhyHw/2Arg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TaudoaM/; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TaudoaM/"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f50966c448so51730211fa.2;
        Mon, 02 Sep 2024 12:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725306039; x=1725910839; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpWpRt3vqUwfo4uZB5tvXqlfhuEFClUtNuDAJ3mY3P8=;
        b=TaudoaM/+ssJydxv/wCKvXkm8NdLHAQyBpIhSkLrhlE4SlgyOoNz3y2V9u2z3kY/XG
         rznWnAbsUfkqbzTSz4Y5bjT6cr6HOeNHXYd4ctKLcfkNRSOJdXxGHmrUtc0SwJXjCMAa
         9bYs1HdtMUdgFUalGgbX7GpFNgyE8ADl3bIH3k/AnLeBcHO51Uhbyi6uNMKZhmXe7FX4
         EkNE0h/iMSekLCK4Wa+S65BZEzrMPkIT4ssRfygM7Qiso/n2HItRj7xoiRjXSKhJM+Op
         S2nngO7fi1fo+v1TQ0/X5XS1PzwQoTUHb30/hsVdPSHH++495KJ097RJlBx3Ad3vsabT
         ihRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725306039; x=1725910839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HpWpRt3vqUwfo4uZB5tvXqlfhuEFClUtNuDAJ3mY3P8=;
        b=pwY5ahUZpyuF4quFPrvcwCoGqTPPE5zOvdQguccRzYGx0EjpFlFihwP/HfVc+otTJA
         FsAmLARJUqNwpTpEmYfuj1xhyM5PH6PF5hHSyqzhPuCRUmadXwzfLyD+VtY+rx50WOUR
         eJAbBuM6t8Q5uXjMQx4Bq0N4xJNNlwrpY0Pa80NI511PJy9S79z1KA+8ZgGaGJMQgVYV
         DG3YXBJKvoj4DKqR99YhHiBsSyMj6Ej/RoNmou2gGhBfWGDZ8FiDLb6LBM3cuN/d+FAo
         LAfnzcJINmDGznEl7b/spM1crT/uY8mjIwgda27cCw8FjzucsfXSRMIK9SsR7qyke01u
         kxdA==
X-Forwarded-Encrypted: i=1; AJvYcCVs/aw4fA4ifpYH01qLDlQhj6XIRobAuOXJo78cB8wGrr6Tdvtna8+tuLUIKyRPvP7hK3GL2+xWX+cCbvs=@vger.kernel.org, AJvYcCWHwLcOQlypBKdQsgrn7SkESm4H3DpqjBV0c3BjiezPZZHO6TFG44mXfjPN1f4QzrOoPG0liyvk4+hU2QI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYLVSpMI2pQ/Gfa2+WDq91NQclTNDgQhRpB7dSqytSqgNKhKIM
	FjW/dP+A7UhMHO8hBJDGEUACylOsD/16hzRjP0QJrPDTYJDL3punMNbUkMAWA8GorZzax7dW7wj
	WzDfKRX3bzYlfrGAxldjXDuXR3SA=
X-Google-Smtp-Source: AGHT+IHvqxlebRz23fBdc7+x4Kxynynh/CzQIlyEUmpae5/E7hDepmKTA1GmE4aPmagGHHDiX+k0jlIfHtrzeik2HdA=
X-Received: by 2002:a05:6512:33ce:b0:52c:d27b:ddcb with SMTP id
 2adb3069b0e04-53546afd60amr7874352e87.3.1725306038019; Mon, 02 Sep 2024
 12:40:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000b4cf9a062114d132@google.com> <20240902084101.138971-1-lizhi.xu@windriver.com>
In-Reply-To: <20240902084101.138971-1-lizhi.xu@windriver.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 3 Sep 2024 04:40:21 +0900
Message-ID: <CAKFNMom+we=aMXZz_f4zVGR6VRO3Zj+y1GC=KZSwLq8MdxO7BQ@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] general protection fault in nilfs_btree_insert (2)
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 5:41=E2=80=AFPM Lizhi Xu wrote:
>
> In nilfs_btree_do_lookup, if the number of children in the btree root nod=
e is 0,
> path[x].bp_bh will not be initialized by __nilfs_btree_get_block,
> which will result in uaf when executing nilfs-btree_get_nonroot_node
> in nilfs_btree_prepare_insert.
>
> In nilfs_bmap_do_insert will run bop_check_insert, so implement
> bop_check_insert and determine the number of children in the btree root
> node within it. If it is 0, return a negative value to avoid calling
> bop_intsert.

Thank you Lizhi for helping us solve this problem.

However, your proposed patch has a few issues (more on that later),
and this anomaly detection should be done when the root node is read,
not just before insertion.  So, instead of adding bop_check_insert, I
will modify the existing sanity check routine
nilfs_btree_root_broken() by adding the following failure condition:

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 862bdf23120e..d390b8ba00d4 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -381,7 +381,8 @@ static int nilfs_btree_root_broken(const struct
nilfs_btree_node *node,
        if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
                     level >=3D NILFS_BTREE_LEVEL_MAX ||
                     nchildren < 0 ||
-                    nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX)) {
+                    nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX ||
+                    (nchildren =3D=3D 0 && level > NILFS_BTREE_LEVEL_NODE_=
MIN))) {
                nilfs_crit(inode->i_sb,
                           "bad btree root (ino=3D%lu): level =3D %d,
flags =3D 0x%x, nchildren =3D %d",
                           inode->i_ino, level, flags, nchildren);

---
Going back to your proposed patch, there are two problems:

(1) nilfs_btree_node_get_nchildren(node) =3D=3D 0 is a normal state in
itself, so it is not OK to return this as an error.

(2) Even if we use bop_check_insert to perform a sanity check, the
error code that should be returned is -EINVAL.
-ENOENT is an internal error code, but if bop_check_insert() returns
it, it may be wrongly exposed to userspace (i.e. system
calls).  If it is -EINVAL, it will be treated as metadata corruption
at the bmap layer with nilfs_bmap_convert_error(), and the error code
will be converted for return to userspace.

So this time I'll be fixing and testing it myself, and will mention
your help in the patch commit log.

Thanks,
Ryusuke Konishi

>
> #syz test
>
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 862bdf23120e..d7fa4d914638 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -1231,6 +1231,17 @@ static void nilfs_btree_commit_insert(struct nilfs=
_bmap *btree,
>                 nilfs_bmap_set_dirty(btree);
>  }
>
> +static int nilfs_btree_check_insert(const struct nilfs_bmap *btree, __u6=
4 key)
> +{
> +       struct nilfs_btree_node *node;
> +       int level;
> +
> +       node =3D nilfs_btree_get_root(btree);
> +       level =3D nilfs_btree_node_get_level(node);
> +       return (level < NILFS_BTREE_LEVEL_NODE_MIN ||
> +               nilfs_btree_node_get_nchildren(node) <=3D 0) ? -ENOENT : =
0;
> +}
> +
>  static int nilfs_btree_insert(struct nilfs_bmap *btree, __u64 key, __u64=
 ptr)
>  {
>         struct nilfs_btree_path *path;
> @@ -2385,7 +2396,7 @@ static const struct nilfs_bmap_operations nilfs_btr=
ee_ops =3D {
>         .bop_seek_key           =3D       nilfs_btree_seek_key,
>         .bop_last_key           =3D       nilfs_btree_last_key,
>
> -       .bop_check_insert       =3D       NULL,
> +       .bop_check_insert       =3D       nilfs_btree_check_insert,
>         .bop_check_delete       =3D       nilfs_btree_check_delete,
>         .bop_gather_data        =3D       nilfs_btree_gather_data,
>  };
