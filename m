From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/29] reiserfs: use bdev_nr_sectors instead of open coding it
Date: Wed, 13 Oct 2021 07:10:34 +0200
Message-ID: <20211013051042.1065752-22-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=neY9ZJPH9MOzXmChpQoZ9vtfCPorKJutFa1ekdF3DV4=; b=PfsnohEdvhV/ruqSbu6iivGJd0
        Zo3djyN81Xn383MmVLbTJS1kEa9ZCXS2mDK7N5D8NmAUj88uBINNyCVjbt3Hz2fQVnR03Zhjiq14G
        7zKHh2mUo689xTR7fXEhFyPZxgwKxVIRy1j43hJzInRINaWAIzmG5d6Ld0VmrNJ+Kq8r9BVg4Cbci
        R/3myVb4K7ohrxlSfIhxqYAmYvFKTO+S1ZDDBa/9e8IX/lkJ4nmXRD2lGIKarWEbMdpJEKTQye58o
        teu82AOgZQfEvAkdOov+/Ln7EN2g7QtqcBdIkCnPq14ddL0H7JCQgOHyHVTLPqcDo9HQcK5qlrTAA
        FSxta/Cg==;
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.or

Use the proper helper to read the block device size and remove two
cargo culted checks that can't be false.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/reiserfs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 58481f8d63d5b..6c9681e2809f0 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1986,8 +1986,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	 * smaller than the filesystem. If the check fails then abort and
 	 * scream, because bad stuff will happen otherwise.
 	 */
-	if (s->s_bdev && s->s_bdev->bd_inode
-	    && i_size_read(s->s_bdev->bd_inode) <
+	if ((bdev_nr_sectors(s->s_bdev) << SECTOR_SHIFT) <
 	    sb_block_count(rs) * sb_blocksize(rs)) {
 		SWARN(silent, s, "", "Filesystem cannot be "
 		      "mounted because it is bigger than the device");
-- 
2.30.2

