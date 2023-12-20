Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131234A985;
	Wed, 20 Dec 2023 22:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kFCGVhh1"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3ba46a19689so82131b6e.3;
        Wed, 20 Dec 2023 14:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703110449; x=1703715249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kk68MJUdWFrLkN8+ARexO/EfWP5dvoGb3D27iCAOWr8=;
        b=kFCGVhh101rDXnLajuUiaoGETy7pNmHKopbeIIFjJXmSpPMPR+HDsUO9KZabjDga/R
         dVlmPOS1oTJg9ZMaeDV/RbZ05bBGXrU8FK0TyJNWYxOLkyCPbgh9Xxl/2dNCUw0jS5Cq
         Jha9CTLLVTgAVXRNlKUxYpFTCC2epK22s0itCmmv2jwjzNyl8eHajzO6DLc0jx/1Ri0/
         lglLThYIvnCDxed74A8U1V1+JxG7PTpK4FWT8XM+sR2GFw7TYmTbmX4e9XBkElohdua1
         MCaa6aEi/TeZaunjTQqF2p3kJLzhaI/i1hSySXk3dFXDEV8MLfX/l69DGwyUhuOLCzgG
         8KWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703110449; x=1703715249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kk68MJUdWFrLkN8+ARexO/EfWP5dvoGb3D27iCAOWr8=;
        b=RpPkqMKyYJsHnZXhHi7CrrFUTTl2E5R3EhLoq7uuijYKu1/a6bLXoX8974CebfkyU3
         EEpYh/LFhsH7wsRHLa9xxDRcK4ySDa/S3PkoUB57TTFIWLfEVaVk8sZiuqTninTpz3Ge
         2HlWgjxbiHe1+8Uc8hct6kqgaA+JCKb8agMPlIS2PXOlf7p2fhLydAaLzFzp+Zt+aQNb
         lLFGZfvdmHDCgCB7gtyKQwGGeYbozH+Td/+t6RD23vWMffm3sOqfD7OQwlqLrK5mdOz4
         o9gwuMXBLtY7RA0ZBIDKXbeXsMHiuVyNUb8wA2L/oUCo//54DVGjgyfsNhfgfBcUsTQu
         hSoA==
X-Gm-Message-State: AOJu0Yxf66PpgiLs/FLKWo7Q38PM6/xa8UP3J890H/PgOcytJDRQo8ow
	pUDhk1pRtNPcLxL1udRKelA=
X-Google-Smtp-Source: AGHT+IHPVF/CltiidkEBH1Hk8/49Sachf7OnNAPjx00SvUJPiTsm+RKPxUpVRQij7wjUWaFQWuR9Zw==
X-Received: by 2002:aca:2205:0:b0:3b9:e859:53b9 with SMTP id b5-20020aca2205000000b003b9e85953b9mr20912473oic.118.1703110448893;
        Wed, 20 Dec 2023 14:14:08 -0800 (PST)
Received: from carrot.. (i118-19-12-122.s42.a014.ap.plala.or.jp. [118.19.12.122])
        by smtp.gmail.com with ESMTPSA id v124-20020a626182000000b006d96d753ca0sm165631pfb.38.2023.12.20.14.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Dec 2023 14:14:08 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: cpfile: fix some kernel-doc warnings
Date: Thu, 21 Dec 2023 07:13:42 +0900
Message-Id: <20231220221342.11505-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

Correct the function parameter names for nilfs_cpfile_get_info():

cpfile.c:564: warning: Function parameter or member 'cnop' not described in 'nilfs_cpfile_get_cpinfo'
cpfile.c:564: warning: Function parameter or member 'mode' not described in 'nilfs_cpfile_get_cpinfo'
cpfile.c:564: warning: Function parameter or member 'buf' not described in 'nilfs_cpfile_get_cpinfo'
cpfile.c:564: warning: Function parameter or member 'cisz' not described in 'nilfs_cpfile_get_cpinfo'
cpfile.c:564: warning: Excess function parameter 'cno' description in 'nilfs_cpfile_get_cpinfo'
cpfile.c:564: warning: Excess function parameter 'ci' description in 'nilfs_cpfile_get_cpinfo'

Also add missing descriptions of the function's specification.

[ konishi.ryusuke@gmail.com: filled in missing descriptions ]

Link: https://lkml.kernel.org/r/20231220065931.2372-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Andrew, please add this to the queue for the next merge window.
This fixes noticeable kernel-doc warnings for fs/nilfs2/cpfile.c.

Thanks,
Ryusuke Konishi

 fs/nilfs2/cpfile.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 9ebefb3acb0e..39136637f715 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -552,11 +552,29 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 }
 
 /**
- * nilfs_cpfile_get_cpinfo -
- * @cpfile:
- * @cno:
- * @ci:
- * @nci:
+ * nilfs_cpfile_get_cpinfo - get information on checkpoints
+ * @cpfile: checkpoint file inode
+ * @cnop:   place to pass a starting checkpoint number and receive a
+ *          checkpoint number to continue the search
+ * @mode:   mode of checkpoints that the caller wants to retrieve
+ * @buf:    buffer for storing checkpoints' information
+ * @cisz:   byte size of one checkpoint info item in array
+ * @nci:    number of checkpoint info items to retrieve
+ *
+ * nilfs_cpfile_get_cpinfo() searches for checkpoints in @mode state
+ * starting from the checkpoint number stored in @cnop, and stores
+ * information about found checkpoints in @buf.
+ * The buffer pointed to by @buf must be large enough to store information
+ * for @nci checkpoints.  If at least one checkpoint information is
+ * successfully retrieved, @cnop is updated to point to the checkpoint
+ * number to continue searching.
+ *
+ * Return: Count of checkpoint info items stored in the output buffer on
+ * success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid checkpoint mode.
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Invalid checkpoint number specified.
  */
 
 ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile, __u64 *cnop, int mode,
-- 
2.34.1

