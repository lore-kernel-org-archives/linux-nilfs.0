Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51566C4167B
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjKFRjX (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjKFRjS (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752F210C0;
        Mon,  6 Nov 2023 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=lcP/X+IVyIzLgY2RgPKpJTs8qG8I+p0Nsdznb+secT8=; b=RRy5QkyLXnOcDrk8+cFZgrv7km
        Hla+nCSKaWKGkoe8X0q222AMqTCxNyaDwc9BwrHlqs9Aw5fkAXlMfM5wCeTuJ6DiFPSyabf0GPm7u
        tO8sKPoPM8uK+3hGe0H4VvLt1SW7KHXIQNgfAYodel60AeEaPVPWN/0SH875im9YP0s48V/aUmB3N
        0nxHzdBEuUs5B09sM5UQ5SfDeBm6vt9KNrGj6qd9nj/TPCne+t7WUCWZCBHZ+IuEL+pEkeWQVCTUP
        8VjxKtV246QF944+BDXxf4iqLBzsgmAKKw7nVv+N/E4qSOpKZov4YMv+HFu1iXmC0wucIRSdsFSJn
        zXrvE8ew==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z5-007H8y-Bu; Mon, 06 Nov 2023 17:39:07 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 13/35] nilfs2: Convert nilfs_mdt_submit_block to use a folio
Date:   Mon,  6 Nov 2023 17:38:41 +0000
Message-Id: <20231106173903.1734114-14-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

Saves two calls to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/mdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 7e4dcff2c94b..e45c01a559c0 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -158,8 +158,8 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff, blk_opf_t opf,
 	*out_bh = bh;
 
  failed_bh:
-	unlock_page(bh->b_page);
-	put_page(bh->b_page);
+	folio_unlock(bh->b_folio);
+	folio_put(bh->b_folio);
 	brelse(bh);
  failed:
 	return ret;
-- 
2.42.0

