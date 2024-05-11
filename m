Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F69366;
	Sat, 11 May 2024 00:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715387389; cv=none; b=fCUHdou62oX09cSxv/Xdehp/ZPjXWLyq4+Snb9VzgaoOsC1nq+vMK9I8a5LRv2ju5eAuHrNyph+uu0F8mrt+W1sWAk3hT+e52IydBMKh2Rb887swh3q6gwJCvoAQ4zNrFT8rfrQmzXcO3V8IxG8aKUA0AgOA/DaA8IjtWn/iYmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715387389; c=relaxed/simple;
	bh=pFNDBCnrqF2vhiFVthI8eDmhOWhXVE4ptSSgbGWVoSY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q7nMhp72abERci7OTRm9TZjNg5H7A1hWvt5ZqLvaUHqfcCNnZjwiWF0Gog1Lph7Dw2C7TKVvcgOEYRC5sumozyRH6vwTvmp5hiG/V/mwdI7vRjH1A4yaDKvTBEDkD2YOZy85F21AqJs/dbRcdGL0bfeR0p/VarUqHUCdIEFKLxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRl0RO2A; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRl0RO2A"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6f453d2c5a1so2439673b3a.2;
        Fri, 10 May 2024 17:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715387387; x=1715992187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a18/1RuaVVjtXwwOKzJFdZnMjlsc7tg3D/quUP40/Qk=;
        b=BRl0RO2AJ76lLOs1KCndLher2BOV892xOXj51GQktKODObACRNgNmtaVrKzdvCmhfG
         pjlYk0SCKQmhm9+bM5bgPLiL6lUs7qegoMSLGZAut+gxjEwFjxbvmp7f5fGNQnx1CYA9
         /x1SDuyip31Fw736WGw6kdEKMJ4jq4llJ/tDKGLtO8pLL6Ojc6qCVobfSDQ9dq1E00Ri
         DVmIou5L16tjkwGeGvZKMX2asnS8yEdyMZxxoiIEPQdXvBWxG3PPiw2TImu2oXBs624/
         SALE2J2iXfTfKmoVMQt3QtfaQrM8LAp3yGfVP6IR2mc2S0sTZfQw3tMHmaBbBhSWoz/e
         xsaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715387387; x=1715992187;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a18/1RuaVVjtXwwOKzJFdZnMjlsc7tg3D/quUP40/Qk=;
        b=Mwa5PmUInPQAmnLV6SJgOcCk6NdpKm7uvMbLvoJGS+17d87V+c5twFjKpqfrThw7F9
         7zk0U1J7I0gxKOcdJmBj6+MXyglKESkOmu+vp2OWRNnGdVS4THhOlq96WyWfCoW65eOw
         caBUTfSZxb9k6OC7c1f2HEhmCSsTHFmu+CFUXJbIEuLEt+EVsjJD9p4yjmg0/v0wY6kp
         cpOozZC32Y7lAcjfrC71ozbRufWQ/ZzkqXptciduy9nTrJgKBgsN98CLFebSVLlUBcn8
         7BmIs6D8WWTeyyA3i6R+niY8Hz8h1/yhoO7ww/VVynvHdpxq6WWwL9oTeQeN/xtCSp36
         hn7g==
X-Forwarded-Encrypted: i=1; AJvYcCUDoxAT+vK0qNKVUbeiN3ijZYiZMP68nJGD/OEyJZcxbB6oeg+eg/xaQWv+P5XYhnqRnRcCMn2TLRwKruYPoj5lK7zu2WkoyazmDemZ
X-Gm-Message-State: AOJu0YynpS3+bFo9z6hKeWiqWIIPet/WEaEQc9EftRzEN60Asu2geXGM
	Q5e6QOF2piHAH4Ky/qy9GXEGUJX9QtBS9+Txx5B262zGuBMNAN8hPDgpnA==
X-Google-Smtp-Source: AGHT+IFkO1qQK/WV7gr9YHUdMNTMnJnXN0lQg+je9NutLR/KcpZ3O9yZK+BoNIt3z7sckcB7D3z+/g==
X-Received: by 2002:a05:6a00:391a:b0:6f3:ebb3:6bc3 with SMTP id d2e1a72fcca58-6f4e026b090mr4200870b3a.3.1715387387211;
        Fri, 10 May 2024 17:29:47 -0700 (PDT)
Received: from carrot.. (i223-218-106-142.s42.a014.ap.plala.or.jp. [223.218.106.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a9d976sm3499267b3a.89.2024.05.10.17.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 17:29:46 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH -mm] nilfs2: make block erasure safe in nilfs_finish_roll_forward()
Date: Sat, 11 May 2024 09:29:42 +0900
Message-Id: <20240511002942.9608-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The implementation of writing a zero-fill block in
nilfs_finish_roll_forward() is not safe.  The buffer is being cleared
without acquiring a lock or setting the uptodate flag, so
theoretically, between the time the buffer's data is cleared and the
time it is written back to the block device using sync_dirty_buffer(),
that zero data can be undone by concurrent block device reads.

Since this buffer points to a location that has been read from disk
once, the uptodate flag will most likely remain, but since it was
obtained with __getblk(), that is not guaranteed.  In other words,
this is exceptional, and this function itself is not normally called
(only once when mounting after a specific pattern of unclean
shutdown), so it is highly unlikely that this will actually cause a
problem.

Anyway, eliminate this potential race issue by protecting the clearing
of buffer data with a buffer lock and setting the buffer's uptodate
flag within the protected section.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Andrew, please add another patch to your queue for the next cycle
(or as a bug fix if it's late).  It eliminates one potential race issue.

Thanks,
Ryusuke Konishi

 fs/nilfs2/recovery.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 020f304c600e..b638dc06df2f 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -702,8 +702,12 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
 	if (WARN_ON(!bh))
 		return;  /* should never happen */
 
+	lock_buffer(bh);
 	memset(bh->b_data, 0, bh->b_size);
+	set_buffer_uptodate(bh);
 	set_buffer_dirty(bh);
+	unlock_buffer(bh);
+
 	err = sync_dirty_buffer(bh);
 	if (unlikely(err))
 		nilfs_warn(nilfs->ns_sb,
-- 
2.34.1

