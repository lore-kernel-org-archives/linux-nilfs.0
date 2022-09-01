From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 19/23] nilfs2: Convert
 nilfs_lookup_dirty_node_buffers() to use filemap_get_folios_tag()
Date: Thu,  1 Sep 2022 15:01:34 -0700
Message-ID: <20220901220138.182896-20-vishal.moola@gmail.com>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
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
 bh=R1s+Q+mQAi/BIrt6gOgtRlGYE9v+cGNlC5URnwM67nk=; b=jQPzOYtW9NW3ysvyLUPXDjmV3M
 LMZqWDJzWZIx25rwV4diwBhql/WrCLDRtPvZhlOH03Zqfepmp5L5jLZKz6LKUckaE0Mdo2T2Atr9+
 0gxek2Dp55paIjrEWS0559qderikpSO137MbiC5PsUy1vBiuYb6BTxCh83ZGH87D0wSw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=R1s+Q+mQAi/BIrt6gOgtRlGYE9v+cGNlC5URnwM67nk=; b=R8ttgPS2HmIzYM4P9i/n+W/PvR
 ZnSk2WK7uLlDqQJC6DCdKbfLBdexx+tBrf32xJJczTXEYK+3rzeGQ5K9+xn9uRAtNxN6i44yFih2w
 1Nna/cTnGiHUaBKrgYET7RYHe2Uf37L2/ibf3Q+kqDYfYNCFnbj0OOvARUpb8do1kohs=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
 bh=R1s+Q+mQAi/BIrt6gOgtRlGYE9v+cGNlC5URnwM67nk=;
 b=g6fAyp3iJgf3LzmTu5bD5zWTZ7od9i2yk9cu47djS4LzM5/vaCauETEa79FJPDbfwN
 cLdqlUh9d8nI0Nm+LbuAhIItiLNmHGfoqlGAYhSfTiRw4ljsDmSdVadB+3m2xO1TNUJa
 0nuVGnoNqQQoLmodKszRhMXSnkLvvjZ4R3brnkvtlDRm/qXRnT+DMRacWFesHhTBBNKc
 0V+89RIxZ0WLehbpnGAbTdJ5uOSPOqVqMofTzLN0E95dgYKuDPhCGssRW2KFzlTQQNsi
 D66yCF12E7iDcZecg+ujt+pmVYyoJIOMaXlKUD3A3/5c5nIgJRrzLjZgJB8I6DmUxegn
 s9WQ==
In-Reply-To: <20220901220138.182896-1-vishal.moola@gmail.com>
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

Convert function to use folios throughout. This is in preparation for
the removal of find_get_pages_range_tag().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/nilfs2/segment.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index e95c667bdc8f..d386d913e349 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -737,20 +737,19 @@ static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	struct inode *btnc_inode = ii->i_assoc_inode;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	struct buffer_head *bh, *head;
 	unsigned int i;
 	pgoff_t index = 0;
 
 	if (!btnc_inode)
 		return;
+	folio_batch_init(&fbatch);
 
-	pagevec_init(&pvec);
-
-	while (pagevec_lookup_tag(&pvec, btnc_inode->i_mapping, &index,
-					PAGECACHE_TAG_DIRTY)) {
-		for (i = 0; i < pagevec_count(&pvec); i++) {
-			bh = head = page_buffers(pvec.pages[i]);
+	while (filemap_get_folios_tag(btnc_inode->i_mapping, &index,
+				(pgoff_t)-1, PAGECACHE_TAG_DIRTY, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); i++) {
+			bh = head = folio_buffers(fbatch.folios[i]);
 			do {
 				if (buffer_dirty(bh) &&
 						!buffer_async_write(bh)) {
@@ -761,7 +760,7 @@ static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
 				bh = bh->b_this_page;
 			} while (bh != head);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 }
-- 
2.36.1
