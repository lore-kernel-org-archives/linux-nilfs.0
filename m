From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] fix warning in fs/nilfs2/btree.c: In function
 =?UTF-8?Q?=E2=80=98nilfs=5Fbtree=5Fconvert=5Fand=5Finsert=E2=80=99?=
Date: Sun, 03 Mar 2013 19:26:56 +0400
Message-ID: <1362324416.29435.33.camel@slavad-ubuntu-12.04>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=czVGJHiSRVOP1lo95NxfLakeFKxGw/+xX2++PTjPqm8=;
	b=cyjbQFEangWgjRqH/y6SPcFWanm5NcwrD8y8uQq0/pGiqfrXXdsFmCHLX5I3U6ubAl/l0kUNRu3ZksiHjjfxOZdP8U4BoxnSdvHuBL3+HIh1aVM/ugjR2RdRQ51DM6j5;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

=46rom: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] fix warning in fs/nilfs2/btree.c: In function =E2=80=98=
nilfs_btree_convert_and_insert=E2=80=99

This patch fixes the warning in fs/nilfs2/btree.c: In function =E2=80=98=
nilfs_btree_convert_and_insert=E2=80=99:
(1) include/asm/bitops.h:321:8: warning: =E2=80=98bh=E2=80=99 may be us=
ed uninitialized in this function [-Wuninitialized]

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 fs/nilfs2/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index b2e3ff3..734ece9 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1767,7 +1767,7 @@ int nilfs_btree_convert_and_insert(struct nilfs_b=
map *btree,
 				   __u64 key, __u64 ptr,
 				   const __u64 *keys, const __u64 *ptrs, int n)
 {
-	struct buffer_head *bh;
+	struct buffer_head *bh =3D NULL;
 	union nilfs_bmap_ptr_req dreq, nreq, *di, *ni;
 	struct nilfs_bmap_stats stats;
 	int ret;
--=20
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
