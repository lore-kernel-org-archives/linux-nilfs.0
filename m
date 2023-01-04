From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v5 12/23] f2fs: Convert f2fs_flush_inline_data()
 to use filemap_get_folios_tag()
Date: Wed,  4 Jan 2023 13:14:37 -0800
Message-ID: <20230104211448.4804-13-vishal.moola@gmail.com>
References: <20230104211448.4804-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=5JTMc/Rft/vIyJlvWKFcn8nkQrf+O33NuNawnN6rRgI=; b=mrc3rNaom8CpNBDIvkuAZfEmjS
 3R+xCbn0VyavguCp83siMq2aSNTbJRK0H5PBCze8VQB4Lnjvib9uT5Wfuf2rv++T/0kkG9MDAeRyf
 AJysRcYkEdINcTPh8BHWNrhKEKsoUgV/MB0VTEcivmzhaL4/KPhMmCwfyFnBVcEZRadY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=5JTMc/Rft/vIyJlvWKFcn8nkQrf+O33NuNawnN6rRgI=; b=iq2NznYEWg5EsvHFJPhaZxNonP
 OtEJxQSY7ShN/iSYH3RtXjz9DlWivsA6fBsLCFcOc0bUWUYOArwagxQK/fbQ0RIzl6MwTB/nbOQ/n
 TmU868Aa/MvwBQVSXmXWGK1lFKdGwD2qsexlsivjiC2U5uumitGhIsTYYx4pEngom57o=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=5JTMc/Rft/vIyJlvWKFcn8nkQrf+O33NuNawnN6rRgI=;
 b=nqEuKaTI9dAXbJiKNF6NFVlHonYqdpnzDFZQRbj6c6q33P4q7zmgWoLXJ3cvwJxiFU
 R4EchBW4P9btK5EV2Ivos6RVjg1pCqpX1sdrjygOWSOWvR56x6MAcYlVYqzqYxU9e9pD
 7EqyoRZKmtKUIC4XqucME2BOGZCWoquaRcoAjwG6f440GMABya0GF45MLcEdcWoBQIPQ
 aSrPTzqxY2gV56movVnmY+sLkzpn2sZ/+NfGjAOpD0jKjJOna2t97nyuQoo/S3JNHjEa
 jJZ5wa0Qe7mURn1kHsaymS4r8Y1pr0V1FypBr74zDvcLsepES4cYIoRevgoh6RoBOUZe
 pZpg==
In-Reply-To: <20230104211448.4804-1-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

Convert function to use a folio_batch instead of pagevec. This is in
preparation for the removal of find_get_pages_tag().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Chao Yu <chao@kernel.org>
---
 fs/f2fs/node.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 3e0362794e27..1c5dc7a3207e 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1890,17 +1890,18 @@ static bool flush_dirty_inode(struct page *page)
 void f2fs_flush_inline_data(struct f2fs_sb_info *sbi)
 {
 	pgoff_t index = 0;
-	struct pagevec pvec;
-	int nr_pages;
+	struct folio_batch fbatch;
+	int nr_folios;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
-	while ((nr_pages = pagevec_lookup_tag(&pvec,
-			NODE_MAPPING(sbi), &index, PAGECACHE_TAG_DIRTY))) {
+	while ((nr_folios = filemap_get_folios_tag(NODE_MAPPING(sbi), &index,
+					(pgoff_t)-1, PAGECACHE_TAG_DIRTY,
+					&fbatch))) {
 		int i;
 
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		for (i = 0; i < nr_folios; i++) {
+			struct page *page = &fbatch.folios[i]->page;
 
 			if (!IS_DNODE(page))
 				continue;
@@ -1927,7 +1928,7 @@ void f2fs_flush_inline_data(struct f2fs_sb_info *sbi)
 			}
 			unlock_page(page);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 }
-- 
2.38.1
