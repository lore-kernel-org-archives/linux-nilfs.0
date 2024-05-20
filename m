Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F55713667A;
	Mon, 20 May 2024 13:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716211619; cv=none; b=dQFf9FUJLstiTu5EBx/Yy7YYnsC6GakQ2aRABG1kSLiS9d/uIIx2r95JoYARojLeugLEJbNWTCX+PFhUaEOFR4F9JPuF1MAfAQMHCXMjdPptipUn7C6GEmrwW89nca9PIAijCMpkdjKfYXDZOZJf7uVgWK8iOLopPoHZYzlIj/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716211619; c=relaxed/simple;
	bh=Bp5+ddPO3oY5d6Y4HWGFFKko18BikL+HuJJMIuI9WTc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CxFlnKdN2HTCdUDBuYS/M/CbC0FWr2q8AVFTmUTCqNKX3bnWxxoeTp5IcZEHTpvsmPncRxBdC2pHCU+Q67btzOcfZBirFJ8qo8h7zcZjrWwIJyoqNQwABkY8c0sWidUNCMVUE4dhEUEI9nwtUogEvhmso7919Fp9CZoPYixfujw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VBlu7leL; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VBlu7leL"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1f05b669b6cso72025165ad.3;
        Mon, 20 May 2024 06:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716211617; x=1716816417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aifCUaK8ycM8ZmIgqu2a8d63Rnfm4Ic3U3SghkzNkDg=;
        b=VBlu7leLMvsMzO4RvEBKbSEg7lUZVwG517MBbwamTrUyUgwHWDGeND14KBnMQRG5rj
         WppvHIhY+mgLSX/mJ3cP/bqldXNdv2jLJKhiXoIDTJe98n1R0juUFIpxbRks7cm3e2ZO
         qy9dNFqghwrGbTwTf0UOzC0lArFqj29GFCkn1Sz8JlU5tHign84WCTDukSgvqp5mun93
         jx3OUQxm+8eOFIjjO96BZasFX2Cw4BmOCZPKhSn1wRv/ugH0ZrYGEATjkUKTp+7ib2Li
         6LWSlYELk6KOYiWniYpzTOk6WNnXIWZQwU1ZndbZ2wp+s6eW5Y3uaxgDC9uTWaijgKyR
         d3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716211617; x=1716816417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aifCUaK8ycM8ZmIgqu2a8d63Rnfm4Ic3U3SghkzNkDg=;
        b=w5VzDWB9jiIlUOVeiOV0b5mEkTnKeXvJNstL9WJ2eQJLAijri7fnNS9w7XjnYLywcJ
         U0y4GgEpw35iH3fD246OfUigD04hMe3jkpW1/XkRpun/FKXitT9IqM4YpEm70boP6qtg
         SEBM6aWvOW8zSWc3AOXBsVJkyVTT4hAj/aQlsYjfHUfrzoYXRVRl9hKIaxiCHNJygaiV
         InSc1wBxBQu+d2HoCUBuUNPovu58FaPXpNKwaUqAUwfn+ROf6zvw97cZl2hnuLAu6CSW
         ozmvPDSPDPVJhBLOEO+pAtc8ABcLbSDA+aCXDzRjVnVWYuG5TZEJOCBLG8cs9eJj21Zg
         HRTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsj40qzFC2GOzgbQs/4/Es93o8iL+IRp+7HJPNiMOjXXpea5O9WqfJSssA5wjCOdKlrZkqBHKAnsVY12VNMYZSt/pdgi72qu6X/pCW
X-Gm-Message-State: AOJu0YysX559tynucqaEdB9C0sSytH+nJKJxi5lYPLYjqAgxkOTL4869
	/vC4EUlCj2CuXUjwNR2Jcq1WvkzYNSdGeEajJnXx1qSszhQ1bZbv
X-Google-Smtp-Source: AGHT+IGvh8bM0dmIPutZvCeHdO5spWa/oDTfvmy6PSH9aarOfm/9orXe4fF4OhD9MXoELviUmUZpUA==
X-Received: by 2002:a17:90a:e50c:b0:2bd:5337:989b with SMTP id 98e67ed59e1d1-2bd533798d3mr6817260a91.35.1716211617380;
        Mon, 20 May 2024 06:26:57 -0700 (PDT)
Received: from carrot.. (i222-151-4-139.s42.a014.ap.plala.or.jp. [222.151.4.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b628849c40sm22011380a91.18.2024.05.20.06.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 06:26:56 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	syzbot <syzbot+e3973c409251e136fdd0@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org,
	sjb7183@psu.edu
Subject: [PATCH 2/3] nilfs2: fix unexpected freezing of nilfs_segctor_sync()
Date: Mon, 20 May 2024 22:26:20 +0900
Message-Id: <20240520132621.4054-3-konishi.ryusuke@gmail.com>
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

A potential and reproducible race issue has been identified where
nilfs_segctor_sync() would block even after the log writer thread
writes a checkpoint, unless there is an interrupt or other trigger to
resume log writing.

This turned out to be because, depending on the execution timing
of the log writer thread running in parallel, the log writer thread
may skip responding to nilfs_segctor_sync(), which causes a call to
schedule() waiting for completion within nilfs_segctor_sync() to lose
the opportunity to wake up.

The reason why waking up the task waiting in nilfs_segctor_sync() may
be skipped is that updating the request generation issued using a
shared sequence counter and adding an wait queue entry to the request
wait queue to the log writer, are not done atomically.  There is a
possibility that log writing and request completion notification by
nilfs_segctor_wakeup() may occur between the two operations, and in
that case, the wait queue entry is not yet visible to
nilfs_segctor_wakeup() and the wake-up of nilfs_segctor_sync() will be
carried over until the next request occurs.

Fix this issue by performing these two operations simultaneously
within the lock section of sc_state_lock.  Also, following the memory
barrier guidelines for event waiting loops, move the call to
set_current_state() in the same location into the event waiting loop
to ensure that a memory barrier is inserted just before the event
condition determination.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
---
 fs/nilfs2/segment.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 4e274bc8eb79..99c78a49e432 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2168,19 +2168,28 @@ static int nilfs_segctor_sync(struct nilfs_sc_info *sci)
 	struct nilfs_segctor_wait_request wait_req;
 	int err = 0;
 
-	spin_lock(&sci->sc_state_lock);
 	init_wait(&wait_req.wq);
 	wait_req.err = 0;
 	atomic_set(&wait_req.done, 0);
+	init_waitqueue_entry(&wait_req.wq, current);
+
+	/*
+	 * To prevent a race issue where completion notifications from the
+	 * log writer thread are missed, increment the request sequence count
+	 * "sc_seq_request" and insert a wait queue entry using the current
+	 * sequence number into the "sc_wait_request" queue at the same time
+	 * within the lock section of "sc_state_lock".
+	 */
+	spin_lock(&sci->sc_state_lock);
 	wait_req.seq = ++sci->sc_seq_request;
+	add_wait_queue(&sci->sc_wait_request, &wait_req.wq);
 	spin_unlock(&sci->sc_state_lock);
 
-	init_waitqueue_entry(&wait_req.wq, current);
-	add_wait_queue(&sci->sc_wait_request, &wait_req.wq);
-	set_current_state(TASK_INTERRUPTIBLE);
 	wake_up(&sci->sc_wait_daemon);
 
 	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
 		if (atomic_read(&wait_req.done)) {
 			err = wait_req.err;
 			break;
-- 
2.34.1

