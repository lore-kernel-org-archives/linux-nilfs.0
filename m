From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/12] xfs use fs_holder_ops for the log and RT
 devices
Date: Wed,  2 Aug 2023 17:41:31 +0200
Message-ID: <20230802154131.2221419-13-hch@lst.de>
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
 bh=i4RVxh7cqcfhStKnrFuIVUqPlurNIlyMZ1NDN212nv0=; b=HBxqRc1RqMJkhP0vcZ5O+b2Sme
 5lCPfyEJKHOt1VYQtlH+1qCc+N3UoB4riOgsPCyUKwHYdGg3xNsj0HsKiRT/4IxxQitOVejudamzQ
 TI+VkNJUaSLcZ2xux5ZSCXLEqDrF4AvRuUKsAAVIye6UWOb9afBZH0yCJmgxJm/hrVL8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=i4RVxh7cqcfhStKnrFuIVUqPlurNIlyMZ1NDN212nv0=; b=F4qNfwCFrI4Zdo+hUCR4x7JKOQ
 AVOaYkWy6yld2HgFhRnzpKmIxTTKvpz9DeO7n85Dc5hjB3aKBHg7ssO7WGP7VlAHhpzYLtux5uNXS
 TcNOzhe+fdGP6TxIOI756Fbw1Efc3YF6IMgibkniYO51k09KyjE3czT+qKZnl2ZS0NlU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=i4RVxh7cqcfhStKnrFuIVUqPlurNIlyMZ1NDN212nv0=; b=m9OaeC94Czmbb5hPBahN8SXBqI
 HNi7Mt4xq8QD0KfNROKtIz4cWo24dWSBz7X8e50X0RB4sQ5tkio4jz+r4r8ZXafkW2ww175yxfozT
 NCUZO2qzsSFjl3BFFlIRN3Wfa2mzIAi3PGZkD8Cd957ycv8VcxS6B+Gl86ETq6tCRKfhACSRqvwK7
 ZdYNXIQB/XHcCPAEwZsU/ppTsd8l/Kd7bPks6ODFCghe5WMh0L9iLVh6NfcG8q01AnZzhLKiyX/4B
 4MY4Wr/7eVJVJE1UTa4EMeC4cbXZti0JxzrFZGHMr43Ix5mWyHHev/cZbWwF9pp4HCsk18N+iH6el
 wjXcrqPw==;
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
log or RT device goes away instead of duplicating the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d5042419ed9997..338eba71ff8667 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -377,17 +377,6 @@ xfs_setup_dax_always(
 	return 0;
 }
 
-static void
-xfs_bdev_mark_dead(
-	struct block_device	*bdev)
-{
-	xfs_force_shutdown(bdev->bd_holder, SHUTDOWN_DEVICE_REMOVED);
-}
-
-static const struct blk_holder_ops xfs_holder_ops = {
-	.mark_dead		= xfs_bdev_mark_dead,
-};
-
 STATIC int
 xfs_blkdev_get(
 	xfs_mount_t		*mp,
@@ -396,8 +385,8 @@ xfs_blkdev_get(
 {
 	int			error = 0;
 
-	*bdevp = blkdev_get_by_path(name, BLK_OPEN_READ | BLK_OPEN_WRITE, mp,
-				    &xfs_holder_ops);
+	*bdevp = blkdev_get_by_path(name, BLK_OPEN_READ | BLK_OPEN_WRITE,
+				    mp->m_super, &fs_holder_ops);
 	if (IS_ERR(*bdevp)) {
 		error = PTR_ERR(*bdevp);
 		xfs_warn(mp, "Invalid device [%s], error=%d", name, error);
@@ -412,7 +401,7 @@ xfs_blkdev_put(
 	struct block_device	*bdev)
 {
 	if (bdev)
-		blkdev_put(bdev, mp);
+		blkdev_put(bdev, mp->m_super);
 }
 
 STATIC void
-- 
2.39.2
