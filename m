Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE51C1B6550;
	Wed, 21 Aug 2024 15:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255198; cv=none; b=ucpkdcXtpWvIrhulTN//iCzroVDwGHoBfXxVAg88Ipxpzy9IymrfcT+vNcLUwAc2kVvC3iejICCjEytmXAF7MPSyPoUZ8cEvhBZR25fMCEnzteI/ApXE9rzjWqAh1KXrwAPTuwc5eEhhJmkl3o9cZUxK9ICWK2Yz+Gtrb3hXWXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255198; c=relaxed/simple;
	bh=tievpw9Idzq/oDwpY74VDYg1KuGt/WQKEAFeRIU6Tw0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=trrBeLimGRGhWBi4rprHdWq6MZjc4R1H2sYtT+XZ2alQqLTiuIGCZjNb7VxsiPpt1b1d/xi7PNArQgzt6F1DuFLNQFTxqfJCS92dd8yWezmqoXGByHIL3aPoVSEcTom+ByNBCWXbZHA0j4XvYOW3jWqyzDTGOIGuWwofuniC8Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LPhsF0st; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LPhsF0st"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2d3c08541cdso5089967a91.2;
        Wed, 21 Aug 2024 08:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724255196; x=1724859996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eglKytNjuCU8vkKlyKNC2ri1I5cDFqQw1/9BtAZicU0=;
        b=LPhsF0stKm3sDUbNF7Gs0QgFrEqCvgmsnxSSS1oPi3Ki1af3uTA2FlkESfqYMKtfAD
         rBwQc2p3BvwUrQ6BCpo8BuJevakgslERrx4xKB5FvuMJuswqkStkHa/Tk4/FGlNEB7dG
         2MgIwfGno35ffsjBn9BGbPUd+yBBJPx+TFXlZ+pJ1sSTQ/Jc0hSGs/xmNA8g7javxakb
         1KfiVyJdNuRMXznlvOIjIB0JPMtJYSud7sxYShAY08JhylEffUMNBvhUUVhNkdNzNbNG
         DV0OHbnRRFpW1PGQtSFKGpC4tLUBTEynawfGYHOI/UnEHRnTzHFhapLnWwsUwVeJEloZ
         4YdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724255196; x=1724859996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eglKytNjuCU8vkKlyKNC2ri1I5cDFqQw1/9BtAZicU0=;
        b=Qq1d78pwkERZFEHUjdouxmK3YBA8s2+aHyr+wc87zzl2OPZctMa3kTa9tSdQJA2KVg
         ZpUj2IcADjGx2u0pMY3DRep/6OUEPLv9CFKAv0xzCKaKB3RpLwErLksYWsJHWTb1dteS
         fp10WjsfMT+AhPxLELYFmNkSqeecchifiuh6Sdlafq97i4EJe2XnIs19zEQGob1x0x5K
         e4MF0S7GB7xcAsLtk4sGiff6xXoqv70JpW97V/lI/UR5ruv5MOpCfFAM560d37B6L4Wv
         nqj7nxmvLpeDBNCJ7zOALzcseu5avGFL4D4N0l/bvWbtc1t7F/WZuQA96te+Ah0rX+Du
         hS9w==
X-Forwarded-Encrypted: i=1; AJvYcCV+TZmC1io+zwzDZ0IjV3E+16NtHWW0xSDBm6gh+XZq3YUL6w7U7PEopyEv0J3RpBOB/e7kjXAryR6aitc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG41zIppmSrNjytxwmXzL3vgelybVUKrNXNXIQxyqZKhvUahKA
	aqOxAPxIzEXa97ccwDE1B110iGX/voxrwAv7qrBLI/aXb1fW3eme1A24wA==
X-Google-Smtp-Source: AGHT+IHi5sDL4TxM47XCmRNFrC4fXQubFcUySiYsrocJ/D5FB87rcLO+Z3hXJNl/opQOg2gHqRtPjA==
X-Received: by 2002:a17:90b:4f89:b0:2d3:dca0:89b7 with SMTP id 98e67ed59e1d1-2d5e99fb6d1mr3427976a91.3.1724255196035;
        Wed, 21 Aug 2024 08:46:36 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eba2e538sm2021098a91.17.2024.08.21.08.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 08:46:35 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] nilfs2: treat missing cpfile header block as metadata corruption
Date: Thu, 22 Aug 2024 00:46:24 +0900
Message-Id: <20240821154627.11848-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821154627.11848-1-konishi.ryusuke@gmail.com>
References: <20240821154627.11848-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cpfile, a metadata file that holds metadata for checkpoint management,
also has statistical information in its first block, and if reading this
block fails, it receives the internal code -ENOENT and returns that code
to the callers.

As with sufile, to prevent this -ENOENT from being propagated to system
calls, return -EIO instead when reading the header block fails.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/cpfile.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 9c8d531cffa7..f0ce37552446 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -125,10 +125,17 @@ static void nilfs_cpfile_block_init(struct inode *cpfile,
 	}
 }
 
-static inline int nilfs_cpfile_get_header_block(struct inode *cpfile,
-						struct buffer_head **bhp)
+static int nilfs_cpfile_get_header_block(struct inode *cpfile,
+					 struct buffer_head **bhp)
 {
-	return nilfs_mdt_get_block(cpfile, 0, 0, NULL, bhp);
+	int err = nilfs_mdt_get_block(cpfile, 0, 0, NULL, bhp);
+
+	if (unlikely(err == -ENOENT)) {
+		nilfs_error(cpfile->i_sb,
+			    "missing header block in checkpoint metadata");
+		err = -EIO;
+	}
+	return err;
 }
 
 static inline int nilfs_cpfile_get_checkpoint_block(struct inode *cpfile,
@@ -283,14 +290,9 @@ int nilfs_cpfile_create_checkpoint(struct inode *cpfile, __u64 cno)
 
 	down_write(&NILFS_MDT(cpfile)->mi_sem);
 	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
-	if (unlikely(ret < 0)) {
-		if (ret == -ENOENT) {
-			nilfs_error(cpfile->i_sb,
-				    "checkpoint creation failed due to metadata corruption.");
-			ret = -EIO;
-		}
+	if (unlikely(ret < 0))
 		goto out_sem;
-	}
+
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 1, &cp_bh);
 	if (unlikely(ret < 0))
 		goto out_header;
-- 
2.34.1

