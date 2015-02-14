From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] lscp: accelerate backward checkpoint listing
Date: Sun, 15 Feb 2015 01:00:02 +0900
Message-ID: <1423929602-25641-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=6Doe23Cb8Dbcewa2+ohIE/k+szp2CFX4aLHm3jJrsgw=;
        b=KwQVX7Nu1WQ1Epo41mpzhx6bph2p5pX3tCr7vTt56b8BU0Uevx14/6/geW8Oi6Q4HG
         WcnY/DyR5oLF7hQ3oEI9c3l77H1qgJvjIj/BSCtrgOa0GvHLr63+S2DTnkgXcgI2F2uF
         IuT6DiuzjkUWlaJ7KRPvhcs6oyAK84MhUIkOWb7R9g1p+v5SJ0PL8iq/M3NfjqArieWH
         IJYyVAVOyKP+2za2aTTM0CN6DJjkwcztf+NmvNwASC+DepkvpE4BuEnRZcsH2YCkwrcR
         ka0kqJp9n4C0jqhVkFujAqvz6b2nJBga+3QpexiUnhx4fKpWt2WV2Dbo8CS46Xxvag7J
         V37w==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

If the minimum checkpoint number of valid checkpoints is large to some
extent, "lscp -r" command takes very long time:

 $ lscp -r
                 CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
             6541269  2015-02-11 18:38:30   cp    -          435          2
             6541268  2015-02-11 18:38:25   cp    -          484         51
  <the command looks to enter a busy loop>

This is because it tries to find younger checkpoints tracking back the
checkpoint list in a constant step size.

This fixes the issue by lengthening or shortening the step size
depending on whether the backward search found a younger checkpoint or
not.

This patch also inserts a dummy nilfs_get_cpinfo() call before
starting the backward search to make successive nilfs_get_cpinfo()
calls much faster.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lscp.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 9 deletions(-)

diff --git a/bin/lscp.c b/bin/lscp.c
index c855def..023be5c 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -84,6 +84,12 @@ static const struct option long_option[] = {
 #define LSCP_NCPINFO	512
 #define LSCP_MINDELTA	64	/* Minimum delta for reverse direction */
 
+enum lscp_state {
+	LSCP_INIT_ST,		/* Initial state */
+	LSCP_NORMAL_ST,		/* Normal state */
+	LSCP_ACCEL_ST,		/* Accelerate state */
+	LSCP_DECEL_ST,		/* Decelerate state */
+};
 
 static __u64 param_index;
 static __u64 param_lines;
@@ -176,35 +182,107 @@ static int lscp_backward_cpinfo(struct nilfs *nilfs,
 	struct nilfs_cpinfo *cpi;
 	nilfs_cno_t sidx; /* start index (inclusive) */
 	nilfs_cno_t eidx; /* end index (exclusive) */
-	__u64 rest, delta;
+	nilfs_cno_t prev_head = 0;
+	__u64 rest, delta, v;
+	int state = LSCP_INIT_ST;
 	ssize_t n;
 
 	rest = param_lines && param_lines < cpstat->cs_ncps ? param_lines :
 		cpstat->cs_ncps;
+	if (!rest)
+		goto out;
 	eidx = param_index && param_index < cpstat->cs_cno ? param_index + 1 :
 		cpstat->cs_cno;
 
-	for ( ; rest > 0 && eidx > NILFS_CNO_MIN; eidx = sidx) {
-		delta = min_t(__u64, LSCP_NCPINFO,
-			      max_t(__u64, rest, LSCP_MINDELTA));
-		sidx = (eidx >= NILFS_CNO_MIN + delta) ? eidx - delta :
-			NILFS_CNO_MIN;
+recalc_delta:
+	delta = min_t(__u64, LSCP_NCPINFO, max_t(__u64, rest, LSCP_MINDELTA));
+	v = delta;
 
-		n = lscp_get_cpinfo(nilfs, sidx, NILFS_CHECKPOINT, eidx - sidx);
+	while (eidx > NILFS_CNO_MIN) {
+		if (eidx < NILFS_CNO_MIN + v || state == LSCP_INIT_ST)
+			sidx = NILFS_CNO_MIN;
+		else
+			sidx = eidx - v;
+
+		n = lscp_get_cpinfo(nilfs, sidx, NILFS_CHECKPOINT,
+				    state == LSCP_NORMAL_ST ? eidx - sidx : 1);
 		if (n < 0)
 			return n;
 		if (!n)
 			break;
 
-		for (cpi = cpinfos + n - 1; cpi >= cpinfos && rest > 0; cpi--) {
+		if (state == LSCP_INIT_ST) {
+			/*
+			 * This state makes succesive
+			 * nilfs_get_cpinfo() calls much faster by
+			 * setting minimum checkpoint number in nilfs
+			 * struct.
+			 */
+			if (cpinfos[0].ci_cno >= eidx)
+				goto out; /* out of range */
+			state = LSCP_NORMAL_ST;
+			continue;
+		} else if (cpinfos[0].ci_cno == prev_head) {
+			/* No younger checkpoint was found */
+
+			if (sidx == NILFS_CNO_MIN)
+				break;
+
+			/* go further back */
+			switch (state) {
+			case LSCP_NORMAL_ST:
+				state = LSCP_ACCEL_ST;
+				/* fall through */
+			case LSCP_ACCEL_ST:
+				if ((v << 1) > v)
+					v <<= 1;
+				break;
+			case LSCP_DECEL_ST:
+				state = LSCP_NORMAL_ST;
+				v = delta;
+				break;
+			}
+			eidx = sidx;
+			continue;
+		} else {
+			switch (state) {
+			case LSCP_ACCEL_ST:
+			case LSCP_DECEL_ST:
+				if (cpinfos[n - 1].ci_cno + 1 < prev_head) {
+					/* search again more slowly */
+					v >>= 1;
+					if (v <= delta) {
+						state = LSCP_NORMAL_ST;
+						v = delta;
+					} else {
+						state = LSCP_DECEL_ST;
+					}
+					continue;
+				}
+				break;
+			default:
+				break;
+			}
+		}
+
+		state = LSCP_NORMAL_ST;
+		cpi = &cpinfos[n - 1];
+		do {
 			if (cpi->ci_cno < eidx &&
 			    (show_all || nilfs_cpinfo_snapshot(cpi) ||
 			     !nilfs_cpinfo_minor(cpi))) {
 				lscp_print_cpinfo(cpi);
 				rest--;
+				if (rest == 0)
+					goto out;
 			}
-		}
+		} while (--cpi >= cpinfos);
+
+		prev_head = cpinfos[0].ci_cno;
+		eidx = sidx;
+		goto recalc_delta;
 	}
+out:
 	return 0;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
