From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/31] block: add a sb_open_mode helper
Date: Tue,  6 Jun 2023 09:39:36 +0200
Message-ID: <20230606073950.225178-18-hch@lst.de>
References: <20230606073950.225178-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686037284;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V4eB4sCjWBlICn7T5AfSKf6BZWEa9JiD//vUubLf7cU=;
	b=WuyvwRbtP3ul9p/I5pF4+tHzHA1UKecDOGaHkgTAzhUR9p6trZ2qBRIcugooeyCMRkcM4j
	8m2od6Ylo7jcassaxz7Eo8IpsaBq6ezPjMKMlN9Kq/dpz3dQeRoDyj3jLZx6xXNicqnHmh
	8ujO0mlI3oZ3CFikP6FloSCbK5VXtsQ=
In-Reply-To: <20230606073950.225178-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

Add a helper to return the open flags for blkdev_get_by* for passed in
super block flags instead of open coding the logic in many places.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/super.c       |  5 +----
 fs/nilfs2/super.c      |  7 ++-----
 fs/super.c             | 15 ++++-----------
 include/linux/blkdev.h |  7 +++++++
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1a2ee9407f5414..fd02b92e39106a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1440,12 +1440,9 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	struct btrfs_fs_devices *fs_devices = NULL;
 	struct btrfs_fs_info *fs_info = NULL;
 	void *new_sec_opts = NULL;
-	fmode_t mode = FMODE_READ;
+	fmode_t mode = sb_open_mode(flags);
 	int error = 0;
 
-	if (!(flags & SB_RDONLY))
-		mode |= FMODE_WRITE;
-
 	if (data) {
 		error = security_sb_eat_lsm_opts(data, &new_sec_opts);
 		if (error)
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 61d5e79a5e81df..a41fd84d4e28ab 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1278,14 +1278,11 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 {
 	struct nilfs_super_data sd;
 	struct super_block *s;
-	fmode_t mode = FMODE_READ;
 	struct dentry *root_dentry;
 	int err, s_new = false;
 
-	if (!(flags & SB_RDONLY))
-		mode |= FMODE_WRITE;
-
-	sd.bdev = blkdev_get_by_path(dev_name, mode, fs_type, NULL);
+	sd.bdev = blkdev_get_by_path(dev_name, sb_open_mode(flags), fs_type,
+				     NULL);
 	if (IS_ERR(sd.bdev))
 		return ERR_CAST(sd.bdev);
 
diff --git a/fs/super.c b/fs/super.c
index 8563794a8bc462..dc7f328398339d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1255,17 +1255,13 @@ int get_tree_bdev(struct fs_context *fc,
 {
 	struct block_device *bdev;
 	struct super_block *s;
-	fmode_t mode = FMODE_READ;
 	int error = 0;
 
-	if (!(fc->sb_flags & SB_RDONLY))
-		mode |= FMODE_WRITE;
-
 	if (!fc->source)
 		return invalf(fc, "No source specified");
 
-	bdev = blkdev_get_by_path(fc->source, mode, fc->fs_type,
-				  &fs_holder_ops);
+	bdev = blkdev_get_by_path(fc->source, sb_open_mode(fc->sb_flags),
+				  fc->fs_type, &fs_holder_ops);
 	if (IS_ERR(bdev)) {
 		errorf(fc, "%s: Can't open blockdev", fc->source);
 		return PTR_ERR(bdev);
@@ -1344,13 +1340,10 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 {
 	struct block_device *bdev;
 	struct super_block *s;
-	fmode_t mode = FMODE_READ;
 	int error = 0;
 
-	if (!(flags & SB_RDONLY))
-		mode |= FMODE_WRITE;
-
-	bdev = blkdev_get_by_path(dev_name, mode, fs_type, &fs_holder_ops);
+	bdev = blkdev_get_by_path(dev_name, sb_open_mode(flags), fs_type,
+				  &fs_holder_ops);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d5b99796f12c11..97803603902076 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1473,6 +1473,13 @@ struct blk_holder_ops {
 	void (*mark_dead)(struct block_device *bdev);
 };
 
+/*
+ * Return the correct open flags for blkdev_get_by_* for super block flags
+ * as stored in sb->s_flags.
+ */
+#define sb_open_mode(flags) \
+	(FMODE_READ | (((flags) & SB_RDONLY) ? 0 : FMODE_WRITE))
+
 struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder,
 		const struct blk_holder_ops *hops);
 struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
-- 
2.39.2
