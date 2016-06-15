From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] nilfs: avoid warning about unused variables
Date: Wed, 15 Jun 2016 22:19:41 +0200
Message-ID: <20160615201945.3348205-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org

The newly added nilfs_msg() infrastructure caused a warning in
nilfs_clear_dirty_page() when it is disabled:

fs/nilfs2/page.c: In function 'nilfs_clear_dirty_page':
fs/nilfs2/page.c:402:22: error: unused variable 'sb' [-Werror=unused-variable]
  struct super_block *sb = inode->i_sb;

We can avoid the warning by adding a cast to void for the first
argument of the macro.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: aede53d223f0 ("nilfs2: replace nilfs_warning() with nilfs_msg()")
---
 fs/nilfs2/nilfs.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index b7064faef217..46fbd4e00315 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -317,7 +317,10 @@ void __nilfs_error(struct super_block *sb, const char *function,
 #else
 
 #define nilfs_msg(sb, level, fmt, ...)					\
-	no_printk(fmt, ##__VA_ARGS__)
+	do {								\
+		no_printk(fmt, ##__VA_ARGS__);				\
+		(void)(sb);						\
+	} while (0)
 #define nilfs_error(sb, fmt, ...)					\
 	do {								\
 		no_printk(fmt, ##__VA_ARGS__);				\
-- 
2.9.0

