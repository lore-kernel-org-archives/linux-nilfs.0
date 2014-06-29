From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: fix issue with potential infinite loop in
 nilfs_mdt_get_block()
Date: Sun, 29 Jun 2014 17:36:50 +0400
Message-ID: <1404049010.4139.17.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=LpfEPwrbCIaX7H5RAAnzIxSK5seLyikBZVPn4Q13YRs=;
	b=BiG/fpFZB3WwBUdz3srJAG1Qu8zNTZoaOmRPoAUdZCcrrHk9byU55g1yvpr+sRJvmSMtRK6SFVCeCGtygNXbfySnnz12YUopJuLdlPNcjzouNJ4xgRpJbDoALt2D9r4K;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
Subject: [PATCH] nilfs2: fix issue with potential infinite loop in nilfs_mdt_get_block()

Potentially, there are situations when nilfs_mdt_read_block() can
return -ENOENT and nilfs_mdt_create_block() can return -EEXIST.
Such situation results in infinite loop inside nilfs_mdt_get_block()
method. This patch fixes issue with potential infinite loop in
nilfs_mdt_get_block() by means of uncomment limitation of read-create
loop retries.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index c4dcd1d..d1e121f 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -254,7 +254,7 @@ int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
 
 	ret = nilfs_mdt_create_block(inode, blkoff, out_bh, init_block);
 	if (unlikely(ret == -EEXIST)) {
-		/* create = 0; */  /* limit read-create loop retries */
+		create = 0;  /* limit read-create loop retries */
 		goto retry;
 	}
 	return ret;
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
