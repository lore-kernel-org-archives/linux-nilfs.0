From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: clamps ns_r_segments_percentage to [1, 99]
Date: Sat, 10 Mar 2012 23:35:29 +0900
Message-ID: <1331390130-7286-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1331390130-7286-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331390130-7286-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Haogang Chen <haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

ns_r_segments_percentage is read from the disk. Bogus or malicious
value could cause integer overflow and malfunction due to meaningless
disk usage calculation.
This patch reports error when mounting such bogus volumes.

Signed-off-by: Haogang Chen <haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index d327140..8a75901 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -409,6 +409,12 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 	nilfs->ns_first_data_block = le64_to_cpu(sbp->s_first_data_block);
 	nilfs->ns_r_segments_percentage =
 		le32_to_cpu(sbp->s_r_segments_percentage);
+	if (nilfs->ns_r_segments_percentage < 1 ||
+	    nilfs->ns_r_segments_percentage > 99) {
+		printk(KERN_ERR "NILFS: invalid reserved segments percentage.\n");
+		return -EINVAL;
+	}
+
 	nilfs_set_nsegments(nilfs, le64_to_cpu(sbp->s_nsegments));
 	nilfs->ns_crc_seed = le32_to_cpu(sbp->s_crc_seed);
 	return 0;
-- 
1.7.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
