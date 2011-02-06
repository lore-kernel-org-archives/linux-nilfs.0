From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH 1/2] nilfs2_ss_manager: stop creating snapshot during shutdown
Date: Sun,  6 Feb 2011 19:14:14 +0900
Message-ID: <1296987255-29949-1-git-send-email-ryusuke@osrg.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

When the snapshot daemon shuts down by interrupt, it can failed to
unmount a part of snapshots since snapshot can be created during
shutdown the daemon.

This fixes the issue by disabling the snapshot creation when the
daemon goes to shutdown state.

Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
---
 nilfs2_ss_manager/nilfs2_ss_manager |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/nilfs2_ss_manager/nilfs2_ss_manager b/nilfs2_ss_manager/nilfs2_ss_manager
index 3056bcb..f19f6ba 100755
--- a/nilfs2_ss_manager/nilfs2_ss_manager
+++ b/nilfs2_ss_manager/nilfs2_ss_manager
@@ -52,6 +52,7 @@ class NILFSSSManager:
         self.mp = mp
         self.logger = logger
         self.mounts = []
+        self.aborting = 0
 
     def create_dir(self, path):
         if os.path.exists(path):
@@ -71,6 +72,10 @@ class NILFSSSManager:
                 commands.getstatusoutput(cmd)
             self.logger.out(syslog.LOG_INFO, "unmounted %s" % mp)
 
+    def shutdown(self):
+        self.aborting = 1
+        self.do_unmount_all()
+
     def do_mount(self, cp, t='date'):
         target = self.mp
         if t == 'date':
@@ -88,9 +93,12 @@ class NILFSSSManager:
                         "mount ss = %d on %s" % (cp['cno'],target))
 
     def create_ss(self):
+        if self.aborting: return
         cps = self.ns.lscp()[:]
         cps.reverse()
         for cp in cps:
+            if self.aborting:
+                break
             if cp['ss']:
                 break
             self.logger.out(syslog.LOG_INFO,
@@ -122,7 +130,7 @@ class NODaemonContext:
 def register_sighandlers(managers, mainloop):
     def do_exit(a,b):
         for m in managers:
-            m.do_unmount_all()
+            m.shutdown()
         mainloop.quit()
     signal.signal(signal.SIGINT, do_exit)
     signal.signal(signal.SIGTERM, do_exit)
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
