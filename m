Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792706816;
	b=D8Ca90TrEekr6A9QjvX4UlgV0NHXipPxYUlMXEbiNqpg4JOWKRdoM9rYvd21AWJzHmRm
	 wygucNZRueJWzHZn4D3Yx8AvPNqK9ZFyujrYKQPzw0RGAmLDGvCJjOfnai4leznjczwH5
	 s9XiaX2G9KKKiQU3aVY3ANK6ageDYxpiXAutYLoR0ShF28c+pT44Hq3L3ENGicEWClLrq
	 gZ7lZ6XwQNRNrjIQ+kOceDV6fH764TEOaBlvoQiDi4hRyV8NuCvwNcu/XWrq2GPwmcxYP
	 XsHKMq11U7b5owxfcZVTqdpsjMCXyuwbzcbvf6kRb1IcmOOPN07sB9CFtEnC6XNbbnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792706816;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=G8gLassD0QTh0gr4RAHwdfUGv7dzLS00phLG0gjKAMs=;
	b=G5WAozIAi7h6vZvFgct2Ng16bZ19lvjyhQb2HMR75REhoSBOPDlr6/39nqzI80ndk8Lr
	 poP54RXmKSw7g9d5/DCqqcQ6F/lYvjrznyRFoYnMgdZzlAwnNQp/y7lXk++BlamvhQba2
	 Miho0eklang3+AoWpsRuLPR+rB56r5kyAM4ixNkfSuAsCeRtVrkDaA7VaF5/xXCADvA7l
	 iG3P3gtwWJa1I8JlE8b8UnZz57sFCSQGJGIlshhAVzw6I6Tmc2xGsdRUpxmqlaFeSyTGb
	 AXSWychvzTXX+5tUMKJsguUOzxsvhAuJWKsWGo/DlD476aQDrGOo1Y9y7Wx2kg3C5Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b9axIoSj;
	arc=none smtp.remote-ip=209.85.222.42
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCE7606A31A
	for <linux-nilfs@vger.kernel.org>; Thu, 22 Oct 2026 22:06:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCCE7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b9axIoSj
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-98c78660542so244039241.1
        for <linux-nilfs@vger.kernel.org>; Thu, 22 Oct 2026 15:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792706815; x=1793311615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G8gLassD0QTh0gr4RAHwdfUGv7dzLS00phLG0gjKAMs=;
        b=b9axIoSjFEUqmtBYmlJqiWDbkQTqPpI0mIm7xaKj+mrDNJbn+KUcDFs7zfsbuww1D9
         5vt3AZS0r5fUXzr0CpoNNIobFRG2wvIxDlnpSbqfACzzLxXoDahPIa9Ex1nlMA+5Bv+m
         8uPCUr/jGel9H6SXQhwJniyu4oVCNvmTXBsh6+ow4kJ5uDJ6vJ9F3mdFOurmKwrhOedb
         JUmHDBm3DDQ6RXjIYrD0eG7yb5VXVXcQqbFC/D/gae9D+GsYbv3+2wV8C4MsSsI/mjrD
         Xi+QjTUsNZdxDwlBZvtndo7tQaSHKbs2RHc+9ggRyTcbF/k912M9ooShnmX4nk1dhDZg
         1f0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792706815; x=1793311615;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G8gLassD0QTh0gr4RAHwdfUGv7dzLS00phLG0gjKAMs=;
        b=Fq9SR9/hOaYZQz57Eatkd2oUCBQnrOM1PChtRdkqIwQ5Gy9/MiMRl4qUIAMws6TLru
         DSAeQxw5xG32yaMjjIG2gn2V/4JA+6rUZAc6TUtCObKUsSE97U1DbNAUynZ7miP0Xjz9
         x+zZ2+K6u/alC0yk2aVkelqzFHvsUvFBz08SUtcen9eMK+ewG/Te0SeQbKhJ7VOiAml9
         rtivxCcZ5PqglvTHFhOy4GbadAzK/yFsynO2/4VfNklfrX7IptrxznU/MiFRbusFbAoL
         HaCjzu1/8EwPV/VH+hh9IjP2j25KMtRXiZ9uBm8ErjOAD/khpdn3nty25LBtmFynxPRf
         Dtsw==
