From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 11/11] nilfs2: clean trailing semicolons in macros
Date: Fri, 29 Apr 2016 22:15:47 +0900
Message-ID: <1461935747-10380-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=BXGWlxi0fQYoFwO5Ohj+bo+h313XWms1ui9+KddXJoc=;
        b=ERjvOxV6xU+2AHxyvgmIYpHkxhbIRTNS0rFeUbaowfGtuwX9VK8TykSNj+AK90LMlg
         iRjgM3gN7RRctRPfKqZQd+p1BqhCZ0abyG/7PAoaMM5USg0vqwoTN5D2r4yc8xCjHWGO
         bPbLzEPpsniKafCf0StjRNsNqVyISvkF6U7Bh46x6iv8ejEXKDPmdtCsf0lqgCiyDoRe
         D7QKAH7tl006hRBB1CppZsQI7WQrw294QUVU5uK2M0FJ+/KIn9A4mVPneokWgRORCIpe
         SdfwksWo/nnontnr5R/KRoR00GE2uxmqHXxrI73xUvR7FH0vbMyBfyBKFIfS8s4W9WG0
         B8xw==
In-Reply-To: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Remove trailing semicolons from macros, as suggested by checkpatch.pl.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/sysfs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/sysfs.h b/fs/nilfs2/sysfs.h
index 677e3a1..648cedf 100644
--- a/fs/nilfs2/sysfs.h
+++ b/fs/nilfs2/sysfs.h
@@ -66,7 +66,7 @@ struct nilfs_##name##_attr { \
 			char *); \
 	ssize_t (*store)(struct kobject *, struct attribute *, \
 			 const char *, size_t); \
-};
+}
 
 NILFS_COMMON_ATTR_STRUCT(feature);
 
@@ -77,7 +77,7 @@ struct nilfs_##name##_attr { \
 			char *); \
 	ssize_t (*store)(struct nilfs_##name##_attr *, struct the_nilfs *, \
 			 const char *, size_t); \
-};
+}
 
 NILFS_DEV_ATTR_STRUCT(dev);
 NILFS_DEV_ATTR_STRUCT(segments);
@@ -93,7 +93,7 @@ struct nilfs_##name##_attr { \
 			char *); \
 	ssize_t (*store)(struct nilfs_##name##_attr *, struct nilfs_root *, \
 			 const char *, size_t); \
-};
+}
 
 NILFS_CP_ATTR_STRUCT(snapshot);
 
-- 
1.8.3.1

