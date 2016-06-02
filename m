From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 2/8] nilfs2: add nilfs_msg() message interface
Date: Thu,  2 Jun 2016 22:58:05 +0900
Message-ID: <1464875891-5443-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1464875891-5443-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=raW++PTkKJsSEPlEEb2s37dnsqDfrR2oJap9CzFmTJA=;
        b=y3fCVHHrSO1GLapxkNf9+vI3VE0pBHPtNM0HgXsEueTqNVWsIeO7WgQ27gj54LP+F7
         jzEwZJJcNzfy+AmR+XJ7P4QMSXIvI+emzLR1Wnbn2SSrRygc0SosOWT6EUyRDIS3sJoT
         QKkGc7i+CsLeIKJjnT8P+HAW37IKFYSP9xKuxnIGL7I1xLWrIKBAYYDOlE/GN3gQZaHJ
         PgQ8dSHo+rbJNNqICz3YKo91kISwyKhiMjkXDJy/8dklMQqS6tx+C7Ki6DdThv2Dcx+S
         s58h/2U0/zjcVnmG+Us+q6MsHHWjPhDGUJp2+n9caMOqmoEF7ZLXWyZcHVrtAFfbvcyO
         lRWA==
In-Reply-To: <1464875891-5443-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Define an own output routine to replace bare use of printk() function.
The output routine is implemented with a macro and a helper function,
which are named nilfs_msg() and __nilfs_msg(), respectively.

__nilfs_msg() formats a message like "NILFS (<device-name>):
<message>", prefixing it with a given log level, and terminates the
statement with a newline.  The "device-name" is optional to make it
available in early stages; it will be omitted if a NULL pointer is
passed to super block instance argument.  nilfs_msg() wraps
__nilfs_msg() and is removed if CONFIG_PRINTK is not set.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/nilfs.h |  7 +++++++
 fs/nilfs2/super.c | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index e482c78..b57ce41e 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -301,6 +301,9 @@ extern struct inode *nilfs_alloc_inode(struct super_block *);
 extern void nilfs_destroy_inode(struct inode *);
 
 extern __printf(3, 4)
+void __nilfs_msg(struct super_block *sb, const char *level,
+		 const char *fmt, ...);
+extern __printf(3, 4)
 void __nilfs_error(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
 extern __printf(3, 4)
@@ -308,11 +311,15 @@ void nilfs_warning(struct super_block *, const char *, const char *, ...);
 
 #ifdef CONFIG_PRINTK
 
+#define nilfs_msg(sb, level, fmt, ...)					\
+	__nilfs_msg(sb, level, fmt, ##__VA_ARGS__)
 #define nilfs_error(sb, fmt, ...)					\
 	__nilfs_error(sb, __func__, fmt, ##__VA_ARGS__)
 
 #else
 
+#define nilfs_msg(sb, level, fmt, ...)					\
+	no_printk(fmt, ##__VA_ARGS__)
 #define nilfs_error(sb, fmt, ...)					\
 	do {								\
 		no_printk(fmt, ##__VA_ARGS__);				\
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7fe497e..86e3c00 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -71,6 +71,22 @@ struct kmem_cache *nilfs_btree_path_cache;
 static int nilfs_setup_super(struct super_block *sb, int is_mount);
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
+void __nilfs_msg(struct super_block *sb, const char *level, const char *fmt,
+		 ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	if (sb)
+		printk("%sNILFS (%s): %pV\n", level, sb->s_id, &vaf);
+	else
+		printk("%sNILFS: %pV\n", level, &vaf);
+	va_end(args);
+}
+
 static void nilfs_set_error(struct super_block *sb)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
-- 
1.8.3.1

