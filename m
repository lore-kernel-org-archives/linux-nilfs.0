Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88263F482E
	for <linux-nilfs@vger.kernel.org>; Thu,  6 Aug 2026 09:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006997; cv=none; b=HW0/iPDUyx/J8dbSPGlSGLjhzat9W6fucL7D7eMB8InD2apbp3WUERqLjAM2vvg+xFIKPgle5v9uT6v5V+dxIwynrI8GGQ9E380kYQq+doxq/tbHBJEQYyA79HAa78iWkiw3ShrY1mEWSlTuKMEQQshkLbJNBis6f05o1Pqb4CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006997; c=relaxed/simple;
	bh=vlmYr8FZdam9m8IeQB9okPpPJXNoGZskZHh8i3FJGok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KSysql8SNgs4FrH2D0DU48cSbVmv3i0wdJklAUyI5wyp7E0PCsZVVKfBfWNEFJFDdqLSpTtlMCWrhh+Un/ACxYRruug3HM2GG4Lf+hZwVhKsL4ChWmcNNumwOuomj4fGJPx7M5+LkJGfvqA7zEAlSJoqJ/iTAKmzaZL973f99po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XSzZcaev; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XSzZcaev"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cedda2ce6fso16922105ad.1
        for <linux-nilfs@vger.kernel.org>; Thu, 06 Aug 2026 02:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786006995; x=1786611795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8OhdDnLO8z1OVTh7Cja/MEj5ZqrQfY51g7lPg1wFyPw=;
        b=XSzZcaevg5r+LEn1kLBox4BnAuNcZ8zYlmZpB20iQwh/2Hi/engXTEgfLII3OtJlYI
         q3p5EbgXV9vFVNN0vmKEoqniW565YRzpDKDqIi8MBb/cRgnr/CPT3mi3A26ooctuaqHk
         ESAERb8/ShhpxVKcFCm85KLQqBoMhkL3x/qcIl9dE285eAkI2v71FZq2tmx7fZvIqN7A
         R/Pgenvc4tJGn+p1DBw7zesAAb4FJZLqciStG4Z1BQ+b+fBqGQBKZEWW64qZmCtu7lyh
         YBKhB62o47NHiXRVxIt7r0ZBnsc4MOhlNDCM82XYwlDD/iAT2Voj9XtRn2RStDvwN+E+
         zgmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786006995; x=1786611795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8OhdDnLO8z1OVTh7Cja/MEj5ZqrQfY51g7lPg1wFyPw=;
        b=nojcmuclLU0ln84VieRzvLBluUW8+J1XSssXCHBsJxKkLzoMMNrSuBwrJLl0hWL7wn
         L2YQq3vrLVLpw+yVHmQoxanpWkJerJFv+T7IeY/7nPJ3WkyFzVbIsQsHI8jG3a8tB5hT
         j0Bnol53fKYcDtaP6z/P05Z+RBzoV/79Fd0pxKoL7q4pvt64vQ4LaHpZ98QT654OA9yj
         KgCT/9cpt67fgYEieKvEB8FtaH4ChX8rmRfY+U7PtfXud0KCMdYDwIGxxqIFZBsseOmO
         LE4erXTZy6ieIc8OXd1QjGTiuQB4235/lNQFZxyahNk4MX0L+RtadFnaizew08KITqiO
         i34w==
X-Gm-Message-State: AOJu0YzSZMbGXrVF7Y+8mP0Tiv3xrEu4yM6H2Git8Kj6Yyc8EIRB5mD2
	4KhoP8vB9A4srkud7v+HJP4i9xMiqMpUaWF8v0NIhoiCeusvxxZRJEzk
X-Gm-Gg: AR+sD116rpn6LugZBqfora39IN1jjkeE9MwdSNK3sL0fffNxi0+cxpKKJbSMRBusOUC
	U0TKjUkd1/qM4N7rNcmhuV55aZLGpbSEL1Yp6YBzEPmxu9u+LJgjFavv0FXRkIq/KAKKa+ZxUGt
	IGUG4HOYswpvZ/5Ztigc2KdQ6Bkx47KYV9jBBm4irhpoDWQIXJ7KfFtEM4WHKKY18amw20kBU2t
	SrKIbHyyhWOdO9C9Wn22ADDevr+HYb2V156PtieLwzkohF2wXN8ZdKaFp1Ej5GfLWs97qGDdJ2u
	SjoY/Km0k4pb10f32MUpUlr9bTBd8vS3sEApB16XyVYJamcB5UIsiDUURVAQhf6TbmMLABX5lT/
	NY53M9kbg3WnkYmDg6YCeA7l28Su53tTaP3UYHVRio8Srsp5BPwIta88TH7o97VycF+s3o6gKdM
	ID49n8nK2eymI1jmg9wc3SGxP8jUadhHdd8pLtcv3bMibNybB7D0zRKfO2o+oXiGjLwA8kKCTiI
	dhVYeSLHzMEohfsdtRSWT61qzLbODzP
