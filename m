Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B401494AC;
	Fri, 16 Aug 2024 07:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723794224; cv=none; b=jSngcbLEFE1xo8DXXQmWLBpAwLTALvAyPQQDTtZ+VYNJ0usqZ2GUKg2qpemCWoXWmb9I1yFAUj/lZDRNP5IktsLoA7d7j3yS0wHafTQiAuZSn/KpZSNiTtWpr1WF4BYucmab5VoYfhjJK4VJhJNxjwYvgtI705+VOItNMkh3Iyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723794224; c=relaxed/simple;
	bh=d2TlnbwTBK2JYwlfptEuI9Zy8jS6k77+C5E/10Wi1pg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iSBR+7GMS7Kd0MhjIjRJGvYxhX60QV/KmDi1wAxly3d6/AajNtZ08UXIzgCbd3KqbR8HeZpUCZldPpK1k0ByYPBZ+SY/CNmPEiDI8/VMRgg7DoN3rTQpVPs31wgtHUXVpV0pmGDJxY1ky3ZFJAp5297crGC3GkGXwFkQ/DjCbxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LShvRTmK; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LShvRTmK"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3db1956643bso1092794b6e.3;
        Fri, 16 Aug 2024 00:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723794221; x=1724399021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SnrqputMzVeb+Pe5/Tf78NeSauXPf5xkVwyJAK2U1zA=;
        b=LShvRTmK9H94K2HEf4Guxu+r4KKrEpBmUzywChdlmt2Zs9V83WDs4C/BwpPVhBS4XZ
         /NN+XInx24WUSIpR+FR0M/qL5WLF5oNwdfdG0GSr67FYiz9ml5PNZ42X6ALb/OBEtCeg
         JVW6WNwD/D1qLD5OFQXsmhvS/zlBQw1CJhhq5cW1ZRhOZnqvLbRxrnoHxAKQosfoxuY1
         ARmSxdK1HKVZ8ePbrGy5jrfd/MlKBnN3fK/CESyPGVN6ODcWq2hzi3zh8fGzeouFwhUp
         MWt+VOd2D9HXkzs0Zq2bJEtvQ5DU/a2/702G6Id/5p4Frb62Kxu3C2Hz/bkkCgs2I1LU
         Y+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723794221; x=1724399021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SnrqputMzVeb+Pe5/Tf78NeSauXPf5xkVwyJAK2U1zA=;
        b=bc0LYwsPUaRklryeyR/i9OQsCFlgCOVi9KQT1rFP+DBNXHsUhP+CeKcsSabF3/VSzi
         ZGljIgLkERSYiUhpuEcduvC0RXcybTW1G6HTKcE/sh8GiSDPda4ygDj4kpIJq6ly9cK1
         j14hp2g5rAnmngqwfADKRJZSSrmLXdUj7qi6uJbmDUpt6lT1KO+TJSC/k0ZXF8Gv7WDA
         bTwcMMu8PulifS9Q/45QyEDz5W8bPcWm+wzTtFJSbdjCtdQI18Pof6aonqFpNMfzx4P5
         kikQ3SdpNCCxYLFALF2IFAquXxE7s/wRbEP83GFyVCAK1GYFUtDrCdGti1/1XqrhRIAH
         XdyA==
X-Forwarded-Encrypted: i=1; AJvYcCVtq0cSaFuOUE3/bg/5yo7dnBcWNooC95mtu29H4NA+HfMnbuTIYNeBbICYaHdDrHD8IDcwx027591iu5BzqcV45gOAPLTUbebcv1+K
X-Gm-Message-State: AOJu0YyL/VqAVS474aw2cwYd6VmylS+CWdwu5VdXIVxDxi11pdYpWZrx
	tbXmOGJolheQhMKq20GA3ng3Cyub5uqIXL4GtfLwvkE6yMiDPHHN4unbIg==
X-Google-Smtp-Source: AGHT+IEY/CQUFGdxkonxE+EU5Oj4AViY2IsRD8KpOwnFyTJUCoXjPgvBGG1wqfpfbbNNwhb4VInH6A==
X-Received: by 2002:a05:6808:1928:b0:3da:aac7:4380 with SMTP id 5614622812f47-3dd3aceab22mr1889285b6e.11.1723794220901;
        Fri, 16 Aug 2024 00:43:40 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61e7c7asm2365971a12.45.2024.08.16.00.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:43:40 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] nilfs2: add missing description of nilfs_btree_path structure
Date: Fri, 16 Aug 2024 16:43:16 +0900
Message-Id: <20240816074319.3253-6-konishi.ryusuke@gmail.com>
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

Add missing kernel-doc comment for the 'bp_ctxt' member variable of
the nilfs_btree_path structure, and eliminate the following warning
output by the kenrel-doc script:

 fs/nilfs2/btree.h:39: warning: Function parameter or struct member
  'bp_ctxt' not described in 'nilfs_btree_path'

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/btree.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index 92868e1a48ca..2a220f716c91 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -24,6 +24,7 @@
  * @bp_index: index of child node
  * @bp_oldreq: ptr end request for old ptr
  * @bp_newreq: ptr alloc request for new ptr
+ * @bp_ctxt: context information for changing the key of a b-tree node block
  * @bp_op: rebalance operation
  */
 struct nilfs_btree_path {
-- 
2.34.1

