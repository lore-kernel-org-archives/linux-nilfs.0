From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH 2/2] nilfs2_ss_manager: retry unmount for busy mount points
Date: Sun,  6 Feb 2011 19:14:15 +0900
Message-ID: <1296987255-29949-2-git-send-email-ryusuke@osrg.net>
References: <1296987255-29949-1-git-send-email-ryusuke@osrg.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296987255-29949-1-git-send-email-ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

Busy mount points are left in the snapshots directory.  This minimizes
the issue by retrying unmount for the busy mount points.

Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
---
 nilfs2_ss_manager/nilfs2_ss_manager |   34 ++++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/nilfs2_ss_manager/nilfs2_ss_manager b/nilfs2_ss_manager/nilfs2_ss_manager
index f19f6ba..5821e2a 100755
--- a/nilfs2_ss_manager/nilfs2_ss_manager
+++ b/nilfs2_ss_manager/nilfs2_ss_manager
@@ -63,18 +63,44 @@ class NILFSSSManager:
         else:
             os.mkdir(path)
 
-    def do_unmount_all(self):
+    def do_unmount_all(self, busy=[], failed=[]):
         for mp in self.mounts:
             cmd = 'umount %s' % mp
             result = commands.getstatusoutput(cmd)
             if result[0] == 0:
-                cmd = 'rmdir %s' %mp
+                cmd = 'rmdir %s' % mp
                 commands.getstatusoutput(cmd)
-            self.logger.out(syslog.LOG_INFO, "unmounted %s" % mp)
+                self.logger.out(syslog.LOG_INFO, "unmounted %s" % mp)
+            elif result[0] == 256:
+                self.logger.out(syslog.LOG_INFO,
+                                "failed to unmount %s (busy)" % mp)
+                busy.append(mp)
+            else:
+                self.logger.out(syslog.LOG_WARNING,
+                                "failed to unmount %s (status=%d)" %
+                                (mp, result[0]))
+                failed.append(mp)
+        self.mounts = busy
+
+    def unmount_all(self):
+        busy = []
+        failed = []
+        self.do_unmount_all(busy, failed)
+
+        retrycount = 2
+        interval = 1
+        while busy and retrycount > 0:
+            self.logger.out(syslog.LOG_INFO,
+                            "Retrying unmount (wait=%ds)" % interval)
+            time.sleep(interval)
+            busy = []
+            self.do_unmount_all(busy, failed)
+            interval <<= 1
+            retrycount -= 1
 
     def shutdown(self):
         self.aborting = 1
-        self.do_unmount_all()
+        self.unmount_all()
 
     def do_mount(self, cp, t='date'):
         target = self.mp
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
