From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 08/10] mount/sundires.c: fix indent
Date: Fri, 14 Feb 2014 03:24:08 +0900
Message-ID: <1392315850-29149-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Fix the following checkpatch warnings:

 WARNING: please, no spaces at the start of a line
 #41: FILE: mount/sundries.c:41:
 +     char *t;$

 WARNING: please, no spaces at the start of a line
 #43: FILE: mount/sundries.c:43:
 +     if (s == NULL)$

 WARNING: suspect code indent for conditional statements (5, 10)
 #43: FILE: mount/sundries.c:43:
 +     if (s == NULL)
 +         die(EX_SOFTWARE, _("bug in xstrndup call"));

 WARNING: please, no spaces at the start of a line
 #46: FILE: mount/sundries.c:46:
 +     t = xmalloc(n+1);$

 WARNING: please, no spaces at the start of a line
 #47: FILE: mount/sundries.c:47:
 +     strncpy(t, s, n);$

 WARNING: please, no spaces at the start of a line
 #48: FILE: mount/sundries.c:48:
 +     t[n] = 0;$

 WARNING: please, no spaces at the start of a line
 #50: FILE: mount/sundries.c:50:
 +     return t;$
 ...

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mount/sundries.c |  278 ++++++++++++++++++++++++-------------------------
 1 file changed, 138 insertions(+), 140 deletions(-)

diff --git a/sbin/mount/sundries.c b/sbin/mount/sundries.c
index 3c22106..381472b 100644
--- a/sbin/mount/sundries.c
+++ b/sbin/mount/sundries.c
@@ -38,76 +38,74 @@
 
 char *xstrndup(const char *s, int n)
 {
-     char *t;
+	char *t;
 
-     if (s == NULL)
-	  die(EX_SOFTWARE, _("bug in xstrndup call"));
+	if (s == NULL)
+		die(EX_SOFTWARE, _("bug in xstrndup call"));
 
-     t = xmalloc(n+1);
-     strncpy(t, s, n);
-     t[n] = 0;
+	t = xmalloc(n+1);
+	strncpy(t, s, n);
+	t[n] = 0;
 
-     return t;
+	return t;
 }
 
 /* reallocates its first arg - typical use: s = xstrconcat3(s,t,u); */
 char *xstrconcat3(char *s, const char *t, const char *u)
 {
-     size_t len = 0;
-
-     len = (s ? strlen(s) : 0) + (t ? strlen(t) : 0) + (u ? strlen(u) : 0);
-
-     if (!len)
-	     return NULL;
-     if (!s) {
-	     s = xmalloc(len + 1);
-	     *s = '\0';
-     }
-     else
-	     s = xrealloc(s, len + 1);
-     if (t)
-	     strcat(s, t);
-     if (u)
-	     strcat(s, u);
-     return s;
+	size_t len = 0;
+
+	len = (s ? strlen(s) : 0) + (t ? strlen(t) : 0) + (u ? strlen(u) : 0);
+
+	if (!len)
+		return NULL;
+	if (!s) {
+		s = xmalloc(len + 1);
+		*s = '\0';
+	} else {
+		s = xrealloc(s, len + 1);
+	}
+	if (t)
+		strcat(s, t);
+	if (u)
+		strcat(s, u);
+	return s;
 }
 
 /* frees its first arg - typical use: s = xstrconcat4(s,t,u,v); */
 char *xstrconcat4(char *s, const char *t, const char *u, const char *v)
 {
-     size_t len = 0;
+	size_t len = 0;
 
-     len = (s ? strlen(s) : 0) + (t ? strlen(t) : 0) +
+	len = (s ? strlen(s) : 0) + (t ? strlen(t) : 0) +
 		(u ? strlen(u) : 0) + (v ? strlen(v) : 0);
 
-     if (!len)
-	     return NULL;
-     if (!s) {
-	     s = xmalloc(len + 1);
-	     *s = '\0';
-     }
-     else
-	     s = xrealloc(s, len + 1);
-     if (t)
-	     strcat(s, t);
-     if (u)
-	     strcat(s, u);
-     if (v)
-	     strcat(s, v);
-     return s;
-
-
+	if (!len)
+		return NULL;
+	if (!s) {
+		s = xmalloc(len + 1);
+		*s = '\0';
+	} else {
+		s = xrealloc(s, len + 1);
+	}
+	if (t)
+		strcat(s, t);
+	if (u)
+		strcat(s, u);
+	if (v)
+		strcat(s, v);
+	return s;
 }
 
 /* Call this with SIG_BLOCK to block and SIG_UNBLOCK to unblock.  */
 void block_signals(int how)
 {
-     sigset_t sigs;
+	sigset_t sigs;
 
-     sigfillset(&sigs);
-     sigdelset(&sigs, SIGTRAP);
-     sigdelset(&sigs, SIGSEGV);
-     sigprocmask(how, &sigs, (sigset_t *) 0);
+	sigfillset(&sigs);
+	sigdelset(&sigs, SIGTRAP);
+	sigdelset(&sigs, SIGSEGV);
+	sigprocmask(how, &sigs, (sigset_t *)0);
 }
 
 
