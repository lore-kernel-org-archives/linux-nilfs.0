From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: replace WARN_ONs for invalid DAT metadata block requests
Date: Fri, 27 Jan 2023 01:41:14 +0900
Message-ID: <20230126164114.6911-1-konishi.ryusuke@gmail.com>
References: <0000000000005cc3d205ea23ddcf@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMxWKmQ/i8aPoVTgMwXRe3wWNfCPGmN2wVMhtok6GV8=;
        b=oSSqVGhtKAiNc1G4eRnYzKX2qSngVoikWgtvsP35LOPVpDms2+p9FYnNNn79s8suej
         Cm3clzjflQjmKypAFrfwLXL4Rlik6QsGF60G6yghCEaxm0UbRSV+iO3f2lIsvmuGK0L6
         oq66SJJkMnOght6aRWB5hUVV6cGr3MhwiBvaury4YZ7FiFAINythTTwYygl5/fPhw9rs
         /PwPfKamx55t/3o9nnMYmteEaiq5vzPD+dLDK84b9W2GDisNLEoUcVCifVxN3VhLgeyO
         JdNNKGVHdWWDfXeRuWKqiNmZnEfgVOIMxxAXw3Vvdz1l4ay+2xGpbd0f5EJWqudYoFv1
         n/ug==
In-Reply-To: <0000000000005cc3d205ea23ddcf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+5d5d25f90f195a3cfcb4-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If DAT metadata file block access fails due to corruption of the DAT file
or abnormal virtual block numbers held by b-trees or inodes, a kernel
warning is generated.

This replaces the WARN_ONs by error output, so that a kernel, booted with
panic_on_warn, does not panic.  This patch also replaces the detected
return code -ENOENT with another internal code -EINVAL to notify the bmap
layer of metadata corruption.  When the bmap layer sees -EINVAL, it
handles the abnormal situation with nilfs_bmap_convert_error() and
finally returns code -EIO as it should.

Link: https://lkml.kernel.org/r/0000000000005cc3d205ea23ddcf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+5d5d25f90f195a3cfcb4-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Hi Andrew, please queue this.  This fixes a few potential WARN_ONs
for corrupted disk images like the one syzbot produced.

Thanks,
Ryusuke Konishi

fs/nilfs2/dat.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 9930fa901039..1e7f653c1df7 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -40,8 +40,21 @@ static inline struct nilfs_dat_info *NILFS_DAT_I(struct inode *dat)
 static int nilfs_dat_prepare_entry(struct inode *dat,
 				   struct nilfs_palloc_req *req, int create)
 {
-	return nilfs_palloc_get_entry_block(dat, req->pr_entry_nr,
-					    create, &req->pr_entry_bh);
+	int ret;
+
+	ret = nilfs_palloc_get_entry_block(dat, req->pr_entry_nr,
+					   create, &req->pr_entry_bh);
+	if (unlikely(ret == -ENOENT)) {
+		nilfs_err(dat->i_sb,
+			  "DAT doesn't have a block to manage vblocknr = %llu",
+			  (unsigned long long)req->pr_entry_nr);
+		/*
+		 * Return internal code -EINVAL to notify bmap layer of
+		 * metadata corruption.
+		 */
+		ret = -EINVAL;
+	}
+	return ret;
 }
 
 static void nilfs_dat_commit_entry(struct inode *dat,
@@ -123,11 +136,7 @@ static void nilfs_dat_commit_free(struct inode *dat,
 
 int nilfs_dat_prepare_start(struct inode *dat, struct nilfs_palloc_req *req)
 {
-	int ret;
-
-	ret = nilfs_dat_prepare_entry(dat, req, 0);
-	WARN_ON(ret == -ENOENT);
-	return ret;
+	return nilfs_dat_prepare_entry(dat, req, 0);
 }
 
 void nilfs_dat_commit_start(struct inode *dat, struct nilfs_palloc_req *req,
@@ -154,10 +163,8 @@ int nilfs_dat_prepare_end(struct inode *dat, struct nilfs_palloc_req *req)
 	int ret;
 
 	ret = nilfs_dat_prepare_entry(dat, req, 0);
-	if (ret < 0) {
-		WARN_ON(ret == -ENOENT);
+	if (ret < 0)
 		return ret;
-	}
 
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
-- 
2.34.1

