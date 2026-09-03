Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0C54AE8B2
	for <linux-nilfs@vger.kernel.org>; Thu,  3 Sep 2026 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788456362; cv=none; b=DYgN+BiSf9UTdewVK2XgUsDcW30ONiRIcaUSvfPMyCsS+eofnpZzc7qZnON3RMFSbz95Kk9fDww1VCtFikijXCHF2aprdAgyHDfFvcBVfjdKD0f7wk1Lk5a8pUeFt2lyXxmPg7A0oTwZJzCoc+icj8HhzSfDz+0rfdOzVUD5Pc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788456362; c=relaxed/simple;
	bh=w+O1sH22NArhRo9yhibk82VLhoaLFZB8GNRWPiP5ibY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bkGGa3ktppDAa7EO8Q8Xsydg9eSpqFfAmMAA/Kk9ydmvwIHp+Mr9Ra5V5zbkPvOiBadKNOYqjVmvCvm/VZe5vc8+/6Z6PWJd0RUzhkl/XH0EpZTAX1dHacuy59HcjetjJ6+nku21mda3hngy5W/9BR80YAvKFSPa+5HCMjaXiuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eKpjyoh9; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eKpjyoh9"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-39675172593so22947a91.2
        for <linux-nilfs@vger.kernel.org>; Thu, 03 Sep 2026 10:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788456360; x=1789061160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rO8qlfauoesgDqAvc32sBU+CCSZKWvXFmYR0AW+q2uo=;
        b=eKpjyoh9vjEqyL3PgXUGo0aabTrr5fw5qRWLo/m+T41MTImRfqpXsOomcxFLnghGA6
         WJt0MpP1khd/XLEko8Npo5TWfqgLB1W/yidC1NdTLqPZL7+UH0RcJqtJEwXKVPDsmyXy
         WwnEaJrphdWhqO1HwcTIvRdD8malOBC/rgKC5I91EhlNTGoJOZ0urC7HlL/gyhBT1NoM
         OrUl+Zp0iD+fn0pHCDI0EZ4bjympQGSn6uYqq1KpYA/forojB1Zm+tQ/WLohVELA8k/8
         xJC8DhROvUH2T89iBih1OOME5Xo8FyWRqB9PW18zI1L4bqYuJ9qB7ANklL3m59hpwva5
         JStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788456360; x=1789061160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rO8qlfauoesgDqAvc32sBU+CCSZKWvXFmYR0AW+q2uo=;
        b=H4y0iirbmxqtRdofibMzbElfUdqrDgm5l8sE2m26al3roRdTCWI6zuBTnB+JAKeowQ
         xT6BKiiUuSLc8eh0xwdME/B4gp8mBqQen1K9as0q2au2w8WjZiNQsfDkgTf7RW9km1o2
         G8qAfbw2sgZPBt4eaOIAMLGqrA96Wz6jLFKIr4Jfcn/GB2WyIAfF7KbBnArlNBpL1Ye5
         9eM+SPfv5bCqN6xSGfM2QiAH9elrM9nuRSeTOReleWfBwBzSb2YaO6af4GhrTN0bXIBT
         e2m7fUXD4nmgOYKRobXGM50NhI4kPyX0FhlNSvHerWYnXwFugvbZhf9uOSuI9WFPkcRr
         EKbA==
X-Gm-Message-State: AFuF++mTdA1dkujEdSDs7hDljO3VIlJPjlX9EPlRc5p7176t0iC5Yk87
	DDfoyHkM6wfCVvLxCtcFFb4feraIFXnqGWH8iNRwLS1DaF4fbJo0HTG4
X-Gm-Gg: AYBFou2sWm5+99d0/wHgiKmial5fTs8Ne8KhJzjdPgER2AEpUx72efJMa6UUKFa3sG+
	EBaMp/VH3vzdRYL0b2Q6tqqxV6pkuj33+jH398DknPeb0aJtsuoSAmLtV+e8dlqhOgtWV8kGuQ+
	wWYggfK9bINJfFTiPKxAjcdo1csyEV9Jj18PtCtIqwa2WWlJoU82t5nlpNjUC5qtoO1bwNSRNm4
	Z6w8m1jSdozI9EAF4ba3izYqWh1Pc7zShTT+UgdHjUJq0bPz0IGjfjsk7KV3pKIhsurTXv/2SE2
	02JXaPIstMYCMkgrrPtPXLSbEje24dTmh5Pvu1qlhdBC6JVvnu2GdT7YlwTuKHgSU6zbjOOMixb
	wfa8Ukucb0eOgwdrw4Y/kqwOjuboyYwQjxtnxGHjgX/wt9q9fZHQbBcZ1zWgFN6iBUZPJkk37qn
	7n/+hfPUpxX8gurO1Vc2C2Y8zUPUhFXMI5MimT7rI3dkJLV7gCc6MBSqg+2QS2V9CdMxDXX+Is9
	7XU1jt2DcUd5r3vC4tJrQU=
X-Received: by 2002:a17:90b:5106:b0:37f:c22a:c188 with SMTP id 98e67ed59e1d1-39b260feb03mr87910a91.4.1788456360320;
        Thu, 03 Sep 2026 10:26:00 -0700 (PDT)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c39227sm6283070a91.9.2026.09.03.10.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 10:25:59 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] nilfs2: strengthen consistency checks in nilfs_direct_propagate()
Date: Fri,  4 Sep 2026 02:23:58 +0900
Message-ID: <20260903172557.9446-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_direct_propagate() is responsible for updating the virtual block
number associated with a dirty data block in the direct mapping.

It is not designed to handle intermediate node blocks.  Furthermore, it
assumes that the block offset of the passed buffer head is within the
range of NILFS_DIRECT_KEY_MAX; otherwise, an out-of-bounds memory access
could occur within the inode containing the bmap root.

While such inconsistencies stem from bugs, they can cause silent,
harmful side effects unless a debug kernel is used - as was the case
with a recent slab out-of-bounds access issue found in this function.

Therefore, issue a kernel warning via WARN_ON_ONCE() and return -EINVAL
for these anomalies, allowing the bmap layer to handle the situation as
a filesystem error.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please queue this for the next cycle.

While the recent out-of-bounds memory access issue in
nilfs_direct_propagate() has already been fixed, this adds extra checks
to catch and gracefully handle similar potential bugs.

Thanks,
Ryusuke Konishi

 fs/nilfs2/direct.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index b8643d3aa2f8..64da677dc8d4 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -270,8 +270,14 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 	if (!NILFS_BMAP_USE_VBN(bmap))
 		return 0;
 
+	if (WARN_ON_ONCE(buffer_nilfs_node(bh)))
+		return -EINVAL;
+
 	dat = nilfs_bmap_get_dat(bmap);
 	key = nilfs_bmap_data_get_key(bmap, bh);
+	if (WARN_ON_ONCE(key > NILFS_DIRECT_KEY_MAX))
+		return -EINVAL;
+
 	ptr = nilfs_direct_get_ptr(bmap, key);
 	if (ptr == NILFS_BMAP_INVALID_PTR)
 		return -EINVAL;
-- 
2.43.0

