Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1825E16EBED;
	Fri, 27 Sep 2024 18:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727461137; cv=none; b=pgilg+L91lg7QEZIVX35pXPxuO/0wsdoJUNOhsWJ9OhfLG3hJxIO1YaN5KPmVuX03o9qqQyHzn1v7hwTNa7L79jQLN0Rfz2jAYLmdPmYEVW7k1DQlJ+eENKH4pK/mOSqLJSHqDM6N3izUk/ScJ3TzyK9eHKo5N/JPiZOTzoeyXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727461137; c=relaxed/simple;
	bh=Cc5bpfgc2ebNZO49EDB8yezKrZ2PpSx1H7KVunV5si0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AbYXl+WzTzepgZQfA8NgDhE1JuXSboKvoEIoKKj1ob/QNNEaApg8bcy7k763K7sQzZA6J1jrzMld4gCTRFOWfBpFsNs4pTkvunqN014VVdzuC24owSIqTNN0/8UBkzChXHZ1E+Qo5kAalDsettlompFvjAOwlBuOBRppN8tyt+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6nWKt3H; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6nWKt3H"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5389fbb28f3so1261395e87.1;
        Fri, 27 Sep 2024 11:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727461133; x=1728065933; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e9PaMjUupnuNud0DUF/86pCwupCkYKS/FGdmFFBzQL0=;
        b=O6nWKt3H52e1tO3xJLYzvHi+735fFF2lsDo9nKuo3eedsTHNtt5fe/q2IvTvvTyaOn
         SHkOJgcaqNzjdaNEJ8wGsxIRM1RRM56srlo6Kjtx1/cukGKkbp2vEBsKQz46LtYuCY61
         FD4BLC7zivRsYvDxID6OuIEvnt6Bce3Zlj8SKNI4Zia6OdQrg8NpsDKJMx6aMcoVeIcV
         x3m7lzFx4eZe83fgjgMIRCZfFCwyN4pGzVXYRem0dy26fyFrgJn9MUyIhcoy6e4gVhf6
         0TngXsxAqNvVZupYh6KlrZPTtdaTNGdiJ9MQXZgygCwYGYy6OZv5uGNcMTzia4F3qWvS
         clWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727461133; x=1728065933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9PaMjUupnuNud0DUF/86pCwupCkYKS/FGdmFFBzQL0=;
        b=JNw7YAR3QugkwsP79Sqbf29lwx6hQv74T6GKONxSEq2QaEwnaXVFcwAaYPxh8rj7w0
         iNBRhdR3AL9T+rMtJ5663ZHtgVdaTCW5aTMOP2X9XwgwN4RfB0Ui1oEs9eMT8yUcSc+M
         LDH3hhaKSkmoFbusB3zTPlAOETM3/kagZwNWxMvad/xvHIRSy9+yp+gclr7PyndGOcLk
         6VuMa/CH1PHw9k2we0Uvs9T3lniYbfuQVY62w9DBG5k5g19g7/U/OlHLtcvDE9YBjy1V
         n8D/NXnUXReVBBYpqCesVRsQgX3X+x6d+DT1rpRoWGXp26rHmk5gPwwh0AT0BL7iesK7
         isvg==
X-Forwarded-Encrypted: i=1; AJvYcCVGn0SvXTZa39AXUniwDFdoa94iXvYebFusIYravUsk6vaVp8zEhwDvcrvwC11fnR5X0Ff6BTYuDg4ySOk=@vger.kernel.org, AJvYcCVRe8Qoph0PFGFWutSrAW/GlwMcPweXUDapYbLEf4z9U1g4JxG6Klop3dGzN2Ci1nlNSVqiEEm9ikpM9Qo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQqF7Zq5Fdzs01CrfNK8Fz820XjhnIjzPrqTrXjs5QahaKLBez
	D8audVknnLbuIIEyN0zw7HXT+/GzfvpLjJNuFEMuQETlJ2ZBtxdIoXt8XG1djyKGsPyZlT4MFfF
	eheIRp7eqIhjCKUa+do0P3eI/r8k=
X-Google-Smtp-Source: AGHT+IFdO5S/Y8L92PGVYCZAgYyhjP2oGeM0AjzZypQ0eDHipMZjOizLQ0cgN+MFOVXRXbDityG0VwFKpcH8SUPhurs=
X-Received: by 2002:a05:6512:12d2:b0:533:4784:6aec with SMTP id
 2adb3069b0e04-5389ef21ed2mr1708061e87.27.1727461132851; Fri, 27 Sep 2024
 11:18:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240927134620.2081991-1-lizhi.xu@windriver.com> <20240927151900.2596508-1-lizhi.xu@windriver.com>
