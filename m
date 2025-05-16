Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0C323FC41;
	Fri, 16 May 2025 12:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747398864; cv=none; b=ut4faeoc3FFOq5SlsG/OVDwoHd7HRiEbR4MxTK5iVBos+hpbLBqtRpQwXhOBDkBFf8tJG1LxRudlu5v1Wc3cRgEXSyJJdi8cb3G2wGaIR44cn1Pi+v0oe5magdyiz8HDatqJ2Yu4QCzoaWLHDATZXHKlyrDDbLvsexJ/uSQ4BEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747398864; c=relaxed/simple;
	bh=+qMIjfa+7kK9fPghuhEoRJqGZazz8er/CgaCIfrLeRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hZ0yKM56qUwXUF28EtA+S0Dh4nrQ6zIdQHAMqNg8+0LWibnfgpafHhGRg1NQEfUxphPliEIP0cmOFUHU4tghEE6HFCL9XqB+HjG4hCRz+r5JXmxgnUdtxO2B8vCUkEhBNYCSgxAQeaaMN5NutQO8sCLMiyDZ83ywz0R2YCZ9UlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dRJT/7xp; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dRJT/7xp"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-73bf5aa95e7so1985762b3a.1;
        Fri, 16 May 2025 05:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747398862; x=1748003662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sQ8MdKTVw3ECVi8keYANU6Bo31kbzYISRDJG8aBqrlI=;
        b=dRJT/7xpoHhD4p5WcEz0fH19YPhzdY3pOcigtldxoEIq8LIULZaIVOtfKcsTJTFjuI
         q7+kYT0pwulLhfCNiZ8rOzbDRWeiHUpIV8SrwJVaKZHrr4+HML3Lk5vy2vUkBgw1Gelx
         Ae2R+CDPvGmcv4w+QEG6iZn6Vp6oUvYPgkno5mtFTPBkYn4sGdmTuIWUMkvCK7I0qRd2
         oOk0ylh/qkQepLYk1/0wyzD6IL4JXnU7quvosvmY+faH/PTwCkuJairyItXFuL87AbsU
         C0U2ySA1TMjLWMb5xsBHI5Vd2fVoY8HmH95UHocDw9B0dzUoivaBliu5oXq2S9tDJ4kf
         UcbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747398862; x=1748003662;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sQ8MdKTVw3ECVi8keYANU6Bo31kbzYISRDJG8aBqrlI=;
        b=XiChj+NmGwSA8WIowVb+N88IWI2JKN0tCwG5xThzv+xzr8tzxRacm0Pu2jUVf9BzXs
         Vmotjn+xIwypAuEawyRHI/S3VJUNCPei+LEo5VdUKOrqgedacclJxmN6nbjGdDihG9nV
         mUFswIDpMCu4VqHRe+R2Q6tgdUr/8pLd+zJdX2zTgWpEGkcCW39DCQyh2O7qLsNGngCe
         GyaCUAuLrJJWsCtzz+4DIYSGGEUsYGBLuzma5Bc0Fn3gy7oEELShV/Bb8HBjW52Pieg/
         BQYvUO/gGbk6AArU4Ev9lwS7mEODUg35eCZWyxm9GrNzEGrhTGUO2+h63l/Rmci6a6nc
         8aGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfuX/AeEcjyrboGCOa64bltf5Q1Z3RJMYyJ3AP94Zt5AOO4oN1lHTOC7ZjwZhajc7XyO/VkRMm2N3v58I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKDa/6II9BpMh/g2jO9p+tP1wqSMEC1lt+7gmfQ4QqaTuPP6kd
	hmphEYyTHoKdrfSXbpjbSTopcxY625sHzO+Ph7CQ/qPnjK1qn0YtBwLVN/UMGQ==
