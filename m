From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs_cleanerd: support relative pathnames in arguments
Date: Sun,  6 Mar 2011 22:30:18 +0100
Message-ID: <1299447018-19088-1-git-send-email-dexen.devries@gmail.com>
References: <20110304.120604.248913114.ryusuke@osrg.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:message-id:x-mailer
         :in-reply-to:references:x-face;
        bh=i6HkvrcsCwo6DhNZ3ouL5Dgt4fD36pJu8buJprJWDgo=;
        b=nfSkEPzZQe69WAYTCEhX2tVEzZGnED4HbgxauTeGiRO7NIOBN5wo7GHT2ONAU2BQme
         v6PfvPE2kqj7cdaxEAZmkgesTCzeBDlgDl4BoZ/P+KCdZaHU5AiSnPfXByaSMiiQL1sH
         I+AVm5iWfl3pLi7omukLuZNjZvb7rEcYhe9Ak=
In-Reply-To: <20110304.120604.248913114.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

canonicalize pathnames of device & directory before daemonize() to support relative pathnames

Signed-off-by: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 1f03cfb..3d58916 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -1343,6 +1343,7 @@ static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
 int main(int argc, char *argv[])
 {
 	char *progname, *conffile;
+	char canonical[PATH_MAX + 2];
 	const char *dev, *dir;
 	char *endptr;
 	int status, nofork, c;
@@ -1406,6 +1407,12 @@ int main(int argc, char *argv[])
 	if (optind < argc)
 		dir = argv[optind++];
 
+	if (dev && myrealpath(dev, canonical, sizeof(canonical)))
+		dev = strdup(canonical);
+
+	if (dir && myrealpath(dir, canonical, sizeof(canonical)))
+		dir = strdup(canonical);
+
 	if (daemonize(0, 0, nofork) < 0) {
 		fprintf(stderr, "%s: %s\n", progname, strerror(errno));
 		exit(1);
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
