From: Waiman Long <longman@redhat.com>
Subject: [PATCH v6 2/2] block_dev: Rename bd_fsfreeze_mutex
Date: Mon, 18 Sep 2017 14:53:51 -0400
Message-ID: <1505760831-7747-3-git-send-email-longman@redhat.com>
References: <1505760831-7747-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505760831-7747-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>, Waiman Long <longman@redhat.com>

As the bd_fsfreeze_mutex is used by the blktrace subsystem as well,
it is now renamed to bd_fsfreeze_blktrace_mutex to better reflect
its purpose.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 fs/block_dev.c          | 14 +++++++-------
 fs/gfs2/ops_fstype.c    |  6 +++---
 fs/nilfs2/super.c       |  6 +++---
 fs/super.c              |  6 +++---
 include/linux/fs.h      |  5 +++--
 kernel/trace/blktrace.c | 14 +++++++-------
 6 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 93d088f..3dea006 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -504,7 +504,7 @@ struct super_block *freeze_bdev(struct block_device *bdev)
 	struct super_block *sb;
 	int error = 0;
 
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	mutex_lock(&bdev->bd_fsfreeze_blktrace_mutex);
 	if (++bdev->bd_fsfreeze_count > 1) {
 		/*
 		 * We don't even need to grab a reference - the first call
@@ -514,7 +514,7 @@ struct super_block *freeze_bdev(struct block_device *bdev)
 		sb = get_super(bdev);
 		if (sb)
 			drop_super(sb);
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		mutex_unlock(&bdev->bd_fsfreeze_blktrace_mutex);
 		return sb;
 	}
 
@@ -528,13 +528,13 @@ struct super_block *freeze_bdev(struct block_device *bdev)
 	if (error) {
 		deactivate_super(sb);
 		bdev->bd_fsfreeze_count--;
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		mutex_unlock(&bdev->bd_fsfreeze_blktrace_mutex);
 		return ERR_PTR(error);
 	}
 	deactivate_super(sb);
  out:
 	sync_blockdev(bdev);
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	mutex_unlock(&bdev->bd_fsfreeze_blktrace_mutex);
 	return sb;	/* thaw_bdev releases s->s_umount */
 }
 EXPORT_SYMBOL(freeze_bdev);
@@ -550,7 +550,7 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
 	int error = -EINVAL;
 
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	mutex_lock(&bdev->bd_fsfreeze_blktrace_mutex);
 	if (!bdev->bd_fsfreeze_count)
 		goto out;
 
@@ -568,7 +568,7 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 	if (error)
 		bdev->bd_fsfreeze_count++;
 out:
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	mutex_unlock(&bdev->bd_fsfreeze_blktrace_mutex);
 	return error;
 }
 EXPORT_SYMBOL(thaw_bdev);
@@ -767,7 +767,7 @@ static void init_once(void *foo)
 	bdev->bd_bdi = &noop_backing_dev_info;
 	inode_init_once(&ei->vfs_inode);
 	/* Initialize mutex for freeze. */
-	mutex_init(&bdev->bd_fsfreeze_mutex);
+	mutex_init(&bdev->bd_fsfreeze_blktrace_mutex);
 }
 
 static void bdev_evict_inode(struct inode *inode)
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index a3711f5..5664905 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1269,14 +1269,14 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 	 * will protect the lockfs code from trying to start a snapshot
 	 * while we are mounting
 	 */
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	mutex_lock(&bdev->bd_fsfreeze_blktrace_mutex);
 	if (bdev->bd_fsfreeze_count > 0) {
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		mutex_unlock(&bdev->bd_fsfreeze_blktrace_mutex);
 		error = -EBUSY;
 		goto error_bdev;
 	}
 	s = sget(fs_type, test_gfs2_super, set_gfs2_super, flags, bdev);
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	mutex_unlock(&bdev->bd_fsfreeze_blktrace_mutex);
 	error = PTR_ERR(s);
 	if (IS_ERR(s))
 		goto error_bdev;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 4fc018d..931b455 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1306,15 +1306,15 @@ static int nilfs_test_bdev_super(struct super_block *s, void *data)
 	 * will protect the lockfs code from trying to start a snapshot
 	 * while we are mounting
 	 */
