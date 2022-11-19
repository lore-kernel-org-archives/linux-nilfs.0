From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()
Date: Sat, 19 Nov 2022 21:05:42 +0900
Message-ID: <20221119120542.17204-1-konishi.ryusuke@gmail.com>
References: <00000000000097c20205ebaea3d6@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5PXFj1rB1pIp6QyH0AQexeQHB5YuSJsq1qsc0FeDJJY=;
        b=pxSuZWqMTJejJ1lIbOiwKO9WYxxjeuJUjsrgPMRK5pl6AH/zDzZluFy1z75nmytsWo
         3UhwJecQmw2UPFZLO+WLqQ4pNrorAJr8zg4ZxY106eBwgxh3LPCsQKmCk5YSO6cJyN9S
         Skb6x8pHk5PLt0Qodz9rWE0AkPrTN2jBVn6LTsRabaouyXbRr0dBC83bOwGYC1xC9tNt
         uJQcPyYP8mJBGR+eFdDCKMwPxu8qKyspEtLaZkw90q0tPwsMBQxPC/OMFXYeKJWDwskN
         fNbAGbBeJHF13A+cZBAKQwgJ7vVRYNRiqdCGJ/0J64etW84jL6C0KN72X1gaxrwDRrNF
         d6EQ==
In-Reply-To: <00000000000097c20205ebaea3d6-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+ebe05ee8e98f755f61d0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ZhangPeng <zhangpeng362-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

From: ZhangPeng <zhangpeng362-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Syzbot reported a null-ptr-deref bug:

 NILFS (loop0): segctord starting. Construction interval = 5 seconds, CP
 frequency < 30 seconds
 general protection fault, probably for non-canonical address
 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
 KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
 CPU: 1 PID: 3603 Comm: segctord Not tainted
 6.1.0-rc2-syzkaller-00105-gb229b6ca5abb #0
 Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google
 10/11/2022
 RIP: 0010:nilfs_palloc_commit_free_entry+0xe5/0x6b0
 fs/nilfs2/alloc.c:608
 Code: 00 00 00 00 fc ff df 80 3c 02 00 0f 85 cd 05 00 00 48 b8 00 00 00
 00 00 fc ff df 4c 8b 73 08 49 8d 7e 10 48 89 fa 48 c1 ea 03 <80> 3c 02
 00 0f 85 26 05 00 00 49 8b 46 10 be a6 00 00 00 48 c7 c7
 RSP: 0018:ffffc90003dff830 EFLAGS: 00010212
 RAX: dffffc0000000000 RBX: ffff88802594e218 RCX: 000000000000000d
 RDX: 0000000000000002 RSI: 0000000000002000 RDI: 0000000000000010
 RBP: ffff888071880222 R08: 0000000000000005 R09: 000000000000003f
 R10: 000000000000000d R11: 0000000000000000 R12: ffff888071880158
 R13: ffff88802594e220 R14: 0000000000000000 R15: 0000000000000004
 FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000)
 knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fb1c08316a8 CR3: 0000000018560000 CR4: 0000000000350ee0
 Call Trace:
  <TASK>
  nilfs_dat_commit_free fs/nilfs2/dat.c:114 [inline]
  nilfs_dat_commit_end+0x464/0x5f0 fs/nilfs2/dat.c:193
  nilfs_dat_commit_update+0x26/0x40 fs/nilfs2/dat.c:236
  nilfs_btree_commit_update_v+0x87/0x4a0 fs/nilfs2/btree.c:1940
  nilfs_btree_commit_propagate_v fs/nilfs2/btree.c:2016 [inline]
  nilfs_btree_propagate_v fs/nilfs2/btree.c:2046 [inline]
  nilfs_btree_propagate+0xa00/0xd60 fs/nilfs2/btree.c:2088
  nilfs_bmap_propagate+0x73/0x170 fs/nilfs2/bmap.c:337
  nilfs_collect_file_data+0x45/0xd0 fs/nilfs2/segment.c:568
  nilfs_segctor_apply_buffers+0x14a/0x470 fs/nilfs2/segment.c:1018
  nilfs_segctor_scan_file+0x3f4/0x6f0 fs/nilfs2/segment.c:1067
  nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1197 [inline]
  nilfs_segctor_collect fs/nilfs2/segment.c:1503 [inline]
  nilfs_segctor_do_construct+0x12fc/0x6af0 fs/nilfs2/segment.c:2045
  nilfs_segctor_construct+0x8e3/0xb30 fs/nilfs2/segment.c:2379
  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2487 [inline]
  nilfs_segctor_thread+0x3c3/0xf30 fs/nilfs2/segment.c:2570
  kthread+0x2e4/0x3a0 kernel/kthread.c:376
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
  </TASK>
 ...

If DAT metadata file is corrupted on disk, there is a case where
req->pr_desc_bh is NULL and blocknr is 0 at nilfs_dat_commit_end()
during a b-tree operation that cascadingly updates ancestor nodes of
the b-tree, because nilfs_dat_commit_alloc() for a lower level block can
initialize the blocknr on the same DAT entry between
nilfs_dat_prepare_end() and nilfs_dat_commit_end().

If this happens, nilfs_dat_commit_end() calls nilfs_dat_commit_free()
without valid buffer heads in req->pr_desc_bh and req->pr_bitmap_bh, and
causes the NULL pointer dereference above in
nilfs_palloc_commit_free_entry() function, which leads to a crash.

Fix this by adding a NULL check on req->pr_desc_bh and req->pr_bitmap_bh
before nilfs_palloc_commit_free_entry() in nilfs_dat_commit_free().

This also calls nilfs_error() in that case to notify that there is a
fatal flaw in the filesystem metadata and prevent further operations.

Link: https://lkml.kernel.org/r/00000000000097c20205ebaea3d6-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Link: https://lkml.kernel.org/r/20221114040441.1649940-1-zhangpeng362-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Signed-off-by: ZhangPeng <zhangpeng362-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reported-by: syzbot+ebe05ee8e98f755f61d0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Please apply this bugfix to -mm tree.

This is the first time I send this to you, but I prefixed this as a v2 patch
since this has the following changes from the original LKML post by ZhangPeng
base on the discussion and consent with him.
v1 -> v2:
1) Use "unlikely" annotation since this usually doesn't happen.
2) Call nilfs_error to notify the fatal flaw in the filesystem metadata and
   prevent further operations.
3) Modify changelog description base on detailed analysis.
4) Add tags ("Tested-by", cc-stable, and links).

fs/nilfs2/dat.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 3b55e239705f..9930fa901039 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -111,6 +111,13 @@ static void nilfs_dat_commit_free(struct inode *dat,
 	kunmap_atomic(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
+
+	if (unlikely(req->pr_desc_bh == NULL || req->pr_bitmap_bh == NULL)) {
+		nilfs_error(dat->i_sb,
+			    "state inconsistency probably due to duplicate use of vblocknr = %llu",
+			    (unsigned long long)req->pr_entry_nr);
+		return;
+	}
 	nilfs_palloc_commit_free_entry(dat, req);
 }
 
-- 
2.34.1

