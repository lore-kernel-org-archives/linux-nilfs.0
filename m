From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2_ss_manager: fix TypeError at exit
Date: Sun,  6 Feb 2011 21:24:17 +0900
Message-ID: <1296995057-30479-1-git-send-email-ryusuke@osrg.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

Fixes the following error on shutdown:

Traceback (most recent call last):
  File "./nilfs2_ss_manager", line 211, in <module>
    mainloop.run()
TypeError: __exit__() takes exactly 1 argument (4 given)

Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
---
 nilfs2_ss_manager/nilfs2_ss_manager |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/nilfs2_ss_manager/nilfs2_ss_manager b/nilfs2_ss_manager/nilfs2_ss_manager
index 5821e2a..cff7d35 100755
--- a/nilfs2_ss_manager/nilfs2_ss_manager
+++ b/nilfs2_ss_manager/nilfs2_ss_manager
@@ -150,7 +150,7 @@ class NODaemonContext:
     def __enter__(self):
         pass
 
-    def __exit__(self):
+    def __exit__(self, *execinfo):
         pass
 
 def register_sighandlers(managers, mainloop):
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
