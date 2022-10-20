From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] MAINTAINERS: git://github.com -> https://github.com for nilfs2
Date: Thu, 20 Oct 2022 11:42:55 +0900
Message-ID: <20221020024255.5000-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HdycwA4FR5vNtX+7nFM1KQuIbhzsWKkIyNCEoTxZqj4=;
        b=WoV/wKOqLYiqQq1ulcH8t/cuwosFM5L9AWFxS+1A/2aZHrK0wSvKRwtntvRSgCCitU
         iLX423YiB7fSNb3qLYBsKlCp2c+pCm0Ien021Fs2GCpM0Gq/VjFF8qKOe7fkDQChESs1
         gmlyTyuQBttLFj63/rf/Zt8RxErSlp7uhSMXARmVs+7YWwcjmMF1P3idXFNpBBJXyIx6
         u4HLoaM5bp8TMjANqMdsy6G9yCjVF2+sSsFp8AUo64nftOQ1xFt3BD7HicUV1Rdns5rc
         rFkzEC8hlpQLLH5/XP0B/YA/ydf2bbKF4MG8ZL7ewEBTnIdOd9IPGoN1+bukQAsh0cZS
         vuRg==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Palmer Dabbelt <palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>

Github deprecated the git:// links about a year ago, so let's move to
the https:// URLs instead.

Signed-off-by: Palmer Dabbelt <palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>
Reported-by: Conor Dooley <conor.dooley-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
Link: https://lkml.kernel.org/r/20221013214638.30933-1-palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Please queue this like other similar fixes.

Thanks,
Ryusuke Konishi

MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ca063a504026..c3382e7e89ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14524,7 +14524,7 @@ L:	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Supported
 W:	https://nilfs.sourceforge.io/
 W:	https://nilfs.osdn.jp/
-T:	git git://github.com/konis/nilfs2.git
+T:	git https://github.com/konis/nilfs2.git
 F:	Documentation/filesystems/nilfs2.rst
 F:	fs/nilfs2/
 F:	include/trace/events/nilfs2.h
-- 
2.34.1