X-Received: by 2002:a17:903:3201:b0:2d0:401c:2ebb with SMTP id d9443c01a7336-2d0ca7125cemr166761795ad.4.1786006995091;
        Thu, 06 Aug 2026 02:03:15 -0700 (PDT)
Received: from carrot.taila25129.ts.net (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4bbc5csm27965115ad.62.2026.08.06.02.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:03:14 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	syzbot+5957361606d7b750b874@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: suppress false positive WARN_ONs for sufile after an FS error
Date: Thu,  6 Aug 2026 18:02:00 +0900
Message-ID: <20260806090311.32633-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After applying the commit associated with the Fixes tag, metadata file
buffers can be evicted from memory even after being marked dirty.

Consequently, operations such as rolling back sufile changes upon
error - which modify the buffer and were previously assumed incapable
of failure - can now fail.

This behavior causes syzbot to trigger a WARN_ON check immediately
following sufile function calls within the log writer.

Resolve this issue by introducing a macro, nilfs_sufile_warn_on_error(),
which uses WARN_ONCE to report unexpected errors only when the filesystem
has not degraded to read-only mode, returning -EIO or -EROFS accordingly.
Replace existing WARN_ON checks for unexpected errors following sufile
operations with this new macro.

Additionally, for nilfs_segctor_truncate_segments() - where an error must
be propagated to halt log writing if a sufile operation fails - modify
the function to return the error code appropriately.

Reported-by: syzbot+5957361606d7b750b874@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5957361606d7b750b874
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Cc: <stable+noautosel@kernel.org> # Warning suppression primarily; will request backport individually if needed
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please apply this for the next cycle at your convenience.

This fixes an issue where a WARN_ON check is triggered by sufile functions
within the log writer after the filesystem degrades to read-only mode.
This is a false-positive warning reported by syzbot this June (and likely
reported previously as well), which can occur as a normal consequence
after degradation.

Thanks,
Ryusuke Konishi

 fs/nilfs2/segment.c | 36 ++++++++++++++++++++----------------
 fs/nilfs2/sufile.h  | 28 ++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 2189267894d2..4345b4a226e8 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1433,7 +1433,7 @@ static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
  failed:
 	list_for_each_entry(segbuf, &list, sb_list) {
 		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
-		WARN_ON(ret); /* never fails */
+		nilfs_sufile_warn_on_error(sufile, ret);
 	}
 	nilfs_destroy_logs(&list);
 	return err;
@@ -1449,7 +1449,7 @@ static void nilfs_free_incomplete_logs(struct list_head *logs,
 	segbuf = NILFS_FIRST_SEGBUF(logs);
 	if (nilfs->ns_nextnum != segbuf->sb_nextnum) {
 		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
-		WARN_ON(ret); /* never fails */
+		nilfs_sufile_warn_on_error(sufile, ret);
 	}
 	if (atomic_read(&segbuf->sb_err)) {
 		/* Case 1: The first segment failed */
@@ -1468,7 +1468,7 @@ static void nilfs_free_incomplete_logs(struct list_head *logs,
 	list_for_each_entry_continue(segbuf, logs, sb_list) {
 		if (prev->sb_nextnum != segbuf->sb_nextnum) {
 			ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
-			WARN_ON(ret); /* never fails */
+			nilfs_sufile_warn_on_error(sufile, ret);
 		}
 		if (atomic_read(&segbuf->sb_err) &&
 		    segbuf->sb_segnum != nilfs->ns_nextnum)
@@ -1491,7 +1491,7 @@ static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
 		ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
 						     live_blocks,
 						     sci->sc_seg_ctime);
-		WARN_ON(ret); /* always succeed because the segusage is dirty */
+		nilfs_sufile_warn_on_error(sufile, ret);
 	}
 }
 
@@ -1504,28 +1504,32 @@ static void nilfs_cancel_segusage(struct list_head *logs, struct inode *sufile)
 	ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
 					     segbuf->sb_pseg_start -
 					     segbuf->sb_fseg_start, 0);
-	WARN_ON(ret); /* always succeed because the segusage is dirty */
+	nilfs_sufile_warn_on_error(sufile, ret);
 
 	list_for_each_entry_continue(segbuf, logs, sb_list) {
 		ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
 						     0, 0);
-		WARN_ON(ret); /* always succeed */
+		nilfs_sufile_warn_on_error(sufile, ret);
 	}
 }
 
