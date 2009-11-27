From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv2 1/9] nilfs2: delete mark_inode_dirty in
	nilfs_new_inode
Date: Fri, 27 Nov 2009 19:41:06 +0900
Message-ID: <1259318474-28342-2-git-send-email-jir@unicus.jp>
References: <1259318474-28342-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1259318474-28342-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

It is redundant to call mark_inode_dirty() in nilfs_new_inode() because
all caller of nilfs_new_inode() will call mark_inode_dirty()
after calling nilfs_new_inode() directly or indirectly in transaction.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/inode.c |    1 -
 fs/nilfs2/namei.c |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index a16c179..ede0375 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -323,7 +323,6 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 				    nilfs_init_acl(), proper cancellation of
 				    above jobs should be considered */
 
-	mark_inode_dirty(inode);
 	return inode;
 
  failed_acl:
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index ed02e88..01adda8 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -188,7 +188,7 @@ static int nilfs_symlink(struct inode *dir, struct dentry *dentry,
 		goto out_fail;
 
 	/* mark_inode_dirty(inode); */
-	/* nilfs_new_inode() and page_symlink() do this */
+	/* page_symlink() do this */
 
 	err = nilfs_add_nondir(dentry, inode);
 out:
-- 
1.5.6.5
