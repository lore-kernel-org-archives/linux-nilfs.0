From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/30] nvmet: use bdev_nr_bytes instead of open coding it
Date: Mon, 18 Oct 2021 12:11:07 +0200
Message-ID: <20211018101130.1838532-8-hch@lst.de>
References: <20211018101130.1838532-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fFiyZJBuziQrITu6AwTrNzk8Coj3yxtnkFBgzy+4utY=; b=f1ZTns0vT6m845qkA0baYXk2PG
        ByKkbnJ+m6x5JEcOlt7OJK30pWXcBBAY2xcc1oOX/GlP+t0jufCSgL5H/v+FL2ep0WYs4CjBQ1ZvD
        lQG5Q7+G38xvKKRPiacPni83/F9CmBbksfoCmOynDY23d+ddtPSvZOtRc/6cK3nk51j7atKYi19r6
        Kag73b5r1mpakcbI/gVx0eS5fxTuecjZwPlCdUJUHarqJZdEd5rQWMGiN5zJahL6UlgGggT0wn6rZ
        vPA0cQ+2G72skx+/d7YG1mcJHEgaG8vk2XDNYrEfowDDgHBQKzmj5azhf7DDo48pGaGARYpawN4ej
        JsMT/KGQ==;
In-Reply-To: <20211018101130.1838532-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/target/io-cmd-bdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 6139e1de50a66..70ca9dfc1771a 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -87,7 +87,7 @@ int nvmet_bdev_ns_enable(struct nvmet_ns *ns)
 		ns->bdev = NULL;
 		return ret;
 	}
-	ns->size = i_size_read(ns->bdev->bd_inode);
+	ns->size = bdev_nr_bytes(ns->bdev);
 	ns->blksize_shift = blksize_bits(bdev_logical_block_size(ns->bdev));
 
 	ns->pi_type = 0;
@@ -108,7 +108,7 @@ int nvmet_bdev_ns_enable(struct nvmet_ns *ns)
 
 void nvmet_bdev_ns_revalidate(struct nvmet_ns *ns)
 {
-	ns->size = i_size_read(ns->bdev->bd_inode);
+	ns->size = bdev_nr_bytes(ns->bdev);
 }
 
 u16 blk_to_nvme_status(struct nvmet_req *req, blk_status_t blk_sts)
-- 
2.30.2

