From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 30/30] udf: use sb_bdev_nr_blocks
Date: Fri, 15 Oct 2021 15:26:43 +0200
Message-ID: <20211015132643.1621913-31-hch@lst.de>
References: <20211015132643.1621913-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20211015132643.1621913-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org, reiserfs-devel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-ext4@vger.kernel.org, Kees Cook <keescook@chromium.org>, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, linux-block@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sou

Use the sb_bdev_nr_blocks helper instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jan Kara <jack@suse.cz>
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
