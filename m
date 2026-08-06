Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF39B48A8D3
	for <linux-nilfs@vger.kernel.org>; Thu,  6 Aug 2026 18:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786040079; cv=none; b=UsfJkQ96hEQB5ykAVnHniIM0OUiQBqyz3E9HzM02fUck7mWBLahg6YlhW120hW3NwAbu9kMW3NUzqtQkKLXNWL4FHACBk3iTTEJB86AgmuHjPamJGzjcoaeO5ksRQ2MYvYiQWpqJEnBOg/xTEbHeXehBlwy/P1QPaDuck3kdKCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786040079; c=relaxed/simple;
	bh=CTBDXnVpz3NeNQmXCM72CfFSdfzstVzoozVZ7Cs4NhA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AbPYQPpN8caO6Um+lAMW/dEQv0ar1vHR0gWi80ntbBBxGlExZ9ILvIoPI+Wf44On2kNU7XtsvPctoirdNm49pZveGFeddJ5baSQijfR4b9pEfGiRZdIUohRII1nWdEqBpsqNcqe2rtay0wcEjJLWx8s7qfso9nWVAYftjec8WVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B6aw65cy; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6aw65cy"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38f620399a0so2278243a91.2
        for <linux-nilfs@vger.kernel.org>; Thu, 06 Aug 2026 11:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786040077; x=1786644877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aJqg201eKHgYEDuPwlB67S8npmOvy/EUxknw6PZVQzs=;
        b=B6aw65cy9B95nAHg22KlCfCnopmkZCK1M8pqm+lTJz0D8Mpqvv4kP63LzN+hhUrx8H
         vaq7JWqFJ7QtJESdj+xRr6LPKe+VJ0pu01FDgbBF5xPKljUUE2MAUBpuyBehuylZIQJ2
         dhiginjbrwQ1hptiaIdtB6vHih8SkLZ/KMAUajDuwimFHCiJNYHxosviWzYqfCVWcu7N
         6ce5TLT5hLhQVA1Fu0STZEufLPkjUXKhMGGyAidsj0LHUdQw/DJV3rEVNKCYNmM10LSa
         7wJoXSYNPohPvsHL27qs0itB6aHkQ1qGOn8H/+TaCNXj/wFrE+dKz2Mu6SYPqKxVKXv6
         1h1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786040077; x=1786644877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aJqg201eKHgYEDuPwlB67S8npmOvy/EUxknw6PZVQzs=;
        b=IRCI15IqlYcrFMAFHRbSsRrnL218StHabPoOKr7mHQACO/8UqovrNuVBVquMqig50Z
         6lgJLnzNa24kysmIJFa/09IX/AxO3hiVrRjGlpVf/yKWhlVs4VD8yQ/v17GV/LT3DB9h
         ovM2oHpIrFBtBZPFFVYd/cnxhotKVpeBm4+AXvIzqqkEnq5qVDcBe9P4e68MIACusyic
         PpYY1tQEeNfdf+iWiL+8VrMnzq2uNmk5aHDxm+rkc915TrbfzojgY//rE4GYXacMvxvJ
         EmfoQq6uzW++t0NacSq5p2PtgEKbwF7dQRtMxJhSqq9hspBeBaoEDhac2Lx3nXJ5DpdP
         pMyg==
X-Forwarded-Encrypted: i=1; AHgh+Rorav3bSzhmHDnoPrP7/lFeWfX/iPD6E3ep513B7hNnn+TPqjwj9AAYvAXYkHAl6Vk1oxw+Vbi7ol1W/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlHkCb1z7fsuMqomgFpp80QgZuKvXU27gH7WGWbNUYlTyQ1KYz
	PcRgpegnIb2iKVCkB8NvUHA/RmCXtzEwrv67sY4M4AlOL6KaHCImM5XB
X-Gm-Gg: AR+sD10xFpsCcboKbSUNR2uz7UpBj5IWq1TiiVRQKVd2dargWNu/zYk6ij9IbstVUYj
	macD04mgFNgtRoZIRqBd1jeCQrfUQ5F+yL1GqkUDlEygcOxNbzYHSGnMZ7+Mg+71jnEA4FyKWEx
	J//xfaqcsdVxu7tj+L/X5+ucIcXBYgPRpd2dJZTJCfaEOwI/l6z2xarR6YGsftoMceZ86UWL3fr
	jMKKi8lDZjJQXvgE7Av12tYyhvpRnAUmyXLFdQIFc6QsgWE8LGn/UlyQIPVIKjvsDdD/mI0bkXi
	qp37DPAMzac2y2zWpWP8cUH+p3NeSBgf+j0QydNKYoJqsZGE+ZvbYxcJa5GwojliCR1fAFFzcZE
	AjXRoMawk06UMjAB/0NmtwcEg8bQZYmfAeyO4kiIdaLaW2oWy2gI2OCBcLsxd3TVueNWYXauvUh
	C4nN8nZR0Ib0hRst+yTJXuadmmSv7+FQw1HNXCvasMSAGzgT7CbKu07K/1kCt+82Hx1XqShQ3bB
	2QtlmM81yW6hckLylyE9q/0+rex2j1fJQFhBQvNFxztxLOp7+GcuU0=
X-Received: by 2002:a17:90b:2785:b0:37d:ee77:78ac with SMTP id 98e67ed59e1d1-3903c5e70c3mr16701307a91.19.1786040077001;
        Thu, 06 Aug 2026 11:14:37 -0700 (PDT)
Received: from carrot.taila25129.ts.net (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085f5c9a5sm1937546a91.15.2026.08.06.11.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:14:36 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	syzbot+5957361606d7b750b874@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v2] nilfs2: suppress false positive WARN_ONs for sufile after an FS error
Date: Fri,  7 Aug 2026 03:13:39 +0900
Message-ID: <20260806181433.43460-1-konishi.ryusuke@gmail.com>
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
v2: Fix nilfs_sufile_warn_on_error() macro to correctly return _err
    instead of the boolean result of unlikely(_err), and add unlikely()
    to the return value check in nilfs_segctor_truncate_segments().
    (Thanks to Zhan Xusheng for pointing out the macro bug).

Hi Viacheslav,

Please apply this for the next cycle at your convenience.

This fixes an issue where a WARN_ON check is triggered by sufile
functions within the log writer after the filesystem degrades to read-only
mode.  This is a false-positive warning reported by syzbot this June
(and likely reported previously as well), which can occur as a normal
consequence after degradation.

This v2 patch fixes a macro bug pointed out, where the final expression
incorrectly normalized the return value.

Thanks,
Ryusuke Konishi

 fs/nilfs2/segment.c | 36 ++++++++++++++++++++----------------
 fs/nilfs2/sufile.h  | 28 ++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 2189267894d2..5896fdae5669 100644
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
+		if (unlikely(ret) && err != -EROFS)
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
index cd6f28ab3521..5888ed479c8b 100644
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
+		_err;							\
+	})
+
 /**
  * nilfs_sufile_scrap - make a segment garbage
  * @sufile: inode of segment usage file
-- 
2.43.0

