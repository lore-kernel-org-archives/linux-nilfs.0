From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: update mailing list address
Date: Sat,  2 Jan 2010 21:54:54 +0900
Message-ID: <1262436894-31439-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

This replaces the list address for nilfs discussion to linux-nilfs at
vger.kernel.org from users at nilfs.org.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 Documentation/filesystems/nilfs2.txt |    2 +-
 MAINTAINERS                          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index 4949fca..839efd8 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -28,7 +28,7 @@ described in the man pages included in the package.
 Project web page:    http://www.nilfs.org/en/
 Download page:       http://www.nilfs.org/en/download.html
 Git tree web page:   http://www.nilfs.org/git/
-NILFS mailing lists: http://www.nilfs.org/mailman/listinfo/users
+List info:           http://vger.kernel.org/vger-lists.html#linux-nilfs
 
 Caveats
 =======
diff --git a/MAINTAINERS b/MAINTAINERS
index 66f5f7d..0121c61 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3882,7 +3882,7 @@ F:	drivers/net/ni5010.*
 
 NILFS2 FILESYSTEM
 M:	KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
-L:	users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
+L:	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://www.nilfs.org/en/
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
-- 
1.6.3.4
