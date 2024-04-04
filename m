Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF46913473D
	for <linux-nilfs@vger.kernel.org>; Thu,  4 Apr 2024 20:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712261488; cv=none; b=kWV8C9oJaA7O1mVb9eEQZcvr5eUWedeDdEtIfNaEqSSEy4HGT7LUNaw4D8DDM9l6k9Jkcwz4gdTFex9w7LlhSdlG/IyRUSnwdOM+FAwNwFWiv3RYcGjZ+y+ZZdwPKSgvrhfqWqdw/Jn8fwQJAlwe9D9dEETxCuHW7jOdfkEBLEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712261488; c=relaxed/simple;
	bh=wA+M2VArWpLgZlY4pL782oiNTOHtIhe2OK2kMAEI2UQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=otudr9lCni8lIGlS8l6iAo/mDwEdiK87sugbCSZIinuwyezEjE4g+kHRV1UxkIre7cYLZvr+2zLk41AX8tRWfJO47mEYb8dn94oM6HnSGEzFwH10sp0+dgOn6lt/8IEq+phVUY6h3YeTWWpguc4nBvbEqNPc80ccKw92oxwKN+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RGXujeo/; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RGXujeo/"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d475b6609eso18047181fa.2
        for <linux-nilfs@vger.kernel.org>; Thu, 04 Apr 2024 13:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712261484; x=1712866284; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lhsh1ZMYBF0tcZFuxKvuIm3PLD1n59ftf/2Zl+VfC7E=;
        b=RGXujeo/rr/EfnLkg4QozyuQ8uNs0RcIYiNDStLC8H5dCgLf0dI5PpxjOm6qHRNbjD
         3npfplMgABEy5U4spmpBLQMF+1Ax9+zszqAHV0GepsdqVeWBxb3T7h426krXlTchDuIs
         J0DFXBk5h/2PSQA2QP8i3U9v+oLAZ87G5IILAxHLrLkhFjFIZ9w61o3tg6yN8heVZ1vr
         i4gONHSL2uLINeEy+mT2dkyKzE9UCJht2xSgWbW1uVhw9XRemqC4rdVMXE0KUXhPshd1
         gtOYLfy0GNVyT/LfWsDf619lXA6neR7VHGlRol7YrlgoBkx3O/EdQr4Xg4kcNhF4PxM/
         BXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712261484; x=1712866284;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lhsh1ZMYBF0tcZFuxKvuIm3PLD1n59ftf/2Zl+VfC7E=;
        b=l3s5QoQldLMqn/Y7JlVobzKqzEQMNeXq945pX6DIGxWtjfctIbwJyvO8S6NapA+z3g
         P+rwTVYlgvQ3LkiFRYv8kbdXMp3rGHXqlbBdiTDnptgtnmwwdDKp8M9xhD1M2djNgQEc
         kGvUE/096YHvHPFIA850tC3PJtxem0YkkTTIuDdpGnbK72EYhX+N31jF7VTBA4lxp/aD
         uwXOKt46RZTEadtjfy0NHNx7PwkhPfGPhLfMrzZwSAJtw3VD04bB/90ERCxqELk9m7uc
         QLoVtKg/8iSxMGlI6LTgsj6cp1tf/Nc45roSfgxovka/XOAF5qM7I2oW0HnoN5e8dDkf
         kRPg==
X-Gm-Message-State: AOJu0YzbLmWufsBnxWXmaoO4F07Kuug4suP31AU/9OtIVSv1dvfIjIT/
	/ahdGOqJ0d/in0WS9X7YsjmvRwAmPyMHWeXOxQbqk4fgOmsiT5LBddD+LSnMEkDMKaHjb7UOqC7
	D7ELGHaiL3KlO6+V8HD+7F4TM4resXI+emWY=
X-Google-Smtp-Source: AGHT+IFM4dtDBTBTYP1jjdWre4nY6w0cOqwZ2OdaKLi11aWOetD2hPszkVrQw66JMa3sEr5JZpaN6/bTrQyilNba/7g=
X-Received: by 2002:a2e:9110:0:b0:2d7:10a1:482a with SMTP id
 m16-20020a2e9110000000b002d710a1482amr330045ljg.31.1712261483411; Thu, 04 Apr
 2024 13:11:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e282e150-2bc1-4b6a-8aa1-0417371c2671@redhat.com>
In-Reply-To: <e282e150-2bc1-4b6a-8aa1-0417371c2671@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 5 Apr 2024 05:11:06 +0900
Message-ID: <CAKFNMo=bbdBsW2xvTMiZcrD37n8MWmDfhH7V2jKZ14=odduRXg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: convert to use the new mount API
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000007b5ac606154af1cd"

