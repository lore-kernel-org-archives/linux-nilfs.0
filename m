Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D72815FA79;
	Tue,  7 May 2024 14:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715091903; cv=none; b=r0qMSguAZCYStmLcbJ88Aipwc0tW2JNi8iHpwSdkrOf6lezdOE0sNVE4Lsp4g73S6gv4UzngykjbageFumwTDcOjqxB5aFn9+2LqZlcf6/HeibeyY2NG02TjTpnvQFZUrbYCaD5lmX5mh3OJ82GoyvS1MhVnX0469c2wjD/JbEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715091903; c=relaxed/simple;
	bh=+IdeP0WxTQxueZFiufonTCIn4CaPWcqXKf2H5nxLy3I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=izY62xA5OFQU2kFqCIPkEbZtKuy/Ei0+P4iJzG5nYDSa8kMoHtdA1WKsmWmgYpDstxuNVhAwe2fyyg592WFeR5whaj3xOeCfgwfT/H+O4COARVrvW3VaLb1UzuF+rBvKV8rBxmcR8jwfWZgF0/t8rybL3zivewNsWV2j2HGDhs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XIS9Otwf; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XIS9Otwf"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1ed012c1afbso24420215ad.1;
        Tue, 07 May 2024 07:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715091901; x=1715696701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mLOr8T9rn6W4Mui4y9GmHNfyW1LxBncW4ibg3T7qe5A=;
        b=XIS9Otwfbg6X+kxGOul8PxBtEZErKGVz/ENeM18Jqr5hqhuJF+DcgzmTCy2mRUD248
         cTqKyYtbSYIY1OcLaBc1xaClCC0te2IKob1gpfhmBlR9u+mvAi1BYlL8JU5u0Jz9jNvP
         qnYamVZk1l/efbID56gcx9iTkKwrHjNxE/FDmHhbS4AL3xAjPwymxF/91OyNb/cRBASy
         0hWzhR8f5s6u/KLFCIwZjSuq5c58eDyCzI4GtqFOkjOjOpt8WhqKx3vmSdcIBYBB7nnz
         sKfsekTIgNHN2ndH4f+o7dPKeyLn60qrwljd6QyLc1Ax/KGQJ3/pWL+nWUzpJuAgtSij
         oE5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715091901; x=1715696701;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mLOr8T9rn6W4Mui4y9GmHNfyW1LxBncW4ibg3T7qe5A=;
        b=LbTDAnXWaWVKZ4+TouY1CTnj+ZuiF1t5N3XwuVNwqvIO6QMRFWs6j095L99G8P9j2Z
         6FWKQgTy5vz6Ij8aO6HiArPFG7ofY3UND+nLwDSPiPDl0zSL6kNqHO7s7uPjfgOq7BNA
         4wnjUZGCwwdq2+bCsJqDCd4MGG3uGlbB6J2QpcnZnbGPtnMRmlSFlQPo0IsV4kgaUq78
         +A8gOUNKBXmov8keA63hcTp0zXjOKEkyhGsclJCYSRf0JpE8xXy5XpGPPdBqqia7T90o
         ViJKKmo6fvzuX8nvOfTTfNI6GxpyTgSlI7RYTCeNkB3UyCwuM2aFacy6+IKsOk1j9Lnq
         yAdA==
X-Forwarded-Encrypted: i=1; AJvYcCV8hOnqskuVSHD0779wpaVi0QT5Dm6siIhXn5VRBzSL60OCExqk8wjI6irba8zkJyUkkTH48oMvHSxzHuSZhVJdHbteYpYAPq77NBBf
X-Gm-Message-State: AOJu0YyHjyZqCAwROtLdxHC1KoKqRP1Q8mKIHZbwVRmnrJMrqT5DWsF3
	u2uSSA+OVkMc3Dnp1sA62QWFYIM1fjJIMBPwmq6GQ3HHoMj/PFOVgcd1fg==
X-Google-Smtp-Source: AGHT+IHuDDbaVCQrzL9ZE7Rxk221c0XDYvkAhrpc4yZ9dwfAawVlc+FjU83xuKfP4/aM4r9AVMxtjw==
X-Received: by 2002:a17:903:41cb:b0:1ec:25d3:7335 with SMTP id u11-20020a17090341cb00b001ec25d37335mr3998626ple.26.1715091901185;
        Tue, 07 May 2024 07:25:01 -0700 (PDT)
Received: from carrot.. (i222-151-5-6.s42.a014.ap.plala.or.jp. [222.151.5.6])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090341c300b001e245c5afbfsm10075091ple.155.2024.05.07.07.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 07:25:00 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH -mm] nilfs2: Use __field_struct() for a bitwise field
Date: Tue,  7 May 2024 23:24:54 +0900
Message-Id: <20240507142454.3344-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

As one can see in include/trace/stages/stage4_event_fields.h, the
implementation of __field() uses the is_signed_type() macro. As one can see
in commit dcf8e5633e2e ("tracing: Define the is_signed_type() macro once"),
there has been an attempt to not make is_signed_type() trigger sparse
warnings for bitwise types. Despite that change, sparse complains when
passing a bitwise type to is_signed_type(). It is not clear to me why.

Follow the example of <trace/events/initcall.h> and suppress the following
sparse warnings by changing __field() into __field_struct():

 fs/nilfs2/segment.c: note: in included file (through
   include/trace/trace_events.h, include/trace/define_trace.h,
   include/trace/events/nilfs2.h):
 ./include/trace/events/nilfs2.h:191:1: warning: cast to restricted
   blk_opf_t
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer
 ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
   degrades to integer

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401092241.I4mm9OWl-lkp@intel.com/
Reported-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Closes: https://lore.kernel.org/all/20240430080019.4242-2-konishi.ryusuke@gmail.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Andrew, Bart has completed a patch that fixes the sparse warnings
related to event trace header, as he kindly shared the link with you
earlier.

Here is the patch (I added a few tags), could you add this to your
tree queue?
I'll send this via email just in case since we don't usually exchange
links.

The patch "nilfs2: use integer type instead of enum req_op for event
tracing header" that I sent is no longer needed, so I will withdraw it.

Thanks,
Ryusuke Konishi

 include/trace/events/nilfs2.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.h
index 8efc6236f57c..8880c11733dd 100644
--- a/include/trace/events/nilfs2.h
+++ b/include/trace/events/nilfs2.h
@@ -200,7 +200,11 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
 		    __field(struct inode *, inode)
 		    __field(unsigned long, ino)
 		    __field(unsigned long, blkoff)
-		    __field(enum req_op, mode)
+		    /*
+		     * Use field_struct() to avoid is_signed_type() on the
+		     * bitwise type enum req_op.
+		     */
+		    __field_struct(enum req_op, mode)
 	    ),
 
 	    TP_fast_assign(
-- 
2.34.1

