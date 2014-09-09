From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] lscp: show snapshots, even if marked minor (reverse mode)
Date: Wed, 10 Sep 2014 05:24:22 +0900
Message-ID: <1410294262-16936-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=z7cXtYwNImUX3ItCztL2IKixBifO0xApinuL+62H270=;
        b=mDHjnXU0twxPwxkSsnnO+4JRHhtwtNESFDsPvtoqvV0Ik1EH597VWkmQFuV4r73Xfr
         8vOS5zGlPnFpHEsSmk5SP0frcg3uQPA149jBHZt7hdT7Gi49EgNaZrygRdegd9YJ9eQj
         dR/CnrK8PahXgmwBBpEAcTU4ZoCpNsUl6og9QsSnwczU/jPGiPwyw0Wksbqgzlx7ycbp
         4yFp7JNzURtFEnQbrWyjq+LaGayvG7WG7yR2fc7Xd7VCmgrzJPfBkvqd03MPWCU+VYho
         tqKtcGDY87x7/PxCV6m9c9ltXXWYamJh/FWRAwyXsM1mkBXmIkOHjC7DrLGgZ4T3GdZq
         LmPw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>

Apply the same change as the commit
d04aea7db2281d2f22d1c943dc5791931db8c474 "lscp: always show snapshots,
even if marked minor" for reverse mode.

Cc: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lscp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/bin/lscp.c b/bin/lscp.c
index a7bf555..c855def 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -198,7 +198,8 @@ static int lscp_backward_cpinfo(struct nilfs *nilfs,
 
 		for (cpi = cpinfos + n - 1; cpi >= cpinfos && rest > 0; cpi--) {
 			if (cpi->ci_cno < eidx &&
-			    (show_all || !nilfs_cpinfo_minor(cpi))) {
+			    (show_all || nilfs_cpinfo_snapshot(cpi) ||
+			     !nilfs_cpinfo_minor(cpi))) {
 				lscp_print_cpinfo(cpi);
 				rest--;
 			}
-- 
1.7.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
