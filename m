From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/30] cramfs: use bdev_nr_bytes instead of open coding it
Date: Mon, 18 Oct 2021 12:11:13 +0200
Message-ID: <20211018101130.1838532-14-hch@lst.de>
References: <20211018101130.1838532-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mHbLY10hNejy/Eg6myZDAE3lqLMvy+937hMxKRWnYHI=; b=lVSE9QbkkoQXxeiFzmYuOXkVzc
        tp8w5cqd9YoUYaFy5SS//Pl+dSXRQ858H01p3jjW3ZspETzTE9+tAJqy+TqxTKpVvwZCPYHMgYmZ0
        rLROFlKO3jLsHulgEWrW2lwwlerQZWnzw55Y5e0PNjG+msn7paVDEAzRRmQmdRlatzDlsISotUjAa
        FNG7mmz/tMs5EueSrUxn68Z6+4sN5Q3uHV3z/o99dybNhaOz+o/dXNMW7qATq2iZ0aSdjA4v3CvgV
        sVCXDnMBr3/xsUYOn5O01oB/n52uGNo+ikYPYJbXz1IJOc0rhnam7i9Hvi1kuJoq9MYrwXE6RWQyg
        rWKKUS8A==;
In-Reply-To: <20211018101130.1838532-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 fs/cramfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 2be65269a987c..666aa380011e0 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -209,7 +209,7 @@ static void *cramfs_blkdev_read(struct super_block *sb, unsigned int offset,
 		return read_buffers[i] + blk_offset;
 	}
 
-	devsize = mapping->host->i_size >> PAGE_SHIFT;
+	devsize = bdev_nr_bytes(sb->s_bdev) >> PAGE_SHIFT;
 
 	/* Ok, read in BLKS_PER_BUF pages completely first. */
 	for (i = 0; i < BLKS_PER_BUF; i++) {
-- 
2.30.2