X-Gm-Gg: ASbGncvAKDR3y4nc3ktrsmK1XxU+S/dCm+UMLoqYEFCP8NHAMTGAt183PLOlvFxobvv
	JNyvIAAo66RZ5VwpzQOkm30C+alTGeZMqAq/Md8AJgTTl5r9n5CoXGQ1+sA3O7jZzVc2Sp9WeQd
	MQuAhlJJC4fRdxt8p5FrileA40VOoCtWyfEmFjNkttt0WrXZzXOz1gdOgIRkWCvyyjPJnoX56mg
	yg0YGdSC0aK6rgLXxEoRxqcqaB1g2fEXIxSiLBL00N4aMMCVyWig+pOuJNcRzdx+juSAptO4UXM
	3Aom+4NMZFtwODYGCFL6rK6vhbM2VPqPn6j0pbSEYVf6Gxwpduqgi+NsycUEtKfOso6DCd/4eAt
	2XCDR6Gp5a8IikaJ+Ylpd3Gl9zPe3
X-Google-Smtp-Source: AGHT+IHxDDmFGa84W12vZqtf53NmGHtdif2gYB6Efz3zCfXjSc47WLKLMkpX9cKPOuKzJ3458fB86w==
X-Received: by 2002:a05:6a00:18a7:b0:742:a0cf:7753 with SMTP id d2e1a72fcca58-742a97769efmr4786725b3a.3.1747398862149;
        Fri, 16 May 2025 05:34:22 -0700 (PDT)
Received: from carrot.. (i223-218-69-4.s41.a014.ap.plala.or.jp. [223.218.69.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9829c10sm1443078b3a.96.2025.05.16.05.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 05:34:21 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH] nilfs2: remove wbc->for_reclaim handling
Date: Fri, 16 May 2025 21:31:13 +0900
Message-ID: <20250516123417.6779-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Since commit 013a07052a1a ("nilfs2: convert metadata aops from writepage
to writepages"), nilfs_mdt_write_folio can't be called from reclaim
context any more.  Remove the code keyed of the wbc->for_reclaim flag,
which is now only set for writing out swap or shmem pages inside the
swap code, but never passed to file systems.

Link: https://lkml.kernel.org/r/20250508054938.15894-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Andrew, please add this to the queue for the next merge cycle.

This removes dead code on nilfs2 regarding the for_reclaim flag in
writeback control.  It is part of Christoph's series "stop passing a
writeback_control to swap/shmem writeout", but I'm sending it ahead
separately at his request.

Thanks,
Ryusuke Konishi

 fs/nilfs2/mdt.c     |  2 --
 fs/nilfs2/segment.c | 16 ----------------
 fs/nilfs2/segment.h |  1 -
 3 files changed, 19 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 2f850a18d6e7..946b0d3534a5 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -422,8 +422,6 @@ static int nilfs_mdt_write_folio(struct folio *folio,
 
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		err = nilfs_construct_segment(sb);
-	else if (wbc->for_reclaim)
-		nilfs_flush_segment(sb, inode->i_ino);
 
 	return err;
 }
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 83970d97840b..61a4141f8d6b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2221,22 +2221,6 @@ static void nilfs_segctor_do_flush(struct nilfs_sc_info *sci, int bn)
 	spin_unlock(&sci->sc_state_lock);
 }
 
-/**
- * nilfs_flush_segment - trigger a segment construction for resource control
- * @sb: super block
- * @ino: inode number of the file to be flushed out.
- */
-void nilfs_flush_segment(struct super_block *sb, ino_t ino)
-{
-	struct the_nilfs *nilfs = sb->s_fs_info;
-	struct nilfs_sc_info *sci = nilfs->ns_writer;
-
-	if (!sci || nilfs_doing_construction())
-		return;
-	nilfs_segctor_do_flush(sci, NILFS_MDT_INODE(sb, ino) ? ino : 0);
-					/* assign bit 0 to data files */
-}
-
 struct nilfs_segctor_wait_request {
 	wait_queue_entry_t	wq;
 	__u32		seq;
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index f723f47ddc4e..4b39ed43ae72 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -226,7 +226,6 @@ extern void nilfs_relax_pressure_in_lock(struct super_block *);
 extern int nilfs_construct_segment(struct super_block *);
 extern int nilfs_construct_dsync_segment(struct super_block *, struct inode *,
 					 loff_t, loff_t);
-extern void nilfs_flush_segment(struct super_block *, ino_t);
 extern int nilfs_clean_segments(struct super_block *, struct nilfs_argv *,
 				void **);
 
-- 
2.43.0

