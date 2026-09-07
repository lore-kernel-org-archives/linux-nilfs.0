Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1745C34EF0D
	for <linux-nilfs@vger.kernel.org>; Mon,  7 Sep 2026 05:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788759271; cv=none; b=M0mkC8vVE6TUWMFKljirXvf1Ad+hOIRjSZJsMOJo8MpcAjjBgkcAVpcmDBGTkDjfyTNx550cADYhr4NLYO/bdvuqdrYaJqiYVQk4yGhDB2S2KgaF3J348YLsicawmXR9YhUBPv7/Ncpr/l62TnAbq8DQ3JOqgju1Ijzs4MKOInE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788759271; c=relaxed/simple;
	bh=mwRUJF3wGx2Qhe1fuExeMLHPcmjOCo1c/6Pg7yRmVMM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=PBrI3unTW9vk7oeRS7VfLsYdeaqVp0zuRCqVvo9C6X4NHbV/plbBokj0jQjmbkV32CSbp0GXMmHcHpzkIWiaEt1A38qeE+8lJtv+EKKvj4wEaWpqQFIQZWcKnsZlfy1a0nnRApTklcCG1h3Bbx9KqJPDwBKeeMZM/7m9Y8RWhF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dEIQyQ6R; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dEIQyQ6R"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49b0dd3c9a0so29213955e9.1
        for <linux-nilfs@vger.kernel.org>; Sun, 06 Sep 2026 22:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788759268; x=1789364068; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cCFD/yXemFHbj/JySUZn34on1n5S4vAUBReMZLU41VE=;
        b=dEIQyQ6RABC0hHoLH6QeNsA5I+rO3Z42AxPdw2fUhALj4iCNOXOBNJOflZOTJr02zW
         I/3XPAOOBVrk25CLifnaJtUL46ioss3TNE1Wuu0EAxLfyTOtS4rcLYuQK4Q4OFMFXfB3
         d5gk144k7N1hyfoFus71fNQfN/ABxvSTtq8MyT0MqpMcgyyzxNKB3Fp9zb2B2b/9lGre
         z1nX3M4pIS3i8Yl3S+qZVf5wBDVE8gj0gn+HD0TlXj8rara9v+oTrSFxAKfrsOufGkt8
         UTzzQoyxY5eqtU0WY/TDlVpDMKQUTbx1YvhAsvOTNrJmsESVLrtcoG1UezL2hLYDZfFk
         cCzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788759268; x=1789364068;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=cCFD/yXemFHbj/JySUZn34on1n5S4vAUBReMZLU41VE=;
        b=mDTjlQZv5RWiynHtlZihdpI1PJsJoc6D6gyQbzrNU9e3E8UwCYlJDLeF8v61S5uJF7
         4y4wXICPddfTfL61H4qeDckmDgFJaRalC6kMjRL42q+MRiwdan14eq5yXzWKd3ZWxA2d
         bDanljZlcgSmBZqT2GD1THX1BsJk5bb9daWhg9g42Mfq6WP39nwEHNgDDZ4FhDXyQxtL
         Y8JeJyhGkYJQ3nirMyQGsJuqssbykHZ9nBkxn1AHtcARI+8HCu0YoFBvFJMfF6sq+ID7
         MyoSQqWbA8fjUG0kuSLN/5OqzQxwNm0ynDsG7QPE/YWJv/XqBXJRElGbhSZCHLnxhZOQ
         uQsQ==
X-Gm-Message-State: AFuF++kRbMZ4T8/RncYW2feRjn/pEZieYdOnHtnlQ+1dHchKGGsJmNsg
	4/SXHPY8jIYw/R0BW5shM+fPQeu2uW62sIkP4Cn5CV8SLPCHjGk+hDjU
