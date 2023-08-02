From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/12] ext4: drop s_umount over opening the log
 device
Date: Wed,  2 Aug 2023 17:41:28 +0200
Message-ID: <20230802154131.2221419-10-hch@lst.de>
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
 bh=9z6iRUB0HpEH9yVJZ8SKsjwqR2QNW5zkViH5X/SDjhI=; b=jcrNyCaZSW9dN8GoB6PD7zdMKk
 MLmnPMGvOQcVMBxuVfN+0KzKd126rGoVh0Vwoa3KdiqN8JqIfDJHnfwF9O+MvcIxK61q7/yHnbXcB
 aNEi4/MBcugwOFFkXbZfw5LGnX/0BKQibgc5ZL/MfgJdC0PfsMxIn1Vii5+vfapDYWj8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=9z6iRUB0HpEH9yVJZ8SKsjwqR2QNW5zkViH5X/SDjhI=; b=CyKmG06GVRxSLZOHD0STatK6f0
 YGWdHHczM9E3ZRh+Ml6B9etjhm+zNwZ2U3hTnU3U9aogl0SewBxGwS8xhwtbInI8nawNRSSiPd9SD
 ssIgcXcIF+hqWIjpkj0xa999K+H2PEEYNaGcyzGLA/s5aiQsicxXIfcDL6oAbpftCFwg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=9z6iRUB0HpEH9yVJZ8SKsjwqR2QNW5zkViH5X/SDjhI=; b=i+HYYGUwVQd0cBogaXIV5vo/pL
 zWblj0H6yG//E5OamCxdVKjjA+loZfVwsPHotijZMYyONUsXn+hTKEPyxDUrHsRUHCyDEzKsicFlq
 duF5vCrFzEbsPWaI2grnR07yMIRV3pbVI/44jrUI4J6B4XHIeW+91ZQBEGfYVI9o+NZeD/XBGRQP6
 o03BDUtDrFgof5bL0lrd7JoHdf7A7vgTEDPlp/C4wUx9XWGAuylz3IICKc7G/ZBWEMNj+Ucoc47ZZ
 BcPdWnYJZX9Eb6u3srXrOnd8/GtwLWAbFSXxE0MVQIBm2dAmvbZaDYkJWjeg771VMhLIIxgUqbssB
 Om0i9bfQ==;
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

Just like get_tree_bdev needs to drop s_umount when opening the main
device, we need to do the same for the ext4 log device to avoid a
potential lock order reversal with s_unmount for the mark_dead path.

It might be preferable to just drop s_umount over ->fill_super entirely,
but that will require a fairly massive audit first, so we'll do the easy
version here first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext4/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 193d665813b611..2ccb19d345c6dd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5854,7 +5854,10 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	if (WARN_ON_ONCE(!ext4_has_feature_journal(sb)))
 		return NULL;
 
+	/* see get_tree_bdev why this is needed and safe */
+	up_write(&sb->s_umount);
 	bdev = ext4_blkdev_get(j_dev, sb);
+	down_write(&sb->s_umount);
 	if (bdev == NULL)
 		return NULL;
 
-- 
2.39.2
