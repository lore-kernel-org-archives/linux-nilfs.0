Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120AE137778
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Apr 2024 20:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713557551; cv=none; b=N8Or5hw8aXLbb6QjYnPtihxvqa7k7VodRIEkP2F7uId5B340BY/6vMur5kMdRzBqDxaAaJ5EzpEBihw/kr3452JXkiCBc+sZZh2Ac0vzjmddvNZuXyvKHSOEJGm0iTi5xp804gSoEpgPInMpqaHXv/il8sCx4ubcXQVNcnneD1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713557551; c=relaxed/simple;
	bh=WsYrRhz+9JGf//9kdBri1E6sa3wRf4CMpbZqE812vug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ElAftmxPmnoc2++45l54Ap1zaBV2/wUqfjUUH+D3zNyLsNu3zSjpyyb9YyOZqUi7u8/rbJTfZubuQLRtWWw8kfuDu+/9Gg2SJInSCHflKOb28MhdANLZ6ZC5y0tAaQH2fhFaxO/fxWudPQiL3Pge9KpE98rEh/Loj+3/cgsmzHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QX0cD1BY; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QX0cD1BY"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2d8b194341eso24432081fa.3
        for <linux-nilfs@vger.kernel.org>; Fri, 19 Apr 2024 13:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713557548; x=1714162348; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXvDY0Ew6gbeK1kUnroAmfTLmyF0eAff9c9ykjDLam4=;
        b=QX0cD1BYHsmhW69WHwlHtm/4NlvgOXX5Lgkw6WMxfajp1ohstCasBgHFHiaXbKkQqf
         OVWQksqiMpg2muSfnN5i0bl9KrGlk3cPXXcyW2HCXylZushuLz2SJTICrCUySrJCBdPQ
         DhMJ5pC8hf2Cv+JEzqy0JaIYCIHnDSn2Up18XZNYiBNj0FCMBG3wjMn6SamDWGBzPpL4
         /eaiszGtTTzEOATzfeBP+KLoOL6Q58yCWEsU3ed7EBfg/ZomXZxBj/n+pekpNU/Mtnl1
         oP8KEf0lxN+G1sSfF10bcTU9shCvnT0k/4e7xxKkkNQaJ/frOKjUjprjuQ76Q2/EWYMz
         MiLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713557548; x=1714162348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GXvDY0Ew6gbeK1kUnroAmfTLmyF0eAff9c9ykjDLam4=;
        b=M8x2uUaN3quCy83v0ysi6Vai3QJrFRry4MgIHnPH2760SyA03cFkTIg6z3kBA2GP95
         S7ZYJ4azcWa2EVmGiHEGghKOyE5hYPPY6ZpkQXjxYXdtkjFNrNFFf6NP1QT+2Exx1L5O
         sZ8AgJRuME9EnEpA35ZCO31RWYD+TTnl9/GFsReTnYRSn2Ue2JS3mb9UQebRtap/uKe6
         xM3EX0zti2DDGeAmlYxCVLUQ4LDnUvNvtj3sUbDijy13G5HCLZfErsDS2EVrM/QgYG6S
         /0mm7vgIQMrMF1gT0n66FojDlqQ8WjK1BYF0m6N/MJREBUSFpXJmNDiK9NT6n8LaTkbB
         x8MA==
X-Gm-Message-State: AOJu0YxlNK6bqChDBrClP5itpBVQNk/a12Kog5MYwXFESffZ/VnhmUKx
	Z9mEmrbQN4mx+rLdfyhCpT/93jwFBradamGqhQDR0DxH64Eh8SfGcH0dFlmdVtnf//YXIls/owp
	4dQsXKHTmzcieAxMX1KSuOQb+p/0=
