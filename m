From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/30] fs: remove sb->s_mode
Date: Thu,  8 Jun 2023 13:02:45 +0200
Message-ID: <20230608110258.189493-18-hch@lst.de>
References: <20230608110258.189493-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=T5Z718thWwTBzPeDg0jur6OK5CtfhwUqydvftRUUfzk=; b=Ve+U2bdtXZnhz7wvsQtSpY8BkS
 LAs6ZQEPDe73rYnDYwp3IOVEb8TSWsoM2ZVkTUYdCZFelT5MksWpRAaxllzbs/b7IY+WjzTt9Q/Kf
 1HXcsOxHVAzHnGgLg0/7NlYt56rcKTF1QE/F5yrc9nWuo2efuzD3x1p8O/obxl8Ek+WQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=T5Z718thWwTBzPeDg0jur6OK5CtfhwUqydvftRUUfzk=; b=JSXYC5xl8SVKgubFb+blPz60sL
 zmCstzstQ26onRqOCgyOf/PG3lHiHummT/y2qn1bC/R/B3ydftBsoKzXORzyZCUwsvBo/ngS56izb
 89BSqhp9cFXw00EcfuHxAAxXX5Ds0PZxBU/KFjdl+0aM+ikLS825xwv5kdpaIfPleA7U=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=T5Z718thWwTBzPeDg0jur6OK5CtfhwUqydvftRUUfzk=; b=Try8qIUINKsh2VL+vddRHYQmeK
 eg6+6M/8CD84A88WXuC8XV2Ftj53W7w3QfqWwkpFvM8dcSNiyhJdJ8jc6RMeT5FILY/RCY3DI/Tm6
 OUtJOgOIAdm527Pojaljwjtgtc5J+NXVTNkayO7Ij3p0a6NtsO9A64bVMzc80GY2tUcWtP6qGLBup
 8GUu2v5YbAWehIuMzuGYMIKn4ImSBwE+aW2tx2uXC5smzWfCZCL9Dwp0FgQCYlM3uji0pURCU61Tq
 oF6CRvRoUcI303XbGlmfMOA0JGhD7JytDLkjy8wt1OGx/u1K/5RhruAL0wUtKLs4N2SVf4WfDKKdq
 FAf6PO1w==;
In-Reply-To: <20230608110258.189493-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

There is no real need to store the open mode in the super_block now.
It is only used by f2fs, which can easily recalculate it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Christian Brauner <brauner@kernel.org>
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
