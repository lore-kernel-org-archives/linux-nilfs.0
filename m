From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 5/5] nilfs-utils: man: add description of min_free_blocks_threshold
Date: Tue, 21 Jan 2014 14:59:44 +0100
Message-ID: <648708ab2ccee79a47b5dc6e4c343d7876e6d99d.1390310509.git.andreas.rohner@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Adds a description of the new min_free_blocks_threshold and
mc_min_free_blocks_threshold options in the config file and the new
command line parameter -t for nilfs-clean.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 man/nilfs-clean.8         | 4 ++++
 man/nilfs_cleanerd.conf.5 | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/man/nilfs-clean.8 b/man/nilfs-clean.8
index 04e11c6..5af836e 100644
--- a/man/nilfs-clean.8
+++ b/man/nilfs-clean.8
@@ -67,6 +67,10 @@ until user resumes the garbage collection.
 \fB\-S\fR, \fB\-\-speed=\fICOUNT[/SECONDS]\fR
 Set garbage collection speed for a cleaner run.
 .TP
+\fB\-t\fR, \fB\-\-free\-blocks\-threshold=\fICOUNT\fR
+Specify the minimal number of free blocks before a segment can be
+cleaned
+.TP
 \fB\-v\fR, \fB\-\-verbose\fR
 Verbose mode.
 .TP
diff --git a/man/nilfs_cleanerd.conf.5 b/man/nilfs_cleanerd.conf.5
index 8f3fcd2..ccb0ade 100644
--- a/man/nilfs_cleanerd.conf.5
+++ b/man/nilfs_cleanerd.conf.5
@@ -79,6 +79,15 @@ Specify whether to use \fBmmap\fP(2) for reading segments.  At
 present, this option is enabled if supported regardless of this
 directive.
 .TP
+.B min_free_blocks_threshold
+Specify the minimal number of free blocks before a segment can be
+cleaned. Set to 0 to disable it. The default value is 256.
+.TP
+.B mc_min_free_blocks_threshold
+Specify the minimal number of free blocks before a segment can be
+cleaned if clean segments < min_clean_segments. Set to 0 to disable it.
+The default value is 128.
+.TP
 .B log_priority
 Gives the verbosity level that is used when logging messages from
 \fBnilfs_cleanerd\fP(8).  The possible values are: \fBemerg\fP,
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
