Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD49C4332F
	for <linux-nilfs@archiver.kernel.org>; Mon,  6 Nov 2023 17:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbjKFRja (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbjKFRjT (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Mon, 6 Nov 2023 12:39:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEB210DC;
        Mon,  6 Nov 2023 09:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=jrbR4iWef8sIb7H7v7Cy30neHladJbirl+6/uy/A9Ow=; b=ahoFAoTZiwERrrFy9c1GghN93M
        7dqmDZYbQ/9AN6DKc86CFLLdjTHIrJpKN5tUFumDpmZKJw42TTPc6nKLU/dhi6zydIH9Dx4f1OEwm
        4p1A30kpDEnLYvphynbKhNdO1adrPSx6NM9YJ0772VC3jjcwXqceD5VxnzV76meCYJOIn4Bq/7ho2
        nqud352xFQE3UzOY8vxnZju7IGpqTWGT+vN0QuT7Q9Xn5CsGzZVZTyZ3fyE5zleGCCdkyDhGPFppY
        K7d1r8JrGiLG9mSjirPmchz7QCiVTnxGn8VUSz5nC0nMJlC853m9z8+q9INQXGWDQNldYdcUUtY0N
        TD3G51Gw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1r03Z6-007HAA-Kx; Mon, 06 Nov 2023 17:39:08 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 22/35] nilfs2: Remove page_address() from nilfs_add_link
Date:   Mon,  6 Nov 2023 17:38:50 +0000
Message-Id: <20231106173903.1734114-23-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20231106173903.1734114-1-willy@infradead.org>
References: <20231106173903.1734114-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

In preparation for removing kmap from directory handling, use
offset_in_page() to calculate 'from'.  Matches ext2.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nilfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 683101dcbddf..0cf4fe91aebe 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -501,7 +501,7 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 	return -EINVAL;
 
 got_it:
-	from = (char *)de - (char *)page_address(page);
+	from = offset_in_page(de);
 	to = from + rec_len;
 	err = nilfs_prepare_chunk(page, from, to);
 	if (err)
-- 
2.42.0

