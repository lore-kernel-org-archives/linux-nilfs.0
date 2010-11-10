From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 7/9] fs/nilfs2/super.c: Use printf extension %pV
Date: Tue,  9 Nov 2010 16:35:21 -0800
Message-ID: <1addeb606bca88e09fb46b93be10c3a58e759348.1289348757.git.joe@perches.com>
References: <cover.1289348757.git.joe@perches.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1289348757.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Using %pV reduces the number of printk calls and
eliminates any possible message interleaving from
other printk calls.

Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
---
 fs/nilfs2/super.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f804d41..bef8cc6 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -111,12 +111,17 @@ void nilfs_error(struct super_block *sb, const char *function,
 		 const char *fmt, ...)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	printk(KERN_CRIT "NILFS error (device %s): %s: ", sb->s_id, function);
-	vprintk(fmt, args);
-	printk("\n");
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_CRIT "NILFS error (device %s): %s: %pV\n",
+	       sb->s_id, function, &vaf);
+
 	va_end(args);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -136,13 +141,17 @@ void nilfs_error(struct super_block *sb, const char *function,
 void nilfs_warning(struct super_block *sb, const char *function,
 		   const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	printk(KERN_WARNING "NILFS warning (device %s): %s: ",
-	       sb->s_id, function);
-	vprintk(fmt, args);
-	printk("\n");
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_WARNING "NILFS warning (device %s): %s: %pV\n",
+	       sb->s_id, function, &vaf);
+
 	va_end(args);
 }
 
-- 
1.7.3.1.g432b3.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
