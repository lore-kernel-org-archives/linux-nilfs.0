From: Qinghuang Feng <qhfeng.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] [NILFS2]: update comment for struct nilfs_dat_entry
Date: Sun, 25 Apr 2010 20:17:25 +0800
Message-ID: <1272197845-5059-1-git-send-email-qhfeng.kernel@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:from:to:cc:subject:date
         :message-id:x-mailer;
        bh=Bg++ED1nMeMKIxAPME0ZeMOpP3lnUCWuu7Y8tTFMp6I=;
        b=I9SXL1IK2p08CjWBsElk0qoFw2EhxxHYIXoFP3fzW2WdOuX+POjOaKPlR83iS4VYXT
         tJJx/n2DRTh7eZ9GeCJP8lR3mP+X5M85cf+dwLyangqi4L1+CXZRIU3OqsecWGEXfU6g
         VqVj7MNVEVjrOHgwIXADQFMDwfqqYStcdln6c=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, Qinghuang Feng <qhfeng.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The comment of struct nilfs_dat_entry is mismatched, fix it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/nilfs2_fs.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 640702e..478ee34 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -437,10 +437,10 @@ struct nilfs_palloc_group_desc {
 
 /**
  * struct nilfs_dat_entry - disk address translation entry
- * @dt_blocknr: block number
- * @dt_start: start checkpoint number
- * @dt_end: end checkpoint number
- * @dt_rsv: reserved for future use
+ * @de_blocknr: block number
+ * @de_start: start checkpoint number
+ * @de_end: end checkpoint number
+ * @de_rsv: reserved for future use
  */
 struct nilfs_dat_entry {
 	__le64 de_blocknr;
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
