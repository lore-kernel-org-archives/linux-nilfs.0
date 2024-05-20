Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167E31369A1;
	Mon, 20 May 2024 13:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716211622; cv=none; b=hoExJhkoMPvEk/tJioAwse2TDHDqbaXw3m8mKHJLD4WPlpUyX5O36tJQGlR0hx7bfe7UZ9uGgJq1z8i4C2G2wYrT51uzDOwLXIuHbUjqKTcr384EJW91+XDlj7Fs8DXzJQ4Xpz0fL9kf7nGWUKnivSxqBOrwzbnts7aQiML0c/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716211622; c=relaxed/simple;
	bh=0pWZhWs3EMPgwiv2J/jv7QnmCej/OqSCgrcNLJE+h5Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k9BnqzgT+5IUGeyxha90MTIy+bqYExnImtqv6qu77Ckw7XFG+wpGOQoxicQB1wUWqQaINxLn9yh0E55fKmG1ePPX3BH4tCARgtiD0CiGn2k3vP80HUDyMupm9jhu+viXH63bGG4EKYj2AmS/JOa6YL4qsdhy1+/7XEMQwnMC6hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L3NkJ8AJ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L3NkJ8AJ"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1eb0e08bfd2so76609325ad.1;
        Mon, 20 May 2024 06:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716211620; x=1716816420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=96ExljQ2zVirPNQa+ZzfNLvxLXxlK8xHce/amt9Pe0M=;
        b=L3NkJ8AJgS9UwRJzKKIfk8jQ36FZtwwt1c/I+nPLW1Fw/xcAdcAPQ8mgMvOUR+9z1c
         /ct2FKgQe3k7B/gu2B8nkecxGZwYXYExYF84auteQSTXOAqaq3zgCTEeK44a+uVuv2CP
         XbIaWOsfKuGqcBePgD0Kub/HvEoc+sOAR2PS4XgfRHyE3gmNCFF7Kn37M8drZJ/9PuTp
         L8gIfH0ZBp/ze1EPqIaWDZnW0qMQPZFdF+XO7viiXhH2wx80fkhPDt45BtA6pUzDrY7B
         pdROYvYxBimJcf5PFTipx1izMqPkpCVjDoU4AsMblR2wzSuJpfnN02kS5COuxBCwSPVD
         Rq8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716211620; x=1716816420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=96ExljQ2zVirPNQa+ZzfNLvxLXxlK8xHce/amt9Pe0M=;
        b=mBR7SI+qd1QnINI2velzUDA4av8tDa0P6sceyDnfapH3hHuDs8ZchcDskbvtHtFuzv
         ZJsSD1n6ik0SOELBnlBht+sNDJt0DHva985pfWWuK4bAXNc1E9pmm1OaT422JZSGRnPo
         eQoxiCXYpyJeNfZyF5fPKnBBtc5rIXa717ZlJ8RLDDScG7bO3ldrHiHia9fJ9JsWV9gH
         nrm+eQbBULi14j6lSQ2oTHz69UC8TP3DhFIwV4IvCWESE74ggbblRUAo4DcIfpgKf1mC
         TkS3UiKlC8lYpn5kq1EpxEQyqOG3l15qGOQ+3c1pz1qb1oSKjH/wwxq6zkmYyUePuThh
         JzRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZ2GMLRvMH/Xn4W5sB7BSYDyvEGWimipgei1tZ7Sn7M6CHXIiux1q1afKTi9i1dky1e4LwAapfAkw39NDPL0mfJ5sAr3Xeb9++1vuS
X-Gm-Message-State: AOJu0YxodhpdYawEUjWvVYXTuuhPYzEFsiVeRagMkOYvf7hXMHlDBkSQ
	C0ltYsr+sNwenPfR+WoN3VwcwLHePV3ULpNVJEua25YDdnoRkv2x
X-Google-Smtp-Source: AGHT+IGbyOUs1EhYzCeml++ycEXgnW9tLpQUKE0JgndaN/V4OMsLmhiL6BPpSZ8uUt5XV8TWCUbRIA==
X-Received: by 2002:a17:90a:5901:b0:2b3:28be:dd6e with SMTP id 98e67ed59e1d1-2b6ccd6baedmr25282210a91.33.1716211620226;
        Mon, 20 May 2024 06:27:00 -0700 (PDT)
