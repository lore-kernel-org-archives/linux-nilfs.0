From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: fix warning in nilfs_writepage()
Date: Thu, 25 Apr 2013 13:38:35 +0400
Message-ID: <1366882715.3181.11.camel@slavad-ubuntu>
References: <20130425074947.GB11880@elgon.mountain>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=oH/hYdvJzaXppDudBoBsCnNipwuqhXVjsAKwyhgs240=;
	b=jXm3sw6qg5rCJpEmCTL0sMAEVRoWnfmEVycW6MkzmtzAvIXDB95nfe1FG2t6GI1B63P++PuPCTFDoUWnX9V7nIK7tNWilt82NnWvBR5xoIY2rodaKJXTl709WTtFuk9b;
In-Reply-To: <20130425074947.GB11880-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kbuild-JC7UmRfGjtg@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, 2013-04-25 at 10:49 +0300, Dan Carpenter wrote:
> [ It's weird that kbuild didn't catch this ].
> 
> Hello Vyacheslav Dubeyko,
> 
> The patch bb594c4767b0: "nilfs2: fix issue with flush kernel thread
> after remount in RO mode because of driver's internal error or
> metadata corruption" from Apr 18, 2013, leads to the following 
> warning:
> "fs/nilfs2/inode.c:211 nilfs_writepage()
> 	 error: we previously assumed 'inode' could be null (see line 195)"
> 

Please, find below the patch with fix.

Thanks,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: fix warning in nilfs_writepage()

The patch fixes warning: "fs/nilfs2/inode.c:211 nilfs_writepage() error: we previously assumed 'inode' could be null (see line 195)".

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index ba7a1da..cf02f55 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -192,7 +192,7 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
 	struct inode *inode = page->mapping->host;
 	int err;
 
-	if (inode && (inode->i_sb->s_flags & MS_RDONLY)) {
+	if (inode->i_sb->s_flags & MS_RDONLY) {
 		/*
 		 * It means that filesystem was remounted in read-only
 		 * mode because of error or metadata corruption. But we
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
