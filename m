From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] fs/nilfs2: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 16:59:00 -0700
Message-ID: <20171016235900.GA102729@beast>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=fDRG07VT1mwEgHLDeoeUsuGa/Y9fGavhA2IEttRhtkQ=;
        b=cbcAi6zMO/nxfxOMQX5kHarP3nywi4d26dbfys0AuzQKtJmfoevoQcEmXYVyZVwajn
         wsimyfWTv+yXzXnlsaYEEpXEaMM6R4fE0xeDP1o/5UjrIr3gvxHmFERRFtIHUpu2NwXH
         quk5XC438kSeJnpEFxk3OGcTi9j00bjeZBX/0=
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly. This requires adding a pointer to
hold the timer's target task, as the lifetime of sc_task doesn't appear to
match the timer's task.

Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 fs/nilfs2/segment.c | 11 +++++------
 fs/nilfs2/segment.h |  1 +
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 70ded52dc1dd..07b6154a081e 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2404,11 +2404,11 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 	return err;
 }
 
-static void nilfs_construction_timeout(unsigned long data)
+static void nilfs_construction_timeout(struct timer_list *t)
 {
-	struct task_struct *p = (struct task_struct *)data;
+	struct nilfs_sc_info *sci = from_timer(sci, t, sc_timer);
 
-	wake_up_process(p);
+	wake_up_process(sci->sc_timer_task);
 }
 
 static void
@@ -2546,8 +2546,7 @@ static int nilfs_segctor_thread(void *arg)
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int timeout = 0;
 
-	sci->sc_timer.data = (unsigned long)current;
-	sci->sc_timer.function = nilfs_construction_timeout;
+	sci->sc_timer_task = current;
 
 	/* start sync. */
 	sci->sc_task = current;
@@ -2678,7 +2677,7 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct super_block *sb,
 	INIT_LIST_HEAD(&sci->sc_gc_inodes);
 	INIT_LIST_HEAD(&sci->sc_iput_queue);
 	INIT_WORK(&sci->sc_iput_work, nilfs_iput_work_func);
-	init_timer(&sci->sc_timer);
+	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
 	sci->sc_interval = HZ * NILFS_SC_DEFAULT_TIMEOUT;
 	sci->sc_mjcp_freq = HZ * NILFS_SC_DEFAULT_SR_FREQ;
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 1060949d7dd2..84084a4d9b3e 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -180,6 +180,7 @@ struct nilfs_sc_info {
 	unsigned long		sc_watermark;
 
 	struct timer_list	sc_timer;
+	struct task_struct     *sc_timer_task;
 	struct task_struct     *sc_task;
 };
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