X-Forwarded-Encrypted: i=1; AKwUvBzp912HmGYkj83edZLDV0zqvby0ZZ9dPc9fTWR7fsAwqBviD82zp5W9GvrfeePxjze1n9yjTwhaC6VezQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKESbEBWJjaMdUIaVe4BUy0lAuTC7gE9Mcpx1h1nE/H1J9CA5Ir
	R3p5u5OPSHlyX2p7eqRJba4Xs2oFUaxmKVo26woTNMCWn1uezdCb6F8e
X-Gm-Gg: AYBFou2O8xbx5Tm2MWVhaxE3p82CMi3GLPp/yEtGH950MOT8x3oV0i8tZvXuxLMknof
	a9V0Xe37K+eA5P21v+3kdIZZyKI4G8+YX3FPZ4B8oYBAh3ogJC+A7JLdFXSNpTJrRxzLtCKLAZw
	JgQ4VjZca+IHN1ZDb026KkB1XDiD4ZnQt9bg1YtZdstsYd8+NCPnFx5SPYPTPqyZUtLS04ailf4
	9yji/Ah7NjpbNLhnP6lbgefE9Ut0sSSrcKWJewKn4OwowI1pasT4WUz4GpqZ2Tdj7nVrRioO6sN
	Ba9OqiKrk+mFNkWuw2jnnJp5JULy3d9yUdbLyGHKFe3Tjs9RERCf5SDLmtR2bdtx34cU/Z/9a4E
	iCvU9dBN/RRpIQZ0V3GpyGjZLyevCGpGHUiQLlCVGucTCRckIuxzHH8vBlJqpCf8fE8TtYd9nOM
	lo6pdZPLxxeW3UHHriRb6YHYNxOzY45I6l8D6aZNMe8fvHtn22m9V116UVpuLAC+UWe4dU19d87
	ATKEdjhaBv1pa4oZve1YgsiD0vP8FdKsYFHRjkfBmXOofyoEJysl53rRfV7He2PBrSQlFWqntHO
	w7y/vp97s7GQFxmY5KnF54085D8Mdoee+p381ddsCQ==
X-Received: by 2002:a05:6102:2922:b0:7a1:f7d2:e82a with SMTP id ada2fe7eead31-7ccc34d7534mr374508137.35.1792706814650;
        Thu, 22 Oct 2026 15:06:54 -0700 (PDT)
Received: from Biostar-A520MT ([187.94.15.233])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7ccc20fed4fsm1122753137.7.2026.10.22.15.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 15:06:54 -0700 (PDT)
From: Breno Rodrigues Alves <breno3011alves@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Breno Rodrigues Alves <breno3011alves@gmail.com>
Subject: [PATCH] nilfs2: remove two dead '#if 0' blocks
Date: Thu, 22 Oct 2026 19:06:37 -0300
Message-ID: <20261022220637.89697-1-breno3011alves@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove two blocks of code that have been disabled with '#if 0' since
the initial nilfs2 import:

  - inode.c: the code that would have read i_file_acl and i_dir_acl
    from the on-disk inode.  nilfs2 has never implemented ACLs, and
    the i_file_acl/i_dir_acl fields do not exist in struct
    nilfs_inode_info, so this block has never been compiled.

  - super.c: the classic ext2 "maximal mount count reached" check.
    nilfs2 reads and rewrites s_max_mnt_count for on-disk
    compatibility, but the check itself was never enabled.  Removing
    the disabled branch does not change the on-disk format or the
    behaviour of the driver.

No functional changes.

Signed-off-by: Breno Rodrigues Alves <breno3011alves@gmail.com>
---
 fs/nilfs2/inode.c | 5 -----
 fs/nilfs2/super.c | 4 ----
 2 files changed, 9 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 34e609606..c5b0e9f27 100644
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
index 893a504cb..d0faae49c 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -826,10 +826,6 @@ static int nilfs_setup_super(struct super_block *sb, int is_mount)
 
 	if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
 		nilfs_warn(sb, "mounting fs with errors");
-#if 0
-	} else if (max_mnt_count >= 0 && mnt_count >= max_mnt_count) {
-		nilfs_warn(sb, "maximal mount count reached");
-#endif
 	}
 	if (!max_mnt_count)
 		sbp[0]->s_max_mnt_count = cpu_to_le16(NILFS_DFL_MAX_MNT_COUNT);
-- 
2.56.0

