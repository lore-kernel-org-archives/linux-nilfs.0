Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9B51E1024
	for <linux-nilfs@vger.kernel.org>; Sun,  3 May 2026 04:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777782843; cv=none; b=cOgC80lWxQA0UuVoD4z0bFhp/xkbyciG30wfKaJdSah1ykIlD4Ueskale0YCfGot1CLAk/U7O1C0r1svepCjDk9DZcmdJLByKyIke6WOswygMX9CqieuWGea0xhoHSB3HQjq7EjGQGONHlHlkFidtiuvjK+q//1d6afrP3oNwUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777782843; c=relaxed/simple;
	bh=HD4URzboXJBxZhTzuR2oVkh1t6RjfnaEoCLziSMUxAc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bmrofZuGbFjBKM7xiV79zaHuo6BwAghI537xIukLcHQ7UsKk8WMOMOK7QzIWHzkBuwR/mBS8A7yiIL24HuiBkBkZbF/NX9PbKi+qMYAilO3DbLnLpFnIK7nwMZEH3WvYamAduqJziFA02KziipetJ2AgcZ2TyJd6DdHOXZrfxRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e1jQDk3X; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e1jQDk3X"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8353fd1cb5fso140500b3a.0
        for <linux-nilfs@vger.kernel.org>; Sat, 02 May 2026 21:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777782840; x=1778387640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B+X/RCr42WF+UVLdUG/9wxwgAYEEO/NYfLNN1QtM6p8=;
        b=e1jQDk3X+XmK6LoTej3SvsR2EsymnrEun9VjWBU49k7XGQ5wBF2qv9qklFulvdySf5
         cbDQcOWu4ZVrxSws4Hu7+aGBo/5rOqhUdfS9HIwhGOSqjlQuOZSMTwMrpF5IoIY7MK25
         6qE5x5fVIz9PDazJsBpO3moFGnVOGz6EBpQOfL+O3a2ze0YnAI5v8LhEKFtPfx/6qRu2
         hXv1rc0kZ8lOpca9uUTK1uL4rfbJMeORS1qGwiFbZpCUBLu2B+0Q8/jbHtfSaWUHbFla
         AYkYt1YfZS3wwMkF7twl8/RQpi+5rGG1UwVKlOFyq21TZIqEIp08bRUTCUdsmRHaINQ1
         k/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777782840; x=1778387640;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+X/RCr42WF+UVLdUG/9wxwgAYEEO/NYfLNN1QtM6p8=;
        b=PTjhhxEBmLrvjm89IP0riPoq9DthFrzQRncN6cy4y+ka1jCVJP0Y60AicD2EXjnn/T
         HJLQSidghc88daAWCyhgR4uCIjwrfPfE8YjJ9Q7JlRA/3MC/yhG4WxPCT3b3KRFfkfjH
         jCQsKUhuCR1Av6nrUz+WY+8JG6hlFu8m4mbUis9H+2qSnW9I/AHCYdHM3JrmUnXVG5xE
         QlsSvUfSCB+7dwN8AVU6fxMJWfrCOMbpOortpz5mVqZh9XE1/L6cRpmnKKBbIyTbHxI3
         R5EDp5Q24Be0X/whbFKNDOtiGTRvw9CBtCeuusiJQqvdgpwjoN0tx0vnhuYxQYBfTEm+
         Uw0A==
X-Gm-Message-State: AOJu0YygfxK8WAvplNTU+/9/+Mrzt+lSkL3UFSm+As8Mz9Z9oxXIHq+q
	cnec3ldAWPXTtzDWjTBY3PKtOLtl9gZiGvpTonLKrqKlti73iNh3FVZl
X-Gm-Gg: AeBDieuZT5fGoGBQO0Ch13Yl3hgACecO3VPaxC/yuAB39eLsgf7pxWGDY9ahtsAlq+i
	We6cBZvIyizyO2WAj1OVtpZRFDS443yXEA+DDkoDEhmLRGdPlNJfOEQFHouWMxwaw76UDVXyHct
	0d59bK9eOSYF8a+H4suLupy7PbRasjXvH8aQNK+NYEF7W2Vc3JWcwBPcnV0O90J+3HOUtgUWIzk
	Acr7LvigixHw36rXU/jEyY2kKKFj21ZKwxuk17k5+Ets4wbKNScxg0KNczkbrNny5YQo2SHSs0T
	+/HHlGZbLS43V67m66RundT46APX5NtAt55UysZgdsgukrejk9Z5OSs/J2F308mzVh5n97O6P/1
	QIFo2hcIyYmQ4ysKsWtXJ3b0v2UqWSzccwN2ACPrkdnGXdTRbSERVgRjTwYzumWANEygEs7GjKW
	WuBWP4MScm9oZ9vbpK+pW64nYJ0e2YgedIOxk9uNogQk83Lo82nVX6OTrsDamMwnv3Q7JlPOQyg
	F658Q==
