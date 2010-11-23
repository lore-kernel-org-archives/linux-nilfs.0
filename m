From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] MAINTAINERS: add nilfs2 git tree entry
Date: Wed, 24 Nov 2010 00:00:32 +0900
Message-ID: <1290524432-5607-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

NILFS2 filesystem section of the MAINTAINERS file lacks an entry of
scm tree.  This adds it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a92c994..c68e816 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4230,6 +4230,7 @@ NILFS2 FILESYSTEM
 M:	KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
 L:	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://www.nilfs.org/en/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
 F:	fs/nilfs2/
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
