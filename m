From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] lssu: display a "p" flag on protected segments
Date: Tue, 11 Feb 2014 16:56:48 +0900
Message-ID: <1392105408-30773-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Display a "p" flag in STAT field of the output lines of protected
segments when -l (--latest-usage) option is specfied.  This flag
clarifies which segments are protected by garbage collection at that
moment.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lssu.c |   29 ++++++++++++++++++-----------
 man/lssu.1 |   17 +++++++++++++----
 2 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/bin/lssu.c b/bin/lssu.c
index 1873957..bef4749 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -104,7 +104,7 @@ const static struct lssu_format lssu_format[] = {
 	{
 		"           SEGNUM        DATE     TIME STAT     NBLOCKS"
 		"       NLIVEBLOCKS\n",
-		"%17llu  %s  %c%c%c  %10u %10u (%3u%%)\n"
+		"%17llu  %s %c%c%c%c  %10u %10u (%3u%%)\n"
 	}
 };
 
@@ -114,6 +114,7 @@ static int all;
 static int latest;
 static int disp_mode;		/* display mode */
 static nilfs_cno_t protcno;
+static __u64 prottime;
 static __u64 param_index;
 static __u64 param_lines;
 
@@ -163,6 +164,7 @@ static ssize_t lssu_print_suinfo(struct nilfs *nilfs, __u64 segnum,
 	char timebuf[LSSU_BUFSIZE];
 	ssize_t i, n = 0, ret;
 	int ratio;
+	int protected;
 	size_t nliveblks;
 
 	for (i = 0; i < nsi; i++, segnum++) {
@@ -190,6 +192,7 @@ static ssize_t lssu_print_suinfo(struct nilfs *nilfs, __u64 segnum,
 		case LSSU_MODE_LATEST_USAGE:
 			nliveblks = 0;
 			ratio = 0;
+			protected = suinfos[i].sui_lastmod >= prottime;
 
 			if (!nilfs_suinfo_dirty(&suinfos[i]) ||
 			    nilfs_suinfo_error(&suinfos[i]))
@@ -203,6 +206,7 @@ static ssize_t lssu_print_suinfo(struct nilfs *nilfs, __u64 segnum,
 			} else if (ret == -2) {
 				nliveblks = suinfos[i].sui_nblocks;
 				ratio = 100;
+				protected = 1;
 			} else {
 				fprintf(stderr,
 					"%s: failed to get usage: %s\n",
@@ -217,6 +221,7 @@ static ssize_t lssu_print_suinfo(struct nilfs *nilfs, __u64 segnum,
 			       nilfs_suinfo_active(&suinfos[i]) ? 'a' : '-',
 			       nilfs_suinfo_dirty(&suinfos[i]) ? 'd' : '-',
 			       nilfs_suinfo_error(&suinfos[i]) ? 'e' : '-',
+			       protected ? 'p' : '-',
 			       suinfos[i].sui_nblocks, nliveblks, ratio);
 			break;
 		}
@@ -253,24 +258,25 @@ static int lssu_list_suinfo(struct nilfs *nilfs)
 
 static int lssu_get_protcno(struct nilfs *nilfs,
 			    unsigned long protection_period,
-			    nilfs_cno_t *protcnop)
+			    __u64 *prottimep, nilfs_cno_t *protcnop)
 {
 	struct nilfs_cnoconv *cnoconv;
 	struct timeval tv;
-	__u64 prottime;
 	int ret;
 
-	if (protection_period == ULONG_MAX) {
-		*protcnop = NILFS_CNO_MAX;
-		return 0;
-	}
-
 	ret = gettimeofday(&tv, NULL);
 	if (ret < 0) {
 		fprintf(stderr, "%s: cannot get current time: %m\n", progname);
 		return -1;
 	}
-	prottime = tv.tv_sec - protection_period;
+
+	if (protection_period == ULONG_MAX) {
+		*protcnop = NILFS_CNO_MAX;
+		*prottimep = tv.tv_sec;
+		return 0;
+	}
+
+	*prottimep = tv.tv_sec - protection_period;
 
 	cnoconv = nilfs_cnoconv_create(nilfs);
 	if (!cnoconv) {
@@ -280,7 +286,7 @@ static int lssu_get_protcno(struct nilfs *nilfs,
 		return -1;
 	}
 
-	ret = nilfs_cnoconv_time2cno(cnoconv, prottime, protcnop);
+	ret = nilfs_cnoconv_time2cno(cnoconv, *prottimep, protcnop);
 	if (ret < 0) {
 		fprintf(stderr,
 			"%s: cannot convert protectoin time to checkpoint "
@@ -383,7 +389,8 @@ int main(int argc, char *argv[])
 	if (latest) {
 		blocks_per_segment = nilfs_get_blocks_per_segment(nilfs);
 		disp_mode = LSSU_MODE_LATEST_USAGE;
-		ret = lssu_get_protcno(nilfs, protection_period, &protcno);
+		ret = lssu_get_protcno(nilfs, protection_period, &prottime,
+				       &protcno);
 		if (ret < 0)
 			exit(1);
 	}
diff --git a/man/lssu.1 b/man/lssu.1
index 2b58f8f..0607b84 100644
--- a/man/lssu.1
+++ b/man/lssu.1
@@ -35,8 +35,11 @@ List only \fIlines\fP input segments.
 .TP
 \fB\-p \fIperiod\fR, \fB\-\-protection-period\fR=\fIperiod\fR
 Specify protection period.  This option is used when printing usage
-status of the moment (with \fB\-l\fR option) to test if each
-block in segments is protected and is not reclaimable.
+status of the moment (with \fB\-l\fR option) to test if each block in
+segments is protected and is not reclaimable.  Optionally, the
+\fIperiod\fP parameter may be suffixed by one of the following units
+designators: \'s\', \'m\', \'h\', \'d\',\'w\',\'M\', or \'Y\', for
+seconds, minutes, hours, days, weeks, months, or years, respectively.
 .TP
 \fB\-V\fR, \fB\-\-version\fR
 Display version and exit.
@@ -53,8 +56,7 @@ Creation date.
 Creation time.
 .TP
 .B STAT
-State of the segment.  It consists of three flags whose meaning is
-shown below:
+State of the segment.  It consists of the following flags:
 .RS
 .TP
 .B a
@@ -67,6 +69,13 @@ The segment is dirty, meaning that it is in use.
 .B e
 The segment is erroneous, meaning that it has once caused an I/O
 error.  NILFS2 avoids allocating the segments with this flag.
+.TP
+.B p (optional)
+The segment is protected, meaning that garbage collection for the
+segment is prevented for some reason, for instance, the protection
+period is not elapsed from its last modified time, the segment is
+pinned by a super block, or it is erroneous and unreclaimable, etc.
+This flag is displayed when \fB\-l\fR option is specified.
 .RE
 .TP
 .B NBLOCKS
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
