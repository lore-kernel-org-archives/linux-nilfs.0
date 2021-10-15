From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/30] hfs: use bdev_nr_sectors instead of open coding it
Date: Fri, 15 Oct 2021 15:26:28 +0200
Message-ID: <20211015132643.1621913-16-hch@lst.de>
References: <20211015132643.1621913-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nOP5ubv8zHIPTFPGGp4mMR4qIBoLNo6J7j7POF84hxo=; b=qKV/HQkSdb71XgYHqm/d8IlV83
        zq9Sgh/XebiPRhWgZRsfR2hbSs2vAEpMEvHXOarf9oJpF7yQ2qvJ4Fd0FXSi7JyRlbcMB5P8CvUZl
        dJoxasGKB/2vzhCsm1WF0QmjonOmViJ8kHtgkolya2No1zo/Mh4c+PvClUZQj0w3cjRCD/Z+fngaH
        njezPXjDF4DYZv+/9qSpeIlcqmLTlO6g3JvfIAe9gJSAstRYZSivMPYmr5M7IV8OIuyVOFA2ZE9Mo
        h/gv4o9IQ0Eu79uDH2vEQA+mDZ10yJGCHryClcpqJX4dp1uw6ySNJgXSxfQX76ZFxxueW0CMUjMTP
        PNbNhViA==;
In-Reply-To: <20211015132643.1621913-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.or

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
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