-	mutex_lock(&sd.bdev->bd_fsfreeze_mutex);
+	mutex_lock(&sd.bdev->bd_fsfreeze_blktrace_mutex);
 	if (sd.bdev->bd_fsfreeze_count > 0) {
-		mutex_unlock(&sd.bdev->bd_fsfreeze_mutex);
+		mutex_unlock(&sd.bdev->bd_fsfreeze_blktrace_mutex);
 		err = -EBUSY;
 		goto failed;
 	}
 	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, flags,
 		 sd.bdev);
-	mutex_unlock(&sd.bdev->bd_fsfreeze_mutex);
+	mutex_unlock(&sd.bdev->bd_fsfreeze_blktrace_mutex);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
 		goto failed;
diff --git a/fs/super.c b/fs/super.c
index 166c4ee..079890f 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1083,15 +1083,15 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 	 * will protect the lockfs code from trying to start a snapshot
 	 * while we are mounting
 	 */
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	mutex_lock(&bdev->bd_fsfreeze_blktrace_mutex);
 	if (bdev->bd_fsfreeze_count > 0) {
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		mutex_unlock(&bdev->bd_fsfreeze_blktrace_mutex);
 		error = -EBUSY;
 		goto error_bdev;
 	}
 	s = sget(fs_type, test_bdev_super, set_bdev_super, flags | SB_NOSEC,
 		 bdev);
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	mutex_unlock(&bdev->bd_fsfreeze_blktrace_mutex);
 	if (IS_ERR(s))
 		goto error_s;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 330b572..16c4297 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -448,8 +448,9 @@ struct block_device {
 
 	/* The counter of freeze processes */
 	int			bd_fsfreeze_count;
-	/* Mutex for freeze and blktrace */
-	struct mutex		bd_fsfreeze_mutex;
+
+	/* Mutex for both freeze and blktrace */
+	struct mutex		bd_fsfreeze_blktrace_mutex;
 } __randomize_layout;
 
 /*
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 7cd5d1d..463a470 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -656,7 +656,7 @@ int blk_trace_startstop(struct request_queue *q, int start)
  * Protection from multiple readers and writers accessing blktrace data
  * concurrently is still required. The bd_mutex was used for this purpose.
  * That could lead to deadlock with concurrent block device deletion and
- * sysfs access. Instead, the block device bd_fsfreeze_mutex is now
+ * sysfs access. Instead, the block device bd_fsfreeze_blktrace_mutex is now
  * overloaded for blktrace data protection. Like freeze/thaw, blktrace
  * functionality is not frequently used. There is no point in adding
  * one more mutex to the block_device structure just for blktrace.
@@ -679,7 +679,7 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 	if (!q)
 		return -ENXIO;
 
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	mutex_lock(&bdev->bd_fsfreeze_blktrace_mutex);
 
 	switch (cmd) {
 	case BLKTRACESETUP:
@@ -705,7 +705,7 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 		break;
 	}
 
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	mutex_unlock(&bdev->bd_fsfreeze_blktrace_mutex);
 	return ret;
 }
 
@@ -1741,7 +1741,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 	if (q == NULL)
 		goto out_bdput;
 
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	mutex_lock(&bdev->bd_fsfreeze_blktrace_mutex);
 
 	if (attr == &dev_attr_enable) {
 		ret = sprintf(buf, "%u\n", !!q->blk_trace);
@@ -1760,7 +1760,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 		ret = sprintf(buf, "%llu\n", q->blk_trace->end_lba);
 
 out_unlock_bdev:
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	mutex_unlock(&bdev->bd_fsfreeze_blktrace_mutex);
 out_bdput:
 	bdput(bdev);
 out:
@@ -1802,7 +1802,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 	if (q == NULL)
 		goto out_bdput;
 
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	mutex_lock(&bdev->bd_fsfreeze_blktrace_mutex);
 
 	if (attr == &dev_attr_enable) {
 		if (value)
@@ -1828,7 +1828,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 	}
 
 out_unlock_bdev:
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	mutex_unlock(&bdev->bd_fsfreeze_blktrace_mutex);
 out_bdput:
 	bdput(bdev);
 out:
-- 
1.8.3.1

