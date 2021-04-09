From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: Fix typos in comments
Date: Fri,  9 Apr 2021 13:35:51 +0900
Message-ID: <1617942951-14631-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=k2mZEPIM2m0LlUJhlSgXYp3DVlSOR6FUSdDcttNdiJk=;
        b=L4i5CejlrQ4MIrpoYJ6j/XsTBtyHPK9R4bXy8nmrP6RkXy/rSxpkoXvg+5EmsRjx6E
         c87bhneuFLSRZszLj9Z5xzpVv4V9228h/BzT0oncvyfeQatdhrT17BPEueXNrWjnAcy/
         rjtSRKs46Nh3MwAElLJF220gJm3NQLNg7kmPbvBB5pWr3Mt52r+T8Ox9neuD7w2cVy/T
         yICudyvjd4c85z+dkpRbuL9BNc9MyyTiThJB/exGPsfHAeiHwsnvKSv6ksOMdWYllmud
         FVRSOy882JI4gGuzfL27Is3EA9ns9WA+OJK8uAcJdMI2bfnq+XTujlhfr6aEsKRxxB68
         Y1zQ==
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

numer -> number in fs/nilfs2/cpfile.c
Decription -> Description in fs/nilfs2/ioctl.c
isntance -> instance in fs/nilfs2/the_nilfs.c

Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Link: https://lore.kernel.org/r/20210409022519.176988-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/cpfile.c    | 2 +-
 fs/nilfs2/ioctl.c     | 4 ++--
 fs/nilfs2/the_nilfs.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 025fb082575a..ce144776b4ef 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -293,7 +293,7 @@ void nilfs_cpfile_put_checkpoint(struct inode *cpfile, __u64 cno,
  * nilfs_cpfile_delete_checkpoints - delete checkpoints
  * @cpfile: inode of checkpoint file
  * @start: start checkpoint number
- * @end: end checkpoint numer
+ * @end: end checkpoint number
  *
  * Description: nilfs_cpfile_delete_checkpoints() deletes the checkpoints in
  * the period from @start to @end, excluding @end itself. The checkpoints
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b053b40315bf..d1db73030085 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1058,7 +1058,7 @@ static int nilfs_ioctl_resize(struct inode *inode, struct file *filp,
  * @inode: inode object
  * @argp: pointer on argument from userspace
  *
- * Decription: nilfs_ioctl_trim_fs is the FITRIM ioctl handle function. It
+ * Description: nilfs_ioctl_trim_fs is the FITRIM ioctl handle function. It
  * checks the arguments from userspace and calls nilfs_sufile_trim_fs, which
  * performs the actual trim operation.
  *
@@ -1100,7 +1100,7 @@ static int nilfs_ioctl_trim_fs(struct inode *inode, void __user *argp)
  * @inode: inode object
  * @argp: pointer on argument from userspace
  *
- * Decription: nilfs_ioctl_set_alloc_range() function defines lower limit
+ * Description: nilfs_ioctl_set_alloc_range() function defines lower limit
  * of segments in bytes and upper limit of segments in bytes.
  * The NILFS_IOCTL_SET_ALLOC_RANGE is used by nilfs_resize utility.
  *
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 221a1cc597f0..8b7b01a380ce 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -195,7 +195,7 @@ static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
 /**
  * load_nilfs - load and recover the nilfs
  * @nilfs: the_nilfs structure to be released
- * @sb: super block isntance used to recover past segment
+ * @sb: super block instance used to recover past segment
  *
  * load_nilfs() searches and load the latest super root,
  * attaches the last segment, and does recovery if needed.
-- 
1.8.3.1

