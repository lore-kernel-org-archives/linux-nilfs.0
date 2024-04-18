Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25AD16F855
	for <linux-nilfs@vger.kernel.org>; Thu, 18 Apr 2024 16:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713458735; cv=none; b=dmw69LNaReXPjUiHSlgrjV+rt1VsgFZtWQeOuvq+pk9lAU07IbS2eiRdEQZSi0QCOIzrW9Jccr+WXvma0EZjwgh1W9GNl7dEwXuHZ3kzXoQ5nrc55XTVeDgVESpaXX2fk9LFKUueDfnp/+y4sqXsXOEiNc4cyxs8tXuOY77t92M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713458735; c=relaxed/simple;
	bh=cCuYVxFViMcwjhsbb0Mh8e/EhkSSnQPwWWcxXcWjbrY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=MziYHbdlliqzfOj3YpdtwsL146SXfV58P1R9pb5qB9vZMID5PYIcQCDZfCLwfDe1uZFwHlU9jenWHvg2PJ+VPT9H46vN8hrrEN2Ht9aspqg71Q5a2tNZSWN/zRzOGSD1nkAIwZNFSCdfHeZmuGJc5pZaBJcbU/3xnXMCcoro4ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bn8lKn/O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bn8lKn/O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713458730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nhRebt6AK2eywN6X7uV2StArSJJKnkEar917shuIGZU=;
	b=bn8lKn/OPKIMKW9Jbh8w9gtjGDadsCY1FT8qMkWas2bz+14VZx3+3ytZm86rpEpCahj5yN
	WJkOerS6GWM0tiKwuz9oo5oWIhcxnavxZD9bTKcmZVN4Yc/LaAC92uH2pjx1KUSCee0B7X
	aRTp04r9yqJ6K4si4X/iUsqmNEhC42s=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-u9uf2-r3Oiu2XmtEzJ_0xQ-1; Thu, 18 Apr 2024 12:45:11 -0400
X-MC-Unique: u9uf2-r3Oiu2XmtEzJ_0xQ-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7da4278d33bso17487439f.1
        for <linux-nilfs@vger.kernel.org>; Thu, 18 Apr 2024 09:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713458703; x=1714063503;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nhRebt6AK2eywN6X7uV2StArSJJKnkEar917shuIGZU=;
        b=xGARO4eFhm/kGCfUz9mi/Vg5n6rPDsUtdfGOWww3kbFGS07OEZ6DP4GBC1LtlbN7k2
         mbbMFCv/7dC7jgwdH/n8kqNG+D31xLxW+E0rdR5zG1z5luhMWMzC7cRPDjhHCo7R8xY9
         8LonT7rfC+minL5DTeGNk0Aed+HQ+D9E2Xrs3yFdBQjEHja0NjUTupb75MSN21e/ceC9
         XSCdZjTngyFVUL3gDOsvUZdTcmwg5ISZpPRKBvZTUTaiDfMfSLl61uvKUGtco2TaHwAl
         KQcscuEQOPHqgwm22JnbDo8BkbX9yUwUVbp+J3UvQ2A0m53FUbwn2MEL441OpMkwEffZ
         OzBw==
X-Gm-Message-State: AOJu0Yx90Grt0azEpDKDzt7pWDbBqhd2ksezBFJn+AJ9AfY2/X38/bSY
	Zj5p3lB2vpRVFFHTjFcvOY+aE/JZMJyLbMK4wGSC21Vg9Yxumcfl/DV5PNV16yLPg45N28BAywI
	1JV5TUsEa5kSKRMoMfdwlSpGSh6bWBK4X2JqYw/rxSTCuNzq4pumpFFyoGGBbRwfijN1iy48/DQ
	VJYkpr8ZOF4TPPoPBW1Ct6c4r7S5Ab4kt+OupTgUNajBk=
X-Received: by 2002:a05:6602:258e:b0:7d6:9ba0:c0c9 with SMTP id p14-20020a056602258e00b007d69ba0c0c9mr4463679ioo.3.1713458702752;
        Thu, 18 Apr 2024 09:45:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGj0OgEwfTZI/3/0sYy2dYK1aM8yoJFW3ROjZoUCEPVEbBtoSDjHE1V24CDgUTdwZTO1p/gRQ==
