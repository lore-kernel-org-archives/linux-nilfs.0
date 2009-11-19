From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/4] nilfs2: apply readahead for recovery on
	mount
Date: Fri, 20 Nov 2009 02:09:10 +0900
Message-ID: <1258650553-10743-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258650553-10743-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258650553-10743-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This inserts readahead in the recovery code.  The readahead request is
issued per segment while searching the latest super root block.

This will shorten mount time after unclean unmount.  A measurement
shows the recovery time was reduced by more than 60 percent:

 e.g. real  0m11.586s -> 0m3.918s  (x 2.96)

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/recovery.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index bcd386d..6d5412e 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -798,6 +798,7 @@ int nilfs_search_super_root(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi,
 	struct nilfs_segsum_info ssi;
 	sector_t pseg_start, pseg_end, sr_pseg_start = 0;
 	sector_t seg_start, seg_end; /* range of full segment (block number) */
+	sector_t b, end;
 	u64 seg_seq;
 	__u64 segnum, nextnum = 0;
 	__u64 cno;
@@ -813,6 +814,11 @@ int nilfs_search_super_root(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi,
 	/* Calculate range of segment */
 	nilfs_get_segment_range(nilfs, segnum, &seg_start, &seg_end);
 
+	/* Read ahead segment */
+	b = seg_start;
+	while (b <= seg_end)
+		sb_breadahead(sbi->s_super, b++);
+
 	for (;;) {
 		/* Load segment summary */
 		ret = load_segment_summary(sbi, pseg_start, seg_seq, &ssi, 1);
@@ -835,14 +841,20 @@ int nilfs_search_super_root(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi,
 		ri->ri_nextnum = nextnum;
 		empty_seg = 0;
 
+		if (!NILFS_SEG_HAS_SR(&ssi) && !scan_newer) {
+			/* This will never happen because a superblock
+			   (last_segment) always points to a pseg
+			   having a super root. */
+			ret = NILFS_SEG_FAIL_CONSISTENCY;
+			goto failed;
+		}
+
+		if (pseg_start == seg_start) {
+			nilfs_get_segment_range(nilfs, nextnum, &b, &end);
+			while (b <= end)
+				sb_breadahead(sbi->s_super, b++);
+		}
 		if (!NILFS_SEG_HAS_SR(&ssi)) {
-			if (!scan_newer) {
-				/* This will never happen because a superblock
-				   (last_segment) always points to a pseg
-				   having a super root. */
-				ret = NILFS_SEG_FAIL_CONSISTENCY;
-				goto failed;
-			}
 			if (!ri->ri_lsegs_start && NILFS_SEG_LOGBGN(&ssi)) {
 				ri->ri_lsegs_start = pseg_start;
 				ri->ri_lsegs_start_seq = seg_seq;
-- 
1.6.3.4
