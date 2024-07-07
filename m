Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98115EDC;
	Sun,  7 Jul 2024 15:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720366082; cv=none; b=qsSATyfIKglsgOu6yGEfXkqclOwqB5yDfjHG/wq+Lgdt5uZri4Z1IwoBt75HYTdhlpcVn8nU2ntMUO12No2ydMBQ94aBzAKSiUx/6yR5yaR7Po+0V8vU+bHrJsKzTb7ZwT3NphyKa8U6u5f4cDtc7gYUNp2uklurgUxC0X0L1Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720366082; c=relaxed/simple;
	bh=3QJzNF62gxTDAiNfsYf65fyUsELa6Yfsu2RONfThXrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=swp+jQ3mZLHC9y8T2eRy/IgQ1yeXGknMUiuUFS6b1CoxTNXXC9jw4SsmeintxgVcHIAKBYPdfCiecz+e2f7sKvXjYKQfVMznRvgx+FcnUIggj9l0b7lEPADtYlzT6xiwZ3lS5/ZzFJROmbNeqf+Se8B7lziDzQVDFfGk7OMCVdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Em4bSQdC; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Em4bSQdC"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ee817dac89so37879921fa.1;
        Sun, 07 Jul 2024 08:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720366079; x=1720970879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fr+DZ0MDnE5jftvLCDj70dKzBj7NuMiWgPTtDpC35MY=;
        b=Em4bSQdCXUvqqo/tvXSjQoUVT1cAhl7PhbfCdR8qesybcznzjvTBp5TzyCEkxxkDda
         LTRLKuziaXHmD6JLlUP2+aqFlu3Yg0x/dtjRkPvdlZyIGd+ZPsuFyWItY+qGVXhp4O4F
         zCRHchsqZewFBH+jGXwrBc0rCMq1j4KUbz3Uu/WDRJYLH4qGBdUsV3JbE4jYVsg3OPiS
         iA77I1JxNAWAlu6VflgKzeCEMpkh7Io5JmSZqoDF9gWdHlhta5F/2mp5WnRdpsLKdsOz
         lawwAyMeNgYAmjN6NoKRUS1r/BMB+5qx1Ho+Nm4LhYk0xKQLavw7V6/TKDslFsIn3N07
         iDxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720366079; x=1720970879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fr+DZ0MDnE5jftvLCDj70dKzBj7NuMiWgPTtDpC35MY=;
        b=AEZLb1fuzJBUuE8ROFTT18mNZSRUF/f4T2FFORHpMilFdkzzAplTNphpulXBpERJbh
         KDxy1GZZM2qa3BDXZ27YayqJ/YxJi1iFB6kHtKTGtCb8BAnQd9QMGxIS4gxlznBFjOsM
         qYDOmIHkx+Jdtz1mDG3da0r9WQgyNQjGwmJB+ikRNJi05q7/dOYhcit2EI5pGIz4k+Bj
         eMf4BYhg5dR4RVSt99IuD0/nF+xebYj6IH33vEuEu2bCx7ITXxvfKwXI4tYtzk6LiIVz
         r+lQpVevj7F69v/mQBB1wprjGoPGjm4z6t2hXpzXG5WWGv2txRm+FfGzgZ1xCBrz39p1
         wOUw==
X-Forwarded-Encrypted: i=1; AJvYcCVmeggnqKh/3lNU13CbiRsPcQ302tQFS+YtSYcxmyJQDKXPCHNUfP1bUzaUyLaDufWvoubIjwWxHD6+UtdQxmyPB/swpm3uEGYoWoCPsaER+m4NRe6LJSMwM9SYyK1bKNtFIwzeYO/NweP1jYw=
X-Gm-Message-State: AOJu0Yx9VrXw8pk1glnPz2kNQPc/sludabx0225eHROcolTowuMMLZe8
	zrFKxeR2izeVH9usYW4Jda8fWoIklg9cN04Nx+7ff8P+oHZ9OYMEN7cyzBiJTgNG115vNJVlTTB
	FL+7g3kDd8JVp+hog/DMwMAPxRsu3t4h9
