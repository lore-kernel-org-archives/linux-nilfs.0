Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201AB1B791A;
	Wed, 21 Aug 2024 15:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255202; cv=none; b=uCLQaIyjRB+uYCRyLcZ4UZD53Hp6hIojCM7WH/27kTLlIivZUVYBYoKasGzU4wcTgO4Tai2cnjwzZwQ2ysep1QwieA4fv+GUzUHmGauIW7qnN/Afc3Manybue8rdMTu/nL/O7gKD2/CrP2oSJeThYUyfpm/ZBpXgThhe5y7Yl2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255202; c=relaxed/simple;
	bh=6EqLNP4se642Lg03ufB4FhGvNCI6hjMuafpaCD2hDfY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PD1dhIRkeNDZShxw/i5fmngll7XEWBpPHimtlfm9ODJXfb3RY7+AzZ/NMLF9NVNRYQQK9kxeWZc/gHhVUrcyTTxlNWQYM3zb/Tl1Fdl6YBy6ifiZY0QrVdZK40S0h0yw4/fHfzrr+f/SSfbq/BC5Um+0FaPahz9GjDCLEOuiGdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CFiWbPsE; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFiWbPsE"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2d3c05dc63eso5105449a91.0;
        Wed, 21 Aug 2024 08:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724255200; x=1724860000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B64wYynHBKuuyZA2Ig3tXfd9fRM26CzND3LkSG9yPr4=;
        b=CFiWbPsEMg8V43RiKIjYzjF7NM++vr/26VoFuqc4rTJF7kKm/wuWk9rsvrbAvzLERE
         Od9CKsD6jDuSsuFrd+k4DizV5xbVajbDUtvj3h7NEvyTRO0wUCfrIKFCB6XbF0nvDXcV
         wXTIQhy10dY4eAw58sMTnVyGSUtDCV0WYt6o8FiXhsG47rVbe9SDPzdWQGBQ36GXYOU6
         A3TPKdmSRDBmsDOVy4iA/O1/CJgFGndG2bO6aN71iGvviksnSFJNtz33vJuXrSQ4o4/y
         bbuGwiHsw7k2MCtyRnjHTErUonExQXrG4dqAhUBsqRGgfldmyKG/1AK/wjzEIUsqUh+l
         +Uow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724255200; x=1724860000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B64wYynHBKuuyZA2Ig3tXfd9fRM26CzND3LkSG9yPr4=;
        b=pzpixLWg5gmaTxVFT04err1JuiEQ2BwouqBt8C8V0hps0FI6SDw/9DkrCybLxkYhZY
         ffrxl68f7+CauJnB/yIyg7lPi0WlluvQjJzwWTn25lKQj8XHkFvhHKm8G8KL60jPjzHt
         m4t5kZloli+lbDURnxJcftrkL7hLlDShMSTMVTF7o7eC7vpJMOQGrh7lifMnGBdxTgg9
         7Jnjz/gnLgSV5eVX0XYTeBLhB3uTzxLzFVVw4CeQVxIN7pxaRMfd+HTjb6x7IqNR0dyZ
         gb2Sw3FRwrCN7azwzz378UrAQ+/lXmMvqhc20I/y2PJMr+0YwDkY7p0efsEf0fQ4EElS
         23OQ==
X-Forwarded-Encrypted: i=1; AJvYcCWO3jZ+hPX0D6pvWGQUcYiWNcgWRxXbQmsHV2AVz8Zc9kr7UmWwzgJN0zOIbzEv6labosGp7eHrwloNnn8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8UtHJn1QjIw7jDUNdl+E42spyj+EZ3qSsA2zKYTRsQnI7MBQn
	JQRIVKqelaKe0HIuqQnLdWF715eBn7ZNcn3o1N1HC5Zu3hrwepbjp7mJVA==
X-Google-Smtp-Source: AGHT+IFMC70+U0HL0blRZO9vu2HRnxtPdwOGVBF+NJjJIJFc4hK0J3pBW/5Hjk2D9/saaHRYCIbLMQ==
X-Received: by 2002:a17:90b:384c:b0:2cc:f2c1:88fb with SMTP id 98e67ed59e1d1-2d5e9a2ee47mr3086091a91.16.1724255200263;
        Wed, 21 Aug 2024 08:46:40 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eba2e538sm2021098a91.17.2024.08.21.08.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 08:46:39 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] nilfs2: do not propagate ENOENT error from sufile during GC
