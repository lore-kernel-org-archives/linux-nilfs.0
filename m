Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B3544DB76
	for <linux-nilfs@vger.kernel.org>; Thu,  7 May 2026 15:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778169072; cv=none; b=DyOpEQkSFquOOU4EhlwTD19K5ux2YYiy6KJC1lcRKZrfNM6ovVKPnPBWk6YK7BILJTDTynt/bkT/No7F2pVNJCe6RXB/R6A9u1Sd3wYZoBlMazKw98LQbiH+6d0SagrDCHfBhFO2Ich6Hn6cMV3jJBYjRYkMfc1Mzpbr0oUANzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778169072; c=relaxed/simple;
	bh=1aksb3sTv+dD+8oaOpRqkDLM6tobIYl6BhOKTdgJS9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GUyxG70qQxG0GdFW8JdecDG40S8gg4Nl5lHJ6DTDUnGEVq/W2eApHbozKQFAqcgP13X0wgfc8Elc9TlSrpHggoc2oAIAZ7LKI0pkz4Qs0ivvI+zCmTmieOy6CRTuz4RZId+Tv0N3DwvG8ssLkFclEXFJDbqBt2RjznG+/9nZQ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gudvfidw; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gudvfidw"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8b3fe2f19a4so9737646d6.2
        for <linux-nilfs@vger.kernel.org>; Thu, 07 May 2026 08:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778169068; x=1778773868; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OhRvkpgM0QSD3U0j8IgTu/cvPqVZ1+L8TzU92AUGNRY=;
        b=gudvfidwxcT5uAWIwQYtMfAshQ+ZP3wPGcWVPFq19mbXLeDHzZ0RUB7MMMXvUiUGEn
         /DqigmzBlS3U88QrgL3sv2oyYmQbbfLcsTgfrfNO8n+khYcwD2MOA1j4mLclfpTHjVU2
         tAKwfLbUgb1AhBXP+dFEoC8Us1is7uMKXX/Jfc96KtudYRnT86o7XlTmMaf7V6HlPyY/
         bqUuSCqLjksrbyqrL7aT3W1hkb18BmKBSqvR0s2Qlwp1dXmXuzIAblXmG6emFuEkWv5d
         j4AxI/chPXy8xhaOUs73AVmvi9FF2fcWhCAfvBYrrPUOQuLPZQCIx0iNtJAgGZS/Gd7b
         K8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778169068; x=1778773868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OhRvkpgM0QSD3U0j8IgTu/cvPqVZ1+L8TzU92AUGNRY=;
        b=p0TXum5Rwr+Oq2E4e7hVr9fNN6FOZuXVpXD0QYDtJ0+M8zxz8NjlHZbQbbmnQw0tzf
         dCQ306Lramzn+y857PYc8XgTjVRL8xgq5fEBYio9YJnugoHLJheL9miCvuWNZ071KwXF
         lOf63PRQ33WWAlFxysuxghA0R9SYPe0gD4rzt5p+Y6hnAHChyHR9lnr480qHeUlTYj5g
         ThIYqY5xfFi8XmhHCYenPVVvA0EMQ4UFuP5Q+7It5mtvfXKGUsAn/lwUApO/OK9mHS1w
         FngvN5QcE2I2sPeesXzEP8n9Npsp7M+uMOz5GK1JkOk6ezFcPy3U3Zs4giPiTWDtWClh
         kqBg==
X-Forwarded-Encrypted: i=1; AFNElJ9p9Igr03pradE/3+DX0eftvUFnVKizr16y+1U9u7Sz4Jl4VmUThBd5cAcwRcBHzFkPSeDyrPBbpCjOVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1ZpAyzqIJGNR36kf3tYgzgxmRcVJ3culJmXhSF06Gt7EgL/tm
	5G788kONT2w77wHQvBspQjenjpuG+HL1W32ypZjBQz34hz2DU2eUJ1FB
X-Gm-Gg: AeBDiesTOsHSeavJ7/Wi3eTQV3Z0SzAsjXlT61JewJcp9PQGAlZ67Z4F3is2V6Cnsq9
	NTUzInJBZ3ltMe2WkbrLpSwGzftEkt3p6sPDmQ5Bpq4H99tpIDAbDYueaUL/Pusji6iKPER4P8O
	MOwekVotC/Ug+sT8BucAmnAlVp42sHK8iNaLC1RUFPem5faaU/2H5dtQcQAvKTYA5cvtM+ARVlc
	DLzarOHgnGMJj8In9UXMLR4/MJuYdRgNS1KOh9ip5pAThGJZ3BbF/oRsdXkAlFx3/HzXQZEIyXy
	CvqF0VCky3hy3sAqkQV06qq2Qt9pSGZV+qWk2WmL6UtpNZzbHk1hd/iSioDN2H5Q6z5YXWucdxL
	qc+/ZliOe1WyV7vp+xrg15UawyvGo7vjckHTwuGpTxCdjoTLumQamHWIMdTcaPjOEAGjtv0JO+J
	dR6eZis4E4s2MFIpRejHep6abESXQaln47q4SlZjPwqZCReiTiRnsgRyml85V9QJ95
X-Received: by 2002:a05:6214:2308:b0:8be:1620:a98e with SMTP id 6a1803df08f44-8be1620b526mr32917656d6.20.1778169068527;
        Thu, 07 May 2026 08:51:08 -0700 (PDT)
Received: from I4-L-HQH5357-01.ad.psu.edu ([130.203.159.160])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53c0e6d72sm234137206d6.26.2026.05.07.08.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 08:51:08 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH] nilfs2: fix backing_dev_info reference leak
Date: Thu,  7 May 2026 11:50:21 -0400
Message-Id: <20260507155021.941895-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

setup_bdev_super() already initializes sb->s_bdev and takes a
reference on the block device backing_dev_info when assigning sb->s_bdi.

nilfs_fill_super() takes another reference to the same
backing_dev_info and stores it in sb->s_bdi again. The extra
reference is not paired with a matching bdi_put(), since
generic_shutdown_super() releases sb->s_bdi only once.

Drop the redundant bdi_get() in nilfs_fill_super(). The single
reference taken by setup_bdev_super() is enough and is released
during superblock shutdown.

Fixes: c1e012ea9e83 ("nilfs2: use setup_bdev_super to de-duplicate the mount code")
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
 fs/nilfs2/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7aa5ef8606cd..893a504cb80c 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1070,8 +1070,6 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_time_gran = 1;
 	sb->s_max_links = NILFS_LINK_MAX;
 
-	sb->s_bdi = bdi_get(sb->s_bdev->bd_disk->bdi);
-
 	err = load_nilfs(nilfs, sb);
 	if (err)
 		goto failed_nilfs;
-- 
2.34.1

