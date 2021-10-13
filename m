From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/29] target/iblock: use bdev_nr_sectors instead
	of open coding it
Date: Wed, 13 Oct 2021 07:10:20 +0200
Message-ID: <20211013051042.1065752-8-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-ext4@vger.kernel.org, Kees Cook <keescook@chromium.org>, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, linux-block@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lis

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_iblock.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 31df20abe141f..ab7f5678ebc44 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -232,8 +232,9 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 	struct block_device *bd,
 	struct request_queue *q)
 {
-	unsigned long long blocks_long = (div_u64(i_size_read(bd->bd_inode),
-					bdev_logical_block_size(bd)) - 1);
+	loff_t size = bdev_nr_sectors(bd) << SECTOR_SHIFT;
+	unsigned long long blocks_long =
+		div_u64(size, bdev_logical_block_size(bd)) - 1;
 	u32 block_size = bdev_logical_block_size(bd);
 
 	if (block_size == dev->dev_attrib.block_size)
-- 
2.30.2
