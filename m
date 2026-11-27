Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795754574;
	b=Xo7Akp2U1g6aKs2R90mX03gTd97ZvJ7mHVzzvjKT7irryw2lK3zUk6/D5pj66ZYXvVVY
	 D3SUbm/uNWVFJWFRJEg9CqB4Ro8DQ1R07PA16oP2xVUZXISF9UNAB10qmpoY7HeeKC4nq
	 gMGzw40/06RSsTZaKri0vq3NDv2vAKeNkrRT3ENL08HGOngti0ZmcIqiSArm4gH5iKckx
	 dJCOJBRtW5f8w/ORKUS60BEB8pilTKZNYEo/ce5Cg4c5h9P8nPKKmS20NbfOsTpJ/edZ9
	 3o8wosy8+duRhIZTFcrMNbfQcWb0H7UtZouiHO/KwSeIiDJKkC15qk73pyxCxn2pngg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795754574;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Lw1keLoKzOf/BxPSFHr9zeG8a4MdLodK3QSionyZ4Q=;
	b=NYU89yFkopNKzyRKF+cPckNdsSYFP8hEsgEPKyHyBqwNPNcABgv00XHutUxnvQxuFdnm
	 Avjaqg7+wkZdAZ86NZZVV3KPYZ7RqrFLRYKtmP0rSZIGUDEg4yuESVy4avPQaJWBRip75
	 1bt1dgQMnbqcMfJN0p/aCL9Lqp06n86zZtIDLE5H7k1LK4Ys46jaQygyhgFqE6o1ymLgI
	 5hwqyZL9IrIphjiwE/DcFGwnEQoaz7b5Ha5L1A4Bg3C07Z60KzGL9Layubqyga99chkp+
	 LT2MQyeZAZdvPUVJZfZWKiigPa3WBIJggnXz+Z1CBe7cCs6vGRmU11j9bwtPy9IxoMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XB3vzQLH;
	arc=none smtp.remote-ip=74.125.82.51
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A3C606A32E
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Nov 2026 04:42:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38A3C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XB3vzQLH
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1b3acec6677so11700983c88.1
        for <linux-nilfs@vger.kernel.org>; Thu, 26 Nov 2026 20:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795754573; x=1796359373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Lw1keLoKzOf/BxPSFHr9zeG8a4MdLodK3QSionyZ4Q=;
        b=XB3vzQLHxzHEdBv15RQgvEblNrVIIZAkd+36YeA4RU7cYK2aEaMdWoBUneW70iRuHT
         4LbbSFrOUIq91Q62wyMUxGy/poVPneX0isL6NetAuqOTkCoQ188gmTNW7UXCu0wsgoLX
         AXCVLcro64tAiP3RVImkzRecLkwnP8AC5/r3gIJzdg4X5Y7tzswdaowQ0fwE1A+Q2XBi
         KtrcOeo9IP+mfjfi0fsFJHqWv1dn8YV6kOSVCymdbeaNIdDgZRgfqiO/rDvoNau8S2UD
         0d0kafhb0K5gAMPohX6S+B7JU37X7/h0ZrqQaoLEtyorwo/jhcjVr+4yT3EZt4D4cmQz
         6oWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795754573; x=1796359373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8Lw1keLoKzOf/BxPSFHr9zeG8a4MdLodK3QSionyZ4Q=;
        b=tG5zXYR5QNuyLDtBjhj13zsbJSatOOWCKHA+DPuDOVP/fAIkrtDeIuV11pCFE+8OBB
         /8kjJPmW9IG41cFK6IwISTH4zV5y4J+YTn7HBLeIXds8pW8Q9E+FYO2p6H7bpyRCAbnK
         yYsxP0UWQQclAKNQjtG0/YB43swW2E3dreOSKG5jd6Ns/A2Ob81GWyiSqdHy++LeE1jk
         XeVYluldKFv0R6XrLiqJaBK7rpwmucQ7yCWcvPSAgXZXgbIZMSIcBwUat6fSbs8R7Y/T
         aiArQ8SCbL4dest1+1wRSCGGBjTvbiI3U3OsREAEUGxmDHw8yy1yHxLIZXeD2oQ2Ppgm
         BhtA==
X-Forwarded-Encrypted: i=1; AL+hErGmJfNGWW41gOMEbf3/FDJU/02IGR5S08y7OrGJfOhl5CgvjbcNElhSOaATZhTD+1M7vaITXES2yDhyuw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/RIsjNkMdZFe1qtFd93OzL6PCjp2b6weiqqrBDhFSyWedBpLL1
	fcfiFxJdzzOyLjR8zHManBf9MYvYXAImPr45niQ9KUzfYjxACwxfbthcaSjGCQ==
