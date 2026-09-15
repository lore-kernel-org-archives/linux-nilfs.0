Received: from mail-ua2-f12.google.com (mail-ua2-f12.google.com [74.125.226.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A782A395AC7
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 19:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.226.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501961; cv=none; b=ZtcWWpcpev4D/o61uQwDqfR96pwPGPatbaDHFiA0KpQMHUQvowTGumZA15zXPcrK2mzv9XevJOLzypn3R3GcJeTNMCbyXclZSQmkk/Wn19y7z9SjftBFgOSj4ZKAOeyscqp5kXIGH/PtwSh5ycRCYKj4nit6WQQ0o7gtI0hm0JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501961; c=relaxed/simple;
	bh=2cXXOWjK7JoLdFJFVCJGqbFrSo5eKES1Xt0NI4Smz1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dU63Tch28NIHCDd6cupkF3qjhKtUhGHuEfE9nEXhWkTp44w2sWtiw9eNoEGv5QPXtcPWemzCwOzq/MzeNyj5P4Phn4A5z0ohZtGdQJEeCYcopKotetqBX/WUOhKEz8smsFFysLJEoLccwwympcJgLoO1OwoKJ7YnQ3YuaVn9lj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1PHTmnQ; arc=none smtp.client-ip=74.125.226.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1PHTmnQ"
Received: by mail-ua2-f12.google.com with SMTP id a1e0cc1a2514c-97e7c7bc5bfso41156241.2
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 12:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789501957; x=1790106757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eB/X2yMgQrn8vw6u8/x8ViKhD/NsvvzC8LKDvhRpti8=;
        b=L1PHTmnQ1HPmI+SvWbUih+Fgde4geOnQfNUR3ZSZhvfB7ggKWH29iEccuOvvIV6hKB
         MBED8p29l6vNm1hxkBwv/9C3iMwBhs6RXXIkrWH0IBT2BSfKFCfYORuU99w3CvUj47FT
         c/RZ4uluO6OF977TJqa1Myi1tLKgXTuBY+9+TxBb0rgELNW4U0Hum6o58P4DfBORwbmd
         nehK449bPD9GmvAclz5z1kesvSdAjunXXC/7pd2M2O2LmvkKhZw7DusHJze+AJfByDJ1
         bPDw5lxTE34mZGQ4pW7btvoycCgExWoRWpepkjne4BPd7N93c7n/vb4euYQYHf6NbFIT
         1oQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789501957; x=1790106757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eB/X2yMgQrn8vw6u8/x8ViKhD/NsvvzC8LKDvhRpti8=;
        b=mYk1J9tdlIXzo02U6vpm+/yqrF1cl5cH8bbFHR5Rpo0cQAb/kvP9/zpUAPKWsuzUdw
         ts2BrMaWowrStqsXv6rOi8QJIBOT94/xfj1+cFSkbwHdlq8MMal29Og2sBGf875yZvy2
         exEklWp4q/kbHn+ZQt5FY2MRKOtUI0ZMCUzSK+MFkTLp18Hep9NNaFODsuKPVm66u+Tf
         vCvnCJZNhg/pQngkxh53Z1QmqLkf3Ux92nex4YsCcZpBOBmY1TWvZxgpPug5cBPlwPnM
         X4F/Mzmifp6axCWO/UaiSc/1q233iUh3/iVf04hsnBdtC+csDnXeOBKrfE/lN/go6elQ
         94Jg==
X-Forwarded-Encrypted: i=1; AKwUvByep23xJHmK03TEhMM97URfFZvMwm0lxL7WcnuoL0SgvJX+KZ2QhWRXvbFIrTcy46G0m6Nwy9dTDVYAhg==@vger.kernel.org
X-Gm-Message-State: AFuF++lr4g8r/3y246WBCswnU1HvBIN7WM8Iy01ZY0k2WMv2x5UYGQ87
	4oQM5T1LAurgqYL0wiz+pjQLc8tfXzSZKVzAQMriohU7o53jW5DwmnwC
X-Gm-Gg: AYBFou01h4jOSB85qFNGqDhfM4+O6AdSLMpg5bcTI/2dbN3/zDEqSPVE5RW9GZF5Weg
	c6J+hsfAXfBdlonhcRkWcxATuEiRknAArQTktKF4eZ0CEBuJV9+QNF1ST/Jf85u3jgStc3Ear5S
	oyeKdlsS0wUA3rHsUiz5KyMqzFHLgpPcwKq4a2KAbzugFNQkGPazoDyhXj4sbuf7Mdr3STdg+gS
	UL4Q19Yx7IbPNdxni2MnLjc5YkNEAS6XusLy1nmTxR71f86kVFRdylzn2aDEL3N4XQIahkooKVs
	FHevQzQHo1QfKmpT/y/Xaiapk91D3eluuuGHRTmIgVDto1U8VD5nRI1TSwQQxzKO+Mg92/HmWMk
	lkwilYEhOnu452UcV1tTfB/kWr+OZsQxDF8CnVntrrSpXts3134ZreREnr2FUprjI0ovqdySFz2
	iyGUCzfDMbIN/AMvH5S60PDMJih8FJOhGKQesyhwI4i+tOaUr7XTUUq+RYfrDxCR/NjHJj8EA5Y
	BU=
X-Received: by 2002:a05:6102:3fa8:b0:789:100e:3d1b with SMTP id ada2fe7eead31-7a01f188877mr34423137.0.1789501957560;
        Tue, 15 Sep 2026 12:52:37 -0700 (PDT)
Received: from beelink.. ([187.13.206.89])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-79fb193720fsm823368137.6.2026.09.15.12.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 12:52:37 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH v2] nilfs2: validate segment number in nilfs_sufile_get_suinfo()
Date: Tue, 15 Sep 2026 16:52:23 -0300
Message-ID: <20260915195223.3331909-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <MSG-ID-sufile-v1>
References: <MSG-ID-sufile-v1>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_sufile_get_suinfo() subtracts the caller-provided segment number
from the total number of segments without first checking its range. If
the requested number is greater than the total, the unsigned subtraction
wraps and the function may process segment numbers outside the filesystem.

Cache the total while holding the metadata semaphore and return no entries
when the starting segment number is at or beyond the end.

Fixes: 6c98cd4ecb0a ("nilfs2: segment usage file")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
 fs/nilfs2/sufile.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index eceedca026..573646c5f7 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -870,10 +870,14 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 
 	down_read(&NILFS_MDT(sufile)->mi_sem);
 
+	nsegs = nilfs_sufile_get_nsegments(sufile);
+	if (segnum >= nsegs) {
+		ret = 0;
+		goto out;
+	}
+
 	segusages_per_block = nilfs_sufile_segment_usages_per_block(sufile);
-	nsegs = min_t(unsigned long,
-		      nilfs_sufile_get_nsegments(sufile) - segnum,
-		      nsi);
+	nsegs = min_t(unsigned long, nsegs - segnum, nsi);
 	for (i = 0; i < nsegs; i += n, segnum += n) {
 		n = min_t(unsigned long,
 			  segusages_per_block -
-- 
2.43.0

