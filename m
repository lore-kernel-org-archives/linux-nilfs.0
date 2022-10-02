From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
Date: Sun,  2 Oct 2022 12:08:04 +0900
Message-ID: <20221002030804.29978-1-konishi.ryusuke@gmail.com>
References: <000000000000eb0ba805e9d6e30e@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=H94AYH5YtHBkal/GiFTQVCFtPlhU2OjgiQ2dQ8FUTFw=;
        b=qgbNytB8z5Bj8JoQzwz8kS+Ikv4oEd/VUDI9jP8UhJGyS0e/YhY63cwuhgqUnwSOCa
         5HIxK4LRq9UCO4rUodculT+kZBKOZMfQ7ly+s7k6B2igC9vQ4svXAOZE8kh8n2a0xeI0
         //YeLO0OXjJAAqOoDkqneYmp30k7B+PACZ/WohdrOwT0Y3bL89DomMz5gMM1Ri4lGV1j
         xEFhSYS43RY1ueVJK5THxT3mwmMSMzII2gJRb4i9MazyXnwUqJFvhSeK2cD9a8ebN6f6
         dBbgTkDPtGqko9cck0EYgH4m5IeqiGUbuwVPQ/UdW5K2kQlyWLuIBtJdg4W/4nQsAwz0
         7keQ==
In-Reply-To: <000000000000eb0ba805e9d6e30e-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+2b32eb36c1a825b7a74c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If the i_mode field in inode of metadata files is corrupted on disk,
it can cause the initialization of bmap structure, which should have
been called from nilfs_read_inode_common(), not to be called.  This
causes a lockdep warning followed by a NULL pointer dereference at
nilfs_bmap_lookup_at_level().

This patch fixes these issues by adding a missing sanitiy check for
the i_mode field of metadata file's inode.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+2b32eb36c1a825b7a74c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Reported-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 67f63cfeade5..d4e653d51869 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -440,6 +440,8 @@ int nilfs_read_inode_common(struct inode *inode,
 	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
 	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
 	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode))
+		return -EIO; /* this inode is for metadata and corrupted */
 	if (inode->i_nlink == 0)
 		return -ESTALE; /* this inode is deleted */
 
-- 
2.34.1

