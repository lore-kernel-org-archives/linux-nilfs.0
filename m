From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/5] nilfs2: add a tracepoint for transaction events
Date: Wed,  7 Oct 2015 02:50:25 +0900
Message-ID: <1444153828-6747-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1444153828-6747-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=rGkM6D96pzYIsEndSsmKOLt//OG5vpvHICmXPTqP4p8=;
        b=JMvJq+XlE6LFFjmzpZ1ISg5cCH/bg8lVXgjqiR38A+kv4EPsOHg0GQjYhoiAk4H6fb
         ouTvOF9hOcCHnpcWXLgnLh7JPw/LiChb+miVnPY06QTKWvOXcut4fPMj8c6pfWyO9fbS
         jBqsPrk0TZfwX3NAjvf4gStldfqxX6qMpS/D4XwWzgWwaIwJ5d8QHdxTzwLOycMf/cD6
         8oHmqLo7gJvyEIR1ZxvfUXDwsVNYJdX26fD+XZJFBavaJkNINhrQglzO8BwnGGp/Cjb5
         Ab8nwYvf1uKOQHyWnUZGITLkicAx+yy2dnCpJaWEukSvTr5xrEFMuw29A0FAdz8P7lRE
         M1ng==
In-Reply-To: <1444153828-6747-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This patch adds a tracepoint for transaction events of nilfs. With the
tracepoint, these events can be tracked: begin, abort, commit,
trylock, lock, and unlock. Basically, these events have corresponding
functions e.g. begin event corresponds nilfs_transaction_begin(). The
unlock event is an exception. It corresponds to the iteration in
nilfs_transaction_lock().

Only one tracepoint is introcued: nilfs2_transaction_transition. The
above events are distinguished with newly introduced enum. With this
tracepoint, we can analyse a critical section of segment constructoin.

Sample output by tpoint of perf-tools:
              cp-4457  [000] ...1    63.266220: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 1 flags = 9 state = BEGIN
              cp-4457  [000] ...1    63.266221: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 0 flags = 9 state = COMMIT
              cp-4457  [000] ...1    63.266221: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800bf5ccc58 count = 0 flags = 9 state = COMMIT
        segctord-4371  [001] ...1    68.261196: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = TRYLOCK
        segctord-4371  [001] ...1    68.261280: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = LOCK
        segctord-4371  [001] ...1    68.261877: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 1 flags = 10 state = BEGIN
        segctord-4371  [001] ...1    68.262116: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 18 state = COMMIT
        segctord-4371  [001] ...1    68.265032: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 18 state = UNLOCK
        segctord-4371  [001] ...1   132.376847: nilfs2_transaction_transition: sb = ffff8802112b8800 ti = ffff8800b889bdf8 count = 0 flags = 10 state = TRYLOCK

This patch also does trivial cleaning of comma usage in collection
stage transition event for consistent coding style.

Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
---
 fs/nilfs2/segment.c           | 33 ++++++++++++++++++++++++++-
 include/trace/events/nilfs2.h | 53 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index ef35404..3fc4732 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -214,11 +214,18 @@ int nilfs_transaction_begin(struct super_block *sb,
 {
 	struct the_nilfs *nilfs;
 	int ret = nilfs_prepare_segment_lock(ti);
+	struct nilfs_transaction_info *trace_ti;
 
 	if (unlikely(ret < 0))
 		return ret;
-	if (ret > 0)
+	if (ret > 0) {
+		trace_ti = current->journal_info;
+
+		trace_nilfs2_transaction_transition(sb, trace_ti,
+				    trace_ti->ti_count, trace_ti->ti_flags,
+				    TRACE_NILFS2_TRANSACTION_BEGIN);
 		return 0;
+	}
 
 	sb_start_intwrite(sb);
 
@@ -229,6 +236,11 @@ int nilfs_transaction_begin(struct super_block *sb,
 		ret = -ENOSPC;
 		goto failed;
 	}
+
+	trace_ti = current->journal_info;
+	trace_nilfs2_transaction_transition(sb, trace_ti, trace_ti->ti_count,
+					    trace_ti->ti_flags,
+					    TRACE_NILFS2_TRANSACTION_BEGIN);
 	return 0;
 
  failed:
@@ -261,6 +273,8 @@ int nilfs_transaction_commit(struct super_block *sb)
 	ti->ti_flags |= NILFS_TI_COMMIT;
 	if (ti->ti_count > 0) {
 		ti->ti_count--;
+		trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_COMMIT);
 		return 0;
 	}
 	if (nilfs->ns_writer) {
@@ -272,6 +286,9 @@ int nilfs_transaction_commit(struct super_block *sb)
 			nilfs_segctor_do_flush(sci, 0);
 	}
 	up_read(&nilfs->ns_segctor_sem);
+	trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_COMMIT);
+
 	current->journal_info = ti->ti_save;
 
 	if (ti->ti_flags & NILFS_TI_SYNC)
