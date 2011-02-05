From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2_ss_manager: handle error during loading conffile
Date: Sun,  6 Feb 2011 01:26:04 +0900
Message-ID: <1296923164-25641-1-git-send-email-ryusuke@osrg.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

The error messages printed when failed to load the config file are
confusing.  This makes it better.

Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
---
 nilfs2_ss_manager/nilfs2_ss_manager |   39 ++++++++++++++++++++++++++--------
 1 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/nilfs2_ss_manager/nilfs2_ss_manager b/nilfs2_ss_manager/nilfs2_ss_manager
index 6668127..34b887d 100755
--- a/nilfs2_ss_manager/nilfs2_ss_manager
+++ b/nilfs2_ss_manager/nilfs2_ss_manager
@@ -123,6 +123,20 @@ def register_sighandlers(managers, mainloop):
     signal.signal(signal.SIGINT, do_exit)
     signal.signal(signal.SIGTERM, do_exit)
 
+def check_configuration(conf, conffile, logger):
+    errors = []
+    for key in ['devices', 'period', 'pidfile']:
+        if not key in conf:
+            errors.append("No '%s' key defined" % key)
+        elif not conf[key]:
+            errors.append("'%s' key has no value" % key)
+
+    if len(errors) > 0:
+        logger.out(syslog.LOG_ERR, "Configuration error in %s" % conffile)
+        for error in errors:
+            logger.out(syslog.LOG_ERR, "  " + error),
+        exit(1)
+
 logger = Logger()
 try:
     parser = argparse.ArgumentParser(description="NILFS2 snapshot manager")
@@ -139,6 +153,8 @@ try:
     daemonize = args.daemonize
    
     conf = yaml.safe_load(open(conffile))
+    check_configuration(conf, conffile, logger)
+
     devices = conf['devices']
     period = conf['period']
 
@@ -159,12 +175,17 @@ try:
         register_sighandlers(managers, mainloop)
         mainloop.run()
 
-except yaml.scanner.ScannerError:
-    logger.out(syslog.LOG_INFO, "can not parse config file %s" % conffile)
-
-except KeyError:
-    logger.out(syslog.LOG_INFO, "configuration error: %s" % conffile)
-    for key in ['devices', 'period', 'pidfile']:
-        if not key in conf:
-            logger.out(syslog.LOG_INFO,
-                       "'%s' is not in the configuration" % key)
+except yaml.YAMLError, e:
+    pos = None
+    if (hasattr(e, 'problem') and hasattr(e, 'context_mark') and
+        hasattr(e, 'problem_mark')):
+        if e.context_mark is not None:
+            pos = (e.context_mark.line, e.context_mark.column)
+        elif e.problem_mark is not None:
+            pos = (e.problem_mark.line, e.problem_mark.column)
+
+    logger.out(syslog.LOG_ERR, "Error" +
+               (" near line %s, column %s" % pos if pos else "") +
+               " while loading " + conffile)
+    if hasattr(e, 'problem') and (e.problem is not None):
+        logger.out(syslog.LOG_ERR, "  Reason: %s" % e.problem)
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
