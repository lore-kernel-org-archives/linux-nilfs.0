From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [GIT PULL] nilfs2 fixes for 2.6.36
Date: Tue, 17 Aug 2010 17:48:03 +0900 (JST)
Message-ID: <20100817.174803.110851506.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Linus,

please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to grab the following bug-fixes, one regression fix of the latest rc1
and a generic fix for list corruption/oops in an error path.

Thanks,

Ryusuke Konishi
--
The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:
  Linus Torvalds (1):
        Linux 2.6.36-rc1

Ryusuke Konishi (2):
      nilfs2: fix list corruption after ifile creation failure
      nilfs2: fix false warning saying one of two super blocks is broken

 fs/nilfs2/super.c     |    4 +++-
 fs/nilfs2/the_nilfs.c |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1fa86b9..bee60c0 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -400,9 +400,10 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	list_add(&sbi->s_list, &nilfs->ns_supers);
 	up_write(&nilfs->ns_super_sem);
 
+	err = -ENOMEM;
 	sbi->s_ifile = nilfs_ifile_new(sbi, nilfs->ns_inode_size);
 	if (!sbi->s_ifile)
-		return -ENOMEM;
+		goto delist;
 
 	down_read(&nilfs->ns_segctor_sem);
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, cno, 0, &raw_cp,
@@ -433,6 +434,7 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno)
 	nilfs_mdt_destroy(sbi->s_ifile);
 	sbi->s_ifile = NULL;
 
+ delist:
 	down_write(&nilfs->ns_super_sem);
 	list_del_init(&sbi->s_list);
 	up_write(&nilfs->ns_super_sem);
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 37de1f0..6af1c00 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -608,11 +608,11 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 		return -EINVAL;
 	}
 
-	if (swp) {
+	if (!valid[!swp])
 		printk(KERN_WARNING "NILFS warning: broken superblock. "
 		       "using spare superblock.\n");
+	if (swp)
 		nilfs_swap_super_block(nilfs);
-	}
 
 	nilfs->ns_sbwcount = 0;
 	nilfs->ns_sbwtime = le64_to_cpu(sbp[0]->s_wtime);
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
