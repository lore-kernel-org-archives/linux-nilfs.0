From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v3 1/2] nilfs2: remove double bio_put() in
 nilfs_end_bio_write() for BIO_EOPNOTSUPP error
Date: Tue, 13 Aug 2013 17:50:33 +0400
Message-ID: <1376401833.2274.9.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=rvw8s8ppUFzin1Ne/kFXo5Jr2fhjVFRot7iU4TCLw5M=;
	b=YvK/vzvJel5SToa49i/f/kdkSSzAwl7X3fFVo5cfG/AyK9XrKgkIUeZSMw5y4zghtdMZn1BgBfTMqg9SKw0vnpyUZo6pvA8pvuAtsThsLMkZlrGTxHKp9OXFXeMTcXD4;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: DanCarpenter <dan.carpenter@oracle.com>, linux-nilfs@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, kernel-janitors@vger.kernel.org, akpm@linux-foundation.org

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v3 1/2] nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error

This patch removes double call of bio_put() in nilfs_end_bio_write()
for the case of BIO_EOPNOTSUPP error detection. The issue was found
by Dan Carpenter and he suggests first version of the fix too.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/segbuf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index dc9a913..5bacf46 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -345,8 +345,7 @@ static void nilfs_end_bio_write(struct bio *bio, int err)
 
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		bio_put(bio);
-		/* to be detected by submit_seg_bio() */
+		/* to be detected by nilfs_segbuf_submit_bio() */
 	}
 
 	if (!uptodate)
-- 
1.7.9.5



