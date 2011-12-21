From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: [PATCH 7/7] rmcp: print sensible error message on permission failure
Date: Wed, 21 Dec 2011 15:34:09 -0600
Message-ID: <1324503249-17432-8-git-send-email-dan@archlinux.org>
References: <1324503249-17432-1-git-send-email-dan@archlinux.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=FkIvzNdA3Os5m6Aal+VuNLiFbAX1CJLl6WWNYaf5a1w=;
        b=v/ECfTba1pHhv3n42lYU6iqPF2VYORCm6/pfY2LdaiD55JL+/IzmtezrI/49Cyj6sg
         AYdxj62FCyn2oLZQ2GIaZv5pX+U29cdFg7EoFcHFJJxAMqHzPFVwZ+JzCMx39izko3FR
         vEFhjJ92C6AFsiQ3xYR/NPXElrhFMjU63aoCA=
In-Reply-To: <1324503249-17432-1-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When running as non-root, the error message seems to indicate a
checkpoint is a snapshot, rather than the actual problem, which is that
I do not have permission to delete the checkpoints.

Before:
    $ rmcp 29..35
    rmcp: 29: cannot remove snapshot
    rmcp: 30: cannot remove snapshot
    rmcp: 31: cannot remove snapshot
    rmcp: 32: cannot remove snapshot
    rmcp: 33: cannot remove snapshot
    rmcp: 34: cannot remove snapshot
    rmcp: 35: cannot remove snapshot

    To delete snapshot(s), change them into checkpoints with
    chcp command before removal.

After:
    $ ./bin/rmcp 29..35
    lt-rmcp: 29: cannot remove checkpoint: Operation not permitted
    lt-rmcp: 30: cannot remove checkpoint: Operation not permitted
    lt-rmcp: 31: cannot remove checkpoint: Operation not permitted
    lt-rmcp: 32: cannot remove checkpoint: Operation not permitted
    lt-rmcp: 33: cannot remove checkpoint: Operation not permitted
    lt-rmcp: 34: cannot remove checkpoint: Operation not permitted
    lt-rmcp: 35: cannot remove checkpoint: Operation not permitted

Since May 2009 the kernel has returned EBUSY instead of EPERM for
removal requests against snapshots, commit 30c25be71fcbd87fd. We should
be able to treat EPERM as expected now, as the commit message there
indicates.

Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
---

This does introduce a behavior change as well- we no longer exit the range loop
immediately on an error code, instead we continue the loop and attempt to
delete the rest of the checkpoints in the range. Objections to this? I'm not an
expert by any means.

 bin/rmcp.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/bin/rmcp.c b/bin/rmcp.c
index 780a192..3c5c184 100644
--- a/bin/rmcp.c
+++ b/bin/rmcp.c
@@ -105,7 +105,7 @@ static int rmcp_remove_range(struct nilfs *nilfs,
 			nd++;
 			continue;
 		}
-		if (errno == EBUSY || errno == EPERM) {
+		if (errno == EBUSY) {
 			nss++;
 			if (!force) {
 				fprintf(stderr,
@@ -115,14 +115,16 @@ static int rmcp_remove_range(struct nilfs *nilfs,
 		} else if (errno == ENOENT) {
 			nocp++;
 		} else {
-			fprintf(stderr, "%s: %s\n", progname, strerror(errno));
+			fprintf(stderr,
+				"%s: %llu: cannot remove checkpoint: %s\n",
+				progname, (unsigned long long)cno,
+				strerror(errno));
 			ret = -1;
-			goto out;
 		}
 	}
 	if (!force && (nss > 0 || (nocp > 0 && nd == 0)))
 		ret = 1;
- out:
+
 	*ndeleted = nd;
 	*nsnapshots = nss;
 	return ret;
-- 
1.7.8

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
