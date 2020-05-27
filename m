From: wu000273@umn.edu
Subject: [PATCH] nilfs2: Fix reference count leak in nilfs_sysfs_create_snapshot_group.
Date: Wed, 27 May 2020 14:55:32 -0500
Message-ID: <20200527195532.28077-1-wu000273@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p7.oit.umn.edu 49XM5F5xp4z9vLH1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=q3TLvJ9CIfB/1wbg5oIw6CZmCCpeVyOuikrOuGzN8wA=;
        b=iSjjF+W7C++RnXuhE6xA97IPJEc37+fmpoEckipRxMbfZd7b7rJ9U99XRoYCjMOUoE
         9bpsnGsBCPwrMuKtiyBQSdQXD06vFEj5R+v6qA7VyuLOexIruIZMnGDZx2UBWVzz2FHq
         OdxtczifndOGVGRZBd5gQowMpBEvPV/IPyPhEnn1a9ytoddnkZkuKjGQqXFV6aSbgIm7
         N/bfr9r0Pb/AekpiJKA5DvtWn2bFbBdTuzJPKEtTbqp23V/ASN47pwvt1grw3GxnWonL
         vfciYVl69sKcy7ew1k8B3dKcmHjMePfW9LqGwIfVcjgzyFQwGdjEZHUfCgT4q0pBLTfU
         YLPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kjlu@umn.edu
Cc: wu000273@umn.edu, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

kobject_init_and_add() takes reference even when it fails.
If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object. Previous
commit "b8eb718348b8" fixed a similar problem.

Fixes: a5a7332a291b ("nilfs2: add /sys/fs/nilfs2/<device>/mounted_snapshots/<snapshot>group")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
---
 fs/nilfs2/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index e60be7bb55b0..b2517c5e773a 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -209,8 +209,10 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 					    "%llu", root->cno);
 	}
 
-	if (err)
+	if (err) {
+		kobject_put(&root->snapshot_kobj);
 		return err;
+	}
 
 	return 0;
 }
-- 
2.17.1

