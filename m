From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] fs/Kconfig: move nilfs2 outside misc filesystems
Date: Sat,  8 Aug 2009 17:00:14 +0900
Message-ID: <1249718414-5282-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, users@nilfs.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Some people asked me questions like the following:

On Wed, 15 Jul 2009 13:11:21 +0200, Leon Woestenberg wrote:
> just wondering, any reasons why NILFS2 is one of the miscellaneous
> filesystems and, for example, btrfs, is not in Kconfig?

Actually, nilfs is NOT a filesystem came from other operating systems,
but a filesystem created purely for Linux.  Nor is it a flash
filesystem but that for generic block devices.

So, this moves nilfs outside the misc category as I responded in LKML
"Re: Why does NILFS2 hide under Miscellaneous filesystems?"
(Message-Id: <20090716.002526.93465395.ryusuke@osrg.net>).

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/Kconfig        |    2 +-
 fs/nilfs2/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 0e7da7b..455aa20 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -43,6 +43,7 @@ source "fs/xfs/Kconfig"
 source "fs/gfs2/Kconfig"
 source "fs/ocfs2/Kconfig"
 source "fs/btrfs/Kconfig"
+source "fs/nilfs2/Kconfig"
 
 endif # BLOCK
 
@@ -186,7 +187,6 @@ source "fs/romfs/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
-source "fs/nilfs2/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 72da095..251da07 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -1,6 +1,6 @@
 config NILFS2_FS
 	tristate "NILFS2 file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	select CRC32
 	help
 	  NILFS2 is a log-structured file system (LFS) supporting continuous
-- 
1.6.3.4

