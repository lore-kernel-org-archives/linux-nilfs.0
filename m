Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A811714A8
	for <linux-nilfs@vger.kernel.org>; Thu, 15 Aug 2024 13:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729421; cv=none; b=nOFwPTcjm8uQVmwhop7m6PtIoBxIEEvsSSZQ22ldQCUTEbKPl48M9svsDhmLxs6xI3HElsTpBLFO9rAOqkRZ7Xax+vP83VVKUrDChs9TE7Rq1WZnOviMODTBXD5SsuQKL9qQZ3fIqRpvWe8pZVCCMAh9Su8asNExflHVZhILPJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729421; c=relaxed/simple;
	bh=4TQRJFqg+4ZLuu0+mTkWOoiwyWZ++QZOIlkKkxSQTxQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FC7lv5qxjelkVbS4P3B9+OZY1NEy2i/L402loklrEqrsvqreVROAIjCFvlPKje3wJ6AxZyteh9DBeG3Y5VIKUbe4yVhMfi8ocRFJnEM2TX1ux457uCcQCgKSLw9P141/g4Djtb/GV3uNN5wGaKIxMH+pgmU6gu/xkP9DSs3Jr5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T2rgw5aL; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T2rgw5aL"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53310adb4c3so580258e87.3
        for <linux-nilfs@vger.kernel.org>; Thu, 15 Aug 2024 06:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723729417; x=1724334217; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5elmfcsy6t/Z5UQ+bSUJoDGbumwrMG8zoNXFo95OWw=;
        b=T2rgw5aLz3U8zNr1auR0Nsu24dTnz5NzFSnoVv5gNcAohbdMUvcoxmLrnFMx1c+n+f
         dwVS9peAhmoxvyMZmFKybBL7CNVRsb3VLECLa6bG8bPz3j/c9paBHEHNa7trjtnBG8fX
         E1BtNhfwwsbnbp4mjP0uYyDt0rIAv4MeISRmb8AizHFVnIMg6JmK2IHnyRXe0u/V6gPl
         ASHhdxuwiYzgFO1TQoNQAQWerNhW4JZ4KAxw5109YrWKoRQQJ7PL8vl0ddTkBjmalf0/
         FkT7XX/K0jsY3f4VuKLYo3thxJ51uhlX47AfjGICTIfX6j4Z6bfXCK55NLWGd0by6Rqw
         wduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723729417; x=1724334217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5elmfcsy6t/Z5UQ+bSUJoDGbumwrMG8zoNXFo95OWw=;
        b=NVeqbzl7Aqr6vbyw34bXkVfAjWgV2XQu4m+me9kkkSALrf87mfFbve9lvHW3QjVXe8
         ox2qvPgjaoJ7HwCQU1ICANX/duI0uTWU5PqssDQWgiOVF8LRPGjAJzakh9/mPZpWbOVi
         K1XLWAYpEke6Clk+1+UsNm7hCKEj3Ph+5KAi8CSnWai68d2bqUNayYsAl3JNAdknOXVz
         ezzxRnBuencN9lPKzmAUOfdGMbDKcl7YzXBae1nsR4qz3g/kdygwNRqFHvMphOUZcSDe
         eKAvJpZPZ0rz9qXSOzP3Fh+tK1otTqNTUcDk9EUwbuG4qBzO8tqkfFAgktDCQUTfyqrq
         qfFw==
X-Forwarded-Encrypted: i=1; AJvYcCWEA97i2q+lQopbGIhBJqGzCbXfmMGfOm2OKUf0kbBBedm8mHCgCyANeWTRcc3KVOzEMF2SmXmgHQmmFgN9czqbXXqkVkT+QA+mdUI=
X-Gm-Message-State: AOJu0YxlpLRV+IzsVG/i+9ktStT+ap0bJzzT2DI0nlcnUa8B13MiY7uT
	egnAFeFTCqrthNMjDsGQO1mnHTDc64gLbzQBaE9Id9WqfQIzFYIsWl5KSszBiKmxLOnv6r5uL3d
	c4TmpZ7jF/0ifTLmLxxNogXD5S08=
X-Google-Smtp-Source: AGHT+IE3ku+0N3jgRonmi5Qsi8ZgyZj8jkHWPKgoCDCh40zKXkAwpnYVhfzPHX3Vjk8YJXMnHq30zbtkseDX8ruCJxs=
X-Received: by 2002:a05:6512:b92:b0:52c:d7d9:9ba6 with SMTP id
 2adb3069b0e04-532edbb48c0mr3722885e87.50.1723729416723; Thu, 15 Aug 2024
 06:43:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240815013442.1220909-1-huangxiaojia2@huawei.com>
In-Reply-To: <20240815013442.1220909-1-huangxiaojia2@huawei.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 15 Aug 2024 22:43:19 +0900
Message-ID: <CAKFNMomEJPEuAEkDf=pr06QDVxADbfg5vzqxq7jpYYkjGVVROA@mail.gmail.com>
Subject: Re: [PATCH -next v2] nilfs2: use common implementation of file type
To: Huang Xiaojia <huangxiaojia2@huawei.com>
Cc: yuehaibing@huawei.com, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2024 at 10:27=E2=80=AFAM Huang Xiaojia wrote:
>
> Deduplicate the nilfs2 file type conversion implementation.
>
> Signed-off-by: Huang Xiaojia <huangxiaojia2@huawei.com>
> ---
> v2: Keep the definitions of NILFS_FT_*
> v1: https://lore.kernel.org/all/20240814123801.1196678-1-huangxiaojia2@hu=
awei.com/

Thanks Huang.

I've done a full review of this v2 patch and have no issues or
additional comments.
After testing, I'll include it in a patch set I'll send upstream for
the next cycle (probably a collection of misc patches).

Thanks for your help.

Ryusuke Konishi

> ---
>  fs/nilfs2/dir.c | 44 +++++---------------------------------------
>  1 file changed, 5 insertions(+), 39 deletions(-)
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
> --
> 2.34.1
>
