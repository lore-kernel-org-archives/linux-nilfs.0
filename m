From: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH tracepoints] nilfs2: add tracepoints for analyzing sufile manipulation
Date: Tue, 29 Sep 2015 22:37:36 +0900
Message-ID: <1443533856-18827-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=3cIs8TjdnpwgZEaJJyekD9sNJ6OAzYSzmkMJoEyPmYk=;
        b=l8G33/SIu7e8PLD/nzkvs3iA/t/+yKXskDf3r1cL2n4LdAuBYaKeTzLJWqnVDaEc28
         x8gDV0Gqhvqrb7VbWs70I2fGs+BBx7k1w7JQtcVtPUt+HaSRGN6P/abBvpyX1VdaBHI+
         gma0klOWaug6NJ8zDW9iU7R5O6umDwmdUItgnqlfvVvIp31i3weaHEcwu47beZO1Zel7
         bNsW1a9/Oy1ck/jkyRt1Tl4pDYe/6TTDpvbYuvtFQampOWZ53U80eawOhuIbUoikfYYZ
         9t9e/ibHQS18oMpKypCRasxkeXw2//l/uKN46FC8mP2A1thucCxEjw3yDKHKNb/0XgWD
         vwKQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Benixon Dhas <benixon.dhas-Sjgp3cTcYWE@public.gmane.org>, TK Kato <TK.Kato-Sjgp3cTcYWE@public.gmane.org>

This patch adds tracepoints which would be useful for analyzing
segment usage from a perspective of high level sufile manipulation
(check, alloc, free). sufile is an important in-place updated metadata
file, so analyzing the behavior would be useful for performance
turning.

example of usage (a case of allocation):

$ sudo bin/tpoint nilfs2:nilfs2_segment_usage_allocated
Tracing nilfs2:nilfs2_segment_usage_allocated. Ctrl-C to end.
        segctord-17800 [002] ...1 10671.867294: nilfs2_segment_usage_allocated: sufile = ffff880054f908a8 segnum = 2
        segctord-17800 [002] ...1 10675.073477: nilfs2_segment_usage_allocated: sufile = ffff880054f908a8 segnum = 3

Cc: Benixon Dhas <benixon.dhas-Sjgp3cTcYWE@public.gmane.org>
Cc: TK Kato <TK.Kato-Sjgp3cTcYWE@public.gmane.org>
Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sufile.c            |  8 ++++++
 include/trace/events/nilfs2.h | 67 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 2a869c3..7ff8f15 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -30,6 +30,8 @@
 #include "mdt.h"
 #include "sufile.h"
 
+#include <trace/events/nilfs2.h>
+
 /**
  * struct nilfs_sufile_info - on-memory private data of sufile
  * @mi: on-memory private data of metadata file
@@ -358,6 +360,7 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 				break; /* never happens */
 			}
 		}
+		trace_nilfs2_segment_usage_check(sufile, segnum, cnt);
 		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 1,
 							   &su_bh);
 		if (ret < 0)
@@ -388,6 +391,9 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 			nilfs_mdt_mark_dirty(sufile);
 			brelse(su_bh);
 			*segnump = segnum;
+
+			trace_nilfs2_segment_usage_allocated(sufile, segnum);
+
 			goto out_header;
 		}
 
@@ -490,6 +496,8 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 	NILFS_SUI(sufile)->ncleansegs++;
 
 	nilfs_mdt_mark_dirty(sufile);
+
+	trace_nilfs2_segment_usage_freed(sufile, segnum);
 }
 
 /**
diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.h
index e5649ac..1b65ba6 100644
--- a/include/trace/events/nilfs2.h
+++ b/include/trace/events/nilfs2.h
@@ -95,6 +95,73 @@ TRACE_EVENT(nilfs2_transaction_transition,
 		      show_transaction_state(__entry->state))
 );
 
+TRACE_EVENT(nilfs2_segment_usage_check,
+	    TP_PROTO(struct inode *sufile,
+		     __u64 segnum,
+		     unsigned long cnt),
+
+	    TP_ARGS(sufile, segnum, cnt),
+
+	    TP_STRUCT__entry(
+		    __field(struct inode *, sufile)
+		    __field(__u64, segnum)
+		    __field(unsigned long, cnt)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->sufile = sufile;
+		    __entry->segnum = segnum;
+		    __entry->cnt = cnt;
+		    ),
+
+	    TP_printk("sufile = %p segnum = %llu cnt = %lu",
+		      __entry->sufile,
+		      __entry->segnum,
+		      __entry->cnt)
+);
+
+TRACE_EVENT(nilfs2_segment_usage_allocated,
+	    TP_PROTO(struct inode *sufile,
+		     __u64 segnum),
+
+	    TP_ARGS(sufile, segnum),
+
+	    TP_STRUCT__entry(
+		    __field(struct inode *, sufile)
+		    __field(__u64, segnum)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->sufile = sufile;
+		    __entry->segnum = segnum;
+		    ),
+
+	    TP_printk("sufile = %p segnum = %llu",
+		      __entry->sufile,
+		      __entry->segnum)
+);
+
+TRACE_EVENT(nilfs2_segment_usage_freed,
+	    TP_PROTO(struct inode *sufile,
+		     __u64 segnum),
+
+	    TP_ARGS(sufile, segnum),
+
+	    TP_STRUCT__entry(
+		    __field(struct inode *, sufile)
+		    __field(__u64, segnum)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->sufile = sufile;
+		    __entry->segnum = segnum;
+		    ),
+
+	    TP_printk("sufile = %p segnum = %llu",
+		      __entry->sufile,
+		      __entry->segnum)
+);
+
 #endif /* _TRACE_NILFS2_H */
 
 /* This part must be outside protection */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
