From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 5/7] nilfs2: remove unnecessary else after return or break
Date: Tue, 10 May 2016 22:24:29 +0900
Message-ID: <1462886671-3521-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1462886671-3521-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=sCcmLEHOX2hU8PZUNBVKv1cVtZj68cBZN6PtHzPJOSM=;
        b=E2hDNdWPWEV+11z+M3ARArTXGNdzkh1PCavPDeRxBL9DH+Q3Xife2CT3a39pNzxTa6
         mn65+NIxvlUxtmybPir+h7h/xsWCZjYc4tfS52rSmdFZowVDNxyX9d6gNfzBgC9iWpmc
         OfnpLEeM4/ChxEGA70pGe2XaZWNoiz0L7f3I40L5bHNsJffS/tYQgImxJb0cs4ZTa2GV
         /rx61meBfhN9+uLFrAhSKKorf794wFb4eDIjs1T4Io8Q4HEwsxJj9kekoyGHtulHunqJ
         e0neB/u5wmmo44gxLUpJX9QeTrkdBgo5I4fJ98yoQLCjDen5jxa+CYRW/3sEMFtG84A9
         OzSw==
In-Reply-To: <1462886671-3521-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This fixes the checkpatch.pl warning that suggests else is not
generally useful after a break or return.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/btree.c   | 12 ++++++------
 fs/nilfs2/direct.c  |  6 +++---
 fs/nilfs2/segment.c | 26 ++++++++++++--------------
 3 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 57ec6af..eccb1c8 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1029,12 +1029,12 @@ static __u64 nilfs_btree_find_target_v(const struct nilfs_bmap *btree,
 	if (ptr != NILFS_BMAP_INVALID_PTR)
 		/* sequential access */
 		return ptr;
-	else {
-		ptr = nilfs_btree_find_near(btree, path);
-		if (ptr != NILFS_BMAP_INVALID_PTR)
-			/* near */
-			return ptr;
-	}
+
+	ptr = nilfs_btree_find_near(btree, path);
+	if (ptr != NILFS_BMAP_INVALID_PTR)
+		/* near */
+		return ptr;
+
 	/* block group */
 	return nilfs_bmap_find_target_in_group(btree);
 }
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 0010686..251a4492 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -107,9 +107,9 @@ nilfs_direct_find_target_v(const struct nilfs_bmap *direct, __u64 key)
 	if (ptr != NILFS_BMAP_INVALID_PTR)
 		/* sequential access */
 		return ptr;
-	else
-		/* block group */
-		return nilfs_bmap_find_target_in_group(direct);
+
+	/* block group */
+	return nilfs_bmap_find_target_in_group(direct);
 }
 
 static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 97dee06..c9ee03c 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -150,17 +150,15 @@ static int nilfs_prepare_segment_lock(struct nilfs_transaction_info *ti)
 	if (cur_ti) {
 		if (cur_ti->ti_magic == NILFS_TI_MAGIC)
 			return ++cur_ti->ti_count;
-		else {
-			/*
-			 * If journal_info field is occupied by other FS,
-			 * it is saved and will be restored on
-			 * nilfs_transaction_commit().
-			 */
-			printk(KERN_WARNING
-			       "NILFS warning: journal info from a different "
-			       "FS\n");
-			save = current->journal_info;
-		}
+
+		/*
+		 * If journal_info field is occupied by other FS,
+		 * it is saved and will be restored on
+		 * nilfs_transaction_commit().
+		 */
+		printk(KERN_WARNING
+		       "NILFS warning: journal info from a different FS\n");
+		save = current->journal_info;
 	}
 	if (!ti) {
 		ti = kmem_cache_alloc(nilfs_transaction_cachep, GFP_NOFS);
@@ -2552,10 +2550,10 @@ static int nilfs_segctor_thread(void *arg)
 
 		if (timeout || sci->sc_seq_request != sci->sc_seq_done)
 			mode = SC_LSEG_SR;
-		else if (!sci->sc_flush_request)
-			break;
-		else
+		else if (sci->sc_flush_request)
 			mode = nilfs_segctor_flush_mode(sci);
+		else
+			break;
 
 		spin_unlock(&sci->sc_state_lock);
 		nilfs_segctor_thread_construct(sci, mode);
-- 
1.8.3.1

