From: Pieter Smith <pieter@boesman.nl>
Subject: [PATCH 34/56] fs/nilfs2: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:11 +0100
Message-ID: <1415913813-362-35-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0TNRFy/pfylAa9C6ApxUDfOadAO3qvCv2+lRFAYIlbs=;
        b=UlnQv0B0UGZsqaviz140OnCIqc8s5VL209RxkxJ6R5d5DIF6xx1f24WgSI2rNkTa/Z
         3yGZLnjldTt5Ej5fma0piJ3WyT+s8Qw5ZkCksAz4qwOfbViS9rng9Xt3Z+iPZhgRNBv3
         XkRc/lhKfkvnpEbLCo3KxJJJ2Tls+cgSPrc9PVMcEPk7U34bsaAuXoil6nGfkL+dL8td
         Qitebs3gKpEjKldGsw5LIcrLQuTXlpXdR4qQq72N7gQG9Gw3Ec1oux6pEUCmaQaB/F6D
         AqtbSrPNeOOHZE8RTUGuHRlqUa+0RokcQYXbZ8TfDvaAsjXqgC1RnCk1P98dwvn+FH+d
         /9DA==
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, "open list:NILFS2 FILESYSTEM" <linux-nilfs@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

Compile out splice support from nilfs2 when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/nilfs2/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 2497815..dc63aea 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -164,7 +164,7 @@ const struct file_operations nilfs_file_operations = {
 	.open		= generic_file_open,
 	/* .release	= nilfs_release_file, */
 	.fsync		= nilfs_sync_file,
-	.splice_read	= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 };
 
 const struct inode_operations nilfs_file_inode_operations = {
-- 
1.9.1
