From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: Remove an uninitialization warning in
 nilfs_btree_propagate_v()
Date: Fri, 2 Apr 2010 18:40:39 +0800
Message-ID: <20100402104039.GA9652@xhl>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:date:from:to:cc:subject
         :message-id:mail-followup-to:mime-version:content-type
         :content-disposition:content-transfer-encoding:x-operating-system
         :user-agent;
        bh=+HOwa3F2wERZzTOi/8igvG8iQJ0uv2fwR3DkgpAxec0=;
        b=Z73DfaSoEyQeXItSbYndPZHTUoiptQG2ovcdCzrZJPtIgngXvY4FQHToMlJ/Sdsb0u
         TDDZHxsewqrLR7cApuUCqtxbmLfbtIiT0U16cnxMQX50vHciDWG5iJfQONd9rge8YmKt
         1qtItv1Ng2pML5Etk4IcP6ZvJayFUeMlI74bU=
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

`make CONFIG_NILFS2_FS=3Dm M=3Dfs/nilfs2/` will give the following warn=
ings:

fs/nilfs2/btree.c: In function =E2=80=98nilfs_btree_propagate=E2=80=99:
fs/nilfs2/btree.c:1882: warning: =E2=80=98maxlevel=E2=80=99 may be used=
 uninitialized in this function
fs/nilfs2/btree.c:1882: note: =E2=80=98maxlevel=E2=80=99 was declared h=
ere

Set maxlevel =3D 0 to fix it.

Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/btree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 7cdd98b..76c38e3 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1879,7 +1879,7 @@ static int nilfs_btree_propagate_v(struct nilfs_b=
tree *btree,
 				   struct nilfs_btree_path *path,
 				   int level, struct buffer_head *bh)
 {
-	int maxlevel, ret;
+	int maxlevel =3D 0, ret;
 	struct nilfs_btree_node *parent;
 	struct inode *dat =3D nilfs_bmap_get_dat(&btree->bt_bmap);
 	__u64 ptr;
--=20
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
