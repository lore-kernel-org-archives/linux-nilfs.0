Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C7313C3F2
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 05:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746683403; cv=none; b=DkzTphJf3ELPD7FdLiq2huKYparRWuVfjOzrvuQni6brooZZRGvojVdzmK876OV89BMcaPRDoGOBc178bNyL4T+HNQ9H0FihhLVnNjSCGvA13KbeMhlx208HTUTPHsF9YTSp+4H4fnFdB/pEolyUZpdcy9QGdx29COIo2SVlNak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746683403; c=relaxed/simple;
	bh=QT2cfpT0RbsodBTqwAQ4CL/CEmszDD3odSoiJKXqSig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHUd2FaTQ67hjpByH5BfCAgCObs0IrwlBLyAAPd+FnsDb8lxb3L5LdeaFtgluGYZaKcNEQaTVdiMY0O5BuA4eF89R7ltxoqL9HXxI62K7JDl+xmc6htdUL2zfUgb2JJqMCrbHJy1PITcWUfVsUxmpSxunxe6+e97l5ZWUxDV6pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iuaZjQcR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iuaZjQcR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1WBr9w3SFmKiuKk2Rz4AT4diH7vJiSWAxy4wDmvjr48=; b=iuaZjQcRHmbEKRnNbeG8a0d6/A
	ObZPbr3a4MS2Dkbm2FE7+49x0Vg5EI+NeciJN/0hEFMxY/wbNpSTMeGSEQxWrOSPmEetF5QXQ74De
	5RHg0xMA/5Zwrfmlg3ux2ISZQFESfBlWsGZGHWoIRD0VzygDaooq1eL3p3dnHq29dlcV+0NXLgtWM
	q8oA7Oa1DOKKcEisYAymrSx1XLKERuXjEctKYibmeiuRljwuZuak21uKSLbLn52vhhrsGNcduMRp4
	VAX324/lMT8uObHhpejLeTFaaJaP4lmalFMTx23Kag3Ka/NlzOp/4WQX105MIgeBSlpZZrk1veimD
	pB2m6Yxg==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCu8t-0000000HOsc-1M4a;
	Thu, 08 May 2025 05:50:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-nilfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/7] nilfs2: remove wbc->for_reclaim handling
Date: Thu,  8 May 2025 07:47:48 +0200
Message-ID: <20250508054938.15894-7-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250508054938.15894-1-hch@lst.de>
References: <20250508054938.15894-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Since commit 013a07052a1a ("nilfs2: convert metadata aops from writepage
to writepages"), nilfs_mdt_write_folio can't be called from reclaim
context any more.  Remove the code keyed of the wbc->for_rename flag,
which is now only set for writing out swap or shmem pages inside the
swap code, but never passed to file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
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
2.47.2

