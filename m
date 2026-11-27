Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795754581;
	b=EkPRQnIdap/YZkEAt7wYFKS3w/NMCzRn1FEXIC63ktAijHmCT+Akec5Z5waq8/GhsZo5
	 CXD7rwBGJfkFKk57VGLbAw5HHCxzjrEyug/5m79S6DzhIb+m+OrILCCZQm6V3ffmzlJIA
	 2sweugf+g5Nzl5bRuN1gwGVgCVJ4DQnReMk8KUEneYNMesYPwGxWWuVTcIj769OoHWoyQ
	 BDN4A53/B13dR5KcpTqFP9sKXXmMpZCVm7S9d9J8PxRLrTFPlNWdMpaM9iHUJxKdRJpvR
	 HudlWt0xrRQYunT6m8JlURqDvdgCP+/pQQp+Dr8OkTWbjQFVeQTsGCvWaMK+xwNQZJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795754581;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k0rYRyrD1fMCKRAq6G01uKOV/1M1ZNsc6U0xUKlxk/8=;
	b=w4DM4ExN/rDozjsd/g8mbG6SNmD4EQHvBEgrFHCh+dfCU1yueUuNlY3cKzDoc2JWhbZ8
	 0ExpVu0C+H9WwWehBP3WdY49BxgdRzoMKpt3s/MGxZV/pYPi0nfLdNmukS//PXzDKTZZU
	 oIN87p2TOGTiT9Uix0KBlyxy3ka5OeGTNwSCVL4x8KPWadCPmqxM9Nu2S53A1CpYSGUT4
	 FPnkkBksgTW8viCIqzK3dqdfTGjjmfK1sDp7GM+1UFP9Zc9aF7963GMtNXeVO3z4Jf4Sb
	 XTghvQsZS+3yAQNHBwMl0MKcYM2KNpHR2P0WZrKYyvofGL25u38QmlBPX9LbnXp/5iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Uj9U0lvJ;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74322606A691
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Nov 2026 04:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74322606A691
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Uj9U0lvJ
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1ae58d17cd9so8673208c88.1
        for <linux-nilfs@vger.kernel.org>; Thu, 26 Nov 2026 20:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795754571; x=1796359371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k0rYRyrD1fMCKRAq6G01uKOV/1M1ZNsc6U0xUKlxk/8=;
        b=Uj9U0lvJW0hn+15LlcVLiuocGYdZQUYHXub06SdKvfkyUvGIrtmzJzESL6V4YJIcsV
         1Qsz7YQ5qSpZ0jk+bZPMau4xGOvzxcg6azaD41FPjXsmGJc8fyjP4SNUtHVUjmXF434Y
         sK5l5pb1acke3oS4xBBJQSbDpKxAWUskoWZRgxdpY00wONwhu8DmMr36O5WGIfbP8rae
         3/zAOW42cr/qj7DSRiiXb4NA6XebtSPpDub9xh1arh4B79TLPpXiaDFfQmaXaIKPa4eC
         PcJlqmEGk5RHNaXuRwhgx+X3fQ7f5FX0jps1mvBqPUp/DNEvu+moycTbnzA+rJ7xlDbY
         /72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795754571; x=1796359371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k0rYRyrD1fMCKRAq6G01uKOV/1M1ZNsc6U0xUKlxk/8=;
        b=N23JdXMbTHfUR8Mei96BcIhoQpLm6scNlp80z1HM00pA8E13Tid4/Nt9rFWdEDMcgb
         kT1swX65ezpoNQunHdK306PJmjDle+w11vjGSrhT+YlgsTjFnUAdD+96UdejRvvXZFWe
         qXAGqKt1yEz2ozgTZga6WnVkGM0lcEjFjpeKIuOPNfnFHY+TzQuvajHPhkHK3I7VSP6X
         /HAPxK8pbmBRrY4kIh3RJ4UvF1rZ46bRKHw8Ab+wVgrA1M/s+KXOpSiPjiFtx2C+PVUk
         l63NkLC5sbLHkE4x3k2Z31S+5C+auafydikBmF4jVnzY47zhAFnI/7VDVImzheh58DUU
         0GjQ==
X-Forwarded-Encrypted: i=1; AL+hErF07IHQfJ1SsjPP18gXel5S6301HEL3RLXxYETrn9rS7p08maJbHb0UVIj7+l7X26GLdt2Mb9T+wU/Hlw==@vger.kernel.org
X-Gm-Message-State: APuU4Z8KnMuSFl3Q5SjMBAQ/rXLcLv9AuwmrhWXlrXq+qKe5VcoU9/7x
	bUbf5wbRFL9IWwshV5+WTQdpv5Iwl3HHo9Te73/ROBRcuHbfxR2cXO5n
