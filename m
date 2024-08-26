Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6534C199FC9;
	Mon, 26 Aug 2024 17:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724694105; cv=none; b=cp8l3CEEzEusr8jAGT3whjDI7IBP+gIfEl4P3xyHlW6XqfpY6/UWCJVQQ09fpi5PQ4fhyCl+a3cTLW4MqBVxt03Y+V3LqChcYtSwcyiEvGe9Vr8HAI3XAp9z8N4zFXob8+wsJbJ69GQ0cEBc6ZsaxvFDeiPXEkWr/cGmcU2KURU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724694105; c=relaxed/simple;
	bh=ToL2x8xnfHrosgb8aQift+NPFQhBnl5Skyt2L9eY3mc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cPfY2smAaM8ByhsBDeXIlKFiVNzRDhs3zhLjF4sv6zoQyaBy5ZNBPjNQN8Go8GCzoM1u79KeogS/j7pEgBiiJTB5qaZet+yUf9Wx7iqxafANpLZD1CdplJefwbzs6mBobqm5CDG6P76XvpoFca2AexkuqwDWmDeAX8jXrbBJYvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jjS5I01m; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jjS5I01m"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-713edc53429so3376547b3a.2;
        Mon, 26 Aug 2024 10:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724694104; x=1725298904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/L0zziEopy1k9FRIPuSPnxsmn0iKwFK/QqP/AQhKzkw=;
        b=jjS5I01m/zXV45R48kIGNYn/0W1UHCE2gutbXzOQoLFd9wvCjtVny4TuM08OjzdMtG
         b43ltNgVSMBpX+c1/+VA0i+bSzUlbGmjhMCUP53/EacIJsWqE68DoL/Kf/b5dcWlV+eZ
         RXBuY0kRnROJHahoueQHLDw0sjH5LpTwCJzr7S4WBJMwcrMi41xhpMy6MuC4WUSrPX9B
         Z410NMqFLTWxUqaCuzJq7oVDXs0sGEh6GzWeyC+hnF3XUXtdZXj+p5U2pINBGJI9JF+G
         ydYluF3qR9bkpFtXrsJvQVsdxY9VgWv9+20cjqTkRogYKY/vOIfsU0ttnzD6GDMCguTm
         q/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724694104; x=1725298904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/L0zziEopy1k9FRIPuSPnxsmn0iKwFK/QqP/AQhKzkw=;
        b=Q89eqK44rwx40HP3yT513ogIU+0Yueu8w07CAEwHLbtQiJ9Dq9gHVxxPVWFVmeuQ0B
         wlkdUpTkP6FMnYCqNYQXVPexfCTtqzhezEP+ud/7eaoyriWX2j6/k2HiGvbNCU6+v7ju
         7uvsXWRu1rHVdzjE5pUtjcqfJT/BXYPJvcJr+SjWyPrhhitA9CYjrM6QClLVc66XH5Xp
         cW0cbJymeYp2QaQ8jxCgOIDpUysjkDQUWRjwlXOprtj1S5IrRuytrFmJurSQM+4ltg7s
         tCvvuCXN4p7dVtb8YVk+6oPJVEf97iSzN8CHEo6NTNWwV3OE7jbcrLk5j9chLIJN2SZw
         xmlg==
X-Forwarded-Encrypted: i=1; AJvYcCWfUbKBNDHir1xyLyNAjrm1iasG0GagGUCjP2Ge49S7lrn7ZkG2wv/boz8Gnxmx644MwrlArIdwwpF/Uw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdAI3ZHFXtKkw7bG8nBs8ctVVHajt+8X5OLZReQdz9YXswDlfr
	6z4DlsSZzn+mWiShwj+AQ1IE+3FcspJ1cKFJ0YEFt6qQ249st3mp1jVOLw==
X-Google-Smtp-Source: AGHT+IFPRbF8DdghPhc67ld4MgpjA50rrPgbVagXiI6O40OgDdIbPzGFYNj6B88f6/vUgz410lmFxQ==
X-Received: by 2002:a05:6a20:9e4e:b0:1cc:be05:ffe2 with SMTP id adf61e73a8af0-1ccc087617cmr408623637.18.1724694103492;
        Mon, 26 Aug 2024 10:41:43 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855665besm70057055ad.34.2024.08.26.10.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 10:41:42 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] nilfs2: remove sc_timer_task
Date: Tue, 27 Aug 2024 02:41:14 +0900
Message-Id: <20240826174116.5008-7-konishi.ryusuke@gmail.com>
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

After commit f5d4e04634c9 ("nilfs2: fix use-after-free of timer for
log writer thread") is applied, nilfs_construct_timeout(), which is
called by a timer and wakes up the log writer thread, is never called
after the log writer thread has terminated.

As a result, the member variable "sc_timer_task" of the
"nilfs_sc_info" structure, which was added when timer_setup() was
adopted to retain a reference to the log writer thread's task even
after it had terminated, is no longer needed, as it should be; we can
simply use "sc_task" instead, which holds a reference to the log
writer thread's task for its lifetime.  So, eliminate "sc_timer_task"
by this means.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/segment.c | 3 +--
 fs/nilfs2/segment.h | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 206066ce6d00..225f61ef66e7 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2504,7 +2504,7 @@ static void nilfs_construction_timeout(struct timer_list *t)
 {
 	struct nilfs_sc_info *sci = from_timer(sci, t, sc_timer);
 
-	wake_up_process(sci->sc_timer_task);
+	wake_up_process(sci->sc_task);
 }
 
 static void
@@ -2642,7 +2642,6 @@ static int nilfs_segctor_thread(void *arg)
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int timeout = 0;
 
-	sci->sc_timer_task = current;
 	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
 	/* start sync. */
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 2499721ebcc9..7d1160a266df 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -115,7 +115,6 @@ struct nilfs_segsum_pointer {
  * @sc_lseg_stime: Start time of the latest logical segment
  * @sc_watermark: Watermark for the number of dirty buffers
  * @sc_timer: Timer for segctord
- * @sc_timer_task: Thread woken up by @sc_timer
  * @sc_task: current thread of segctord
  */
 struct nilfs_sc_info {
@@ -172,7 +171,6 @@ struct nilfs_sc_info {
 	unsigned long		sc_watermark;
 
 	struct timer_list	sc_timer;
-	struct task_struct     *sc_timer_task;
 	struct task_struct     *sc_task;
 };
 
-- 
2.34.1