-static void nilfs_segctor_truncate_segments(struct nilfs_sc_info *sci,
-					    struct nilfs_segment_buffer *last,
-					    struct inode *sufile)
+static int nilfs_segctor_truncate_segments(struct nilfs_sc_info *sci,
+					struct nilfs_segment_buffer *last,
+					struct inode *sufile)
 {
 	struct nilfs_segment_buffer *segbuf = last;
-	int ret;
+	int ret, err = 0;
 
 	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
 		sci->sc_segbuf_nblocks -= segbuf->sb_rest_blocks;
-		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
-		WARN_ON(ret);
+
+		ret = nilfs_sufile_warn_on_error(
+			sufile, nilfs_sufile_free(sufile, segbuf->sb_nextnum));
+		if (ret && err != -EROFS)
+			err = ret;
 	}
 	nilfs_truncate_logs(&sci->sc_segbufs, last);
+	return err;
 }
 
 
@@ -1564,7 +1568,7 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 							sci->sc_freesegs,
 							sci->sc_nfreesegs,
 							NULL);
-			WARN_ON(err); /* do not happen */
+			nilfs_sufile_warn_on_error(nilfs->ns_sufile, err);
 			sci->sc_stage.flags &= ~NILFS_CF_SUFREED;
 		}
 
@@ -1576,8 +1580,8 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 		sci->sc_stage = prev_stage;
 	}
 	nilfs_segctor_zeropad_segsum(sci);
-	nilfs_segctor_truncate_segments(sci, sci->sc_curseg, nilfs->ns_sufile);
-	return 0;
+	err = nilfs_segctor_truncate_segments(sci, sci->sc_curseg,
+					nilfs->ns_sufile);
 
  failed:
 	return err;
@@ -1878,7 +1882,7 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 						sci->sc_freesegs,
 						sci->sc_nfreesegs,
 						NULL);
-		WARN_ON(ret); /* do not happen */
+		nilfs_sufile_warn_on_error(nilfs->ns_sufile, ret);
 	}
 
 	nilfs_destroy_logs(&logs);
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index cd6f28ab3521..a2e05d9584a0 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -10,6 +10,7 @@
 #ifndef _NILFS_SUFILE_H
 #define _NILFS_SUFILE_H
 
+#include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include "mdt.h"
@@ -54,6 +55,33 @@ int nilfs_sufile_read(struct super_block *sb, size_t susize,
 		      struct nilfs_inode *raw_inode, struct inode **inodep);
 int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
 
+/**
+ * nilfs_sufile_warn_on_error - warn on unexpected sufile error
+ * @sufile: inode of segment usage file
+ * @err: status code returned by a sufile function
+ *
+ * Even if buffer heads of blocks containing segment usage entries have
+ * been dirtied in advance by calling functions such as
+ * nilfs_sufile_mark_dirty() or nilfs_sufile_{alloc,free}(), those buffers
+ * can be discarded from memory after the file system detects corruption and
+ * degrades to read-only mode, which may cause sufile operations, including
+ * cancel operations, to return errors.  nilfs_sufile_warn_on_error() is used
+ * to detect unexpected errors other than during read-only degradation.
+ *
+ * Return: 0 if @err is 0, %-EROFS if in read-only degraded mode, and %-EIO
+ * otherwise.
+ */
+#define nilfs_sufile_warn_on_error(sufile, err)				\
+	({								\
+		int _err = (err);					\
+									\
+		if (unlikely(_err))					\
+			_err = WARN_ONCE(!sb_rdonly((sufile)->i_sb),	\
+				"unexpected sufile error %d\n", _err) ? \
+				-EIO : -EROFS;				\
+		unlikely(_err);						\
+	})
+
 /**
  * nilfs_sufile_scrap - make a segment garbage
  * @sufile: inode of segment usage file
-- 
2.43.0

