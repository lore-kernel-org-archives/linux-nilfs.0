Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D1633A9C5
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Dec 2025 18:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167601; cv=none; b=Fmq4oUPKjp2OHLWpbglZDqcvjdJL6IwqGcD2ZbchWs+wep21TfNUXG9tByyc/6O7oVRxpNwtIi0qKM5swI/rVPjbTqc1XCI8k9PrDRXxyESjsx4PZC6yaAQsy6Y/RB2jOJIrJ4/aJSCnrGRS2cu2XTuSY2QKV92qmtJd8O6vyKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167601; c=relaxed/simple;
	bh=RmCnd6gkVlTZlugAcfM3670Kr8ZwNknI/MToBJWnUBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaFQMmrc8vcRy5VAEAGGtkT3oCb2m3eF+AuuzCp+xzu1pCAyGj8V9YdrKiAmIR5PL3tBZd8jWljcrL5MwAHlHd+/ajv1jmSdc98ny+NmAiKDLNAmEiqWbKnKSepSZMZnv/q370pvb0vRRAmUDsmkx867NnIcXQcUfM2TiWZTrT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZpFy2ifd; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZpFy2ifd"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7aab7623f42so2522933b3a.2
        for <linux-nilfs@vger.kernel.org>; Fri, 19 Dec 2025 10:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766167599; x=1766772399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dW3bXX4vP+WteeSK3ew02UmI9wiau0xdWqe/ZXK117U=;
        b=ZpFy2ifd83Eym1irHxEJi4ORn+/+ueWx6zfrtGVXsyJSXnWiLyzx5s6ZBNpjGaYfUh
         18PCM7+6dS6lvHTk0gDH3006xXlVQLATp1Ans4pIqlCwq+MUH3V8QyEiZo0Kv/+nbGPH
         OCARGNx0VvgQmSYklJqRXS0+cHtRmXOYQrYs82eMCQKnD5fTqhCEBTye9FsIlwQVch4Z
         xisz+XVeWXURb3jUnXYV1ENYYN6gfXwxPuV2VH5wf2OakfphEDd2Q9d2y8ipPIZh4FxG
         C773FlBc65H03OiChnCeob0crVbVael65dZr7kfiyJM9XDhKtyqy1QgAY+zq43o0Jo2W
         KmwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766167599; x=1766772399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dW3bXX4vP+WteeSK3ew02UmI9wiau0xdWqe/ZXK117U=;
        b=UNU8MVX+V+ZYb4g1/D+6jB69Qpuzr5H0lRNUKTwWmrryL4SaUA0zfjCkcramml3stJ
         v5j+Ng+CmzyvfzFCB4Li798ma4dDV783bjmgqn2T+V7QTItWxdTmMVpMJT/3+Xwv1igA
         LihU2CxcCs1mz1bxyY6y/Is6ZPzQ4HaOjIZ3GZaK0mVxYk7b55d38ZoeGaS/hfh54+vn
         uxFLUFWaSCf7vvO8qkO/t0VAa7ev3iQYNZtQ74pjRbVxBhJ59k8LVPX4DLQQ8Hxxf3jZ
         rQymxaGpB9fJUc63zUAHiOyev8NSEJCC7v02nPo24cICQvJXrHZzGl8MFczt5PcdtjK8
         2oNg==
X-Gm-Message-State: AOJu0YyfJbM10RMw/V0QGll7nBvS5R2MJs59TuuoUtKUXfO80mEFrP6h
	JaNwx/e6H0NsqMIuAouFhLfDHytTW1F0drmQThZrYPqOQS8qCa9pfFAhLajx/JpM
