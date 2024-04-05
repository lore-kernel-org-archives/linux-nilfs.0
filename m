Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C39748A
	for <linux-nilfs@vger.kernel.org>; Fri,  5 Apr 2024 10:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712313248; cv=none; b=p6hZ8rc5qjO6mfC2+0E2yqDjxH3issIZTWKB/YNLXTq+bkG1jnF3UOQqeyYDqJ9sk4VsCZhdcWixMrj3O9pj6BdSOgVxRgFqEDPmDf3pqUI6Ny+rb80IZZ5RKbJXbR6gg2ZJYMwbI6HEgRWnmFdWOdg+48pXIGFbioItFzrXr4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712313248; c=relaxed/simple;
	bh=KOcUrt6jrqayLkSoLxpFJYBebs3OShFmc005YgVWR54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I+X6gfN9xxaBK+X1SP33mohUidH3fFiTW2xbh449M+QR+rXW5bVhdQd3/n7yA3man/csOdHQ00aTWSkxTx4y9wp2r45i+zTvRu/T6kKfHuncA192monfT9PwI3XYLEo3dHCT4yIF835GXztN4zzkwOEF8yc6hKsQrZnTuZZpJTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LLYqWGRW; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LLYqWGRW"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-516d6898bebso240399e87.3
        for <linux-nilfs@vger.kernel.org>; Fri, 05 Apr 2024 03:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712313245; x=1712918045; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULs8ay7K5pu95JvZHBflm9rOZZ3htaMVjrbi3kdEbig=;
        b=LLYqWGRW0yVFS2/kaUH8ikeaQXj/B2g5NlIrnzE4g1/WK7SQVYWP6oasbYuYdOhcHX
         UpD2umPNpGQgfzVbhI8hYVYBev3Jqa9Vx7kKCitJ5LshvMXhBTprWo3Q86v8BsLfZfFE
         rglV+EyViV9mmS5RsbOJIdIxxumFgWyveJWmtRhmt8ZKRKEvbWCaJXcdZukG4CC/j5Is
         9+Oz8GfhxWdmmrs8zXrVOWXuTj8zQARO0WghaOkA6l/JovmQ7aX2qlSk6nTVyafWofmx
         ssqcoBYaB8hbRiy+k9GvkHXU2tERjdk9FlMOGiPZlq7v4LrLpK5zgMevoyy7yl4e7wld
         lTkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712313245; x=1712918045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ULs8ay7K5pu95JvZHBflm9rOZZ3htaMVjrbi3kdEbig=;
        b=YCP1erGrAyjW4nNPhLy8hpW14hxJ+kXq94nQAnZTWUtIqN3t+rbSZASmNSLUPIah/K
         kbdL1+W5XsH7Vmv27Luaexg/0qqY6R5ZyX6UVS0nE+oqeIPm7BR9x8de6TVQKqeQsj7r
         6Dif1v7XairFUeJnf+FJsmsmNUu09QhPdsSee+cFUAa5L2A28tP0VfLz6JY8HXFhdlfl
         kOExqHg9AQ3bPDyP5hYpBvHJhiRmYhPVIIdC4wGjUDzqJxK6Xi9PuIABq49oZF75mpeP
         1za2hzRGV2js6Rf67FwUgQmObvYGhnNHl/DiNZ8G5lcVj2QYQGBvPuKeMx60Xb/+FdOs
         wndg==
X-Gm-Message-State: AOJu0YwvTtsZ9enXUgbVuxVhocStk6GlT9GTqawCD5UC5VQBqZ4QyBnt
	o3slAbRphENiJiVfA9ovADv3gbRUfi9Gj702nCKPXOwmnzlQxPpS6utgrg0neLT9L8L7VKKYa+8
	MnJmfmHOdyqe2eDpDy1jCIXMrSHc=
