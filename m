Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVxZy36E"
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3570DA4;
	Wed,  6 Dec 2023 20:57:43 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id 5614622812f47-3b9b5bff21dso386704b6e.2;
        Wed, 06 Dec 2023 20:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701925062; x=1702529862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+EKLqq52GK0jw4IGuqvKFvJcNTKuZLtYbF3vm1onl74=;
        b=eVxZy36EKu6joJtHiG/3TnX9lSS4VJNRKtmepZm+2oqHGSMjg2in3NF17ZJ1o4OEC3
         +JbnJcn20suENlR68itbfiQGKv/8fLV9AOBHUBM0BlaL3MeBQT4+yCsqKwqa1PydntLk
         GIdxm55Rtz5q6KT/SgiZzALNPS9KX6QWPn4W3fgeanSCYogqamZJ7b0UP6IvNyP4hcGa
         UPKduM9iTZtoXbeR8fH7b4xDnvLGBOqfr5E1lsepOazN/9bvYvbqauvcUA1j2Csi8qu+
         Xds/9fYGZW4csFodK3+X8lnC9h6/lgCwZrEWNBTEZGPaMSx7J4oh7WL1P5v3dofDNyMO
         kSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701925062; x=1702529862;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+EKLqq52GK0jw4IGuqvKFvJcNTKuZLtYbF3vm1onl74=;
        b=rD6phoUFMRvTm3Xyah5F93yhN3Zc6K1qJBuqni0EvrHXydkYZKofVzrFRRyUmKOIr9
         DRj4D6IgeOmkGBKD95LUjjQGqmnjmIj2LHP92hTNnrlkU3fS/GbATUeRQZh1Q/Kn1j+i
         iGGI9QC4YPi1+9iDEDyIFw5biEy3uyYjO0pm4nmr/Zz3sFpkAO6tufj2u6v4weqeKVD/
         eBHyRjJb8y/RLIGTOMUbJYDS40eaFOR5K7g9XNYBhNMRvy2K5AUg/hd5tGorQ+PZu6G1
         0WQnvJUd+4yE0Z2/xb4lc1S6OAX7w+p91AX7+Eb6mTAtn07/6ihh9Eclte59+0hnP7wH
         tmFw==
X-Gm-Message-State: AOJu0Yys/FDp9kSUXd9EMXuoh5eE1PZb6ti0zBsfDosmZteGw2MdcMOB
	7XYdBD0liC74NsgXtIfx7ucnyxDqS0Q=
X-Google-Smtp-Source: AGHT+IFFwcQCP2Uq8DUz9dgEMkn5l06vlu6eWg3jQI0UzHfv4+DoZy0zbGKdCpQjTOTlhjtHdb1KEw==
X-Received: by 2002:a05:6808:289:b0:3b9:e119:270d with SMTP id z9-20020a056808028900b003b9e119270dmr64614oic.4.1701925062397;
        Wed, 06 Dec 2023 20:57:42 -0800 (PST)
Received: from carrot.. (i223-218-132-246.s42.a014.ap.plala.or.jp. [223.218.132.246])
        by smtp.gmail.com with ESMTPSA id y20-20020a056a00191400b006ce458995f8sm373594pfi.173.2023.12.06.20.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 20:57:41 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: switch WARN_ONs to warning output in nilfs_sufile_do_free()
Date: Thu,  7 Dec 2023 13:57:30 +0900
Message-Id: <20231207045730.5205-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_sufile_do_free(), which is called when log write fails or during
GC, uses WARN_ONs to check for abnormal status of metadata.  In the
former case, these WARN_ONs will not be fired, but in the latter case
they don't "never-happen".  It is possible to trigger these by
intentionally modifying the userland GC library to release segments
that are not in the expected state.

So, replace them with warning output using the dedicated macro
nilfs_warn().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Andrew, please add this to the queue for the next merge window.  This
replaces two potentially triggered WARN_ONs with ones that use a warning
output macro.

Thanks,
Ryusuke Konishi

fs/nilfs2/sufile.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 58ca7c936393..0a8119456c21 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -471,10 +471,15 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 		kunmap_atomic(kaddr);
 		return;
 	}
-	WARN_ON(nilfs_segment_usage_error(su));
-	WARN_ON(!nilfs_segment_usage_dirty(su));
+	if (unlikely(nilfs_segment_usage_error(su)))
+		nilfs_warn(sufile->i_sb, "free segment %llu marked in error",
+			   (unsigned long long)segnum);
 
 	sudirty = nilfs_segment_usage_dirty(su);
+	if (unlikely(!sudirty))
+		nilfs_warn(sufile->i_sb, "free unallocated segment %llu",
+			   (unsigned long long)segnum);
+
 	nilfs_segment_usage_set_clean(su);
 	kunmap_atomic(kaddr);
 	mark_buffer_dirty(su_bh);
-- 
2.34.1

