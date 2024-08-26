Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ECD19AA5F;
	Mon, 26 Aug 2024 17:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724694108; cv=none; b=qsmrdHtQFbMFAefskCcDLbx32taGRHa8PBYwrcBm6K/2BD+E6tMm0M0NoyGcY8Yv2DvxtTOHHaCtMc/xezxTh5WUpxMeruiQapv5K9diOAbrG8rYu181Irs72x2MX0W0oXW2P59qJ5JV9our+oR/fS1uAr2HIAcv1aQcPqPc+2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724694108; c=relaxed/simple;
	bh=v0gjB22Au6ZBffPsE+u+TBMr4uxhnaGhXcb+6IwJlYU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UHgE56QckgbEAp/88YPvRXDynpqca8F80KgipoE7Pc/cUh0gR0ZFpIse3Bl2OUXTiiWU8qlxpS36xVa/u24GM1jCQzsfbiX5fb72v4Vtn18CkMdrY20yb6udwOr1QEg9np3POGaX9hQvnQueO1z+CRh5VMLa+PSBZAOPBn2JrAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k41Qle4G; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k41Qle4G"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2021c08b95cso42425095ad.0;
        Mon, 26 Aug 2024 10:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724694106; x=1725298906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sxBPu0aX8e4MOrJfmUcokpiujmjulqV2zZPPRHbAgvU=;
        b=k41Qle4Gi74mWC3hFDbx81GAW949xtAaEJ/2SiIpu1JHM0BLHVfj/hZ+1e/eqy5pdU
         +0LEfiaODVwiyTTxkBCyg30tSFj+dZjHv67eobBprDEI6s4f2Wu6bVs1rAKrhN/w2oYh
         BSXK8Q7DxgLy/yQ6AvOhBnnw9b6IN67QiCrR7CTqoyu7LAEFxtuYVJinsEgkLT9YfXz2
         DxFE5SfC40DBpcI53rsjQVEn28S/QR3Moi/hQ9HD4qglgeinfV8kqmTchD4G2l4t8y8e
         57Va1x5U2vp739Bum42F8ILpzyxQjcS7qLG/GpdoguuXVkToZxH7mIrF8/eFhN3HVRJV
         rMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724694106; x=1725298906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sxBPu0aX8e4MOrJfmUcokpiujmjulqV2zZPPRHbAgvU=;
        b=fmpThJ2N7xgjN1y2DxhJKx+ATp1kJ7wucaKin6ruHXOO95qhruUISdazUrOm73HIWc
         1g7f+meLjogMgcKsGWvTWwip52UpHBYKKIHdDgbMqu9gjX52Dkgx3NHfBs4xWQ0lWv64
         1rVpX3/uPV7ZzjwzKVV9t6+UjDnsujO0ZwP5Jpy3VY4IAxUu7zlQcC9MmDM4xVjo2aEw
         oXz7iLFUR7MItirF22FFR78OWv1S11kr9WHKKUA+Y+Ei61nuNkZm+0paUgEQCuw1ex1+
         h5JdjVj2TFaRhD03MIJZ+2ae5LBdj3xsS71iLJuGkcKuYJDaiR6OjGFeT1+AIZspawPh
         CgrA==
X-Forwarded-Encrypted: i=1; AJvYcCUuVPS7DIZ/pgXCXdLw8t7i4NGRAkXRqq72aawweHTeuUW3a3Dxn9Tt4An13Ls/YoZqyuvdhg5IVw2Hsmw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeSKO43gbmCA6KTfMPdikqWfw7SgFSI1K/H7ZhxmoIOPu6o1C3
	G5De5KTy217zETtcIX938xq2KC01CNawocRWIAmJYtJC5XEL3+ZKxX3Hfw==
X-Google-Smtp-Source: AGHT+IE5X+eC/iQDQoLxS2D0z0jqiOyhoF5w9vM9hw7jhYsB3Mdvm47CVzZXkq1KS6NYpCfTPJ4bQw==
X-Received: by 2002:a17:902:c713:b0:1fd:6ca4:f987 with SMTP id d9443c01a7336-204ddd25f60mr4450335ad.15.1724694105501;
        Mon, 26 Aug 2024 10:41:45 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855665besm70057055ad.34.2024.08.26.10.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 10:41:44 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] nilfs2: use kthread_create and kthread_stop for the log writer thread
Date: Tue, 27 Aug 2024 02:41:15 +0900
Message-Id: <20240826174116.5008-8-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240826174116.5008-1-konishi.ryusuke@gmail.com>
References: <20240826174116.5008-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

By using kthread_create() and kthread_stop() to start and stop the log
writer thread, eliminate custom thread start and stop helpers, as well
as the wait queue "sc_wait_task" on the "nilfs_sc_info" struct and
NILFS_SEGCTOR_QUIT flag that exist only to implement them.