X-Gm-Gg: AY/fxX7spRQnzFsJtLA1G9FK1Sgfupubvpkf6DpKE43Vo7xMUpIwLpMDte7hC7t1wzd
	JxO7CIsQyt05QBsu+U1n8DVVhIBh5FCMXSJ3A58gkLLV1PI6zJ3alsRvyojhYySJ1FCj6QYW6wf
	sK6b8i/sWk6YnO5fnzQgK07khx1u1VIrbXB7oVsWOdduMFkRol0Lls2kC9CtdOEltY+QJJZ3x8/
	1K7NWToO3bNlAUQIp5eGRNcrd95Fxx+HhF6hV9qjaeT1pokWNwAtXlyJMZimvNjqlkjdOLINEnm
	q4EBuK6aACqXX+TsUKlgYWZ0wVipipht6vjSNqa1hEYm3HDjVeccT0Ds3PYsjswjV8zuc0gYOMG
	qdUIwmjX0JrVUMO4s0llIAqkVsUcAEXm+CjiSdLZ6zklqodlz3CQ9M4XawlCxWW+F87mIsKnOS/
	m7fMxFjrcl8Q4om1gElQjQBgTA6W0IUANHmxQU2XNnknmnDIQkf0D2uEOuTWoSs/He8NMkTSc=
X-Google-Smtp-Source: AGHT+IGe/PQZJEf5gTpe3Qj3z8NAvg1R45BbPbrsdavVKhN2FFhW7JZT5OmWh7zVxEj1sac9wjAXyA==
X-Received: by 2002:a05:6a20:3d06:b0:35f:c643:105e with SMTP id adf61e73a8af0-376a81dc6e1mr3504223637.34.1766167598563;
        Fri, 19 Dec 2025 10:06:38 -0800 (PST)
Received: from carrot.devel.local (i114-180-53-102.s42.a014.ap.plala.or.jp. [114.180.53.102])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7961c130sm2688468a12.3.2025.12.19.10.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 10:06:37 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] nilfs2: Fix potential block overflow that cause system hang
Date: Sat, 20 Dec 2025 03:04:25 +0900
Message-ID: <20251219180631.27554-2-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219180631.27554-1-konishi.ryusuke@gmail.com>
References: <20251219180631.27554-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Edward Adam Davis <eadavis@qq.com>

When a user executes the FITRIM command, an underflow can occur when
calculating nblocks if end_block is too small. Since nblocks is of
type sector_t, which is u64, a negative nblocks value will become a
very large positive integer. This ultimately leads to the block layer
function __blkdev_issue_discard() taking an excessively long time to
process the bio chain, and the ns_segctor_sem lock remains held for a
long period. This prevents other tasks from acquiring the ns_segctor_sem
lock, resulting in the hang reported by syzbot in [1].

If the ending block is too small, typically if it is smaller than 4KiB
range, depending on the usage of the segment 0, it may be possible to
attempt a discard request beyond the device size causing the hang.

Exiting successfully and assign the discarded size (0 in this case)
to range->len.

Although the start and len values in the user input range are too small,
a conservative strategy is adopted here to safely ignore them, which is
equivalent to a no-op; it will not perform any trimming and will not
throw an error.

[1]
task:segctord state:D stack:28968 pid:6093 tgid:6093  ppid:2 task_flags:0x200040 flags:0x00080000
Call Trace:
 rwbase_write_lock+0x3dd/0x750 kernel/locking/rwbase_rt.c:272
 nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2569 [inline]
 nilfs_segctor_thread+0x6ec/0xe00 fs/nilfs2/segment.c:2684

[ryusuke: corrected part of the commit message about the consequences]
Fixes: 82e11e857be3 ("nilfs2: add nilfs_sufile_trim_fs to trim clean segs")
Reported-by: syzbot+7eedce5eb281acd832f0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7eedce5eb281acd832f0
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
---
 fs/nilfs2/sufile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 83f93337c01b..eceedca02697 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -1093,6 +1093,9 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
 	else
 		end_block = start_block + len - 1;
 
+	if (end_block < nilfs->ns_first_data_block)
+		goto out;
+
 	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
 	segnum_end = nilfs_get_segnum_of_block(nilfs, end_block);
 
@@ -1191,6 +1194,7 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
 out_sem:
 	up_read(&NILFS_MDT(sufile)->mi_sem);
 
+out:
 	range->len = ndiscarded << nilfs->ns_blocksize_bits;
 	return ret;
 }
-- 
2.43.0

