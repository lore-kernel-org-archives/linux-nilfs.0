From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 28/29] reiserfs: use sb_bdev_nr_blocks
Date: Wed, 13 Oct 2021 07:10:41 +0200
Message-ID: <20211013051042.1065752-29-hch@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=o4h3siWCWbYazYK0Oyye0WCxhW+TPsSdCJyezg31K/s=; b=h/xz+HqR3T+2gdg8k2nNGkeFrh
        oBfn/pdJam7uwquPpri+uWckonTBJR+SPPwva6ojdH4VCTh9BjV8vKQKCGyPXU0dgqxxOBWFjziev
        PP0t0q4OWGrW7NaoepwV7XF78rE2jSee6S6dOoUwoWpD+2U/BptLWNNM8TnnqDuu3gnovgVWrwCPY
        NzqOyLaeLFL/gtHgcLPYk7oy122A48dL/MvYklpbYzsq1afBOR/LuKx8OP6d8BfPxgCzYKGpApyGA
        vkkxTaOCFuOQcwepWerxC/fBJk1clMLnCBsEwAZyLqtkz98WYOdIwjlim4YFIKx6YjNBxeikzaCtY
        u+K2EeIg==;
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.or

Use the sb_bdev_nr_blocks helper instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/reiserfs/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 6c9681e2809f0..b12baadb7e9bb 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1199,9 +1199,7 @@ static int reiserfs_parse_options(struct super_block *s,
 
 			if (!strcmp(arg, "auto")) {
 				/* From JFS code, to auto-get the size. */
-				*blocks =
-				    i_size_read(s->s_bdev->bd_inode) >> s->
-				    s_blocksize_bits;
+				*blocks = sb_bdev_nr_blocks(s);
 			} else {
 				*blocks = simple_strtoul(arg, &p, 0);
 				if (*p != '\0') {
-- 
2.30.2

