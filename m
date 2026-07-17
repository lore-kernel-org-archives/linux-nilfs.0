Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973A0305E28
	for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 07:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784274549; cv=none; b=s+7HW7FyZWzOTXd2AKyQih/uYWSNLW2Oq9sWrPPIY5O+fVUmtME5UVya587qZs/w+ohIlQfjGDST14JZC+kAqETmzGr7YcI+vumdeTSc0Y6RyjctAGom0KPNHy8/XuBeQj5SOdH4odqKe5kC7or9ZTR10xMCl3ldChO5M5SErJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784274549; c=relaxed/simple;
	bh=QsX25RSzBaeCDGxjfNm9Iy0psAtxdi41sZxfmHj8aiM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YDvcwKwcXkpvKVxEpycEVVGQe6WuuWKKryaAA0aXbo55B4ElZNDbIyCOHMuU9b+EtOnsMpZ46mbCFfeVU2WUmRaDLUnfBRuS2F4G7BhNc+ySB5tJMSjv08YEGxwfMQ8/t+8aU2yuJULdD7jEdhCdrxjFxjd9zu4aTEqLjcf4U1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cTKZ9UHS; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cTKZ9UHS"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-69e28b554ceso3688986a12.0
        for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 00:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784274544; x=1784879344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tKk5vrY2co9MgfAMfcRD+C8jGuDWrHk9IrcaAoCqleM=;
        b=cTKZ9UHSl6c1ekB7LTGgocqVMqFr0E3lITnKgTZ2Cfipn/I1kvT6gGIFED19LgYZaX
         BtToH0fY1ZFGhyxe8wlOHGTlYA7A+7iL/+xQHCl0LAml7y8fEyZOxUb2GyQ1mHhVzOZk
         AjBfjtYBP9r2j+IzdA2q4F9ECj0cBmHdLENkLwMPVdeB+uv3jVwQnQjjRWcrTq3KrOpJ
         9IY69yyzgJ6PN7Pqno7Z0kSQA6kg931twh+BxmZAXgIOfMeBD4gOXv+1pmnCV6niySYu
         bLDx1AF9qlxQv7K+sHG+/Zh/Kx+JrPxNAbzUOTqICNUpa2GW8RFTo7NDvvmCy8mu5ySA
         bS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784274544; x=1784879344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tKk5vrY2co9MgfAMfcRD+C8jGuDWrHk9IrcaAoCqleM=;
        b=bf4p9c42elM+r1JB+H9ZsMfwVrCqGK95OI60JEPZyjLrWHnovQm0/Og2I1EiJmMGJZ
         jgGPFcsyR3HakwxK0unxoC1MWuyY3Ej7aNFgiYpl6kfuTbmuU7qkcHlbgeyLLcsiC6ha
         P4dIaY3R3umMsafcgdMfU0lgpn23ToLx34jB8iosep5xy9vwlMsAc26W7fWvuBLEz4KB
         VzpPD/mnh0RiS+TtjLXFF9p2fvWQNP1YxrzrJQxRCb7vFVhNBdbysmI9g68ndtN9OhPj
         Nsb37v0EFf//FEU7F5Tz2YjuaAm9lztcAuPNNOVaICe2h8Bgmmz1HYZugP8n+8kcYy8r
         hfFw==
X-Gm-Message-State: AOJu0Yy5jWnLUFNFKtbITjTWdG1NqWpdqjS05ZL1zbTwNb2/xjDqTdsT
	e286b6CvaN2u4arsioWAUMTYVoJrYdYSxjTMtn3TLLSSylVmAEBk3IaZ
X-Gm-Gg: AfdE7ckA5xhD4ogDqRlh3PV3hHWQ7aUEsgPLD9uIzZ417Bh+megZ84laobgjU7HTCtD
	FLHfJ9R1yBnmpHyOMpCHm61Iw+A6uNPvCKw5WGvakiFnILbhj3JG9Bt1G2Yorwrvvxiz1DHSCIV
	VQqRZPpS4ZL7rZ52yiTKk/nz6tWEZ3+pa1x8f5MBp491RDgGhLNKUD8InZGna4JFjAfLgKAJHcg
	fANpOFu2VfKHJY+FN4CsOlXR4bcNHoQ0h6P8NepNYgtYdyWCzxttyv1oRBwEWg9XnG5kmVP9Sqw
	PwnuEj/NTQtJU0M/N4qS94Z9jNImCTW+ZZf8sG3sYuGBgA70blsoVysveuXIvZiVbDdzk6bn5NT
	VCwUxSNjn91Ja8cWCf7Txivn8Nf+a9n9c7UE4myI0jeBlrdnNCxwGu3mvPUIo8KzJeR4DH3tSQ/
	b5ZKd6rGldwCCDmE1MBbbc/EOO7gxBl0J2hni5Yf4Cnm7DJV7yKGa02PWkVC+VhBtMfCXGwt8v5
	y9dxvd1m6yocFPam/ArsdyAh1tE1ZfQd5WfOtycEzalZTu9QhPb1rRKR5swbeAl1D8dkBLqbFnh
	3Z2n+NCV/BgwTtQ5Q7IlLE8vjXT5PuTbJ9IPJ5V0uMoISbsVJpjKBKcZvtJjsZkbQ5TxMeG2nH7
	p1HY2HSLbIYiY+lph5utXmU1UdPXKeGv7CW/Z+zJ9YmBqwcjm39N2nTa8T+TS/2xqa0sxvhgTqS
	5luQMCsLOPeyv6hZ9mZWc=
X-Received: by 2002:a17:907:970c:b0:bee:b5f2:639d with SMTP id a640c23a62f3a-c16b47289bcmr61632666b.10.1784274543794;
        Fri, 17 Jul 2026 00:49:03 -0700 (PDT)
Received: from cs-280612103108-default.europe-west4-a.c.oa7bb030819b2a894-tp.internal (193.216.13.34.bc.googleusercontent.com. [34.13.216.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c172349690bsm35374766b.42.2026.07.17.00.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 00:49:03 -0700 (PDT)
From: Joshua Crofts <joshua.crofts1@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
Subject: [PATCH] nilfs2: fix infinite loop in nilfs_clean_segments()
Date: Fri, 17 Jul 2026 07:47:10 +0000
Message-ID: <20260717074710.1397-1-joshua.crofts1@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reported a hung task in nilfs_transaction_begin(). This occurs
because the cleaner ioctl falls into an infinite loop if
nilfs_segctor_construct() repeatedly returns -EROFS (e.g. the device
is remounted as read-only after an I/O error).

Currently in nilfs_clean_segments(), if err is non-zero, it logs the
error and sleeps but doesn't abort when it encounters a terminal error
like -EROFS. This causes the thread to loop forever.

Fix this by breaking out of the loop if nilfs_segctor_construct()
returns -EROFS. This matches the behaviour in
nilfs_segctor_write_out(), which also handles -EROFS.

Reported-by: syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cae54346a70bbceeff2c
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Assisted-by: gemini:gemini-3.1-pro
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
---
As much as I've tried, syzbot is unable to test this and always fails
with "FATAL: Kernel too old". Nevertheless, I've tested the patch with
the same reproducer in QEMU and the system didn't hang.
---
 fs/nilfs2/segment.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9332f5ac6..91d3bb314 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2561,6 +2561,9 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 			break;
 
 		nilfs_warn(sb, "error %d cleaning segments", err);
+		if (unlikely(err == -EROFS))
+			break;
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(sci->sc_interval);
 	}
-- 
2.47.3

