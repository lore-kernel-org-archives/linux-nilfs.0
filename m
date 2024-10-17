Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E321B40858;
	Thu, 17 Oct 2024 19:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729193652; cv=none; b=SoUjRM0D/5MSXfRYwE9orkCJwZ7gC2kNKKfATEvOlfszuDBUWWn5jfklj8gGqE5uPRG2mK/uFWWHoKXzkGgKzHVNTqWVsnKzwv9lCd3P0ofzwgAvphO9D6URS2VL9x6xvSJYhJq0Vx7cM7LIoz3bsrUfz297bCrWsKYsi8iaW3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729193652; c=relaxed/simple;
	bh=51XDC0OMQ9nal+R9BQzWaW5MrDNFkuV0pYP+8zrNXBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1GXGOL+nkRiHzMS4GLRFrW4Ue0vQRnO9VNEmSGZzCqR3QGxFGX2YebMYGAxG2y1omVrVcetz8YYoSTGEx4EHf3K88vEsBU/xaJWxTa4agoirWVifgr0yhNwe+2CDCEdLzdWEblpPDfE1KTH7dV/T15utTEKnIErA4HMNytbZrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fKNa5+sq; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fKNa5+sq"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7e9e38dd5f1so1051069a12.0;
        Thu, 17 Oct 2024 12:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729193647; x=1729798447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zibIy/kvkKs/QaBIbThYuE2kzTK1P93FRUnGGYpOnEw=;
        b=fKNa5+sqlnTsbylaikd0JFyaUYTHEveFbzQ+NxJaYk8aD+ag4/ceNF2Krp/SS/Hd4W
         7NS++bjwibNNOyHrsnYCWRnWVuDqQ7drPflO6QcHuBLJCbYTfjrcX5cntfTDNM5lWgrx
         i22w6yDFg3SozAHYOxq0jybkEB+sCm8FUsrRaG2xOASC/WtklR5MlG94NM9mX73MpuUE
         X1Hbv9/7Qa71+oOitNA8jemUJUd0bo+FXu1fncQ1jddY3OenY2kfN22OSe+IFQCKYUTk
         94AVUJkP4ePJLK5wqqDuEo27EznBUpga1YFrzaZ23QDEkP+f3+hla9VFd1+zeRzZLMei
         BkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729193647; x=1729798447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zibIy/kvkKs/QaBIbThYuE2kzTK1P93FRUnGGYpOnEw=;
        b=NUHZiqchSMyBog6Yr0MCFQOTSRGuQb7VccvcD3rbgLPAZ97Y9fDIF7LDELqPc15f7z
         JBlreapTKJOzMzqydzQLl3hTzaPXq8NWbq2fDX5PHzRMrDgZ67VHkkrCPOUwy9Din4CX
         wyZr3EkEO3O4a/MldRPvCvnvNNedwwmrsO6ViQAWyx8DJ5VkeyixAYGu6jcBkwrjTYSl
         DHMFwQyJ2s+sbyqUoPhTfeTaPt0XSN4aHGOxckT/G6c9OOBKr77fhXixAl/+sshqEILS
         Vhildd2gEEWNufcziKWadAfMu2/4j1GDzugbkaIysScQmLycQNMc2nEleQXsV6f39nfL
         NgVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHc7n6bihlBgFVZumD4NEBxqvkbfaNIc51g/n6cvDuG1AtWhrPfLEO4MaqXvzeSxeU2habYpeg1WQ+iYc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+eAUVL7stWoW1EdUVYZ4XzjdfpOFPOky+5WyXDNPmJyuHy+6P
	TQw35gN3i3A5IxE4KFEfZiLl8eAjvTbFFUduXW05/T5ifxkPI2kD
X-Google-Smtp-Source: AGHT+IGZdK8AevECiWf3nnn3K9UGd/yQoLK2r7QAjSv7uXKkId1/G6akCdTdScRDdS+hF7YJpFXu5A==
X-Received: by 2002:a05:6a20:d70a:b0:1d8:b076:d9ad with SMTP id adf61e73a8af0-1d905f59327mr11962742637.40.1729193647054;
        Thu, 17 Oct 2024 12:34:07 -0700 (PDT)
Received: from carrot.. (i118-19-49-33.s41.a014.ap.plala.or.jp. [118.19.49.33])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ea34a8077sm11501b3a.190.2024.10.17.12.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 12:34:06 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot <syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: fix kernel bug due to missing clearing of checked flag
Date: Fri, 18 Oct 2024 04:33:10 +0900
Message-ID: <20241017193359.5051-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <670f8e80.050a0220.d9b66.0163.GAE@google.com>
References: <670f8e80.050a0220.d9b66.0163.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported that in directory operations after nilfs2 detects
filesystem corruption and degrades to read-only,
__block_write_begin_int(), which is called to prepare block writes,
may fail the BUG_ON check for accesses exceeding the folio/page size,
triggering a kernel bug.

This was found to be because the "checked" flag of a page/folio was
not cleared when it was discarded by nilfs2's own routine, which
causes the sanity check of directory entries to be skipped when the
directory page/folio is reloaded.  So, fix that.

This was necessary when the use of nilfs2's own page discard routine
was applied to more than just metadata files.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d6ca2daf692c7a82f959
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Cc: stable@vger.kernel.org
---
Hi Andrew, please apply this as a bug fix.

This fixes another kernel bug recently reported by syzbot.

Thanks,
Ryusuke Konishi

 fs/nilfs2/page.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 5436eb0424bd..10def4b55995 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -401,6 +401,7 @@ void nilfs_clear_folio_dirty(struct folio *folio)
 
 	folio_clear_uptodate(folio);
 	folio_clear_mappedtodisk(folio);
+	folio_clear_checked(folio);
 
 	head = folio_buffers(folio);
 	if (head) {
-- 
2.43.0

