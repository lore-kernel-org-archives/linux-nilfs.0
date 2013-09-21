From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 18/19] nilfs2: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:50 +0200
Message-ID: <1379802471-30252-18-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Nj6GdUCuQEzBGXEsh/yjDYWCopVqXM9VLUSaYy7TG7s=;
        b=bfGWw8R6/AP0iJItQ4iSGx9CPXYVrGQm0YSOmdazi2dKvDl2n2MYoxkJ3Nf5jluQNO
         cJoncFjW9QTvh5nOmWfGr7jT9Bbt0pUgWAj599wOLaBdBp3X4SK4M3hDojY/ocbumCcT
         SFeZfroMy9lfUo8lop6sgcDa4PsqDp0kHzmD910vwSs2q/y3tctYSUPteVbVTYSsHfMS
         Z4mop7q9zEkysJPNGn0nt03tafIr7o6n7inD+GaKm958r+otpgJ7bz398wCydXVFYFgo
         NHZnCR8uEB29HdAdT+4FgQB1MZTZWId3wCyUU2wzcp4eoPfpQxd1+jTpXBZ+fwNmPOql
         VA3w==
In-Reply-To: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke@lab.ntt.co.jp
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Peter Senna Tschudin <peter.senna@gmail.com>

The variable update_sr is only assigned the values true and false.
Change its type to bool.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@exists@
type T;
identifier b;
@@
- T
+ bool
  b = ...;
  ... when any
  b = \(true\|false\)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 fs/nilfs2/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index bd88a74..669c809 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1746,7 +1746,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	struct nilfs_segment_buffer *segbuf;
 	struct page *bd_page = NULL, *fs_page = NULL;
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
-	int update_sr = false;
+	bool update_sr = false;
 
 	list_for_each_entry(segbuf, &sci->sc_write_logs, sb_list) {
 		struct buffer_head *bh;
-- 
1.8.3.1
