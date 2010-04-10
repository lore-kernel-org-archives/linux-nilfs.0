From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] nilfs2: nilfs_segctor_destroy() should do a full job
Date: Sun, 11 Apr 2010 00:17:00 +0800
Message-ID: <20100410161700.GB9213@xhl>
References: <20100410161543.GA9213@xhl>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:date:from:to:cc:subject
         :message-id:mail-followup-to:references:mime-version:content-type
         :content-disposition:in-reply-to:x-operating-system:user-agent;
        bh=+qdKozawDJtzKi5P6PqYyK+eN1KiyWVRoD4y1/hls6Y=;
        b=c6HcTyWnqWz4kgsUZ1yAJ1XPoU9UTRIcA1Kj8c+Iz41QONhP2Pwzs+fta5nkXETN9U
         oFvV4CPxyiSPmWCSyr72OT0lvAg3wjioYlICIlQvd20WmjI7WqWvvDb0o6GlP8gBi5RY
         nxGrLBsmZn1mdnbOYPzqNMT+yp7nqMhkRJUSc=
Content-Disposition: inline
In-Reply-To: <20100410161543.GA9213@xhl>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From 466fbbc10dabc8a14e292ee19636fc534036a8b7 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sat, 10 Apr 2010 22:26:04 +0800
Subject: [PATCH 2/3] nilfs2: nilfs_segctor_destroy() should do a full job

To set "sbi->s_sc_info = NULL;" is also a part of nilfs_segctor_destroy()'s job.
Move it into the destroy procedure.

Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/segment.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 514620d..dd3c4d5 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2774,6 +2774,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 	down_write(&sbi->s_nilfs->ns_segctor_sem);
 
 	kfree(sci);
+	sbi->s_sc_info = NULL;
 }
 
 /**
@@ -2829,10 +2830,8 @@ void nilfs_detach_segment_constructor(struct nilfs_sb_info *sbi)
 	LIST_HEAD(garbage_list);
 
 	down_write(&nilfs->ns_segctor_sem);
-	if (NILFS_SC(sbi)) {
+	if (NILFS_SC(sbi))
 		nilfs_segctor_destroy(NILFS_SC(sbi));
-		sbi->s_sc_info = NULL;
-	}
 
 	/* Force to free the list of dirty files */
 	spin_lock(&sbi->s_inode_lock);
-- 
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
