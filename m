From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/30] ntfs3: use bdev_nr_bytes instead of open coding it
Date: Mon, 18 Oct 2021 12:11:20 +0200
Message-ID: <20211018101130.1838532-21-hch@lst.de>
References: <20211018101130.1838532-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=7vy0+8EI8WhVCxcCPpT3E3xZPAv/h7863mIj0HITKC4=; b=dSgrFBalcG5IC5gy8leFi0/QUI
        8jbCvHeQvsAMp2Vc8XaJNgaFomPjUZxHYyC0Lr8ip+cEGSd3e9dOsE9BLDAOXLiIxKskzuJNVL/fJ
        9/vz7wC6aJeWCOa866cMrDClVUyh/nPJwEgGnkT7aSULX7H/Rx0e6fz/pzjosefYz2bVFgXRlecrl
        OK92p3ALP6pCTMlkZ3qBMnoKoRHEVAF7nq96GJlCV7bX4ForSv41tAleJNCMrpQJckjzxO/kA47Wn
        OAc86dc6jd8RmrmIqLhJBcqnOCCDYnNAaZzrQ6Qs4EG0Do8+0MqgT7yVBLcb6ir4m1vlBzJoKJsMs
        +PeH0mvg==;
In-Reply-To: <20211018101130.1838532-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ntfs3/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 55bbc9200a10e..7ed2cb5e8b1d9 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -918,7 +918,6 @@ static int ntfs_fill_super(struct super_block *sb, void *data, int silent)
 	int err;
 	struct ntfs_sb_info *sbi;
 	struct block_device *bdev = sb->s_bdev;
-	struct inode *bd_inode = bdev->bd_inode;
 	struct request_queue *rq = bdev_get_queue(bdev);
 	struct inode *inode = NULL;
 	struct ntfs_inode *ni;
@@ -967,7 +966,7 @@ static int ntfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Parse boot. */
 	err = ntfs_init_from_boot(sb, rq ? queue_logical_block_size(rq) : 512,
-				  bd_inode->i_size);
+				  bdev_nr_bytes(bdev));
 	if (err)
 		goto out;
 
-- 
2.30.2

