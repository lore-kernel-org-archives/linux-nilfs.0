From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/12] fs: export setup_bdev_super
Date: Wed,  2 Aug 2023 17:41:20 +0200
Message-ID: <20230802154131.2221419-2-hch@lst.de>
References: <20230802154131.2221419-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yR3dj+eONAtbKM/zIO7ew4m4jCWdaatgpKXh7YubtNo=; b=mhaGQnhVJ1uO0sXkPgK8YqFZc5
        sx4T/ucx2OPuff6PNBCxPLw0lRV53g6hNyTwuVkRXmfF5ms72GkE+0x1uqrIpsNzHaHP6+Py4j6Tt
        9XFmrppR/JGamizKFARycs9Ei0Zd6NCt6jtO/emxLVKW+oJppL6xK9oZ0QyDSOt4KwCRRE5Fb3/qV
        nd1M5X+TDd19RtkW7i16PyY3kk/HSZISBliaimAqK2zb2qyMjYGvY5ilv8+9zMumwN7d615Bm9309
        WGSgzj/m+SQzHji61NEj7z0Pag2YVdzThx00Fv79SfAWHCvcSS285h67bPeQfgF/88NmzMiFiyxid
        AaZCwhZg==;
In-Reply-To: <20230802154131.2221419-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

We'll want to use setup_bdev_super instead of duplicating it in nilfs2.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/super.c                 | 3 ++-
 include/linux/fs_context.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 3ef39df5bec506..6aaa275fa8630d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1243,7 +1243,7 @@ static int test_bdev_super_fc(struct super_block *s, struct fs_context *fc)
 		s->s_dev == *(dev_t *)fc->sget_key;
 }
 
-static int setup_bdev_super(struct super_block *sb, int sb_flags,
+int setup_bdev_super(struct super_block *sb, int sb_flags,
 		struct fs_context *fc)
 {
 	blk_mode_t mode = sb_open_mode(sb_flags);
@@ -1295,6 +1295,7 @@ static int setup_bdev_super(struct super_block *sb, int sb_flags,
 	sb_set_blocksize(sb, block_size(bdev));
 	return 0;
 }
+EXPORT_SYMBOL_GPL(setup_bdev_super);
 
 /**
  * get_tree_bdev - Get a superblock based on a single block device
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index ff6341e09925bc..58ef8433a94b8c 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -158,6 +158,8 @@ extern int get_tree_keyed(struct fs_context *fc,
 					   struct fs_context *fc),
 			 void *key);
 
+int setup_bdev_super(struct super_block *sb, int sb_flags,
+		struct fs_context *fc);
 extern int get_tree_bdev(struct fs_context *fc,
 			       int (*fill_super)(struct super_block *sb,
 						 struct fs_context *fc));
-- 
2.39.2

