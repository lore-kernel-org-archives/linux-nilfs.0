From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: Remove the unneeded result variable
Date: Wed, 21 Sep 2022 12:48:03 +0900
Message-ID: <20220921034803.2476-3-konishi.ryusuke@gmail.com>
References: <20220921034803.2476-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=X35vTpMjT4JUzdTpTOGe0YDg/vRzJ/72gtqZZF6EwZw=;
        b=TIchTrk6LcgzDDQ8AFqJ4xvF0DQy/GH1PrTcZsl47HPjIW4N9bAhmZr0cKJSQP0mIe
         dcTPofMbsqgq+n23YaQjaNdyGt01wOU08IYY877KynrlWkBD3WO/dAsRdKNUjKbrk91t
         LJsSBb0hxLB16WK8K1jYGJ8jJKbi4gDSaYTCNHG/wUe08Zll//maFZxZm6S4TF+gUm5R
         dpDlOVt5JRDxyfvV+wvgMrm8DPVENKMZyJAJpnNgC+Fisz2bYebzUG9AwVRKlOkRex6B
         0qSSV7ZyImEP9PdIWV6W5zVk7P/2XdVwgwdyojTKLRxu/dllobkB98ZbUiYU4TVb9Ur3
         fKSg==
In-Reply-To: <20220921034803.2476-1-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Return the value nilfs_segctor_sync() directly instead of storing it in
another redundant variable.

Link: https://lkml.kernel.org/r/20220831033403.302184-1-ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org
Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
2.34.1

