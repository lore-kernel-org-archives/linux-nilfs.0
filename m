Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A66B19884C;
	Mon, 26 Aug 2024 17:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724694093; cv=none; b=lgzJDwuFuSe/o+oNcnwy+BBIjr33ZQpbArF+M0R/cwbJL7cM+vozhNYcnkCPT5MUaUUXr4bGzp50BFNJ9KJIl2In48lCtK8dPqytlEZhvMZyf5Et4pJYQHNKmS/qDRcEXUD0Pct/fSuaHkIjlKBBGJCRBQwyXN3M1jJq/SsZ6vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724694093; c=relaxed/simple;
	bh=mdE56Rylrt2hy2vypS115yKOruMwiY7pJphlpSJYe8c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LamPmB0lDVxGcA79PQgAq39awo5BhVpgJGFyAiXSiPVaMr16bX7CiefrLlz5ADwada7ZpOhp2gUTN3W16YsAdNdf8KWXIVfRAOHRE6Fh6jdZZCZWEEhHp/3JOT4CirWBhUWzOZcflFyeFfuVOZWnjcHEwloSS6stUQEOICoT0QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WwB1Pa5m; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WwB1Pa5m"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-201d5af11a4so40392205ad.3;
        Mon, 26 Aug 2024 10:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724694091; x=1725298891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YFt2mJ1X3Rb4fKf4vP3EK+dw/lN+io4rc1YtQ6OpOWo=;
        b=WwB1Pa5mXA0PSr8zVLctP7BHOVLtO0fn8q6nmoMwqQVWYtiFTO8X9sOQYOBQgbQemH
         9LppzH33PcFx43k1nvsHO2Q5WgVBz3x7PpYXZKkUmpLov6/IsqCwFyc5f/it3uwMJaAi
         sPnM3/0RFdvN8nnlwWhx+0dKgF2FoV04KJKWa64748TMYxqO9f7ghwA+JHTsf5Gi7qow
         uWfexGmno9EbXyKz1/oknz7mhP42pa2v4el721zSKvKub/LzboWHvO8bSf9ETAP15hmB
         Y7Ql+y9RyCplzOzBYkFrJ9JB6sq2ENMxpd58fU5WfBX2G3eKo+NriNHkJmcIamVPgg6o
         vRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724694091; x=1725298891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YFt2mJ1X3Rb4fKf4vP3EK+dw/lN+io4rc1YtQ6OpOWo=;
        b=qtSx9RGULqcwzxUbPOsIZfMKdClpbCSQIhnRRQ0KE4rxnNOrWQQVEeFm0o8KlomzKe
         4cMGGf1OCDfNiSSlRFdsh44GjLscvTqA0KxTqfB0QSzG2DEvLOf9terWbQgJMJ/XVNfc
         /6obrq3pbT69/gHX6M2HtGMuI48LJerB382G3ZGgEKDH5ZG3w2Z3ZAX1l2wM527zwRQJ
         aU1p4Q92aFQfEdDjJTRJHedM8XNJg+GPiC/IT7F7Mz/punhMBxMgnm0RyvVRLx+gcooj
         Ceq8cvTB6wo62xsZiNkmW9RxQIbzWUbwaz4YALsYuyxJAhVrGCqEGRIWTv27/6eXYrbm
         X89Q==
X-Forwarded-Encrypted: i=1; AJvYcCX1o/tzntL3h4CLMKGKADDSnVFGEpkbrb0yfQhLNgwX57J+VuDCx+ndfj0VyFxQQG8cXFNlErDmvrw6snY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+9mk+ryPDNqArxcAI9ilg56m00Kwqk+g1+wZjfBptaKFcINgM
	wtMGQAEAa3DfH/tFCsU3KQNrmFshyNOeaiN/fgnJ0xf73iCW0hkj
X-Google-Smtp-Source: AGHT+IF2G1WgA/D44MW5BVGjbL3HYJVs6Pi8VPEs7KXm1SBSBNpRwkDKwrISF5RNmBUnR+sD/b04Zw==
X-Received: by 2002:a17:903:1210:b0:203:8b7c:c8d0 with SMTP id d9443c01a7336-204df4def85mr3995535ad.40.1724694091282;
        Mon, 26 Aug 2024 10:41:31 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855665besm70057055ad.34.2024.08.26.10.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 10:41:30 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] nilfs2: assorted cleanups
Date: Tue, 27 Aug 2024 02:41:08 +0900
Message-Id: <20240826174116.5008-1-konishi.ryusuke@gmail.com>
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

This is a collection of cleanup patches, with only the last three
focused on the log writer thread, the rest are miscellaneous.

Patches 1/8, 4/8, and 7/8 adopt common implementations, 2/8 uses a
generic macro, 5/8 removes dead code, 6/8 removes an unnecessary
reference, and 3/8 and 8/8 each simplify a paticular messy
implementation.

Thanks,
Ryusuke Konishi

Huang Xiaojia (1):
  nilfs2: use common implementation of file type

Ryusuke Konishi (7):
  nilfs2: use the BITS_PER_LONG macro
  nilfs2: separate inode type information from i_state field
  nilfs2: eliminate the shared counter and spinlock for i_generation
  nilfs2: do not repair reserved inode bitmap in nilfs_new_inode()
  nilfs2: remove sc_timer_task
  nilfs2: use kthread_create and kthread_stop for the log writer thread
  nilfs2: refactor nilfs_segctor_thread()

 fs/nilfs2/bmap.h      |   5 +-
 fs/nilfs2/dir.c       |  44 ++---------
 fs/nilfs2/inode.c     |  75 ++++---------------
 fs/nilfs2/nilfs.h     |  15 +++-
 fs/nilfs2/segment.c   | 170 ++++++++++++++++++------------------------
 fs/nilfs2/segment.h   |   5 --
 fs/nilfs2/super.c     |   1 +
 fs/nilfs2/the_nilfs.c |   5 --
 fs/nilfs2/the_nilfs.h |   6 --
 9 files changed, 108 insertions(+), 218 deletions(-)

-- 
2.34.1

