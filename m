From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: eliminate sparse warning - "context imbalance"
Date: Fri,  8 Oct 2010 22:37:28 +0900
Message-ID: <1286545048-21582-3-git-send-email-jir@unicus.jp>
References: <1286545048-21582-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286545048-21582-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, ryusuke-sG5X7nlA6pw@public.gmane.org, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

insert sparse annotations to fix following sparse warning.

fs/nilfs2/segment.c:2681:3: warning: context imbalance in 'nilfs_segctor_kill_thread' - unexpected unlock

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/segment.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 172ad42..c64f6e4 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2677,12 +2677,23 @@ static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
 {
 	sci->sc_state |= NILFS_SEGCTOR_QUIT;
 
+	/* 
+	 * nilfs_segctor_kill_thread is only called inside sc_state_lock lock.
+	 * sparse doesn't detect the context and warn "unexpected unlock".
+	 * This pretends to lock the sc_state_lock for sparse.
+	 */
+	__acquire(&sci->sc_state_lock);
 	while (sci->sc_task) {
 		wake_up(&sci->sc_wait_daemon);
 		spin_unlock(&sci->sc_state_lock);
 		wait_event(sci->sc_wait_task, sci->sc_task == NULL);
 		spin_lock(&sci->sc_state_lock);
 	}
+	/*
+	 * Pretending to lock sc_state_lock will cause "wrong count" warning.
+	 * This pretends to unlock th sc_state_lock for sparse.
+	 */
+	__release(&sci->sc_state_lock);
 }
 
 /*
-- 
1.5.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
