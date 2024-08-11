Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73D2376F1;
	Sun, 11 Aug 2024 10:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723370610; cv=none; b=H9unxoXLnbeolFGFYOVV+NZ8YVEDPXG+OUV47l/Oq7J5CyePO9/9y0Lt6Cpox2Hyvckkxzo1a8Oj5R0hoyfkTUUffRxIDMnj+HRaw/J9PlwSzyissxQq/SAY8PIFp68tjjuyUPONEL+0ahtg+Q8rU9RiTNEi7SFZeSsuxgxfUts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723370610; c=relaxed/simple;
	bh=aGU/jBbzchZyBT+GV3ovfu6PArw3iySYty0LV+q7LLw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=W8pZrar3eoeW6Rx/KFa2xeE4FQb6AqY0aNxhyNe5HgcnsHOpOuNDA3NZS9YyfzSopIz97N4RtfAUQzT+Cju9GfwZbemStOWqeIHunQlHrU82YtCm6/UanRvrvjWzjRNFoc1Ll4vCKoLR2RiwVWkC8QEVdLzbXHBv3pExZ+oPEes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hIS+R1LI; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hIS+R1LI"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2cb64529a36so2370090a91.0;
        Sun, 11 Aug 2024 03:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723370608; x=1723975408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xIOl8OsZI63rJ5MOQ8aWvipATQqMN50CEJzU+2GZD54=;
        b=hIS+R1LIQ/OjSVNKVljwPTv7gS3ls787JD+aie0d6lhzD/1wPBGt3Ou4PoLMWrdGU3
         WKCdHhtNgSq+xz6uuQKnKriwMT/cmjrUhyDIEIlgMpCsHYw8B3VcORSLIFEMqdK0cn70
         Ik1AeUTn/qKD51yP/UhuhXpCsTK6WSGNS8ypI4sJgitmW01rE+lpDi1fp+ez2r6FjhFv
         p1uD7K5ANNDMQWe7Wrr2UntpSr7ctQhlUG7ACdy63Wgu1hIRVRqQ7K+ZeX7ZzpPSXaRN
         IyxxaGcDDfYLDfgpj+g2yf5tSTFNarczquAEHzhGeWl6wfrY4c458xiniPKnp/JsN39x
         qYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723370608; x=1723975408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xIOl8OsZI63rJ5MOQ8aWvipATQqMN50CEJzU+2GZD54=;
        b=l3e7mQZjMFBtAOCiQQIJEbr7ehRQ+C2M1gYqRW0e4H86Bhzf7S+EN24ZzLu6WgY3Jo
         KgdNcXhgmx1Q8E0tHinohKOCJ+qCsIuxcVOGyGZpVvkrMRD9J7AyYHnDyl7Q47BG6kCm
         G8i3dx/we4rNvkbnPjULg/C17rPjUoahdVvEyRYk1BPvE3U0oW/6aaDWQnBvf06FTiKg
         8b+wljUoN7ie68KJCh2GPrawzGwVjyTZfZwTijT/1fa6eljL1CzLdPCdhTjBX3hM5EJW
         YUmUaKtIqj0Ysb+fh3LP1X1TR7Q4xQ3Z/qCmMMfahscz+rEOGQzp/P1SAWegmCiY3Cye
         4U5A==
X-Forwarded-Encrypted: i=1; AJvYcCUCi38HoFgmdCyDvlKQN4dpVCctrBCUbf9wXi7Qpc4RHfflH1d5tu2bsbZ4LlwddCPwConywlTlcl2RAIKzHMU0L89Lf/B7yRhY+xbn
X-Gm-Message-State: AOJu0Yyx/BygpnlsK+PRt/DC4V9sl+NCMS8mcqP0uvRdr4Ec8aX+rsaz
	uZNbZPjhMg2oObhtW11kC1n6ZmuIQOLBVn4+QCSfV3iKlDHs56Femgr/ww==
