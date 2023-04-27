From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: do not write dirty data after degenerating to read-only
Date: Thu, 27 Apr 2023 10:15:26 +0900
Message-ID: <20230427011526.13457-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682558131; x=1685150131;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zrhaHXbwFsAd0/GaXjow7H0L4+tY0cPhGmnifdoJQXg=;
        b=UHPmzD/Jv7A/n5d3rtYTtbcJMUMUlwDvrekWM3+ffCgmlYi440mf723O21x1cz+6bJ
         LMpmg4Nq7ivKgB6odqiW+Rp+s+PQy9DVqNpI0Lq4EHtDlgsyL2HGRyDH6GiF8Cd1xFSQ
         DuwwoJSBJz9pzwZFv1Oc7IR34uUZqEvT/WD1Y0UErcaAFXc9ojvtvOuxExoxJeB61UIt
         ySp5r5U2/F26BAQLK1xavfLN23IoEepEuXqxeuMNKXRVWjR2KhKAHmNnqfaJ76dCTCL+
         10qSEQmxSsvPC7T7dx1ddWXHR/vwVS5Hr++krWyiyDC33myHP+pGCcg/5IDZtzglHt14
         UXIQ==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+2af3bc9585be7f23f290-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

According to syzbot's report, mark_buffer_dirty() called from
nilfs_segctor_do_construct() outputs a warning with some patterns after
nilfs2 detects metadata corruption and degrades to read-only mode.

After such read-only degeneration, page cache data may be cleared
through nilfs_clear_dirty_page() which may also clear the uptodate
flag for their buffer heads.  However, even after the degeneration,
log writes are still performed by unmount processing etc., which
causes mark_buffer_dirty() to be called for buffer heads without the
"uptodate" flag and causes the warning.

Since any writes should not be done to a read-only file system in the
first place, this fixes the warning in mark_buffer_dirty() by letting
nilfs_segctor_do_construct() abort early if in read-only mode.

This also changes the retry check of nilfs_segctor_write_out() to
avoid unnecessary log write retries if it detects -EROFS that
nilfs_segctor_do_construct() returned.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+2af3bc9585be7f23f290-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Link: https://syzkaller.appspot.com/bug?extid=2af3bc9585be7f23f290
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 fs/nilfs2/segment.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 228659612c0d..ac949fd7603f 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2041,6 +2041,9 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int err;
 
+	if (sb_rdonly(sci->sc_super))
+		return -EROFS;
+
 	nilfs_sc_cstage_set(sci, NILFS_ST_INIT);
 	sci->sc_cno = nilfs->ns_cno;
 
@@ -2724,7 +2727,7 @@ static void nilfs_segctor_write_out(struct nilfs_sc_info *sci)
 
 		flush_work(&sci->sc_iput_work);
 
-	} while (ret && retrycount-- > 0);
+	} while (ret && ret != -EROFS && retrycount-- > 0);
 }
 
 /**
-- 
2.34.1

