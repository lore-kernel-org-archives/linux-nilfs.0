Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905B6309EF9
	for <linux-nilfs@vger.kernel.org>; Mon,  7 Sep 2026 08:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788769430; cv=pass; b=YJRhkLGUm+2UO56Si/Op3/db+fV2sC56jzI2/Nx+071zAlCmthyGNwr+D86hKWh49YPkakytEZ8v9+97kz3neR9z7sdNVR/WRKaUQQvDu3DlTxOxFA3LWcnIeStXnVw55L78ByARA9nAklttE/dPIquQhhIpqwKzo9y+Yf+Hbrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788769430; c=relaxed/simple;
	bh=P73mL+NckPvwm0Z6UFZ/zOQtwW0DTrdvlGKhHJ+Uef8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DfrS3RmpXhQw05GIjs/VcG6XGNdHFwNG8rxUYUXcgRIDA2HPSCVse81Aq+hFTXDBZgUhsozv5lFIrIWHQLpiO0sTTPsQBLEaWm4i6h0hh4s3rBaTe13Y9ybzAl1JqHkJUbRQau2T0BCAUbMJ8uUGDLJQE+iXCeiOLoOHMSixCGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YSNmaaK1; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSNmaaK1"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-66fb8a78ad2so3358424d50.2
        for <linux-nilfs@vger.kernel.org>; Mon, 07 Sep 2026 01:23:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788769427; cv=none;
        d=google.com; s=arc-20260327;
        b=AW+bKL+wRqMnewgTM0pltV3IfseM2It5lkX83a4+Pm7pTufk5mJOgWfb2F7MhwgOFY
         CnJpq/4p5yTSYFmujcYGAuLBfPNofZKAv8HYi8gUmADx3e/eINXC3ZziuQU9k5elFuPF
         wdDEtt1mMYxwfzg/aMU/AcyWsYL9fvlIC7+FBuwYKw+NRhQH37Uh+LFAvqdMjuR6sx1t
         jHKb36frdb7Ol7mHOf9FVQLTmEflYDRmCK1XixrztjWmQUkXyhG5/tLOiSzbhzj5o1kn
         KM8FQ2WT6YYfZ1+tbExRHxwX264Yo5o+qQpBbxvWartAnEUhyC11iOnjpzGarqFZRzjL
         sBTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1RaztqRxo0uD6ze9i74Ru/vD4EDfdRaHg25tJec+1a0=;
        fh=B094nHikDwxSt5eIAIqaScXfNRyc844IPuPHGCWDVUI=;
        b=EVKQUXuVhqIZoXEMSxIJP1NuBWnQ2bsr0OLohzRfrFL97lcIdFih0bZnXLUklv7RB6
         UPvkq6pqpDQMX/qXOPqZW0wt7gcw6Go97lSt0yJQGV/pVNkXJKk9s0F4vr+MsGphzGQP
         bUrOBxjOHISidYykrvFF+jWZCduqC5RHEraNTRNJZ/3YLa9QAzknvGgzJ8AkrGcIySBj
         u0gispb2CLLOvdPZgx8reI6mbRghQLDDbW2bFLuHz+snDlAqJva3dYZtRXz+cnI2qNGP
         /Hudlvt3e6uZdLopg9EtNoljDpbJ6/H0rr+src4P4uEr8GDa/q/Tqv9lIURHIlKrS/Ww
         vqwA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788769427; x=1789374227; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1RaztqRxo0uD6ze9i74Ru/vD4EDfdRaHg25tJec+1a0=;
        b=YSNmaaK1uI9IYDuj/JisTR/jCngJDl2aHIP+seKT4edLPBjfkvyjQG4II3yh9gXsXg
         2tSedZeX2VPsk//dedMvlmOxx9bPkKw5cLJn1klRtkfXNzppNC7Q++XZ395+K3vcSwUO
         Tz0Aa47l7zg41gnC7b4TcG1VdgqGX7oyyUgRDkBV1yBOL1oij3gkHhII3QawgujYj70E
         CJxrnkrewWV7dwiSTZ7yo0P2BLOy6YyTqiu6n0JMemginqkyq3zx8KyZns4mpKlyvwMP
         cTzI9XROIMDiWFi86N4KzNwXfEwjS9Mu8lWtgFm+Cujyf8tIkQx/78I/xvtUDJEwFaBh
         a45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788769427; x=1789374227;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1RaztqRxo0uD6ze9i74Ru/vD4EDfdRaHg25tJec+1a0=;
        b=oZlZa/h0xrEomwWi7w8e8OLc7QgP7ucoW+9X3Vot9ktcsN34I3cHpWCmAfqF6h5LEh
         rQfF14HeS3hYL8UyxsKtVXHhVidHyBd7BZxBiJXRd6GPI3irnSqtJ2NilYzpWP0VyN2f
         Nu3EEyZrfkfELXhJxbbFlY5VdQjzXlb7lVr9oQHor6gLRYy+tOwVCsHwwfDWI99KOuxP
         WlEsGjlG6tj1P84d5xNkVyJuxK9QqrSrPnFsU23E2dihfwjxJBBQN1B8WRXTnvBrK3/E
         P1GPcXDhhjB5bWA4WEgnZWAsglUJoAl+eeWd6meleFxaeEIb4NijpvsZObxu/wcy3cpu
         +Abg==
