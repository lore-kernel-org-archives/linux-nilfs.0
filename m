Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664EF1B14E9
	for <linux-nilfs@vger.kernel.org>; Wed, 14 Aug 2024 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723643862; cv=none; b=rlpnS9nPx2HyGlWNx/fGP8ULaB8ISId7cZD6eZjr7w57hLkQmeCEY4yTo17HKtL4mCNsbV+tw6bLeEzi4Q5I8/aSLsylxlqkOPRqrZsF48k7ly5plyFVw6N6HzDIe9IR7C9lLSe3KNVxsK7+kZTEqhUoBWIapkHG3/n/0S8JyfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723643862; c=relaxed/simple;
	bh=3IQaLEnt7lnsX2grYZ8r42Tav5k7h3dFV62HKasC9xs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GLauGN/zeOSqHOQo3Us6jbJX5aqR9MMQO/8m3Qt2eYLRF5/4ZUwxP5wjiukgoN9r3OBC/Gt7YEmo1mUvxAsY2GKY5XbNJSvy8C5ab9OEgfYINB/mZlO41sz1zpe1fi/ejC4bngkq0jGFXDRQgGcs4X1zDzoTgReqNm7JiMtvSsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k6uBTiU7; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k6uBTiU7"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ef248ab2aeso103958711fa.0
        for <linux-nilfs@vger.kernel.org>; Wed, 14 Aug 2024 06:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723643858; x=1724248658; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQFM7vp13y5h0+3Fc2fPuVEq/HHaT3w99SOzauWQDFo=;
        b=k6uBTiU7uNyLnAah0+Vc6I82kMutP4xz5ypK1/0lilMuIa2I7qe7vU/VVUh0XJh8SB
         DytL0jB8G/5uaOlsEGdXMZgGY6CTrh46KCZQmUPUBGRDqqclAT9Y/AXXOSOQCMGK/yIa
         mqgIj/5mqhGuVQF4hMSGoQIB4Ps268HoRsRj0yjpJBothPyJGarLOZUiWcBMY87Mh0CE
         9q8mhNzw5Cgg5K3O6LroyHvQNZIAA8ethaPm1x/jRar9rrWlXqwi9hsXJyM9GRYFwe1o
         Q7lsTl6XLTbj05c9iEXCID/133smQA+nmp7hlmErUM4zYXtPq1OK75KGsc0fWWPbwrQC
         nG3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723643858; x=1724248658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQFM7vp13y5h0+3Fc2fPuVEq/HHaT3w99SOzauWQDFo=;
        b=EIw/5sellSUVo7SRo9CUaUiiSG1rYvOOp8iZyFwJcRtyRADmNEvQEH5T1Xe8mv+Bwt
         X/DY0pDHeS3wyG3ZN+JrMYczqCXyWmzMDmcryd43yGKZxdv8CBQj+Vi5az4qhp+yPnpW
         eE6+ryhjR4uEXXnDQluf+yoMSqIKhBfvaqU5e697zg/eJx1YBOi8vIzE+5ISPSQUUt0D
         I6ZQ6eSJAVPexlmI3uUyD19VEt2DwEHCWGJvj0I2m6eDbtbCGGbMNturokKKHodk5Odp
         X04cVbwhwy3Z9C9wCeCAcyadvlEzKbS2FiCrDYFrVQcYH2kmeS25Ugm99sqSFfliQUv6
         QMnA==
X-Forwarded-Encrypted: i=1; AJvYcCVxQYKJv0hlbtFx16F4AO+PLH/zUy085frfWmdlvEYZpihx8Yn1+tlXRmupE51ZTEdDHegcJhVki7NrlrrVOZ1DyJGcc7WnwEr+gJ8=
X-Gm-Message-State: AOJu0YxYe81u788nvy1FyUdy63hni6c1svmdnDBKTJTkh5Ag3Y2EBkuo
	1V/+/6H6slSyIgUWiKJ80fHYyTJJZ8A5EuhZYZDguZy/KiLO1WWjPYPlqc7DMPD66L6cGnndK2X
	oDFUeOuIfb4VrZzDXPdeORg1ZvDy0NRcT
