From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2_ss_manager: rename configuration file in README
Date: Sat,  5 Feb 2011 17:47:12 +0900
Message-ID: <1296895632-23393-1-git-send-email-ryusuke@osrg.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

Renames "nilfs2_ss.conf" to "nilfs_ss.conf" in the README file.

Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
---
 nilfs2_ss_manager/README |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/nilfs2_ss_manager/README b/nilfs2_ss_manager/README
index 6bbacbe..8f5b798 100644
--- a/nilfs2_ss_manager/README
+++ b/nilfs2_ss_manager/README
@@ -20,7 +20,7 @@ Install:
 
 Configure:
 
-After install the scripts, you have to edit the /etc/nilfs2_ss.conf
+After install the scripts, you have to edit the /etc/nilfs_ss.conf
 to tell the daemon which device is the nilfs volume you want to watch,
 and which directory is the mount point to mount the managed snapshots.
 
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
