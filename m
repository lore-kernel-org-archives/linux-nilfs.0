From: Chen Zhongjin <chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment usage as dirty
Date: Fri, 18 Nov 2022 14:33:04 +0800
Message-ID: <20221118063304.140187-1-chenzhongjin@huawei.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
nilfs_segment_usage is not set dirty, which makes it can be found by
nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).

This will cause the problem reported by syzkaller:
https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24

It's because the case starts with segbuf1.segnum = 3, nextnum = 4, and
nilfs_sufile_alloc() not called to allocate a new segment.

The first time nilfs_segctor_extend_segments() allocated segment
segbuf2.segnum = segbuf1.nextnum = 4, then nilfs_sufile_alloc() found
nextnextnum = 4 segment because its su is not set dirty.
So segbuf2.nextnum = 4, which causes next segbuf3.segnum = 4.

sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
added to both buffer lists of two segbuf.
It makes the list head of second list linked to the first one. When
iterating the first one, it will access and deref the head of second,
which causes NULL pointer dereference.

Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Reported-by: syzbot+77e4f0...-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Signed-off-by: Chen Zhongjin <chenzhongjin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 fs/nilfs2/sufile.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 77ff8e95421f..2962f9071490 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -495,12 +495,18 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
 {
 	struct buffer_head *bh;
+	void *kaddr;
+	struct nilfs_segment_usage *su;
 	int ret;
 
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
 	if (!ret) {
 		mark_buffer_dirty(bh);
 		nilfs_mdt_mark_dirty(sufile);
+		kaddr = kmap_atomic(bh->b_page);
+		su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
+		nilfs_segment_usage_set_dirty(su);
+		kunmap_atomic(kaddr);
 		brelse(bh);
 	}
 	return ret;
-- 
2.17.1

