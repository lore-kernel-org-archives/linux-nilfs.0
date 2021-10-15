From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/30] affs: use bdev_nr_sectors instead of open coding it
Date: Fri, 15 Oct 2021 15:26:24 +0200
Message-ID: <20211015132643.1621913-12-hch@lst.de>
References: <20211015132643.1621913-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4+4aho7Od7CaYcuq9D5nzrbKD6dBz8xE3WUEnLiAMa8=; b=njF1lec5ToI1mF57nm85IhKdj0
        R4hMIfun9fY3BAXnq2O3pwjWa9Yt+TLx9N+CKb+hbwwZsb7BmEGSKJ+y+JTe0PuviO7YsVgzHDBMq
        P+X5kEL75/uDtXbzZ9PYeumMpGPAXVPmL/a9Mk4lggk1lRinjRoJOvH4G1BQkSuxqrKWXzzb0vuee
        vkFF60DWx0p4PiABO9m18Mk+Wmr08nwkEtbxYJmdqxY8PBsUn4OfwqpSFFwThqis0kY8xJmmNWq9s
        LrfzgH4Wt8+bIkiFrGPQNv8u0vdWAxRq5WmN2xGi+vF1lijX5TkCen4UBOXbvs7MGTvHtep/9pzQ9
        ZQXXo4MA==;
In-Reply-To: <20211015132643.1621913-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 fs/affs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index c6c2a513ec92d..c609005a9eaaa 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -389,7 +389,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	 * blocks, we will have to change it.
 	 */
 
-	size = i_size_read(sb->s_bdev->bd_inode) >> 9;
+	size = bdev_nr_sectors(sb->s_bdev);
 	pr_debug("initial blocksize=%d, #blocks=%d\n", 512, size);
 
 	affs_set_blocksize(sb, PAGE_SIZE);
-- 
2.30.2

