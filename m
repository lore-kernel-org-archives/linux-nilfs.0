From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/4] nilfs2: add omitted comment for ns_mount_state field of the_nilfs structure
Date: Mon, 16 Jul 2012 10:05:23 +0900
Message-ID: <1342400726-30670-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1342400726-30670-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1342400726-30670-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

From: Vyacheslav Dubeyko <slava@dubeyko.com>

This patch adds omitted comment for ns_mount_state field of the_nilfs
structure.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/the_nilfs.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 9992b11..ef40a51 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -52,6 +52,7 @@ enum {
  * @ns_sbwtime: previous write time of super block
  * @ns_sbwcount: write count of super block
  * @ns_sbsize: size of valid data in super block
+ * @ns_mount_state: file system state
  * @ns_seg_seq: segment sequence counter
  * @ns_segnum: index number of the latest full segment.
  * @ns_nextnum: index number of the full segment index to be used next
-- 
1.7.9.3
