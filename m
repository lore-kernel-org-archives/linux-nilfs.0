From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 27/32] nilfs2: Convert to use blkdev_get_handle_by_path()
Date: Tue,  4 Jul 2023 14:21:54 +0200
Message-ID: <20230704122224.16257-27-jack@suse.cz>
References: <20230629165206.383-1-jack@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1688473346; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQwr5UuHNfhTbPltKjuSdQnPV1mAcWzpyJqrIN8BW0I=;
        b=nOacVS8tJH8o+KaEeK8T7qQ2qZYGpNHZrHdl+D2d/5NBZt18W9D0GubEG33ybqDnC+6s4b
        woJwgxkqsTmLNCBW6yzXws0T/lFkAzjqGC/Yy8oLTY1XTT79XS0OVHlS+Az39XvC4Fhvf/
        fTQKQqeL1Cagw+Jr9qukz7p0SJj9fXc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1688473346;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQwr5UuHNfhTbPltKjuSdQnPV1mAcWzpyJqrIN8BW0I=;
        b=VGVnKUg83uI2bRH7vJbEMJqY/TZfXogwFhtgNjI67oPxV8qlVbBcLGITDC+i2IDdUDpfZL
        i2qifN45iJK9VYAQ==
In-Reply-To: <20230629165206.383-1-jack-AlSwsSmVLrQ@public.gmane.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2354; i=jack-AlSwsSmVLrQ@public.gmane.org; h=from:subject; bh=DtdezkZSK/EN7RM1qSQYRSnndqPmr+l0kbPMp17XFJg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBkpA7iDlB6QtnlTTlGdMJScOFDAX2JZEdaLV5wnQzq wfPr4T+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZKQO4gAKCRCcnaoHP2RA2WRuB/ 93sM8/9dGNutmxHoGEwtGYIIHvJjLz0OrPGr/rt39+sF5c9+WtfclsNZKrDE94oblL8T2o3nX5R/LN wiAFHzzgZYgg/12m8Za2axys3zh+uos763PGHIk2KfJ+6Fo+mFYKKZKIRKiviewfu6XgdJv4Qo0+Sb psBZY1rOU3m/HWCVvqcfugnu4hJN3rdUqYbpGcLYB6UEM1PEg+oSPR4kf30dV8D3q48lMGy+1vNmj1 5IRRSUYNFyHdzvBXDpA+Hsis5vX0vfXijjPcmhb2D2Km2OntPST3pnilGdLVKp2XkkBuTbXx29A01B iSQmxGUB40YvRnmZFjGSZXIVogEbjT
X-Developer-Key: i=jack-AlSwsSmVLrQ@public.gmane.org; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Convert nilfs2 to use blkdev_get_handle_by_path() and initialize the
superblock with the handle.

CC: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/nilfs2/super.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 0ef8c71bde8e..0aba0daa06d2 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1283,14 +1283,15 @@ static int nilfs_identify(char *data, struct nilfs_super_data *sd)
 
 static int nilfs_set_bdev_super(struct super_block *s, void *data)
 {
-	s->s_bdev = data;
+	s->s_bdev_handle = data;
+	s->s_bdev = s->s_bdev_handle->bdev;
 	s->s_dev = s->s_bdev->bd_dev;
 	return 0;
 }
 
 static int nilfs_test_bdev_super(struct super_block *s, void *data)
 {
-	return (void *)s->s_bdev == data;
+	return s->s_bdev == ((struct bdev_handle *)data)->bdev;
 }
 
 static struct dentry *
@@ -1298,15 +1299,17 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 	     const char *dev_name, void *data)
 {
 	struct nilfs_super_data sd;
+	struct bdev_handle *bdev_handle;
 	struct super_block *s;
 	struct dentry *root_dentry;
 	int err, s_new = false;
 
-	sd.bdev = blkdev_get_by_path(dev_name, sb_open_mode(flags), fs_type,
-				     NULL);
-	if (IS_ERR(sd.bdev))
-		return ERR_CAST(sd.bdev);
+	bdev_handle = blkdev_get_handle_by_path(dev_name, sb_open_mode(flags),
+				fs_type, NULL);
+	if (IS_ERR(bdev_handle))
+		return ERR_CAST(bdev_handle);
 
+	sd.bdev = bdev_handle->bdev;
 	sd.cno = 0;
 	sd.flags = flags;
 	if (nilfs_identify((char *)data, &sd)) {
@@ -1326,7 +1329,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 		goto failed;
 	}
 	s = sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, flags,
-		 sd.bdev);
+		 bdev_handle);
 	mutex_unlock(&sd.bdev->bd_fsfreeze_mutex);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
@@ -1374,7 +1377,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 	}
 
 	if (!s_new)
-		blkdev_put(sd.bdev, fs_type);
+		blkdev_handle_put(bdev_handle);
 
 	return root_dentry;
 
@@ -1383,7 +1386,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 
  failed:
 	if (!s_new)
-		blkdev_put(sd.bdev, fs_type);
+		blkdev_handle_put(bdev_handle);
 	return ERR_PTR(err);
 }
 
-- 
2.35.3

