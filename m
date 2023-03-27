From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
Date: Tue, 28 Mar 2023 02:53:18 +0900
Message-ID: <20230327175318.8060-1-konishi.ryusuke@gmail.com>
References: <00000000000000660d05f7dfa877@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679939742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTZpI//Tzxb69PVqP+6KSGMc/N99I4Rh6kzXUg6Qf3c=;
        b=KzJQ4Zoyh25lshRcEk9Mk4u3QKPhuPrEVuIW6/OcqBI/6jeJ6kxr+KuXjsy6ElQBo0
         sMReFt0dNEHFIOMCmqK27UbaRXW327gZ2dar1/V1mFTk8BzQU9RHt1bRCt2KKcJW1gK7
         qVmN28OHzRK2QsEL31t13tsKl0B11hgz8ioqV/f527m9KQMVd6EOsiCWtH3UTrGzqHRA
         YwsSsBZ7PeW+SWilcpZ/7A+nXAQHU0DZzBQe6LxcD7+fO+sgL0D75D0gbHeAqCwJUX51
         T0tHdj9igY/VgQP2ikyA5+uGafrY1Op2gxA6rP0rD+XA34AoHj+EVI8E0+KMeGgP/tJ8
         nZ9A==
In-Reply-To: <00000000000000660d05f7dfa877-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot <syzbot+b08ebcc22f8f3e6be43a-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The finalization of nilfs_segctor_thread() can race with
nilfs_segctor_kill_thread() which terminates that thread, potentially
causing a use-after-free BUG as KASAN detected.

At the end of nilfs_segctor_thread(), it assigns NULL to "sc_task" member
of "struct nilfs_sc_info" to indicate the thread has finished, and then
notifies nilfs_segctor_kill_thread() of this using waitqueue
"sc_wait_task" on the struct nilfs_sc_info.

However, here, immediately after the NULL assignment to "sc_task",
it is possible that nilfs_segctor_kill_thread() will detect it and return
to continue the deallocation, freeing the nilfs_sc_info structure before
the thread does the notification.

This fixes the issue by protecting the NULL assignment to "sc_task" and
its notification, with spinlock "sc_state_lock" of the struct
nilfs_sc_info.  Since nilfs_segctor_kill_thread() does a final check to
see if "sc_task" is NULL with "sc_state_lock" locked, this can eliminate
the race.

Reported-by: syzbot+b08ebcc22f8f3e6be43a-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Link: https://lkml.kernel.org/r/00000000000000660d05f7dfa877-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/segment.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 19446a8243d7..6ad41390fa74 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2609,11 +2609,10 @@ static int nilfs_segctor_thread(void *arg)
 	goto loop;
 
  end_thread:
-	spin_unlock(&sci->sc_state_lock);
-
 	/* end sync. */
 	sci->sc_task = NULL;
 	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_kill_thread() */
+	spin_unlock(&sci->sc_state_lock);
 	return 0;
 }
 
-- 
2.34.1

