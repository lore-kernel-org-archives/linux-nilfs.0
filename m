Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF95E1B1D68;
	Wed, 21 Aug 2024 15:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255194; cv=none; b=BKdn9RahU1SW0IFtggvxFaMEhd7xtWwBjHAKNK+z4EoLZVTGC5WKecAWgiAfYArUDUq5tslcTXrq+pfgkGK/8hAth2UVoajX2IDSPVGkp7CiEmOTrUWy616iVvqgEixa5O+eN3oYiYU1gFAcG+yL/MUNfy4hAWREgvd3NNm0hdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255194; c=relaxed/simple;
	bh=q6kOuv7JmGx5f0uRi29l8qYMyWDFaKek+Zzbz3CBl0U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cJoGUaB3sOIZUHwun9bGg6lfuor7i3RnNRP3MwFUeQYMVA1qDjsr0dIbCFYMadbBfiAw34+SKNDtu4fgGxOl5Uwy71Z+mcJIsZ2IOjacEHUG/98bl2ZlxObka0VDefBeTgmy0cts7TsLZMoIoabueKFO1EfOuQaTgCd6q9KLiM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gNYuhW3L; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gNYuhW3L"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2cd5d6b2581so4811235a91.2;
        Wed, 21 Aug 2024 08:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724255192; x=1724859992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kDmBWhoAI1BJ7q9OkqxwWxT0egyDSchGz+xNu+LWMYM=;
        b=gNYuhW3LvIARaJ+uCebtd07OfWnQhCxpNoqrur7qeePrsCb7kiSfqZDpI3JBliHc1H
         pAc/QbU/KS0Ytr0NC5cbnWvau+BSMA7bGoVDbR4YSKJbm1kBKCOBaC66u6Vm4wCTM707
         LsF7qaXMCY0IAb04V0cl+33uf1l1ZldvtzyX7ykiOwqFEbbGtZe6T8hrZcK8iCHmPhB4
         9YJy4TTgl3Kn0c1O/75GSwHMWXKv6Z39c1RM55yqBG2Dc6yLA9wtWNXjotIEMUwMqPul
         /vmXoPv2WbiuZsx0X/ZNMgU45nSJDj8j3/WwCZsdriPZj529nCvH6Hq1gpeIoMaqKZW5
         jk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724255192; x=1724859992;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kDmBWhoAI1BJ7q9OkqxwWxT0egyDSchGz+xNu+LWMYM=;
        b=BpAf1OkYxj60ra907PlGFO1yU5BP/4eLmogQUYPVR9p7FekYimnKsru3lv7jIr3QF1
         Dwvgvb8HKqNfs+7cCVAZwSvOJyM4en5Nvg81kzfZP+WYD/HIWz8hteujromx7QiczWkO
         dZv1Hi8d6Ng+vDqCQwLgOmpI9UOLXYqe0lj/oOeoRDlHIVlP1JCLWJRL8NRSKxCKubDo
         MnzKToeOlt4ZNqF44c/vomwe0J+scVyuqX++pSmpYbm+xvyF0d8KtAW7g2Fp98lAWx/k
         w7uOKMh7ckjNJ69ctOjNfwOwJrxVGGvi/+QuZeRQ2/h5q+NpRfAXlwjbYo6JVHK0fUB4
         /5/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVsv6TDW0mcjPG6tUAWcpLY/AgPygF2++Ur1vyHj/+irQ9d0gHKD8q7mPQH0/67RFumx5ryMPQNAYUpMRI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtA7QTzMXGBK5C7l7NZ3lkImFs9szx4AriyXu0u2DK6rYcE+1a
	iPtujW+0f/IcZ7CaHtZY9SkK9f9fQlQWbzljmi2JmM1gQ/v4iXPs2/rZyA==
X-Google-Smtp-Source: AGHT+IHNNf3tcFS62X2a8jmPdzJkFEsKrVes+d8/KVGitk6PNAdZfipICkG7LEm3//jaK6bt27+i5A==
X-Received: by 2002:a17:90a:cc0c:b0:2d0:86a:fbd with SMTP id 98e67ed59e1d1-2d5e9ec9558mr2958050a91.32.1724255191909;
        Wed, 21 Aug 2024 08:46:31 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eba2e538sm2021098a91.17.2024.08.21.08.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 08:46:31 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] nilfs2: prevent unexpected ENOENT propagation
Date: Thu, 22 Aug 2024 00:46:22 +0900
Message-Id: <20240821154627.11848-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew,

please add this series to the queue for the next cycle.

This series fixes potential issues where the result code -ENOENT,
which is returned internally when a metadata file operation encouters
a hole block, is exposed to user space without being properly handled.

Several issues with the same cause leading to hangs or WARN_ON check
failures have been reported by syzbot and fixed each time in the past.
This collectively fixes the missing -ENOENT conversions that do not
cause stability issues and are not covered by syzbot.

Thanks,
Ryusuke Konishi


Ryusuke Konishi (5):
  nilfs2: treat missing sufile header block as metadata corruption
  nilfs2: treat missing cpfile header block as metadata corruption
  nilfs2: do not propagate ENOENT error from sufile during recovery
  nilfs2: do not propagate ENOENT error from sufile during GC
  nilfs2: do not propagate ENOENT error from nilfs_sufile_mark_dirty()

 fs/nilfs2/cpfile.c   | 22 ++++++++-------
 fs/nilfs2/recovery.c | 11 +++++++-
 fs/nilfs2/segment.c  | 64 ++++++++++++++++++++++++++++++++++++++------
 fs/nilfs2/sufile.c   | 32 +++++++++++++++++-----
 4 files changed, 104 insertions(+), 25 deletions(-)

-- 
2.34.1

