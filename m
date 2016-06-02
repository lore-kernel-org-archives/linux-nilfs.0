From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 3/8] nilfs2: embed a back pointer to super block instance in nilfs object
Date: Thu,  2 Jun 2016 22:58:06 +0900
Message-ID: <1464875891-5443-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1464875891-5443-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=oTANWL6rkxWEc4eJ1mzWOzt2beKIKUCvOYt9ZLfONBI=;
        b=gFVPxxHmPNOirYLZf50bViIKK8DLlu5HUPwFQN9+FS5mZtqo3pE4/PK+6GXlSWNl+1
         P2p+RY7COIBQ2cSVyvHrQJjgDvcJm94iGKjJXmne+PKHcYRRr8vrkM8IbvWWvq5KFdpq
         FxzB1gFqy1WLMnfRts64wj7EMeeVXxTxk4AW+0NHdV0Pl+SdhxYNHMOiMo71XNetkw3d
         UsrVAX0+3s3O9tZs+18SBwqAdzmlGZK6uqXoFwB3kc3TyH/5uuMk/Q0Ta7i41FBLu0jf
         gSAFdaO0XMI6vKgOTw9kqRl0vVksHGRVbm/X2bFrRGhPJvfhnGwIzC6DnsL+AAahBQNV
         YuiA==
In-Reply-To: <1464875891-5443-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Insert a back pointer to super block instance in nilfs object so that
functions of nilfs2 easily refer to the super block instance.  This
simplifies replacement of printk() in the successive change.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c     | 2 +-
 fs/nilfs2/the_nilfs.c | 7 ++++---
 fs/nilfs2/the_nilfs.h | 4 +++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 86e3c00..2d4d0be 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1076,7 +1076,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	__u64 cno;
 	int err;
 
-	nilfs = alloc_nilfs(sb->s_bdev);
+	nilfs = alloc_nilfs(sb);
 	if (!nilfs)
 		return -ENOMEM;
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 809bd2d..dbead89 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -56,12 +56,12 @@ void nilfs_set_last_segment(struct the_nilfs *nilfs,
 
 /**
  * alloc_nilfs - allocate a nilfs object
- * @bdev: block device to which the_nilfs is related
+ * @sb: super block instance
  *
  * Return Value: On success, pointer to the_nilfs is returned.
  * On error, NULL is returned.
  */
-struct the_nilfs *alloc_nilfs(struct block_device *bdev)
+struct the_nilfs *alloc_nilfs(struct super_block *sb)
 {
 	struct the_nilfs *nilfs;
 
@@ -69,7 +69,8 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	if (!nilfs)
 		return NULL;
 
-	nilfs->ns_bdev = bdev;
+	nilfs->ns_sb = sb;
+	nilfs->ns_bdev = sb->s_bdev;
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
 	mutex_init(&nilfs->ns_snapshot_mount_mutex);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 79369fd..79d1421 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -43,6 +43,7 @@ enum {
  * struct the_nilfs - struct to supervise multiple nilfs mount points
  * @ns_flags: flags
  * @ns_flushed_device: flag indicating if all volatile data was flushed
+ * @ns_sb: back pointer to super block instance
  * @ns_bdev: block device
  * @ns_sem: semaphore for shared states
  * @ns_snapshot_mount_mutex: mutex to protect snapshot mounts
@@ -102,6 +103,7 @@ struct the_nilfs {
 	unsigned long		ns_flags;
 	int			ns_flushed_device;
 
+	struct super_block     *ns_sb;
 	struct block_device    *ns_bdev;
 	struct rw_semaphore	ns_sem;
 	struct mutex		ns_snapshot_mount_mutex;
@@ -281,7 +283,7 @@ static inline int nilfs_sb_will_flip(struct the_nilfs *nilfs)
 }
 
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
-struct the_nilfs *alloc_nilfs(struct block_device *bdev);
+struct the_nilfs *alloc_nilfs(struct super_block *sb);
 void destroy_nilfs(struct the_nilfs *nilfs);
 int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data);
 int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb);
-- 
1.8.3.1

