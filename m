Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795754562;
	b=sFQZ8mt15dkcInpG9m/i24kinLmpHKIhfefQA5rTVu6ZIYb7bN3iHwAxTf7gd1RDQ4Qs
	 frIWkblZs2T9fgxdGY+NfSD+l078Ifq5cPNw+TFCdOXDZ3Qa7sbtW94P7UPupDGBGLw71
	 j2TFi2WBRcCLm1i+piYdZ/vBK2fXwU9x170FzcRz/dp49ONlk6mCoSF6XkfrecKr4jDwm
	 wWrrziFh9TIy7ON8RE8FRwb55Qv0jbspKMBH9A3YO8NSdXAulGcj4sGHEKqsfgjM2w13F
	 7+imUnh0Sh6itT/zHv78+LEB7TZpkAfMoI2Be7YMm91eT8+xglfL7rRpyvdB6HrZtaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795754562;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5OwI7aiL42uUdQVwTE/xjv216C9AaTLHeX4bUu2Ny4Y=;
	b=BZ+XcJ6hqlEm8dIq4DwIQPC8Ry2+VQzgPq8g4z33A+kzWwsR1Hdg7JensH+gICI/xmsE
	 p71XAR8QThVKnQYHWzX5pNeuxMK3UrL/FNqRLTkyt6FTlZZD5qFDxI6GjWj8IIsMgCVrt
	 fqYywvw+JgBq0Vxt0WgRHPBcOaIs2w1h7ZGHVyPui6bnkj+nIdT0POHls/s1zlhsS5E1M
	 Pj/GZeAl87UvPIe1yYyYFTNCkJdRZVFw9/CKicClHEYIN9qgbe49cPxH9BlBcpzBcBe7+
	 iLjoXviy61j0EgceuThBQ4p1Hqw7JaUWVsqQbVetwGLfHneUYAKDyaOq+jVoN+i3zHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EegywdNx;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CADF606A699
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Nov 2026 04:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CADF606A699
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EegywdNx
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-14394530ec6so1439323c88.1
        for <linux-nilfs@vger.kernel.org>; Thu, 26 Nov 2026 20:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795754561; x=1796359361; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5OwI7aiL42uUdQVwTE/xjv216C9AaTLHeX4bUu2Ny4Y=;
        b=EegywdNxlMW7z+ECBrzDPvt1rmgqQHEbZ9Ls4lh3u9J1TyEWaNJz4ez0N7rYbMqNdh
         M2DEzXQk/fQkkgPSjphO+Ckcp59bvvvTcE2I3AxgGXjwWOaqvWXN2ixe+O3AgZ23T14c
         QNMk1RsaJLiP3DUwAsXF5UDJ30oy3bCt2dXYzKuRJ3pSBTX+KG7PK3xsysiPN8ZpL9rk
         HAUWivC/xOthYT6Lw7fCRCK6aX/4KzyTY/LJbblNa1eRJ52PI8hnY6J7xStD1q5azTsP
         t2mcwJG3SpyFbaUvfdVwQgq1TKSf+Pcze+wbhVlZgaWMfsTZ3SLBOh4IB3gxitN/W3Bp
         vCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795754561; x=1796359361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5OwI7aiL42uUdQVwTE/xjv216C9AaTLHeX4bUu2Ny4Y=;
        b=ILvIhTEIyZ9Ek1MfTpYkkMDpuiT5Tevdf6HdReh2pwdF8BgzJsk6zn2P0lLSj3CxmC
         hIvHBqMUwTsEF3nWgbjAryin3PfG4igRIxcqlnKcoLsslpcSy0DAkGixR7xfKI+dKqC4
         YfYsIr7Mpk22bw3pSIc3LWTUtr0W2THqACXMroI0GbSIR6Nl76cVvcrVd6E8+moaw0zK
         7Ndtren0CrFl8poiw/jB3x12R0X4c9SEgTmhl5aBv5a31AGLel4Oxj9lbrB7ExhH1lTV
         6mbBibAbdcx0ofDnLamFxj8eS1dd4pKLhzNhYuRpafQZ3fU3cVQlTbF8H/Adp++Y+Iwo
         nZRw==
