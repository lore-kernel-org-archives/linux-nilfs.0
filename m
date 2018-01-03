From: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
Subject: [PATCH 2/3] mount.nilfs: drop include rpc/types.h
Date: Wed,  3 Jan 2018 21:28:22 +0100
Message-ID: <1515011303-8797-2-git-send-email-dev.kurt@vandijck-laurijssen.be>
References: <1515011303-8797-1-git-send-email-dev.kurt@vandijck-laurijssen.be>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515011303-8797-1-git-send-email-dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>

rpc/types.h does not exist on low-footprint musl toolchains,
and is only required for the boolean types, which musl provides
elsewhere.
This commit drops the include completely.

Signed-off-by: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
---
 sbin/mount/sundries.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sbin/mount/sundries.h b/sbin/mount/sundries.h
index b3064a7..94d8ce4 100644
--- a/sbin/mount/sundries.h
+++ b/sbin/mount/sundries.h
@@ -15,9 +15,6 @@
 #include <signal.h>
 #include <stdarg.h>
 #include <stdlib.h>
-#if !defined(bool_t) && !defined(__GLIBC__)
-#include <rpc/types.h>
-#endif
 
 extern int mount_quiet;
 
-- 
1.8.5.rc3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