X-Forwarded-Encrypted: i=1; AKwUvBzRxStg0RSTSLYB3p2I5nCmqk/cKyCC5u5Jjb/Wp1Xbt/A2k0MC0H2hcBDMB/AXxswGPCH1N+4u3fQj3g==@vger.kernel.org
X-Gm-Message-State: AFuF++mh73vbsk5mXR07/+mmnkQ7ZwBeRdErOPjSmZHyOgTkr1CivUzk
	z1hb9FtPtvFS6dMxCHkGsFWeiK4qNbX4Pl/iatgYQde1CjJS1RiH0cmK/SLITk8xkASTaufc/yf
	WmUBRKWZ8Fjfbz+gowdFTjDmlDMtEAXE=
X-Gm-Gg: AYBFou05Sd7y522+QJH1UJz6T3I4By7nKa2g2itiovf6iYkNYxpR6gAu+zUszOnXY70
	QUzjss6h1+H4Wsgb0zNg1GJqHtdjANyjDLEuq5O5k56XXcFgNWGWSxZiVfA5A/pjjE+/NjlWBhI
	aWeamMaPyodarNNmeOJKoDlEw3vnCLUTqsFGTA8uPHSKdHF+YDqjHMs7AeIycthZVSY2WoBK+Mc
	KvLtqmje8K+EPkuWf0X/zfF8vC5/xzdP5+chZ+Tg5gQZawPesXZsCWtfdkpsM68jW8ehemX2pd7
	5Yc/P+sGLdyVsu+VT7xR1bdIXVkr845UGAec/TzVY7Xe
X-Received: by 2002:a05:690e:4010:b0:66f:a8e8:7140 with SMTP id
 956f58d0204a3-66fb58e9544mr5610726d50.5.1788769427506; Mon, 07 Sep 2026
 01:23:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907-nilfs2-dead-code-cleanup-v2-1-fa1ab5b0abd6@gmail.com>
In-Reply-To: <20260907-nilfs2-dead-code-cleanup-v2-1-fa1ab5b0abd6@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 7 Sep 2026 17:23:28 +0900
X-Gm-Features: AcwNN1UL-TBL1zVJ8oYPZu6IdEJ8j9pQrZKvKaogUfV_Im3LoHnPA17DgONGnVE
Message-ID: <CAKFNMo=AHjHpQdzMXtH-TbE-1OFCRmRLaOcSm=87YJYHo2M=EA@mail.gmail.com>
Subject: Re: [PATCH v2] nilfs2: remove '#if 0' code blocks
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Joshua Crofts <joshua.crofts1@gmail.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 2:34=E2=80=AFPM Joshua Crofts wrote:
>
> There are two instances of '#if 0' code blocks that are dead code.
> Remove these code blocks.
>
> Additionally, remove a commented out section containing similar code
> as the '#if 0' block and unnecessary brackets around a single-statement
> if per checkpatch rules.
>
> Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
> ---
> Changes in v2:
> - remove block of commented out code (Ryusuke).

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Viacheslav, could you please apply this directly to your tree for the
next cycle?

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/inode.c | 7 -------
>  fs/nilfs2/super.c | 8 ++------
>  2 files changed, 2 insertions(+), 13 deletions(-)
>
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 34e6096069ad..778274203f4c 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -342,8 +342,6 @@ struct inode *nilfs_new_inode(struct inode *dir, umod=
e_t mode)
>         ii->i_flags =3D nilfs_mask_flags(
>                 mode, NILFS_I(dir)->i_flags & NILFS_FL_INHERITED);
>
> -       /* ii->i_file_acl =3D 0; */
> -       /* ii->i_dir_acl =3D 0; */
>         ii->i_dir_start_lookup =3D 0;
>         nilfs_set_inode_flags(inode);
>         inode->i_generation =3D get_random_u32();
> @@ -422,11 +420,6 @@ int nilfs_read_inode_common(struct inode *inode,
>
>         inode->i_blocks =3D le64_to_cpu(raw_inode->i_blocks);
>         ii->i_flags =3D le32_to_cpu(raw_inode->i_flags);
> -#if 0
> -       ii->i_file_acl =3D le32_to_cpu(raw_inode->i_file_acl);
> -       ii->i_dir_acl =3D S_ISREG(inode->i_mode) ?
> -               0 : le32_to_cpu(raw_inode->i_dir_acl);
> -#endif
>         ii->i_dir_start_lookup =3D 0;
>         inode->i_generation =3D le32_to_cpu(raw_inode->i_generation);
>
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 893a504cb80c..89fa6faa34d2 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -824,13 +824,9 @@ static int nilfs_setup_super(struct super_block *sb,=
 int is_mount)
>         max_mnt_count =3D le16_to_cpu(sbp[0]->s_max_mnt_count);
>         mnt_count =3D le16_to_cpu(sbp[0]->s_mnt_count);
>
> -       if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
> +       if (nilfs->ns_mount_state & NILFS_ERROR_FS)
>                 nilfs_warn(sb, "mounting fs with errors");
> -#if 0
> -       } else if (max_mnt_count >=3D 0 && mnt_count >=3D max_mnt_count) =
{
> -               nilfs_warn(sb, "maximal mount count reached");
> -#endif
> -       }
> +
>         if (!max_mnt_count)
>                 sbp[0]->s_max_mnt_count =3D cpu_to_le16(NILFS_DFL_MAX_MNT=
_COUNT);
>
>
> ---
> base-commit: 4d7d9486c04d917265f64c55bd23b2cc4fe7749c
> change-id: 20260905-nilfs2-dead-code-cleanup-cefbe2773172
>
> Best regards,
> --
> Kind regards,
> Joshua Crofts
>
