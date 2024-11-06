Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8F82064ED;
	Wed,  6 Nov 2024 16:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730909298; cv=none; b=dYheR5te70OPabZ4x1TFQDhqysa+9mcBU+Z/ZZGj5vHsN+stZgJDBW4hYGDhZf45q40dAW+kTnfinneGEy7M8W5fCCzbdif/DznV2PrFhteiC4yYZcolBEBUADlQttP1tScnJy+hiL9b4LRODzkf12g9kwJArHZ/GuyzmPREgGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730909298; c=relaxed/simple;
	bh=JJmKb8/dtMAe1mZtrEBDHhFb04BdwpMXEsX6P3zTUa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkMsp59MhejaoUSLz+MK+6bUjw/FaaJg8NkjhIACPIPXR1c4NbAMkmFQtLTJ7YeSHa25mwB98NWcToZOtLcUcBhsTOlYGuR/OdHl7CdzoJjYyLtfCbdpTaLabMHGHxyL1IG3cDdxq0m6Tie4AdOfIelO2s30Gtt6NiuAINQZbtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CZAho2Uy; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZAho2Uy"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7ea76a12c32so1937a12.1;
        Wed, 06 Nov 2024 08:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730909296; x=1731514096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uWVgiw1PMvx4ovMJaY9CohyriMrKQ0YReuKZjfQ3WO4=;
        b=CZAho2UyeA2H4OVkUHPh3ENiw48WDEqZbA3clIxd5jCuwmHp5Sovne7sLEb/jEwGz2
         KZSTF4/GWAM6i3bp+1ehDS0YqyRcI8//P2UZHSQ6ELvNAW9UdsuI6Rdr3atHljRxOP1n
         rcSGC5lLn9kVb6B4Sd/+eukmadbSPFJlljo9O8EhR0S/rrQ3vYBax8xq4aKswnYavEUu
         HOcqYZuJp22ssBawRTYLrk1BxkdVKKVjwvz8EJXU3e5WGby/YHa0RcPQYhBJDMWCQnRi
         C8YeF2aQL7e+OlA+5kKx/CIxOzabjeIfXUkAobReZT0qA2HIZehQcHJnnW4K0AiFoIA7
         F41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730909296; x=1731514096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uWVgiw1PMvx4ovMJaY9CohyriMrKQ0YReuKZjfQ3WO4=;
        b=Pu2F1Ipl3FxlHfHmzEHKPW9ViDHwLQ42l+TcaW4ABWrP9p8bxH6sZvqw+KF6kyBEEd
         YJjd7nPOGsbVvi0C0Apfsh6CoZP3vSIl6qRdxnY+Q82xw8H5vhAssPqmjkxlvMcZvNpb
         kr9/pGkUzCWgGDEezgAXNB8UARFniy5TgAkaQW1kfCrhlzpmw44Irk4Gp1kk+/LncKF2
         owez9XBOMcVVEp1/+k8bAAXEHND96PWCwjA+e2Im6K7uOI4MzBLwqFNVsmm+A+bT6oeq
         FbGQfZbi78NnFiVOjM2hXe1casn6B1I66v7GRhGlUPGE/KhtAtnaN824IHvF4uGux85m
         j7vQ==
X-Forwarded-Encrypted: i=1; AJvYcCWa56MdaSzjQk+21wvPkxxdcyEvGU+Q+u4t9PgCeF/7IRzo4SdvKSOH13Pp/7Atz5jJHmF7aCnquzXWzYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDQzSXinfZRlHsNE11Cf/6C8jMRRB2fVylVLGfx40LXPeubbww
	yJ8P1tAks2zr1EnJDuB0woTy/bWaoa5gzEZETTzhh7dg+JrKTQ9c
X-Google-Smtp-Source: AGHT+IGy6qICRptlaOd6/ohReRo+vIf4ipnFxTOvETzFHoSmb5HUD3llQNz5vDEL/w1NyNuLGlrgNA==
X-Received: by 2002:a17:90b:164e:b0:2e0:a77e:82ff with SMTP id 98e67ed59e1d1-2e93c1f2029mr33085079a91.33.1730909296163;
        Wed, 06 Nov 2024 08:08:16 -0800 (PST)
Received: from carrot.. (i114-180-55-233.s42.a014.ap.plala.or.jp. [114.180.55.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e99a4f9ef0sm1715476a91.3.2024.11.06.08.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 08:08:15 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot <syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	bugreport@valiantsec.com
Subject: [PATCH 0/2] nilfs2: fix null-ptr-deref bugs on block tracepoints
Date: Thu,  7 Nov 2024 01:07:31 +0900
Message-ID: <20241106160811.3316-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <672270b5.050a0220.3c8d68.052a.GAE@google.com>
References: <672270b5.050a0220.3c8d68.052a.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew, please add this series to the queue for the next cycle.

This series fixes null pointer dereference bugs that occur when using
nilfs2 and two block-related tracepoints.

Thanks,
Ryusuke Konishi

Ryusuke Konishi (2):
  nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint
  nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint

 fs/nilfs2/btnode.c  | 2 --
 fs/nilfs2/gcinode.c | 4 +---
 fs/nilfs2/mdt.c     | 1 -
 fs/nilfs2/page.c    | 2 +-
 4 files changed, 2 insertions(+), 7 deletions(-)

-- 
2.43.0

