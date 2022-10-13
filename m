From: Palmer Dabbelt <palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] MAINTAINERS: git://github -> https://github.com for konis
Date: Thu, 13 Oct 2022 14:46:38 -0700
Message-ID: <20221013214638.30933-1-palmer@rivosinc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=to:from:cc:content-transfer-encoding:mime-version:message-id:date
         :subject:from:to:cc:subject:date:message-id:reply-to;
        bh=Aa6ranh9iRasjoS2Kj2d4o4SlgNu10NUJ0u0bZB5AJA=;
        b=z+ZeS+/L8+VqUgwiDIehsX9N9VLyDedAyAIe9dyZO68zr4geeyQgp/cSkSRkJ7WwTy
         DziaL0vIrHiVaFPHTreK5VNRZWuR2aWHC69R/vKHyrNOisAsULcaL0Uh4aCs/wYok1mc
         u1B6JmNNR5Y9t9pj0ZqrrOeg8M/To6gerZuwuwXsRRjZVUIfBPp2hkXP7UClELKm7DGD
         00+SVuuH/0fBpgk1/vxp9g1p5mdoDG1IZ1zuljO8iPzArMbQHJAZsvzUaRWpk9S1oZo3
         kp/5sRDM+D5NaRPngKdJeHu+DrdoGlBvnTHXGy/W2YTf7kHkTJWwuIV3nFDHk3aCibKX
         F6EA==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Palmer Dabbelt <palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>, Conor Dooley <conor.dooley-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>

Github deprecated the git:// links about a year ago, so let's move to
the https:// URLs instead.

Reported-by: Conor Dooley <conor.dooley-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
Signed-off-by: Palmer Dabbelt <palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>
---
I've split these up by github username so folks can take them
independently, as some of these repos have been renamed at github and
thus need more than just a sed to fix them.
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d118acdce8b8..c9c396e2d8a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14363,7 +14363,7 @@ L:	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Supported
 W:	https://nilfs.sourceforge.io/
 W:	https://nilfs.osdn.jp/
-T:	git git://github.com/konis/nilfs2.git
+T:	git https://github.com/konis/nilfs2.git
 F:	Documentation/filesystems/nilfs2.rst
 F:	fs/nilfs2/
 F:	include/trace/events/nilfs2.h
-- 
2.38.0

