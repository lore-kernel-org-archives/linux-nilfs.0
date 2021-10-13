From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/29] fs: simplify init_page_buffers
Date: Wed, 13 Oct 2021 07:10:22 +0200
Message-ID: <20211013051042.1065752-10-hch@lst.de>
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

No need to convert from bdev to inode and back.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 3fb9c5b457ab6..ef1fe4f77a952 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -897,7 +897,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
 	struct buffer_head *head = page_buffers(page);
 	struct buffer_head *bh = head;
 	int uptodate = PageUptodate(page);
-	sector_t end_block = blkdev_max_block(I_BDEV(bdev->bd_inode), size);
+	sector_t end_block = blkdev_max_block(bdev, size);
 
 	do {
 		if (!buffer_mapped(bh)) {
-- 
2.30.2