X-Received: by 2002:a05:6602:258e:b0:7d6:9ba0:c0c9 with SMTP id p14-20020a056602258e00b007d69ba0c0c9mr4463650ioo.3.1713458702176;
        Thu, 18 Apr 2024 09:45:02 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id s20-20020a056638219400b00482b8b12872sm504286jaj.174.2024.04.18.09.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Apr 2024 09:45:01 -0700 (PDT)
Message-ID: <33d078a7-9072-4d8e-a3a9-dec23d4191da@redhat.com>
Date: Thu, 18 Apr 2024 11:45:00 -0500
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V3] nilfs2: convert to use the new mount API
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Convert nilfs2 to use the new mount API.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Sorry for the delay on resend, other work got in the way...
This all paged out a bit but I think I addressed all of the review
items. Thanks!

V3:
- Add identifiers to nilfs_store_magic() prototype
- switch Opt_snapshot to use fsparam_u64 vs. fsparam_u32
- add error message for invalid cp=0 case
- remove early sb->s_flags change in nilfs2_reconfigure()
- un-split error message string in nilfs_get_tree()

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 2e29b98ba8ba..728e90be3570 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -335,8 +335,8 @@ void __nilfs_error(struct super_block *sb, const char *function,
 
 extern struct nilfs_super_block *
 nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
-extern int nilfs_store_magic_and_option(struct super_block *,
-					struct nilfs_super_block *, char *);
+extern int nilfs_store_magic(struct super_block *sb,
+			     struct nilfs_super_block *sbp);
 extern int nilfs_check_feature_compatibility(struct super_block *,
 					     struct nilfs_super_block *);
 extern void nilfs_set_log_cursor(struct nilfs_super_block *,
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index ac24ed109ce9..a54fa43331f5 100644
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
@@ -702,105 +702,98 @@ static const struct super_operations nilfs_sops = {
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
+static const struct fs_parameter_spec nilfs_param_spec[] = {
+	fsparam_enum	("errors", Opt_err, nilfs_param_err),
+	fsparam_flag_no	("barrier", Opt_barrier),
+	fsparam_u64	("cp", Opt_snapshot),
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
+
+			nilfs_err(sb,
+				  "\"%s\" option is invalid for remount",
+				  param->key);
+			return -EINVAL;
+		}
+		if (result.uint_64 == 0) {
+			nilfs_err(NULL,
+				  "invalid option \"cp=0\": invalid checkpoint number 0");
+			return -EINVAL;
 		}
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
@@ -857,9 +850,8 @@ struct nilfs_super_block *nilfs_read_super_block(struct super_block *sb,
 	return (struct nilfs_super_block *)((char *)(*pbh)->b_data + offset);
 }
 
-int nilfs_store_magic_and_option(struct super_block *sb,
-				 struct nilfs_super_block *sbp,
-				 char *data)
+int nilfs_store_magic(struct super_block *sb,
+		      struct nilfs_super_block *sbp)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
 
@@ -870,14 +862,12 @@ int nilfs_store_magic_and_option(struct super_block *sb,
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
@@ -1042,10 +1032,11 @@ int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno)
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
 
@@ -1055,10 +1046,13 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 
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
@@ -1117,34 +1111,25 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
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
-
-	if (!parse_options(data, sb, 1)) {
-		err = -EINVAL;
-		goto restore_opts;
-	}
-	sb->s_flags = (sb->s_flags & ~SB_POSIXACL);
 
 	err = -EINVAL;
 
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
@@ -1172,7 +1157,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 				   "couldn't remount RDWR because of unsupported optional features (%llx)",
 				   (unsigned long long)features);
 			err = -EROFS;
-			goto restore_opts;
+			goto ignore_opts;
 		}
 
 		sb->s_flags &= ~SB_RDONLY;
@@ -1180,130 +1165,56 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
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
+		nilfs_err(s, "invalid option \"cp=%llu\", read-only option is not specified",
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
@@ -1315,34 +1226,65 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
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

