From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] TimeBrowse: nautilus-python is python-nautilus in Debian/Ubuntu
Date: Sat,  5 Feb 2011 14:59:58 +0900
Message-ID: <1296885598-22348-1-git-send-email-ryusuke@osrg.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The binary package name of nautilus-python is "python-nautilus" in
Debian or Ubuntu.  Adding the alias is helpful to avoid confusion.

Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
---
 nautilus/README |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/nautilus/README b/nautilus/README
index 8152aac..9cd1e1e 100644
--- a/nautilus/README
+++ b/nautilus/README
@@ -4,7 +4,7 @@ This extension is meant to be used with the Nautilus File Manager,
 
 Requirements:
     * nautilus
-    * nautilus-python
+    * nautilus-python (python-nautilus in Debian/Ubuntu)
 
 To install:
     To install for all users, copy TimeBrowse.py to:
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
