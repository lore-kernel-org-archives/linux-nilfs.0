Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B894F883;
	Fri, 16 Aug 2024 09:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798909; cv=none; b=UuIU37343wmWzxuWpe92LKAqy2UfNwF/pbtJy0ujqeA/cE+QNCUtKEd1u+favvoAToLtExRJWyb8ask9y02Dc2KTAhAheI8VJPrtAZTMhts6Tkr56sEedDCnSNy8efd8rjkMbxufihYvYGC5cl/cWYTaCFui4iOccml/IjaPgiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798909; c=relaxed/simple;
	bh=W3tlIos9wm9zluB5RC6mOx5GY+1+/oLRlai18pKgSOs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=C0Ejp+N1uJAlclNvUStBg+Oge+zVDLU9dVtQmeO81fH3qx4Yq1qlr4FPR1/CTY6ABxJvWBcPMV31+QLgZBDH7ZsyowMgApl07E4j+E9DoobZ4w4EPSAhZ6grKBV3vFxa7+94KJkToQheS8HC35UncjF09DQotK028usC6qIMjek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QgWdo6NO; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QgWdo6NO"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1fdd6d81812so18440175ad.1;
        Fri, 16 Aug 2024 02:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723798907; x=1724403707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P1HmecyUvtp06bV4nFVvKeXY3H6FSUCPmIpY5aV1k+s=;
        b=QgWdo6NO7GxqE7v7lKBQ+8qhE5U5tuCWiClONcDgkh6lm5ZbMzX9TOCLCiRVB8Tgrn
         tbN1DN8Af69CYFdnNSZkHULVB2sUaAOX4VHQ+IFLIB+aV+svY/aWgYw6b7QXPcX3IJs6
         yGIeQ/MYJJsXcwTp0IzjnoHYPtkTNAXQ2kfRXIRGO9FXRJi5mJN1u77zVpZNgxkamgiX
         DlaERHvnR/M6NAW+Zc3cprcUJewcXKHPUzNLgSYZckCtknrhfPw4+iQWFLXLullc1Lno
         lLcjSJ+hNC1yduIgw9eYbRb1T5Hy02ZDBzrHch/9IFhcB9SRQAUlk6ykon2mmQ4xtlJf
         vLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723798907; x=1724403707;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P1HmecyUvtp06bV4nFVvKeXY3H6FSUCPmIpY5aV1k+s=;
        b=MJI+ScL+RUBLOPBWovTUrFedyDOIlmwQglQXAPY4OQ4To0rNsQkhXlW+RokE2VyrPx
         owIRRySP93Oz/AbOrfqQjrR7KwVL03k6wTo5VYPAGz2JAnRXFWzp2CelICKWF/cj2mrQ
         UVaJYNr5gcQQadhZpEMvEUU6Qg60CY7gRJtq1o9Bqwdz3lP041hSezTJ0GHpl6mEhtL8
         JOYWneV669ow8JLTjSA/AEbew5NTo0hfWVdSwgqZ2wRS3kJcb83F91etEu1gVrmR00SS
         RC2AC1kXr4eleJ3jM7MEgIsVhM0I1USEP1/0wON+A56TkX7wk26/4OvHX/gPRP2mkRWn
         vpbQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2LhnjDtlfeMcA19sWCCdDzw+osmYbz+YcBDm+qv8c+lpcTM1AYPqqqi+WJckc1AHggINij+ZmNz53hS6TMwpzfW63j97jrBqFAp1U
X-Gm-Message-State: AOJu0YxXW+8FV/+/VGHZi/9/YH8/+zb+kPSMiSs3fo6fXXsi7TRwPqvq
	6TrlDoeLCcRZ6OjzcENv5R5xef5ZBryIK1/Gie/ZbxUS/AD6H7wryEVPxg==
X-Google-Smtp-Source: AGHT+IG1zCZyt8nAkJxQ7ghwjwiyGU4t6ixokK+TeaG4B8/XEyf61YKiRdKCJMLpKVRg20dEQbcxrg==
X-Received: by 2002:a17:902:f544:b0:1f9:d0da:5b2f with SMTP id d9443c01a7336-20203ed8c92mr27194715ad.39.1723798906974;
        Fri, 16 Aug 2024 02:01:46 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f02fb470sm21790195ad.9.2024.08.16.02.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 02:01:46 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: do not output warnings when clearing dirty buffers
Date: Fri, 16 Aug 2024 18:01:28 +0900
Message-Id: <20240816090128.4561-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After detecting file system corruption and degrading to a read-only
mount, dirty folios and buffers in the page cache are cleared, and a
large number of warnings are output at that time, often filling up
the kernel log.

In this case, since the degrading to a read-only mount is output to
the kernel log, these warnings are not very meaningful, and are
rather a nuisance in system management and debugging.