Date: Thu, 22 Aug 2024 00:46:26 +0900
Message-Id: <20240821154627.11848-5-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821154627.11848-1-konishi.ryusuke@gmail.com>
References: <20240821154627.11848-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_sufile_freev(), which is used to free segments in GC, aborts with
-ENOENT if the target segment usage is on a hole block.

This error only occurs if one of the segment numbers to be freed passed
by the GC ioctl is invalid, so return -EINVAL instead.

To avoid impairing readability, introduce a wrapper function that
encapsulates error handling including the error code conversion (and
error message output).

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/segment.c | 64 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 871ec35ea8e8..765d55333a13 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1102,12 +1102,64 @@ static int nilfs_segctor_scan_file_dsync(struct nilfs_sc_info *sci,
 	return err;
 }
 
+/**
+ * nilfs_free_segments - free the segments given by an array of segment numbers
+ * @nilfs:   nilfs object
+ * @segnumv: array of segment numbers to be freed
+ * @nsegs:   number of segments to be freed in @segnumv
+ *
+ * nilfs_free_segments() wraps nilfs_sufile_freev() and
+ * nilfs_sufile_cancel_freev(), and edits the segment usage metadata file
+ * (sufile) to free all segments given by @segnumv and @nsegs at once.  If
+ * it fails midway, it cancels the changes so that none of the segments are
+ * freed.  If @nsegs is 0, this function does nothing.
+ *
+ * The freeing of segments is not finalized until the writing of a log with
+ * a super root block containing this sufile change is complete, and it can
+ * be canceled with nilfs_sufile_cancel_freev() until then.
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid segment number.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
+ */
+static int nilfs_free_segments(struct the_nilfs *nilfs, __u64 *segnumv,
+			       size_t nsegs)
+{
+	size_t ndone;
+	int ret;
+
+	if (!nsegs)
+		return 0;
+
+	ret = nilfs_sufile_freev(nilfs->ns_sufile, segnumv, nsegs, &ndone);
+	if (unlikely(ret)) {
+		nilfs_sufile_cancel_freev(nilfs->ns_sufile, segnumv, ndone,
+					  NULL);
+		/*
+		 * If a segment usage of the segments to be freed is in a
+		 * hole block, nilfs_sufile_freev() will return -ENOENT.
+		 * In this case, -EINVAL should be returned to the caller
+		 * since there is something wrong with the given segment
+		 * number array.  This error can only occur during GC, so
+		 * there is no need to worry about it propagating to other
+		 * callers (such as fsync).
+		 */
+		if (ret == -ENOENT) {
+			nilfs_err(nilfs->ns_sb,
+				  "The segment usage entry %llu to be freed is invalid (in a hole)",
+				  (unsigned long long)segnumv[ndone]);
+			ret = -EINVAL;
+		}
+	}
+	return ret;
+}
+
 static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 {
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	struct list_head *head;
 	struct nilfs_inode_info *ii;
-	size_t ndone;
 	int err = 0;
 
 	switch (nilfs_sc_cstage_get(sci)) {
@@ -1201,14 +1253,10 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 		nilfs_sc_cstage_inc(sci);
 		fallthrough;
 	case NILFS_ST_SUFILE:
-		err = nilfs_sufile_freev(nilfs->ns_sufile, sci->sc_freesegs,
-					 sci->sc_nfreesegs, &ndone);
-		if (unlikely(err)) {
-			nilfs_sufile_cancel_freev(nilfs->ns_sufile,
-						  sci->sc_freesegs, ndone,
-						  NULL);
+		err = nilfs_free_segments(nilfs, sci->sc_freesegs,
+					  sci->sc_nfreesegs);
+		if (unlikely(err))
 			break;
-		}
 		sci->sc_stage.flags |= NILFS_CF_SUFREED;
 
 		err = nilfs_segctor_scan_file(sci, nilfs->ns_sufile,
-- 
2.34.1

