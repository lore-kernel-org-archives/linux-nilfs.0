From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix infinite loop in nilfs_mdt_get_block()
Date: Mon,  1 May 2023 04:30:46 +0900
Message-ID: <20230430193046.6769-1-konishi.ryusuke@gmail.com>
References: <CAKFNMonK2VcZx=KEG8cz61bhwMvChEJ=T+FecxpGg1QiRCcZhA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682883067; x=1685475067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GlsJcu/owJRrewoN2aRAwgzKM6GWcL4oq43DrBBCLyg=;
        b=e1gXWRJ+lF5vAfKGBUYK74U9MMM91eT1I3BSLNVRvuY7BZ7sy26hFR6sMBUv1L6e7i
         WfP8oDcKCy/zq/kGN9idkc7TmQT8cYCkppBirtSAaNEvzUen6OsI3Tu8RUd2nVkHllpC
         PGbfj10Lti5yebEYTXfHrbcjSD0olULKbRWPhIDXUUGHadgzKFAjvQ9/8/J/fMTBnZR5
         P/UqnTOcGV/4caKKKQtSQ2efnZqrDTYdA9Ruvvi1LzkVWVKysDMYJXI+D3SOqUL4Zw8f
         LRmPz28XUE3Wmddr7DoPYsg9slogv4PGBnC0OowyQFMZmADMX6NEUQeut3hBpvoMovdr
         gRcw==
In-Reply-To: <CAKFNMonK2VcZx=KEG8cz61bhwMvChEJ=T+FecxpGg1QiRCcZhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+221d75710bde87fa0e97-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If the disk image that nilfs2 mounts is corrupted and a virtual block
address obtained by block lookup for a metadata file is invalid,
nilfs_bmap_lookup_at_level() may return the same internal return code
as -ENOENT, meaning the block does not exist in the metadata file.

This duplication of return codes confuses nilfs_mdt_get_block(), causing
it to read and create a metadata block indefinitely.

In particular, if this happens to the inode metadata file, ifile,
semaphore i_rwsem can be left held, causing task hangs in lock_mount.

Fix this issue by making nilfs_bmap_lookup_at_level() treat virtual
block address translation failures with -ENOENT as metadata corruption
instead of returning the error code.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+221d75710bde87fa0e97-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Link: https://syzkaller.appspot.com/bug?extid=221d75710bde87fa0e97
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/bmap.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 798a2c1b38c6..7a8f166f2c8d 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -67,20 +67,28 @@ int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
 
 	down_read(&bmap->b_sem);
 	ret = bmap->b_ops->bop_lookup(bmap, key, level, ptrp);
-	if (ret < 0) {
-		ret = nilfs_bmap_convert_error(bmap, __func__, ret);
+	if (ret < 0)
 		goto out;
-	}
+
 	if (NILFS_BMAP_USE_VBN(bmap)) {
 		ret = nilfs_dat_translate(nilfs_bmap_get_dat(bmap), *ptrp,
 					  &blocknr);
 		if (!ret)
 			*ptrp = blocknr;
+		else if (ret == -ENOENT) {
+			/*
+			 * If there was no valid entry in DAT for the block
+			 * address obtained by b_ops->bop_lookup, then pass
+			 * internal code -EINVAL to nilfs_bmap_convert_error
+			 * to treat it as metadata corruption.
+			 */
+			ret = -EINVAL;
+		}
 	}
 
  out:
 	up_read(&bmap->b_sem);
-	return ret;
+	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
 int nilfs_bmap_lookup_contig(struct nilfs_bmap *bmap, __u64 key, __u64 *ptrp,
-- 
2.34.1

