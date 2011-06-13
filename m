From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cleancache [3/3]
Date: Mon, 13 Jun 2011 20:08:06 +0200
Message-ID: <201106132008.06511.dexen.devries@gmail.com>
References: <20110608.230231.65968027.ryusuke@osrg.net> <201106131521.15372.dexen.devries@gmail.com> <20110613.234048.21322431.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GIl9NMylJGhzz3Q"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type:message-id;
        bh=s5R8AIBE3A0y8Ft6+mW08gner9JEzwT9Ntoyl6B4CFI=;
        b=v9210ZXX94y/IVO3TkwoypBR2Y8pumf97eg+X5Oj50NiaEqrg4rPDfFNvjyYLi7wqs
         5ciVHCfuZxpKkWNnbaFFODf+73JtKHJl+qgDx8VidoGG5jQ7R9D9WU6ZQuB8e8PLv9uM
         UnQRJ/HHHggmrVbX5k+yTgWVBzuMi2Jm1Y1h0=
In-Reply-To: <20110613.234048.21322431.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--Boundary-00=_GIl9NMylJGhzz3Q
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Monday 13 June 2011 16:40:48 you wrote:
> So, you hit the bug on a raw hadrware.
> In my hardware, /sys/kernel/mm/cleancache/* didn't change.

which most probably means you haven't had zcache enabled, due to the bug in 
its build system (as described in prev mail).


Attached is the silly patch I've used to enable cleancache for NILFS2. I have 
virtually no experience with in-kernel programming, so it may be very, very 
wrong. Terribly sorry in advance...


Happy hacking, Ryusuke,
-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''

--Boundary-00=_GIl9NMylJGhzz3Q
Content-Type: text/x-patch;
  charset="UTF-8";
  name="nilfs-cleancache-simplistic-enable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="nilfs-cleancache-simplistic-enable.patch"

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8351c44..57022bc 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -48,6 +48,7 @@
 #include <linux/writeback.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
+#include <linux/cleancache.h>
 #include "nilfs.h"
 #include "export.h"
 #include "mdt.h"
@@ -1296,6 +1297,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 		err = PTR_ERR(s);
 		goto failed;
 	}
+	cleancache_init_fs(s);
 
 	if (!s->s_root) {
 		char b[BDEVNAME_SIZE];

--Boundary-00=_GIl9NMylJGhzz3Q--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
