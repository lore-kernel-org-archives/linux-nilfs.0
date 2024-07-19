Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A897D1465B1
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Jul 2024 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721410637; cv=none; b=YzE/rlQyizrvsZNmfAJHYL3kktTECDS8J+9Lk57zuEKZfUgm9jceYKg6ZuMeZLjnCCD7zg/0ywZSvsrPbMrJewtBBzN+3h22V6u2FWI7kQLpGdsn8GKeLTmQrjawIO8ytN0E/mle41VMbWtJL86kwia7/yQmHD756SthTYZB4a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721410637; c=relaxed/simple;
	bh=8dnKiwY7NJXGhX+fRLaVrKz9h+svjc42PbMDP35HkxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m0Ee7qUhZZuK+GybAR4433crIfTIYdk1WYZvtfQCI1OnPSeY7f6NIfa5Hb1EiXBvBlYNT+T6v/2E29FeH6bOJuAYTu1gYm+fWPtabWAmcaBdHLmW2RX1WdycXvMKWEyrZIAFbE1Z/xOrhTIBpJNAzEmat4XaqJbV3WZOJe7vWyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NmzTcLLj; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NmzTcLLj"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52ea79e689eso2892200e87.1
        for <linux-nilfs@vger.kernel.org>; Fri, 19 Jul 2024 10:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721410633; x=1722015433; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajrJSAcBiy8Fhnywx+itnz4Ok7S/mD4j+kbRIQrerpU=;
        b=NmzTcLLj4L1HSdL/nhMUiyVZqUEhOYPXk68uOWHY/iT1/4CQjapI1Fo7ke2NM3QCIL
         D6Y8eLFwfm26C/WK59w2WwTOjpypJIWhPeaz+H3TtGUGsYNuWR7m8i1waKabISIYwvXA
         pIiBv/RzILZoXE6EoA3mjfmGt0ldOImVliROgTpte5yRTNiwjwmRG2TS6CLc/1vkPDwV
         yIre8H+wLbucsHfgiEOYXaSQ4hpw2IWkFGRJ6CbGy/uYyNpeRLun4b8iJoGcuE8rmbnj
         W/WIw/OVDomuSGqqma1UfmWVKjTlg+btnaxTeYAcJAuVF+PtwZx7z5JwJxWhG/jlZPK9
         NkaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721410633; x=1722015433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ajrJSAcBiy8Fhnywx+itnz4Ok7S/mD4j+kbRIQrerpU=;
        b=B6dCzEA6cG6/CuLVYOV27LqZp3Zil+CFDyn5600VwsZ0VvA9PeKpI+LHGvkXBwYh/W
         dUtlRLuLVGciUw/uhmOEAJKj3Mg87HXBZensPW8r9GCCExTF3HfUWex1bP4Zb6/GE3Wn
         ZDRRYvRZ1EfBFJ/6/LAn5Kr5qmxiUEGIq013WKdS3F3Z9JEbC81e8reQTf34NRxL9P7p
         MmkeXtsg8zxsbRahFc0H3BbUtLw6yaCJVxIT9nioB7yPPTCGniI92AptdTWR/i83u3AS
         YxCMJH23f3IHMlrPXwGq35Ksz3u9fXTeuhRzwVA+f6uv7xkfvSZzSttuVIeYbR+NDO+p
         lqvg==
X-Gm-Message-State: AOJu0Yy6qMbugXmVjRVsT7y4drEDel9GE8sfepJGLGhjc4Wc34HpJEti
	xVdTEh7gRJpQikmbLzKs7yaFyPHDKEt20u05zBtNOFNtcz21ljl/pOMbGmOqcxFFlt4cMnIqE5z
	2eoyXWZQg/EVWJhyi8EBqc1HlBpk=
X-Google-Smtp-Source: AGHT+IG9iMoR7qYrSqPj/XAetBUQoBUEMnVVDtZK/xXFNEtLPbfBUBZOXQlIUegcgYal6b41T7JM/W87+NTPCHdWmFE=
X-Received: by 2002:ac2:4c41:0:b0:52e:9cc7:4462 with SMTP id
 2adb3069b0e04-52ee53a7234mr8368671e87.11.1721410632434; Fri, 19 Jul 2024
 10:37:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719091725.1877001-1-lihongbo22@huawei.com>
