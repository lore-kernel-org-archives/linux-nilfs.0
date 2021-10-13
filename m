From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/29] hfs: use bdev_nr_sectors instead of open coding it
Date: Wed, 13 Oct 2021 07:10:27 +0200
Message-ID: <20211013051042.1065752-15-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ThhwJoeorMicfGUoJpj8bDFZXXZ2Sru2bDJViO7vTu8=; b=LCiRvxWM1CTaMWKxh92Deomiwf
        AY9T2YY1wAWxayl0vHnI1Q7mpxaX7UvIsbVjgD5F5J0/8Qm83whK+tQBPPPd8pmhB0O4eGWD4XqfT
        c51RkGegU087jx0bEhd8pTkptR/xVbI1krXiYhhsCMIgD4nHHZeeyW9HDn7opQL1nNlHC+MWFxmZj
        O53LeicK40qW4KmNGbDlJiMfRDGAw1iqHT+q8MOwN7FIAQVaGPNnSrsAg3Oezji+43Uw1qYjdH5Lx
        A2knf7KchBs3lZTE5z1hpj3gY1+JYG/FFOQsWofs+2X44MCi4XFeV63rKedqfr82Gv2DcvsEarZbm
        idOFCkQg==;
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/hfs/mdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index cdf0edeeb2781..5beb826524354 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -36,7 +36,7 @@ static int hfs_get_last_session(struct super_block *sb,
 
 	/* default values */
 	*start = 0;
-	*size = i_size_read(sb->s_bdev->bd_inode) >> 9;
+	*size = bdev_nr_sectors(sb->s_bdev);
 
 	if (HFS_SB(sb)->session >= 0) {
 		struct cdrom_tocentry te;
-- 
2.30.2

