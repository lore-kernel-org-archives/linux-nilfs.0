Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01C04F602;
	Fri, 16 Aug 2024 07:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723794213; cv=none; b=T3PVPeCvgejizbVUR19ritBKYW2aDZxoYoQwdnh8iOcSMc5jJcGYMPzqHgQhg+F4oy70rakjKamPlSMP+Ifs0U4EDGroWClZZB3v/erCJPUBeo+LdH5AnFH18462S5yNGlsdl3pbzfi1EI8B25Ck9E/hu7YDQ8Px9JjdIQXQGPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723794213; c=relaxed/simple;
	bh=zaApHtQg2oSp+QYGp9b1CE8d7V38jbZLbHqogLU+glc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oh55VpMSlBi7Vj0gtKqFN2gz7ExylnaPmy+BgMEN+27wkX7CH8YbjIDokd+Ud68reeZ7CsRsx/Xw7UXvMYOGO1rhQAybkxQUxioYlE5pqnsMrwLYrf0g1Rqd4FaTkZOkTNiUOTE1v19lnMq4oyu7ylNI2IHFb50BmqLUaSbxVTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z75pRi7s; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z75pRi7s"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-27010ae9815so780596fac.2;
        Fri, 16 Aug 2024 00:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723794210; x=1724399010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jpU1zDE8vWcy5g8XvrytGvPiuUH7nyo8mC+3JbG9J0k=;
        b=Z75pRi7skihqgrUhIx3zHYr3LfeAPcQu5pdUuewzXSjdO3WP2HYSZXy8D7i9H9cNmh
         sOO2KqOt3ZiN+3qYZgK5RK813Ie4oULlaA+gJpdIxTq57ywZSOMpJ2VWOiyZdSGCVLIO
         XUsMswpMbd/efdw5gtLZ6/W1oAN2vuWBQ6u50Ib8m4rulpK7zIRVqPm0THuPdJzFeQS8
         xnSO+Jmn7Qhrhu5+cIqgUnAdjQkCqCqFjtm4o5OuycRaZy/DynaU9zrINCumg62ekE9+
         8oQEkbbz2U+RarWyVNqinPc3SQulIBGij3qN9tvkr+lU0WHXIJEm0PCY2Cwj7b58P/37
         nqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723794210; x=1724399010;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jpU1zDE8vWcy5g8XvrytGvPiuUH7nyo8mC+3JbG9J0k=;
        b=NVF5aOaPLeW4fuNznRLOvLKuEb069L56mkTmKrAQMwQCPOnUuoe69UcJXFIcU974/F
         DZiACR7hJJOPSDojNlmXJXsrI49y/7KGvV0hU50lg23ZonpUhOSFMpdNTBKoACG8q/2e
         CMlfZe4s+yICws+NCiEvK/RX3WAZFb3XnLi8avSGUOUYmhVFndNUIfjHR76TSKkbcYNM
         4vqTvRmlR/V7FX5bVeHlwVA3jBHcMf/vwWN+jaIl/O6ImacikjPcm5w/QX51LK4HrcKy
         LFnFJK1cqNKXGOjmuMjDdhkc3brPZOLG4Suz9Iy9c6a9C7OBza41IpTVb21LnLInQqca
         myJg==
X-Forwarded-Encrypted: i=1; AJvYcCXab/df3yaPwYsdDoCwRFH4z9N1aeH9dyTpGf+ddZfDX2d1664znhMbxzJIqBXlPfCuWy/hIXKPPWLAq+pTwoYYolY0Q56e1ea1Iq+D
X-Gm-Message-State: AOJu0Yw48/2ayLeV0m/gFSGEXDWqA6ZXa24INYc+QWSi3K5aL2HXBc9u
	uuG5B3dCokYhlOwXpWe+m4FTvFTT7zh62CHtuH7bX2uFvgUgLK1rxuYDxQ==
X-Google-Smtp-Source: AGHT+IHSkjb0amXBZJyLteOFF1JfTwiarpRF6PbhvIghe9GeACLdCDy6AyqH/FWVADhs3O2ARwvfqA==
X-Received: by 2002:a05:6870:5254:b0:261:9c7:a0bb with SMTP id 586e51a60fabf-2701c590a08mr2157662fac.48.1723794210205;
        Fri, 16 Aug 2024 00:43:30 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61e7c7asm2365971a12.45.2024.08.16.00.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:43:29 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] nilfs2: clean up kernel-doc warnings
Date: Fri, 16 Aug 2024 16:43:11 +0900
Message-Id: <20240816074319.3253-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew, please add this series to the queue for the next cycle.

This series fixes a number of formatting issues in kernel doc comments
that were detected as warnings by the kernel-doc script, making
violations more noticeable when adding or modifying kernel doc.

There are still warnings output by "kernel-doc -Wall", but they are
widespread, so I plan to fix them at another time while considering
priorities.

Thanks,
Ryusuke Konishi

Ryusuke Konishi (8):
  nilfs2: add missing argument description for __nilfs_error()
  nilfs2: add missing argument descriptions for ioctl-related helpers
  nilfs2: improve kernel-doc comments for b-tree node helpers
  nilfs2: fix incorrect kernel-doc declaration of nilfs_palloc_req
    structure
  nilfs2: add missing description of nilfs_btree_path structure
  nilfs2: describe the members of nilfs_bmap_operations structure
  nilfs2: fix inconsistencies in kernel-doc comments in segment.h
  nilfs2: fix missing initial short descriptions of kernel-doc comments

 fs/nilfs2/alloc.h   |  2 +-
 fs/nilfs2/bmap.c    |  2 +-
 fs/nilfs2/bmap.h    | 15 ++++++++++-
 fs/nilfs2/btnode.c  | 63 ++++++++++++++++++++++++++++++++++++++-------
 fs/nilfs2/btree.h   |  1 +
 fs/nilfs2/cpfile.c  | 32 +++++++++++------------
 fs/nilfs2/dat.c     | 17 +++++-------
 fs/nilfs2/ioctl.c   | 17 ++++++++++--
 fs/nilfs2/segment.h |  7 ++---
 fs/nilfs2/sufile.c  | 20 ++++++--------
 fs/nilfs2/super.c   |  4 +++
 11 files changed, 125 insertions(+), 55 deletions(-)

-- 
2.34.1

