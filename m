From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: [PATCH] nilfs: check filetype/uid/gid at nilfs_read_inode_common()
Date: Sat, 1 Oct 2022 20:24:38 +0900
Message-ID: <f1438f46-a52d-707b-4ef9-ab29525f1c98@I-love.SAKURA.ne.jp>
References: <000000000000eb0ba805e9d6e30e@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <000000000000eb0ba805e9d6e30e-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: syzbot+2b32eb36c1a825b7a74c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org, syzkaller-bugs <syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>

syzbot is reporting lockdep warning followed by NULL pointer dereference
at nilfs_bmap_lookup_at_level() [1], for a crafted filesystem which
contains raw_inode->i_mode == 0 is poisoning checkpoint inode at
nilfs_read_inode_common() from nilfs_ifile_read() from
nilfs_attach_checkpoint() from nilfs_fill_super() from nilfs_mount().
Check that filetype/uid/gid are valid as well as i_nlink is valid.

Link: https://syzkaller.appspot.com/bug?extid=2b32eb36c1a825b7a74c [1]
Reported-by: syzot <syzbot+2b32eb36c1a825b7a74c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
---
This patch solves crash but I don't know whether this patch is correct.

Commit 05fe58fdc10df9eb ("nilfs2: inode operations") did

+       if (inode->i_nlink == 0 && (inode->i_mode == 0 || ii->i_dtime))

and commit 612392307cb09e49 ("nilfs2: support nanosecond timestamp") did

-       if (inode->i_nlink == 0 && (inode->i_mode == 0 || ii->i_dtime))
+       if (inode->i_nlink == 0 && inode->i_mode == 0)

and commit 705304a863cc4158 ("nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races") did


-       if (inode->i_nlink == 0 && inode->i_mode == 0)
+       if (inode->i_nlink == 0)

but I don't know which commit was wrong. Is inode->i_mode == 0 valid in nilfs?

 fs/nilfs2/inode.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 67f63cfeade5..798efd879642 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -442,6 +442,20 @@ int nilfs_read_inode_common(struct inode *inode,
 	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
 	if (inode->i_nlink == 0)
 		return -ESTALE; /* this inode is deleted */
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFLNK:
+	case S_IFREG:
+	case S_IFDIR:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFIFO:
+	case S_IFSOCK:
+		break;
+	default:
+		return -EINVAL; /* Filetype is invalid */
+	}
+	if (!uid_valid(inode->i_uid) || !gid_valid(inode->i_gid))
+		return -EINVAL; /* UID/GID is invalid */
 
 	inode->i_blocks = le64_to_cpu(raw_inode->i_blocks);
 	ii->i_flags = le32_to_cpu(raw_inode->i_flags);
-- 
2.34.1

