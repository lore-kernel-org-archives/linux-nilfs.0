From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] TimeBrowse: add .gitignore file
Date: Sat,  5 Feb 2011 19:00:09 +0900
Message-ID: <1296900009-24085-1-git-send-email-ryusuke@osrg.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
---
 .gitignore |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..44df3a7
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,30 @@
+#
+# NOTE! Don't add files that are generated in specific
+# subdirectories here. Add them in the ".gitignore" file
+# in that subdirectory instead.
+
+#
+# Normal rules
+#
+.*
+*.log
+*~
+*.pyc
+*.orig
+*.rej
+
+!.gitignore
+tags
+TAGS
+GPATH
+GRTAGS
+GSYMS
+GTAGS
+
+#
+# Generated files
+#
+build
+dist
+*.egg-info
+
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
