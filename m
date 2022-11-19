From: Chen Zhongjin <chenzhongjin@huawei.com>
Subject: [PATCH v2] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment usage as dirty
Date: Sat, 19 Nov 2022 17:34:24 +0800
Message-ID: <20221119093424.193145-1-chenzhongjin@huawei.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: chenzhongjin@huawei.com, konishi.ryusuke@gmail.com, akpm@linux-foundation.org

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

Fix this by setting usage as dirty in nilfs_sufile_mark_dirty(),
and add lock in it to protect the usage modification.

Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Cc: stable@vger.kernel.org
Reported-by: syzbot+77e4f005cb899d4268d1@syzkaller.appspotmail.com
Reported-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
v1 -> v2:
1) Add lock protection as Ryusuke suggested and slightly fix commit
message.
2) Fix and add tags.
---
 fs/nilfs2/sufile.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 77ff8e95421f..dc359b56fdfa 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -495,14 +495,22 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
 {
 	struct buffer_head *bh;
+	void *kaddr;
+	struct nilfs_segment_usage *su;
 	int ret;
 
+	down_write(&NILFS_MDT(sufile)->mi_sem);
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
+	up_write(&NILFS_MDT(sufile)->mi_sem);
 	return ret;
 }
 
-- 
2.17.1

