Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679C61F5433;
	Tue,  7 Jan 2025 20:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736280135; cv=none; b=p6zbkqQjuqrrtd8KkS1JWHhinlW2MJ5uWHYbe0BL3oJ9kCWhpsWzv0b1b2R5Jow6PlcB0DNBDT1SVP9GgHqmI+HD3mEaDHEVUHgazcfHXWcQiG+F0xHnbZGS6eqfMqJr823ZV417xFG/JKQMsQnwjUzpMSeyrcekJQC1+Lt5Q3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736280135; c=relaxed/simple;
	bh=0/AC4KAWbs6EKP/LQK5/9nMu4KDtHUmB3rMLV9WgyKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBoIQfRIbdKDECkxP9XdMUrNkrwpEu+OtzmQu56fA/oRjPljhPPXMlXM3OZMoRI6+gNFqxCNaP2SB5KMjUgyqd5Nb5VO+ZIDrWtupUw0aFYBh5Hw7i1ufWDRwRQRcA4leqg3FuYehbqyw0tt7VAIarWg9DTsp4dSOely99KDIPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DpZGi9Re; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DpZGi9Re"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2166360285dso239132775ad.1;
        Tue, 07 Jan 2025 12:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736280132; x=1736884932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cC83R6uMLVJsRRAAkUolhak8PtJS4lsRTBAQjUWw2YU=;
        b=DpZGi9RebUXXUd0brloY9SrgYhkyRej1xM+f7a9Y+xwjunCa1mNDX4NbvR6g0Y4uWp
         B7xiSTLC98hM9/UzuC2fU4z9lbjZzZKoN89R+gNhvQXR0sG++PcbV4gatmBGj7YrkFD5
         xoukKqKETNv7OjbC/mnceMYkMBoWWX7566G5MJy/qNYTklqqWMJVocapw370pLVcyljz
         fVymAAZ1vuKFzRriHKMORb7X1Bi3NluVaAAhYSEOn61WDLhI2ps1DHflwkUHUTpbpkOV
         ZB53wVxJVkf6SY2syc3sCAcwi/FPtosBIHrMIUeZYQvLZ41c4KwUw6A7RFvvMREX1Qsk
         RcgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736280132; x=1736884932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cC83R6uMLVJsRRAAkUolhak8PtJS4lsRTBAQjUWw2YU=;
        b=Sl+9Qavrsxpe1W1T/FdUOsCOUu+bYKqpd9ZCcX9c1voX8v8ydh72tlSIJH2Idy2VqU
         RMV+WPjJL5IRs5P2EqscZQlQCFL11oC7GS/sytFAX5jo4oZTSD6TRucZDdLCPQMzym3f
         1EG8P38HwOjfL5PwaNSOb5ZEpxfL+Ssj2b27XkjnMATTWIZysgT1G7d0veFpoOnPHP7C
         s5qVPdMFWPnLM+faW+LPAZ1XqsGoygudgT8OEa9s2+3dFj1HCXws2/bHPs3J5a10QZMZ
         XcjVNp/pfLUPId3q5BgRK42f7cuc0JebVZijKNmJejFrrfLyDkIVnw7+qmiWvSvkIvyB
         ztGg==
X-Forwarded-Encrypted: i=1; AJvYcCVswkd4MVzup+TYIy2OhSr/XD2NuDBmQ8rmITeivo7AnvNY22CGhe0/X0XchS5YMfx5nwF+0udMzXQX7ZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHQxddXPQCXHaKICaUM1WQJDR/5y8rncZlqQGU/riJtCsXnwOm
	SqcPqkF6vRT2og5l3ZWhWJ7+UnTECAc0dSz1GzmNLJ142CvymWHz
X-Gm-Gg: ASbGncvAIk7nOLV5eqHZbSR70MZzGsXol1oF6WyhcTwTbUQj013WL7hYZz2DFKUGCuL
	LAX3XG9YJWfCyTb5t6NTuCAut97ug/yYH0AfDrSru6Ad8ALeouNxy5EhO3O70eSD+rvWhUO/Oao
	YDs7TmNAPDS5bB9YTPTjRogZI6P4rX1d0rBJDKip2wAllVT94yKJBNCwaF+aLbXMgjfG5QKLSxu
	v3HBkgC3ZuRiKkIA+wq+mspABpSFlW3LP6juS/i85uIW9gLVBWs34R6LxEJ1thTGDdseiXMPImL
	wqwWiZov44BM4W22ZdViZRSNTNGp
X-Google-Smtp-Source: AGHT+IELplfseAwUcpMERVFLXxH2RDjsCQSFmoJPprr8u0cI70v/CccO3rW+PPYkx3Rb6q2fN55/fg==
X-Received: by 2002:a17:903:230d:b0:215:cbbf:8926 with SMTP id d9443c01a7336-21a83fb0da4mr5174305ad.35.1736280131494;
        Tue, 07 Jan 2025 12:02:11 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dca02b3fsm314332365ad.244.2025.01.07.12.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 12:02:10 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com,
	syzbot+d98fd19acd08b36ff422@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] nilfs2: do not force clear folio if buffer is referenced
