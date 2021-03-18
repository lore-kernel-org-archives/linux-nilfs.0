From: menglong8.dong@gmail.com
Subject: [PATCH] fs/nilfs2: fix misspellings using codespell tool
Date: Thu, 18 Mar 2021 04:32:32 -0700
Message-ID: <20210318113233.473329-1-liu.xuzhi@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nsoRVO5MAUfTeyru0kxzkoVrIbOCET+lsu0GRILy5lg=;
        b=m7DerXCdhW/2I8tupKIDo2uQIIsKDtD0mG3nWTUkXMBud8jdCUK8beEuJXm2kiqbxj
         AvHnL850rd1uYgE323mKLb52topo/ygpccFFEypUhoQO0Ezd9pd0JunVRqj4uka9p9Fq
         DEuIUpfUc7GlIeiVtiGYMpuiTrh8BR8NzaDOCgIuQZdXRnx9LyKF0YFZ1R1A5rbFsKAz
         y1iFUwyscgvPb9oDN5u/xMiNIDEe9HlkaXxprF0abOjhwckvIrunrLvTxOxFfXtwOaBt
         yunRI1VF6PZwdYdfAB4EGLIhM8lyuJWYGiosIeClBoaCkdZoojO+ls2sihXamXIYQBwu
         L8/w==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: konishi.ryusuke@gmail.com
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, Liu xuzhi <liu.xuzhi@zte.com.cn>

From: Liu xuzhi <liu.xuzhi@zte.com.cn>

Two typos are found out by codespell tool \
in 2217th and 2254th lines of segment.c:

$ codespell ./fs/nilfs2/
./segment.c:2217 :retured  ==> returned
./segment.c:2254: retured  ==> returned

Fix two typos found by codespell.

Signed-off-by: Liu xuzhi <liu.xuzhi@zte.com.cn>
---
 fs/nilfs2/segment.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index cd4da9535aed..686c8ee7b29c 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2214,7 +2214,7 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
  * nilfs_construct_segment - construct a logical segment
  * @sb: super block
  *
- * Return Value: On success, 0 is retured. On errors, one of the following
+ * Return Value: On success, 0 is returned. On errors, one of the following
  * negative error code is returned.
  *
  * %-EROFS - Read only filesystem.
@@ -2251,7 +2251,7 @@ int nilfs_construct_segment(struct super_block *sb)
  * @start: start byte offset
  * @end: end byte offset (inclusive)
  *
- * Return Value: On success, 0 is retured. On errors, one of the following
+ * Return Value: On success, 0 is returned. On errors, one of the following
  * negative error code is returned.
  *
  * %-EROFS - Read only filesystem.
-- 
2.25.1