X-Gm-Gg: AZFdTZdE8IdeB3KPPFgAB+DoEyteKTyrkauMbURTN468+5WqcMc1LzNulOnl+H9otFZ
	IMGTDaEtv/CEvHJMrasOA4jxShzu1Uq7zCN3HpxiFSlZ53DhLIzvRUu1w+vD6ly7djWfF08bmqb
	pJuLOYwWLYOtsGTbynOxBsncdalFHD9K+Siawo4BEn2pUYFr5+2J7ygZH1JYc2MSnrjJGW/d/zc
	qTZG1DnL4dGF/lW6Wg9zkeHFvHMN3paUuoJd5BtN4Kd1blcbpXsq3fk3tsNC/1+U/6DKRpEu2SQ
	5QQZD9v3JtmfT43I05qqZbU4eyzAypjKZLXID8hlakSCVpYgfnDuqrcR8VUc9EySVS8sPKOsy0a
	QwsWcIYDP/lCBJe0q7SRyYFt9CI6j7Nk5lB2JewV/+v5T4pwlwrxZx1x0CbOmIYw6hScxJZplcM
	JKUZppiuAk/A/c1NDuWGQM0muQQEEgmq/9n6f6vN9zuFqFESOrFfGJyvi2LEay/OFj4cPfV3mN6
	QK+U76ZKg8rQA3FW2To7xqIUfgm9iTje/YG3a/FLcC6tc7LKDpHaYGGRdVhzOC/i/O1Xq/puWNS
	W/E3VN51sGzYx3LLghpppT6m4ntXEQRyHOgaWMxkTbOWmKdl7vRWexJuoeZvw8E=
X-Received: by 2002:a05:701b:2815:b0:1b5:22d1:1eb5 with SMTP id a92af1059eb24-1b55693615emr23865815c88.37.1795754573309;
        Thu, 26 Nov 2026 20:42:53 -0800 (PST)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556829d31sm88000388c88.9.2026.11.26.20.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:42:51 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Wang Jianjian <wangjianjian3@huawei.com>,
	linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Zheng Zheng <fengaojigui88@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>
Subject: [PATCH 7/8] nilfs2: free virtual block numbers just before collecting DAT changes
Date: Fri, 27 Nov 2026 13:41:00 +0900
Message-ID: <20261127044231.37630-8-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127044231.37630-1-konishi.ryusuke@gmail.com>
References: <20261127044231.37630-1-konishi.ryusuke@gmail.com>
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During garbage collection, obsolete virtual block numbers were previously
freed from the DAT file at the beginning of the GC ioctl in
nilfs_ioctl_prepare_clean_segments().  Because this occurred before
collecting dirty blocks for the new log, those freed DAT entries could
theoretically be reallocated during log construction, making it
impossible to cancel the deallocation and recover consistent state if
construction is aborted.

Move the deallocation via nilfs_dat_freev() to the NILFS_ST_DAT stage
in nilfs_segctor_collect_blocks(), right before collecting dirty DAT
blocks, where freeing DAT entries cannot cause virtual block
reallocation.  Also extend nilfs_palloc_freev() and nilfs_dat_freev()
to report the number of processed entries, and track the deallocation
state with NILFS_CF_VBKFREED so freed DAT entries are reliably restored
on abort.

Fixes: ce5a5ad1a833 ("nilfs2: fix infinite loop in nilfs_clean_segments()")
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/alloc.c   | 14 ++++++++++----
 fs/nilfs2/alloc.h   |  3 ++-
 fs/nilfs2/dat.c     | 15 +++++++++++----
 fs/nilfs2/dat.h     |  3 ++-
 fs/nilfs2/ioctl.c   | 36 +-----------------------------------
 fs/nilfs2/segment.c | 29 +++++++++++++++++++++++++----
 6 files changed, 51 insertions(+), 49 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 7b1cd2baefcf..bc67b211ac55 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -815,10 +815,12 @@ void nilfs_palloc_abort_free_entry(struct inode *inode,
  * @inode: inode of metadata file using this allocator
  * @entry_nrs: array of entry numbers to be deallocated
  * @nitems: number of entries stored in @entry_nrs
+ * @ndone: place to store the number of process entries
  *
  * Return: 0 on success, or a negative error code on failure.
  */
-int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
+int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems,
+		size_t *ndone)
 {
 	struct buffer_head *desc_bh, *bitmap_bh;
 	struct nilfs_palloc_group_desc *desc;
@@ -840,12 +842,12 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 		group = nilfs_palloc_group(inode, entry_nrs[i], &group_offset);
 		ret = nilfs_palloc_get_desc_block(inode, group, 0, &desc_bh);
 		if (ret < 0)
-			return ret;
+			goto fail;
 		ret = nilfs_palloc_get_bitmap_block(inode, group, 0,
 						    &bitmap_bh);
 		if (ret < 0) {
 			brelse(desc_bh);
-			return ret;
+			goto fail;
 		}
 
 		/* Get the first entry number of the group */
@@ -927,7 +929,11 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 					   ret, group, inode->i_ino);
 		}
 	}
