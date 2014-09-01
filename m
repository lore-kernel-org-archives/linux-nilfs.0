From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: [PATCH] lscp: always show snapshots, even if marked minor
Date: Mon,  1 Sep 2014 14:48:46 -0500
Message-ID: <1409600926-25385-1-git-send-email-dan@archlinux.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:subject:date:message-id;
        bh=K5FDxrWj3LFX9RrbBKAHqXvRM03mbkk8/PpLICgu8k0=;
        b=ZRm9SRkoTLio68jpfM+7cobPnC9y6DrCxGIkDXIsQZyIWAB7aojp4SfIxbSoIWudyv
         RieqItZExdnmmqJShkimjaTY2Xq8qyi08Xuo3lh2+hS6T2L/oCJzMSHkzCAP6tNfpxQ+
         K1aC1Xya+br15rGYAB1VNI8xsYQHgVs6cgEnV+KqrZqHt6QFctTkijjRysdbtwLA1LRW
         qEhKNwy/8nwjGK7+lTEyWcOUN+UQ93lA0hfedSsXGrr/l8v5LSKn2miXptTjdd2rN/ls
         xi7el2qp05qCqPWbINrVZ+io5TuQwEPXUM0WtYXAPOi+GKJSwYysZUMRvA8Y2jEXt+Qy
         kxSQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When the average user types `lscp` and doesn't see the snapshot they
just tried to make, it can be very confusing. Add an additional check
to ensure snapshots are never omitted from lscp output.

Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
---

Thoughts? I notice this quite often due to a "snapshot-on-shutdown" job I have
running on my machine, and it is very odd to not see this snapshot listed next
time I boot up and run `lscp -r | less`.

 bin/lscp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bin/lscp.c b/bin/lscp.c
index 2de81b6..6803657 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -159,7 +159,7 @@ static int lscp_forward_cpinfo(struct nilfs *nilfs,
 			break;
 
 		for (cpi = cpinfos; cpi < cpinfos + n; cpi++) {
-			if (show_all || !nilfs_cpinfo_minor(cpi)) {
+			if (show_all || nilfs_cpinfo_snapshot(cpi) || !nilfs_cpinfo_minor(cpi)) {
 				lscp_print_cpinfo(cpi);
 				rest--;
 			}
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
