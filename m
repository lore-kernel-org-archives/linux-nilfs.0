From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: [PATCH 5/7] Use strtoull instead of strtoul where applicable
Date: Wed, 21 Dec 2011 15:34:07 -0600
Message-ID: <1324503249-17432-6-git-send-email-dan@archlinux.org>
References: <1324503249-17432-1-git-send-email-dan@archlinux.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=zSJZ4koMZ+VfbhGha5f/NBTSO16ZRzahI+pm8f3TkVU=;
        b=ABIXp1MEOdRMfYK8AUb+DjOTNu+oS3ajyPVq4/TUd4/IGLSOyTYnALQTWV+jITzX9q
         Oc/24prxIu5/Za4pZ/YQbFQENFC75oUZLEk+MmhMnfcH6p/ZvwNQAH4tJHkKcCmlLiyz
         trY63qlifK587dWyursOkE6SLV5bDS/9wdYEM=
In-Reply-To: <1324503249-17432-1-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When parsing into u64 or unsigned long long storage, we should use the
correct library function.

Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
---
 bin/dumpseg.c                  |    4 ++--
 sbin/nilfs-clean/nilfs-clean.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/bin/dumpseg.c b/bin/dumpseg.c
index fbc587d..d6b4290 100644
--- a/bin/dumpseg.c
+++ b/bin/dumpseg.c
@@ -211,7 +211,7 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "%s: too few arguments\n", progname);
 		exit(1);
 	} else {
-		strtoul(argv[optind], &endptr, DUMPSEG_BASE);
+		strtoull(argv[optind], &endptr, DUMPSEG_BASE);
 		if (*endptr == '\0')
 			dev = NULL;
 		else
@@ -229,7 +229,7 @@ int main(int argc, char *argv[])
 
 	status = 0;
 	for (i = optind; i < argc; i++) {
-		segnum = strtoul(argv[i], &endptr, DUMPSEG_BASE);
+		segnum = strtoull(argv[i], &endptr, DUMPSEG_BASE);
 		if (*endptr != '\0') {
 			fprintf(stderr, "%s: %s: invalid segment number\n",
 				progname, argv[i]);
diff --git a/sbin/nilfs-clean/nilfs-clean.c b/sbin/nilfs-clean/nilfs-clean.c
index 9d92b67..25aa14a 100644
--- a/sbin/nilfs-clean/nilfs-clean.c
+++ b/sbin/nilfs-clean/nilfs-clean.c
@@ -331,7 +331,7 @@ static int nilfs_clean_parse_protection_period(const char *arg)
 	char *endptr;
 	int ret = 0;
 
-	period = strtoul(arg, &endptr, 10);
+	period = strtoull(arg, &endptr, 10);
 	if (endptr == arg) {
 		myprintf(_("Error: invalid protection period: %s\n"), arg);
 		ret = -1;
-- 
1.7.8

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