Received: from carrot.. (i222-151-4-139.s42.a014.ap.plala.or.jp. [222.151.4.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b628849c40sm22011380a91.18.2024.05.20.06.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 06:26:59 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	syzbot <syzbot+e3973c409251e136fdd0@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org,
	sjb7183@psu.edu
Subject: [PATCH 3/3] nilfs2: fix potential hang in nilfs_detach_log_writer()
Date: Mon, 20 May 2024 22:26:21 +0900
Message-Id: <20240520132621.4054-4-konishi.ryusuke@gmail.com>
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

Syzbot has reported a potential hang in nilfs_detach_log_writer()
called during nilfs2 unmount.

Analysis revealed that this is because nilfs_segctor_sync(), which
synchronizes with the log writer thread, can be called after
nilfs_segctor_destroy() terminates that thread, as shown in the call
trace below:

nilfs_detach_log_writer
  nilfs_segctor_destroy
    nilfs_segctor_kill_thread  --> Shut down log writer thread
    flush_work
      nilfs_iput_work_func
        nilfs_dispose_list
          iput
            nilfs_evict_inode
              nilfs_transaction_commit
                nilfs_construct_segment (if inode needs sync)
                  nilfs_segctor_sync  --> Attempt to synchronize with
                                          log writer thread
                           *** DEADLOCK ***

Fix this issue by changing nilfs_segctor_sync() so that the log writer
thread returns normally without synchronizing after it terminates, and
by forcing tasks that are already waiting to complete once after the
thread terminates.

The skipped inode metadata flushout will then be processed together in
the subsequent cleanup work in nilfs_segctor_destroy().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+e3973c409251e136fdd0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e3973c409251e136fdd0
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
---
 fs/nilfs2/segment.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 99c78a49e432..c27f0daec9af 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2190,6 +2190,14 @@ static int nilfs_segctor_sync(struct nilfs_sc_info *sci)
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
+		/*
+		 * Synchronize only while the log writer thread is alive.
+		 * Leave flushing out after the log writer thread exits to
+		 * the cleanup work in nilfs_segctor_destroy().
+		 */
+		if (!sci->sc_task)
+			break;
+
 		if (atomic_read(&wait_req.done)) {
 			err = wait_req.err;
 			break;
@@ -2205,7 +2213,7 @@ static int nilfs_segctor_sync(struct nilfs_sc_info *sci)
 	return err;
 }
 
-static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
+static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err, bool force)
 {
 	struct nilfs_segctor_wait_request *wrq, *n;
 	unsigned long flags;
@@ -2213,7 +2221,7 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
 	spin_lock_irqsave(&sci->sc_wait_request.lock, flags);
 	list_for_each_entry_safe(wrq, n, &sci->sc_wait_request.head, wq.entry) {
 		if (!atomic_read(&wrq->done) &&
-		    nilfs_cnt32_ge(sci->sc_seq_done, wrq->seq)) {
+		    (force || nilfs_cnt32_ge(sci->sc_seq_done, wrq->seq))) {
 			wrq->err = err;
 			atomic_set(&wrq->done, 1);
 		}
@@ -2362,7 +2370,7 @@ static void nilfs_segctor_notify(struct nilfs_sc_info *sci, int mode, int err)
 	if (mode == SC_LSEG_SR) {
 		sci->sc_state &= ~NILFS_SEGCTOR_COMMIT;
 		sci->sc_seq_done = sci->sc_seq_accepted;
-		nilfs_segctor_wakeup(sci, err);
+		nilfs_segctor_wakeup(sci, err, false);
 		sci->sc_flush_request = 0;
 	} else {
 		if (mode == SC_FLUSH_FILE)
@@ -2746,6 +2754,13 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 		|| sci->sc_seq_request != sci->sc_seq_done);
 	spin_unlock(&sci->sc_state_lock);
 
+	/*
+	 * Forcibly wake up tasks waiting in nilfs_segctor_sync(), which can
+	 * be called from delayed iput() via nilfs_evict_inode() and can race
+	 * with the above log writer thread termination.
+	 */
+	nilfs_segctor_wakeup(sci, 0, true);
+
 	if (flush_work(&sci->sc_iput_work))
 		flag = true;
 
-- 
2.34.1

