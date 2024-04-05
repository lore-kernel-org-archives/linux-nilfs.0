Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA971CD18
	for <linux-nilfs@vger.kernel.org>; Fri,  5 Apr 2024 03:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712286041; cv=none; b=Ij7IXO727QQvxnhhvgosa1MAXqvs4DyIh4pdRMQkAy3MVuKAmb+BNHwLaZrwCxrrcD75O9NVyiOHIwvZnOKej3K9EfB6kKmFUA4aAzCZLEnTZOY7fjvcl2QcosZRRvOtq0sZ79svy1q6W+sdfW31HpRDJxLj/cbtsg0/uqvNmhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712286041; c=relaxed/simple;
	bh=TkIfuY9rG1auJ1UnD+cDvTpYE3RH1pHA0lP5jkz6hr8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=lKdVJtb+kNRgafXXTU9p0+bNgkOz/OoqautijyrITlgjJTKKmB8OwuM2SB/8nxIyMKYnRlSH3liCfGXvstdh0TAPEgt+9jBIQ7ZZl0dUzBeOgdEJi5Pluj9eri7fLm7Qd4UwGMi8l6Q6eqj8CUM0owk9EMHQw7isGVN7gOhjKAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dz6m81m3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dz6m81m3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712286037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P3aAdjks8dpPaJFiPmXLEgde5tG2AAzRM9FNdE2GMEg=;
	b=Dz6m81m3ijHovYB1rsw7sZmRUsz083y3gCDOj7hhp9YZHzgfbcK46t/5zhrFtAzKT/gFXp
	sX8GA2AkdQSkB3x8yiv8dN5XgrC23yzT3UsV0/3G+oKZ7BTkOlE1/c1XWdwhk9YRnfwZwj
	crO1DQvq9quO10TU0C5Z0viGyio0bxE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-v1LMwRtHPUq2TQQkKwX5iQ-1; Thu, 04 Apr 2024 23:00:34 -0400
X-MC-Unique: v1LMwRtHPUq2TQQkKwX5iQ-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7cbf2ff0e33so167819039f.1
        for <linux-nilfs@vger.kernel.org>; Thu, 04 Apr 2024 20:00:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712286033; x=1712890833;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P3aAdjks8dpPaJFiPmXLEgde5tG2AAzRM9FNdE2GMEg=;
        b=EFJTYJzcccweD9LJKGyiK+Na0uDSHAuGYrYSVgCdiznbuAf3eUdg+WQbxSdmuDaDbz
         WKICrUN5UdIH/0XNB+2NhRrkVhcoQIYjnYs4g3hr4R6CPacaNOldKIUFZFQBFTbj3hSK
         VBDg4WEkou9Rbx4omfZ5bZ3Wu1elpnZMgSKsx90gVQTRr0xXpstHW0u3Cb6xq0yos3kh
         2GEz7ZFqzpmT0HPnxe5cYtIc4VWxKtATaHyABdvjjscRiNOJGzGVjfhpuYvtG2Bnk3Fq
         28kf7a5KFgmQiB+2TI7mW7V8nFQgprTiHzvurrd7eTSz0HqWPx0c+Yvem9ojxEB7Y+0a
         5BCg==
X-Gm-Message-State: AOJu0Yy4Hi/CQryfoJEdeneS+1IZcwPmZR+2CFGEudMuJgCFekOYMo1W
	NgbpueK8yJLzNxgdIjjRBD4U8LRg6yPAykHScMHrK/+KG4fQ9SgxxmnIdhrlnJpCMCwCBE5OlBz
	XgtZ+stiCNxENeweJjOPh36VQkqxX9Qi5yVjAZSQQhGalHWGUjPJ0Q1NyvWOVI15V53+N
X-Received: by 2002:a5e:df47:0:b0:7d3:3e0d:fa1b with SMTP id g7-20020a5edf47000000b007d33e0dfa1bmr145357ioq.12.1712286033105;
        Thu, 04 Apr 2024 20:00:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhfFUhdm7cs8GhkEctIe8jVWQlB1iA6fLZQpaKSNPvIyBw9hzlX2AgbsU12qBKWbs1AUf8eg==
X-Received: by 2002:a5e:df47:0:b0:7d3:3e0d:fa1b with SMTP id g7-20020a5edf47000000b007d33e0dfa1bmr145348ioq.12.1712286032756;
        Thu, 04 Apr 2024 20:00:32 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id bb14-20020a0566383b0e00b0047ed39e61adsm313007jab.35.2024.04.04.20.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 20:00:32 -0700 (PDT)
