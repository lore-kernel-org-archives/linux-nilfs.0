From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: [PATCH 1/2] nilfs-tune: add static/const specifiers where applicable
Date: Fri, 23 Dec 2011 09:11:15 -0600
Message-ID: <1324653076-13692-1-git-send-email-dan@archlinux.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        bh=T7WGgkiJ4wR0LhqyMf6QdH3twtLz6dFbryiLWuSS2Wg=;
        b=jbrECVChWJxsOL8+KQc49gIka8b0N5ZGKojBwwZISnz6oiblDlNlFFvVwj8RsOO5gV
         HT16gRJUvdJEIUzHVH+zU6PWucfC5cRfDw1EaCqtBqVioxwSFFPm8vR+rps1tSOwsGKO
         LCJmUWowoI1G0g/qeRg3sUMwg/SATjJD4H+S0=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
---
 sbin/nilfs-tune/nilfs-tune.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
index d5bc00f..cd5ef24 100644
--- a/sbin/nilfs-tune/nilfs-tune.c
+++ b/sbin/nilfs-tune/nilfs-tune.c
@@ -100,7 +100,7 @@ const static __u64 clear_ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	0
 };
 
-int parse_uuid(const char *uuid_string, __u8 *uuid)
+static int parse_uuid(const char *uuid_string, __u8 *uuid)
 {
 	int i;
 	char p[3];
@@ -126,7 +126,8 @@ int parse_uuid(const char *uuid_string, __u8 *uuid)
 	return 0;
 }
 
-void parse_options(int argc, char *argv[], struct nilfs_tune_options *opts)
+static void parse_options(int argc, char *argv[],
+		struct nilfs_tune_options *opts)
 {
 	int c;
 	opts->flags = O_RDONLY;
@@ -274,7 +275,7 @@ static const char *group_string(gid_t gid)
 	return buf;
 }
 
-static const char *uuid_string(unsigned char *uuid)
+static const char *uuid_string(const unsigned char *uuid)
 {
 	static char buf[256];
 
@@ -349,7 +350,7 @@ static void print_features(FILE *f, struct nilfs_super_block *sbp)
 	fputs("\n", f);
 }
 
-void show_nilfs_sb(struct nilfs_super_block *sbp)
+static void show_nilfs_sb(struct nilfs_super_block *sbp)
 {
 	char label[sizeof(sbp->s_volume_name) + 1];
 	gid_t gid;
@@ -491,7 +492,7 @@ static int update_feature_set(struct nilfs_super_block *sbp,
 	return ret;
 }
 
-int modify_nilfs(char *device, struct nilfs_tune_options *opts)
+static int modify_nilfs(const char *device, struct nilfs_tune_options *opts)
 {
 	int devfd;
 	int ret = EXIT_SUCCESS;
@@ -563,7 +564,7 @@ out:
 int main(int argc, char *argv[])
 {
 	struct nilfs_tune_options opts;
-	char *device;
+	const char *device;
 
 	printf("nilfs-tune %s\n", VERSION);
 	if (argc < 2) {
-- 
1.7.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
