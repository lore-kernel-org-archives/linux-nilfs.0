From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/7] nilfs2: do not use async write flag for segment summary buffers
Date: Thu, 12 Mar 2015 23:38:08 +0900
Message-ID: <1426171094-27414-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1426171094-27414-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=40YEa+GHgqUpGA4wdbDuLqm0uIHe2Qqf3sOZ3sBOlH0=;
        b=ySLZ+N8+etnqnjfMsG5Coo4Z30eo/E2DneAi1NpPzm6PWo+SrVKD4+E/vmxvkhYcE5
         uOL6NsRL4Y3euQqaA27x4ybJPbZxJGWPzd4T549sQiTb6Ur3KKRu88vd5d73JodPt0rP
         NXltF4JelGnMz0E+/p1iy4pMYXDoH83MCKzYYBlSb+VdFRSBXKOMonAM7ovVfOufw1/q
         sij3dTybTS3uwgWbrWeNHdhkX/hPPmpaWzKk87wuvCCnavXsGh5qFmeF/4DEr6A3PUJ+
         7dJBUwOlOXZwvFjh/6z14HpDctjPOKh6g/5+OuFfG4SQz/yuVNo+aX/2E9sqzbpEp7Lt
         xhgA==
In-Reply-To: <1426171094-27414-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Vyacheslav Dubeyko <slava@dubeyko.com>

The async write flag is introduced to nilfs2 in the commit
7f42ec394156 ("nilfs2: fix issue with race condition of competition
between segments for dirty blocks"), but the flag only makes sense for
data buffers and btree node buffers.  It is not needed for segment
summary buffers.

This gits rid of the latter uses as part of refactoring of atomic bit
operations on buffer state bitmap.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
---
 fs/nilfs2/segment.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 0c3f303..c9a4e60 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1588,7 +1588,6 @@ static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
 
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
-			set_buffer_async_write(bh);
 			if (bh->b_page != bd_page) {
 				if (bd_page) {
 					lock_page(bd_page);
@@ -1688,7 +1687,6 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
-			clear_buffer_async_write(bh);
 			if (bh->b_page != bd_page) {
 				if (bd_page)
 					end_page_writeback(bd_page);
@@ -1768,7 +1766,6 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 				    b_assoc_buffers) {
 			set_buffer_uptodate(bh);
 			clear_buffer_dirty(bh);
-			clear_buffer_async_write(bh);
 			if (bh->b_page != bd_page) {
 				if (bd_page)
 					end_page_writeback(bd_page);
-- 
1.8.3.1