The related nilfs2-specific page/folio routines have a silent argument
that suppresses the warning output, but since it is not currently used
meaningfully, remove both the silent argument and the warning output.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Andrew, please add this to the queue for the next cycle.

This prevents the kernel log from being filled with counterproductive
messages warning about dirty buffers being cleared when a file system
corruption is detected.

Thanks,
Ryusuke Konishi

 fs/nilfs2/inode.c |  4 ++--
 fs/nilfs2/mdt.c   |  6 +++---
 fs/nilfs2/page.c  | 19 +++----------------
 fs/nilfs2/page.h  |  4 ++--
 4 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7340a01d80e1..c39bc940e6f2 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -162,7 +162,7 @@ static int nilfs_writepages(struct address_space *mapping,
 	int err = 0;
 
 	if (sb_rdonly(inode->i_sb)) {
-		nilfs_clear_dirty_pages(mapping, false);
+		nilfs_clear_dirty_pages(mapping);
 		return -EROFS;
 	}
 
@@ -186,7 +186,7 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
 		 * have dirty pages that try to be flushed in background.
 		 * So, here we simply discard this dirty page.
 		 */
-		nilfs_clear_folio_dirty(folio, false);
+		nilfs_clear_folio_dirty(folio);
 		folio_unlock(folio);
 		return -EROFS;
 	}
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 4f792a0ad0f0..ceb7dc0b5bad 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -411,7 +411,7 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 		 * have dirty folios that try to be flushed in background.
 		 * So, here we simply discard this dirty folio.
 		 */
-		nilfs_clear_folio_dirty(folio, false);
+		nilfs_clear_folio_dirty(folio);
 		folio_unlock(folio);
 		return -EROFS;
 	}
@@ -638,10 +638,10 @@ void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
 	if (mi->mi_palloc_cache)
 		nilfs_palloc_clear_cache(inode);
 
-	nilfs_clear_dirty_pages(inode->i_mapping, true);
+	nilfs_clear_dirty_pages(inode->i_mapping);
 	nilfs_copy_back_pages(inode->i_mapping, shadow->inode->i_mapping);
 
-	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true);
+	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping);
 	nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
 			      NILFS_I(shadow->inode)->i_assoc_inode->i_mapping);
 
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 14e470fb8870..7797903e014e 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -357,9 +357,8 @@ void nilfs_copy_back_pages(struct address_space *dmap,
 /**
  * nilfs_clear_dirty_pages - discard dirty pages in address space
  * @mapping: address space with dirty pages for discarding
- * @silent: suppress [true] or print [false] warning messages
  */
-void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
+void nilfs_clear_dirty_pages(struct address_space *mapping)
 {
 	struct folio_batch fbatch;
 	unsigned int i;
@@ -380,7 +379,7 @@ void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
 			 * was acquired.  Skip processing in that case.
 			 */
 			if (likely(folio->mapping == mapping))
-				nilfs_clear_folio_dirty(folio, silent);
+				nilfs_clear_folio_dirty(folio);
 
 			folio_unlock(folio);
 		}
@@ -392,20 +391,13 @@ void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
 /**
  * nilfs_clear_folio_dirty - discard dirty folio
  * @folio: dirty folio that will be discarded
- * @silent: suppress [true] or print [false] warning messages
  */
-void nilfs_clear_folio_dirty(struct folio *folio, bool silent)
+void nilfs_clear_folio_dirty(struct folio *folio)
 {
-	struct inode *inode = folio->mapping->host;
-	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bh, *head;
 
 	BUG_ON(!folio_test_locked(folio));
 
-	if (!silent)
-		nilfs_warn(sb, "discard dirty page: offset=%lld, ino=%lu",
-			   folio_pos(folio), inode->i_ino);
-
 	folio_clear_uptodate(folio);
 	folio_clear_mappedtodisk(folio);
 
@@ -419,11 +411,6 @@ void nilfs_clear_folio_dirty(struct folio *folio, bool silent)
 		bh = head;
 		do {
 			lock_buffer(bh);
-			if (!silent)
-				nilfs_warn(sb,
-					   "discard dirty block: blocknr=%llu, size=%zu",
-					   (u64)bh->b_blocknr, bh->b_size);
-
 			set_mask_bits(&bh->b_state, clear_bits, 0);
 			unlock_buffer(bh);
 		} while (bh = bh->b_this_page, bh != head);
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 7e1a2c455a10..64521a03a19e 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -41,8 +41,8 @@ void nilfs_folio_bug(struct folio *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
-void nilfs_clear_folio_dirty(struct folio *, bool);
-void nilfs_clear_dirty_pages(struct address_space *, bool);
+void nilfs_clear_folio_dirty(struct folio *folio);
+void nilfs_clear_dirty_pages(struct address_space *mapping);
 unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
 					    unsigned int);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
-- 
2.34.1

