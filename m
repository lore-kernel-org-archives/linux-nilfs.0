From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure
Date: Thu, 29 Sep 2022 21:33:30 +0900
Message-ID: <20220929123330.19658-1-konishi.ryusuke@gmail.com>
References: <0000000000001a6b6705e9b3533d@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=2J8dEhSi4LoVFaaTjvQBUI0DFYA9A2JG/Zfec+eIbxg=;
        b=bKErUGltahBAoxoud23nWtqed2bGUwNz4MKypA7BMv/noAxOXYQQeV6vkmMSwI5TDW
         XYCs64b6Swl4ARcHgtCb38nZ8e6UGSpwfqZCsaV40h9MWaFVJ6CT/sFSGtbri2ry2oOC
         Qschv+0chd6XnFFtyqCVlS/wfllaKWp72zAmD8/O8pf4HnDRCsOAQg4Px7ZKsusZ9ObE
         wVvvLXFrIY2WyrnOomyXmYynnqOfyjaNlamIstOdvju5NA8QbAkcm59znDusT6JJfNkE
         xuQzYRFnvfp846BkJ/jOXSWiRfwEi1PrF/4bzA1vqjdzz9brvAywLKMXVeGoHKjTXDU+
         X+aw==
In-Reply-To: <0000000000001a6b6705e9b3533d-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+fbb3e0b24e8dae5a16ee-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If creation or finalization of a checkpoint fails due to anomalies
in the checkpoint metadata on disk, a kernel warning is generated.

This patch replaces the WARN_ONs by nilfs_error, so that a kernel,
booted with panic_on_warn, does not panic.  A nilfs_error is
appropriate here to handle the abnormal filesystem condition.

This also replaces the detected error codes with an I/O error so that
neither of the internal error codes is returned to callers.

Reported-by: syzbot+fbb3e0b24e8dae5a16ee-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/segment.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 0afe0832c754..25c56ea779ea 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -875,9 +875,11 @@ static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
 		nilfs_mdt_mark_dirty(nilfs->ns_cpfile);
 		nilfs_cpfile_put_checkpoint(
 			nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
-	} else
-		WARN_ON(err == -EINVAL || err == -ENOENT);
-
+	} else if (err == -EINVAL || err == -ENOENT) {
+		nilfs_error(sci->sc_super,
+			    "checkpoint creation failed due to metadata corruption.");
+		err = -EIO;
+	}
 	return err;
 }
 
@@ -891,7 +893,11 @@ static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 0,
 					  &raw_cp, &bh_cp);
 	if (unlikely(err)) {
-		WARN_ON(err == -EINVAL || err == -ENOENT);
+		if (err == -EINVAL || err == -ENOENT) {
+			nilfs_error(sci->sc_super,
+				    "checkpoint finalization failed due to metadata corruption.");
+			err = -EIO;
+		}
 		goto failed_ibh;
 	}
 	raw_cp->cp_snapshot_list.ssl_next = 0;
-- 
2.34.1