X-Google-Smtp-Source: AGHT+IHAmu2FqqcMyieYM5i/cU8KsuJuD3lE+cYUbLZISRwa/hgVzTPFxdNvbDXESh/2KdJA6+mDBmTXyUzZiFOXZrE=
X-Received: by 2002:ac2:58f5:0:b0:52e:9389:5694 with SMTP id
 2adb3069b0e04-52ea0e58748mr2432064e87.34.1720366078372; Sun, 07 Jul 2024
 08:27:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7da501fae4f96e3d2c740fe5638cad813d33fcbf.1720360830.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <7da501fae4f96e3d2c740fe5638cad813d33fcbf.1720360830.git.christophe.jaillet@wanadoo.fr>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 8 Jul 2024 00:27:41 +0900
Message-ID: <CAKFNMond47=nPZdPN2+ZAAFJCN3RYGMi1+GdDPje+QXFRyBvog@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: Constify struct kobj_type
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 7, 2024 at 11:01=E2=80=AFPM Christophe JAILLET wrote:
>
> 'struct kobj_type' is not modified in this driver. It is only used with
> kobject_init_and_add() which takes a "const struct kobj_type *" parameter=
.
>
> Constifying this structure moves some data to a read-only section, so
> increase overall security.
>
> On a x86_64, with allmodconfig:
> Before:
> =3D=3D=3D=3D=3D=3D
>    text    data     bss     dec     hex filename
>   22403    4184      24   26611    67f3 fs/nilfs2/sysfs.o
>
> After:
> =3D=3D=3D=3D=3D
>    text    data     bss     dec     hex filename
>   22723    3928      24   26675    6833 fs/nilfs2/sysfs.o
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested-only
> ---
>  fs/nilfs2/sysfs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
> index 379d22e28ed6..a5569b7f47a3 100644
> --- a/fs/nilfs2/sysfs.c
> +++ b/fs/nilfs2/sysfs.c
> @@ -56,7 +56,7 @@ static void nilfs_##name##_attr_release(struct kobject =
*kobj) \
>                                                 sg_##name##_kobj); \
>         complete(&subgroups->sg_##name##_kobj_unregister); \
>  } \
> -static struct kobj_type nilfs_##name##_ktype =3D { \
> +static const struct kobj_type nilfs_##name##_ktype =3D { \
>         .default_groups =3D nilfs_##name##_groups, \
>         .sysfs_ops      =3D &nilfs_##name##_attr_ops, \
>         .release        =3D nilfs_##name##_attr_release, \
> @@ -166,7 +166,7 @@ static const struct sysfs_ops nilfs_snapshot_attr_ops=
 =3D {
>         .store  =3D nilfs_snapshot_attr_store,
>  };
>
> -static struct kobj_type nilfs_snapshot_ktype =3D {
> +static const struct kobj_type nilfs_snapshot_ktype =3D {
>         .default_groups =3D nilfs_snapshot_groups,
>         .sysfs_ops      =3D &nilfs_snapshot_attr_ops,
>         .release        =3D nilfs_snapshot_attr_release,
> @@ -967,7 +967,7 @@ static const struct sysfs_ops nilfs_dev_attr_ops =3D =
{
>         .store  =3D nilfs_dev_attr_store,
>  };
>
> -static struct kobj_type nilfs_dev_ktype =3D {
> +static const struct kobj_type nilfs_dev_ktype =3D {
>         .default_groups =3D nilfs_dev_groups,
>         .sysfs_ops      =3D &nilfs_dev_attr_ops,
>         .release        =3D nilfs_dev_attr_release,
> --
> 2.45.2
>

Thanks, this seems like a reasonable change.
I'll test it in a few environments just to be sure, and then send it upstre=
am.

Ryusuke Konishi