X-Received: by 2002:a05:6a00:4487:b0:827:2792:e401 with SMTP id d2e1a72fcca58-834fff61eecmr9682961b3a.15.1777782840362;
        Sat, 02 May 2026 21:34:00 -0700 (PDT)
Received: from carrot.taila25129.ts.net (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515b00b28sm6975373b3a.42.2026.05.02.21.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2026 21:33:59 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Deepanshu Kartikey <kartikey406@gmail.com>
Subject: [PATCH] nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range segment numbers
Date: Sun,  3 May 2026 13:33:29 +0900
Message-ID: <20260503043357.7031-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Deepanshu Kartikey <kartikey406@gmail.com>

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

The writer holding ns_segctor_sem was a concurrent
NILFS_IOCTL_CLEAN_SEGMENTS caller, stuck inside printk while emitting
per-element warnings from nilfs_sufile_updatev():

   __nilfs_msg+0x373/0x450 fs/nilfs2/super.c:78
   nilfs_sufile_updatev+0x21c/0x6d0 fs/nilfs2/sufile.c:186
   nilfs_sufile_freev fs/nilfs2/sufile.h:93 [inline]
   nilfs_free_segments fs/nilfs2/segment.c:1140 [inline]
   nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1261 [inline]
   nilfs_segctor_do_construct+0x1f55/0x76c0
   nilfs_clean_segments+0x3bd/0xa50
   nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
   nilfs_ioctl+0x261f/0x2780

The root cause is that user-supplied segment numbers are not validated
before nilfs_clean_segments() begins doing work; the range check on
each segnum is performed deep inside the call chain by
nilfs_sufile_updatev(), which emits a nilfs_warn() per invalid entry
while still holding the segctor lock and the sufile mi_sem.  Under load
(repeated invocations across multiple mounts saturating the global
printk path), the cumulative printk latency keeps ns_segctor_sem held
long enough to trip the hung_task watchdog, blocking concurrent
operations such as chmod() that need ns_segctor_sem for read.

Fix by validating the contents of kbufs[4] in nilfs_clean_segments()
immediately after acquiring ns_segctor_sem via nilfs_transaction_lock().
Holding ns_segctor_sem serializes the check against
nilfs_ioctl_resize(), which can modify ns_nsegments, so the validation
uses a consistent value.  Out-of-range segment numbers are rejected
with -EINVAL before any segment-cleaning work begins, so the bad
entries never reach the per-element diagnostic path inside
nilfs_sufile_updatev().

Reported-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=62f0f99d2f2bb8e3bbd7
Tested-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Fixes: 071cb4b81987 ("nilfs2: eliminate removal list of segments")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please queue this patch.

This is a fix by Deepanshu that addresses the problem recently
detected by syzbot, a hang-up that can occur when GC ioctl parameters
are invalid (this time, when a segment number to be freed is
out-of-range).

Thanks,
Ryusuke Konishi

 fs/nilfs2/segment.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 1491a4d4b1e1..9332f5ac6083 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2512,12 +2512,33 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info ti;
 	int err;
+	size_t i, nfreesegs = argv[4].v_nmembs;
+	__u64 *segnumv = kbufs[4];
 
 	if (unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 1);
 
+	/*
+	 * Validate segment numbers under ns_segctor_sem (held for write
+	 * by nilfs_transaction_lock above) so the check is serialized
+	 * against nilfs_ioctl_resize(), which can modify ns_nsegments.
+	 * Rejecting bad input here, before any segment-cleaning work
+	 * begins, avoids the per-element diagnostic path inside
+	 * nilfs_sufile_updatev() that would otherwise run under this
+	 * same lock and stall concurrent readers.
+	 */
+	for (i = 0; i < nfreesegs; i++) {
+		if (segnumv[i] >= nilfs->ns_nsegments) {
+			nilfs_err(sb,
+				 "Segment number %llu to be freed is out of range",
+				 (unsigned long long)segnumv[i]);
+			err = -EINVAL;
+			goto bail_unlock;
+		}
+	}
+
 	err = nilfs_mdt_save_to_shadow_map(nilfs->ns_dat);
 	if (unlikely(err))
 		goto out_unlock;
@@ -2558,6 +2579,7 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 	sci->sc_freesegs = NULL;
 	sci->sc_nfreesegs = 0;
 	nilfs_mdt_clear_shadow_map(nilfs->ns_dat);
+ bail_unlock:
 	nilfs_transaction_unlock(sb);
 	return err;
 }
-- 
2.43.0

