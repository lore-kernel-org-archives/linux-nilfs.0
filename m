From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: [PATCH] nilfs2: fix WARNING in mark_buffer_dirty due to discarded buffer reuse
Date: Fri, 18 Aug 2023 22:18:04 +0900
Message-ID: <20230818131804.7758-1-konishi.ryusuke@gmail.com>
References: <0000000000003da75f05fdeffd12@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692364689; x=1692969489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzzMWGzNSLRyaBcN3mZ9k3m0heMsfpzA3+qcnBXsGqU=;
        b=YLoH3BK/waIQP1nP5jtKqbnW1GxErxLDqGmPHjYocbmIOBV1zJfjAqelJbf9jJ35Jd
         WAHDyUocGplRyyIBxvo2OS8n27JbdFXfCE6TwcMw32KXBQwKoa3uo2YFbYQdlJhNNUy3
         Gmv9S58jhba2U5QInoHSVIytkHKDfkiR/DNFqHZE4ZdQPDMxT6B6YDOAmGQrsTVUq7Ti
         XC+JfkXBMOMTm6HdQFB0FjnmK+ofs2Pe6eFLM7IlJCAPcTLEXGSZPrjsC6y4fw0skPA/
         +Mdf/PhNcuar6Kf3y/j5OjjYFNE1iHBVIEqB+8EIJFMc9LFAVIIrjSs9hoCny5Ojxmo9
         RZVQ==
In-Reply-To: <0000000000003da75f05fdeffd12@google.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org, syzbot <syzbot+cdfcae656bac88ba0e2d@syzkaller.appspotmail.com>, syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

A syzbot stress test using a corrupted disk image reported that
mark_buffer_dirty() called from __nilfs_mark_inode_dirty() or
nilfs_palloc_commit_alloc_entry() may output a kernel warning, and can
panic if the kernel is booted with panic_on_warn.

This is because nilfs2 keeps buffer pointers in local structures for some
metadata and reuses them, but such buffers may be forcibly discarded by
nilfs_clear_dirty_page() in some critical situations.

This issue is reported to appear after commit 28a65b49eb53 ("nilfs2: do
not write dirty data after degenerating to read-only"), but the issue has
potentially existed before.

Fix this issue by checking the uptodate flag when attempting to reuse
an internally held buffer, and reloading the metadata instead of reusing
the buffer if the flag was lost.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+cdfcae656bac88ba0e2d@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000003da75f05fdeffd12@google.com
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org> # 3.10+
---
 fs/nilfs2/alloc.c | 3 ++-
 fs/nilfs2/inode.c | 7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 6ce8617b562d..7342de296ec3 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -205,7 +205,8 @@ static int nilfs_palloc_get_block(struct inode *inode, unsigned long blkoff,
 	int ret;
 
 	spin_lock(lock);
-	if (prev->bh && blkoff == prev->blkoff) {
+	if (prev->bh && blkoff == prev->blkoff &&
+	    likely(buffer_uptodate(prev->bh))) {
 		get_bh(prev->bh);
 		*bhp = prev->bh;
 		spin_unlock(lock);
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 35bc79305318..acf7a266f72f 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -1025,7 +1025,7 @@ int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh)
 	int err;
 
 	spin_lock(&nilfs->ns_inode_lock);
-	if (ii->i_bh == NULL) {
+	if (ii->i_bh == NULL || unlikely(!buffer_uptodate(ii->i_bh))) {
 		spin_unlock(&nilfs->ns_inode_lock);
 		err = nilfs_ifile_get_inode_block(ii->i_root->ifile,
 						  inode->i_ino, pbh);
@@ -1034,7 +1034,10 @@ int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh)
 		spin_lock(&nilfs->ns_inode_lock);
 		if (ii->i_bh == NULL)
 			ii->i_bh = *pbh;
-		else {
+		else if (unlikely(!buffer_uptodate(ii->i_bh))) {
+			__brelse(ii->i_bh);
+			ii->i_bh = *pbh;
+		} else {
 			brelse(*pbh);
 			*pbh = ii->i_bh;
 		}
-- 
2.34.1

