From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] mkfs.nilfs2: fix gcc warning "array subscript is above array bounds"
Date: Fri, 22 Aug 2014 20:06:42 +0900
Message-ID: <1408705602-19780-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=4F5p6BI25R0vBW1TOKnwklO9f1hKr+UULYoA9EaG9as=;
        b=Mrn6IG7CpboWxj9VqGgUJsHjxCgRfCrsBNOQN8s/H4nL05CkZnZA1YPuDsU89kvQUB
         cjgsRCaSeUSHJiJFUAOLnUzbNWBlVTuvY2RU2YorM5bKoFVGjdMXVuilhzUum/A0pD3X
         ZN2KWftekBvBofMy3e5jZacT15ElyWSb/p7ZrfAeX2nal1WTRrgAOvu7EGFmXXT3StJf
         SGHL+TlVn8gnAGUP7cD9/ffnlVP2xTqkWCp9Ac95a2AJdhEl+UJ/sQoLyys3rb3Vp7k6
         LDb/IKACcZrTkOcxzoUUmiFwbfNVmqhFleX/uQITMWsXiPS/xJg6Ui/bNoZ1frGqA+oX
         u0cw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Recent gcc compiler (e.g. gcc version 4.9.1) gives a false positive
warning during the build of mkfs.nilfs2:

 mkfs.c: In function 'main':
 mkfs.c:540:47: warning: array subscript is above array bounds [-Warray-bounds]
    struct nilfs_segment_info *si = &di->seginfo[i];
                                               ^
 mkfs.c:540:47: warning: array subscript is above array bounds [-Warray-bounds]
 mkfs.c:540:47: warning: array subscript is above array bounds [-Warray-bounds]
 mkfs.c:540:47: warning: array subscript is above array bounds [-Warray-bounds]

This fixes the issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mkfs/mkfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index c7e18c6..f5f7dbb 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -532,12 +532,12 @@ static struct nilfs_segment_info *new_segment(struct nilfs_disk_info *di)
 
 static void fix_disk_layout(struct nilfs_disk_info *di)
 {
+	struct nilfs_segment_info *si;
 	int i, j;
 
 	di->nblocks_used = 0;
 	di->nblocks_to_write = di->first_segment_block;
-	for (i = 0; i < di->nseginfo; i++) {
-		struct nilfs_segment_info *si = &di->seginfo[i];
+	for (i = 0, si = di->seginfo; i < di->nseginfo; i++, si++) {
 		blocknr_t blocknr = si->start + si->nblk_sum;
 
 		si->nblocks += si->nblk_sum + 1 /* summary and super root */;
-- 
1.7.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