X-Google-Smtp-Source: AGHT+IGbfMH+Gv1oHilkymoa8bNlUIJ10dhH/yJQvx0aGWTh2GKopUn+bl64QH+dENPnIbq9liSjUuv/7P7YZ1na6ws=
X-Received: by 2002:a2e:9bc5:0:b0:2f1:67de:b536 with SMTP id
 38308e7fff4ca-2f3aa1f0788mr22823421fa.24.1723643857842; Wed, 14 Aug 2024
 06:57:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814123801.1196678-1-huangxiaojia2@huawei.com>
In-Reply-To: <20240814123801.1196678-1-huangxiaojia2@huawei.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 14 Aug 2024 22:57:21 +0900
Message-ID: <CAKFNMonzv8Xpx2bucrPwtmq=vYcFbVz1KC5G_Y89v9N=vQRnww@mail.gmail.com>
Subject: Re: [PATCH -next] nilfs2: use common implementation of file type
To: Huang Xiaojia <huangxiaojia2@huawei.com>
Cc: yuehaibing@huawei.com, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 9:31=E2=80=AFPM Huang Xiaojia  wrote:
>
> Deduplicate the nilfs2 file type conversion implementation and
> remove NILFS_FT_* definitions since it's the same as defined
> by POSIX.
>
> Signed-off-by: Huang Xiaojia <huangxiaojia2@huawei.com>
> ---
>  fs/nilfs2/dir.c                    | 44 ++++--------------------------
>  include/uapi/linux/nilfs2_ondisk.h | 16 -----------
>  2 files changed, 5 insertions(+), 55 deletions(-)
>
> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> index 4a29b0138d75..ba6bc6efcf11 100644
> --- a/fs/nilfs2/dir.c
> +++ b/fs/nilfs2/dir.c
> @@ -231,37 +231,6 @@ static struct nilfs_dir_entry *nilfs_next_entry(stru=
ct nilfs_dir_entry *p)
>                                           nilfs_rec_len_from_disk(p->rec_=
len));
>  }
>
> -static unsigned char
> -nilfs_filetype_table[NILFS_FT_MAX] =3D {
> -       [NILFS_FT_UNKNOWN]      =3D DT_UNKNOWN,
> -       [NILFS_FT_REG_FILE]     =3D DT_REG,
> -       [NILFS_FT_DIR]          =3D DT_DIR,
> -       [NILFS_FT_CHRDEV]       =3D DT_CHR,
> -       [NILFS_FT_BLKDEV]       =3D DT_BLK,
> -       [NILFS_FT_FIFO]         =3D DT_FIFO,
> -       [NILFS_FT_SOCK]         =3D DT_SOCK,
> -       [NILFS_FT_SYMLINK]      =3D DT_LNK,
> -};
> -
> -#define S_SHIFT 12
> -static unsigned char
> -nilfs_type_by_mode[(S_IFMT >> S_SHIFT) + 1] =3D {
> -       [S_IFREG >> S_SHIFT]    =3D NILFS_FT_REG_FILE,
> -       [S_IFDIR >> S_SHIFT]    =3D NILFS_FT_DIR,
> -       [S_IFCHR >> S_SHIFT]    =3D NILFS_FT_CHRDEV,
> -       [S_IFBLK >> S_SHIFT]    =3D NILFS_FT_BLKDEV,
> -       [S_IFIFO >> S_SHIFT]    =3D NILFS_FT_FIFO,
> -       [S_IFSOCK >> S_SHIFT]   =3D NILFS_FT_SOCK,
> -       [S_IFLNK >> S_SHIFT]    =3D NILFS_FT_SYMLINK,
> -};
> -
> -static void nilfs_set_de_type(struct nilfs_dir_entry *de, struct inode *=
inode)
> -{
> -       umode_t mode =3D inode->i_mode;
> -
> -       de->file_type =3D nilfs_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
> -}
> -
>  static int nilfs_readdir(struct file *file, struct dir_context *ctx)
>  {
>         loff_t pos =3D ctx->pos;
> @@ -297,10 +266,7 @@ static int nilfs_readdir(struct file *file, struct d=
ir_context *ctx)
>                         if (de->inode) {
>                                 unsigned char t;
>
> -                               if (de->file_type < NILFS_FT_MAX)
> -                                       t =3D nilfs_filetype_table[de->fi=
le_type];
> -                               else
> -                                       t =3D DT_UNKNOWN;
> +                               t =3D fs_ftype_to_dtype(de->file_type);
>
>                                 if (!dir_emit(ctx, de->name, de->name_len=
,
>                                                 le64_to_cpu(de->inode), t=
)) {
> @@ -444,7 +410,7 @@ void nilfs_set_link(struct inode *dir, struct nilfs_d=
ir_entry *de,
>         err =3D nilfs_prepare_chunk(folio, from, to);
>         BUG_ON(err);
>         de->inode =3D cpu_to_le64(inode->i_ino);
> -       nilfs_set_de_type(de, inode);
> +       de->file_type =3D fs_umode_to_ftype(inode->i_mode);
>         nilfs_commit_chunk(folio, mapping, from, to);
>         inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
>  }
> @@ -531,7 +497,7 @@ int nilfs_add_link(struct dentry *dentry, struct inod=
e *inode)
>         de->name_len =3D namelen;
>         memcpy(de->name, name, namelen);
>         de->inode =3D cpu_to_le64(inode->i_ino);
> -       nilfs_set_de_type(de, inode);
> +       de->file_type =3D fs_umode_to_ftype(inode->i_mode);
>         nilfs_commit_chunk(folio, folio->mapping, from, to);
>         inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
>         nilfs_mark_inode_dirty(dir);
> @@ -612,14 +578,14 @@ int nilfs_make_empty(struct inode *inode, struct in=
ode *parent)
>         de->rec_len =3D nilfs_rec_len_to_disk(NILFS_DIR_REC_LEN(1));
>         memcpy(de->name, ".\0\0", 4);
>         de->inode =3D cpu_to_le64(inode->i_ino);
> -       nilfs_set_de_type(de, inode);
> +       de->file_type =3D fs_umode_to_ftype(inode->i_mode);
>
>         de =3D (struct nilfs_dir_entry *)(kaddr + NILFS_DIR_REC_LEN(1));
>         de->name_len =3D 2;
>         de->rec_len =3D nilfs_rec_len_to_disk(chunk_size - NILFS_DIR_REC_=
LEN(1));
>         de->inode =3D cpu_to_le64(parent->i_ino);
>         memcpy(de->name, "..\0", 4);
> -       nilfs_set_de_type(de, inode);
> +       de->file_type =3D fs_umode_to_ftype(inode->i_mode);
>         kunmap_local(kaddr);
>         nilfs_commit_chunk(folio, mapping, 0, chunk_size);
>  fail:
> diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilf=
s2_ondisk.h
> index c23f91ae5fe8..f52c338103a5 100644
> --- a/include/uapi/linux/nilfs2_ondisk.h
> +++ b/include/uapi/linux/nilfs2_ondisk.h
> @@ -306,22 +306,6 @@ struct nilfs_dir_entry {
>         char    pad;
>  };
>
> -/*
> - * NILFS directory file types.  Only the low 3 bits are used.  The
> - * other bits are reserved for now.
> - */
> -enum {
> -       NILFS_FT_UNKNOWN,
> -       NILFS_FT_REG_FILE,
> -       NILFS_FT_DIR,
> -       NILFS_FT_CHRDEV,
> -       NILFS_FT_BLKDEV,
> -       NILFS_FT_FIFO,
> -       NILFS_FT_SOCK,
> -       NILFS_FT_SYMLINK,
> -       NILFS_FT_MAX
> -};
> -
>  /*
>   * NILFS_DIR_PAD defines the directory entries boundaries
>   *
> --
> 2.34.1
>

Hi Huang Xiaojia,

I understand the intention of using common code for conversion between
ftype and dtype. I haven't fully reviewed this yet, including its
compatibility, but I agree with the direction.

However, please do not remove the definitions of NILFS_FT_* in
nilfs2_ondisk.h (even if there is no longer a reference from the
kernel implementation).

These are identifiers exposed to user space tools as a part of the
disk format definition in the uapi header, and removing them means
changing the user interface.

In the future, if FT_* is exposed to userspace, I think we will
redefine them as aliases to them. For now, leave them as they are.
Even if they should be unified to FT_*, they should be considered to
be phased out rather than suddenly removed.

Thanks,
Ryusuke Konishi