In-Reply-To: <20240719091725.1877001-1-lihongbo22@huawei.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 20 Jul 2024 02:36:55 +0900
Message-ID: <CAKFNMome8sJQ6z391GVYCAG0rgbnnwyVAUJVdCnNWmRjtgakxw@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: support ->tmpfile()
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 6:12=E2=80=AFPM Hongbo Li wrote:
>
> Add function nilfs2_tmpfile to support O_TMPFILE file creation.
>
> tmpfile testcases(generic/(004,389,509,530,531) except
> generic/389,530 (need acl and shutdown supported) now run/pass.
>
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/nilfs2/namei.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index c950139db6ef..a36667d7a5e8 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -125,6 +125,36 @@ nilfs_mknod(struct mnt_idmap *idmap, struct inode *d=
ir,
>         return err;
>  }
>
> +static int nilfs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +                       struct file *file, umode_t mode)
> +{
> +       struct inode *inode;
> +       struct nilfs_transaction_info ti;
> +       int err;
> +
> +       err =3D nilfs_transaction_begin(dir->i_sb, &ti, 1);
> +       if (err)
> +               return err;
> +
> +       inode =3D nilfs_new_inode(dir, mode);
> +       err =3D PTR_ERR(inode);
> +       if (!IS_ERR(inode)) {
> +               inode->i_op =3D &nilfs_file_inode_operations;
> +               inode->i_fop =3D &nilfs_file_operations;
> +               inode->i_mapping->a_ops =3D &nilfs_aops;
> +               nilfs_mark_inode_dirty(inode);
> +               d_tmpfile(file, inode);
> +               unlock_new_inode(inode);
> +               err =3D 0;
> +       }
> +       if (!err)
> +               err =3D nilfs_transaction_commit(dir->i_sb);
> +       else
> +               nilfs_transaction_abort(dir->i_sb);
> +
> +       return finish_open_simple(file, err);
> +}
> +
>  static int nilfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
>                          struct dentry *dentry, const char *symname)
>  {
> @@ -544,6 +574,7 @@ const struct inode_operations nilfs_dir_inode_operati=
ons =3D {
>         .mkdir          =3D nilfs_mkdir,
>         .rmdir          =3D nilfs_rmdir,
>         .mknod          =3D nilfs_mknod,
> +       .tmpfile        =3D nilfs_tmpfile,
>         .rename         =3D nilfs_rename,
>         .setattr        =3D nilfs_setattr,
>         .permission     =3D nilfs_permission,
> --
> 2.34.1
>

Hi Hongbo,

Thank you for the patch suggestion.

As for the O_TMPFILE support, with this implementation, when the file
system crashes in an unclean way, the inodes generated in the ifile
metadata file by nilfs_new_inode() are not released and remain
orphaned.

I think that this problem needs to be solved first.

If you could propose a mechanism to repair orphaned inodes at mount
time, I would like to apply it.
Is that possible?

For example,

A method of constructing an on-disk chain list of inodes that starts
from the latest checkpoint of cpfile, or a reserved inode (inode
number 0, etc.) of ifile, registering them there, and releasing them
during recovery at mount time.

Alternatively, a less efficient method would be to perform a full scan
of ifile metadata when recovery occurs at mount time,
and release those whose link count does not match the inode bitmap.

If we actually implement it, I think we need to discuss the method to
be determined.

This issue takes priority, but I would like to make another comment
about the implementation of your proposal:

The call to nilfs_mark_inode_dirty() involves copying the on-memory
inode data to the ifile, so it must be done after the on-memory inode
update is complete.  Therefore, move it after the call to d_tmpfile().
(we need to check if this swap actually works without side effects).

Also, the function name in the changelog is a type for "nilfs_tmpfile".

That's all for now.

Thanks,
Ryusuke Konishi
