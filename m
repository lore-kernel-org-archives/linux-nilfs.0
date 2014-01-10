From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 16/17] nilfs2: fix issue with chmod command
Date: Fri, 10 Jan 2014 16:10:26 +0400
Message-ID: <1389355826.3938.138.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=k75zTYqAZzRwwLNBYRi9YCO4V5nTce9sQXPTWeFxK3s=;
	b=m8x5gaHkNuaPRrxzRe7umlvldV86+G4S2uX+YYE/TJaU6il0Mul086mE6I02DH1TTmO7/YJ9Cr+S7eewOv8kTAvxL0rU5rcbR3+RQI5AfjtDApVaA8Ib86dck1lioASQ;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 16/17] nilfs2: fix issue with chmod command

This patch fix issue with "Operation not supported" message
for the case of trying to use chmod command for NILFS2 volume
that it doesn't contain xafile.

Reported-by: Michael L. Semon <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/acl.c b/fs/nilfs2/acl.c
index 95b3601..7c3f366 100644
--- a/fs/nilfs2/acl.c
+++ b/fs/nilfs2/acl.c
@@ -185,7 +185,7 @@ int nilfs_acl_chmod(struct inode *inode)
 	struct posix_acl *acl;
 
 	if (!nilfs_has_xafile(nilfs))
-		return -EOPNOTSUPP;
+		return 0;
 
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
