From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 29/29] udf: use sb_bdev_nr_blocks
Date: Wed, 13 Oct 2021 07:10:42 +0200
Message-ID: <20211013051042.1065752-30-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TLmI0Wv2QuwTWKBKyulZhpN/vG7+mutYGLwxwgtoXSU=; b=WG8Sbg76bIW/yFBrJU86scHxmB
        tj+o1s5xOwVjUkYsXQFA8NmHfhnJwwaWJwjP+r1wXVQx214Bu5mkSO0cnUvyTy7E6klSuqDUN5PnX
        x2skyeaIa4Zny3ZhUi4dsqV7v/AEXhtmmy9TqFuy6SaNhye8NE4GJpnf/1LIrNUgZsGsJCAcJ+Qkb
        at3Q9xMyln1HuzfuN1yoPpTaOv97nku/4U0s7pvsASpFrwPn0fmvo5SckwMXBxbSnzLWfsjd2LPUt
        y8N6iG7/cisaWdsG1ZZS+Gkq0w1DlP57EQoNcgAt+I5E6TJ46kikGMDRB6WHLi29xlzECjDxbkxA0
        QrBrh9Nw==;
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.or

Use the sb_bdev_nr_blocks helper instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/udf/lowlevel.c | 5 ++---
 fs/udf/super.c    | 9 +++------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/udf/lowlevel.c b/fs/udf/lowlevel.c
index f1094cdcd6cde..46d6971721975 100644
--- a/fs/udf/lowlevel.c
+++ b/fs/udf/lowlevel.c
@@ -47,8 +47,7 @@ unsigned int udf_get_last_session(struct super_block *sb)
 
 unsigned long udf_get_last_block(struct super_block *sb)
 {
-	struct block_device *bdev = sb->s_bdev;
-	struct cdrom_device_info *cdi = disk_to_cdi(bdev->bd_disk);
+	struct cdrom_device_info *cdi = disk_to_cdi(sb->s_bdev->bd_disk);
 	unsigned long lblock = 0;
 
 	/*
@@ -56,7 +55,7 @@ unsigned long udf_get_last_block(struct super_block *sb)
 	 * Try using the device size...
 	 */
 	if (!cdi || cdrom_get_last_written(cdi, &lblock) || lblock == 0)
-		lblock = i_size_read(bdev->bd_inode) >> sb->s_blocksize_bits;
+		lblock = sb_bdev_nr_blocks(sb);
 
 	if (lblock)
 		return lblock - 1;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index b2d7c57d06881..34247fba6df91 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1175,8 +1175,7 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 	struct udf_inode_info *vati;
 	uint32_t pos;
 	struct virtualAllocationTable20 *vat20;
-	sector_t blocks = i_size_read(sb->s_bdev->bd_inode) >>
-			  sb->s_blocksize_bits;
+	sector_t blocks = sb_bdev_nr_blocks(sb);
 
 	udf_find_vat_block(sb, p_index, type1_index, sbi->s_last_block);
 	if (!sbi->s_vat_inode &&
@@ -1838,8 +1837,7 @@ static int udf_check_anchor_block(struct super_block *sb, sector_t block,
 	int ret;
 
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_VARCONV) &&
-	    udf_fixed_to_variable(block) >=
-	    i_size_read(sb->s_bdev->bd_inode) >> sb->s_blocksize_bits)
+	    udf_fixed_to_variable(block) >= sb_bdev_nr_blocks(sb))
 		return -EAGAIN;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1901,8 +1899,7 @@ static int udf_scan_anchors(struct super_block *sb, sector_t *lastblock,
 		last[last_count++] = *lastblock - 152;
 
 	for (i = 0; i < last_count; i++) {
-		if (last[i] >= i_size_read(sb->s_bdev->bd_inode) >>
-				sb->s_blocksize_bits)
+		if (last[i] >= sb_bdev_nr_blocks(sb))
 			continue;
 		ret = udf_check_anchor_block(sb, last[i], fileset);
 		if (ret != -EAGAIN) {
-- 
2.30.2

