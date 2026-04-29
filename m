Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F10F33F5A7
	for <linux-nilfs@vger.kernel.org>; Wed, 29 Apr 2026 01:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777427245; cv=none; b=IQ8MKeCRsYvB1+n5VaVs71y+gPYWB/Q7DE+SyGQTpKemaC+nou9fTm5etrE5ZhbJiBvVe05iZ7rjNgpDc7ysF7P9Xh/eZn5KNRXJnp37QfaSfjLf0I615qNb0qQL4SMeMYr+kwappx5NJ/cf0nZJftID7ZaOxU18vLKAw9l3GXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777427245; c=relaxed/simple;
	bh=WqMv1YckYv/W8D1HJMKDMyO/iFhn+GXZHdYfC+bwTQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A/1s6BxYnhU1u8vIUuceBdl184kSjpDqlr5inPwNy+10dQ8bC9XURE/Gzk2xZ5mliTz9ArvGhA2yi9AfzvqeBs9t/WDMB3ON8wBdqhsK2njFl+Oey4PHYBdD0DghO9+TTLJVuFhabhTMQq5MtOSfamAfszDrarLpiIFxWc1brY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHmy7H+h; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHmy7H+h"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c79662bbd2eso8248441a12.3
        for <linux-nilfs@vger.kernel.org>; Tue, 28 Apr 2026 18:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777427241; x=1778032041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vQY4IGSDhnPDm3SZbmOaVwD/CLwLKCguemr0HTW+jZ8=;
        b=ZHmy7H+hQhl2GlGaGyksCcJZF4mFtKQriPFwIQZM7G4sg8hxYGULNwOoKjALh7t6rf
         IyIbwPzujwW3LmJveKhTbKDHkjScd4rG++y2cRM53oPPhe1uYHf6/OAcRo6ghI7lbWK0
         RnOCTD9QM5loFrjJyERCKl2u5l64j4je34eVyqIEox3959fKZh+MXGQtONrAnnSiEVEm
         3P4PJU0KWXZGQyq+iB3ufi4AGudcz6rLQUfXQt0n8x1HKLr1sU0Wc+xncD61Eswpbm0l
         zHlEiJS3GdJWnZNcVxKzroTF9OXLfpaYI8y5mIEoQhPQz1HrBQmdGH1PU5+N/Nv8mpn/
         HxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777427241; x=1778032041;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQY4IGSDhnPDm3SZbmOaVwD/CLwLKCguemr0HTW+jZ8=;
        b=bVkq+Vq9NKxt7QCXnDBVAYlc0eWDjg/Ya7f1Tys0cO4EzyKzB5fT6/4Wq5xqqBc/lJ
         gzc1ZIJjyUHPNMorEukdkwQbClnqT0sBA/zjuT9hrkQJ3y2z27ZUiuJVOdF2sTzcqbQU
         nDYFQHWT9Khl38gLDMbo7vofN1yvQ10GYD1hDs8vS/78r6cXYbg6NM11UCCqUGgfc7R9
         idvrRjpSasgUUOmo4M6IdLHPHmvYfwx4C6I5C4sJrKJohur/NMdtocupKxx+iOeRz5d2
         KueU/r4KhkYLSmeCnXF2Uss9SK35kn+9S1d7sG2+bzX0dmhtKFP0HMefU2IMlptHIzoK
         OCIw==
X-Gm-Message-State: AOJu0YxNjHuubjpVrodmJ/8t9TmhwLYNLQO33pSn8sH3jydXmNws0ouq
	ji2Ofpsdau12pnkQ7z0wZ13HUPZvkXNjJ/OJV5QV4ALZkQdpQwvSTM69
X-Gm-Gg: AeBDieu7dGTY5Y7Jq4YQINqDJP5xMdD4VYQ8aPirCMhuJY5+a0s88IT9mV7MUoXgLIE
	E0lCpHXTWUK/TRyHwIYbw/VkDVX6piJ91mAar5jI45k4y58JgxSJAoSdz2Mf2SmyzwZyu9ta72t
	/jWK4wfHn3vAOhxVeb89VzQEExrsF/9KSYDyIO0oq9w67o+34OsvxDRye4F1Zqvb8dyc7PeH9MA
	QYtu7J//HwA577eQGpGY7Wml1kej/62uMJJcfmNvIjMeC0hpuGvBzbAsalOHhi35Uj8mHA98yVK
	Nb/tMlSof/JsHXJsWlWoNuDldklORSAo5ATBpATAo/cu78gxLiWfX+1YWZpoWet3JUm1r6h/IX8
	E538eFyeegI7tEGElV8b1BQUbCe1jYNXptN7h4Lt75/cK6LbDIHdJplZRZ2Ow406Pz5Y10bgWfA
	PWxP+fQdTjwFPeP7LdUQsNNQLZsDIyo/Vju9sibwHu2Pwie1co6sX3VMmtbt97kTf/tddgLRRa3
	fhxlnw2oXRlXC3obQ==
