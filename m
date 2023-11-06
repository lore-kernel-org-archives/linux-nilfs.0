Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739A9C4167B
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbjKFRjV (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbjKFRjS (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7A8D57;
        Mon,  6 Nov 2023 09:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ocUPXujLAlIdfiGe9skNuAQj9DW5J6k/r+nk9Zo0FWQ=; b=HABhC2rSzMOLkkw9pGspvYdoRZ
        sFaljPC8YAMtd0p9c37q7CbQUayVDDv9Bj7HQlrAxgbXumGh+s6ON+beKGuMjHAr0Lo5Z8lsyrLUm
        /Kzhd501C0jun9Gmzzil0+vNf9WEzoIa/ZsFhV1Jddsm3/pMNePAsTg5SjJQYB4rIbDqEjIokv9Kk
        7+PCqCGOnzYQIN1n3OnLkzmkcOAULqBDKhQzBX6/F1kFbh5cW80PyCquot7/SVeveYRxholKYO+yL
        RtpDY3ixygNcuZOLqvVCsxkRL03njGqBXO40Ncuu32/Ba0ewK9RYPHI/uYtRHGIp/5HrrF854oEqW
        8CScSuEA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z3-007H7v-V7; Mon, 06 Nov 2023 17:39:06 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 02/35] nilfs2: Convert nilfs_abort_logs to use folios
Date:   Mon,  6 Nov 2023 17:38:30 +0000
Message-Id: <20231106173903.1734114-3-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Use the new folio APIs, saving five hidden calls to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/segment.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 1df03d0895be..730062e79bfc 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1788,7 +1788,7 @@ static void nilfs_end_page_io(struct page *page, int err)
 static void nilfs_abort_logs(struct list_head *logs, int err)
 {
 	struct nilfs_segment_buffer *segbuf;
-	struct page *bd_page = NULL, *fs_page = NULL;
+	struct folio *bd_folio = NULL, *fs_folio = NULL;
 	struct buffer_head *bh;
 
 	if (list_empty(logs))
@@ -1798,10 +1798,10 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
 			clear_buffer_uptodate(bh);
-			if (bh->b_page != bd_page) {
-				if (bd_page)
-					end_page_writeback(bd_page);
-				bd_page = bh->b_page;
+			if (bh->b_folio != bd_folio) {
+				if (bd_folio)
+					folio_end_writeback(bd_folio);
+				bd_folio = bh->b_folio;
 			}
 		}
 
@@ -1810,22 +1810,22 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 			clear_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
 				clear_buffer_uptodate(bh);
-				if (bh->b_page != bd_page) {
-					end_page_writeback(bd_page);
-					bd_page = bh->b_page;
+				if (bh->b_folio != bd_folio) {
+					folio_end_writeback(bd_folio);
+					bd_folio = bh->b_folio;
 				}
 				break;
 			}
-			if (bh->b_page != fs_page) {
-				nilfs_end_page_io(fs_page, err);
-				fs_page = bh->b_page;
+			if (bh->b_folio != fs_folio) {
+				nilfs_end_folio_io(fs_folio, err);
+				fs_folio = bh->b_folio;
 			}
 		}
 	}
-	if (bd_page)
-		end_page_writeback(bd_page);
+	if (bd_folio)
+		folio_end_writeback(bd_folio);
 
-	nilfs_end_page_io(fs_page, err);
+	nilfs_end_folio_io(fs_folio, err);
 }
 
 static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
-- 
2.42.0

