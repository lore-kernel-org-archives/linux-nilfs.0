Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8CF2E0905
	for <linux-nilfs@vger.kernel.org>; Wed, 29 Oct 2025 22:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761778353; cv=none; b=rPdDaTcRrq5GNexLvKmncJ9z60t/zCUOmTPTDipSqj7zBkrNwi/NGlP20Eq5CXpLWzz8jw7UztovcKVYtmwL3FzhUcD1o2JJhl8gBjrGPmJJKZTtAUj6vgSH44KFkk+DrtU3udbjTgPy8if/dLtt3H1dixxgwnUYF/3uRNJiULY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761778353; c=relaxed/simple;
	bh=1ZhsIcRLP7+IYtwf3LWzzjumhrTQGEFECTJ35YVT8uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpbc//5mXPYjXmiC7XkzK1wQQa+iXA+dPbUO472c2uvIPYZgH4D8mZYcZHQ9vvbxwA3yj0mFULIXrBK2Kj75TbK9/YL5uQZXImhshQIgF80bWfr0h/ewp/2PZ4goNnupru5DCB1FSUgWWdZhgVmurcl9EyDr00bik+IBHhK6Kf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AeM6XZZP; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AeM6XZZP"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so4845265ad.2
        for <linux-nilfs@vger.kernel.org>; Wed, 29 Oct 2025 15:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761778351; x=1762383151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sa/M9rWrlNILi0zFUiuPfvMm44JyZKpzB3uqveEBnzM=;
        b=AeM6XZZP7+v14dT4V7+2Bz6QaBm9o5pcqcmHXjyxqwK3IBcpd58Xlxmov4jLp2Q6Xq
         FH2Nrf0k7ZWmPUKIjT63AvE3aD7J/WY+LUrie7zkzx46j5tQbx+m43OIP6TmKTiylz2g
         pJTMIS4LO8PyHjexbx9YnWKfzmtC+wSS0v1KwqEZKX7wYd/VwyM2PR5V4mjEK2xD8H/4
         Fktvfi8mScNJ6o2gBlKtFsEsIIo3LN9PGIT34bZ2soE6FX5bxCLgykueBLIJy4b6ZotO
         WSbfZ+NFKqCjvjzKpjvS7vOMCdX2V4ogq//ho9paAo58tFhSHMRUndchSmnaGjl9lEhr
         wMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761778351; x=1762383151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sa/M9rWrlNILi0zFUiuPfvMm44JyZKpzB3uqveEBnzM=;
        b=AM4zBdgjFq8eN7WgDB3N8xOPAyzD7LwJgsonykNtqGsmn4KwawD0z04tx/z2U8DV93
         +8GruWW16dRYUn/yH8fu28jaZ7FxjKzuzsCv5PXfJKN5ryxit1eZSl+ZfXcPSh7kNGRz
         K7pUc6oAI2RZg7HDDopvXOL/hjvw7J5pOv8hJilr+ECI2qkrFkgjNx6SLmBXsDpYVtTr
         B3elPNMjTwDNvuidqUOMtOHAOvIgZbPD7X2noBJSbUPh7UAKcGsqSvCPEkRuKjoXjfUu
         oThgNeVOL2GXXGh5Jug+nDJUv6L27sh2A/jRr6+8rZYhzblby2KlZwhSjGtmjzwRSOUx
         Wcrw==
X-Gm-Message-State: AOJu0YyANmr+czRBw7PlxyUeU6nEFKPlVonOi1mqnKGhqxnnpRB68Dei
	0cw1zu4UMk12bP32zaBxW69p3NRbMFkPDTqNwEJGllQSGFTaT0P4ycZg+2BABg==