X-Received: by 2002:a05:6a21:3290:b0:398:af16:f19f with SMTP id adf61e73a8af0-3a39c2742bemr6744689637.44.1777427241331;
        Tue, 28 Apr 2026 18:47:21 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:383f:4345:dc30:cb53:18e2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed6dd823sm331484b3a.38.2026.04.28.18.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 18:47:19 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2] nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range segment numbers
Date: Wed, 29 Apr 2026 07:17:11 +0530
Message-ID: <20260429014711.102110-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported a hung task in nilfs_transaction_begin() where multiple
tasks performing chmod() on a nilfs2 mount blocked for over 143 seconds
waiting to acquire ns_segctor_sem for read:

  INFO: task syz.0.17:5918 blocked for more than 143 seconds.
  Call Trace:
   schedule+0x164/0x360
   rwsem_down_read_slowpath+0x6d9/0x940
   down_read+0x99/0x2e0
   nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
   nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
   notify_change+0xc1a/0xf40
   chmod_common+0x273/0x4a0
   do_fchmodat+0x12d/0x230

The writer holding ns_segctor_sem was a concurrent NILFS_IOCTL_CLEAN_SEGMENTS
caller, stuck inside printk while emitting per-element warnings from
nilfs_sufile_updatev():

   __nilfs_msg+0x373/0x450 fs/nilfs2/super.c:78
   nilfs_sufile_updatev+0x21c/0x6d0 fs/nilfs2/sufile.c:186
   nilfs_sufile_freev fs/nilfs2/sufile.h:93 [inline]
   nilfs_free_segments fs/nilfs2/segment.c:1140 [inline]
   nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1261 [inline]
   nilfs_segctor_do_construct+0x1f55/0x76c0
   nilfs_clean_segments+0x3bd/0xa50
   nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
   nilfs_ioctl+0x261f/0x2780

The root cause is that nilfs_ioctl_clean_segments() does not validate
the user-supplied segment numbers in kbufs[4] before calling
nilfs_clean_segments(), which acquires ns_segctor_sem for write.  The
range check on each segnum is performed deep inside the call chain by
nilfs_sufile_updatev(), which emits a nilfs_warn() per invalid entry
while still under the segctor lock and the sufile mi_sem.  Under load
(repeated invocations across multiple mounts saturating the global
printk path), the cumulative printk latency keeps ns_segctor_sem held
long enough to trip the hung_task watchdog, blocking concurrent
operations such as chmod() that need ns_segctor_sem for read.

Fix by validating the contents of kbufs[4] in the ioctl entry path,
before any FS-wide lock is acquired.  Out-of-range segment numbers are
rejected with -EINVAL synchronously, with no work performed under
ns_segctor_sem.

Reported-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=62f0f99d2f2bb8e3bbd7
Fixes: 4f6b828837b4 ("nilfs2: fix lock order reversal in nilfs_clean_segments ioctl")
Cc: stable@vger.kernel.org
Tested-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20260428040256.84403-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v2:
  - Reuse existing 'n' loop variable instead of introducing a new
    one (Slava Dubeyko)
  - Add dedicated out_free_segnums label so the validation-failure
    path falls through the existing cleanup ladder rather than
    duplicating kfree(kbufs[4]) inline (Slava Dubeyko)
---
 fs/nilfs2/ioctl.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index e0a606643e87..41e47f558600 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -876,6 +876,20 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	}
 	nilfs = inode->i_sb->s_fs_info;
 
+	/*
+	 * Validate segment numbers against the filesystem's segment count
+	 * before entering nilfs_clean_segments(), which acquires
+	 * ns_segctor_sem for write.  Catching invalid segnums here avoids
+	 * holding that lock while emitting per-element diagnostics under
+	 * the segment constructor.
+	 */
+	for (n = 0; n < nsegs; n++) {
+		if (((__u64 *)kbufs[4])[n] >= nilfs->ns_nsegments) {
+			ret = -EINVAL;
+			goto out_free_segnums;
+		}
+	}
+
 	for (n = 0; n < 4; n++) {
 		ret = -EINVAL;
 		if (argv[n].v_size != argsz[n])
@@ -928,6 +942,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 out_free:
 	while (--n >= 0)
 		kvfree(kbufs[n]);
+out_free_segnums:
 	kfree(kbufs[4]);
 out:
 	mnt_drop_write_file(filp);
-- 
2.43.0