Message-ID: <1ba497be-64cb-4a4d-99a8-16707da32cc4@redhat.com>
Date: Thu, 4 Apr 2024 22:00:30 -0500
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH V2] nilfs2: convert to use the new mount API
From: Eric Sandeen <sandeen@redhat.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
References: <e282e150-2bc1-4b6a-8aa1-0417371c2671@redhat.com>
 <CAKFNMo=bbdBsW2xvTMiZcrD37n8MWmDfhH7V2jKZ14=odduRXg@mail.gmail.com>
 <f99b0c44-c5b4-4e0b-892b-dd9793a80f9a@redhat.com>
 <CAKFNMokYkO-WsvrcZh=-FpR=LtCQnsyxET3ZjSzx-o5zXcMU9g@mail.gmail.com>
 <2fd47dc7-e130-4c67-b39a-b1c38aa1c500@redhat.com>
 <0d26ef52-91bd-4108-bf09-5d92fa58cd28@redhat.com>
Content-Language: en-US
In-Reply-To: <0d26ef52-91bd-4108-bf09-5d92fa58cd28@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Fix call to nilfs2_reconfigure() in nilfs_mount() to ensure
fc->root is set.

Clean up some extraneous comments and whitespace

This one passes your current test script.

Thanks,
-Eric

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 2e29b98ba8ba..f4d367295d38 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -335,8 +335,8 @@ void __nilfs_error(struct super_block *sb, const char *function,
 
 extern struct nilfs_super_block *
 nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
-extern int nilfs_store_magic_and_option(struct super_block *,
-					struct nilfs_super_block *, char *);
+extern int nilfs_store_magic(struct super_block *,
+			     struct nilfs_super_block *);
 extern int nilfs_check_feature_compatibility(struct super_block *,
 					     struct nilfs_super_block *);
 extern void nilfs_set_log_cursor(struct nilfs_super_block *,
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index ac24ed109ce9..0a87637e0bc2 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -29,7 +29,8 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
-#include <linux/parser.h>
+#include <linux/fs_context.h>
+#include <linux/fs_parser.h>
 #include <linux/crc32.h>
 #include <linux/vfs.h>
 #include <linux/writeback.h>
@@ -61,7 +62,6 @@ struct kmem_cache *nilfs_segbuf_cachep;
 struct kmem_cache *nilfs_btree_path_cache;
 
 static int nilfs_setup_super(struct super_block *sb, int is_mount);
-static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
 void __nilfs_msg(struct super_block *sb, const char *fmt, ...)
 {
@@ -702,105 +702,94 @@ static const struct super_operations nilfs_sops = {
 	.freeze_fs	= nilfs_freeze,
 	.unfreeze_fs	= nilfs_unfreeze,
 	.statfs         = nilfs_statfs,
-	.remount_fs     = nilfs_remount,
 	.show_options = nilfs_show_options
 };
 
 enum {
-	Opt_err_cont, Opt_err_panic, Opt_err_ro,
-	Opt_barrier, Opt_nobarrier, Opt_snapshot, Opt_order, Opt_norecovery,
-	Opt_discard, Opt_nodiscard, Opt_err,
+	Opt_err, Opt_barrier, Opt_snapshot, Opt_order, Opt_norecovery,
+	Opt_discard,
 };
 
-static match_table_t tokens = {
-	{Opt_err_cont, "errors=continue"},
-	{Opt_err_panic, "errors=panic"},
-	{Opt_err_ro, "errors=remount-ro"},
-	{Opt_barrier, "barrier"},
-	{Opt_nobarrier, "nobarrier"},
-	{Opt_snapshot, "cp=%u"},
-	{Opt_order, "order=%s"},
-	{Opt_norecovery, "norecovery"},
-	{Opt_discard, "discard"},
-	{Opt_nodiscard, "nodiscard"},
-	{Opt_err, NULL}
+static const struct constant_table nilfs_param_err[] = {
+	{"continue",	NILFS_MOUNT_ERRORS_CONT},
+	{"panic",	NILFS_MOUNT_ERRORS_PANIC},
+	{"remount-ro",	NILFS_MOUNT_ERRORS_RO},
+	{}
 };
 
-static int parse_options(char *options, struct super_block *sb, int is_remount)
-{
-	struct the_nilfs *nilfs = sb->s_fs_info;
-	char *p;
-	substring_t args[MAX_OPT_ARGS];
-
-	if (!options)
-		return 1;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		int token;
+const struct fs_parameter_spec nilfs_param_spec[] = {
+	fsparam_enum	("errors", Opt_err, nilfs_param_err),
+	fsparam_flag_no	("barrier", Opt_barrier),
+	fsparam_u32	("cp", Opt_snapshot),
+	fsparam_string	("order", Opt_order),
+	fsparam_flag	("norecovery", Opt_norecovery),
+	fsparam_flag_no	("discard", Opt_discard),
+	{}
+};
 
-		if (!*p)
-			continue;
+struct nilfs_fs_context {
+	unsigned long ns_mount_opt;
+	__u64 cno;
+};
 
-		token = match_token(p, tokens, args);
-		switch (token) {
-		case Opt_barrier:
-			nilfs_set_opt(nilfs, BARRIER);
-			break;
-		case Opt_nobarrier:
+static int nilfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct nilfs_fs_context *nilfs = fc->fs_private;
+	int is_remount = fc->purpose == FS_CONTEXT_FOR_RECONFIGURE;
+	struct fs_parse_result result;
+	int opt;
+
+	opt = fs_parse(fc, nilfs_param_spec, param, &result);
+	if (opt < 0)
+		return opt;
+
+	switch (opt) {
+	case Opt_barrier:
+		if (result.negated)
 			nilfs_clear_opt(nilfs, BARRIER);
-			break;
-		case Opt_order:
-			if (strcmp(args[0].from, "relaxed") == 0)
-				/* Ordered data semantics */
-				nilfs_clear_opt(nilfs, STRICT_ORDER);
-			else if (strcmp(args[0].from, "strict") == 0)
-				/* Strict in-order semantics */
-				nilfs_set_opt(nilfs, STRICT_ORDER);
-			else
-				return 0;
-			break;
-		case Opt_err_panic:
-			nilfs_write_opt(nilfs, ERROR_MODE, ERRORS_PANIC);
-			break;
-		case Opt_err_ro:
-			nilfs_write_opt(nilfs, ERROR_MODE, ERRORS_RO);
-			break;
-		case Opt_err_cont:
-			nilfs_write_opt(nilfs, ERROR_MODE, ERRORS_CONT);
-			break;
-		case Opt_snapshot:
-			if (is_remount) {
-				nilfs_err(sb,
-					  "\"%s\" option is invalid for remount",
-					  p);
-				return 0;
-			}
-			break;
-		case Opt_norecovery:
-			nilfs_set_opt(nilfs, NORECOVERY);
-			break;
-		case Opt_discard:
-			nilfs_set_opt(nilfs, DISCARD);
-			break;
-		case Opt_nodiscard:
-			nilfs_clear_opt(nilfs, DISCARD);
-			break;
-		default:
-			nilfs_err(sb, "unrecognized mount option \"%s\"", p);
-			return 0;
+		else
+			nilfs_set_opt(nilfs, BARRIER);
+		break;
+	case Opt_order:
+		if (strcmp(param->string, "relaxed") == 0)
+			/* Ordered data semantics */
+			nilfs_clear_opt(nilfs, STRICT_ORDER);
+		else if (strcmp(param->string, "strict") == 0)
+			/* Strict in-order semantics */
+			nilfs_set_opt(nilfs, STRICT_ORDER);
+		else
+			return -EINVAL;
+		break;
+	case Opt_err:
+		nilfs->ns_mount_opt &= ~NILFS_MOUNT_ERROR_MODE;
+		nilfs->ns_mount_opt |= result.uint_32;
+		break;
+	case Opt_snapshot:
+		if (is_remount) {
+			struct super_block *sb = fc->root->d_sb;
+			nilfs_err(sb,
+				  "\"%s\" option is invalid for remount",
+				  param->key);
+			return -EINVAL;
 		}
+		if (result.uint_64 == 0)
+			return -EINVAL;
+		nilfs->cno = result.uint_64;
+		break;
+	case Opt_norecovery:
+		nilfs_set_opt(nilfs, NORECOVERY);
+		break;
+	case Opt_discard:
+		if (result.negated)
+			nilfs_clear_opt(nilfs, DISCARD);
+		else
+			nilfs_set_opt(nilfs, DISCARD);
+		break;
+	default:
+		return -EINVAL;
 	}
-	return 1;
-}
 
-static inline void
-nilfs_set_default_options(struct super_block *sb,
-			  struct nilfs_super_block *sbp)
-{
-	struct the_nilfs *nilfs = sb->s_fs_info;
-
-	nilfs->ns_mount_opt =
-		NILFS_MOUNT_ERRORS_RO | NILFS_MOUNT_BARRIER;
+	return 0;
 }
 
 static int nilfs_setup_super(struct super_block *sb, int is_mount)
@@ -857,9 +846,8 @@ struct nilfs_super_block *nilfs_read_super_block(struct super_block *sb,
 	return (struct nilfs_super_block *)((char *)(*pbh)->b_data + offset);
 }
 
-int nilfs_store_magic_and_option(struct super_block *sb,
-				 struct nilfs_super_block *sbp,
-				 char *data)
+int nilfs_store_magic(struct super_block *sb,
+		      struct nilfs_super_block *sbp)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
 
@@ -870,14 +858,12 @@ int nilfs_store_magic_and_option(struct super_block *sb,
 	sb->s_flags |= SB_NOATIME;
 #endif
 
-	nilfs_set_default_options(sb, sbp);
-
 	nilfs->ns_resuid = le16_to_cpu(sbp->s_def_resuid);
 	nilfs->ns_resgid = le16_to_cpu(sbp->s_def_resgid);
 	nilfs->ns_interval = le32_to_cpu(sbp->s_c_interval);
 	nilfs->ns_watermark = le32_to_cpu(sbp->s_c_block_max);
 
-	return !parse_options(data, sb, 0) ? -EINVAL : 0;
+	return 0;
 }
 
 int nilfs_check_feature_compatibility(struct super_block *sb,
@@ -1042,10 +1028,11 @@ int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno)
  * So, the recovery process is protected from other simultaneous mounts.
  */
 static int
-nilfs_fill_super(struct super_block *sb, void *data, int silent)
+nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct the_nilfs *nilfs;
 	struct nilfs_root *fsroot;
+	struct nilfs_fs_context *ctx = fc->fs_private;
 	__u64 cno;
 	int err;
 
@@ -1055,10 +1042,13 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_fs_info = nilfs;
 
-	err = init_nilfs(nilfs, sb, (char *)data);
+	err = init_nilfs(nilfs, sb);
 	if (err)
 		goto failed_nilfs;
 
+	/* Copy in parsed mount options */
+	nilfs->ns_mount_opt = ctx->ns_mount_opt;
+
 	sb->s_op = &nilfs_sops;
 	sb->s_export_op = &nilfs_export_ops;
 	sb->s_root = NULL;
@@ -1117,21 +1107,15 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	return err;
 }
 
-static int nilfs_remount(struct super_block *sb, int *flags, char *data)
+static int nilfs_reconfigure(struct fs_context *fc)
 {
+	struct nilfs_fs_context *ctx = fc->fs_private;
+	struct super_block *sb = fc->root->d_sb;
 	struct the_nilfs *nilfs = sb->s_fs_info;
-	unsigned long old_sb_flags;
-	unsigned long old_mount_opt;
 	int err;
 
 	sync_filesystem(sb);
-	old_sb_flags = sb->s_flags;
-	old_mount_opt = nilfs->ns_mount_opt;
 
-	if (!parse_options(data, sb, 1)) {
-		err = -EINVAL;
-		goto restore_opts;
-	}
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL);
 
 	err = -EINVAL;
@@ -1139,12 +1123,11 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	if (!nilfs_valid_fs(nilfs)) {
 		nilfs_warn(sb,
 			   "couldn't remount because the filesystem is in an incomplete recovery state");
-		goto restore_opts;
+		goto ignore_opts;
 	}
-
-	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
+	if ((bool)(fc->sb_flags & SB_RDONLY) == sb_rdonly(sb))
 		goto out;
-	if (*flags & SB_RDONLY) {
+	if (fc->sb_flags & SB_RDONLY) {
 		sb->s_flags |= SB_RDONLY;
 
 		/*
@@ -1172,7 +1155,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 				   "couldn't remount RDWR because of unsupported optional features (%llx)",
 				   (unsigned long long)features);
 			err = -EROFS;
-			goto restore_opts;
+			goto ignore_opts;
 		}
 
 		sb->s_flags &= ~SB_RDONLY;
@@ -1180,130 +1163,57 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		root = NILFS_I(d_inode(sb->s_root))->i_root;
 		err = nilfs_attach_log_writer(sb, root);
 		if (err)
-			goto restore_opts;
+			goto ignore_opts;
 
 		down_write(&nilfs->ns_sem);
 		nilfs_setup_super(sb, true);
 		up_write(&nilfs->ns_sem);
 	}
  out:
-	return 0;
-
- restore_opts:
-	sb->s_flags = old_sb_flags;
-	nilfs->ns_mount_opt = old_mount_opt;
-	return err;
-}
-
-struct nilfs_super_data {
-	__u64 cno;
-	int flags;
-};
-
-static int nilfs_parse_snapshot_option(const char *option,
-				       const substring_t *arg,
-				       struct nilfs_super_data *sd)
-{
-	unsigned long long val;
-	const char *msg = NULL;
-	int err;
-
-	if (!(sd->flags & SB_RDONLY)) {
-		msg = "read-only option is not specified";
-		goto parse_error;
-	}
-
-	err = kstrtoull(arg->from, 0, &val);
-	if (err) {
-		if (err == -ERANGE)
-			msg = "too large checkpoint number";
-		else
-			msg = "malformed argument";
-		goto parse_error;
-	} else if (val == 0) {
-		msg = "invalid checkpoint number 0";
-		goto parse_error;
-	}
-	sd->cno = val;
-	return 0;
-
-parse_error:
-	nilfs_err(NULL, "invalid option \"%s\": %s", option, msg);
-	return 1;
-}
-
-/**
- * nilfs_identify - pre-read mount options needed to identify mount instance
- * @data: mount options
- * @sd: nilfs_super_data
- */
-static int nilfs_identify(char *data, struct nilfs_super_data *sd)
-{
-	char *p, *options = data;
-	substring_t args[MAX_OPT_ARGS];
-	int token;
-	int ret = 0;
-
-	do {
-		p = strsep(&options, ",");
-		if (p != NULL && *p) {
-			token = match_token(p, tokens, args);
-			if (token == Opt_snapshot)
-				ret = nilfs_parse_snapshot_option(p, &args[0],
-								  sd);
-		}
-		if (!options)
-			break;
-		BUG_ON(options == data);
-		*(options - 1) = ',';
-	} while (!ret);
-	return ret;
-}
+	sb->s_flags = (sb->s_flags & ~SB_POSIXACL);
+	/* Copy over parsed remount options */
+	nilfs->ns_mount_opt = ctx->ns_mount_opt;
 
-static int nilfs_set_bdev_super(struct super_block *s, void *data)
-{
-	s->s_dev = *(dev_t *)data;
 	return 0;
-}
 
-static int nilfs_test_bdev_super(struct super_block *s, void *data)
-{
-	return !(s->s_iflags & SB_I_RETIRED) && s->s_dev == *(dev_t *)data;
+ ignore_opts:
+	return err;
 }
 
-static struct dentry *
-nilfs_mount(struct file_system_type *fs_type, int flags,
-	     const char *dev_name, void *data)
+static int
+nilfs_get_tree(struct fs_context *fc)
 {
-	struct nilfs_super_data sd = { .flags = flags };
+	struct nilfs_fs_context *ctx = fc->fs_private;
 	struct super_block *s;
 	dev_t dev;
 	int err;
 
-	if (nilfs_identify(data, &sd))
-		return ERR_PTR(-EINVAL);
+	if (ctx->cno && !(fc->sb_flags & SB_RDONLY)) {
+		nilfs_err(s, "invalid option \"cn=%llu\", "
+			"read-only option is not specified",
+			ctx->cno);
+		return -EINVAL;
+	}
 
-	err = lookup_bdev(dev_name, &dev);
+	err = lookup_bdev(fc->source, &dev);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
-	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, flags,
-		 &dev);
+	s = sget_dev(fc, dev);
 	if (IS_ERR(s))
-		return ERR_CAST(s);
+		return PTR_ERR(s);
 
 	if (!s->s_root) {
-		err = setup_bdev_super(s, flags, NULL);
+		err = setup_bdev_super(s, fc->sb_flags, fc);
 		if (!err)
-			err = nilfs_fill_super(s, data,
-					       flags & SB_SILENT ? 1 : 0);
+			err = nilfs_fill_super(s, fc);
 		if (err)
 			goto failed_super;
 
 		s->s_flags |= SB_ACTIVE;
-	} else if (!sd.cno) {
+	} else if (!ctx->cno) {
 		if (nilfs_tree_is_busy(s->s_root)) {
-			if ((flags ^ s->s_flags) & SB_RDONLY) {
+			if ((fc->sb_flags ^ s->s_flags) & SB_RDONLY) {
 				nilfs_err(s,
 					  "the device already has a %s mount.",
 					  sb_rdonly(s) ? "read-only" : "read/write");
@@ -1315,34 +1225,65 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 			 * Try remount to setup mount states if the current
 			 * tree is not mounted and only snapshots use this sb.
 			 */
-			err = nilfs_remount(s, &flags, data);
+			fc->root = s->s_root;
+			err = nilfs_reconfigure(fc);
 			if (err)
 				goto failed_super;
 		}
 	}
 
-	if (sd.cno) {
+	if (ctx->cno) {
 		struct dentry *root_dentry;
 
-		err = nilfs_attach_snapshot(s, sd.cno, &root_dentry);
+		err = nilfs_attach_snapshot(s, ctx->cno, &root_dentry);
 		if (err)
 			goto failed_super;
-		return root_dentry;
+		fc->root = root_dentry;
+		return 0;
 	}
 
-	return dget(s->s_root);
+	fc->root = dget(s->s_root);
+	return 0;
 
  failed_super:
 	deactivate_locked_super(s);
-	return ERR_PTR(err);
+	return err;
+}
+
+static void nilfs_free_fc(struct fs_context *fc)
+{
+	kfree(fc->fs_private);
+}
+
+static const struct fs_context_operations nilfs_context_ops = {
+	.parse_param	= nilfs_parse_param,
+	.get_tree	= nilfs_get_tree,
+	.reconfigure	= nilfs_reconfigure,
+	.free		= nilfs_free_fc,
+};
+
+static int nilfs_init_fs_context(struct fs_context *fc)
+{
+	struct nilfs_fs_context *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->ns_mount_opt = NILFS_MOUNT_ERRORS_RO | NILFS_MOUNT_BARRIER;
+	fc->fs_private = ctx;
+	fc->ops = &nilfs_context_ops;
+
+	return 0;
 }
 
 struct file_system_type nilfs_fs_type = {
 	.owner    = THIS_MODULE,
 	.name     = "nilfs2",
-	.mount    = nilfs_mount,
 	.kill_sb  = kill_block_super,
 	.fs_flags = FS_REQUIRES_DEV,
+	.init_fs_context = nilfs_init_fs_context,
+	.parameters = nilfs_param_spec,
 };
 MODULE_ALIAS_FS("nilfs2");
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 2ae2c1bbf6d1..77fce1f509d1 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -668,7 +668,7 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
  * Return Value: On success, 0 is returned. On error, a negative error
  * code is returned.
  */
-int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
+int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 {
 	struct nilfs_super_block *sbp;
 	int blocksize;
@@ -686,7 +686,7 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	if (err)
 		goto out;
 
-	err = nilfs_store_magic_and_option(sb, sbp, data);
+	err = nilfs_store_magic(sb, sbp);
 	if (err)
 		goto failed_sbh;
 
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index cd4ae1b8ae16..85da0629415d 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -219,10 +219,6 @@ THE_NILFS_FNS(PURGING, purging)
 #define nilfs_set_opt(nilfs, opt)  \
 	((nilfs)->ns_mount_opt |= NILFS_MOUNT_##opt)
 #define nilfs_test_opt(nilfs, opt) ((nilfs)->ns_mount_opt & NILFS_MOUNT_##opt)
-#define nilfs_write_opt(nilfs, mask, opt)				\
-	((nilfs)->ns_mount_opt =					\
-		(((nilfs)->ns_mount_opt & ~NILFS_MOUNT_##mask) |	\
-		 NILFS_MOUNT_##opt))					\
 
 /**
  * struct nilfs_root - nilfs root object
@@ -276,7 +272,7 @@ static inline int nilfs_sb_will_flip(struct the_nilfs *nilfs)
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
 struct the_nilfs *alloc_nilfs(struct super_block *sb);
 void destroy_nilfs(struct the_nilfs *nilfs);
-int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data);
+int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb);
 int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb);
 unsigned long nilfs_nrsvsegs(struct the_nilfs *nilfs, unsigned long nsegs);
 void nilfs_set_nsegments(struct the_nilfs *nilfs, unsigned long nsegs);