--0000000000007b5ac606154af1cd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 4, 2024 at 7:12=E2=80=AFAM Eric Sandeen wrote:
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> Note: This one was relatively more complex than others, so I would
> appreciate review and testing. Basic checks of mounts, various mount
> options, and snapshot mounts do seem to work. I may well have missed
> something though, as I am not very familiar with nilfs.
>
> You may want to look closely at the handling of case Opt_err: which
> no longer uses nilfs_write_opt() and open-codes the flag change, so
> that I can use the enum. If you'd prefer to make 3 independent
> Opt_err_XXXZ cases, that would be possible.
>
> If any of the other changes here are unclear, or problematic, please
> let me know.
>
> Thanks!
> -Eric

Hi Eric,

Thank you!  This is one of the modernizations that I thought I had to
do with nilfs2.

I'm planning on doing a full review later, but when I ran a mount
pattern test, the kernel restarted without any messages (probably
caused a panic), so I'll give you some quick feedback.

The mount pattern that caused the kernel to restart was a simultaneous
mount of the current tree and a snapshot, which occurred when the
snapshot was mounted and then the current tree was mounted.  Something
like below:

$ sudo losetup /dev/loop0 ./nilfs.iso
$ sudo mount -t nilfs2 -o ro,cp=3D38866 /dev/loop0 /mnt/snapshot
$ sudo mount -t nilfs2 /dev/loop0 /mnt/test
--> panic

Here, 38866 is the snapshot number that can be created with the
nilfs-utils "mkcp -s" command or "chcp" command, and the number can be
checked with "lscp -s".

I have placed the mount test script I used in the following location:

 https://github.com/konis/nilfs-test-tools/blob/main/test-nilfs-mount.sh

The panic occurred in test #17 of that script.

I'll also try to track what's going on.

Thanks,
Ryusuke Konishi

>
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index 98cffaf0ac12..46d8d628f739 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -334,8 +334,8 @@ void __nilfs_error(struct super_block *sb, const char=
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
> index df8674173b22..deaca772d1c7 100644
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
> @@ -723,105 +723,95 @@ static const struct super_operations nilfs_sops =
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
> +               /* in old API was handled elsewhere */
> +               if (is_remount) {
> +                       struct super_block *sb =3D fc->root->d_sb;
> +                       nilfs_err(sb,
> +                                 "\"%s\" option is invalid for remount",
> +                                 param->key);
> +                       return -EINVAL;
>                 }
> +               if (result.uint_64 =3D=3D 0)
> +                       return -EINVAL;
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
> @@ -878,9 +868,8 @@ struct nilfs_super_block *nilfs_read_super_block(stru=
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
> @@ -891,14 +880,12 @@ int nilfs_store_magic_and_option(struct super_block=
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
> @@ -1063,10 +1050,11 @@ int nilfs_checkpoint_is_mounted(struct super_bloc=
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
> @@ -1076,10 +1064,13 @@ nilfs_fill_super(struct super_block *sb, void *da=
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
> @@ -1138,21 +1129,15 @@ nilfs_fill_super(struct super_block *sb, void *da=
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
>
>         err =3D -EINVAL;
> @@ -1160,12 +1145,14 @@ static int nilfs_remount(struct super_block *sb, =
int *flags, char *data)
>         if (!nilfs_valid_fs(nilfs)) {
>                 nilfs_warn(sb,
>                            "couldn't remount because the filesystem is in=
 an incomplete recovery state");
> -               goto restore_opts;
> +               goto ignore_opts;
>         }
>
> -       if ((bool)(*flags & SB_RDONLY) =3D=3D sb_rdonly(sb))
> +       /* readonly unchanged */
> +       if ((bool)(fc->sb_flags & SB_RDONLY) =3D=3D sb_rdonly(sb))
>                 goto out;
> -       if (*flags & SB_RDONLY) {
> +
> +       if (fc->sb_flags & SB_RDONLY) {
>                 sb->s_flags |=3D SB_RDONLY;
>
>                 /*
> @@ -1193,7 +1180,7 @@ static int nilfs_remount(struct super_block *sb, in=
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
> @@ -1201,130 +1188,57 @@ static int nilfs_remount(struct super_block *sb,=
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
> @@ -1336,34 +1250,64 @@ nilfs_mount(struct file_system_type *fs_type, int=
 flags,
>                          * Try remount to setup mount states if the curre=
nt
>                          * tree is not mounted and only snapshots use thi=
s sb.
>                          */
> -                       err =3D nilfs_remount(s, &flags, data);
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
> index 71400496ed36..894d9a513eed 100644
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

--0000000000007b5ac606154af1cd
Content-Type: application/x-gzip; name="kconfig.gz"
Content-Disposition: attachment; filename="kconfig.gz"
Content-Transfer-Encoding: base64
Content-ID: <f_lulntro60>
X-Attachment-Id: f_lulntro60

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
--0000000000007b5ac606154af1cd--
