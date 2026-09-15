Received: from mail-vs2-f42.google.com (mail-vs2-f42.google.com [74.125.227.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC9038A702
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789502288; cv=none; b=Eo8rCsfdSTyR2zkNNWTG4ja1ZpKkklJ2Lqy2Cw22bRhIYGPDr+e6cZRPzw1VyG5W+erAFWyk5ACj0ccyeXHp9A0GuMa0tHbGaQlmtSG+FfaORwtZabL6sdusYVIm4mjSaBG9sz//ecfp4YpG/tUDX6BO+Mv7pfA1Mi2OorabanA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789502288; c=relaxed/simple;
	bh=soU+IJMQYQAk/mFcVgaVMr5OydPHwZ6kxs1PueuqXB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klHRWyg8eAh7jj2wurfHouPRzMtio4D8AlA4oKfz1tnhEkjHWppnHuUTJPATGOt4NEpc/WMex1Dp+ZaY7Zw/cntat0UYc8pRkOoKt03625xfquknbuQjf0NdYCuYxtDvRfS/5aPEwiwIukkPHFgUHbbQW/eoiLevF32BgJkTpNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FqM4lBm9; arc=none smtp.client-ip=74.125.227.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FqM4lBm9"
Received: by mail-vs2-f42.google.com with SMTP id 71dfb90a1353d-5c67e33b917so113099e0c.1
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 12:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789502286; x=1790107086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C/+JbpbsAYVYVUx1G5/XfHKlvoY9nHrnkBiKZFD9Udo=;
        b=FqM4lBm9cxZ1mn6/qIAiHRyV2Hk91aZlG5+f/qQMeBRpjX+Nir43Wo58+9jmaxuCUR
         1HqH1Y+dk055hyA2sxW7S1bAOARxP3DyT8RHGoBgtq6moS6JfYOFzNLNCa6QjKjCGmCu
         bD+bHSXQ/Fh4Pn+P7bKxes7D5lDSdhd4wR53owRJPQpTWhLjXiIg61R9eAs3fjUevRBZ
         q80aL0hpbEIgR0VwpNMAKGTdgBEdR2zHrAQ1RFC8UNG7jSt3wzLVbLZU42uC9Yzw6czS
         gqJgtj35E24BQx75ozasaixV38/u5bAMuIcLKsNUv/QVvKk3F5GOpvkfCJZNF0/6tCur
         1CCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789502286; x=1790107086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C/+JbpbsAYVYVUx1G5/XfHKlvoY9nHrnkBiKZFD9Udo=;
        b=r7toHjC1findG/6sYgQxTUCo2UijqFtBe5ds5WSJFkaWV2tUAF1FDdjhKf9jFNm4D1
         ghqJPfygvvC2sHLLilWyGEkdg51/D0EF4ggzhzsLYskXtwqzwpagjkMDkPDWpTh2x3gc
         sv1v7XTS+q90xnz6KkyFAzq/PuGTElyWCZ5AbGealUD1XEFUEDdbiQJdz5gw51xwhhkF
         izWtse9MmY9gJ6k9hHlbPImap4d8CSoBrXqZR0BNaHTSVppiRyF8JM14RH4G0TCszfI0
         THMlW6PWFf+tO0q/T9TZ85S1aanAgKUsm31aQiJscpVYqKo+6SF7rSnlYJhWxY80MRqK
         1hiw==
X-Forwarded-Encrypted: i=1; AKwUvBxSxyF612/pW81PiGHrofgJxl2RcyC87XNTsuCLF0tRY1K/aiF0PgooTMcW8HxcbY9cXPmLQSLTKwxDYg==@vger.kernel.org
X-Gm-Message-State: AFuF++k+BAKbj0MbCw2h0SKY33DyPeUqUSeyTE8ZBLJSOMApLz7yMuIY
	jQGrmwhWKWyjzyfFYMaZD5H+GyN9VdXTSHQ0hXJDSJxjOOq37ZcgiJcB
X-Gm-Gg: AYBFou3VCNxjBglMlUMxt9CHmcnJijO3KuYgpXUqrStA/vbPCPCqCNDW5GtzBhcka/b
	IvD1Nlglb3NWkCucKUynqTmHvRIBVWtP8WPT7800pAnvBL0DUrv0dhRQrG2j9s7o1Wf9/HUJoof
	7L5deus3EGvwxtFOL1vsixt0wSADKlg8QycMvFdaPwZiCORN4nf4w2RoLjnn5nr7Art2YTid0qa
	raF321/gnc7AmAV+eLpy5v8VL/tCQuytzjgEMOlXEymEhvWkXc/o+OLgXrl5PjcjVpZTUTEtxLK
	qo3ZmXeA/4hsFeWctM5Jg+u3UDeoZSwZLeCYVvwycnzbPTVGTP0xlLWjdqRCJVqrVMiVlPDpdfh
	EGxWRQexNWCiRauJtAof5x7hQrsy6cBq48FMoRCP5J+8LH5VCRo7My+W/Cuhp6RTFZs6iyTGEgq
	s0/7aMlwDzsNxoX8hvj/A56YU4U9N+psHWUq+/KpQZ9/04gDNYVayJ8Pq28v/Q6BPZ
X-Received: by 2002:a05:6122:30e7:b0:5bf:8c77:e89a with SMTP id 71dfb90a1353d-5c993aba6b8mr5975354e0c.2.1789502286009;
        Tue, 15 Sep 2026 12:58:06 -0700 (PDT)
Received: from beelink.. ([187.13.206.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c9988e5f27sm587530e0c.1.2026.09.15.12.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 12:58:05 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH v2] nilfs2: validate file block counts during recovery
Date: Tue, 15 Sep 2026 16:57:52 -0300
Message-ID: <20260915195752.3337033-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915111351.2726334-1-qwe.aldo@gmail.com>
References: <20260915111351.2726334-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_scan_dsync_log() trusts the block counts in each on-disk file
information entry. If fi_ndatablk is greater than fi_nblocks, the data
block loop can consume excessive summary entries and the later subtraction
used to derive the number of node blocks underflows.

Reject inconsistent file information entries before consuming their block
information.

Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
 fs/nilfs2/recovery.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 4d5a6aa521..28200cef4d 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -359,6 +359,10 @@ static int nilfs_scan_dsync_log(struct the_nilfs *nilfs, sector_t start_blocknr,
 		ino = le64_to_cpu(finfo->fi_ino);
 		nblocks = le32_to_cpu(finfo->fi_nblocks);
 		ndatablk = le32_to_cpu(finfo->fi_ndatablk);
+		if (ndatablk > nblocks) {
+			err = -EIO;
+			goto out;
+		}
 		nnodeblk = nblocks - ndatablk;
 
 		while (ndatablk-- > 0) {
-- 
2.43.0

