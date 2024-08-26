Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755B619AD73;
	Mon, 26 Aug 2024 17:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724694110; cv=none; b=mwHg7udhZDnTAVqBpJgoiOy9IKDx/eBnup2/79c8lnd4GzZWTINFLps1BfklqmKhPgAZJadcAPUalO+Myti7war80Q1rPxtSMgupiz4jETCL7I1kyKxFJ+r+/YkbrlWjfnfyM7HeZWUAKlUkgwkJpoaNyjbEx0qq/Vpz5vjWr/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724694110; c=relaxed/simple;
	bh=JtFDI4yYUQR700ra8I78LsXDmojzhmbA+0CKHi3GxWs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gaif3GRnxWOTecOPmY1Db7waI8oFjyov+6/ruTWGG4CXS0B9m+hzKdlK71VD4IYlrl4Hw49z66vd+nU5/6LIj/MQ6clCCRVuMSi+iLNO9b8z3g0zvMxSo5iValOwp5dzu+ZvuwVmStU4kgxYcaBPZhTzKfxe+JtoL5DCc/QjDac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aBXfMHec; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aBXfMHec"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fec34f94abso44445005ad.2;
        Mon, 26 Aug 2024 10:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724694108; x=1725298908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bXIcye025aQHp4YYCJd3WvJxtsBbB399iGk/S5LYEJw=;
        b=aBXfMHecIOKzr+NDNn3DNEm+ZN6BCy+arjxmqSBrYIF/qNp+OLuUwpysQaKK0iMXZz
         awWSsvOKDsbVSiZvQjV44Y1/V1kpwkNgg/tworXHv7jg2gbm00O/VuwJhMngDj55YpFV
         wy3XoUv3NAhZCZR/iRuKDnf3DWTStkfO+td4yT+6XQe0didN7uaNsad7fMc95NRk1jDb
         udib7KJNBhGsf5QuT5yEWNelKEVihb+KXBDteShxRFzMkDGe5Ikmoe0gbvwDHBMdIcU7
         K3byzQlNwHvToKgtFbQHyP1lgO8pu7Gk8czy6waOSAdQ+ngpXyD7KLdqqWUPVwnpfxNB
         QIYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724694108; x=1725298908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bXIcye025aQHp4YYCJd3WvJxtsBbB399iGk/S5LYEJw=;
        b=TGybM8Jf0rfQNbyavgnvWpjkkmLLYqqK0EVimWaXJUfssrtR/KmxjRLDANBJJqvLNE
         7LbfxYGyzuDDUZ1+UWts/tb5Kd4+SlulgLMTFA5zT3P6C2g0B3HK8b1oiooBDaSNGHDx
         paF7kpxID5YnrHSujqo4lQYUSoO/ZG6CDuBnyNjn4wsGDZ1NdV1rul9Q5zhFGmkg/VrN
         Mnw8QVOWYinvQ8NFzHrJA3XxbNrg+ei+y5Bbf3+E/CRqkBoVJKkTqLHxFaB3U0CI+8mo
         W+YyqvCzXQ5tghnFeaaRsnlfDkX71eRNG7bPq1pPI1dW/bSaicoSP9HPJQxcNHQ+wvKu
         AzVw==
X-Forwarded-Encrypted: i=1; AJvYcCVg9B0I6ovmNqHAR2g2v7aqQhBwpj+6A5ZpFckswkgraq7FRMDxGxd+UpLnjGcQkye/oAdmEheGQK+GwIA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGFTpyiVrNBYqZ4j+min/0QOtMcMVDVrSMVP1PURfZyaDuZ1yi
	JeSzV9llwr4hvIn7mLi1N54LbP24VQX10gSDWKBWZ8amArc6H9QWG4j2Ag==
X-Google-Smtp-Source: AGHT+IEuHWgkuL52jNVrRqBi5Dk/bYdiYqV3bUqR8iI9vQgpPcaSTNT26tXSur1BopD7YCMV2M7gJA==
X-Received: by 2002:a17:902:e812:b0:202:859:f85 with SMTP id d9443c01a7336-2039e489273mr114680635ad.24.1724694107498;
        Mon, 26 Aug 2024 10:41:47 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855665besm70057055ad.34.2024.08.26.10.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 10:41:46 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] nilfs2: refactor nilfs_segctor_thread()
Date: Tue, 27 Aug 2024 02:41:16 +0900
Message-Id: <20240826174116.5008-9-konishi.ryusuke@gmail.com>
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

