From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 1/3] BTRFS: support NFSv2 export
Date: Fri, 08 May 2015 10:16:23 +1000
Message-ID: <20150508001623.31129.91695.stgit@notabene.brown>
References: <20150508001142.31129.7604.stgit@notabene.brown>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150508001142.31129.7604.stgit-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <jbacik-b10kYP2dOMg@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The "fh_len" passed to ->fh_to_* is not guaranteed to be that same as
that returned by encode_fh - it may be larger.

With NFSv2, the filehandle is fixed length, so it may appear longer
than expected and be zero-padded.

So we must test that fh_len is at least some value, not exactly equal
to it.

Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
---
 fs/btrfs/export.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 8d052209f473..2513a7f53334 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -112,11 +112,11 @@ static struct dentry *btrfs_fh_to_parent(struct super_block *sb, struct fid *fh,
 	u32 generation;
 
 	if (fh_type == FILEID_BTRFS_WITH_PARENT) {
-		if (fh_len !=  BTRFS_FID_SIZE_CONNECTABLE)
+		if (fh_len <  BTRFS_FID_SIZE_CONNECTABLE)
 			return NULL;
 		root_objectid = fid->root_objectid;
 	} else if (fh_type == FILEID_BTRFS_WITH_PARENT_ROOT) {
-		if (fh_len != BTRFS_FID_SIZE_CONNECTABLE_ROOT)
+		if (fh_len < BTRFS_FID_SIZE_CONNECTABLE_ROOT)
 			return NULL;
 		root_objectid = fid->parent_root_objectid;
 	} else
@@ -136,11 +136,11 @@ static struct dentry *btrfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
 	u32 generation;
 
 	if ((fh_type != FILEID_BTRFS_WITH_PARENT ||
-	     fh_len != BTRFS_FID_SIZE_CONNECTABLE) &&
+	     fh_len < BTRFS_FID_SIZE_CONNECTABLE) &&
 	    (fh_type != FILEID_BTRFS_WITH_PARENT_ROOT ||
-	     fh_len != BTRFS_FID_SIZE_CONNECTABLE_ROOT) &&
+	     fh_len < BTRFS_FID_SIZE_CONNECTABLE_ROOT) &&
 	    (fh_type != FILEID_BTRFS_WITHOUT_PARENT ||
-	     fh_len != BTRFS_FID_SIZE_NON_CONNECTABLE))
+	     fh_len < BTRFS_FID_SIZE_NON_CONNECTABLE))
 		return NULL;
 
 	objectid = fid->objectid;


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
