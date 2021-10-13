From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/29] fat: use bdev_nr_sectors instead of open coding it
Date: Wed, 13 Oct 2021 07:10:26 +0200
Message-ID: <20211013051042.1065752-14-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vexCFEOI/ei3isdU+2cR9MEkkZh1w9b+BJVWLureADk=; b=vhGTDXj0ONPOGVEPoja9/Oi8cq
        wtlvbbL0y4wdHwGEkbL+4zbydA1FRxXOj8/u5FHt74LZtp2sb+HKJ0Jqop0oSJkzM5RFXLNmbrcZb
        nUjdvT4SZwdLInBISCMwR07cpKhLE2p//l0tPnuDoF3ced3Iv3qz+z/cgEHfxJcSxwQuN563IYFJQ
        Pk/ERQGmtCyYjIujw/6y2zcBM+LAJPjF1tvrgZuM1HoI+CVjCzgbRz3v02U1oZw6KmD5tvDQvKL3q
        i4+CmF4acXWDpq/V+F/RCRaY/NA7dvxmux0sQzjesAzadbivOEvx6pVBJyRXtykGYTtxVPnQwixLZ
        pQCR1gfg==;
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fat/inode.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index de0c9b013a851..9f3cd03668adc 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1536,14 +1536,11 @@ static int fat_read_static_bpb(struct super_block *sb,
 	struct fat_bios_param_block *bpb)
 {
 	static const char *notdos1x = "This doesn't look like a DOS 1.x volume";
-
+	sector_t bd_sects = bdev_nr_sectors(sb->s_bdev);
 	struct fat_floppy_defaults *fdefaults = NULL;
 	int error = -EINVAL;
-	sector_t bd_sects;
 	unsigned i;
 
-	bd_sects = i_size_read(sb->s_bdev->bd_inode) / SECTOR_SIZE;
-
 	/* 16-bit DOS 1.x reliably wrote bootstrap short-jmp code */
 	if (b->ignored[0] != 0xeb || b->ignored[2] != 0x90) {
 		if (!silent)
-- 
2.30.2

