From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] nilfs2 minor amendments
Date: Wed, 21 Sep 2022 12:48:01 +0900
Message-ID: <20220921034803.2476-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=2WkMhi2PBahvt2cU0dj162qjUJrLStIdvT7p6uWkrUE=;
        b=Z0zXDBvXjBVpJoMipaRL9hM4+ogpJ+Ip+xjgKON4ZlKP2lSqrp4XUSxbeTth0j4mLw
         obChTqq4ri2e5Ky14XJouoxJEbdAzcApTRuWpgD+iNT14nVLGlodnd9AIklapmZXNoSg
         51C4eMOunjZhc574m7YREX/CTe1JeM2Nbn9cCnio77/KkqUC/kUdO3EE9hPGj07IU6wy
         2c1SZePZ56gIo4A+Vhe0ppq9QmrlK4jYDp2WEblxhc0aUKUetkxiNTZawIJmtYCVJPto
         ljFX0L5Fre+AfgTFViHiRduLmhfM8jp5KnRMVq/lnjTCV/2n24eW5hv9YttQBBqt6fOn
         hoxg==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Andrew,

please queue the following changes for the next merge window.
Both are minor coding-level fixes by users of a robot reporter.

Minghao Chi (1):
  nilfs2: delete unnecessary checks before brelse()

ye xingchen (1):
  nilfs2: Remove the unneeded result variable


Thanks,
Ryusuke Konishi
--
 fs/nilfs2/btree.c   | 6 ++----
 fs/nilfs2/segment.c | 4 +---
 2 files changed, 3 insertions(+), 7 deletions(-)

-- 
2.34.1

