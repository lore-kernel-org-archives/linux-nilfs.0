From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: [PATCH] nilfs2: fix incomplete initialization in
 nilfs_direct_assign_p()
Date: Sun, 26 Mar 2023 15:32:07 +0900
Message-ID: <6c1d39bc-b19b-becf-821e-8cc9db8b4167@I-love.SAKURA.ne.jp>
References: <0000000000000d710705f63f014c@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <0000000000000d710705f63f014c-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: syzbot <syzbot+048585f3f4227bb2b49b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

syzbot is reporting uninit value at nilfs_add_checksums_on_logs() [1], for
nilfs_direct_assign_p() from nilfs_direct_assign() from nilfs_bmap_assign()
does not initialize "struct nilfs_binfo_dat"->bi_pad field.

We need to initialize sizeof("union nilfs_binfo"->bi_dat) bytes if
nilfs_write_dat_node_binfo() from nilfs_segctor_assign() copies it
and nilfs_add_checksums_on_logs() passes it to CRC function.

Reported-by: syzbot <syzbot+048585f3f4227bb2b49b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Link: https://syzkaller.appspot.com/bug?extid=048585f3f4227bb2b49b [1]
Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
---
I'm not sure whether this can fix the bug, for a reproducer is not yet
available...

 fs/nilfs2/direct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index a35f2795b242..4358b4581ec4 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -313,7 +313,8 @@ static int nilfs_direct_assign_p(struct nilfs_bmap *direct,
 	nilfs_direct_set_ptr(direct, key, blocknr);
 
 	binfo->bi_dat.bi_blkoff = cpu_to_le64(key);
-	binfo->bi_dat.bi_level = 0;
+	/* initialize bi_pad field together while assigning bi_level field */
+	*(u64 *) &binfo->bi_dat.bi_level = (u64) 0;
 
 	return 0;
 }
-- 
2.34.1

