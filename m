From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/3] nilfs2: fix irregular checkpoint creation
	due to data flush
Date: Tue,  3 Nov 2009 13:53:37 +0900
Message-ID: <1257224019-29261-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1257224019-29261-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1257224019-29261-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

When nilfs flushes out dirty data to reduce memory pressure, creation
of checkpoints is wrongly postponed.  This bug causes irregular
checkpoint creation especially in small footprint systems.

To correct this issue, a timer for the checkpoint creation has to be
continued if a log writer does not create a checkpoint.

This will do the correction.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 683df89..6eff66a 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2468,17 +2468,22 @@ static void nilfs_segctor_notify(struct nilfs_sc_info *sci,
 	/* Clear requests (even when the construction failed) */
 	spin_lock(&sci->sc_state_lock);
 
-	sci->sc_state &= ~NILFS_SEGCTOR_COMMIT;
-
 	if (req->mode == SC_LSEG_SR) {
+		sci->sc_state &= ~NILFS_SEGCTOR_COMMIT;
 		sci->sc_seq_done = req->seq_accepted;
 		nilfs_segctor_wakeup(sci, req->sc_err ? : req->sb_err);
 		sci->sc_flush_request = 0;
-	} else if (req->mode == SC_FLUSH_FILE)
-		sci->sc_flush_request &= ~FLUSH_FILE_BIT;
-	else if (req->mode == SC_FLUSH_DAT)
-		sci->sc_flush_request &= ~FLUSH_DAT_BIT;
+	} else {
+		if (req->mode == SC_FLUSH_FILE)
+			sci->sc_flush_request &= ~FLUSH_FILE_BIT;
+		else if (req->mode == SC_FLUSH_DAT)
+			sci->sc_flush_request &= ~FLUSH_DAT_BIT;
 
+		/* re-enable timer if checkpoint creation was not done */
+		if (sci->sc_timer && (sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
+		    time_before(jiffies, sci->sc_timer->expires))
+			add_timer(sci->sc_timer);
+	}
 	spin_unlock(&sci->sc_state_lock);
 }
 
-- 
1.6.3.4
