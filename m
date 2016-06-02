From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 8/8] nilfs2: refactor parser of snapshot mount option
Date: Thu,  2 Jun 2016 22:58:11 +0900
Message-ID: <1464875891-5443-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1464875891-5443-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=7UqPeQhb0SCX3rb36Z62UnFrpPtKp06tO0I1HDt56RY=;
        b=IQkcwruvtaujJPk2SnJozHapZtYygxXHVbLLZT2CBwEmEMtw+rN66anViPHEuRmYJ0
         pWDhCLHmsBndNJIVPaQC6JKNmBEYya8U1K7VUa/MQDYt7UU36VJ28MD++fMfO/7btLq7
         6SKpHqgKmYrVOzt+aQU6oBSXwhzleu+2SBhsewRClWbsxYDMoWEUpA5Q46L7dsbC0sfI
         Vm72kCeblXMf4H5J8H8m88U73SobvhdXvpGsLTvS/LBNspvaQ8qaNUnDpdhmmHbf0ohS
         eo3RBJA7cg62d1ivtZ7HEFFF/LGLrX0WtQRFNUwoqNJ58YlrW9V+kL54kF3BIP1V6wVS
         i6dQ==
In-Reply-To: <1464875891-5443-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Move parser of snapshot mount option to a separate function
nilfs_parse_snapshot_option(), replace simple_strtoull() with
kstrtoull() to avoid checkpatch.pl warning "WARNING: simple_strtoull
is obsolete, use kstrtoull instead", and refine the error message of
the parser.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c | 53 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 33ba6f7..c95d369 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1205,6 +1205,38 @@ struct nilfs_super_data {
 	int flags;
 };
 
+static int nilfs_parse_snapshot_option(const char *option,
+				       const substring_t *arg,
+				       struct nilfs_super_data *sd)
+{
+	unsigned long long val;
+	const char *msg = NULL;
+	int err;
+
+	if (!(sd->flags & MS_RDONLY)) {
+		msg = "read-only option is not specified";
+		goto parse_error;
+	}
+
+	err = kstrtoull(arg->from, 0, &val);
+	if (err) {
+		if (err == -ERANGE)
+			msg = "too large checkpoint number";
+		else
+			msg = "malformed argument";
+		goto parse_error;
+	} else if (val == 0) {
+		msg = "invalid checkpoint number 0";
+		goto parse_error;
+	}
+	sd->cno = val;
+	return 0;
+
+parse_error:
+	nilfs_msg(NULL, KERN_ERR, "invalid option \"%s\": %s", option, msg);
+	return 1;
+}
+
 /**
  * nilfs_identify - pre-read mount options needed to identify mount instance
  * @data: mount options
@@ -1221,24 +1253,9 @@ static int nilfs_identify(char *data, struct nilfs_super_data *sd)
 		p = strsep(&options, ",");
 		if (p != NULL && *p) {
 			token = match_token(p, tokens, args);
-			if (token == Opt_snapshot) {
-				if (!(sd->flags & MS_RDONLY)) {
-					ret++;
-				} else {
-					sd->cno = simple_strtoull(args[0].from,
-								  NULL, 0);
-					/*
-					 * No need to see the end pointer;
-					 * match_token() has done syntax
-					 * checking.
-					 */
-					if (sd->cno == 0)
-						ret++;
-				}
-			}
-			if (ret)
-				nilfs_msg(NULL, KERN_ERR,
-					  "invalid mount option: %s", p);
+			if (token == Opt_snapshot)
+				ret = nilfs_parse_snapshot_option(p, &args[0],
+								  sd);
 		}
 		if (!options)
 			break;
-- 
1.8.3.1

