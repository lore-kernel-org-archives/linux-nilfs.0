From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/29] squashfs: use bdev_nr_sectors instead of open coding it
Date: Wed, 13 Oct 2021 07:10:35 +0200
Message-ID: <20211013051042.1065752-23-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=B7QUfk1V5g8os83d9H1pzKVS9Wky59aiatgX6MLOno0=; b=CuLaz4HX5JZzaiVl+rrp1XndWm
        e85pf4KU0S4KS7k7a+Wkegm4zhjEcCEdUBRwtldyb4HFr1gr6lgjLQj5gR2x0k9qZ9N9Fi8WCz2xT
        8lNfgQhpAFUxT3Ufk/vyJR4YsqVM6aNVMZAfOHIMxlln4kh1U5jQB+VQARv68hhX7otTu4X5BswHz
        cDJoWPnUZvJYLvt/R4l57Ff41h5Bq0YtrIJd4PJZIkxEo6zcABBBk3oC13aDY8YQSnJFo4HO1M+Jv
        hM3ZRc3MS/f9El5do1DMz2+5eS1XxDW0umV7kD9UxXVALr22ThZ0cfVN+QmtRS3JTKFR+4iWuZfuY
        nidJqMvw==;
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/squashfs/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 60d6951915f44..e83042ecf0d86 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -16,6 +16,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/blkdev.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
@@ -179,8 +180,8 @@ static int squashfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	/* Check the filesystem does not extend beyond the end of the
 	   block device */
 	msblk->bytes_used = le64_to_cpu(sblk->bytes_used);
-	if (msblk->bytes_used < 0 || msblk->bytes_used >
-			i_size_read(sb->s_bdev->bd_inode))
+	if (msblk->bytes_used < 0 ||
+	    msblk->bytes_used > (bdev_nr_sectors(sb->s_bdev) << SECTOR_SHIFT))
 		goto failed_mount;
 
 	/* Check block size for sanity */
-- 
2.30.2