X-Gm-Gg: AZFdTZex5Q873OpYPZkvajvMNScAYjY3w/32Urk4f7lQG6qdz3yg+/bCil5p/PSgt0l
	ADkpnSxyvgcLSWh0YPolvoX6/PprbdpFGbHuEVLmYDbUS2EhFrU1AKQ9WdT+VIZALePT4hYwoKp
	Ajh7Qzat5SguuQm22RiCXvwYHNLKnXitiSjRbvM+4KN88BJH1Uw0xWlWbd6w8nZbJ7Ma9QjpJWL
	mXfXJs/ht84af4o2mKdiFvm7bnuZ1Ot/QWIeO4FFw5vy6BD0ChY4zBs9Wc+kMYHpFkDzR7J/bj7
	OMNmR70aiBCSp5ZKFbigsf2TjwxTzVLGJYwldjJyaOC8luN9HEk92qnGd9r7ap+kj2f457B1fCR
	Lk4srS1oFFAk2GF9FPVaCTgneAZyj1azE4DIx+a/BjNQHDDftvUaixk5zUznVofTobMncnbE8pT
	ihff6AeOQsj2FvP4mTzwf5rsq+E6W2MMaSxIJ0h5cbjdk05j8e+bih4hwxMW4bSMeC8BK+wUEFP
	o6Z2MuJE8rclJg7w1Mwxi8IzVivJKCLaNBRMOmT3uKYMjbzk+TdTBUbBcoVX3okNxFbOzJWtVdE
	g8a+P+HhlXMtVkBVOzHVMb0E89MpyP8Yo30jz9MZMniEfST4/4qQuIcpqDxeqUg=
X-Received: by 2002:a05:701b:4588:10b0:195:76af:b810 with SMTP id a92af1059eb24-1b5972b4691mr1650412c88.25.1795754570587;
        Thu, 26 Nov 2026 20:42:50 -0800 (PST)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556829d31sm88000388c88.9.2026.11.26.20.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:42:49 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Wang Jianjian <wangjianjian3@huawei.com>,
	linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Zheng Zheng <fengaojigui88@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>
Subject: [PATCH 6/8] nilfs2: restore removed DAT entries when aborting GC
Date: Fri, 27 Nov 2026 13:40:59 +0900
Message-ID: <20261127044231.37630-7-konishi.ryusuke@gmail.com>
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

Since commit ce5a5ad1a833 ("nilfs2: fix infinite loop in
nilfs_clean_segments()"), an escape path was added to exit the GC loop
in nilfs_clean_segments() when GC fails.  However, if GC is aborted
due to an error, obsolete virtual block numbers freed from the DAT
metadata file are left deleted, causing subsequent GC runs or userland
tools such as lssu -l (which relies on the DAT to evaluate live blocks)
to fail due to missing DAT entries.

Fix this by restoring the removed DAT entries from the shadow mapping
saved by nilfs_dat_freev() when log construction is aborted during GC.

Fixes: ce5a5ad1a833 ("nilfs2: fix infinite loop in nilfs_clean_segments()")
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/dat.c     | 72 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/dat.h     |  1 +
 fs/nilfs2/segment.c | 10 ++++++-
 fs/nilfs2/segment.h |  4 +++
 4 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index b4156945e433..94d358d9d5b0 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -352,6 +352,78 @@ int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
 	return nilfs_palloc_freev(dat, vblocknrs, nitems);
 }
 
