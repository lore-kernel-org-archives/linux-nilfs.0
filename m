Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A959313664A;
	Mon, 20 May 2024 13:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716211617; cv=none; b=NKoJhoAxwP6/s11ORzKvW+LOShvji1XtJ/DaRvn1mLXTWgrPYHa7eQBiLUIWxrAxjxqfZZGGor8eK2IcuvvsQrGa0OF7/AWPNLFR/41XgFnmuXCJChCxxrye2JbI3yoXRHIzOVfUcoJm1gBdUVk3UcyJegca38AX0Wuv8hSrHJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716211617; c=relaxed/simple;
	bh=1xasG/CgreKLTDJbZq9iuVZl83sLNiPA8/I/muRRB2o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ps41td1f5QT6ZP0m9zk6h64ZKLa7BeQJU770IjWthgFcgnTmAg6ZfpyiHJG2XE6dlDtHVzUCt5drvQKVLazGxZJOYermDl9YsMLikE4/6NnrliDmZFmwMp9nfHS/CX8yQ3w6mnRGq1ePuEVSVkwkpbt14N7Hr+zhAbdfMpwwYqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VavuuiGk; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VavuuiGk"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e651a9f3ffso70412495ad.1;
        Mon, 20 May 2024 06:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716211615; x=1716816415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RKTW2iTjEKpg8c91ykURECnowHK+hWD/0s3IOnwVtRw=;
        b=VavuuiGkM1XzMz2UwfYL99BuFVCZ2Cr08fofxDIrrKmwGgatraV0os4oiz71lHO0fF
         xOjPARHn+OUmfs8/gVr8nEG/h3dWXCyYveZNgOf4zkrC+HfVrr7t9ECPfhUwAMH9Jyqx
         PXMw98xdhlRbw1LEYXJ7XBtSiKB4tkv2ttzTDx0/XSkK5IvA2rj8IfwMM1LwONLbfMEy
         /W+c0oWyK5xmaHb1THIVzRl8nFFhXQryW1inDBTyQUlERGYbZ4AljQru9n0jb8Vr7xZ8
         eDsUuliDsJpcUPhkCFwBFOcKgDurbLhMU5gr/mcl9z3nQhcAiAi4gyPEdVMCUlRK1rC2
         YItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716211615; x=1716816415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RKTW2iTjEKpg8c91ykURECnowHK+hWD/0s3IOnwVtRw=;
        b=eOz370AHAoBsK3amyXlZ9F2vY64RvIYI4LeKpTcxcQ7V6d0QJ8sdD6o3AroHFnIIOt
         shCbjTplswuIYWqyua6Cjp208VXAH01ay0494IMjSj4MOfFL0Pn6R3n2HaxSqfpXDsoU
         pkt0V9cKVEF9MzN11vtExtW/t15eErtIlTxHVSOnWvtVnGxw2ZEGKv+XF8OZSr61qBMC
         gEcRywN05S78YkP6YMxN0ZeIYTH9hwBD4jGfy7Ex8TX2GWWqQeUf4/E7ABedtK6b2Ion
         lQaA2LLIkW2SDeoqIsvtxP3yOe8EKa/ydEU297qMi5GDg4rvgJ0CYvptXBSguYVTl8oc
         o8Qw==
X-Forwarded-Encrypted: i=1; AJvYcCVQJJhB+sijhMFGGNXQiP0RPW1S27yB6GSo5i6/99HP6sir2PWh0SeIu/UD0qOh+zBTLb5NaxYAWgBLZWzIV5fVpHGHEEPV5pD3Vsd8
X-Gm-Message-State: AOJu0YwzgghLZt92Gw3UsHH/JdtvHLzr6h1GCqHPcpBNI4qVwCz/MrRe
	Idj2mXAXgEFFw3kidaVNRW1RdBo1LG20sDVjL93w0F/LlXPvhd52
X-Google-Smtp-Source: AGHT+IEfyWey7gyS6tKFyo43qi+P5NuXgxOtcYINd+l/8gE9ftaUVUJrac7/TUZOk0Vs6fVCifn4Qw==
X-Received: by 2002:a17:90b:1252:b0:2b1:a150:f75f with SMTP id 98e67ed59e1d1-2b6cc7801fbmr27283404a91.23.1716211614875;
        Mon, 20 May 2024 06:26:54 -0700 (PDT)
