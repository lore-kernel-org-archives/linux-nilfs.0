Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6114594C
	for <linux-nilfs@vger.kernel.org>; Thu, 28 Mar 2024 22:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711663505; cv=none; b=fgajMklwuXiArGDWEReCpyKG9ZXhOikuB6Wf3cDYiKpOd/CAk1wK7huLb7dgAuOwAoTshf5Dr74zsZZ9aS+DUclLfC5R4J9bRrUYA8o6LJxZqlZivRCmriL0rZaGzN4w5scsTqKNDEXlqIjQq025zyK77D5cP70c+GoSwbwPzlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711663505; c=relaxed/simple;
	bh=9ZSPvENfmgfhIsnuJFWhvL6BmUkVhFz5PSQ7INGUgHQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZANe1RaM8nbTCjwYkZ5xY9sRczD3ypy26Be2o+FjW7PAxCYXbFgvUStY06o1lOdWySbW3A4OrH5iorSaOPLH4YjNWEDFAy4/EILtZ+NGXVChRn/LR9ZmzAOowgWC6URlXfOuAcRCM69E7Zy1fijweJLl8AoHVMVwLltPU4Q/Upo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3e9R8CFY; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3e9R8CFY"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-56c404da0ebso2248875a12.0
        for <linux-nilfs@vger.kernel.org>; Thu, 28 Mar 2024 15:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711663501; x=1712268301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGMxoG8AQ8BGP67PTNjLH3VS7bl1OwfTgMURF7OtwG4=;
        b=3e9R8CFYk4xjW7QBhCdJc/gM8mLEfGvLcbf051vzhpu2zFvFzZX0urTkZ6D3i9795p
         29DbUncFM+7y1IktSL96E1UC5aMZlFJnO0g6C9vb9wIqcsVtNxCMXqMpSV2n/q+ecnzv
         pYmuMpikZ9fkSnRWZMhYqQAl51UYAnQeMul8Jyjp2vlvxdRmX0Iyyd4EA0qi+XcFUxG4
         rT6uKbHEHvYaEsI+nhXf2DR5WZclKPXe9/tV37YTK9Z3CQVu4kVQMmizqwbkVfBoDvIg
         CZmjqR9MuDLE9xf4gftr5D33nqTy1cuyuHeF+ZBzWix/r5u70eh3ACzKBJ3uTYcMYgTp
         ibuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711663501; x=1712268301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGMxoG8AQ8BGP67PTNjLH3VS7bl1OwfTgMURF7OtwG4=;
        b=Q/odNDRiaMAsMYfhdYzVMxHGgaCE1S+KCxU4hUhM+MRi/RzOPPEl4crmqi8jvr6FgZ
         Vv5F98oYh4NICMdAt7Kpq/Bu7/i/RDjZZA+VpWIBv3BZCAlBttaWpJ1+iu7JVPXqRLXj
         zzSe84UlE1lxrMFMV94vDZmkQLD69JyaFBCFFMQQ+4KESrZRtCMbZi754YkTqB71Cere
         INoFaIvRnEohwGxgeHIyNH2d14XPt/ZJ4zznr0X5V05fXxntCQ0AFkz+njezo+WUMsm6
         abWxGTKUDgWLPJtG2hB8ZkyujtSEEH0nU0YSt7/Zk3NLv3jsl2/wl9y1ZdWy5YhEsKmQ
         Uvhg==
X-Forwarded-Encrypted: i=1; AJvYcCVSQj6VS+8ct8fOxsIVhrYmdc2cBHwztg+/c5qWqX59HejvRfxSGznOaj+xNlJeXVMjessSI0GpJ747ZS1i37pYmo1WTL0SN02U8js=
X-Gm-Message-State: AOJu0YzGk4OhA8aJGLfkkzDim7SJ/UVpwYWf0v7I9gyko902JvNT1wIO
	nCp3AtVyvKO4bbrTvuUdbl4vCCn4Bf7AWI0wtAWtV9J4EGKUyqXw2ZrM4UyZZ03pOWgN4sVwGyU
	o9oAFRgG03JLr/fQ0yN9W4l3SiASNCkflVr4Y
X-Google-Smtp-Source: AGHT+IGI1NuivKb4Ji1liwhmjoNA08qow9K2J1nHBY2lkA7t+bjvkMMP3tHaIzK6dIha9lwR+QhUcEEc6nDcKmlEY7E=
X-Received: by 2002:a05:6402:35ca:b0:56c:2ef7:f3ed with SMTP id
 z10-20020a05640235ca00b0056c2ef7f3edmr442959edc.35.1711663501455; Thu, 28 Mar
 2024 15:05:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240328143051.1069575-1-arnd@kernel.org> <20240328143051.1069575-7-arnd@kernel.org>
In-Reply-To: <20240328143051.1069575-7-arnd@kernel.org>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 28 Mar 2024 15:04:49 -0700
Message-ID: <CAFhGd8oJ5trNE7na9jCDbEt5kox1rg0mia59EHj+XikHUnay5w@mail.gmail.com>
Subject: Re: [PATCH 6/9] nilfs2: fix out-of-range warning
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Philipp Stanner <pstanner@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Thorsten Blum <thorsten.blum@toblux.com>, linux-nilfs@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2024 at 7:32=E2=80=AFAM Arnd Bergmann <arnd@kernel.org> wro=
te:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> clang-14 points out that v_size is always smaller than a 64KB
> page size if that is configured by the CPU architecture:

Is this only with clang-14?

>
> fs/nilfs2/ioctl.c:63:19: error: result of comparison of constant 65536 wi=
th expression of type '__u16' (aka 'unsigned short') is always false [-Werr=
or,-Wtautological-constant-out-of-range-compare]
>         if (argv->v_size > PAGE_SIZE)
>             ~~~~~~~~~~~~ ^ ~~~~~~~~~
>
> This is ok, so just shut up that warning with a cast.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

My question out of curiosity aside,

Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  fs/nilfs2/ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index f1a01c191cf5..8be471ce4f19 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -60,7 +60,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilf=
s,
>         if (argv->v_nmembs =3D=3D 0)
>                 return 0;
>
> -       if (argv->v_size > PAGE_SIZE)
> +       if ((size_t)argv->v_size > PAGE_SIZE)
>                 return -EINVAL;
>
>         /*
> --
> 2.39.2
>
