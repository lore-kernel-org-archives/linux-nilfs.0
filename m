From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/12] ext4: use fs_holder_ops for the log device
Date: Wed,  2 Aug 2023 17:41:29 +0200
Message-ID: <20230802154131.2221419-11-hch@lst.de>
References: <20230802154131.2221419-1-hch@lst.de>
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
 bh=t1/fXxbj2uJU5xas1rDU20QLxJIeGJx3IPPvaW9KT9Y=; b=hK9TdUfZqy8KR6/hcW6ZL15D1U
 OmVxVN2X3FFWZeKNdEIScd8M1SwyQ+sbl9ivwXBebvcKCRC/hkbqt17teif4Z88k1uaiHoenSIiux
 sxVia2xwHVDsuqNZdWOuhJyDhEGIiw018dxRANVNsx6ljMhjLQG4QgBSFxLnbC3nuFE0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=t1/fXxbj2uJU5xas1rDU20QLxJIeGJx3IPPvaW9KT9Y=; b=gIrWJGOdqcNmSuUrysAbcDyWuO
 YcShyUxpNQt6KqbCwfzZe+x7jgBYi9Hwv81O3qSo5D2IOQmyM9WK2UxbF3+T2cGk8w8KEj5NZI0GN
 8KDNZ1aqvWMZRM8SRDIYzmhsAvr9utHkHwMJYjBmNKxlzIZTsQdaNaVApkdHQyDIGRPk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=t1/fXxbj2uJU5xas1rDU20QLxJIeGJx3IPPvaW9KT9Y=; b=2i+CcpcoXVSq4J7NqyEaRQu0MS
 DSsA4T4HQ7JZ+g7Ov6bcczZ/tpF4ZkTz9NxECM9geFk5dv1/TztPUrp17xFtlDXKLyoX3pkpemqeB
 OQPpsZdYMVdmbDglOG0I9dpqcqqeyV/XjkQ67mNuOFgWIEwDlobHlmhsm0iPi3w+6wR+6G5B1YZQP
 iWapYBcFtpmWKbvl+Jn8/7LBe0gSETLk1M6EwK0Ny2GMRQFmOIyT6N6Ad/dzBzf+vmZA2pOhMR8re
 MOaux36gSAexWnIViecm5TMwu6JeqWJ/qWyq27xWHNPjx/AhL2CBf5lfuvqnCDWkGqZsv5nzmKORQ
 JAio8dFQ==;
In-Reply-To: <20230802154131.2221419-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-btrfs@vger.kernel.org

Use the generic fs_holder_ops to shut down the file system when the
log device goes away instead of duplicating the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext4/super.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2ccb19d345c6dd..063832e2d12a8e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1096,15 +1096,6 @@ void ext4_update_dynamic_rev(struct super_block *sb)
 	 */
 }
 
-static void ext4_bdev_mark_dead(struct block_device *bdev)
-{
-	ext4_force_shutdown(bdev->bd_holder, EXT4_GOING_FLAGS_NOLOGFLUSH);
-}
-
-static const struct blk_holder_ops ext4_holder_ops = {
-	.mark_dead		= ext4_bdev_mark_dead,
-};
-
 /*
  * Open the external journal device
  */
@@ -1113,7 +1104,7 @@ static struct block_device *ext4_blkdev_get(dev_t dev, struct super_block *sb)
 	struct block_device *bdev;
 
 	bdev = blkdev_get_by_dev(dev, BLK_OPEN_READ | BLK_OPEN_WRITE, sb,
-				 &ext4_holder_ops);
+				 &fs_holder_ops);
 	if (IS_ERR(bdev))
 		goto fail;
 	return bdev;
-- 
2.39.2