In-Reply-To: <20240927151900.2596508-1-lizhi.xu@windriver.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 28 Sep 2024 03:18:36 +0900
Message-ID: <CAKFNMok4U8OTVDV0YFDUGotsShSZKST532snzL3fQBVFcUL9TQ@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: add ratelimiting to nilfs2 message
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: syzbot+8a192e8d090fa9a31135@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 28, 2024 at 12:19=E2=80=AFAM Lizhi Xu wrote:
>
> Syzbot report a task hung in vcs_open.
> When rec_len too small in nilfs_check_folio, it can result in a huge floo=
d
> of messages being sent to the console. It eventually caused tty to hung w=
hen
> retrieving the console_lock().
>
> Reported-by: syzbot+8a192e8d090fa9a31135@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D8a192e8d090fa9a31135
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>  fs/nilfs2/dir.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)

Thank you for the patch.

I could confirm that the problem is reproducible and that your patch
prevents it, so I will treat this as a nilfs2 side issue.

The patch seems somewhat straightforward, so let me review this a bit
more.  I may ask you to make some changes.

Thanks,
Ryusuke Konishi

>
> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> index fe5b1a30c509..0a89dda75414 100644
> --- a/fs/nilfs2/dir.c
> +++ b/fs/nilfs2/dir.c
> @@ -32,6 +32,7 @@
>  #include <linux/pagemap.h>
>  #include "nilfs.h"
>  #include "page.h"
> +#include <linux/ratelimit.h>
>
>  static inline unsigned int nilfs_rec_len_from_disk(__le16 dlen)
>  {
> @@ -115,6 +116,7 @@ static bool nilfs_check_folio(struct folio *folio, ch=
ar *kaddr)
>         size_t limit =3D folio_size(folio);
>         struct nilfs_dir_entry *p;
>         char *error;
> +       static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL * 5,=
 1);
>
>         if (dir->i_size < folio_pos(folio) + limit) {
>                 limit =3D dir->i_size - folio_pos(folio);
> @@ -148,9 +150,11 @@ static bool nilfs_check_folio(struct folio *folio, c=
har *kaddr)
>         /* Too bad, we had an error */
>
>  Ebadsize:
> -       nilfs_error(sb,
> -                   "size of directory #%lu is not a multiple of chunk si=
ze",
> -                   dir->i_ino);
> +       if (__ratelimit(&rs)) {
> +               nilfs_error(sb,
> +                           "size of directory #%lu is not a multiple of =
chunk size",
> +                           dir->i_ino);
> +       }
>         goto fail;
>  Eshort:
>         error =3D "rec_len is smaller than minimal";
> @@ -167,18 +171,22 @@ static bool nilfs_check_folio(struct folio *folio, =
char *kaddr)
>  Einumber:
>         error =3D "disallowed inode number";
>  bad_entry:
> -       nilfs_error(sb,
> +       if (__ratelimit(&rs)) {
> +               nilfs_error(sb,
>                     "bad entry in directory #%lu: %s - offset=3D%lu, inod=
e=3D%lu, rec_len=3D%zd, name_len=3D%d",
>                     dir->i_ino, error, (folio->index << PAGE_SHIFT) + off=
s,
>                     (unsigned long)le64_to_cpu(p->inode),
>                     rec_len, p->name_len);
> +       }
>         goto fail;
>  Eend:
>         p =3D (struct nilfs_dir_entry *)(kaddr + offs);
> -       nilfs_error(sb,
> -                   "entry in directory #%lu spans the page boundary offs=
et=3D%lu, inode=3D%lu",
> -                   dir->i_ino, (folio->index << PAGE_SHIFT) + offs,
> -                   (unsigned long)le64_to_cpu(p->inode));
> +       if (__ratelimit(&rs)) {
> +               nilfs_error(sb,
> +                           "entry in directory #%lu spans the page bound=
ary offset=3D%lu, inode=3D%lu",
> +                           dir->i_ino, (folio->index << PAGE_SHIFT) + of=
fs,
> +                           (unsigned long)le64_to_cpu(p->inode));
> +       }
>  fail:
>         return false;
>  }
> --
> 2.43.0
>
