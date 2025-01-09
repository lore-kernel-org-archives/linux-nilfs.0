Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EA115573F;
	Thu,  9 Jan 2025 03:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736393297; cv=none; b=jyX3UjT+g2tqOccwSpRf7x0m8IT50LHXgfp05ny7mhZKiFgnj6xGIHHpuISZBTMdc8TykT0U0KWenSWQe2RQ2wUAtY6AYg2LvSpWcNeMZxjkDhiDLKgloboarelUgNd56PnKrBmLrSJTI74T4udtzLgEELpqy8Y2aLgQ8/2e408=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736393297; c=relaxed/simple;
	bh=zG5tClB1S+5fwEph6dA2tbJ9FMCpFdEQnHTdTVaxnVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q6zC5GlxxZha7j6YYG0HlvvaeX19T1o7I5kp4atUhmbIYt+IGZ391HX5SNHheOEJOX7L0L7xjHybDCMM5SJf2wcKU5XOqWUB+p01E34CqBK3YpGhF9QmKyoRfUWeSMDSYb+pZtfEBj+rtslt+H4QKgKo9TuRi+0kpNZ6Q4pi0ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RSM7KCVD; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RSM7KCVD"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ef6c56032eso614089a91.2;
        Wed, 08 Jan 2025 19:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736393294; x=1736998094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AP1JZY/9b3Mvtqpmu7gPl03RWrtXelPM1K3Y+nEeC90=;
        b=RSM7KCVDYAlaIsHvPtvZT/tFBpOkAp2fBEQcqgikqv0odOMgPVI3V6+pvLGWm1C9xq
         lwPelkeAM/Z9WPEquSGrafxj+yPC2EVOIl1n/Op5rhpfofTw6qLRpYMfRPbMbHGwjXvZ
         bZkg2sQj2JIzUPYFL2z5Q8woaGUSL2/90JjSTnaEQ1FOLSRX3EyNlifOYZ6+EKtTZrnD
         uXfd69UWjtTI62rDrLV4B2pNg3eDozjF6HiQTkNSSmpSE0lHlUiJ34LFaAZM0dYes51C
         wmLGM1mh8A/0Tug3Jd/GqIthqTr+tUTE7L431ND3dLFI4EsvPoRaWVj5JXDbJNI3+PkI
         ZRGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736393294; x=1736998094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AP1JZY/9b3Mvtqpmu7gPl03RWrtXelPM1K3Y+nEeC90=;
        b=CPBpP0JTr5U4dxVvZwGJ88aWu5LcXoIjJaAF/5mS8y7sZcTvl1kc4eaRtiKKHdHba2
         gSUSseNDCFeY+Dqv28qMx45lhmY5RX5vTTTrgnl3Hv0BIbYHDfJ60atxHGeP+S+EHgvP
         nOAogxgZFweSNpeoipNBMTJ1ScuMPvo/XIRcl3uAzfQQUiP6yggKCd39zDp1QLFfJcMs
         Ih3MYg5FVjDXCUc/WXkt3Z7WfR3O87iT7Xt+9wPprz/IUMrKK2vjA+nVL1QAHm8efFX3
         TySczPw6+yAY/njKh5gsdpYivI7Lf3VtFKP2kPghWZvY9tOw/juq5G/2vv5SVSs7pPns
         Uekg==
X-Forwarded-Encrypted: i=1; AJvYcCWZTOIgmUxqAcDgaScwBJxt0PN5auZ/XX49uUFze9xVk6tZDRIDnUi85kA6uiQJt6Wdz1+HEzKrHwt5Qac=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt6pRpicJeQT6MNCStKulHGjEG27RyM1WlY130q+/4BRMuwcwT
	DnuAs2sO0B2Df1dSXBy/HCtquuE2CYtIzfj6rFdSBRHuqs1GNU2FtAVEfA==
X-Gm-Gg: ASbGncuSF86NWCVAyMpf62ZLBIMZA+nEbFwFBmKnqBQn/rvbyGdPRqEDnr/i+SrAjtL
	mKjcsBuK5FQmb2x9EC15Lwwqoyog5hbl8VTW9gV2a/hoXIhpQH5rjEUSVfKR5HbOl0weMkZnrda
	U6JXrR01eLFnYaVjQkWVOqJNFmuotESlRvb/zR1LbiRuq/WdZ9cyLzJli1R2cuqmbUh6+2Fq8Hu
	qBZVDkuWJRQ0a9c1/EBB6XuJu8elhmdlTcuiVc4cMy4yLByb8W9ctds5AxjkSBwyvHyFQWRlT2J
	b4k4lQdMVE7zOAA9mCFHU8r75Owl
X-Google-Smtp-Source: AGHT+IGqvk9MfMm4katQSHQwhtPimX8jq8BaT/YUtrUq95XGcMeRTsuvQihIx7ghSvpdq1t5jWunDA==
X-Received: by 2002:a17:90a:c2ce:b0:2ee:741c:e9f4 with SMTP id 98e67ed59e1d1-2f548ebba5bmr7491084a91.11.1736393293556;
        Wed, 08 Jan 2025 19:28:13 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f55942eed5sm194963a91.27.2025.01.08.19.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 19:28:12 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] nilfs2: fix kernel-doc comments for function return values
Date: Thu,  9 Jan 2025 12:23:19 +0900
Message-ID: <20250109032846.10147-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew,

please add this series to the queue for the next merge window.

This series fixes the inadequacies in the return value descriptions in
nilfs2's kernel-doc comments (mainly incorrect formatting), as well as
the lack of return value descriptions themselves, and fixes most of
the remaining warnings that are output when the kernel-doc script is
run with the "-Wall" option.

Thanks,
Ryusuke Konishi

Ryusuke Konishi (6):
  nilfs2: correct return value kernel-doc descriptions for ioctl
    functions
  nilfs2: correct return value kernel-doc descriptions for bmap
    functions
  nilfs2: correct return value kernel-doc descriptions for sufile
  nilfs2: correct return value kernel-doc descriptions for metadata
    files
  nilfs2: correct return value kernel-doc descriptions for the rest
  nilfs2: add missing return value kernel-doc descriptions

 fs/nilfs2/alloc.c     |  64 +++++++++++-
 fs/nilfs2/alloc.h     |   2 +
 fs/nilfs2/bmap.c      | 113 +++++++++-------------
 fs/nilfs2/btree.c     |   7 +-
 fs/nilfs2/cpfile.c    |  49 ++++------
 fs/nilfs2/dat.c       |  39 +++-----
 fs/nilfs2/gcinode.c   |  22 ++---
 fs/nilfs2/ifile.c     |  32 +++---
 fs/nilfs2/inode.c     |  16 ++-
 fs/nilfs2/ioctl.c     | 220 ++++++++++++++++--------------------------
 fs/nilfs2/mdt.c       |  59 ++++++-----
 fs/nilfs2/page.c      |   8 +-
 fs/nilfs2/recovery.c  |  57 +++++++----
 fs/nilfs2/segbuf.c    |  12 +--
 fs/nilfs2/segment.c   |  53 +++++-----
 fs/nilfs2/sufile.c    | 104 ++++++++------------
 fs/nilfs2/sufile.h    |  21 ++--
 fs/nilfs2/super.c     |  10 +-
 fs/nilfs2/the_nilfs.c |  25 +++--
 19 files changed, 428 insertions(+), 485 deletions(-)

-- 
2.43.0

