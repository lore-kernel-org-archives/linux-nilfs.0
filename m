Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EF0322C73
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Apr 2026 04:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777348987; cv=none; b=Mxpx2SZnPo2gcc0oif7OCpAbDCE4zSBWsvT9bFKWLVudbkEoOZyaWS5Ou5oVSAEjxPtgvUG2JpB1VNsUfwZmICWt8L+aO+X2dURLysnu04X5HsN9iopgKL9jG7F6Ie28BaDWaZOtNkf+6SYLXTyfTzvVygjH6BvEw7hRwaof+aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777348987; c=relaxed/simple;
	bh=v09oGjZBxxoD1I5Dd0lzZ/Y5lisNLiiyclz+cFfNTDE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fjow2rHVvNzm0d/Cbkf8fug/Icn+5fN8rhRot5ShOPm1isgNLlU6HBKz33DQR2zREZ7U8uF7QhjI05qElbwLXatzDAC3xdScEWYL368l4X67fjuxwNsCa7IqIQ/IRXtJreCzlXnWPR6O6bYmhTO2sAa3vPu3y4OfI0C1lI5oDUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FDpIU0IC; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FDpIU0IC"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c76bde70ec9so4370718a12.2
        for <linux-nilfs@vger.kernel.org>; Mon, 27 Apr 2026 21:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777348983; x=1777953783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rMo4jaeAOuEhn+qc2FlN+TMLJBS8wFQYR9JHj3QpiF4=;
        b=FDpIU0ICKHUIihLGT4+22gLcTotte2hA+yY/0SdpHzBpSx8S9e0VZ78K8thutz5Aw7
         zSx3aGbppt33ZB9BNY0F0gZkbyGCmCxp+LRp2/FtGVCG9HfmXTiwCODu86gxbcbfkAqn
         zHnwdRsuQjiMl9Vp295F2sFTRw9unXj3f0HXJIxMpQ49Nz5j1ziNEC+nuJKJGtJIr0qV
         JREabeGveW2bPdqwaL+7x7KH0QNTMx0owXUvD9rpyXzAGtMEgW2id5ZALVX56f/C7STB
         +AEjw1E8iLUhR1ULFcLcrtrY7SYjFLuYOyZDxOMwUxV2DVHsFtlkDd8040/RuW+kq8gl
         5Vjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777348983; x=1777953783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMo4jaeAOuEhn+qc2FlN+TMLJBS8wFQYR9JHj3QpiF4=;
        b=cDhpWtwQwUqQIjWtfr8y+CJTXXIsbPM8CWPW68MHFoUtlzsUgUHPAnyWPGoux9tPxS
         QCjwHbQt4Pjb5cfLFZsl323VVs180HiLOXlACAxEpK1XUDU9WX5EZuhPAFKnPqGCk2Je
         wrwthR7EGDfA2KZB1HxgJg6SGkyO7oU3fAuihpD48AmAEVG3t89wMblJowq/cMaT90PT
         Z1ihMfVkQBj/dNz/NZh1g3EWj5fd9osM3NHuh8usbpre8V9nkBNd9+Wvw3SBbk5qeUAD
         w6sOgTCWGQupqBf+mJJjh4hA+lI12g90fQU19r6hH5e0U8vO3Khg3kYmfvsqlv5aaKGb
         Ewzw==
X-Gm-Message-State: AOJu0YyZ0a+BY9ly9Oqri08s21b9VkaUlTFZ9/uCjkn2ezZNzEFG8Ta7
	q4PAkLey+NIqWMFkDYd1GIfZROzpYwrj2RnMBkc3tSq3fEeG055dJVS4
X-Gm-Gg: AeBDieunffcGf5RLFiWJSoWbCAIit/B65BOq5WfR1Cmx1ADrgRLoHbTmJA5iGtxlkSa
	5DCgOvCDrA+fYEoiN+Xjh3yki5H6K6Bb7mql2+b2hi+qlh79Nb6t+SkfOeGaQAQ72tjpvVoJb0w
	RjZMFbgq/6udGlTSv/gFsOTdWzxDc7HJ15GNrUVfvk3HglhSZ8w6lPLRMTXB8L6Tul/bKtj0Ck8
	Cf0JTXQGHBkAbYMwKw8On4Qt/a6+VQCB3uNoZbZ0OPVgcbwicQImlsD/3OIeVFn6DRNKODDO17/
	U2ejTfolLTEAY26DwWkqJBxbQXWdr+MiRgiaEE1e7tInqtDMOMIShV0epqPJ84z/L3J7dP8nQCF
	iOVQ7uxTnZ4zSMSTX22H8CDGsUx9+Jyf4y/euFy58fXmElddbDA/HV/c3z2PqytR8Sz7lljBAx8
	O6+khYP9bCiowW35bBcWPpz3lKTu+fyod7l+pOZB0ipQJnX2LrlyDQXEIK8vnfQNNZ0AQXIyk/A
	mHdc8B98q2iXiDHeQ==
X-Received: by 2002:a05:6a20:918d:b0:3a2:fbf9:d823 with SMTP id adf61e73a8af0-3a39bffeb9amr1812739637.8.1777348983332;
        Mon, 27 Apr 2026 21:03:03 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:383f:3532:7d40:72e8:bc68])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7fc6015691sm693675a12.18.2026.04.27.21.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 21:03:02 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Subject: [PATCH] nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range segment numbers
Date: Tue, 28 Apr 2026 09:32:55 +0530
Message-ID: <20260428040256.84403-1-kartikey406@gmail.com>
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
Tested-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/nilfs2/ioctl.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index e0a606643e87..38822dce1839 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -846,6 +846,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	struct the_nilfs *nilfs;
 	size_t len, nsegs;
 	int n, ret;
+	size_t i;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -876,6 +877,21 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	}
 	nilfs = inode->i_sb->s_fs_info;
 
+	/*
+	 * Validate segment numbers against the filesystem's segment count
+	 * before entering nilfs_clean_segments(), which acquires
+	 * ns_segctor_sem for write.  Catching invalid segnums here avoids
+	 * holding that lock while emitting per-element diagnostics under
+	 * the segment constructor.
+	 */
+	for (i = 0; i < nsegs; i++) {
+		if (((__u64 *)kbufs[4])[i] >= nilfs->ns_nsegments) {
+			ret = -EINVAL;
+			kfree(kbufs[4]);
+			goto out;
+		}
+	}
+
 	for (n = 0; n < 4; n++) {
 		ret = -EINVAL;
 		if (argv[n].v_size != argsz[n])
-- 
2.43.0

