From: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
Subject: [PATCH 1/3] nilfs-utils: use _POSIX_MAX_INPUT
Date: Wed,  3 Jan 2018 21:28:21 +0100
Message-ID: <1515011303-8797-1-git-send-email-dev.kurt@vandijck-laurijssen.be>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>

musl does provide _POSIX_MAX_INPUT, but no MAX_INPUT out of the box.
This commit assigns _POSIX_MAX_INPUT to MAX_INPUT.

Signed-off-by: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
---
 bin/rmcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/bin/rmcp.c b/bin/rmcp.c
index 0140f56..6773912 100644
--- a/bin/rmcp.c
+++ b/bin/rmcp.c
@@ -47,6 +47,11 @@
 #include <limits.h>
 #endif	/* HAVE_LIMITS_H */
 
+/* define MAX_INPUT for musl */
+#ifndef MAX_INPUT
+#define MAX_INPUT _POSIX_MAX_INPUT
+#endif
+
 #include <errno.h>
 #include "nilfs.h"
 #include "parser.h"
-- 
1.8.5.rc3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
