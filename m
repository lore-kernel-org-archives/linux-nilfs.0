From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/3] nilfs2: avoid duplicate segment construction for fsync()
Date: Tue,  2 Dec 2014 01:41:45 +0900
Message-ID: <1417452107-6411-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1417452107-6411-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=EWk0utIMup6FABHar+NCGRK5RpkWKlIDpjxP7XRR+D4=;
        b=DICtp8razb+vcqBdjuRzmmawDrC2KioGyz33APCg/RhY89K4CqP0f/8p6fGB+j+ncz
         md39DU/+sneQQWtOtjfDoxydzo05logFP+0XjVPGTMwIwngzdvSFr2Oc5fTtHHaZYtqy
         1C6nbTpeQJ9Gft+o1MhfrDfWyPWLSilJvLzXdGKG/vL54lROGW27YW6lEszYxBhyki+C
         HYa3w4AfFX7s0ZDxQvKWZNW+U4tCCPVaKtHH7BSw4ZiDbkzQ1W6HrYo0ZgPRfJhAx/64
         eiplCJ4d/+cd0Y9RYJMK1TNo5iYn6sT0QjMyu5wHeGHZi/V+AcZhb0nPhTk1pnumuZUM
         HRUA==
In-Reply-To: <1417452107-6411-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Andreas Rohner <andreas.rohner@gmx.net>

From: Andreas Rohner <andreas.rohner@gmx.net>

This patch removes filemap_write_and_wait_range() from
nilfs_sync_file(), because it triggers a data segment construction by
calling nilfs_writepages() with WB_SYNC_ALL. A data segment construction
does not remove the inode from the i_dirty list and it does not clear
the NILFS_I_DIRTY flag. Therefore nilfs_inode_dirty() still returns
true, which leads to an unnecessary duplicate segment construction in
nilfs_sync_file().

A call to filemap_write_and_wait_range() is not needed, because NILFS2
does not rely on the generic writeback mechanisms. Instead it implements
its own mechanism to collect all dirty pages and write them into
segments. It is more efficient to initiate the segment construction
directly in nilfs_sync_file() without the detour over
filemap_write_and_wait_range().

Additionally the lock of i_mutex is not needed, because all code blocks
that are protected by i_mutex are also protected by a NILFS transaction:

Function                i_mutex     nilfs_transaction
------------------------------------------------------
nilfs_ioctl_setflags:   yes         yes
nilfs_fiemap:           yes         no
nilfs_write_begin:      yes         yes
nilfs_write_end:        yes         yes
nilfs_lookup:           yes         no
nilfs_create:           yes         yes
nilfs_link:             yes         yes
nilfs_mknod:            yes         yes
nilfs_symlink:          yes         yes
nilfs_mkdir:            yes         yes
nilfs_unlink:           yes         yes
nilfs_rmdir:            yes         yes
nilfs_rename:           yes         yes
nilfs_setattr:          yes         yes

For nilfs_lookup() i_mutex is held for the parent directory, to protect
it from modification. The segment construction does not modify directory
inodes, so no lock is needed.

nilfs_fiemap() reads the block layout on the disk, by using
nilfs_bmap_lookup_contig(). This is already protected by bmap->b_sem.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/file.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index e9e3325..1ad6bdf 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -41,19 +41,14 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct inode *inode = file->f_mapping->host;
 	int err;
 
-	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (err)
-		return err;
-	mutex_lock(&inode->i_mutex);
-
-	if (nilfs_inode_dirty(inode)) {
-		if (datasync)
-			err = nilfs_construct_dsync_segment(inode->i_sb, inode,
-							    0, LLONG_MAX);
-		else
-			err = nilfs_construct_segment(inode->i_sb);
-	}
-	mutex_unlock(&inode->i_mutex);
+	if (!nilfs_inode_dirty(inode))
+		return 0;
+
+	if (datasync)
+		err = nilfs_construct_dsync_segment(inode->i_sb, inode,
+						    start, end);
+	else
+		err = nilfs_construct_segment(inode->i_sb);
 
 	nilfs = inode->i_sb->s_fs_info;
 	if (!err)
-- 
1.8.3.1
