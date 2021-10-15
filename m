From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/30] fs: simplify init_page_buffers
Date: Fri, 15 Oct 2021 15:26:23 +0200
Message-ID: <20211015132643.1621913-11-hch@lst.de>
References: <20211015132643.1621913-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Yh+z+whkMCjXlGfSieTjzpMbNq/jpmSmFhhD2XKG2/0=; b=ufR+oXnZuQvJgeVKMr8H0co3Mg
        i7geZsH7y+5rg0Wg3e1JCutjGsBL0goE4q7Eh9Nb3L7sQR0wIPeMI1YPQCqESX75rm9E2X8hg+P4G
        WqxJbnRltcP6itHciQBjz9EUzeGVUcUZ4BmC2sD6+Cow7+Abn7zZE2gMMlIPhVT4c9UvdKu5F5fkR
        wQj71rmTJYvPF8wQsvQa3m6oGZzUUFK+4QI/zCV+STDd+BXLuNzxWvQpSNB11EVgDxRGZ41YzSL+O
        D+OHRqGjODpbEDYkXt02HqmhVZjAA1F2vXyiVfc/loXWKT+FL+8DXlR6d84sU5HWhzqKeRjPwKCyj
        pN1P6Yfw==;
In-Reply-To: <20211015132643.1621913-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.or

No need to convert from bdev to inode and back.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 156358977249f..46bc589b7a03c 100644
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