Received: from carrot.. (i222-151-4-139.s42.a014.ap.plala.or.jp. [222.151.4.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b628849c40sm22011380a91.18.2024.05.20.06.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 06:26:54 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	syzbot <syzbot+e3973c409251e136fdd0@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org,
	sjb7183@psu.edu
Subject: [PATCH 1/3] nilfs2: fix use-after-free of timer for log writer thread
Date: Mon, 20 May 2024 22:26:19 +0900
Message-Id: <20240520132621.4054-2-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240520132621.4054-1-konishi.ryusuke@gmail.com>
References: <0000000000001a167a05ebc4f62b@google.com>
 <20240520132621.4054-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A use-after-free issue has been reported regarding the timer sc_timer on
the nilfs_sc_info structure.

The problem is that even though it is used to wake up a sleeping log
writer thread, sc_timer is not shut down until the nilfs_sc_info
structure is about to be freed, and is used regardless of the thread's
lifetime.

Fix this issue by limiting the use of sc_timer only while the log writer
thread is alive.

Reported-by: "Bai, Shuangpeng" <sjb7183@psu.edu>
Closes: https://groups.google.com/g/syzkaller/c/MK_LYqtt8ko/m/8rgdWeseAwAJ
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: fdce895ea5dd ("nilfs2: change sc_timer from a pointer to an embedded one in struct nilfs_sc_info")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
---
 fs/nilfs2/segment.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 8654ab8ad534..4e274bc8eb79 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2118,8 +2118,10 @@ static void nilfs_segctor_start_timer(struct nilfs_sc_info *sci)
 {
 	spin_lock(&sci->sc_state_lock);
 	if (!(sci->sc_state & NILFS_SEGCTOR_COMMIT)) {
-		sci->sc_timer.expires = jiffies + sci->sc_interval;
-		add_timer(&sci->sc_timer);
+		if (sci->sc_task) {
+			sci->sc_timer.expires = jiffies + sci->sc_interval;
+			add_timer(&sci->sc_timer);
+		}
 		sci->sc_state |= NILFS_SEGCTOR_COMMIT;
 	}
 	spin_unlock(&sci->sc_state_lock);
@@ -2320,10 +2322,21 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
  */
 static void nilfs_segctor_accept(struct nilfs_sc_info *sci)
 {
+	bool thread_is_alive;
+
 	spin_lock(&sci->sc_state_lock);
 	sci->sc_seq_accepted = sci->sc_seq_request;
+	thread_is_alive = (bool)sci->sc_task;
 	spin_unlock(&sci->sc_state_lock);
-	del_timer_sync(&sci->sc_timer);
+
+	/*
+	 * This function does not race with the log writer thread's
+	 * termination.  Therefore, deleting sc_timer, which should not be
+	 * done after the log writer thread exits, can be done safely outside
+	 * the area protected by sc_state_lock.
+	 */
+	if (thread_is_alive)
+		del_timer_sync(&sci->sc_timer);
 }
 
 /**
@@ -2349,7 +2362,7 @@ static void nilfs_segctor_notify(struct nilfs_sc_info *sci, int mode, int err)
 			sci->sc_flush_request &= ~FLUSH_DAT_BIT;
 
 		/* re-enable timer if checkpoint creation was not done */
-		if ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
+		if ((sci->sc_state & NILFS_SEGCTOR_COMMIT) && sci->sc_task &&
 		    time_before(jiffies, sci->sc_timer.expires))
 			add_timer(&sci->sc_timer);
 	}
@@ -2539,6 +2552,7 @@ static int nilfs_segctor_thread(void *arg)
 	int timeout = 0;
 
 	sci->sc_timer_task = current;
+	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
 	/* start sync. */
 	sci->sc_task = current;
@@ -2606,6 +2620,7 @@ static int nilfs_segctor_thread(void *arg)
  end_thread:
 	/* end sync. */
 	sci->sc_task = NULL;
+	timer_shutdown_sync(&sci->sc_timer);
 	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_kill_thread() */
 	spin_unlock(&sci->sc_state_lock);
 	return 0;
@@ -2669,7 +2684,6 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct super_block *sb,
 	INIT_LIST_HEAD(&sci->sc_gc_inodes);
 	INIT_LIST_HEAD(&sci->sc_iput_queue);
 	INIT_WORK(&sci->sc_iput_work, nilfs_iput_work_func);
-	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
 	sci->sc_interval = HZ * NILFS_SC_DEFAULT_TIMEOUT;
 	sci->sc_mjcp_freq = HZ * NILFS_SC_DEFAULT_SR_FREQ;
@@ -2748,7 +2762,6 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 
 	down_write(&nilfs->ns_segctor_sem);
 
-	timer_shutdown_sync(&sci->sc_timer);
 	kfree(sci);
 }
 
-- 
2.34.1

