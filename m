Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A130C19E826;
	Wed,  2 Apr 2025 18:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743618993; cv=none; b=jcjTvpGhtnD0RLaePSeROmrk7P5YuFr2aFElyordo1oEgoF6oJBvoTb04WZspPR5sqWYNiSntClE4GAD7Y5/kp3cnEkdZj9UZNty4ZHgxkQze0wN5j8fu2o0exZFLOM4ZA/sD8/3clInsrpnk5aREkNUXEhRT7r7gqREzGl3VtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743618993; c=relaxed/simple;
	bh=FKIHSf5cZYkWbmp/d0E/1oP5l7pPs5lu6mv9+5xDjFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gZOqCIUb4rGHzb31eQxo6shh6QGzgSOwNkJPYBV6BdNvaSvHaeQ1Bog5ODStwEoFbRk49YQJlpeHzBzVQq5iKvLJiO4kaZgPL1hJFNQt8sQiy+yhDgwXqtImWc7+0yB9QOjpKep75Jxld5Q5F3RJ5ZN1dBIWCvxUTU6FPTppQxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YkAlJ+cF; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YkAlJ+cF"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5498d2a8b89so133964e87.1;
        Wed, 02 Apr 2025 11:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743618990; x=1744223790; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=teeXejL/Hd5zYG3KzJj1/Ymk9cghk5Bn0HSSl08+gVQ=;
        b=YkAlJ+cFkpmkMtrRzdLG9QBDPmQIR9peHXRKdgnEs2ICQ1V763tGZ0EXxE1OIFKD6E
         KIZHdampxG2FEsFCKiTfPDh88oUvuCZlaPsoQuWVUf+Jk9a0g16oPRI0XytLzk7UFArr
         3y/u9OTzrwhKDVf7w5Vgc6Fy3FliBzq6ZF0N3dFpqU354atmLslussyLFObwodDCBwCv
         2X3pJnyUFQZZZu/N7nAGKgbYq5B/OhqOpLg/IFHDqzNUT13Dh2NxhGj5eIDG2SEzr6gI
         DzoC0iWocszvJb9qD7NlWGdO7NVXtULBGriA6HP0AXf+DaYgRLN4sq7wm9QAXhoYGCpk
         KKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743618990; x=1744223790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=teeXejL/Hd5zYG3KzJj1/Ymk9cghk5Bn0HSSl08+gVQ=;
        b=Uq7oVoyOWRm/khQXfcSmQUPjEha4QRZoHRs8s8+EUdXnKzut/Ujx+qLdiRmijOUhnj
         qIBhl6gBCAUCql8sZKoGVpFfu36VaA09PZxG5iScUWQ5klXETOWCHLGgaCfZJIN4yEgb
         GOlRuTF6X+O+zgWqmNpIaPMOiwHrvEg4gtIxQ/fx82vmZMy7hnIt6wZpEKORfPML86IM
         tylSulTc8K+pZZE2oL1V/Wh4xlK74l+UCxAhOm4JYlEkFbDLYtEebwC0dl8m7yCoY620
         cG0evnBEzU65jJBshaljLpHzEI+b+kyzD9QUChM403k5dYeJhbQ/xZl0thipbINp5Tbm
         a9GA==
X-Forwarded-Encrypted: i=1; AJvYcCWIswdIrV8uiTU5/iuoMFWUlVIkjZSurvFaigMdVkpR+mnJ+qLbFRy0HaWc6IMldx6zGULnrXCAQO9aI9w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7YxWvewEMs5M9Y+bB2wGNbv/WjIuwMkbmCgJIMTH64+Ojwkj0
	VS6M74utFU7gBvVsRBHuOACIUB2NIwyXIzXJEjZXX3NrUTrrqB88YUFzrNWiIT+rU/az+V41vSR
	uNoiamWzmE+KWre2UxM3oTUtA2bvK+MbL
X-Gm-Gg: ASbGncvYWxMxQw+/iZYdTUY7uVeds7N3j+1O8R5YdRDqYkBGA2P0vpsq5jKi54mIfmx
	lP3eT64gJGBQcmQRfif1Zz8oeaBlrzEdw/Dzl9Wassia6uvNT6cC5pETx6exzXGV5bq6NVOhcVC
	aiLB2aDNqvdGuqeWufGFBQY9BSZ2PzzSLkNC6hMOPfXKeMs6dHQbrFiDW5gpwL
