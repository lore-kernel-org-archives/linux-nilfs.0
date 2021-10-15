From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/30] pstore/blk: use bdev_nr_bytes instead of
	open coding it
Date: Fri, 15 Oct 2021 15:26:34 +0200
Message-ID: <20211015132643.1621913-22-hch@lst.de>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org, reiserfs-devel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-ext4@vger.kernel.org, Kees Cook <keescook@chromium.org>, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, linux-block@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, Jan Kara <ja>

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/pstore/blk.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/pstore/blk.c b/fs/pstore/blk.c
index 04ce58c939a0b..5d1fbaffd66a1 100644
--- a/fs/pstore/blk.c
+++ b/fs/pstore/blk.c
@@ -205,7 +205,6 @@ static ssize_t psblk_generic_blk_write(const char *buf, size_t bytes,
 static int __register_pstore_blk(struct pstore_device_info *dev,
 				 const char *devpath)
 {
-	struct inode *inode;
 	int ret = -ENODEV;
 
 	lockdep_assert_held(&pstore_blk_lock);
@@ -217,14 +216,13 @@ static int __register_pstore_blk(struct pstore_device_info *dev,
 		goto err;
 	}
 
-	inode = file_inode(psblk_file);
-	if (!S_ISBLK(inode->i_mode)) {
+	if (!S_ISBLK(file_inode(psblk_file)->i_mode)) {
 		pr_err("'%s' is not block device!\n", devpath);
 		goto err_fput;
 	}
 
-	inode = I_BDEV(psblk_file->f_mapping->host)->bd_inode;
-	dev->zone.total_size = i_size_read(inode);
+	dev->zone.total_size =
+		bdev_nr_bytes(I_BDEV(psblk_file->f_mapping->host));
 
 	ret = __register_pstore_device(dev);
 	if (ret)
-- 
2.30.2