X-Google-Smtp-Source: AGHT+IEqLgn5J1/xUwtwqX9QAgEetrZEUIBjFbDyfdsqx1MfZZB/nMNL0hZRUqtvph+KlSN5Zs9/zt2ve7rDFmf9l2Y=
X-Received: by 2002:a05:6512:3c8e:b0:516:d15e:88a4 with SMTP id
 h14-20020a0565123c8e00b00516d15e88a4mr899079lfv.49.1712313245086; Fri, 05 Apr
 2024 03:34:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e282e150-2bc1-4b6a-8aa1-0417371c2671@redhat.com>
 <CAKFNMo=bbdBsW2xvTMiZcrD37n8MWmDfhH7V2jKZ14=odduRXg@mail.gmail.com>
 <f99b0c44-c5b4-4e0b-892b-dd9793a80f9a@redhat.com> <CAKFNMokYkO-WsvrcZh=-FpR=LtCQnsyxET3ZjSzx-o5zXcMU9g@mail.gmail.com>
 <2fd47dc7-e130-4c67-b39a-b1c38aa1c500@redhat.com> <0d26ef52-91bd-4108-bf09-5d92fa58cd28@redhat.com>
 <1ba497be-64cb-4a4d-99a8-16707da32cc4@redhat.com>
In-Reply-To: <1ba497be-64cb-4a4d-99a8-16707da32cc4@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 5 Apr 2024 19:33:47 +0900
Message-ID: <CAKFNMo=zu38X+SYDgyP=g4aD9E1ee209C7FqvF9_cj1vxZgjuQ@mail.gmail.com>
Subject: Re: [PATCH V2] nilfs2: convert to use the new mount API
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 5, 2024 at 12:00=E2=80=AFPM Eric Sandeen wrote:
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> V2: Fix call to nilfs2_reconfigure() in nilfs_mount() to ensure
> fc->root is set.
>
> Clean up some extraneous comments and whitespace
>
> This one passes your current test script.
>
> Thanks,
> -Eric

Yeah, this v2 patch resolved the panic issue.  It passed the test
script in multiple environments, as well as my manual checks for mount
options with and without using the constant table.  Seems to be
working perfectly so far.

I'll get started on the full review, but I'd like to provide feedback
on style warnings detected by the checkpatch script at this point.

---
WARNING: Missing commit description - Add an appropriate one

WARNING: function definition argument 'struct super_block *' should
also have an identifier name
#146: FILE: fs/nilfs2/nilfs.h:338:
+extern int nilfs_store_magic(struct super_block *,

WARNING: function definition argument 'struct nilfs_super_block *'
should also have an identifier name
#146: FILE: fs/nilfs2/nilfs.h:338:
+extern int nilfs_store_magic(struct super_block *,

WARNING: space prohibited between function name and open parenthesis '('
#220: FILE: fs/nilfs2/super.c:721:
+ fsparam_enum ("errors", Opt_err, nilfs_param_err),

WARNING: space prohibited between function name and open parenthesis '('
#221: FILE: fs/nilfs2/super.c:722:
+ fsparam_flag_no ("barrier", Opt_barrier),

WARNING: space prohibited between function name and open parenthesis '('
#223: FILE: fs/nilfs2/super.c:724:
+ fsparam_string ("order", Opt_order),

WARNING: space prohibited between function name and open parenthesis '('
#224: FILE: fs/nilfs2/super.c:725:
+ fsparam_flag ("norecovery", Opt_norecovery),

WARNING: space prohibited between function name and open parenthesis '('
#225: FILE: fs/nilfs2/super.c:726:
+ fsparam_flag_no ("discard", Opt_discard),

WARNING: Missing a blank line after declarations
#317: FILE: fs/nilfs2/super.c:770:
+ struct super_block *sb =3D fc->root->d_sb;
+ nilfs_err(sb,

WARNING: quoted string split across lines
#576: FILE: fs/nilfs2/super.c:1193:
+ nilfs_err(s, "invalid option \"cn=3D%llu\", "
+ "read-only option is not specified",

total: 0 errors, 10 warnings, 563 lines checked
---

Of these, the warning for the function declaration of
nilfs_store_magic() is an existing issue, so it can be left as is.

Also, I feel like the warnings for fsparam_{enum,flag,flag_no,string}
can be ignored for the sake of appearance.  (I will not omit them here
so as not to make any preconceptions).

Thanks,
Ryusuke Konishi
