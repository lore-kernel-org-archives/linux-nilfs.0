From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/3] nilfs_cleanerd.conf: try to use set_suinfo ioctl by default
Date: Tue, 19 Aug 2014 08:52:16 +0900
Message-ID: <1408405936-6130-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1408405936-6130-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=Mw2QcVqvJYhOhNAh65ZDXRKF2hnj8EhPXHl6V4muZTk=;
        b=1CCQ1oSgGd4OQQ+9DdiJ1g8p3qV6kFLTpCsTaK6XV/xhBKFQ8YHJ0f6LyDb48Yk4jX
         1ncwhSRzqIV39LV4P4xaRlzcFYzRi3CrqFJco7lfe9gXV9t4VVRCV61EmE8frmHA5kyR
         OwvV5aZM3at+QV88CMOrWM0g78Ppv1OnNmzDO2lXIKkRGeHi4OM+kqNH/mxUJevcrRly
         9hLVGJu29TpTRI2Na9cBCJ0tScGtbQyWvWNBpIrdgvengg7weQR9Sp6TvmrXjBkG04I5
         zVaK6f2mlZKmzXH37NN5vX7aFTXlWN5SWioaX8q9r4WKHtqOFE7696U24c2hNkDe0ks7
         IZ7A==
In-Reply-To: <1408405936-6130-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, Ryusuke konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Now set_suinfo ioctl is supported by nilfs2 kernel module in mainline.
This changes nilfs_cleanerd so that it tries to use the feature by
default.  If it's not supported by the underlying kernel, the feature
will be disabled automatically.

Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/cleanerd/nilfs_cleanerd.conf |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sbin/cleanerd/nilfs_cleanerd.conf b/sbin/cleanerd/nilfs_cleanerd.conf
index 79d3fce..05cd9d4 100644
--- a/sbin/cleanerd/nilfs_cleanerd.conf
+++ b/sbin/cleanerd/nilfs_cleanerd.conf
@@ -69,7 +69,7 @@ mc_min_reclaimable_blocks	1%
 
 # enable set_suinfo ioctl if supported
 # (needed for min_reclaimable_blocks)
-#use_set_suinfo
+use_set_suinfo
 
 # Use mmap when reading segments if supported.
 use_mmap
-- 
1.7.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
