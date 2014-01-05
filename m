From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH nilfs-utils v2 4/4] man: remove a description of -n option
Date: Mon,  6 Jan 2014 00:52:45 +0900
Message-ID: <1388937165-32692-5-git-send-email-mitake.hitoshi@gmail.com>
References: <1388937165-32692-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7k+Av20uKRRj2JcXzslFLhVZXSLVL/kfb/sMZWcwW24=;
        b=E9r7qlPHdYLzuCYXZKZR6p+flH+KPoNrzaD80ABeFHIhgKcovExGU1Tnb3edK13Y94
         +wZZq8XpfyIc5TeVzee4qTnpyLa9bb27+VO5z9/xRX2OfBghn6oHhBKXRZXjWf1xL9YX
         65gbCXJJV9vSl7iNXadXDgduiDEz0tI3Qbw/dhdefe2R89B7ky1bZE/3Fskrt8B+1hcw
         64I7uPZE1uXEI2iQdr6CDlE0dLBRq+kEc371PinrUwKNMtFg9It2N6mdRU/F8IcUfeTC
         mSQRyZGIj62+wk1Wkbxx3a1768OkT3fv/8GfJhiNGnB/V3z3u9nwFTaVqnptnJ2YQJlF
         plEQ==
In-Reply-To: <1388937165-32692-1-git-send-email-mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Signed-off-by: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/nilfs_cleanerd.8 | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/man/nilfs_cleanerd.8 b/man/nilfs_cleanerd.8
index ad6d188..46caef2 100644
--- a/man/nilfs_cleanerd.8
+++ b/man/nilfs_cleanerd.8
@@ -35,10 +35,6 @@ Display help message and exit.
 \fB\-c \fIfile\fR, \fB\-\-conf\fR=\fIfile\fR
 Specify configuration file.
 .TP
-\fB\-n\fR, \fB\-\-nofork\fR
-invoke cleanerd without forking process. This option is intended for
-internal use from \fBmount.nilfs2\fP(8).
-.TP
 \fB\-p \fIinterval\fR, \fB\-\-protection-period\fR=\fIinterval\fR
 Override protection period with the specified number of seconds.
 .SH SIGNALS
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
