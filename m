From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs-utils: Simple notes about compiling.
Date: Thu,  7 Oct 2010 20:24:20 +0900
Message-ID: <1286450660-21481-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Andrea Gelmini <andrea.gelmini-PT7Us6ch6G9eoWH0uzbU5w@public.gmane.org>

From: Andrea Gelmini <andrea.gelmini-PT7Us6ch6G9eoWH0uzbU5w@public.gmane.org>

Borrowed from http://marc.info/?l=linux-nilfs&m=128542348518482&w=2

Modified by Ryusuke Konishi to separate cases where users need to run
autoconf/automake tools.

Signed-off-by: Andrea Gelmini <andrea.gelmini-PT7Us6ch6G9eoWH0uzbU5w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 README |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/README b/README
index e69de29..bc2faff 100644
--- a/README
+++ b/README
@@ -0,0 +1,17 @@
+* How to compile
+
+ $ ./configure
+ $ make
+
+* How to get development sources
+
+ $ cd your-work-directory
+ $ git clone http://git.nilfs.org/nilfs2-utils.git
+
+Before compiling the development sources, you need to run
+autoconf/automake tools.  This is not required for packaged sources
+unless you changed the configuration.
+ 
+ $ cd nilfs2-utils
+ $ aclocal && autoheader && libtoolize -c --force && automake -a -c && autoconf
+
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