@@ -290,10 +307,15 @@ void nilfs_transaction_abort(struct super_block *sb)
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
 	if (ti->ti_count > 0) {
 		ti->ti_count--;
+		trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_ABORT);
 		return;
 	}
 	up_read(&nilfs->ns_segctor_sem);
 
+	trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+		    ti->ti_flags, TRACE_NILFS2_TRANSACTION_ABORT);
+
 	current->journal_info = ti->ti_save;
 	if (ti->ti_flags & NILFS_TI_DYNAMIC_ALLOC)
 		kmem_cache_free(nilfs_transaction_cachep, ti);
@@ -339,6 +361,9 @@ static void nilfs_transaction_lock(struct super_block *sb,
 	current->journal_info = ti;
 
 	for (;;) {
+		trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_TRYLOCK);
+
 		down_write(&nilfs->ns_segctor_sem);
 		if (!test_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags))
 			break;
@@ -350,6 +375,9 @@ static void nilfs_transaction_lock(struct super_block *sb,
 	}
 	if (gcflag)
 		ti->ti_flags |= NILFS_TI_GC;
+
+	trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_LOCK);
 }
 
 static void nilfs_transaction_unlock(struct super_block *sb)
@@ -362,6 +390,9 @@ static void nilfs_transaction_unlock(struct super_block *sb)
 
 	up_write(&nilfs->ns_segctor_sem);
 	current->journal_info = ti->ti_save;
+
+	trace_nilfs2_transaction_transition(sb, ti, ti->ti_count,
+			    ti->ti_flags, TRACE_NILFS2_TRANSACTION_UNLOCK);
 }
 
 static void *nilfs_segctor_map_segsum_entry(struct nilfs_sc_info *sci,
diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.h
index 573da00..e5649ac 100644
--- a/include/trace/events/nilfs2.h
+++ b/include/trace/events/nilfs2.h
@@ -42,6 +42,59 @@ TRACE_EVENT(nilfs2_collection_stage_transition,
 		      show_collection_stage(__entry->stage))
 );
 
+#ifndef TRACE_HEADER_MULTI_READ
+enum nilfs2_transaction_transition_state {
+	TRACE_NILFS2_TRANSACTION_BEGIN,
+	TRACE_NILFS2_TRANSACTION_COMMIT,
+	TRACE_NILFS2_TRANSACTION_ABORT,
+	TRACE_NILFS2_TRANSACTION_TRYLOCK,
+	TRACE_NILFS2_TRANSACTION_LOCK,
+	TRACE_NILFS2_TRANSACTION_UNLOCK,
+};
+#endif
+
+#define show_transaction_state(type)					\
+	__print_symbolic(type,						\
+			 { TRACE_NILFS2_TRANSACTION_BEGIN, "BEGIN" },	\
+			 { TRACE_NILFS2_TRANSACTION_COMMIT, "COMMIT" },	\
+			 { TRACE_NILFS2_TRANSACTION_ABORT, "ABORT" },	\
+			 { TRACE_NILFS2_TRANSACTION_TRYLOCK, "TRYLOCK" }, \
+			 { TRACE_NILFS2_TRANSACTION_LOCK, "LOCK" },	\
+			 { TRACE_NILFS2_TRANSACTION_UNLOCK, "UNLOCK" })
+
+TRACE_EVENT(nilfs2_transaction_transition,
+	    TP_PROTO(struct super_block *sb,
+		     struct nilfs_transaction_info *ti,
+		     int count,
+		     unsigned int flags,
+		     enum nilfs2_transaction_transition_state state),
+
+	    TP_ARGS(sb, ti, count, flags, state),
+
+	    TP_STRUCT__entry(
+		    __field(void *, sb)
+		    __field(void *, ti)
+		    __field(int, count)
+		    __field(unsigned int, flags)
+		    __field(int, state)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->sb = sb;
+		    __entry->ti = ti;
+		    __entry->count = count;
+		    __entry->flags = flags;
+		    __entry->state = state;
+		    ),
+
+	    TP_printk("sb = %p ti = %p count = %d flags = %x state = %s",
+		      __entry->sb,
+		      __entry->ti,
+		      __entry->count,
+		      __entry->flags,
+		      show_transaction_state(__entry->state))
+);
+
 #endif /* _TRACE_NILFS2_H */
 
 /* This part must be outside protection */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
