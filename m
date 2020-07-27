From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] nilfs2: Convert __nilfs_msg to integrate the level and format
Date: Mon, 27 Jul 2020 23:28:30 +0900
Message-ID: <1595860111-3920-3-git-send-email-konishi.ryusuke@gmail.com>
References: <1595860111-3920-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ByU1/eNsYuK+GvYyh2kCuTxeEuK1AGp+s4ZtpbXbVKU=;
        b=o3SnS5cuvequyTLFcS+lezgeWpNLkUtAmwe6DnMeHTy/MxmANCgHVsSpEhLvBTM76Z
         oLwhVYeuXBw39dvfolBjCQ9lW1sW8fF4vvwmhC2Yt4fVoa0er0GJeBTWN0nEn39fLeJu
         yJueqvcQ/qS6605ydP+dlCSsvWjg44rUT10pg12fePozF2rJkc6d5gXjGerCCvGLPED2
         CfCppqOH4SincYE547zDZ5H5gPMIkVuQ4Pgsmq0ZekfsiFKrkHPG9EoWpjV3W75klSeN
         fbP7dXwryyACOzbT3p5KlcZyhEuM6uUt1pJfRm1guIhBegsp0Dr72okkzz+Z/hz+QHmZ
         GpgA==
In-Reply-To: <1595860111-3920-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>

Reduce object size a bit by removing the KERN_<LEVEL> as a
separate argument and adding it to the format string.

Reduce overall object size by about ~.5% (x86-64 defconfig w/ nilfs2)

old:
$ size -t fs/nilfs2/built-in.a | tail -1
 191738	   8676	     44	 200458	  30f0a	(TOTALS)

new:
$ size -t fs/nilfs2/built-in.a | tail -1
 190971	   8676	     44	 199691	  30c0b	(TOTALS)

Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/nilfs.h |  9 ++++-----
 fs/nilfs2/super.c | 16 +++++++++++-----
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 42395ba52da6..979a41016743 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -289,9 +289,8 @@ static inline int nilfs_mark_inode_dirty_sync(struct inode *inode)
 /* super.c */
 extern struct inode *nilfs_alloc_inode(struct super_block *);
 
-extern __printf(3, 4)
-void __nilfs_msg(struct super_block *sb, const char *level,
-		 const char *fmt, ...);
+__printf(2, 3)
+void __nilfs_msg(struct super_block *sb, const char *fmt, ...);
 extern __printf(3, 4)
 void __nilfs_error(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
@@ -299,7 +298,7 @@ void __nilfs_error(struct super_block *sb, const char *function,
 #ifdef CONFIG_PRINTK
 
 #define nilfs_msg(sb, level, fmt, ...)					\
-	__nilfs_msg(sb, level, fmt, ##__VA_ARGS__)
+	__nilfs_msg(sb, level fmt, ##__VA_ARGS__)
 #define nilfs_error(sb, fmt, ...)					\
 	__nilfs_error(sb, __func__, fmt, ##__VA_ARGS__)
 
@@ -307,7 +306,7 @@ void __nilfs_error(struct super_block *sb, const char *function,
 
 #define nilfs_msg(sb, level, fmt, ...)					\
 	do {								\
-		no_printk(fmt, ##__VA_ARGS__);				\
+		no_printk(level fmt, ##__VA_ARGS__);			\
 		(void)(sb);						\
 	} while (0)
 #define nilfs_error(sb, fmt, ...)					\
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 5729ee86da9a..fef4821a1f0f 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -62,19 +62,25 @@
 static int nilfs_setup_super(struct super_block *sb, int is_mount);
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
-void __nilfs_msg(struct super_block *sb, const char *level, const char *fmt,
-		 ...)
+void __nilfs_msg(struct super_block *sb, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
+	int level;
 
 	va_start(args, fmt);
-	vaf.fmt = fmt;
+
+	level = printk_get_level(fmt);
+	vaf.fmt = printk_skip_level(fmt);
 	vaf.va = &args;
+
 	if (sb)
-		printk("%sNILFS (%s): %pV\n", level, sb->s_id, &vaf);
+		printk("%c%cNILFS (%s): %pV\n",
+		       KERN_SOH_ASCII, level, sb->s_id, &vaf);
 	else
-		printk("%sNILFS: %pV\n", level, &vaf);
+		printk("%c%cNILFS: %pV\n",
+		       KERN_SOH_ASCII, level, &vaf);
+
 	va_end(args);
 }
 
-- 
1.8.3.1

