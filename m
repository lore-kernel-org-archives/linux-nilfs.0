From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 27/29] ntfs: use sb_bdev_nr_blocks
Date: Wed, 13 Oct 2021 07:10:40 +0200
Message-ID: <20211013051042.1065752-28-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Vyix3XnNewPbitJtfxF/KE3HcfFXjFKv1GQk4gXWQ44=; b=mS1vt9+lp4Lk5R6YaPr1obdBn8
        KoEmy3QGJkuDO5yqPjhbR2J6Y35wEBEx8L5h9ZFgVQGwQaJVnKOWe00E5WMgbx6SiqwFYRAXFMn3J
        npt+6QLZlLwFvVR2v4KRrRgZG/4tt+JsTBw549Rr6Qu21s4AJfCFL4rxxUh/P/4+ffzWAm/mMSBEw
        8prgiYz3jDLt51CC4UGDhhFsOik5puVVqqy52XwRoA6a4eOU6py0UFQtBhDl0fBFb1oAV3VWTCZzX
        5envLujGqZwrf69wZIkPd1uI+Me9ct8DV8azTzowHCLdhU5yRQUcp6Aq+qpbw3sHXrCNRreTeerNW
        vSIb/OXg==;
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.or

Use the sb_bdev_nr_blocks helper instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ntfs/super.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 0d7e948cb29c9..5ae8de09b271b 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2772,13 +2772,12 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 	ntfs_debug("Set device block size to %i bytes (block size bits %i).",
 			blocksize, sb->s_blocksize_bits);
 	/* Determine the size of the device in units of block_size bytes. */
-	if (!i_size_read(sb->s_bdev->bd_inode)) {
+	vol->nr_blocks = sb_bdev_nr_blocks(sb);
+	if (!vol->nr_blocks) {
 		if (!silent)
 			ntfs_error(sb, "Unable to determine device size.");
 		goto err_out_now;
 	}
-	vol->nr_blocks = i_size_read(sb->s_bdev->bd_inode) >>
-			sb->s_blocksize_bits;
 	/* Read the boot sector and return unlocked buffer head to it. */
 	if (!(bh = read_ntfs_boot_sector(sb, silent))) {
 		if (!silent)
@@ -2816,8 +2815,7 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 			goto err_out_now;
 		}
 		BUG_ON(blocksize != sb->s_blocksize);
-		vol->nr_blocks = i_size_read(sb->s_bdev->bd_inode) >>
-				sb->s_blocksize_bits;
+		vol->nr_blocks = sb_bdev_nr_blocks(sb);
 		ntfs_debug("Changed device block size to %i bytes (block size "
 				"bits %i) to match volume sector size.",
 				blocksize, sb->s_blocksize_bits);
-- 
2.30.2

