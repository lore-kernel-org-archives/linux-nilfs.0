From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: remove double bio_put() in nilfs_end_bio_write()
 for BIO_EOPNOTSUPP error
Date: Mon, 22 Jul 2013 12:02:14 +0400
Message-ID: <1374480134.5175.6.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=ZJeSzgGJsGGOwmMk2LFvJ22S5iGKegqQ26RN1nvil6w=;
	b=I00RavEZ+gAKF3sC9jv3vkMuejSUaRZqQB9To0yFCcrTDPVnxMrvSPuoBP9ayu7JgH1FJEu7DNWf/xFJoSyAg+BdRuNH3KNdlvYUPiy94HAHr+1cyRkR/RqmXd8fpEKD;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, DanCarpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error

This patch removes double call of bio_put() in nilfs_end_bio_write()
for the case of BIO_EOPNOTSUPP error detection. The issue was found
by Dan Carpenter and he suggests first version of the fix too.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
