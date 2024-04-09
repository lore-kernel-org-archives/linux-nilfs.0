Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4384813A3F8
	for <linux-nilfs@vger.kernel.org>; Tue,  9 Apr 2024 19:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712690054; cv=none; b=gcGX0Z9zfJeQNBIVJv2o8p9pLeB5egl9rSJ9ofv3EMBFxnckjRKNNW2RzEt5H5KxWaJMdlRFYWwFuA7Y8XdnpEbCGrXdTQ9V4ViDvcgwcxeIOzvihstYeaOgrQZuDHVINJeBYfIUYPX8b7w/siRUDBckL4jO9qDdBqnULmExVXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712690054; c=relaxed/simple;
	bh=KJx1f+VYWwCxmaBm7L+ySNz5SLhUyEBYRcxfFnl9t4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TvFcTgjYNt4LsN2k7oAiYrOr1o0i/KQlrH6vxhXvHtV9g/El5J1aZ5euDQMH1rzuHde6bzjP6Cio9lhznxQ4n8blWHgH2kFl6N4gp9k/erhfUUoo/bY7Vjv78+A5barsp8hPeDy42kMaIXGFwTi+TFIXwBW+tv+g7uo/+enseJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzWsetwp; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzWsetwp"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-617ddc988f5so48401437b3.2
        for <linux-nilfs@vger.kernel.org>; Tue, 09 Apr 2024 12:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712690051; x=1713294851; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSThqLPsJpUVypDsFaov/MkGmKUWvCXKUEDIDbU4N9Q=;
        b=RzWsetwpZEoHF+YbEMCLzyhZba65yVZxqpUiizzlSV7gfqG3x68fy9Wa5i5IL7tMiW
         dvBNfT02udtQjcxrs/XS/JNSjJ7x9XAsa2XMUbRVe4kWdNGDm6xLeX7faVOOzJX6Asuf
         kgFZCnuQuInxbM4uYf/nMI/4N0UlUcAP3NKuEzNrh93kDDXm/NzKMpriP/g8hpk8n/0G
         7OwRUHL0NOS91ns44UkO4GTOf153RFvjrb168hRvFEsIplmSSiUkLm0I9NqHhHGwdcc5
         bjxrvq3HmINHFDFN7hAMYMDEWPRYBPOcp9+JYKYaPN52oOF5d08H6YLll8dpBrWK5hvg
         0aZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712690051; x=1713294851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jSThqLPsJpUVypDsFaov/MkGmKUWvCXKUEDIDbU4N9Q=;
        b=aYl8BmS/waqxFh9oMj3G4JhxJqqrDu4WpyNaFodVLO3R3TOz+hUtXEY2rgZtxuWiHx
         5/5MPBaYpS2WReoSHMkVzTlMenJS4M0RjFegKoskXGr0lXihIgJzARtiwUYynV3ERymj
         hg1ZfsdTR0SlYLv0dB6h0zE4UsPyscGtX6KJb/lKcaGuhydahhlqYAjVRCsdZSNQW/ic
         doe7vp1Ox7wgNKA3iP2Icu/GxA73fAWvR4aXB6vjinERyIOrbwFoI7il8qR5sAXsaV/l
         Xnh5wZHiq1lckTZsGjk0FagFiXGataC+J7NKFRtYrsR65mU28i3iy9tbIcDOt4BJoyR2
         OOhg==
X-Gm-Message-State: AOJu0YwlbIHKCXQ47WxP2owS9MgyDUrHhTnun/pqTP+DHgO/g0OGYZas
	Z6TzTeHBsCH5tnKPQf+zH9sfZuMNSAdQdUKumqHQc044q01NlG6HSK0U/d24QGnUhIBxOMfieIu
	oBMa9MNB7gpT+9K1vTg8TPoiSbZXylnL0oMs=
X-Google-Smtp-Source: AGHT+IFO0LSXBemyExxdi4sYUrEEbichjrckIxMKZ+pJAseCkgDl0cQh8Hkx4cl7F4fGxGgyZ+b+6zDj6LlIUSSQGJQ=
X-Received: by 2002:a25:af10:0:b0:dcb:38d3:3c6a with SMTP id
 a16-20020a25af10000000b00dcb38d33c6amr618634ybh.46.1712690051013; Tue, 09 Apr
 2024 12:14:11 -0700 (PDT)
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
Date: Wed, 10 Apr 2024 04:13:51 +0900
Message-ID: <CAKFNMonx-qZPUn6-qCFGbiFd06K-3bjsHyaw+rw_uq3YU_m=9w@mail.gmail.com>
Subject: Re: [PATCH V2] nilfs2: convert to use the new mount API
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for waiting.  I've finished the full review.

