From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [RFC] nilfs2: double bio_put() in nilfs_end_bio_write()
Date: Fri, 19 Jul 2013 12:26:03 +0300
Message-ID: <20130719092603.GB22147@longonot.mountain>
Mime-Version: 1.0
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, kernel-janitors@vger.kernel.org

I don't know if this is correct or not, but if feels like we shouldn't
be calling bio_put() twice in nilfs_end_bio_write().  Also the comment
is out of date.  If this is correct then I can resend with a proper
Signed-off-by line and everything.

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index dc9a913..a660fd7 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -346,7 +346,8 @@ static void nilfs_end_bio_write(struct bio *bio, int err)
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
 		bio_put(bio);
-		/* to be detected by submit_seg_bio() */
+		/* to be detected by nilfs_segbuf_submit_bio() */
+		return;
 	}
 
 	if (!uptodate)
