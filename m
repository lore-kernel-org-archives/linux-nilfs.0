Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617A337CD21
	for <linux-nilfs@vger.kernel.org>; Wed,  2 Sep 2026 11:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788348092; cv=none; b=f7HzOYXGPyU/kKi3eOkOhLyBfTKRIAp3c4TSiuHslLsgNxY/osmSgK7Yu8VgCLFc7QPAHiQ3O47n6XcBo5TZ2DvgKEXE5eZlvQDYMOhfz5OTdAuNQ4zEvw/q6lZUPAzdfEGosqIdzyOELQbmvh829ooldOMHh0whGL1xAxSJLE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788348092; c=relaxed/simple;
	bh=c/wQKmUSzU8ziJYz7as+k6+5HYdNlx5SIqPlvA8nW6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q2lcuVMZRQs+Nq//5DVHY/XRvfE7iZv77332n7Ez7geQNQZAcdyQQ9NspWQ/zOCXUHSGnqb4rRN3RHGKK+OJxbsVHQbG2F3E/L4Ph5hxOoNJd3hSqcirlvsizZ8UJWoIdzV+O8Mf6OUTYs1r+nIesE6TeatygQhHUxS1boOdyXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Of4GpOBD; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Of4GpOBD"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-855d2bfae95so2337772b3a.1
        for <linux-nilfs@vger.kernel.org>; Wed, 02 Sep 2026 04:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788348090; x=1788952890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cUtVtVjiKeiGWLkAF+yWgaZY7ulxa5mtX18RLlXcwM8=;
        b=Of4GpOBDlb5W1cmaXD+SRIcnrpYxZYBA/eBGLX135+V/OpfYFKrjQ8yLI6OXaJjdBc
         Os9mTq9u9jtdKtCUom/hmguuMZMnhnNCfSUMqNATrMOH4tUE16GENgjY41o9yCgyr2PB
         umZRdacnqYcBlzzSqrSSwR90NCwqxiB7NNOYozUe9L5r9iwEjTxMSUkq/DQB2P0a6XBG
         EWJ53bTqImnDkySVXsuvYiePva/7Z0Yg4M6kJgD0nV8FoUeDpgD01UXERYj73O4ji6O/
         006nsgiLHGGkIOODiZLC8DoJoCc9UYV4sdcqVn3q6bu5sUsePFJo3+RpCB1EZeFJB/vI
         pACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788348090; x=1788952890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cUtVtVjiKeiGWLkAF+yWgaZY7ulxa5mtX18RLlXcwM8=;
        b=QypVQk88tXwyTioExoQj5lvgG8b/3R8xctFLno1pwtQk+NoRg/RWaiRHQ05AubgtVB
         NcJpsS30bJIGxwaT04TG1SvNx6yiFWxF+lgDKuEAzD7b4RRmusAFSpMPPCdsq5CQK79R
         Md+fEYYQnsaSk6Xc2lgvaNHZzH9Cb45GcuDuI24ykK+OU+WpgHAAPEU5LIhC9Ytm2tcU
         e3O2eXpDT+MxeL8Royfud+phM3yVWquWR/+z2KuUFU9B9hrPnXe/k8FUrvRgcqjsa1iL
         L1qcCwQROsZ/W9UOIj0zvDmnJaathjdubsqRqMyDQE4izCqCbiyIzuGVTE+O3DSzdYYJ
         w3HQ==
X-Forwarded-Encrypted: i=1; AKwUvBzXchVa/AFqqiyr0lrSYaRObKZQnunmseEHOfpwB9pcSBufpeLQx0LC6PUiqJdmE7grJdbpGpiqQCD5Cw==@vger.kernel.org
X-Gm-Message-State: AFuF++kvYrzmFmJc7yCUIBiLXUlmI5sqvPBG8l0OQ2/hYmHn66HIwdht
	Ow06fMny2BQEKShNvXj6+iFAsuhEHG8/FNW2jGg3yCqlkjqWbQ39pdAG
X-Gm-Gg: AYBFou1MUOVbe5jQvPRioBQaaEE6BjEgYZhvxV6K/W4esvAnlDU90eIHfELZ0SCNcFh
	qT1pmsNBynPAtmRmfi7nRuMbywVgqtGfmN27IpcaNS6ZSc/3hGYvaIWt4YO9BZuoC0+MDZROcye
	5oWlLeQGLimRtfC9AkX31a/FGwSF7CmcJKiSl+6dTkVoHVXFlB4S2IDsnIN0pInom+Fi8j5llv7
	gy/4HO5zC/Ml9yDwkwGkAADE2YS0CkWjMjAOiEA1xP7dQFrNRDgSEGXH2Vv90/DUQkOxLAI3SO0
	YgRx1Ms2Wk/IYt1nAYwrvoM1pjcT4jS/xovazyi4ctA4j0CgvQehc2KQVcZ9wSJQq+pJFw9SnNi
	RivSqkDVLGlq2wFst7i+xKFiDTiURu0wKIGjGNWOBkyXESZq+hswPdJv09OB8lX14pJ9nOcVkMV
	vJIalr+LVStr3olDBFT6p+8tZ/2j0m15Tl+494zcybWFJ82bQkKb6yaetq4wcQGpchlAvQyXwNB
	CTS32eyBjY=