I'll comment below, inline.
First let me say that this patch is great and I don't see any points
that need major rewrites.

Regarding style warnings, I will reply to that email later.

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
>
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index 2e29b98ba8ba..f4d367295d38 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -335,8 +335,8 @@ void __nilfs_error(struct super_block *sb, const char=
 *function,
>
>  extern struct nilfs_super_block *
>  nilfs_read_super_block(struct super_block *, u64, int, struct buffer_hea=
d **);
> -extern int nilfs_store_magic_and_option(struct super_block *,
> -                                       struct nilfs_super_block *, char =
*);
> +extern int nilfs_store_magic(struct super_block *,
> +                            struct nilfs_super_block *);
>  extern int nilfs_check_feature_compatibility(struct super_block *,
>                                              struct nilfs_super_block *);
>  extern void nilfs_set_log_cursor(struct nilfs_super_block *,
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index ac24ed109ce9..0a87637e0bc2 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -29,7 +29,8 @@
>  #include <linux/slab.h>
>  #include <linux/init.h>
>  #include <linux/blkdev.h>
> -#include <linux/parser.h>
> +#include <linux/fs_context.h>
> +#include <linux/fs_parser.h>
>  #include <linux/crc32.h>
>  #include <linux/vfs.h>
>  #include <linux/writeback.h>
> @@ -61,7 +62,6 @@ struct kmem_cache *nilfs_segbuf_cachep;
>  struct kmem_cache *nilfs_btree_path_cache;
>
>  static int nilfs_setup_super(struct super_block *sb, int is_mount);
> -static int nilfs_remount(struct super_block *sb, int *flags, char *data)=
;
>
>  void __nilfs_msg(struct super_block *sb, const char *fmt, ...)
>  {
> @@ -702,105 +702,94 @@ static const struct super_operations nilfs_sops =
=3D {
>         .freeze_fs      =3D nilfs_freeze,
>         .unfreeze_fs    =3D nilfs_unfreeze,
>         .statfs         =3D nilfs_statfs,
> -       .remount_fs     =3D nilfs_remount,
>         .show_options =3D nilfs_show_options
>  };
>
>  enum {
> -       Opt_err_cont, Opt_err_panic, Opt_err_ro,
> -       Opt_barrier, Opt_nobarrier, Opt_snapshot, Opt_order, Opt_norecove=
ry,
> -       Opt_discard, Opt_nodiscard, Opt_err,
> +       Opt_err, Opt_barrier, Opt_snapshot, Opt_order, Opt_norecovery,
> +       Opt_discard,
>  };
>
> -static match_table_t tokens =3D {
> -       {Opt_err_cont, "errors=3Dcontinue"},
> -       {Opt_err_panic, "errors=3Dpanic"},
> -       {Opt_err_ro, "errors=3Dremount-ro"},
> -       {Opt_barrier, "barrier"},
> -       {Opt_nobarrier, "nobarrier"},
> -       {Opt_snapshot, "cp=3D%u"},
> -       {Opt_order, "order=3D%s"},
> -       {Opt_norecovery, "norecovery"},
> -       {Opt_discard, "discard"},
> -       {Opt_nodiscard, "nodiscard"},
> -       {Opt_err, NULL}
> +static const struct constant_table nilfs_param_err[] =3D {
> +       {"continue",    NILFS_MOUNT_ERRORS_CONT},
> +       {"panic",       NILFS_MOUNT_ERRORS_PANIC},
> +       {"remount-ro",  NILFS_MOUNT_ERRORS_RO},
> +       {}
>  };
>
> -static int parse_options(char *options, struct super_block *sb, int is_r=
emount)
> -{
> -       struct the_nilfs *nilfs =3D sb->s_fs_info;
> -       char *p;
> -       substring_t args[MAX_OPT_ARGS];
> -
> -       if (!options)
> -               return 1;
> -
> -       while ((p =3D strsep(&options, ",")) !=3D NULL) {
> -               int token;
> +const struct fs_parameter_spec nilfs_param_spec[] =3D {
> +       fsparam_enum    ("errors", Opt_err, nilfs_param_err),
> +       fsparam_flag_no ("barrier", Opt_barrier),

> +       fsparam_u32     ("cp", Opt_snapshot),

Checkpoint numbers require a 64-bit unsigned integer parser
(originally parsed by kstrtoull()), so I think you should use
fsparam_u64 here.
Since nilfs_parse_param() was written assuming fsparam_u64, I guess
this is a simple mistake.

Also, "nilfs_param_spec" is not declared with the "static" class
specifier, so could you please add it ?

> +       fsparam_string  ("order", Opt_order),
> +       fsparam_flag    ("norecovery", Opt_norecovery),
> +       fsparam_flag_no ("discard", Opt_discard),
> +       {}
> +};
>
> -               if (!*p)
> -                       continue;
> +struct nilfs_fs_context {
> +       unsigned long ns_mount_opt;
> +       __u64 cno;
> +};
>
> -               token =3D match_token(p, tokens, args);
> -               switch (token) {
> -               case Opt_barrier:
> -                       nilfs_set_opt(nilfs, BARRIER);
> -                       break;
> -               case Opt_nobarrier:
> +static int nilfs_parse_param(struct fs_context *fc, struct fs_parameter =
*param)
> +{
> +       struct nilfs_fs_context *nilfs =3D fc->fs_private;
> +       int is_remount =3D fc->purpose =3D=3D FS_CONTEXT_FOR_RECONFIGURE;
> +       struct fs_parse_result result;
> +       int opt;
> +
> +       opt =3D fs_parse(fc, nilfs_param_spec, param, &result);
> +       if (opt < 0)
> +               return opt;
> +
> +       switch (opt) {
> +       case Opt_barrier:
> +               if (result.negated)
>                         nilfs_clear_opt(nilfs, BARRIER);
> -                       break;
> -               case Opt_order:
> -                       if (strcmp(args[0].from, "relaxed") =3D=3D 0)
> -                               /* Ordered data semantics */
> -                               nilfs_clear_opt(nilfs, STRICT_ORDER);
> -                       else if (strcmp(args[0].from, "strict") =3D=3D 0)
> -                               /* Strict in-order semantics */
> -                               nilfs_set_opt(nilfs, STRICT_ORDER);
> -                       else
> -                               return 0;
> -                       break;
> -               case Opt_err_panic:
> -                       nilfs_write_opt(nilfs, ERROR_MODE, ERRORS_PANIC);
> -                       break;
> -               case Opt_err_ro:
> -                       nilfs_write_opt(nilfs, ERROR_MODE, ERRORS_RO);
> -                       break;
> -               case Opt_err_cont:
> -                       nilfs_write_opt(nilfs, ERROR_MODE, ERRORS_CONT);
> -                       break;
> -               case Opt_snapshot:
> -                       if (is_remount) {
> -                               nilfs_err(sb,
> -                                         "\"%s\" option is invalid for r=
emount",
> -                                         p);
> -                               return 0;
> -                       }
> -                       break;
> -               case Opt_norecovery:
> -                       nilfs_set_opt(nilfs, NORECOVERY);
> -                       break;
> -               case Opt_discard:
> -                       nilfs_set_opt(nilfs, DISCARD);
> -                       break;
> -               case Opt_nodiscard:
> -                       nilfs_clear_opt(nilfs, DISCARD);
> -                       break;
> -               default:
> -                       nilfs_err(sb, "unrecognized mount option \"%s\"",=
 p);
> -                       return 0;
> +               else
> +                       nilfs_set_opt(nilfs, BARRIER);
> +               break;
> +       case Opt_order:
> +               if (strcmp(param->string, "relaxed") =3D=3D 0)
> +                       /* Ordered data semantics */
> +                       nilfs_clear_opt(nilfs, STRICT_ORDER);
> +               else if (strcmp(param->string, "strict") =3D=3D 0)
> +                       /* Strict in-order semantics */
> +                       nilfs_set_opt(nilfs, STRICT_ORDER);
> +               else
> +                       return -EINVAL;
> +               break;
> +       case Opt_err:
> +               nilfs->ns_mount_opt &=3D ~NILFS_MOUNT_ERROR_MODE;
> +               nilfs->ns_mount_opt |=3D result.uint_32;
> +               break;
> +       case Opt_snapshot:
> +               if (is_remount) {
> +                       struct super_block *sb =3D fc->root->d_sb;
> +                       nilfs_err(sb,
> +                                 "\"%s\" option is invalid for remount",
> +                                 param->key);
> +                       return -EINVAL;
>                 }

> +               if (result.uint_64 =3D=3D 0)
> +                       return -EINVAL;

For the case where the "cp=3D0" invalid option is specified, could you
please output the following error message with nilfs_err() as before ?

   "invalid option \"cp=3D0\": invalid checkpoint number 0"

Other similar messages seem to overlap with the message output by
fs_parser routines, so I think just adding this one is sufficient.


> +               nilfs->cno =3D result.uint_64;
> +               break;
> +       case Opt_norecovery:
> +               nilfs_set_opt(nilfs, NORECOVERY);
> +               break;
> +       case Opt_discard:
> +               if (result.negated)
> +                       nilfs_clear_opt(nilfs, DISCARD);
> +               else
> +                       nilfs_set_opt(nilfs, DISCARD);
> +               break;
> +       default:
> +               return -EINVAL;
>         }
> -       return 1;
> -}
>
> -static inline void
> -nilfs_set_default_options(struct super_block *sb,
> -                         struct nilfs_super_block *sbp)
> -{
> -       struct the_nilfs *nilfs =3D sb->s_fs_info;
> -
> -       nilfs->ns_mount_opt =3D
> -               NILFS_MOUNT_ERRORS_RO | NILFS_MOUNT_BARRIER;
> +       return 0;
>  }
>
>  static int nilfs_setup_super(struct super_block *sb, int is_mount)
> @@ -857,9 +846,8 @@ struct nilfs_super_block *nilfs_read_super_block(stru=
ct super_block *sb,
>         return (struct nilfs_super_block *)((char *)(*pbh)->b_data + offs=
et);
>  }
>
> -int nilfs_store_magic_and_option(struct super_block *sb,
> -                                struct nilfs_super_block *sbp,
> -                                char *data)
> +int nilfs_store_magic(struct super_block *sb,
> +                     struct nilfs_super_block *sbp)
>  {
>         struct the_nilfs *nilfs =3D sb->s_fs_info;
>
> @@ -870,14 +858,12 @@ int nilfs_store_magic_and_option(struct super_block=
 *sb,
>         sb->s_flags |=3D SB_NOATIME;
>  #endif
>
> -       nilfs_set_default_options(sb, sbp);
> -
>         nilfs->ns_resuid =3D le16_to_cpu(sbp->s_def_resuid);
>         nilfs->ns_resgid =3D le16_to_cpu(sbp->s_def_resgid);
>         nilfs->ns_interval =3D le32_to_cpu(sbp->s_c_interval);
>         nilfs->ns_watermark =3D le32_to_cpu(sbp->s_c_block_max);
>
> -       return !parse_options(data, sb, 0) ? -EINVAL : 0;
> +       return 0;
>  }
>
>  int nilfs_check_feature_compatibility(struct super_block *sb,
> @@ -1042,10 +1028,11 @@ int nilfs_checkpoint_is_mounted(struct super_bloc=
k *sb, __u64 cno)
>   * So, the recovery process is protected from other simultaneous mounts.
>   */
>  static int
> -nilfs_fill_super(struct super_block *sb, void *data, int silent)
> +nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
>  {
>         struct the_nilfs *nilfs;
>         struct nilfs_root *fsroot;
> +       struct nilfs_fs_context *ctx =3D fc->fs_private;
>         __u64 cno;
>         int err;
>
> @@ -1055,10 +1042,13 @@ nilfs_fill_super(struct super_block *sb, void *da=
ta, int silent)
>
>         sb->s_fs_info =3D nilfs;
>
> -       err =3D init_nilfs(nilfs, sb, (char *)data);
> +       err =3D init_nilfs(nilfs, sb);
>         if (err)
>                 goto failed_nilfs;
>
> +       /* Copy in parsed mount options */
> +       nilfs->ns_mount_opt =3D ctx->ns_mount_opt;
> +
>         sb->s_op =3D &nilfs_sops;
>         sb->s_export_op =3D &nilfs_export_ops;
>         sb->s_root =3D NULL;
> @@ -1117,21 +1107,15 @@ nilfs_fill_super(struct super_block *sb, void *da=
ta, int silent)
>         return err;
>  }
>
> -static int nilfs_remount(struct super_block *sb, int *flags, char *data)
> +static int nilfs_reconfigure(struct fs_context *fc)
>  {
> +       struct nilfs_fs_context *ctx =3D fc->fs_private;
> +       struct super_block *sb =3D fc->root->d_sb;
>         struct the_nilfs *nilfs =3D sb->s_fs_info;
> -       unsigned long old_sb_flags;
> -       unsigned long old_mount_opt;
>         int err;
>
>         sync_filesystem(sb);
> -       old_sb_flags =3D sb->s_flags;
> -       old_mount_opt =3D nilfs->ns_mount_opt;
>
> -       if (!parse_options(data, sb, 1)) {
> -               err =3D -EINVAL;
> -               goto restore_opts;
> -       }

>         sb->s_flags =3D (sb->s_flags & ~SB_POSIXACL);

This "s_flags" adjustment overlaps with the flag adjustment just
before returning with normal status.
I think there is no problem with deleting this.

>
>         err =3D -EINVAL;
> @@ -1139,12 +1123,11 @@ static int nilfs_remount(struct super_block *sb, =
int *flags, char *data)
>         if (!nilfs_valid_fs(nilfs)) {
>                 nilfs_warn(sb,
>                            "couldn't remount because the filesystem is in=
 an incomplete recovery state");
> -               goto restore_opts;
> +               goto ignore_opts;
>         }
> -
> -       if ((bool)(*flags & SB_RDONLY) =3D=3D sb_rdonly(sb))
> +       if ((bool)(fc->sb_flags & SB_RDONLY) =3D=3D sb_rdonly(sb))
>                 goto out;
> -       if (*flags & SB_RDONLY) {
> +       if (fc->sb_flags & SB_RDONLY) {
>                 sb->s_flags |=3D SB_RDONLY;
>
>                 /*
> @@ -1172,7 +1155,7 @@ static int nilfs_remount(struct super_block *sb, in=
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
> @@ -1180,130 +1163,57 @@ static int nilfs_remount(struct super_block *sb,=
 int *flags, char *data)
>                 root =3D NILFS_I(d_inode(sb->s_root))->i_root;

>                 err =3D nilfs_attach_log_writer(sb, root);
>                 if (err)
> -                       goto restore_opts;
> +                       goto ignore_opts;

Here, if nilfs_attach_log_writer() fails, it will return via
"ignore_opts" without restoring the SB_RDONLY flag in sb->s_flags.
I think it is necessary to repair the flag only for this error path,
what do you think?

>
>                 down_write(&nilfs->ns_sem);
>                 nilfs_setup_super(sb, true);
>                 up_write(&nilfs->ns_sem);
>         }
>   out:
> -       return 0;
> -
> - restore_opts:
> -       sb->s_flags =3D old_sb_flags;
> -       nilfs->ns_mount_opt =3D old_mount_opt;
> -       return err;
> -}
> -
> -struct nilfs_super_data {
> -       __u64 cno;
> -       int flags;
> -};
> -
> -static int nilfs_parse_snapshot_option(const char *option,
> -                                      const substring_t *arg,
> -                                      struct nilfs_super_data *sd)
> -{
> -       unsigned long long val;
> -       const char *msg =3D NULL;
> -       int err;
> -
> -       if (!(sd->flags & SB_RDONLY)) {
> -               msg =3D "read-only option is not specified";
> -               goto parse_error;
> -       }
> -
> -       err =3D kstrtoull(arg->from, 0, &val);
> -       if (err) {
> -               if (err =3D=3D -ERANGE)
> -                       msg =3D "too large checkpoint number";
> -               else
> -                       msg =3D "malformed argument";
> -               goto parse_error;
> -       } else if (val =3D=3D 0) {
> -               msg =3D "invalid checkpoint number 0";
> -               goto parse_error;
> -       }
> -       sd->cno =3D val;
> -       return 0;
> -
> -parse_error:
> -       nilfs_err(NULL, "invalid option \"%s\": %s", option, msg);
> -       return 1;
> -}
> -
> -/**
> - * nilfs_identify - pre-read mount options needed to identify mount inst=
ance
> - * @data: mount options
> - * @sd: nilfs_super_data
> - */
> -static int nilfs_identify(char *data, struct nilfs_super_data *sd)
> -{
> -       char *p, *options =3D data;
> -       substring_t args[MAX_OPT_ARGS];
> -       int token;
> -       int ret =3D 0;
> -
> -       do {
> -               p =3D strsep(&options, ",");
> -               if (p !=3D NULL && *p) {
> -                       token =3D match_token(p, tokens, args);
> -                       if (token =3D=3D Opt_snapshot)
> -                               ret =3D nilfs_parse_snapshot_option(p, &a=
rgs[0],
> -                                                                 sd);
> -               }
> -               if (!options)
> -                       break;
> -               BUG_ON(options =3D=3D data);
> -               *(options - 1) =3D ',';
> -       } while (!ret);
> -       return ret;
> -}
> +       sb->s_flags =3D (sb->s_flags & ~SB_POSIXACL);
> +       /* Copy over parsed remount options */
> +       nilfs->ns_mount_opt =3D ctx->ns_mount_opt;
>
> -static int nilfs_set_bdev_super(struct super_block *s, void *data)
> -{
> -       s->s_dev =3D *(dev_t *)data;
>         return 0;
> -}
>
> -static int nilfs_test_bdev_super(struct super_block *s, void *data)
> -{
> -       return !(s->s_iflags & SB_I_RETIRED) && s->s_dev =3D=3D *(dev_t *=
)data;
> + ignore_opts:
> +       return err;
>  }
>
> -static struct dentry *
> -nilfs_mount(struct file_system_type *fs_type, int flags,
> -            const char *dev_name, void *data)
> +static int
> +nilfs_get_tree(struct fs_context *fc)
>  {
> -       struct nilfs_super_data sd =3D { .flags =3D flags };
> +       struct nilfs_fs_context *ctx =3D fc->fs_private;
>         struct super_block *s;
>         dev_t dev;
>         int err;
>
> -       if (nilfs_identify(data, &sd))
> -               return ERR_PTR(-EINVAL);

> +       if (ctx->cno && !(fc->sb_flags & SB_RDONLY)) {
> +               nilfs_err(s, "invalid option \"cn=3D%llu\", "
> +                       "read-only option is not specified",
> +                       ctx->cno);
> +               return -EINVAL;
> +       }

This error check conversion (to check after the read-only flag is
determined) is ok.
But, the option name in the error message has changed, so please correct it=
.
The original message looks like

  "invalid option \"cp=3D%llu\": read-only option is not specified"

The checkpoint number expression cannot be reproduced to be exactly
the same as the input (as in the case where the radix is specified
like "cp=3D0x123") but I think it's acceptable.


That's all for the non-style issue comments.

Thanks,
Ryusuke Konishi

>
> -       err =3D lookup_bdev(dev_name, &dev);
> +       err =3D lookup_bdev(fc->source, &dev);
>         if (err)
> -               return ERR_PTR(err);
> +               return err;
>
> -       s =3D sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, =
flags,
> -                &dev);
> +       s =3D sget_dev(fc, dev);
>         if (IS_ERR(s))
> -               return ERR_CAST(s);
> +               return PTR_ERR(s);
>
>         if (!s->s_root) {
> -               err =3D setup_bdev_super(s, flags, NULL);
> +               err =3D setup_bdev_super(s, fc->sb_flags, fc);
>                 if (!err)
> -                       err =3D nilfs_fill_super(s, data,
> -                                              flags & SB_SILENT ? 1 : 0)=
;
> +                       err =3D nilfs_fill_super(s, fc);
>                 if (err)
>                         goto failed_super;
>
>                 s->s_flags |=3D SB_ACTIVE;
> -       } else if (!sd.cno) {
> +       } else if (!ctx->cno) {
>                 if (nilfs_tree_is_busy(s->s_root)) {
> -                       if ((flags ^ s->s_flags) & SB_RDONLY) {
> +                       if ((fc->sb_flags ^ s->s_flags) & SB_RDONLY) {
>                                 nilfs_err(s,
>                                           "the device already has a %s mo=
unt.",
>                                           sb_rdonly(s) ? "read-only" : "r=
ead/write");
> @@ -1315,34 +1225,65 @@ nilfs_mount(struct file_system_type *fs_type, int=
 flags,
>                          * Try remount to setup mount states if the curre=
nt
>                          * tree is not mounted and only snapshots use thi=
s sb.
>                          */
> -                       err =3D nilfs_remount(s, &flags, data);
> +                       fc->root =3D s->s_root;
> +                       err =3D nilfs_reconfigure(fc);
>                         if (err)
>                                 goto failed_super;
>                 }
>         }
>
> -       if (sd.cno) {
> +       if (ctx->cno) {
>                 struct dentry *root_dentry;
>
> -               err =3D nilfs_attach_snapshot(s, sd.cno, &root_dentry);
> +               err =3D nilfs_attach_snapshot(s, ctx->cno, &root_dentry);
>                 if (err)
>                         goto failed_super;
> -               return root_dentry;
> +               fc->root =3D root_dentry;
> +               return 0;
>         }
>
> -       return dget(s->s_root);
> +       fc->root =3D dget(s->s_root);
> +       return 0;
>
>   failed_super:
>         deactivate_locked_super(s);
> -       return ERR_PTR(err);
> +       return err;
> +}
> +
> +static void nilfs_free_fc(struct fs_context *fc)
> +{
> +       kfree(fc->fs_private);
> +}
> +
> +static const struct fs_context_operations nilfs_context_ops =3D {
> +       .parse_param    =3D nilfs_parse_param,
> +       .get_tree       =3D nilfs_get_tree,
> +       .reconfigure    =3D nilfs_reconfigure,
> +       .free           =3D nilfs_free_fc,
> +};
> +
> +static int nilfs_init_fs_context(struct fs_context *fc)
> +{
> +       struct nilfs_fs_context *ctx;
> +
> +       ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL);
> +       if (!ctx)
> +               return -ENOMEM;
> +
> +       ctx->ns_mount_opt =3D NILFS_MOUNT_ERRORS_RO | NILFS_MOUNT_BARRIER=
;
> +       fc->fs_private =3D ctx;
> +       fc->ops =3D &nilfs_context_ops;
> +
> +       return 0;
>  }
>
>  struct file_system_type nilfs_fs_type =3D {
>         .owner    =3D THIS_MODULE,
>         .name     =3D "nilfs2",
> -       .mount    =3D nilfs_mount,
>         .kill_sb  =3D kill_block_super,
>         .fs_flags =3D FS_REQUIRES_DEV,
> +       .init_fs_context =3D nilfs_init_fs_context,
> +       .parameters =3D nilfs_param_spec,
>  };
>  MODULE_ALIAS_FS("nilfs2");
>
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 2ae2c1bbf6d1..77fce1f509d1 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -668,7 +668,7 @@ static int nilfs_load_super_block(struct the_nilfs *n=
ilfs,
>   * Return Value: On success, 0 is returned. On error, a negative error
>   * code is returned.
>   */
> -int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *da=
ta)
> +int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
>  {
>         struct nilfs_super_block *sbp;
>         int blocksize;
> @@ -686,7 +686,7 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_=
block *sb, char *data)
>         if (err)
>                 goto out;
>
> -       err =3D nilfs_store_magic_and_option(sb, sbp, data);
> +       err =3D nilfs_store_magic(sb, sbp);
>         if (err)
>                 goto failed_sbh;
>
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index cd4ae1b8ae16..85da0629415d 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -219,10 +219,6 @@ THE_NILFS_FNS(PURGING, purging)
>  #define nilfs_set_opt(nilfs, opt)  \
>         ((nilfs)->ns_mount_opt |=3D NILFS_MOUNT_##opt)
>  #define nilfs_test_opt(nilfs, opt) ((nilfs)->ns_mount_opt & NILFS_MOUNT_=
##opt)
> -#define nilfs_write_opt(nilfs, mask, opt)                              \
> -       ((nilfs)->ns_mount_opt =3D                                       =
 \
> -               (((nilfs)->ns_mount_opt & ~NILFS_MOUNT_##mask) |        \
> -                NILFS_MOUNT_##opt))                                    \
>
>  /**
>   * struct nilfs_root - nilfs root object
> @@ -276,7 +272,7 @@ static inline int nilfs_sb_will_flip(struct the_nilfs=
 *nilfs)
>  void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
>  struct the_nilfs *alloc_nilfs(struct super_block *sb);
>  void destroy_nilfs(struct the_nilfs *nilfs);
> -int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *da=
ta);
> +int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb);
>  int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb);
>  unsigned long nilfs_nrsvsegs(struct the_nilfs *nilfs, unsigned long nseg=
s);
>  void nilfs_set_nsegments(struct the_nilfs *nilfs, unsigned long nsegs);
>
