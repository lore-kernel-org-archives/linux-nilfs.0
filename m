From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 6/7] nilfs2: remove loops of single statement macros
Date: Tue, 10 May 2016 22:24:30 +0900
Message-ID: <1462886671-3521-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1462886671-3521-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=1gzrq89l2G9Ap71IiTPOTb+P9u0nKP9jptnEyWLLA+g=;
        b=F+KIEDDE0ofhVlKQ5kCGNgajcUWJaCJJYOT5EzOfq5yIDvIf0XCuOwWnos782omV/c
         58Tcp+cv7mVbw0opSBvAgC4LwXnTemITyRlkhIc/RtV1sfW4uNTKeqgyOqcwtdVkz+F+
         6EwWlHnaNleO83ScxKMEGTVDoqUDAcmhsGhnqjVc0VuHJhjogVE8fLtJQXtFNvqbJEK7
         2N4DAGy60/WqgLlBuKJdqFABZGKNIXYRIS17/pBJBtHWcFQAjteSj9kbaOuPHqfgOd7A
         65WHtWWv5pq1Tq9ULhsIa5W2SaJMYn8koQGjjB2fD8I0ZBRdnB+K94V2KQluGuNxk4T5
         wvdw==
In-Reply-To: <1462886671-3521-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This fixes checkpatch.pl warning "WARNING: Single statement macros
should not use a do {} while (0) loop".

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/the_nilfs.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 06d2548..79369fd 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -222,15 +222,14 @@ THE_NILFS_FNS(SB_DIRTY, sb_dirty)
  * Mount option operations
  */
 #define nilfs_clear_opt(nilfs, opt)  \
-	do { (nilfs)->ns_mount_opt &= ~NILFS_MOUNT_##opt; } while (0)
+	((nilfs)->ns_mount_opt &= ~NILFS_MOUNT_##opt)
 #define nilfs_set_opt(nilfs, opt)  \
-	do { (nilfs)->ns_mount_opt |= NILFS_MOUNT_##opt; } while (0)
+	((nilfs)->ns_mount_opt |= NILFS_MOUNT_##opt)
 #define nilfs_test_opt(nilfs, opt) ((nilfs)->ns_mount_opt & NILFS_MOUNT_##opt)
 #define nilfs_write_opt(nilfs, mask, opt)				\
-	do { (nilfs)->ns_mount_opt =					\
+	((nilfs)->ns_mount_opt =					\
 		(((nilfs)->ns_mount_opt & ~NILFS_MOUNT_##mask) |	\
-		 NILFS_MOUNT_##opt);					\
-	} while (0)
+		 NILFS_MOUNT_##opt))					\
 
 /**
  * struct nilfs_root - nilfs root object
-- 
1.8.3.1

