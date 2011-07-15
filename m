From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [GIT PULL] nilfs2 fix
Date: Sat, 16 Jul 2011 02:51:34 +0900 (JST)
Message-ID: <20110716.025134.152331037.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive a documentation fix for a change in this cycle.


Thanks,

Ryusuke Konishi
--
The following changes since commit 620917de59eeb934b9f8cf35cc2d95c1ac8ed0fc:

  Linux 3.0-rc7 (2011-07-11 16:51:52 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Ryusuke Konishi (1):
      nilfs2: remove resize from unsupported features list

 Documentation/filesystems/nilfs2.txt |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index d5c0cef..873a2ab 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -40,7 +40,6 @@ Features which NILFS2 does not support yet:
 	- POSIX ACLs
 	- quotas
 	- fsck
-	- resize
 	- defragmentation
 
 Mount options
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
