From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: do not use async write flag for segment summary buffers
Date: Mon,  9 Feb 2015 00:30:47 +0900
Message-ID: <1423409448-5430-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1423409448-5430-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=IbgWW8HhWAp8goZAb1DAcrh0JXJgUQHKq6kQJsdlFRE=;
        b=DOeX74X1kbHvTJvqcv2l+J5fyuPERG/7ZvCXX5RDljcL/dZOro8zWiN4ror69u6Wb/
         l7yF2p/HFyplxjZ9sWPdQS1hbeZmbvccMfcgoFv64Efdzb2386FhbDgnqJVuUxwzlvwh
         0697BR+tlKNYmSqLgMQpZ4hOLD7n+Isw4Yi35KZCJl7QXWnDNzJvP7PCHikZaPE9srgY
         6orAWcct/n5/IbfiAGUb+uOSPcKPjs+jtSQyMQzthaPKStWyRCcuekNUQ8pXqPvVY3wN
         wiunWKLk6Z7UCD2SkmDe9FedPRZnSvCxPvdaNDBNdDu0Z41B/tIhzRrfoT2SKbR7aapa
         hucw==
In-Reply-To: <1423409448-5430-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

The async write flag is introduced to nilfs2 in the commit 7f42ec3941
"nilfs2: fix issue with race condition of competition between segments
for dirty blocks", but the flag only makes sense for data buffers and
btree node buffers.  It is not needed for segment summary buffers.

This gits rid of the latter uses to prepare for refactoring of atomic
bit operations on buffer state bitmap.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 fs/nilfs2/segment.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 469086b..566cad8 100644
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

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
