From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: [PATCH v3] nilfs2: initialize "struct nilfs_binfo_dat"->bi_pad field
Date: Sun, 26 Mar 2023 19:27:04 +0900
Message-ID: <85f48e7e-a1dc-69ac-4e28-7449036cc8b3@I-love.SAKURA.ne.jp>
References: <0000000000000d710705f63f014c@google.com>
 <6c1d39bc-b19b-becf-821e-8cc9db8b4167@I-love.SAKURA.ne.jp>
 <CAKFNMokJ0_n6y3Wrc87WfhKA02ay4dqP7R_4XnonqDCj_Tuqcg@mail.gmail.com>
 <1103c7b0-0e46-4a92-74ee-920bf9599a80@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <1103c7b0-0e46-4a92-74ee-920bf9599a80-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: syzbot <syzbot+048585f3f4227bb2b49b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs_btree_assign_p() and nilfs_direct_assign_p() are not initializing
"struct nilfs_binfo_dat"->bi_pad field, causing uninit-value reports
when being passed to CRC function.

Reported-by: syzbot <syzbot+048585f3f4227bb2b49b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Link: https://syzkaller.appspot.com/bug?extid=048585f3f4227bb2b49b
Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
---
Changes in v3:
  Also fix nilfs_btree_assign_p().

Changes in v2:
  Use memset() for initialization, suggested by Ryusuke Konishi.

 fs/nilfs2/btree.c  | 1 +
 fs/nilfs2/direct.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 2681a449edc1..13592e82eaf6 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -2219,6 +2219,7 @@ static int nilfs_btree_assign_p(struct nilfs_bmap *btree,
 	/* on-disk format */
 	binfo->bi_dat.bi_blkoff = cpu_to_le64(key);
 	binfo->bi_dat.bi_level = level;
+	memset(binfo->bi_dat.bi_pad, 0, sizeof(binfo->bi_dat.bi_pad));
 
 	return 0;
 }
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index a35f2795b242..4c85914f2abc 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -314,6 +314,7 @@ static int nilfs_direct_assign_p(struct nilfs_bmap *direct,
 
 	binfo->bi_dat.bi_blkoff = cpu_to_le64(key);
 	binfo->bi_dat.bi_level = 0;
+	memset(binfo->bi_dat.bi_pad, 0, sizeof(binfo->bi_dat.bi_pad));
 
 	return 0;
 }
-- 
2.34.1