Simplify nilfs_segctor_thread(), the main loop function of the log
writer thread, to make the basic structure easier to understand.

In particular, the acquisition and release of the sc_state_lock spinlock
was scattered throughout the function, so extract the determination of
whether log writing is required into a helper function and make the
spinlock lock sections clearer.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/segment.c | 85 +++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 45 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 013262ab5169..587251830897 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2629,6 +2629,32 @@ static int nilfs_segctor_flush_mode(struct nilfs_sc_info *sci)
 	return SC_LSEG_SR;
 }
 
+/**
+ * nilfs_log_write_required - determine whether log writing is required
+ * @sci:   nilfs_sc_info struct
+ * @modep: location for storing log writing mode
+ *
+ * Return: true if log writing is required, false otherwise.  If log writing
+ * is required, the mode is stored in the location pointed to by @modep.
+ */
+static bool nilfs_log_write_required(struct nilfs_sc_info *sci, int *modep)
+{
+	bool timedout, ret = true;
+
+	spin_lock(&sci->sc_state_lock);
+	timedout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
+		   time_after_eq(jiffies, sci->sc_timer.expires));
+	if (timedout || sci->sc_seq_request != sci->sc_seq_done)
+		*modep = SC_LSEG_SR;
+	else if (sci->sc_flush_request)
+		*modep = nilfs_segctor_flush_mode(sci);
+	else
+		ret = false;
+
+	spin_unlock(&sci->sc_state_lock);
+	return ret;
+}
+
 /**
  * nilfs_segctor_thread - main loop of the log writer thread
  * @arg: pointer to a struct nilfs_sc_info.
@@ -2644,70 +2670,39 @@ static int nilfs_segctor_thread(void *arg)
 {
 	struct nilfs_sc_info *sci = (struct nilfs_sc_info *)arg;
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
-	int timeout = 0;
 
 	nilfs_info(sci->sc_super,
 		   "segctord starting. Construction interval = %lu seconds, CP frequency < %lu seconds",
 		   sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
 
 	set_freezable();
-	spin_lock(&sci->sc_state_lock);
- loop:
-	for (;;) {
-		int mode;
-
-		if (kthread_should_stop())
-			goto end_thread;
-
-		if (timeout || sci->sc_seq_request != sci->sc_seq_done)
-			mode = SC_LSEG_SR;
-		else if (sci->sc_flush_request)
-			mode = nilfs_segctor_flush_mode(sci);
-		else
-			break;
-
-		spin_unlock(&sci->sc_state_lock);
-		nilfs_segctor_thread_construct(sci, mode);
-		spin_lock(&sci->sc_state_lock);
-		timeout = 0;
-	}
 
-
-	if (freezing(current)) {
-		spin_unlock(&sci->sc_state_lock);
-		try_to_freeze();
-		spin_lock(&sci->sc_state_lock);
-	} else {
+	while (!kthread_should_stop()) {
 		DEFINE_WAIT(wait);
-		int should_sleep = 1;
+		bool should_write;
+		int mode;
+
+		if (freezing(current)) {
+			try_to_freeze();
+			continue;
+		}
 
 		prepare_to_wait(&sci->sc_wait_daemon, &wait,
 				TASK_INTERRUPTIBLE);
-
-		if (sci->sc_seq_request != sci->sc_seq_done)
-			should_sleep = 0;
-		else if (sci->sc_flush_request)
-			should_sleep = 0;
-		else if (sci->sc_state & NILFS_SEGCTOR_COMMIT)
-			should_sleep = time_before(jiffies,
-					sci->sc_timer.expires);
-
-		if (should_sleep) {
-			spin_unlock(&sci->sc_state_lock);
+		should_write = nilfs_log_write_required(sci, &mode);
+		if (!should_write)
 			schedule();
-			spin_lock(&sci->sc_state_lock);
-		}
 		finish_wait(&sci->sc_wait_daemon, &wait);
-		timeout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
-			   time_after_eq(jiffies, sci->sc_timer.expires));
 
 		if (nilfs_sb_dirty(nilfs) && nilfs_sb_need_update(nilfs))
 			set_nilfs_discontinued(nilfs);
+
+		if (should_write)
+			nilfs_segctor_thread_construct(sci, mode);
 	}
-	goto loop;
 
- end_thread:
 	/* end sync. */
+	spin_lock(&sci->sc_state_lock);
 	sci->sc_task = NULL;
 	timer_shutdown_sync(&sci->sc_timer);
 	spin_unlock(&sci->sc_state_lock);
-- 
2.34.1