X-Gm-Gg: AYBFou1iPo2Ya8S76UFGumj7F3bUkLSHU4PhNvLWUP66aeENjDnbJXVcs0G/qMlzZeD
	9TsAQ2em6UcZq19X0B8exW+13XtZ3IUVfGX72/XLz1xkVuv2W4dhXhO8kvL74Kg5pZZrw2GHRAp
	u3LCYBi6l0uGu0KD+tnm5VRoGwpJDWrabm5/qNGyeZiC35C22RuD/wXv5i7JrqU193/uLZUxK3j
	sm3exGFnlLfvv1dKYfPFqIuv0/aSl8Y4ilMhuHXUFMkdNt+zMe5emj3QVHy/lW/zUEyWjKMMcly
	7G3ii/MJTR+PNPcfrowqgHPRNISMV4VHLoRnDTqn3U3nRLrCFF03yE2/87OWBMt/8TU7uFCI8oZ
	a2IiMR0on9tQfK65sbPbpLmQqha2CFg6NhZGLCgm/Ik0iVSr32DeKuPKm377YCfRQ6YunDbulnv
	Jtdux1dN5jTRSfbQ18NuIRHSLWzDPVU7cTrDpyC71qAAfnzrUQFxs+dayYPYGnani42k40wpv1h
	1HfLdtjf2pRePRXxd4UUZm8mtLKHoS00bXcnfLbnGvGcf8U6Vb69knVygZ7GiNJVK1Rg/ecLJZ2
	b9DMhaZwWKh8gj++lPBuabPTLY4VMHriHmn/U1ihM+GHvhlGRZyVl0IjXI60fbIr2NjON7Te3xj
	9CGGFIx0naB+1R3INUN/U+q0/
X-Received: by 2002:a05:600c:a00a:b0:49c:ed94:cdd8 with SMTP id 5b1f17b1804b1-49cf81f6736mr416215265e9.6.1788759263385;
        Sun, 06 Sep 2026 22:34:23 -0700 (PDT)
Received: from [192.168.1.187] ([2a02:8308:4092:11f0::f9f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce58da3acsm783385275e9.0.2026.09.06.22.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 22:34:23 -0700 (PDT)
From: Joshua Crofts <joshua.crofts1@gmail.com>
Date: Mon, 07 Sep 2026 07:34:21 +0200
Subject: [PATCH v2] nilfs2: remove '#if 0' code blocks
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-nilfs2-dead-code-cleanup-v2-1-fa1ab5b0abd6@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqDMBBG4avIrB1Ip9hgr1JcxORPHZAoCRUhe
 PcGl9/ivUoFWVHo3VXKOLTolhqk78gvLn3BGppJjLzMaAZOusYiHOAC+y2A/QqXfjt7xBli7fN
 hhVq+Z0Q97/Vnuq4/dcVM8moAAAA=
X-Change-ID: 20260905-nilfs2-dead-code-cleanup-cefbe2773172
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Joshua Crofts <joshua.crofts1@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788759262; l=2332;
 i=joshua.crofts1@gmail.com; s=20260530; h=from:subject:message-id;
 bh=mwRUJF3wGx2Qhe1fuExeMLHPcmjOCo1c/6Pg7yRmVMM=;
 b=Tqy5R6SDWC36FaN3x/0yiMabRHSFHS/2yRDudjVam6e1zC9Au22w8vVRRnXYlTjwYQA5K4slZ
 TVCUpQvQx6ZAzj3ljja+nYvhEABui/gpTLTSVBD5QmryPiGvfIwwg9r
X-Developer-Key: i=joshua.crofts1@gmail.com; a=ed25519;
 pk=RTDOoVwgeL4oFdASj9U+cxJuIjXuXk73zkjnGOJKbEo=

There are two instances of '#if 0' code blocks that are dead code.
Remove these code blocks.

Additionally, remove a commented out section containing similar code
as the '#if 0' block and unnecessary brackets around a single-statement
if per checkpatch rules.

Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
---
Changes in v2:
- remove block of commented out code (Ryusuke).
---
 fs/nilfs2/inode.c | 7 -------
 fs/nilfs2/super.c | 8 ++------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 34e6096069ad..778274203f4c 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -342,8 +342,6 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	ii->i_flags = nilfs_mask_flags(
 		mode, NILFS_I(dir)->i_flags & NILFS_FL_INHERITED);
 
-	/* ii->i_file_acl = 0; */
-	/* ii->i_dir_acl = 0; */
 	ii->i_dir_start_lookup = 0;
 	nilfs_set_inode_flags(inode);
 	inode->i_generation = get_random_u32();
@@ -422,11 +420,6 @@ int nilfs_read_inode_common(struct inode *inode,
 
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

