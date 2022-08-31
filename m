From: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH linux-next] nilfs2: Remove the unneeded result variable
Date: Wed, 31 Aug 2022 03:34:03 +0000
Message-ID: <20220831033403.302184-1-ye.xingchen@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=OA6ZBoW6tn54/FgmsdfdLrU3vD7MdBVPqn+LErflnVQ=;
        b=e2g6MN3EJpfYl45WC5dxQGRvivXW81wOQIEYjU2qfv81vB9FTvz/6upDepxVuhuya2
         +taNNFrBbvjxC0fp6LyH1SlxXlM7R9EdVnO4jiQBNyzy0VGa/K137Be/VPm01AAqK9ei
         BVS0Xmjz4NPcoXiVrqLfTYIIkMds9cXJ/vJ0MFTgY7qoJOB8P405Tr21LZZ2/g9NzUad
         aOvG4/eNUpqTTXMvH3nevgv/yJxX0U0ip3VEX2lRBrAj6A9SIqwdwwuYMHIn9Yp4lRGQ
         D6n7gLjN0v8+T8FbOOD4eCT73U385gPmdiYufueATdy7BPaxisevTC8NOrQUZavGhCib
         u6uw==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

From: ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Return the value nilfs_segctor_sync() directly instead of storing it in
another redundant variable.

Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
---
 fs/nilfs2/segment.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 0afe0832c754..9abae2c9120e 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2235,7 +2235,6 @@ int nilfs_construct_segment(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info *ti;
-	int err;
 
 	if (!sci)
 		return -EROFS;
@@ -2243,8 +2242,7 @@ int nilfs_construct_segment(struct super_block *sb)
 	/* A call inside transactions causes a deadlock. */
 	BUG_ON((ti = current->journal_info) && ti->ti_magic == NILFS_TI_MAGIC);
 
-	err = nilfs_segctor_sync(sci);
-	return err;
+	return nilfs_segctor_sync(sci);
 }
 
 /**
-- 
2.25.1