X-Google-Smtp-Source: AGHT+IHoQnSQ1/gfO3dPhPZvCBm5J18YdTBeLC459Jv9d7IaH3Xi4DEHsjmouetHxRY00RX8mc9nUw==
X-Received: by 2002:a17:90a:90f:b0:2ca:4a6f:1dd with SMTP id 98e67ed59e1d1-2d1e806a397mr4486236a91.41.1723370607917;
        Sun, 11 Aug 2024 03:03:27 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1fcf06589sm2802637a91.25.2024.08.11.03.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Aug 2024 03:03:27 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: protect references to superblock parameters exposed in sysfs
Date: Sun, 11 Aug 2024 19:03:20 +0900
Message-Id: <20240811100320.9913-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The superblock buffers of nilfs2 can not only be overwritten at
runtime for modifications/repairs, but they are also regularly
swapped, replaced during resizing, and even abandoned when degrading
to one side due to backing device issues.  So, accessing them requires
mutual exclusion using the reader/writer semaphore "nilfs->ns_sem".

Some sysfs attribute show methods read this superblock buffer without
the necessary mutual exclusion, which can cause problems with pointer
dereferencing and memory access, so fix it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: da7141fb78db ("nilfs2: add /sys/fs/nilfs2/<device> group")
Cc: stable@vger.kernel.org
---
Andrew, please apply this as a bug fix.

This fixes possible memory access problem when retrieving superblock
information from the sysfs interface.

Thanks,
Ryusuke Konishi

 fs/nilfs2/sysfs.c | 43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index a5569b7f47a3..14868a3dd592 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -836,9 +836,15 @@ ssize_t nilfs_dev_revision_show(struct nilfs_dev_attr *attr,
 				struct the_nilfs *nilfs,
 				char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	u32 major = le32_to_cpu(sbp[0]->s_rev_level);
-	u16 minor = le16_to_cpu(sbp[0]->s_minor_rev_level);
+	struct nilfs_super_block *raw_sb;
+	u32 major;
+	u16 minor;
+
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	major = le32_to_cpu(raw_sb->s_rev_level);
+	minor = le16_to_cpu(raw_sb->s_minor_rev_level);
+	up_read(&nilfs->ns_sem);
 
 	return sysfs_emit(buf, "%d.%d\n", major, minor);
 }
@@ -856,8 +862,13 @@ ssize_t nilfs_dev_device_size_show(struct nilfs_dev_attr *attr,
 				    struct the_nilfs *nilfs,
 				    char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	u64 dev_size = le64_to_cpu(sbp[0]->s_dev_size);
+	struct nilfs_super_block *raw_sb;
+	u64 dev_size;
+
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	dev_size = le64_to_cpu(raw_sb->s_dev_size);
+	up_read(&nilfs->ns_sem);
 
 	return sysfs_emit(buf, "%llu\n", dev_size);
 }
@@ -879,9 +890,15 @@ ssize_t nilfs_dev_uuid_show(struct nilfs_dev_attr *attr,
 			    struct the_nilfs *nilfs,
 			    char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	struct nilfs_super_block *raw_sb;
+	ssize_t len;
 
-	return sysfs_emit(buf, "%pUb\n", sbp[0]->s_uuid);
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	len = sysfs_emit(buf, "%pUb\n", raw_sb->s_uuid);
+	up_read(&nilfs->ns_sem);
+
+	return len;
 }
 
 static
@@ -889,10 +906,16 @@ ssize_t nilfs_dev_volume_name_show(struct nilfs_dev_attr *attr,
 				    struct the_nilfs *nilfs,
 				    char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	struct nilfs_super_block *raw_sb;
+	ssize_t len;
+
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	len = scnprintf(buf, sizeof(raw_sb->s_volume_name), "%s\n",
+			raw_sb->s_volume_name);
+	up_read(&nilfs->ns_sem);
 
-	return scnprintf(buf, sizeof(sbp[0]->s_volume_name), "%s\n",
-			 sbp[0]->s_volume_name);
+	return len;
 }
 
 static const char dev_readme_str[] =
-- 
2.34.1

