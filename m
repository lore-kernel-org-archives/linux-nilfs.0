Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490CC15625A;
	Fri, 16 Aug 2024 07:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723794227; cv=none; b=PNff1bwJd0dgXusSE72c6UuwzqliagARFrgwFA8undK5rakZ0pe0PbrfzmIbVcjGU79oQILcJ3hqd7C4agf4fIN6u9GJoiYSeSMbADmjP92tQwik3MQYy72dUBFv0mnszARJ8mfM0iz4fNtB/2QkOkakCeb9htLQyFhl1QGTCLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723794227; c=relaxed/simple;
	bh=kiKWKAUAbvAlluI6kaAn6cBCa9AkXQOWjGozLNZUXCw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mb17zi0aw8VPUltcF1OW5PR7vG/Unh5948+/OWKlAh5LRKBiIdcNrSKLOXqSakCLdYFbmTyMG61pyj1I0N8TGV5JySYWaJ0ec6bVH3Y6x2zIY6DDKLcORB398hInheUKN4MQ+TSgkbfeWrhU03wHDU0phkgGupyr0FrxcBWm84E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xx15G8cs; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xx15G8cs"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3db14cc9066so1137923b6e.3;
        Fri, 16 Aug 2024 00:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723794225; x=1724399025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dop1h2/PH5d4ieq0SlCtOSrsPYAe02dXUT2sT+HcSoU=;
        b=Xx15G8cs5gkEaaFnJUTgWNfqP37c5PrJXez4iUfzbq09f3BX20917foHNfcpmKaCBQ
         mrjoY8vQCVW/3rZS7sObOzZfqfpt+VpGjgcCpbhoYeiFNSaQej7tX7jz+iYWrvpLEws7
         3E0Dd4YUGME6QRumDSr/lOL4D6B8GVthPd0iq0WqAi5RYc3KMnMOQu+gsANvWm93Dvge
         xTtZWDAh1TFbhRGe9IiSJUkNGPvmncDxCV8uDXyb1M/lN7sKYjxqec5erHvmZzJOZlMb
         VpTCrdsDH2VuK33mmRw9GfJpKdxWIaPUjKCLcrcL3Q5K0o028eeLyZ9a7K8sJXmJRoT+
         8eMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723794225; x=1724399025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dop1h2/PH5d4ieq0SlCtOSrsPYAe02dXUT2sT+HcSoU=;
        b=FK9k6KrR8w7XGbY1MCU4vJFLl/y82XkxBl+kM6x4ynYWtGamNxpI4IC6nMIb1tkoJO
         hsnh/HdhYs5juWLAuKrYxJ9RoFOI0timtW3bwKc3fwV+zH/OuPzXCNg5d6dsr8LtHUTW
         EdhLN4hVwe2z9Dma5KZqn9dYsg88BvvmKrvPMQ7rLm6+QVkvM8eKzmxOOq/8hXwpSr76
         ZvxetgCRjXx0gbcIyLjBLzLRq2F3YRV64DOtKzyYkrlWS1CKrXZm0WDXqaiMQ2L0058t
         2nxGl8F5NPZpw8TvmPBaE+A43PArfOa5K4uoU+XyoV/Ngu2+//iHoBwWR5Fh2yb315vG
         KUsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfUWL2cTCBR+lACpvOXYtfNkgjwuFcUyQ3WP5XDDfaUaOKQ+vjBRcDgKmyWlDhe+5kS8bytKxABD1UkrwZ0KClxZylM72pkStF/aQk
X-Gm-Message-State: AOJu0YwJAVY8tWV30t5QMVeuhYaC5eA3C0XABGb4cnw0Hk0tyih8jy6R
	BbBN3C05kjwKvmZvP1wnSI6VX/bbcWklbuZCu4MKjZkI8z4T3ix87X160Q==
X-Google-Smtp-Source: AGHT+IHB+DzmERb+l5GLvvTdYM55lX++XXZXDYD5ogb9ZeGrPSmM1CsrrdaamKCZJqWs1XKoJaoNkA==
X-Received: by 2002:a05:6808:1a0a:b0:3db:15a9:4a1f with SMTP id 5614622812f47-3dd3af6af6emr1547459b6e.49.1723794225132;
        Fri, 16 Aug 2024 00:43:45 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61e7c7asm2365971a12.45.2024.08.16.00.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:43:44 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] nilfs2: fix inconsistencies in kernel-doc comments in segment.h
Date: Fri, 16 Aug 2024 16:43:18 +0900
Message-Id: <20240816074319.3253-8-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240816074319.3253-1-konishi.ryusuke@gmail.com>
References: <20240816074319.3253-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix incorrect or missing variable names in the member variable
descriptions in the nilfs_recovery_info and nilfs_sc_info structures,
thereby eliminating the following warnings output by the kernel-doc
script:

 fs/nilfs2/segment.h:49: warning: Function parameter or struct member
  'ri_cno' not described in 'nilfs_recovery_info'
 fs/nilfs2/segment.h:49: warning: Function parameter or struct member
  'ri_lsegs_start_seq' not described in 'nilfs_recovery_info'
 fs/nilfs2/segment.h:49: warning: Excess struct member 'ri_ri_cno'
  description in 'nilfs_recovery_info'
 fs/nilfs2/segment.h:49: warning: Excess struct member 'ri_lseg_start_seq'
  description in 'nilfs_recovery_info'
 fs/nilfs2/segment.h:177: warning: Function parameter or struct member
  'sc_seq_accepted' not described in 'nilfs_sc_info'
 fs/nilfs2/segment.h:177: warning: Function parameter or struct member
  'sc_timer_task' not described in 'nilfs_sc_info'
 fs/nilfs2/segment.h:177: warning: Excess struct member 'sc_seq_accept'
  description in 'nilfs_sc_info'

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/segment.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 1060f72ebf5a..2499721ebcc9 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -22,10 +22,10 @@ struct nilfs_root;
  * struct nilfs_recovery_info - Recovery information
  * @ri_need_recovery: Recovery status
  * @ri_super_root: Block number of the last super root
- * @ri_ri_cno: Number of the last checkpoint
+ * @ri_cno: Number of the last checkpoint
  * @ri_lsegs_start: Region for roll-forwarding (start block number)
  * @ri_lsegs_end: Region for roll-forwarding (end block number)
- * @ri_lseg_start_seq: Sequence value of the segment at ri_lsegs_start
+ * @ri_lsegs_start_seq: Sequence value of the segment at ri_lsegs_start
  * @ri_used_segments: List of segments to be mark active
  * @ri_pseg_start: Block number of the last partial segment
  * @ri_seq: Sequence number on the last partial segment
@@ -107,7 +107,7 @@ struct nilfs_segsum_pointer {
  * @sc_wait_daemon: Daemon wait queue
  * @sc_wait_task: Start/end wait queue to control segctord task
  * @sc_seq_request: Request counter
- * @sc_seq_accept: Accepted request count
+ * @sc_seq_accepted: Accepted request count
  * @sc_seq_done: Completion counter
  * @sc_sync: Request of explicit sync operation
  * @sc_interval: Timeout value of background construction
@@ -115,6 +115,7 @@ struct nilfs_segsum_pointer {
  * @sc_lseg_stime: Start time of the latest logical segment
  * @sc_watermark: Watermark for the number of dirty buffers
  * @sc_timer: Timer for segctord
+ * @sc_timer_task: Thread woken up by @sc_timer
  * @sc_task: current thread of segctord
  */
 struct nilfs_sc_info {
-- 
2.34.1

