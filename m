From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 02/11] nilfs2: remove space before comma
Date: Fri, 29 Apr 2016 22:15:38 +0900
Message-ID: <1461935747-10380-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=rv90uV1FAwWVCkEaSMz7nGMY3tkEH/kzeu/DBXjrgAI=;
        b=XWEAj9xv3A0igeQ6mP2ud4/uruvMnhBI+idU3M84TW4BTBiL56ywargvhUAV7jo7lT
         y5ab/P5dDFouYAjfbjF5P/omiAPusXeM9AYBZibxuPfmA26P4LJDr0D3Lk5s/7inJwUy
         u7wGt+Vs/vrBjLSH3fzp/+8g2hUNgZBfTFiaORYnGJeUPrhRirKvyVHtl5d302GNCD/2
         f8T154u3spbAjTzN4LZQ93TZvrNw/QZSg7elabhuUSF9rKJiFhFiDe6GxM95LEpy8Uwu
         5AzRLENEVnSccZK6Yuhpt3ybk17WrT58DsCILdJzs7EGKLtXJrzsxH/Ot+eIAcvB4EYD
         ypIA==
In-Reply-To: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Fix checkpatch.pl error "ERROR: space prohibited before that ','
(ctx:WxW)" at nilfs_sufile_set_suinfo().

This also fixes checkpatch.pl warning "WARNING: Prefer 'unsigned int'
to bare use of 'unsigned'" at nilfs_sufile_set_suinfo() and
nilfs_sufile_get_suinfo().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/sufile.c | 4 ++--
 fs/nilfs2/sufile.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 52821ff..5b37204 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -819,7 +819,7 @@ out:
  * %-ENOMEM - Insufficient amount of memory available.
  */
 ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
-				unsigned sisz, size_t nsi)
+				unsigned int sisz, size_t nsi)
 {
 	struct buffer_head *su_bh;
 	struct nilfs_segment_usage *su;
@@ -897,7 +897,7 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
  * %-EINVAL - Invalid values in input (segment number, flags or nblocks)
  */
 ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
-				unsigned supsz, size_t nsup)
+				unsigned int supsz, size_t nsup)
 {
 	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
 	struct buffer_head *header_bh, *bh;
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index b8afd72..35e34c8 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -42,9 +42,9 @@ int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum);
 int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
 				   unsigned long nblocks, time_t modtime);
 int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
-ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
+ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned int,
 				size_t);
-ssize_t nilfs_sufile_set_suinfo(struct inode *, void *, unsigned , size_t);
+ssize_t nilfs_sufile_set_suinfo(struct inode *, void *, unsigned int, size_t);
 
 int nilfs_sufile_updatev(struct inode *, __u64 *, size_t, int, size_t *,
 			 void (*dofunc)(struct inode *, __u64,
-- 
1.8.3.1