X-Google-Smtp-Source: AGHT+IGckSMnjNEzS6reiSuj7r+yfCvm+iU5O72B9jSbi8cFRUoiXvXxoG15FSZjjEQnFoIt8aCuJVARl2SZbmeQ7tE=
X-Received: by 2002:a05:651c:1039:b0:2dc:b04b:b3c0 with SMTP id
 w25-20020a05651c103900b002dcb04bb3c0mr1812177ljm.6.1713557547854; Fri, 19 Apr
 2024 13:12:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <33d078a7-9072-4d8e-a3a9-dec23d4191da@redhat.com>
In-Reply-To: <33d078a7-9072-4d8e-a3a9-dec23d4191da@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 20 Apr 2024 05:12:11 +0900
Message-ID: <CAKFNMokRBcoP8z8Y6m60bYb=Se9SSn3N459hE0KWAnN7tEop=g@mail.gmail.com>
Subject: Re: [PATCH V3] nilfs2: convert to use the new mount API
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 1:45=E2=80=AFAM Eric Sandeen wrote:
>
> Convert nilfs2 to use the new mount API.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> Sorry for the delay on resend, other work got in the way...
> This all paged out a bit but I think I addressed all of the review
> items. Thanks!
>
> V3:
> - Add identifiers to nilfs_store_magic() prototype
> - switch Opt_snapshot to use fsparam_u64 vs. fsparam_u32
> - add error message for invalid cp=3D0 case
> - remove early sb->s_flags change in nilfs2_reconfigure()
> - un-split error message string in nilfs_get_tree()
>

Thank you for the revised patch!

...
> +       case Opt_snapshot:
> +               if (is_remount) {
> +                       struct super_block *sb =3D fc->root->d_sb;
> +
> +                       nilfs_err(sb,
> +                                 "\"%s\" option is invalid for remount",
> +                                 param->key);
> +                       return -EINVAL;
> +               }
> +               if (result.uint_64 =3D=3D 0) {
> +                       nilfs_err(NULL,
> +                                 "invalid option \"cp=3D0\": invalid che=
ckpoint number 0");
> +                       return -EINVAL;

At first glance, I wondered why the nilfs_err() super_block instance
argument was NULL here, but I see, it can only be used by remount..

...
> @@ -1172,7 +1157,7 @@ static int nilfs_remount(struct super_block *sb, in=
t *flags, char *data)
>                                    "couldn't remount RDWR because of unsu=
pported optional features (%llx)",
>                                    (unsigned long long)features);
>                         err =3D -EROFS;
> -                       goto restore_opts;
> +                       goto ignore_opts;
>                 }
>
>                 sb->s_flags &=3D ~SB_RDONLY;
> @@ -1180,130 +1165,56 @@ static int nilfs_remount(struct super_block *sb,=
 int *flags, char *data)
>                 root =3D NILFS_I(d_inode(sb->s_root))->i_root;
>                 err =3D nilfs_attach_log_writer(sb, root);
>                 if (err)
> -                       goto restore_opts;
> +                       goto ignore_opts;
>
>                 down_write(&nilfs->ns_sem);
>                 nilfs_setup_super(sb, true);
>                 up_write(&nilfs->ns_sem);
>         }

There is still an issue where the SB_RDONLY flag on sb->s_flags is not
repaired in the error path of nilfs_attach_log_writer().

This seems to be the only essential issue remaining, so I can add the
following fix (safer one - drop the SB_RDONLY flag for
nilfs_attach_log_writer, call it, and repair the flag if it fails),
and send it upstream.
Is this okay?  Please let me know if you have any opinions.

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index a54fa43331f5..a8f03c860e87 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1164,8 +1164,10 @@ static int nilfs_reconfigure(struct fs_context *fc)

                root =3D NILFS_I(d_inode(sb->s_root))->i_root;
                err =3D nilfs_attach_log_writer(sb, root);
-               if (err)
+               if (err) {
+                       sb->s_flags |=3D SB_RDONLY;
                        goto ignore_opts;
+               }

                down_write(&nilfs->ns_sem);
                nilfs_setup_super(sb, true);


Thanks,
Ryusuke Konishi