X-Google-Smtp-Source: AGHT+IG6tIKLi8Y1e3xKYYecej6SvVuqlTPnJ8DZQtIr4L7+/movsrG9weMDGjS5CKM42BvcD412xJIK1IHhW2Z1cH4=
X-Received: by 2002:a05:6512:68a:b0:549:8f4a:6ba7 with SMTP id
 2adb3069b0e04-54b110109a6mr6006225e87.36.1743618989412; Wed, 02 Apr 2025
 11:36:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250402085856.3348-1-vulab@iscas.ac.cn>
In-Reply-To: <20250402085856.3348-1-vulab@iscas.ac.cn>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 3 Apr 2025 03:36:12 +0900
X-Gm-Features: AQ5f1JqCEBeAdU1cscafNKjqu6N8tmDqzGBuNtzEsQ_845TclGUwLFsnpsdJdRU
Message-ID: <CAKFNMomBZBVZZ_ohHDuZpJJWJHz_5FE+6EDxVoiFDvRCfFb_HQ@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: Add pointer check for nilfs_direct_propagate()
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I will comment inline.

On Wed, Apr 2, 2025 at 5:59=E2=80=AFPM Wentao Liang wrote:
>
> In nilfs_direct_propagate(), the printer get from nilfs_direct_get_ptr()
> need to be checked to ensure it is not an invalid pointer. A proper
> implementation can be found in nilfs_direct_delete(). Add a value check
> and return -ENOENT when it is an invalid pointer.

nilfs_direct_propagate() (and its caller nilfs_bmap_propagate()) are
internal operations called only by the log writer, which writes back
new or modified blocks, so we must ensure that -ENOENT is not
erroneously propagated to system calls.

In nilfs_direct_propagate(), if the pointer value obtained by
nilfs_direct_get_ptr() is NILFS_BMAP_INVALID_PTR, it means that the
metadata (in this case, i_bmap in the nilfs_inode_info struct) that
should point to the data block at the buffer head of the argument is
corrupted and the data block is orphaned, meaning that the file system
has lost consistency.

To handle this case, return -EINVAL instead of -ENOENT.

If you do so, the caller nilfs_bmap_propagate() will treat it as
metadata corruption via nilfs_bmap_convert_error() and the error code
will be converted appropriately.

And please don't cite nilfs_direct_delete() as an example.  It
intentionally returns -ENOENT as an error indicating that the block
you tried to delete did not exist, regardless of whether the
filesystem is corrupted or not.  On the other hand,
nilfs_direct_propagate() assumes that the block associated with the
buffer head of the argument can be looked up.  So, these are based on
different assumptions.

Please revise the changelog description and the returned error code
with the above in mind.

>
> Fixes: 10ff885ba6f5 ("nilfs2: get rid of nilfs_direct uses")

The commit that should be pointed to as the cause is:

Fixes: 36a580eb489f (=E2=80=9Cnilfs2: direct block mapping=E2=80=9D)

> Cc: stable@vger.kernel.org # v2.6+

Please remove this tag. If it becomes a real issue and becomes a
higher priority, I will add it.  (At least with the Fixes tag, it will
be picked up automatically and eventually backported to the stable
trees will be attempted.)
For now I will send it for the next cycle as an extra sanity check,
after making sure it doesn't introduce any new issues.

Again, when you send patches with git send-email, please be careful
not to include stable@vger.kernel.org in the recipient list.
To avoid being noisy, at this stage, it is sufficient to only send the
patch to me (the maintainer), the linux-nilfs ML and LKML.

Thanks,
Ryusuke Konishi

> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  fs/nilfs2/direct.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
> index 893ab36824cc..ff1c9fe72bec 100644
> --- a/fs/nilfs2/direct.c
> +++ b/fs/nilfs2/direct.c
> @@ -273,6 +273,9 @@ static int nilfs_direct_propagate(struct nilfs_bmap *=
bmap,
>         dat =3D nilfs_bmap_get_dat(bmap);
>         key =3D nilfs_bmap_data_get_key(bmap, bh);
>         ptr =3D nilfs_direct_get_ptr(bmap, key);
> +       if (ptr =3D=3D NILFS_BMAP_INVALID_PTR)
> +               return -ENOENT;
> +
>         if (!buffer_nilfs_volatile(bh)) {
>                 oldreq.pr_entry_nr =3D ptr;
>                 newreq.pr_entry_nr =3D ptr;
> --
> 2.42.0.windows.2
>
