From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/3] nilfs-utils: get rid of null checks before calling free()
Date: Mon, 19 Jan 2015 02:34:38 +0900
Message-ID: <1421602478-1896-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1421602478-1896-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=Uu5FqAaP5MUIIaBlxrMqJjUX9QlNFv5oqriPzh5fpqw=;
        b=EUdsDWR7QY8GYkLgVY/xF5mbyoy4IdDuGpSBpauq/pEw0DvQ0CJZh8EAPi051dDu5T
         l3dXSoN6ctpDVIolF9rMQtsYMxEcDnkt445Qg5doDEnCdEJkEXtJMlF1d6J+nXv0xemM
         K6pEwiV0U7FBx2Jf2JEMugVLvfxlMd/qeedVogMzMgjayhYVQnFT7BcxudxoP9XbP7nv
         ztk9dn4GPh4ytOSnIpMlqtYeSCxYVTsbIY+1B3KWLWiQc7GmKIu22+3wSrjyPCxH8qcs
         QScv6/XfCJ9bR+AuoY9xZC1v0Nb9esWnssp/s8IEW3er1eOFExnXOqBxlyflU0Qp8viF
         NH5A==
In-Reply-To: <1421602478-1896-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Remove unnecessary null checks before calling free() function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/cleaner_ctl.c |  6 ++----
 lib/gc.c          |  3 +--
 lib/nilfs.c       | 19 +++++++------------
 lib/realpath.c    |  9 +++------
 4 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/lib/cleaner_ctl.c b/lib/cleaner_ctl.c
index fa41ac1..9c458a4 100644
--- a/lib/cleaner_ctl.c
+++ b/lib/cleaner_ctl.c
@@ -226,8 +226,7 @@ static int nilfs_cleaner_find_fs(struct nilfs_cleaner *cleaner,
 					       sizeof(canonical))) {
 					mdev = canonical;
 				}
-				if (last_match_dev)
-					free(last_match_dev);
+				free(last_match_dev);
 				last_match_dev = strdup(mdev);
 				if (!last_match_dev)
 					goto error;
@@ -238,8 +237,7 @@ static int nilfs_cleaner_find_fs(struct nilfs_cleaner *cleaner,
 					       sizeof(canonical))) {
 					mdir = canonical;
 				}
-				if (last_match_dir)
-					free(last_match_dir);
+				free(last_match_dir);
 				last_match_dir = strdup(mdir);
 				if (!last_match_dir)
 					goto error;
diff --git a/lib/gc.c b/lib/gc.c
index 54d0b66..48c295a 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -508,8 +508,7 @@ static int nilfs_toss_vdescs(struct nilfs *nilfs,
 	}
 	ret = 0;
  out:
-	if (ss != NULL)
-		free(ss);
+	free(ss);
 	return ret;
 }
 
diff --git a/lib/nilfs.c b/lib/nilfs.c
index 52ddee9..30db654 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -435,13 +435,10 @@ out_fd:
 		close(nilfs->n_devfd);
 	if (nilfs->n_iocfd >= 0)
 		close(nilfs->n_iocfd);
-	if (nilfs->n_dev != NULL)
-		free(nilfs->n_dev);
-	if (nilfs->n_ioc != NULL)
-		free(nilfs->n_ioc);
-	if (nilfs->n_sb != NULL)
-		free(nilfs->n_sb);
 
+	free(nilfs->n_dev);
+	free(nilfs->n_ioc);
+	free(nilfs->n_sb);
 	free(nilfs);
 	return NULL;
 }
@@ -458,12 +455,10 @@ void nilfs_close(struct nilfs *nilfs)
 		close(nilfs->n_devfd);
 	if (nilfs->n_iocfd >= 0)
 		close(nilfs->n_iocfd);
-	if (nilfs->n_dev != NULL)
-		free(nilfs->n_dev);
-	if (nilfs->n_ioc != NULL)
-		free(nilfs->n_ioc);
-	if (nilfs->n_sb != NULL)
-		free(nilfs->n_sb);
+
+	free(nilfs->n_dev);
+	free(nilfs->n_ioc);
+	free(nilfs->n_sb);
 	free(nilfs);
 }
 
diff --git a/lib/realpath.c b/lib/realpath.c
index 3f01b87..691360b 100644
--- a/lib/realpath.c
+++ b/lib/realpath.c
@@ -133,8 +133,7 @@ myrealpath(const char *path, char *resolved_path, int maxreslth) {
 
 			/* Insert symlink contents into path. */
 			m = strlen(path);
-			if (buf)
-				free(buf);
+			free(buf);
 			buf = malloc(m + n + 1);
 			if (!buf) {
 				errno = ENOMEM;
@@ -153,12 +152,10 @@ myrealpath(const char *path, char *resolved_path, int maxreslth) {
 	/* Make sure it's null terminated. */
 	*npath = '\0';
 
-	if (buf)
-		free(buf);
+	free(buf);
 	return resolved_path;
 
  err:
-	if (buf)
-		free(buf);
+	free(buf);
 	return NULL;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