Also, update the kernel doc comments of the changed functions as
appropriate.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/segment.c | 82 +++++++++++++++++----------------------------
 fs/nilfs2/segment.h |  3 --
 2 files changed, 31 insertions(+), 54 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 225f61ef66e7..013262ab5169 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2630,11 +2630,15 @@ static int nilfs_segctor_flush_mode(struct nilfs_sc_info *sci)
 }
 
 /**
- * nilfs_segctor_thread - main loop of the segment constructor thread.
+ * nilfs_segctor_thread - main loop of the log writer thread
  * @arg: pointer to a struct nilfs_sc_info.
  *
- * nilfs_segctor_thread() initializes a timer and serves as a daemon
- * to execute segment constructions.
+ * nilfs_segctor_thread() is the main loop function of the log writer kernel
+ * thread, which determines whether log writing is necessary, and if so,
+ * performs the log write in the background, or waits if not.  It is also
+ * used to decide the background writeback of the superblock.
+ *
+ * Return: Always 0.
  */
 static int nilfs_segctor_thread(void *arg)
 {
@@ -2642,11 +2646,6 @@ static int nilfs_segctor_thread(void *arg)
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int timeout = 0;
 
-	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
-
-	/* start sync. */
-	sci->sc_task = current;
-	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_start_thread() */
 	nilfs_info(sci->sc_super,
 		   "segctord starting. Construction interval = %lu seconds, CP frequency < %lu seconds",
 		   sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
@@ -2657,7 +2656,7 @@ static int nilfs_segctor_thread(void *arg)
 	for (;;) {
 		int mode;
 
-		if (sci->sc_state & NILFS_SEGCTOR_QUIT)
+		if (kthread_should_stop())
 			goto end_thread;
 
 		if (timeout || sci->sc_seq_request != sci->sc_seq_done)
@@ -2711,41 +2710,10 @@ static int nilfs_segctor_thread(void *arg)
 	/* end sync. */
 	sci->sc_task = NULL;
 	timer_shutdown_sync(&sci->sc_timer);
-	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_kill_thread() */
 	spin_unlock(&sci->sc_state_lock);
 	return 0;
 }
 
-static int nilfs_segctor_start_thread(struct nilfs_sc_info *sci)
-{
-	struct task_struct *t;
-
-	t = kthread_run(nilfs_segctor_thread, sci, "segctord");
-	if (IS_ERR(t)) {
-		int err = PTR_ERR(t);
-
-		nilfs_err(sci->sc_super, "error %d creating segctord thread",
-			  err);
-		return err;
-	}
-	wait_event(sci->sc_wait_task, sci->sc_task != NULL);
-	return 0;
-}
-
-static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
-	__acquires(&sci->sc_state_lock)
-	__releases(&sci->sc_state_lock)
-{
-	sci->sc_state |= NILFS_SEGCTOR_QUIT;
-
-	while (sci->sc_task) {
-		wake_up(&sci->sc_wait_daemon);
-		spin_unlock(&sci->sc_state_lock);
-		wait_event(sci->sc_wait_task, sci->sc_task == NULL);
-		spin_lock(&sci->sc_state_lock);
-	}
-}
-
 /*
  * Setup & clean-up functions
  */
@@ -2766,7 +2734,6 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct super_block *sb,
 
 	init_waitqueue_head(&sci->sc_wait_request);
 	init_waitqueue_head(&sci->sc_wait_daemon);
-	init_waitqueue_head(&sci->sc_wait_task);
 	spin_lock_init(&sci->sc_state_lock);
 	INIT_LIST_HEAD(&sci->sc_dirty_files);
 	INIT_LIST_HEAD(&sci->sc_segbufs);
@@ -2821,8 +2788,12 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 
 	up_write(&nilfs->ns_segctor_sem);
 
+	if (sci->sc_task) {
+		wake_up(&sci->sc_wait_daemon);
+		kthread_stop(sci->sc_task);
+	}
+
 	spin_lock(&sci->sc_state_lock);
-	nilfs_segctor_kill_thread(sci);
 	flag = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) || sci->sc_flush_request
 		|| sci->sc_seq_request != sci->sc_seq_done);
 	spin_unlock(&sci->sc_state_lock);
@@ -2870,14 +2841,15 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
  * This allocates a log writer object, initializes it, and starts the
  * log writer.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINTR	- Log writer thread creation failed due to interruption.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
+	struct nilfs_sc_info *sci;
+	struct task_struct *t;
 	int err;
 
 	if (nilfs->ns_writer) {
@@ -2890,15 +2862,23 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 		return 0;
 	}
 
-	nilfs->ns_writer = nilfs_segctor_new(sb, root);
-	if (!nilfs->ns_writer)
+	sci = nilfs_segctor_new(sb, root);
+	if (unlikely(!sci))
 		return -ENOMEM;
 
-	err = nilfs_segctor_start_thread(nilfs->ns_writer);
-	if (unlikely(err))
+	nilfs->ns_writer = sci;
+	t = kthread_create(nilfs_segctor_thread, sci, "segctord");
+	if (IS_ERR(t)) {
+		err = PTR_ERR(t);
+		nilfs_err(sb, "error %d creating segctord thread", err);
 		nilfs_detach_log_writer(sb);
+		return err;
+	}
+	sci->sc_task = t;
+	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
-	return err;
+	wake_up_process(sci->sc_task);
+	return 0;
 }
 
 /**
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 7d1160a266df..f723f47ddc4e 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -105,7 +105,6 @@ struct nilfs_segsum_pointer {
  * @sc_flush_request: inode bitmap of metadata files to be flushed
  * @sc_wait_request: Client request queue
  * @sc_wait_daemon: Daemon wait queue
- * @sc_wait_task: Start/end wait queue to control segctord task
  * @sc_seq_request: Request counter
  * @sc_seq_accepted: Accepted request count
  * @sc_seq_done: Completion counter
@@ -158,7 +157,6 @@ struct nilfs_sc_info {
 
 	wait_queue_head_t	sc_wait_request;
 	wait_queue_head_t	sc_wait_daemon;
-	wait_queue_head_t	sc_wait_task;
 
 	__u32			sc_seq_request;
 	__u32			sc_seq_accepted;
@@ -191,7 +189,6 @@ enum {
 };
 
 /* sc_state */
-#define NILFS_SEGCTOR_QUIT	    0x0001  /* segctord is being destroyed */
 #define NILFS_SEGCTOR_COMMIT	    0x0004  /* committed transaction exists */
 
 /*
-- 
2.34.1