X-Forwarded-Encrypted: i=1; AL+hErFHFeWx63GTpOxCU/DYGYzjz3kzUqaYsxj0cm3/5Q3ZpkOJC474TfTTyLX7VOPKNgOKB5yGXfTigsrE3g==@vger.kernel.org
X-Gm-Message-State: APuU4Z9/sBYEhd+9kW0hT+JLtY0mbgzY9ICAI71XAPFciLyL7ZPfhmQO
	XF8PwAKE93g2eM5/F5gi9jwJSFCtYfkHZ8iHzYrqwKJrUV2oxx4JjwFsVEhSMA==
X-Gm-Gg: AZFdTZczy60z9AEJOnIjkQ1ru/C/PymM3H5OIPItjhnDfXYrNzv28/fKzV3dXvf1jUm
	GB/WDE0WWac5BlARb0evWkRLtuTrc211mSh4TK98erQM1m7uuHC7bzcFjaLvftxIFM554Emd6dr
	HfsIg+VjHwI5GPTSD+DOJztYCZrSVa4dDDt9xDcd1uEKZCv28PTSs9vya+ip1BN38Gyw+wraaMz
	11PEeAqJWgz+C2E5X+eVb4aqBtefSxl0/3HXQui2t4XViDRjLXRNUWBBDjWg7K2sob8cxDRxWv6
	aXPifkWmaC6JTuzg9mleEuoeF9IalKIIJYqbQdjr/Do+TkJcQNTWiKcTlsPR4DzVqFjcp34l5yG
	VESvnK62xozTqdnp2QmQ6UlXoMnOCHTf/tvhWoZLxdbK/BUTl2KdGvyoQB/aKzVRNORJnJJr3/8
	aRjZVn4qCC0/J6Ls7B8kYm1kGjWpirfN++fpWUtQLmw1C9IIxd55o3rnNM6iHaOvA6x9ad6yxn1
	xWR/zKLzL/IbyInknj8EhMLrxGBEKtL9g5wvD+8JPSlrju8iTBFB7PldRGtqfQYeafgj3qpli19
	JstbQM21pobf8A/cuV2hD2nPsq5HizAZIUADh7ahQl7zXJPID/w9FQ28xQP3RFA=
X-Received: by 2002:a05:701a:ccc9:10b0:166:f097:6f12 with SMTP id a92af1059eb24-1b5568b3e73mr22698115c88.15.1795754561058;
        Thu, 26 Nov 2026 20:42:41 -0800 (PST)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556829d31sm88000388c88.9.2026.11.26.20.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:42:39 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Wang Jianjian <wangjianjian3@huawei.com>,
	linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Zheng Zheng <fengaojigui88@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>
Subject: [PATCH 2/8] nilfs2: cancel the relocation of GC-targeted blocks if log writing fails
Date: Fri, 27 Nov 2026 13:40:55 +0900
Message-ID: <20261127044231.37630-3-konishi.ryusuke@gmail.com>
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
in nilfs_clean_segments() when GC fails.

When log writing fails, dirty metadata and data buffers for regular
inodes remain dirty in memory, so retrying the log write causes no
inconsistency.  However, for blocks relocated by garbage collection,
their physical block mappings in the DAT have already been updated to
the new locations during log writing.  If GC aborts on error and
discards its cached GC inodes without reverting these DAT mappings,
subsequent data reads or B-tree lookups will end up reading unwritten
block locations.

To allow safely bailing out of the GC loop on error, add a mechanism to
cancel the relocation of GC-targeted blocks and partially restore the
DAT when log writing fails in a GC context.  Specifically, introduce
nilfs_dat_undo_move() to restore original physical block numbers from
the saved buffers in the DAT shadow mapping, expose it through a new
bmap operation bop_undo_assign and nilfs_bmap_undo_assign() (set only
for GC inodes), and invoke nilfs_cancel_block_relocation() from
nilfs_segctor_abort_construction() when nilfs_doing_gc() is true.

Fixes: ce5a5ad1a833 ("nilfs2: fix infinite loop in nilfs_clean_segments()")
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/bmap.h    | 23 ++++++++++++++++++
 fs/nilfs2/btree.c   |  8 +++++++
 fs/nilfs2/dat.c     | 58 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/dat.h     |  1 +
 fs/nilfs2/direct.c  |  1 +
 fs/nilfs2/segment.c | 35 +++++++++++++++++++++++++++
 6 files changed, 126 insertions(+)

diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index a72f3c308a5d..6493217b1a7f 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -53,6 +53,7 @@ struct nilfs_bmap_stats {
  *                            mapping root
  * @bop_lookup_dirty_buffers: operation to collect dirty block buffers
  * @bop_assign:               disk block address assignment operation
+ * @bop_undo_assign:          undo disk block address assignment operation
  * @bop_mark:                 operation to mark in-use blocks as dirty for
  *                            relocation by GC
  * @bop_seek_key:             find valid block key operation
@@ -74,6 +75,8 @@ struct nilfs_bmap_operations {
 			  struct buffer_head **,
 			  sector_t,
 			  union nilfs_binfo *);
+	void (*bop_undo_assign)(struct nilfs_bmap *bmap,
+				struct buffer_head *bh);
 	int (*bop_mark)(struct nilfs_bmap *, __u64, int);
 
 	int (*bop_seek_key)(const struct nilfs_bmap *, __u64, __u64 *);
@@ -182,6 +185,26 @@ static inline int nilfs_bmap_lookup(struct nilfs_bmap *bmap, __u64 key,
 	return nilfs_bmap_lookup_at_level(bmap, key, 1, ptr);
 }
 
+/**
+ * nilfs_bmap_undo_assign - restore the block number to its original position
+ * @bmap:    bmap
+ * @bh:      buffer head for which the block number should be undone
+ *
+ * nilfs_bmap_undo_assign() undoes the block relocation performed during
+ * garbage collection for the buffer @bh and restores its original block
+ * position.  For regular bmaps where bop_undo_assign is %NULL, this
+ * function is a no-op.
+ */
+static inline void nilfs_bmap_undo_assign(struct nilfs_bmap *bmap,
+					struct buffer_head *bh)
+{
+	if (bmap->b_ops->bop_undo_assign) {
+		down_write(&bmap->b_sem);
+		bmap->b_ops->bop_undo_assign(bmap, bh);
+		up_write(&bmap->b_sem);
+	}
+}
+
 /*
  * Internal use only
  */
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 6b8332e8c0db..8c12b78c0e9d 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -2378,6 +2378,12 @@ static int nilfs_btree_assign_gc(struct nilfs_bmap *btree,
 	return 0;
 }
 
+static void nilfs_btree_undo_assign_gc(struct nilfs_bmap *btree,
+				struct buffer_head *bh)
+{
+	nilfs_dat_undo_move(nilfs_bmap_get_dat(btree), bh->b_blocknr);
+}
+
 static int nilfs_btree_mark(struct nilfs_bmap *btree, __u64 key, int level)
 {
 	struct buffer_head *bh;
@@ -2423,6 +2429,7 @@ static const struct nilfs_bmap_operations nilfs_btree_ops = {
 	.bop_lookup_dirty_buffers =	nilfs_btree_lookup_dirty_buffers,
 
 	.bop_assign		=	nilfs_btree_assign,
+	.bop_undo_assign	=	NULL,
 	.bop_mark		=	nilfs_btree_mark,
 
 	.bop_seek_key		=	nilfs_btree_seek_key,
@@ -2445,6 +2452,7 @@ static const struct nilfs_bmap_operations nilfs_btree_ops_gc = {
 	.bop_lookup_dirty_buffers =	nilfs_btree_lookup_dirty_buffers,
 
 	.bop_assign		=	nilfs_btree_assign_gc,
+	.bop_undo_assign	=	nilfs_btree_undo_assign_gc,
 	.bop_mark		=	NULL,
 
 	.bop_seek_key		=	NULL,
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 888dc1831c86..d2718944368b 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -379,6 +379,64 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 	return 0;
 }
 
+/**
+ * nilfs_dat_undo_move - undo the change to the block number
+ * @dat:      DAT file inode
+ * @vblocknr: virtual block number
+ *
+ * nilfs_dat_undo_move() restores the original physical block number for
+ * @vblocknr from the frozen DAT entry buffer in the shadow mapping, if such
+ * a saved buffer exists and is marked uptodate; otherwise, it does nothing.
+ */
+void nilfs_dat_undo_move(struct inode *dat, __u64 vblocknr)
+{
+	struct buffer_head *entry_bh, *saved_bh;
+	int ret;
+
+	if (WARN_ON_ONCE(!nilfs_doing_gc()))
+		return;
+
+	ret = nilfs_palloc_get_entry_block(dat, vblocknr, 0, &entry_bh);
+	if (ret < 0) {
+		if (unlikely(ret != -ENOENT)) {
+			nilfs_warn(dat->i_sb,
+				"%s: error %d loading the entry block for vblocknr = %llu",
+				__func__, ret, (unsigned long long)vblocknr);
+		}
+		return;
+	}
+
+	if (!buffer_nilfs_redirected(entry_bh))
+		goto release_entry_bh;
+
+	saved_bh = nilfs_mdt_get_frozen_buffer(dat, entry_bh);
+	if (!saved_bh)
+		goto release_entry_bh;
+
+	if (likely(buffer_uptodate(saved_bh))) {
+		struct nilfs_dat_entry *entry, *saved_entry;
+		__le64 cur_blocknr, orig_blocknr;
+		size_t offset;
+
+		offset = nilfs_palloc_entry_offset(dat, vblocknr, entry_bh);
+		entry = kmap_local_folio(entry_bh->b_folio, offset);
+		saved_entry = kmap_local_folio(saved_bh->b_folio, offset);
+		cur_blocknr = entry->de_blocknr;
+		entry->de_blocknr = orig_blocknr = saved_entry->de_blocknr;
+		kunmap_local(saved_entry);
+		kunmap_local(entry);
+		if (cur_blocknr != orig_blocknr) {
+			mark_buffer_dirty(entry_bh);
+			nilfs_mdt_mark_dirty(dat);
+		}
+	}
+
+	brelse(saved_bh);
+
+release_entry_bh:
+	brelse(entry_bh);
+}
+
 /**
  * nilfs_dat_translate - translate a virtual block number to a block number
  * @dat: DAT file inode
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index 468c82d26183..4f67f31f928b 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -39,6 +39,7 @@ void nilfs_dat_abort_update(struct inode *, struct nilfs_palloc_req *,
 int nilfs_dat_mark_dirty(struct inode *, __u64);
 int nilfs_dat_freev(struct inode *, __u64 *, size_t);
 int nilfs_dat_move(struct inode *, __u64, sector_t);
+void nilfs_dat_undo_move(struct inode *dat, __u64 vblocknr);
 ssize_t nilfs_dat_get_vinfo(struct inode *, void *, unsigned int, size_t);
 
 int nilfs_dat_read(struct super_block *sb, size_t entry_size,
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 64da677dc8d4..18a700db76ed 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -375,6 +375,7 @@ static const struct nilfs_bmap_operations nilfs_direct_ops = {
 	.bop_lookup_dirty_buffers	=	NULL,
 
 	.bop_assign		=	nilfs_direct_assign,
+	.bop_undo_assign	=	NULL,
 	.bop_mark		=	NULL,
 
 	.bop_seek_key		=	nilfs_direct_seek_key,
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 4c2d51f6550c..24f8fa8cf864 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1860,6 +1860,39 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 	nilfs_end_folio_io(fs_folio, err);
 }
 
+/**
+ * nilfs_cancel_block_relocation - cancel relocation of GC-targeted blocks
+ * @logs: list of segment buffers whose log write failed or was aborted
+ *
+ * nilfs_cancel_block_relocation() iterates through the payload buffers of
+ * each segment buffer in @logs (excluding the super root block) and calls
+ * nilfs_bmap_undo_assign() to revert the DAT mappings of blocks relocated
+ * by garbage collection.  This is necessary to prevent subsequent data reads
+ * or B-tree lookups from accessing unwritten block locations via the DAT
+ * after GC aborts on error and discards the cached GC inodes.
+ */
+static void nilfs_cancel_block_relocation(struct list_head *logs)
+{
+	struct nilfs_segment_buffer *segbuf;
+	struct buffer_head *bh;
+	struct inode *inode;
+
+	list_for_each_entry(segbuf, logs, sb_list) {
+		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
+				    b_assoc_buffers) {
+			if (bh == segbuf->sb_super_root)
+				break;
+			inode = bh->b_folio->mapping->host;
+			/*
+			 * NILFS_I(inode)->i_bmap points to the primary inode's
+			 * bmap structure, whether the inode serves as a cache
+			 * for B-tree nodes or as the primary inode itself.
+			 */
+			nilfs_bmap_undo_assign(NILFS_I(inode)->i_bmap, bh);
+		}
+	}
+}
+
 static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 					     struct the_nilfs *nilfs, int err)
 {
@@ -1874,6 +1907,8 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 	if (list_empty(&logs))
 		return; /* if the first segment buffer preparation failed */
 
+	if (nilfs_doing_gc())
+		nilfs_cancel_block_relocation(&logs);
 	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);
 	nilfs_free_incomplete_logs(&logs, nilfs);
 
-- 
2.53.0