+/**
+ * nilfs_dat_cancel_freev - undo removal of DAT entries
+ * @dat:       DAT file inode
+ * @vblocknrs: array of virtual block numbers
+ * @nitems:    number of virtual block numbers
+ *
+ * nilfs_dat_cancel_freev() restores freed virtual block numbers specified by
+ * @vblocknrs and @nitems from the shadow mapping.
+ */
+void nilfs_dat_cancel_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
+{
+	unsigned long entries_per_block = NILFS_MDT(dat)->mi_entries_per_block;
+	unsigned int entry_size = NILFS_MDT(dat)->mi_entry_size;
+	struct buffer_head *entry_bh = NULL, *saved_bh = NULL;
+	struct nilfs_palloc_req req;
+	__u64 start_vblocknr = 0, end_vblocknr = 0;
+	size_t i;
+
+	for (i = 0; i < nitems; i++) {
+		size_t offset;
+		int ret;
+
+		req.pr_entry_nr = vblocknrs[i];
+		ret = nilfs_palloc_prepare_alloc_entry(dat, &req, false);
+		if (ret < 0)
+			continue;
+
+		if (req.pr_entry_nr != vblocknrs[i])
+			goto abort_alloc_entry;
+
+		if (!saved_bh || vblocknrs[i] < start_vblocknr ||
+			vblocknrs[i] >= end_vblocknr) {
+			u64 rem;
+
+			brelse(saved_bh);
+			saved_bh = NULL;
+			brelse(entry_bh);
+			entry_bh = NULL;
+
+			ret = nilfs_dat_prepare_entry(dat, &req, true);
+			if (ret < 0)
+				goto abort_alloc_entry;
+
+			entry_bh = req.pr_entry_bh;
+
+			saved_bh = nilfs_mdt_get_frozen_buffer(dat, entry_bh);
+			if (!saved_bh) {
+				brelse(entry_bh);
+				entry_bh = NULL;
+				goto abort_alloc_entry;
+			}
+
+			div64_u64_rem(vblocknrs[i], entries_per_block, &rem);
+			start_vblocknr = vblocknrs[i] - rem;
+			end_vblocknr = start_vblocknr + entries_per_block;
+		}
+
+		offset = nilfs_palloc_entry_offset(dat,	vblocknrs[i], entry_bh);
+		memcpy_folio(entry_bh->b_folio, offset, saved_bh->b_folio,
+			offset, entry_size);
+		mark_buffer_dirty(entry_bh);
+		nilfs_palloc_commit_alloc_entry(dat, &req);
+		continue;
+
+abort_alloc_entry:
+		nilfs_palloc_abort_alloc_entry(dat, &req);
+	}
+
+	brelse(saved_bh);
+	brelse(entry_bh);
+}
+
 /**
  * nilfs_dat_move - change a block number
  * @dat: DAT file inode
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index 4f67f31f928b..8e1e52aa9cf7 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -38,6 +38,7 @@ void nilfs_dat_abort_update(struct inode *, struct nilfs_palloc_req *,
 
 int nilfs_dat_mark_dirty(struct inode *, __u64);
 int nilfs_dat_freev(struct inode *, __u64 *, size_t);
+void nilfs_dat_cancel_freev(struct inode *dat, __u64 *vblocknrs, size_t items);
 int nilfs_dat_move(struct inode *, __u64, sector_t);
 void nilfs_dat_undo_move(struct inode *dat, __u64 vblocknr);
 ssize_t nilfs_dat_get_vinfo(struct inode *, void *, unsigned int, size_t);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 263f9ff00193..f3c12c14c750 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1909,8 +1909,12 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 	if (list_empty(&logs))
 		return; /* if the first segment buffer preparation failed */
 
-	if (nilfs_doing_gc())
+	if (nilfs_doing_gc()) {
 		nilfs_cancel_block_relocation(&logs);
+		nilfs_dat_cancel_freev(nilfs->ns_dat, sci->sc_freevblks,
+				sci->sc_nfreevblks);
+	}
+
 	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);
 	nilfs_free_incomplete_logs(&logs, nilfs);
 
@@ -2605,6 +2609,8 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 
 	sci->sc_freesegs = kbufs[4];
 	sci->sc_nfreesegs = argv[4].v_nmembs;
+	sci->sc_freevblks = kbufs[2];
+	sci->sc_nfreevblks = argv[2].v_nmembs;
 	sci->sc_subuf = subuf;
 	list_splice_tail_init(&nilfs->ns_gc_inodes, &sci->sc_gc_inodes);
 
@@ -2636,6 +2642,8 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 
  out_unlock:
 	sci->sc_subuf = NULL;
+	sci->sc_freevblks = NULL;
+	sci->sc_nfreevblks = 0;
 	sci->sc_freesegs = NULL;
 	sci->sc_nfreesegs = 0;
 	list_splice_tail_init(&sci->sc_gc_inodes, &nilfs->ns_gc_inodes);
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index e67afc14a82c..711c69e24575 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -83,7 +83,9 @@ struct nilfs_segsum_pointer {
  * @sc_iput_queue: list of inodes for which iput should be done
  * @sc_iput_work: work struct to defer iput call
  * @sc_freesegs: array of segment numbers to be freed
+ * @sc_freevblks: array of virtual block numbers to be freed
  * @sc_nfreesegs: number of segments on @sc_freesegs
+ * @sc_nfreevblks: number of virtual block numbers on @sc_freevblks
  * @sc_subuf: buffer used to save segment entries
  * @sc_dsync_inode: inode whose data pages are written for a sync operation
  * @sc_dsync_start: start byte offset of data pages
@@ -129,7 +131,9 @@ struct nilfs_sc_info {
 	struct work_struct	sc_iput_work;
 
 	__u64		       *sc_freesegs;
+	__u64		       *sc_freevblks;
 	size_t			sc_nfreesegs;
+	size_t			sc_nfreevblks;
 	void		       *sc_subuf;
 
 	struct nilfs_inode_info *sc_dsync_inode;
-- 
2.53.0