@@ -116,14 +114,14 @@ void block_signals(int how)
     to avoid mixing output of several threads) */
 void error(const char *fmt, ...)
 {
-     va_list args;
-
-     if (mount_quiet)
-	  return;
-     va_start(args, fmt);
-     vfprintf(stderr, fmt, args);
-     va_end(args);
-     fputc('\n', stderr);
+	va_list args;
+
+	if (mount_quiet)
+		return;
+	va_start(args, fmt);
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+	fputc('\n', stderr);
 }
 
 /* True if fstypes match.  Null *TYPES means match anything,
@@ -132,69 +130,69 @@ void error(const char *fmt, ...)
    with the same meaning. */
 int matching_type(const char *type, const char *types)
 {
-     int no;			/* negated types list */
-     int len;
-     const char *p;
-
-     if (streq(type, MNTTYPE_SWAP))
-	  return 0;
-     if (types == NULL)
-	  return 1;
-
-     no = 0;
-     if (!strncmp(types, "no", 2)) {
-	  no = 1;
-	  types += 2;
-     }
-
-     /* Does type occur in types, separated by commas? */
-     len = strlen(type);
-     p = types;
-     while (1) {
-	     if (!strncmp(p, "no", 2) && !strncmp(p+2, type, len) &&
-		 (p[len+2] == 0 || p[len+2] == ','))
-		     return 0;
-	     if (strncmp(p, type, len) == 0 &&
-		 (p[len] == 0 || p[len] == ','))
-		     return !no;
-	     p = index(p, ',');
-	     if (!p)
-		     break;
-	     p++;
-     }
-     return no;
+	int no;			/* negated types list */
+	int len;
+	const char *p;
+
+	if (streq(type, MNTTYPE_SWAP))
+		return 0;
+	if (types == NULL)
+		return 1;
+
+	no = 0;
+	if (!strncmp(types, "no", 2)) {
+		no = 1;
+		types += 2;
+	}
+
+	/* Does type occur in types, separated by commas? */
+	len = strlen(type);
+	p = types;
+	while (1) {
+		if (!strncmp(p, "no", 2) && !strncmp(p+2, type, len) &&
+		    (p[len+2] == 0 || p[len+2] == ','))
+			return 0;
+		if (strncmp(p, type, len) == 0 &&
+		    (p[len] == 0 || p[len] == ','))
+			return !no;
+		p = index(p, ',');
+		if (!p)
+			break;
+		p++;
+	}
+	return no;
 }
 
 /* Returns 1 if needle found or noneedle not found in haystack
  * Otherwise returns 0
  */
-static int
-check_option(const char *haystack, const char *needle) {
-     const char *p, *r;
-     int len, needle_len, this_len;
-     int no;
-
-     no = 0;
-     if (!strncmp(needle, "no", 2)) {
-	  no = 1;
-	  needle += 2;
-     }
-     needle_len = strlen(needle);
-     len = strlen(haystack);
-
-     for (p = haystack; p < haystack+len; p++) {
-	  r = strchr(p, ',');
-	  this_len = r ? r - p : strlen(p);
-	  if (this_len != needle_len) {
-	       p += this_len;
-	       continue;
-	  }
-	  if (strncmp(p, needle, this_len) == 0)
-	       return !no; /* foo or nofoo was found */
-	  p += this_len;
-     }
-
-     return no;  /* foo or nofoo was not found */
+static int check_option(const char *haystack, const char *needle)
+{
+	const char *p, *r;
+	int len, needle_len, this_len;
+	int no;
+
+	no = 0;
+	if (!strncmp(needle, "no", 2)) {
+		no = 1;
+		needle += 2;
+	}
+	needle_len = strlen(needle);
+	len = strlen(haystack);
+
+	for (p = haystack; p < haystack+len; p++) {
+		r = strchr(p, ',');
+		this_len = r ? r - p : strlen(p);
+		if (this_len != needle_len) {
+			p += this_len;
+			continue;
+		}
+		if (strncmp(p, needle, this_len) == 0)
+			return !no; /* foo or nofoo was found */
+		p += this_len;
+	}
+
+	return no;  /* foo or nofoo was not found */
 }
 
 
@@ -207,32 +205,32 @@ check_option(const char *haystack, const char *needle) {
  */
 int matching_opts(const char *options, const char *test_opts)
 {
-     const char *p, *r;
-     char *q;
-     int len, this_len;
-
-     if (test_opts == NULL)
-	  return 1;
-
-     len = strlen(test_opts);
-     q = alloca(len+1);
-     if (q == NULL)
-          die(EX_SYSERR, _("not enough memory"));
-
-     for (p = test_opts; p < test_opts+len; p++) {
-	  r = strchr(p, ',');
-	  this_len = r ? r - p : strlen(p);
-	  if (!this_len)
-		  continue; /* if two ',' appear in a row */
-	  strncpy(q, p, this_len);
-	  q[this_len] = '\0';
-	  if (!check_option(options, q))
-	       return 0; /* any match failure means failure */
-	  p += this_len;
-     }
-
-     /* no match failures in list means success */
-     return 1;
+	const char *p, *r;
+	char *q;
+	int len, this_len;
+
+	if (test_opts == NULL)
+		return 1;
+
+	len = strlen(test_opts);
+	q = alloca(len+1);
+	if (q == NULL)
+		die(EX_SYSERR, _("not enough memory"));
+
+	for (p = test_opts; p < test_opts+len; p++) {
+		r = strchr(p, ',');
+		this_len = r ? r - p : strlen(p);
+		if (!this_len)
+			continue; /* if two ',' appear in a row */
+		strncpy(q, p, this_len);
+		q[this_len] = '\0';
+		if (!check_option(options, q))
+			return 0; /* any match failure means failure */
+		p += this_len;
+	}
+
+	/* no match failures in list means success */
+	return 1;
 }
 
 /* Make a canonical pathname from PATH.  Returns a freshly malloced string.
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