X-Received: by 2002:a05:6a00:4c87:b0:845:cad1:d691 with SMTP id d2e1a72fcca58-85f4255a5c0mr2156595b3a.5.1788348089351;
        Wed, 02 Sep 2026 04:21:29 -0700 (PDT)
Received: from ustb520lab-MS-7E07.. ([123.124.147.27])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85dc07157d5sm1177258b3a.46.2026.09.02.04.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 04:21:28 -0700 (PDT)
From: Jiaming Zhang <r772577952@gmail.com>
To: konishi.ryusuke@gmail.com,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com
Cc: linux-kernel@vger.kernel.org,
	r772577952@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2] nilfs2: force clear dirty state when restoring from the shadow map
Date: Wed,  2 Sep 2026 19:21:21 +0800
Message-ID: <20260902112121.2125383-1-r772577952@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When garbage collection fails, nilfs2 rolls the DAT metadata file's page
cache back to a shadow copy taken before GC started.
nilfs_clear_dirty_pages() drops the dirty state of the folios in the DAT
cache, then nilfs_copy_back_pages() overwrites them with the saved
contents and warns if one is still dirty:

	/* overwrite existing folio in the destination cache */
	WARN_ON(folio_test_dirty(dfolio));

nilfs_clear_dirty_pages() used to clear the dirty state unconditionally,
which is safe here because the rollback runs with the log writer
stopped, so nothing else can dirty the cache while it runs.  The same
helper is also used when writeback finds dirty folios after the
filesystem has degraded to read-only, where it does run concurrently
with the log writer, so commit ca76bb226bf4 ("nilfs2: do not force clear
folio if buffer is referenced") made nilfs_clear_folio_dirty() skip a
folio if any of its buffer heads is busy.  The rollback caller shares
that helper, so its clearing step can now return with a folio still
dirty.

A DAT folio can hold a busy buffer head without anyone modifying the
folio: nilfs_mdt_read_block() submits read-ahead for the blocks
following the one it was asked for and waits only for the first, so the
read-ahead buffers are still locked when it returns.  With a block size
smaller than the page size, a locked read-ahead buffer can share a folio
with a block that GC dirtied and keep the whole folio dirty past the
clearing step.

Add a force flag to nilfs_clear_dirty_pages() and
nilfs_clear_folio_dirty() that skips the busy buffer check, and set it
in the two calls from nilfs_mdt_restore_from_shadow_map().  The
read-only fallback callers keep passing false, so that commit still
protects them and the WARN_ON() is left alone.

Fixes: ca76bb226bf4 ("nilfs2: do not force clear folio if buffer is referenced")
Closes: https://lore.kernel.org/lkml/CANypQFZSYrtcshnUzOPiqatyLd-M8_OReOewQoAi_V5yY0dTtg@mail.gmail.com/
Cc: stable@vger.kernel.org
Suggested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Assisted-by: Claude Code:claude-opus-5
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
---
Changes in v2:
- Keep the WARN_ON() in nilfs_copy_back_pages() untouched.
- Add a bool force argument to nilfs_clear_dirty_pages() and
  nilfs_clear_folio_dirty(), and set it to true in the two calls from
  nilfs_mdt_restore_from_shadow_map().

v1: https://lore.kernel.org/lkml/20260901134430.1292467-1-r772577952@gmail.com/

 fs/nilfs2/inode.c |  2 +-
 fs/nilfs2/mdt.c   |  6 +++---
 fs/nilfs2/page.c  | 50 +++++++++++++++++++++++++++--------------------
 fs/nilfs2/page.h  |  4 ++--
 4 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 34e6096069ad..64437aed8390 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -163,7 +163,7 @@ static int nilfs_writepages(struct address_space *mapping,
 	int err = 0;
 
 	if (sb_rdonly(inode->i_sb)) {
-		nilfs_clear_dirty_pages(mapping);
+		nilfs_clear_dirty_pages(mapping, false);
 		return -EROFS;
 	}
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 2a435349fd21..b50c88b65183 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -405,7 +405,7 @@ static int nilfs_mdt_write_folio(struct folio *folio,
 		 * have dirty folios that try to be flushed in background.
 		 * So, here we simply discard this dirty folio.
 		 */
-		nilfs_clear_folio_dirty(folio);
+		nilfs_clear_folio_dirty(folio, false);
 		folio_unlock(folio);
 		return -EROFS;
 	}
@@ -648,10 +648,10 @@ void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
 	if (mi->mi_palloc_cache)
 		nilfs_palloc_clear_cache(inode);
 
-	nilfs_clear_dirty_pages(inode->i_mapping);
+	nilfs_clear_dirty_pages(inode->i_mapping, true);
 	nilfs_copy_back_pages(inode->i_mapping, shadow->inode->i_mapping);
 
-	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping);
+	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true);
 	nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
 			      NILFS_I(shadow->inode)->i_assoc_inode->i_mapping);
 
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index cf4f1c6798f5..857926da9f21 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -369,8 +369,9 @@ void nilfs_copy_back_pages(struct address_space *dmap,
 /**
  * nilfs_clear_dirty_pages - discard dirty pages in address space
  * @mapping: address space with dirty pages for discarding
+ * @force: whether to clear the dirty state regardless of busy buffer heads
  */
-void nilfs_clear_dirty_pages(struct address_space *mapping)
+void nilfs_clear_dirty_pages(struct address_space *mapping, bool force)
 {
 	struct folio_batch fbatch;
 	unsigned int i;
@@ -391,7 +392,7 @@ void nilfs_clear_dirty_pages(struct address_space *mapping)
 			 * was acquired.  Skip processing in that case.
 			 */
 			if (likely(folio->mapping == mapping))
-				nilfs_clear_folio_dirty(folio);
+				nilfs_clear_folio_dirty(folio, force);
 
 			folio_unlock(folio);
 		}
@@ -403,13 +404,16 @@ void nilfs_clear_dirty_pages(struct address_space *mapping)
 /**
  * nilfs_clear_folio_dirty - discard dirty folio
  * @folio: dirty folio that will be discarded
+ * @force: whether to clear the states regardless of busy buffer heads
  *
  * nilfs_clear_folio_dirty() clears working states including dirty state for
- * the folio and its buffers.  If the folio has buffers, clear only if it is
- * confirmed that none of the buffer heads are busy (none have valid
- * references and none are locked).
+ * the folio and its buffers.  If the folio has buffers and force is false,
+ * clear only if it is confirmed that none of the buffer heads are busy (none
+ * have valid references and none are locked).  If force is true, the states
+ * are cleared unconditionally, the caller should guarantee that the folio is
+ * not being modified concurrently.
  */
-void nilfs_clear_folio_dirty(struct folio *folio)
+void nilfs_clear_folio_dirty(struct folio *folio, bool force)
 {
 	struct buffer_head *bh, *head;
 
@@ -422,24 +426,28 @@ void nilfs_clear_folio_dirty(struct folio *folio)
 			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
 			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
 			 BIT(BH_Delay));
-		bool busy, invalidated = false;
+
+		if (!force) {
+			bool busy, invalidated = false;
 
 recheck_buffers:
-		busy = false;
-		bh = head;
-		do {
-			if (atomic_read(&bh->b_count) | buffer_locked(bh)) {
-				busy = true;
-				break;
+			busy = false;
+			bh = head;
+			do {
+				if (atomic_read(&bh->b_count) |
+				    buffer_locked(bh)) {
+					busy = true;
+					break;
+				}
+			} while (bh = bh->b_this_page, bh != head);
+
+			if (busy) {
+				if (invalidated)
+					return;
+				invalidate_bh_lrus();
+				invalidated = true;
+				goto recheck_buffers;
 			}
-		} while (bh = bh->b_this_page, bh != head);
-
-		if (busy) {
-			if (invalidated)
-				return;
-			invalidate_bh_lrus();
-			invalidated = true;
-			goto recheck_buffers;
 		}
 
 		bh = head;
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 136cd1c143c9..c3ba3468af5c 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -41,8 +41,8 @@ void nilfs_folio_bug(struct folio *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
-void nilfs_clear_folio_dirty(struct folio *folio);
-void nilfs_clear_dirty_pages(struct address_space *mapping);
+void nilfs_clear_folio_dirty(struct folio *folio, bool force);
+void nilfs_clear_dirty_pages(struct address_space *mapping, bool force);
 unsigned int nilfs_page_count_clean_buffers(struct folio *folio,
 		unsigned int from, unsigned int to);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
-- 
2.43.0

