From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: initialize "struct nilfs_binfo_dat"->bi_pad field
Date: Mon, 27 Mar 2023 00:21:46 +0900
Message-ID: <20230326152146.15872-1-konishi.ryusuke@gmail.com>
References: <0000000000000d710705f63f014c@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679844104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nSW0yZ/8PqCmJ515Nk2Q6ClqvBnG6F3s+Yexzns2FiY=;
        b=NcAEOnWfyfOYB53pnelUpofAE53NS/W77HtJB+tEii830WjdSQgP2t6NIKXtSdW0/X
         RmE5+6l2PMRnn3bymt+uaA+QUclipcmcsMEPqUfmPzTnLwuBxeQ3OOdzWwlV2CpJL6wi
         5ULtS+4bM/Ct58SDIg0HA/XadZu4qPGIod7T1+i9xDruhhdJQNXvJOkyeiloo3IcVMAT
         S/b+IAOzvwqYCWS1d1WdSKmR8tn7cSGxAJewlmIjWjOmvnreoHTMfFzkJv/ybluvRlqj
         w1ggqTxTqniXXFdYAS+h5Kkd+XxIa+fgQTZhGXPyPXnYu4/tw3vTzeykcO2opNTMQ4Hz
         BJdg==
In-Reply-To: <0000000000000d710705f63f014c-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot <syzbot+048585f3f4227bb2b49b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>

From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>

nilfs_btree_assign_p() and nilfs_direct_assign_p() are not initializing
"struct nilfs_binfo_dat"->bi_pad field, causing uninit-value reports
when being passed to CRC function.

Reported-by: syzbot <syzbot+048585f3f4227bb2b49b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Link: https://syzkaller.appspot.com/bug?extid=048585f3f4227bb2b49b
Reported-by: Dipanjan Das <mail.dipanjan.das-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Link: https://lkml.kernel.org/r/CANX2M5bVbzRi6zH3PTcNE_31TzerstOXUa9Bay4E6y6dX23_pg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Andrew, please pick this up, a fix for the KMSAN report.

Ryusuke Konishi

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

