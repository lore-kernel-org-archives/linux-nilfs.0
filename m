From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/30] hfsplus: use bdev_nr_sectors instead of open coding it
Date: Mon, 18 Oct 2021 12:11:16 +0200
Message-ID: <20211018101130.1838532-17-hch@lst.de>
References: <20211018101130.1838532-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Y/n231v6mya+HLQ5553wYpz7337dsR2Clc1g640C0Nc=; b=SCcF5DiQPtaryC8amaczOmgHaE
        EWl+pclINoiVWjiFCEJTcUQty+0UJDH3If97VwAzA56GdzMXjmUVYq0tZT4P4MLFmaQB1bQ2izaeP
        YIItZQNSyFH3kgZvt4cmrVPksL8l8dxWqgYHClJSHI1toZACMqIdpvbMEZHP7B9bUYFuuO0zTP08q
        EZaz+7U8UqJWANDcHETl8ZQVzoaKg+cIte8Qc2VSKthKmsgqIn0x5au5NGmOyErKVbsM3M1MwlrMW
        UKP1IF81u09Jm1W7i2MknZYPp85pQdssf21yzAio0Zgpcii7ZDbgQ74NHj/NkGQaAW0fixaEguw6L
        SVvqXYvw==;
In-Reply-To: <20211018101130.1838532-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 fs/hfsplus/wrapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 0350dc7821bf9..51ae6f1eb4a55 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -131,7 +131,7 @@ static int hfsplus_get_last_session(struct super_block *sb,
 
 	/* default values */
 	*start = 0;
-	*size = i_size_read(sb->s_bdev->bd_inode) >> 9;
+	*size = bdev_nr_sectors(sb->s_bdev);
 
 	if (HFSPLUS_SB(sb)->session >= 0) {
 		struct cdrom_tocentry te;
-- 
2.30.2

