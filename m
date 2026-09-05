Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD82E32B133
	for <linux-nilfs@vger.kernel.org>; Sat,  5 Sep 2026 04:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788583761; cv=none; b=TBVjXTBuIp0j/JzRvd539aKUT1fjGdZ7GIp8SJiY3AO+tPwFyKnP0I035KkjoK8h86FKtf8bX987cHxddRPY/vLT4DhxFrlZ9bfMjMRcuFtz+nToOEyGLA8OYDIxU6vkoIPxsrwdK90M5s2jEi41eV4lf53yQO/BdddG+DJFfkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788583761; c=relaxed/simple;
	bh=Jj9kUn5qhvVJUdifRsunS/tN56R4uuxK9bdK99KID7M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=iOIbgoTWFyX018j0Ku3vb0idaP09DMFhVNZh8QdDiN5udJ4LlH1tMCSJofnR9Y6+zB440JUTz4+GUx3jjJtMFN8+EdTKTL6J/YUf4uktxoCNmvLjF+MF8Bz//ypzmcq921o/UMTN8qcdOto2vGEA/OURD5UF0vYkHoA6+fuR1ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CmAu3dHT; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CmAu3dHT"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-482dd6ee390so1833928f8f.3
        for <linux-nilfs@vger.kernel.org>; Fri, 04 Sep 2026 21:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788583758; x=1789188558; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Cazmnr8+WSnK+Laj1qZm2xa964waI/P+EGpnlZ4TgYM=;
        b=CmAu3dHTyB/ii+ZHQ1EE3t/v8s/xWfm3rWRxbBb5DaewKsWDJMQTFOiAGZGiLDSjmz
         4VUduiDpmR9vV0grRmYC7b/UHw8IzgHwfvOASxmKT5vcLJPe5dhIuomZ/PuS44I31bHi
         398enntDs0Oqs4q0Zw5LJs7mLUBWDTgggSoSQZTJFvI0Mf4ln2CqWbH7Sd8yUGa3qrkF
         j4CDoq5uxuRXnyvH8i5+gQcciUPAgZ2m1xo6rLknIP9aG/bK8wTl6TYo0HsK3J55iIWH
         KBvsF/zK13W3u6jWlPtrlJABA9OEBJbEbRmsF91zlMD1YHLwvetcXbTh/62k7vk/RTqC
         Iegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788583758; x=1789188558;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Cazmnr8+WSnK+Laj1qZm2xa964waI/P+EGpnlZ4TgYM=;
        b=fCM60MSIX5rygxFaQwdOI34/C/mWJlOaMsI9HlO4rZETPGSeESR0hrU9e1GNq2kFw6
         9R4/F2+tPfVAopioF3wY7GDHNqC2zzrefVrdFq0LqJK6/sefVJkOgK4uVZ55Axf4CuvD
         UwHgBfQFtFGPL4u1xgUih52NMN2wllHg32m0IAKP0qmmv4fG+iC/739Ohs9fXBDyirGV
         dL7QlG8PtB4Ebp2M/ejcPQ6HgHF0pTB7uRJzCxVXfvPpIjK3yk8AQppsER7kcKu/AYGb
         yymhD2PNBKfIpL+gohgyvtD1Tk+Nd8pBdksroWQ5EbX7LqMLPl8OUa89KMpwtTDw/P3o
         /MOA==
X-Gm-Message-State: AFuF++kwi8m7IL4roQ+N20ZbysCtzkmWDBaKXo2pBT54fJVPkT2IiCLy
	wWskjIzhdSEpZBHUZ4SbgDi6sUxnvgEMKrtij6AJ5zqtUiWQHbyN2Fnw
X-Gm-Gg: AYBFou1l/GukxjbMJ/UMOEOHO4475SvIcdcjpI1TS9H9b7l11eRqopUEPevKYCsm7RN
	9MQMiY8T3D6vM9dCBum6kQOijToMFJLxigQWd/JILB/WgbHZHbXoejKMhhlnijRicALzC4/3qj+
	ZMSr8oLR7E57LGz1LGW9Ti4NItJUWIuwY1WU8CuT9OupgYEBab0f53wNdyszfBJ1uBfazYw71OB
	JXrNgpb7K/u2lq+RuSvd9TE/tlrKSr6P1qsPhuIN22FAmtdUG/rwqD1KiRgyncsNjuQzyUF55J6
	XP2+smTlOwM5uaaLVedy9aeMtbHiCJywnL0WtIn2MM2od3v01IflYwCPcF7zyAxO3b/B3DKghzO
	hXoB9GzYK1BhwYXr7yxIOd7N2t4FVwbuWgWt0WhXaBD934GoruAN254wVymis54Gu06mC+sg4bo
	AevszmXCZNfz4s+b9KrZ2M0MQLWCEgkLJzJ0eSzz4SF8BYdiUx3p8sBuX5OBEwsOwxF9+zsIQSr
	6hbE7U8rHnZSBKUjRuMJAnAQK+leTm6UU0CDeJMOirGmcHIi/0x6/DMFTJHuiCoaPUu+JtJ2XO9
	jm8AojaJjqrBueexdR9bM2p5L7How2XcudqakoOFjfZlRn9oT4kinjkdhOw2TvN9jLzsOkkUTD+
	G4RFz7npQDZB04XCUYjSvz2y8AC6vEYN0L5gmdQQ=
