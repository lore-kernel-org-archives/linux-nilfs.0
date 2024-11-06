Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D599206512;
	Wed,  6 Nov 2024 16:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730909301; cv=none; b=Uhj4hvWN78Ox+cn0VJCtBnw/PzdwGrMUehDHkhCtTDKx8Kwcey8cCrg+NjdghogI0dUPoap2Vx4gpYrI+TTNE+MPuOLGyWu8MMt1BMp2xzkh0DGrxI3Tgd+A0sYXvnVkGTWyAbKmeSpXD3OYLVzLGNJomwYng0hYVX57MB2MHYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730909301; c=relaxed/simple;
	bh=jNJBL1rHtTTUpCI6kZYq+CuUh5QuDwEjynn/Vf52+64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pv0wnwfp65+QF9HWT3oF88AK5i8PI5r/33X3J3InOw2Y9RJ5a7fd6fSdv5+avpROx9M43T8vgfunXeyvvIB2RGL8f62cZ8m25T4fWIGmr/Gmjop5pBulm00DPqtm1LotFN2Db/k0ix5qFEm9N3EiJifX550/qbvB8r5TctLnLgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HNhO30b+; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HNhO30b+"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7ee020ec76dso5649583a12.3;
        Wed, 06 Nov 2024 08:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730909299; x=1731514099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GRC/e3yt2TW+5Ss4CXPhQ3NBWPcYT3OY1sRprLMV3rc=;
        b=HNhO30b+uvpz1sE1pXo0JG9kTt/MuajKK+zhqk7jFHhYc+Og/z9HIA2iAbroFVtuR1
         7qSpjVU0lWu2bMR1QVmmk+WDYEIx8dERke4oV8WYiMcYg9jVSyml21L2dhlbw2KXVwu/
         sqUA07EJIAIsjrVXX1dgwGrt1YF9sDjMiKWInRRwc+92d4OIRXfJZ23/76tHwSM20RtO
         aera1+6Zq3h8PbwkGs7liu0+sXxXLBPTKUZhBpuCst0p3JLG7HP8Wdz6voO/4JL+VLAb
         6cI4TXNiTVbgC+HUNxeKXjCc4FQlPFBBgspj7G/H1d7VPbFQZZWm7pJajxr7l5Ccrodx
         GDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730909299; x=1731514099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GRC/e3yt2TW+5Ss4CXPhQ3NBWPcYT3OY1sRprLMV3rc=;
        b=SQEIuEinPPFHhhSpxohspWjHa6MKNJ0ty0r99Oy0udUEgOh2yWJEnZH+A4ONi284Rv
         B4LWsIVQsKHcJPk/kKkAKQL6lzbOYRwbuKPnYqkcj0mghiDaAiif3UYLJeiTWbXwpkCW
         5LbQBPkNPFx+Bpc5BKflPWy972XnEtjn7KCzw+uEAM401HqSLUjRGjDvDe0IRmf4FKS7
         JIDNaBmAS3lYr7uYcvuz9e1+blkU1Iz6+FRugesTPSyt+SCwI8JGHU0JLwDn1GNuDATh
         4LWWTOlMTcQh3W77KYpl+X8oNuBjbtDnFkJ84TpEWdY1ZbhwyZOage6f0al7YyILMDL0
         Hb7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWvJyLtV9kl+cwPfZbnBLaMZbETa++/EGGcm0fhng2XKDw01h2TjWkPWkzqTV5yl6CfxO3mEgJL1gn3N00=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/aIqOzhtVTwqDnVWls0o7VqeMWPz4MMATNobz7DKgl51akmAi
	eeG35wYq4jQ81NCx+Vupryan3/OarnuYGiCbUoWZZ9UxxX+Hqnag
X-Google-Smtp-Source: AGHT+IFpK9BKpJD4CSfhO0rlzSp0C2YtrNIWhb+i6yHAn8iez0VRC1SHnrc5WRuLdLZDy4J6PybCTg==
X-Received: by 2002:a17:90a:b30e:b0:2e2:daab:cc69 with SMTP id 98e67ed59e1d1-2e8f105e941mr41083264a91.12.1730909298774;
        Wed, 06 Nov 2024 08:08:18 -0800 (PST)
Received: from carrot.. (i114-180-55-233.s42.a014.ap.plala.or.jp. [114.180.55.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e99a4f9ef0sm1715476a91.3.2024.11.06.08.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 08:08:18 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot <syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	bugreport@valiantsec.com
Subject: [PATCH 1/2] nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint
Date: Thu,  7 Nov 2024 01:07:32 +0900
Message-ID: <20241106160811.3316-2-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241106160811.3316-1-konishi.ryusuke@gmail.com>
References: <672270b5.050a0220.3c8d68.052a.GAE@google.com>
 <20241106160811.3316-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It has been reported that when using "block:block_touch_buffer"
tracepoint, touch_buffer() called from __nilfs_get_folio_block() causes
a NULL pointer dereference, or a general protection fault when KASAN is
enabled.

This happens because since the tracepoint was added in touch_buffer(),
it references the dev_t member bh->b_bdev->bd_dev regardless of whether
the buffer head has a pointer to a block_device structure.  In the
current implementation, the block_device structure is set after the
function returns to the caller.

Here, touch_buffer() is used to mark the folio/page that owns the buffer
head as accessed, but the common search helper for folio/page used by
the caller function was optimized to mark the folio/page as accessed
when it was reimplemented a long time ago, eliminating the need to call
touch_buffer() here in the first place.

So this solves the issue by eliminating the touch_buffer() call itself.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Ubisectech Sirius <bugreport@valiantsec.com>
Closes: https://lkml.kernel.org/r/86bd3013-887e-4e38-960f-ca45c657f032.bugreport@valiantsec.com
Reported-by: syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9982fb8d18eba905abe2
Fixes: 5305cb830834 ("block: add block_{touch|dirty}_buffer tracepoint")
Tested-by: syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
---
 fs/nilfs2/page.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index e48079ebe939..bdc4b152f6e9 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -39,7 +39,6 @@ static struct buffer_head *__nilfs_get_folio_block(struct folio *folio,
 	first_block = (unsigned long)index << (PAGE_SHIFT - blkbits);
 	bh = get_nth_bh(bh, block - first_block);
 
-	touch_buffer(bh);
 	wait_on_buffer(bh);
 	return bh;
 }
-- 
2.43.0

