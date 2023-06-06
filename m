From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/31] fs: remove sb->s_mode
Date: Tue,  6 Jun 2023 09:39:37 +0200
Message-ID: <20230606073950.225178-19-hch@lst.de>
References: <20230606073950.225178-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686037286;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZNvX5ItvblYI9q4poYa4bc1nln7/7DRcaTaNDFe4agA=;
	b=hNGM5IVx/chDwYh3B7ZUc1jXUvY5Fsbe8qo9+P4xpC7p0CH+5tmTFmu0t62cAarWoV2qT+
	IfwBTsGAKCjH2P0O2mn9q+5JAB4vpwDxTKfzOpqXatyqnPl9n1y5Pz777wZcY9PKCNlE1d
	Ts5F4twrp7PZio/Hfww9U46IM7rjQVk=
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

There is no real need to store the open mode in the super_block now.
It is only used by f2fs, which can easily recalculate it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/f2fs/super.c    | 10 ++++++----
 fs/nilfs2/super.c  |  1 -
 fs/super.c         |  2 --
 include/linux/fs.h |  1 -
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index a5adb1d316e331..5a764fecd1c7ef 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3993,6 +3993,7 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
 	struct f2fs_super_block *raw_super = F2FS_RAW_SUPER(sbi);
 	unsigned int max_devices = MAX_DEVICES;
 	unsigned int logical_blksize;
+	fmode_t mode = sb_open_mode(sbi->sb->s_flags);
 	int i;
 
 	/* Initialize single device information */
@@ -4024,8 +4025,8 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
 		if (max_devices == 1) {
 			/* Single zoned block device mount */
 			FDEV(0).bdev =
-				blkdev_get_by_dev(sbi->sb->s_bdev->bd_dev,
-					sbi->sb->s_mode, sbi->sb->s_type, NULL);
+				blkdev_get_by_dev(sbi->sb->s_bdev->bd_dev, mode,
+						  sbi->sb->s_type, NULL);
 		} else {
 			/* Multi-device mount */
 			memcpy(FDEV(i).path, RDEV(i).path, MAX_PATH_LEN);
@@ -4043,8 +4044,9 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
 					(FDEV(i).total_segments <<
 					sbi->log_blocks_per_seg) - 1;
 			}
-			FDEV(i).bdev = blkdev_get_by_path(FDEV(i).path,
-					sbi->sb->s_mode, sbi->sb->s_type, NULL);
+			FDEV(i).bdev = blkdev_get_by_path(FDEV(i).path, mode,
+							  sbi->sb->s_type,
+							  NULL);
 		}
 		if (IS_ERR(FDEV(i).bdev))
 			return PTR_ERR(FDEV(i).bdev);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index a41fd84d4e28ab..15a5a1099427d8 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1316,7 +1316,6 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 		s_new = true;
 
 		/* New superblock instance created */
-		s->s_mode = mode;
 		snprintf(s->s_id, sizeof(s->s_id), "%pg", sd.bdev);
 		sb_set_blocksize(s, block_size(sd.bdev));
 
diff --git a/fs/super.c b/fs/super.c
index dc7f328398339d..86f40f8981989d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1308,7 +1308,6 @@ int get_tree_bdev(struct fs_context *fc,
 		blkdev_put(bdev, fc->fs_type);
 		down_write(&s->s_umount);
 	} else {
-		s->s_mode = mode;
 		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		shrinker_debugfs_rename(&s->s_shrink, "sb-%s:%s",
 					fc->fs_type->name, s->s_id);
@@ -1382,7 +1381,6 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 		blkdev_put(bdev, fs_type);
 		down_write(&s->s_umount);
 	} else {
-		s->s_mode = mode;
 		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		shrinker_debugfs_rename(&s->s_shrink, "sb-%s:%s",
 					fs_type->name, s->s_id);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7b2053649820cc..ad1d2c9afb3fa4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1215,7 +1215,6 @@ struct super_block {
 	uuid_t			s_uuid;		/* UUID */
 
 	unsigned int		s_max_links;
-	fmode_t			s_mode;
 
 	/*
 	 * The next field is for VFS *only*. No filesystems have any business
-- 
2.39.2
