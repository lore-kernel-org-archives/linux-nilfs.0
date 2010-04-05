From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: patch to fix two little typos in comments
Date: Mon, 05 Apr 2010 15:42:29 +0200
Message-ID: <4BB9E8C5.5040300@prnet.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060905030705040402040405"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.
--------------060905030705040402040405
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------060905030705040402040405
Content-Type: text/plain;
 name="comments.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="comments.patch"

diff -ur nilfs2-utils.orig/sbin/cleanerd/cldconfig.h nilfs2-utils/sbin/cleanerd/cldconfig.h
--- nilfs2-utils.orig/sbin/cleanerd/cldconfig.h	2010-04-05 15:37:50.870500143 +0200
+++ nilfs2-utils/sbin/cleanerd/cldconfig.h	2010-04-05 15:39:27.359360247 +0200
@@ -77,7 +77,7 @@
  * @cf_min_clean_segments: low threshold on the number of free segments
  * @cf_max_clean_segments: high threshold on the number of free segments
  * @cf_clean_check_interval: cleaner check interval
- * @cf_nsegments_per_clean number of segments reclaimed per clean cycle
+ * @cf_nsegments_per_clean: number of segments reclaimed per clean cycle
  * @cf_cleaning_interval: cleaning interval
  * @cf_use_mmap: flag that indicate using mmap
  * @cf_log_priority: log priority level
diff -ur nilfs2-utils.orig/sbin/cleanerd/nilfs_cleanerd.conf nilfs2-utils/sbin/cleanerd/nilfs_cleanerd.conf
--- nilfs2-utils.orig/sbin/cleanerd/nilfs_cleanerd.conf	2010-04-05 15:37:50.870500143 +0200
+++ nilfs2-utils/sbin/cleanerd/nilfs_cleanerd.conf	2010-04-05 15:38:34.406684384 +0200
@@ -37,7 +37,7 @@
 # The maximum number of segments to be cleaned at a time.
 nsegments_per_clean	2
 
-# Cleaning interval in second.
+# Cleaning interval in seconds.
 cleaning_interval	5
 
 # Retry interval in seconds.

--------------060905030705040402040405--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
