From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/4] nilfs2: update MAINTAINERS file entries
Date: Tue,  4 Feb 2014 01:50:41 +0900
Message-ID: <1391446244-1435-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Update git repository entry of nilfs2 file system and maintainer's
email description.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2cf5cf..342caaa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6085,10 +6085,10 @@ F:	include/uapi/linux/nfs*
 F:	include/uapi/linux/sunrpc/
 
 NILFS2 FILESYSTEM
-M:	KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
+M:	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
 L:	linux-nilfs@vger.kernel.org
 W:	http://www.nilfs.org/en/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
+T:	git git://github.com/konis/nilfs2.git
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
 F:	fs/nilfs2/
-- 
1.7.9.3
