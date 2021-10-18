From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/30] reiserfs: use bdev_nr_bytes instead of open coding it
Date: Mon, 18 Oct 2021 12:11:22 +0200
Message-ID: <20211018101130.1838532-23-hch@lst.de>
References: <20211018101130.1838532-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JMPu+LENDBo5WUsA2GqtbBEG8Jw1OQsq2zrbWWP5Nwo=; b=LQSSZHMv2uVXfonRxRFX6ja6Oh
        eGRR3MNc1mGAQBs0DNyB1vRYImhOqowRmW7fyj72Thmu4pztEMuT8Sh29JBnr+5bFD5P4IVg/pf0I
        P/8IZtD68Tkv0tkuMKJyC/vOClkagcPllgq5l50/K8TpSSATx/V1h7/rHZsD/dE9ctisbuJUZr4PX
        /tn3a6rHsJivMC/Uk5TS1tifDMdYjU88x7OQ3LcwR5/i122NQR+WSmrzpiUcIcd/t8I+lkXLk6PxB
        qnF6M1SKLWCal6TQdjpgSU8sythC3yyy5ViLBJ+ETNWQbNUzHrxG//gf79BsT7p8S4G9ZZlzrekoX
        emqLZz4w==;
In-Reply-To: <20211018101130.1838532-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.or

Use the proper helper to read the block device size and remove two
cargo culted checks that can't be false.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 fs/reiserfs/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 58481f8d63d5b..8647a00434ea4 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1986,9 +1986,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	 * smaller than the filesystem. If the check fails then abort and
 	 * scream, because bad stuff will happen otherwise.
 	 */
-	if (s->s_bdev && s->s_bdev->bd_inode
-	    && i_size_read(s->s_bdev->bd_inode) <
-	    sb_block_count(rs) * sb_blocksize(rs)) {
+	if (bdev_nr_bytes(s->s_bdev) < sb_block_count(rs) * sb_blocksize(rs)) {
 		SWARN(silent, s, "", "Filesystem cannot be "
 		      "mounted because it is bigger than the device");
 		SWARN(silent, s, "", "You may need to run fsck "
-- 
2.30.2