X-Gm-Gg: ASbGncv8SBj2VEx3lektjj/dAo/loSx9byKu/eFoAfbl10JDV1KMNP3oce5NslV+JFK
	ED7wiAjUEdz6EQ0mVNuMsOEKoZ9yOL5DkKepSqjS/hVVOm0sb/L1/FSU30za3Spx/xzFXa+r1+N
	cRvKmPVULUuxgMzjzZm8ZnF/4QHB6SMOM5TRyCVr7Bf2jLKnjtpkjp69Z9uDlxqPJ5ZhVD5ZW7E
	Cz7qwNy1RccJyobLh5uJhQzxW9KUCgCG/T4eqxE9GvvcoHTbk4Q84fxa0hZuMBDjQqYZyl1CWHR
	Q8aJ3HYp0edA1ktaJlWcYOv78OYOYMHbBYR0ZepHEpPyb1mz60rZhl6uiMbc5ff/4r0/sq5Z3cy
	+UDOmOyptKij9JMzUb7e42X4zqXQNYBP6o9fwXeczcZ79vhwx/+VuL/FM7Ob+4lSMJ4LKrJx8ZG
	omZsaxq2MMuCJ6OXL87a/q8A85+qHaP3xz/zrxgOQ9C/aXMq7BiH2J5ZQIs4w=
X-Google-Smtp-Source: AGHT+IHuHo99Vd2q+n3paxG/Mdr/LKbfWyALc22D4g6ejN4rzMFZ1N7kqVPTYkcjWnoApxq6lFrDPg==
X-Received: by 2002:a17:903:22c3:b0:294:df5f:ffc1 with SMTP id d9443c01a7336-294ee3637f1mr8643055ad.23.1761778351175;
        Wed, 29 Oct 2025 15:52:31 -0700 (PDT)
Received: from carrot.home.local (i114-180-53-102.s42.a014.ap.plala.or.jp. [114.180.53.102])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e42ea7sm162387445ad.101.2025.10.29.15.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 15:52:30 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: Avoid having an active sc_timer before freeing sci
Date: Thu, 30 Oct 2025 07:51:52 +0900
Message-ID: <20251029225226.16044-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <68ffe1a8.050a0220.3344a1.03a1.GAE@google.com>
References: <68ffe1a8.050a0220.3344a1.03a1.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Edward Adam Davis <eadavis@qq.com>

Because kthread_stop did not stop sc_task properly and returned -EINTR,
the sc_timer was not properly closed, ultimately causing the problem [1]
reported by syzbot when freeing sci due to the sc_timer not being closed.

Because the thread sc_task main function nilfs_segctor_thread() returns 0
when it succeeds, when the return value of kthread_stop() is not 0 in
nilfs_segctor_destroy(), we believe that it has not properly closed
sc_timer.
We use timer_shutdown_sync() to sync wait for sc_timer to shutdown, and set
the value of sc_task to NULL under the protection of lock sc_state_lock,
so as to avoid the issue caused by sc_timer not being properly shutdowned.

[1]
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: nilfs_construction_timeout
Call trace:
 nilfs_segctor_destroy fs/nilfs2/segment.c:2811 [inline]
 nilfs_detach_log_writer+0x668/0x8cc fs/nilfs2/segment.c:2877
 nilfs_put_super+0x4c/0x12c fs/nilfs2/super.c:509

Reported-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=24d8b70f039151f65590
Tested-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Fixes: 3f66cc261ccb ("nilfs2: use kthread_create and kthread_stop for the log writer thread")
Cc: <stable@vger.kernel.org> # 6.12+
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Andrew,

Please apply this patch as a bug fix.  It addresses a recently reported
issue by syzbot, where a timer might not be properly shut down.

Thanks,
Ryusuke Konishi

 fs/nilfs2/segment.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index f15ca6fc400d..deee16bc9d4e 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2768,7 +2768,12 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 
 	if (sci->sc_task) {
 		wake_up(&sci->sc_wait_daemon);
-		kthread_stop(sci->sc_task);
+		if (kthread_stop(sci->sc_task)) {
+			spin_lock(&sci->sc_state_lock);
+			sci->sc_task = NULL;
+			timer_shutdown_sync(&sci->sc_timer);
+			spin_unlock(&sci->sc_state_lock);
+		}
 	}
 
 	spin_lock(&sci->sc_state_lock);
-- 
2.43.0