-	return 0;
+	ret = 0;
+fail:
+	if (ndone)
+		*ndone = i;
+	return ret;
 }
 
 void nilfs_palloc_setup_cache(struct inode *inode,
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 046d876ea3e0..0028d74c694d 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -60,7 +60,8 @@ void nilfs_palloc_abort_alloc_entry(struct inode *, struct nilfs_palloc_req *);
 void nilfs_palloc_commit_free_entry(struct inode *, struct nilfs_palloc_req *);
 int nilfs_palloc_prepare_free_entry(struct inode *, struct nilfs_palloc_req *);
 void nilfs_palloc_abort_free_entry(struct inode *, struct nilfs_palloc_req *);
-int nilfs_palloc_freev(struct inode *, __u64 *, size_t);
+int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems,
+		size_t *ndone);
 
 #define nilfs_set_bit_atomic		ext2_set_bit_atomic
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 94d358d9d5b0..515f4243c7b5 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -300,6 +300,7 @@ int nilfs_dat_mark_dirty(struct inode *dat, __u64 vblocknr)
  * @dat: DAT file inode
  * @vblocknrs: array of virtual block numbers
  * @nitems: number of virtual block numbers
+ * @ndone: location to store the number of freed virtual block numbers
  *
  * Description: nilfs_dat_freev() frees the virtual block numbers specified by
  * @vblocknrs and @nitems.
@@ -310,7 +311,8 @@ int nilfs_dat_mark_dirty(struct inode *dat, __u64 vblocknr)
  * * %-ENOENT	- An unallocated management block was found.
  * * %-ENOMEM	- Insufficient memory available.
  */
-int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
+int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems,
+		size_t *ndone)
 {
 	unsigned long entries_per_block = NILFS_MDT(dat)->mi_entries_per_block;
 	struct buffer_head *entry_bh = NULL;
@@ -332,14 +334,14 @@ int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
 						&entry_bh);
 		if (unlikely(ret < 0)) {
 			if (ret != -ENOENT)
-				return ret;
+				goto failed;
 			continue;
 		}
 		if (!buffer_nilfs_redirected(entry_bh)) {
 			ret = nilfs_mdt_freeze_buffer(dat, entry_bh);
 			if (unlikely(ret < 0)) {
 				brelse(entry_bh);
-				return ret;
+				goto failed;
 			}
 		}
 
@@ -349,7 +351,12 @@ int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
 	}
 	brelse(entry_bh);
 
