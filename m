From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: [RFC][PATCH v2 28/31] timers: fs/nilfs2: Use del_timer_shutdown() before freeing timer
Date: Thu, 27 Oct 2022 11:05:53 -0400
Message-ID: <20221027150930.513327801@goodmis.org>
References: <20221027150525.753064657@goodmis.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: "Steven Rostedt (Google)" <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>

Before a timer is freed, del_timer_shutdown() must be called.

Link: https://lore.kernel.org/all/20220407161745.7d6754b3-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org/

Cc: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Steven Rostedt (Google) <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
---
 fs/nilfs2/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index b4cebad21b48..1d3f89de1cd2 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2752,7 +2752,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 
 	down_write(&nilfs->ns_segctor_sem);
 
-	del_timer_sync(&sci->sc_timer);
+	del_timer_shutdown(&sci->sc_timer);
 	kfree(sci);
 }
 
-- 
2.35.1