Date: Wed,  8 Jan 2025 05:00:46 +0900
Message-ID: <20250107200202.6432-2-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250107200202.6432-1-konishi.ryusuke@gmail.com>
References: <670ea678.050a0220.d5849.000b.GAE@google.com>
 <20250107200202.6432-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot has reported that after nilfs2 detects filesystem corruption and
falls back to read-only, inconsistencies in the buffer state may occur.

One of the inconsistencies is that when nilfs2 calls mark_buffer_dirty()
to set a data or metadata buffer as dirty, but it detects that the buffer
is not in the uptodate state:

 WARNING: CPU: 0 PID: 6049 at fs/buffer.c:1177 mark_buffer_dirty+0x2e5/0x520
  fs/buffer.c:1177
 ...
 Call Trace:
  <TASK>
  nilfs_palloc_commit_alloc_entry+0x4b/0x160 fs/nilfs2/alloc.c:598
  nilfs_ifile_create_inode+0x1dd/0x3a0 fs/nilfs2/ifile.c:73
  nilfs_new_inode+0x254/0x830 fs/nilfs2/inode.c:344
  nilfs_mkdir+0x10d/0x340 fs/nilfs2/namei.c:218
  vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4257
  do_mkdirat+0x264/0x3a0 fs/namei.c:4280
  __do_sys_mkdirat fs/namei.c:4295 [inline]
  __se_sys_mkdirat fs/namei.c:4293 [inline]
  __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4293
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

The other is when nilfs_btree_propagate(), which propagates the dirty
state to the ancestor nodes of a b-tree that point to a dirty buffer,
detects that the origin buffer is not dirty, even though it should be:

 WARNING: CPU: 0 PID: 5245 at fs/nilfs2/btree.c:2089
  nilfs_btree_propagate+0xc79/0xdf0 fs/nilfs2/btree.c:2089
 ...
 Call Trace:
  <TASK>
  nilfs_bmap_propagate+0x75/0x120 fs/nilfs2/bmap.c:345
  nilfs_collect_file_data+0x4d/0xd0 fs/nilfs2/segment.c:587
  nilfs_segctor_apply_buffers+0x184/0x340 fs/nilfs2/segment.c:1006
  nilfs_segctor_scan_file+0x28c/0xa50 fs/nilfs2/segment.c:1045
  nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1216 [inline]
  nilfs_segctor_collect fs/nilfs2/segment.c:1540 [inline]
  nilfs_segctor_do_construct+0x1c28/0x6b90 fs/nilfs2/segment.c:2115
  nilfs_segctor_construct+0x181/0x6b0 fs/nilfs2/segment.c:2479
  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2587 [inline]
  nilfs_segctor_thread+0x69e/0xe80 fs/nilfs2/segment.c:2701
  kthread+0x2f0/0x390 kernel/kthread.c:389
  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
  </TASK>

Both of these issues are caused by the callbacks that handle the
page/folio write requests, forcibly clear various states, including the
working state of the buffers they hold, at unexpected times when they
detect read-only fallback.

Fix these issues by checking if the buffer is referenced before clearing
the page/folio state, and skipping the clear if it is.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b2b14916b77acf8626d7
Reported-by: syzbot+d98fd19acd08b36ff422@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=d98fd19acd08b36ff422
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Tested-by: syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com
---
 fs/nilfs2/page.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 9de2a494a069..899686d2e5f7 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -392,6 +392,11 @@ void nilfs_clear_dirty_pages(struct address_space *mapping)
 /**
  * nilfs_clear_folio_dirty - discard dirty folio
  * @folio: dirty folio that will be discarded
+ *
+ * nilfs_clear_folio_dirty() clears working states including dirty state for
+ * the folio and its buffers.  If the folio has buffers, clear only if it is
+ * confirmed that none of the buffer heads are busy (none have valid
+ * references and none are locked).
  */
 void nilfs_clear_folio_dirty(struct folio *folio)
 {
@@ -399,10 +404,6 @@ void nilfs_clear_folio_dirty(struct folio *folio)
 
 	BUG_ON(!folio_test_locked(folio));
 
-	folio_clear_uptodate(folio);
-	folio_clear_mappedtodisk(folio);
-	folio_clear_checked(folio);
-
 	head = folio_buffers(folio);
 	if (head) {
 		const unsigned long clear_bits =
@@ -410,6 +411,25 @@ void nilfs_clear_folio_dirty(struct folio *folio)
 			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
 			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
 			 BIT(BH_Delay));
+		bool busy, invalidated = false;
+
+recheck_buffers:
+		busy = false;
+		bh = head;
+		do {
+			if (atomic_read(&bh->b_count) | buffer_locked(bh)) {
+				busy = true;
+				break;
+			}
+		} while (bh = bh->b_this_page, bh != head);
+
+		if (busy) {
+			if (invalidated)
+				return;
+			invalidate_bh_lrus();
+			invalidated = true;
+			goto recheck_buffers;
+		}
 
 		bh = head;
 		do {
@@ -419,6 +439,9 @@ void nilfs_clear_folio_dirty(struct folio *folio)
 		} while (bh = bh->b_this_page, bh != head);
 	}
 
+	folio_clear_uptodate(folio);
+	folio_clear_mappedtodisk(folio);
+	folio_clear_checked(folio);
 	__nilfs_clear_folio_dirty(folio);
 }
 
-- 
2.43.0