-	return nilfs_palloc_freev(dat, vblocknrs, nitems);
+	return nilfs_palloc_freev(dat, vblocknrs, nitems, ndone);
+
+failed:
+	if (ndone)
+		*ndone = 0;
+	return ret;
 }
 
 /**
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index 8e1e52aa9cf7..9eb17ef2bb63 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -37,7 +37,8 @@ void nilfs_dat_abort_update(struct inode *, struct nilfs_palloc_req *,
 			    struct nilfs_palloc_req *);
 
 int nilfs_dat_mark_dirty(struct inode *, __u64);
-int nilfs_dat_freev(struct inode *, __u64 *, size_t);
+int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t items,
+		size_t *ndone);
 void nilfs_dat_cancel_freev(struct inode *dat, __u64 *vblocknrs, size_t items);
 int nilfs_dat_move(struct inode *, __u64, sector_t);
 void nilfs_dat_undo_move(struct inode *dat, __u64 vblocknr);
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 686ac53498bc..a46dad335ee5 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -701,32 +701,6 @@ static int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
 	return nmembs;
 }
 
-/**
- * nilfs_ioctl_free_vblocknrs - free virtual block numbers
- * @nilfs: nilfs object
- * @argv: vector of arguments from userspace
- * @buf: array of virtual block numbers
- *
- * Description: nilfs_ioctl_free_vblocknrs() function frees
- * the virtual block numbers specified by @buf and @argv->v_nmembs.
- *
- * Return: Number of processed virtual block numbers on success, or one of the
- * following negative error codes on failure:
- * * %-EIO	- I/O error.
- * * %-ENOENT	- Unallocated virtual block number.
- * * %-ENOMEM	- Insufficient memory available.
- */
-static int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
-				      struct nilfs_argv *argv, void *buf)
-{
-	size_t nmembs = argv->v_nmembs;
-	int ret;
-
-	ret = nilfs_dat_freev(nilfs->ns_dat, buf, nmembs);
-
-	return (ret < 0) ? ret : nmembs;
-}
-
 /**
  * nilfs_ioctl_mark_blocks_dirty - mark blocks dirty
  * @nilfs: nilfs object
@@ -809,15 +783,7 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 		msg = "cannot delete checkpoints";
 		goto failed;
 	}
-	ret = nilfs_ioctl_free_vblocknrs(nilfs, &argv[2], kbufs[2]);
-	if (ret < 0) {
-		/*
-		 * can safely abort because DAT file is updated atomically
-		 * using a copy-on-write technique.
-		 */
-		msg = "cannot delete virtual blocks from DAT file";
-		goto failed;
-	}
+
 	ret = nilfs_ioctl_mark_blocks_dirty(nilfs, &argv[3], kbufs[3]);
 	if (ret < 0) {
 		/*
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index f3c12c14c750..b306f09c9497 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -107,8 +107,10 @@ static inline int nilfs_sc_cstage_get(struct nilfs_sc_info *sci)
 /* State flags of collection */
 #define NILFS_CF_NODE		0x0001	/* Collecting node blocks */
 #define NILFS_CF_IFILE_STARTED	0x0002	/* IFILE stage has started */
-#define NILFS_CF_SUFREED	0x0004	/* segment usages has been freed */
-#define NILFS_CF_HISTORY_MASK	(NILFS_CF_IFILE_STARTED | NILFS_CF_SUFREED)
+#define NILFS_CF_SUFREED	0x0004	/* segment usages have been freed */
+#define NILFS_CF_VBKFREED	0x0008	/* DAT entries have been freed */
+#define NILFS_CF_HISTORY_MASK	(NILFS_CF_IFILE_STARTED | NILFS_CF_SUFREED | \
+				 NILFS_CF_VBKFREED)
 
 /* Operations depending on the construction mode and file type */
 struct nilfs_sc_operations {
@@ -1271,6 +1273,18 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 		nilfs_sc_cstage_inc(sci);
 		fallthrough;
 	case NILFS_ST_DAT:
+		if (sci->sc_nfreevblks > 0) {
+			size_t ndone;
+
+			err = nilfs_dat_freev(nilfs->ns_dat, sci->sc_freevblks,
+					sci->sc_nfreevblks, &ndone);
+			if (unlikely(err)) {
+				nilfs_dat_cancel_freev(nilfs->ns_dat,
+						sci->sc_freevblks, ndone);
+				break;
+			}
+			sci->sc_stage.flags |= NILFS_CF_VBKFREED;
+		}
  dat_stage:
 		err = nilfs_segctor_scan_file(sci, nilfs->ns_dat,
 					      &nilfs_sc_dat_ops);
@@ -1563,6 +1577,12 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 
 		nilfs_clear_logs(&sci->sc_segbufs);
 
+		if (sci->sc_stage.flags & NILFS_CF_VBKFREED) {
+			nilfs_dat_cancel_freev(nilfs->ns_dat,
+					sci->sc_freevblks, sci->sc_nfreevblks);
+			sci->sc_stage.flags &= ~NILFS_CF_VBKFREED;
+		}
+
 		if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
 			err = nilfs_sufile_cancel_freev(nilfs->ns_sufile,
 							sci->sc_freesegs,
@@ -1909,11 +1929,12 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 	if (list_empty(&logs))
 		return; /* if the first segment buffer preparation failed */
 
-	if (nilfs_doing_gc()) {
+	if (nilfs_doing_gc())
 		nilfs_cancel_block_relocation(&logs);
+
+	if (sci->sc_stage.flags & NILFS_CF_VBKFREED)
 		nilfs_dat_cancel_freev(nilfs->ns_dat, sci->sc_freevblks,
 				sci->sc_nfreevblks);
-	}
 
 	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);
 	nilfs_free_incomplete_logs(&logs, nilfs);
-- 
2.53.0