X-Received: by 2002:a05:6000:41cb:b0:484:4880:449d with SMTP id ffacd0b85a97d-4858703f685mr12931827f8f.3.1788583757828;
        Fri, 04 Sep 2026 21:49:17 -0700 (PDT)
Received: from [10.200.7.52] ([212.89.239.241])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48594172546sm492537f8f.15.2026.09.04.21.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 21:49:17 -0700 (PDT)
From: Joshua Crofts <joshua.crofts1@gmail.com>
Date: Sat, 05 Sep 2026 06:48:59 +0200
Subject: [PATCH] nilfs2: remove '#if 0' code blocks
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260905-nilfs2-dead-code-cleanup-v1-1-348ed97b2443@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqDMBBG4avIrB2IUzS0VxEXafJHByRKgqUg3
 t3g8lu8d1JBVhT6NCdl/LToliq6tiG/uDSDNVSTGBnM2/ScdI1FOMAF9lsA+xUuHTt7xC/E2ld
 nhWq+Z0T9P+txuq4b++CfcmoAAAA=
X-Change-ID: 20260905-nilfs2-dead-code-cleanup-cefbe2773172
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Joshua Crofts <joshua.crofts1@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788583756; l=2031;
 i=joshua.crofts1@gmail.com; s=20260530; h=from:subject:message-id;
 bh=Jj9kUn5qhvVJUdifRsunS/tN56R4uuxK9bdK99KID7M=;
 b=ggr3TRRy5Y4ktJh/EqYQmoSEzlveccNOC+M28nZ72TOgjUfw4GcxHAHr76TEtHDEBwen51Ru9
 Mk27HEWTBVcDDu4c3x5GvZPmVTFoUXwPhahrG/j6X/PGStyebcLlnby
X-Developer-Key: i=joshua.crofts1@gmail.com; a=ed25519;
 pk=RTDOoVwgeL4oFdASj9U+cxJuIjXuXk73zkjnGOJKbEo=

There are two instances of '#if 0' code blocks that are dead code.
Remove these code blocks.

Additionally, remove unnecessary brackets around a single-statement
if per checkpatch rules.

Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
---
Stumbled upon these blocks when grepping the kernel for #if 0. Not sure
if they are actually used for debugging; if so, I have no issues with
the patch being dropped.

Thanks!
---
 fs/nilfs2/inode.c | 5 -----
 fs/nilfs2/super.c | 8 ++------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 34e6096069ad..c5b0e9f272b7 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -422,11 +422,6 @@ int nilfs_read_inode_common(struct inode *inode,
 
 	inode->i_blocks = le64_to_cpu(raw_inode->i_blocks);
 	ii->i_flags = le32_to_cpu(raw_inode->i_flags);
-#if 0
-	ii->i_file_acl = le32_to_cpu(raw_inode->i_file_acl);
-	ii->i_dir_acl = S_ISREG(inode->i_mode) ?
-		0 : le32_to_cpu(raw_inode->i_dir_acl);
-#endif
 	ii->i_dir_start_lookup = 0;
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 893a504cb80c..89fa6faa34d2 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -824,13 +824,9 @@ static int nilfs_setup_super(struct super_block *sb, int is_mount)
 	max_mnt_count = le16_to_cpu(sbp[0]->s_max_mnt_count);
 	mnt_count = le16_to_cpu(sbp[0]->s_mnt_count);
 
-	if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
+	if (nilfs->ns_mount_state & NILFS_ERROR_FS)
 		nilfs_warn(sb, "mounting fs with errors");
-#if 0
-	} else if (max_mnt_count >= 0 && mnt_count >= max_mnt_count) {
-		nilfs_warn(sb, "maximal mount count reached");
-#endif
-	}
+
 	if (!max_mnt_count)
 		sbp[0]->s_max_mnt_count = cpu_to_le16(NILFS_DFL_MAX_MNT_COUNT);
 

---
base-commit: 4d7d9486c04d917265f64c55bd23b2cc4fe7749c
change-id: 20260905-nilfs2-dead-code-cleanup-cefbe2773172

Best regards,
-- 
Kind regards,
Joshua Crofts

