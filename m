From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 09/10] nilfs-utils: add missing space chars
Date: Fri, 14 Feb 2014 03:24:09 +0900
Message-ID: <1392315850-29149-10-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1392315850-29149-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392315850-29149-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the following checkpatch errors:

 ERROR: spaces required around that '==' (ctx:VxV)
 #219: FILE: mount/mount_opts.c:219:
 +       if (optdata==NULL || *optdata=='\0' || optname==NULL)
                    ^

 ERROR: spaces required around that '==' (ctx:VxV)
 #219: FILE: mount/mount_opts.c:219:
 +       if (optdata==NULL || *optdata=='\0' || optname==NULL)
                                      ^

 ERROR: spaces required around that '==' (ctx:VxV)
 #219: FILE: mount/mount_opts.c:219:
 +       if (optdata==NULL || *optdata=='\0' || optname==NULL)
                                                       ^

 ERROR: spaces required around that '==' (ctx:WxV)
 #223: FILE: mount/mount_opts.c:223:
 +       data = *optdata =='"' ? strip_quotes(optdata) : optdata;
                         ^

 ERROR: spaces required around that '=' (ctx:VxV)
 #328: FILE: mount/mount_opts.c:328:
 +               for (p=opts, opt=NULL; p && *p; p++) {
                       ^

 ERROR: spaces required around that '=' (ctx:VxV)
 #328: FILE: mount/mount_opts.c:328:
 +               for (p=opts, opt=NULL; p && *p; p++) {
                                 ^
 ...

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mount/mount_opts.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sbin/mount/mount_opts.c b/sbin/mount/mount_opts.c
index 274eb4b..8588106 100644
--- a/sbin/mount/mount_opts.c
+++ b/sbin/mount/mount_opts.c
@@ -216,11 +216,11 @@ append_context(const char *optname, char *optdata, char **extra_opts)
 		/* ignore the option if we running without selinux */
 		return 0;
 
-	if (optdata==NULL || *optdata=='\0' || optname==NULL)
+	if (optdata == NULL || *optdata == '\0' || optname == NULL)
 		return -1;
 
 	/* TODO: use strip_quotes() for all mount options? */
-	data = *optdata =='"' ? strip_quotes(optdata) : optdata;
+	data = *optdata == '"' ? strip_quotes(optdata) : optdata;
 
 	if (selinux_trans_to_raw_context(
 			(security_context_t) data, &raw) == -1 ||
@@ -325,7 +325,7 @@ void parse_opts(const char *options, int *flags, char **extra_opts)
 		int open_quote = 0;
 		char *opt, *p;
 
-		for (p=opts, opt=NULL; p && *p; p++) {
+		for (p = opts, opt = NULL; p && *p; p++) {
 			if (!opt)
 				opt = p;		/* begin of the option item */
 			if (*p == '"')
@@ -335,7 +335,7 @@ void parse_opts(const char *options, int *flags, char **extra_opts)
 			if (*p == ',')
 				*p = '\0';		/* terminate the option item */
 			/* end of option item or last item */
-			if (*p == '\0' || *(p+1) == '\0') {
+			if (*p == '\0' || *(p + 1) == '\0') {
 				if (!parse_string_opt(opt))
 					parse_opt(opt, flags, extra_opts);
 				opt = NULL;
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
