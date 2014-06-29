From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: suggest to use dump_stack() in nilfs_error() and
 nilfs_warning()
Date: Sun, 29 Jun 2014 18:03:41 +0400
Message-ID: <1404050621.4139.19.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=VUzgdkyOVKgw4UTDkjRF+4q8UV33PeuX6IPXC/WSaMI=;
	b=VqA/D7T09m5pk15HFGTwA+GtKB2zRwVh/zuDUo+Wa899868KZyN0bdl8gTqD19iGlCkbcTWXz4pH4EOVYFrisLU/IRDcq5T016Q6imblnU+q2y6EltXx5xpcuXukFd/d;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
Subject: [PATCH] nilfs2: suggest to use dump_stack() in nilfs_error() and nilfs_warning()

This patch suggests to use dump_stack() call in nilfs_error() and
nilfs_warning() for more clear understanding of different type of
issues. As a result, end-users can report more informative
descriptions of issues.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |    1 -
 fs/nilfs2/super.c |    5 ++++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6252b17..745e96d 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -970,7 +970,6 @@ void nilfs_dirty_inode(struct inode *inode, int flags)
 	if (is_bad_inode(inode)) {
 		nilfs_warning(inode->i_sb, __func__,
 			      "tried to mark bad_inode dirty. ignored.\n");
-		dump_stack();
 		return;
 	}
 	if (mdi) {
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8c532b2..c6cd607 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -123,6 +123,8 @@ void nilfs_error(struct super_block *sb, const char *function,
 
 	va_end(args);
 
+	dump_stack();
+
 	if (!(sb->s_flags & MS_RDONLY)) {
 		nilfs_set_error(sb);
 
@@ -152,8 +154,9 @@ void nilfs_warning(struct super_block *sb, const char *function,
 	       sb->s_id, function, &vaf);
 
 	va_end(args);
-}
 
+	dump_stack();
+}
 
 struct inode *nilfs_alloc_inode(struct super_block *sb)
 {
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
