Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29566480357
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 11:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789470796; cv=none; b=rBxSAJgEVVkm4016HjCHtysuz/iUurV53B5drTGjmliqhcWaNveB0TvOB7HtaR+Cgu1wxBOACBoFAzZtTysNH5oI6RBo1hqx+lirCCKfJyOtGFHJwqsQIGwXWDp24GRhywSgyPb8dUf6q1BBS3A5rrS/NcqOtwckK8h5rwJj5yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789470796; c=relaxed/simple;
	bh=/PR0j++xcPWGK93YoIOPm58P6YQffnZS3HOrs8+CybM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P56yhqgTq6GvEFslISlMTyTjuAWx3WI4xa31zthzRURbCgdYrdjkGZuUcwOZ9JZlraLTk7/w82ouS+g+7OaMZtRm81xNsSdxi33lfnoGKAUEHOJTIrnjUY+tAQWldzV1DDY0gHNZD66STcskHucfTws1KXQxVnhbSIPTbdu7S8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c0Lu502T; arc=none smtp.client-ip=74.125.227.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c0Lu502T"
Received: by mail-vs2-f12.google.com with SMTP id 71dfb90a1353d-5c67e52ff5dso105637e0c.1
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 04:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789470793; x=1790075593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rt4p4FNPH1KSDrszwChGPcRmHRzEiIH1d0VPdJxsVWw=;
        b=c0Lu502TkcgVpW/RE2MekxssRGxcZF4XsDWlVvHYF+hwybWZ1CpNovy308sawZrts6
         3MtRW7OhW2hqJy2hB2PNaVlb84l1wdFwTxMN1ZogLtCRziCA363h3sSLTDg9wLp/67i1
         aXHDkV0StDWKMznUMUYhb/BcfVQ5JfoaxvoKmDIZttyC4r5mSs6U4W846t0hSsj93+3R
         OXZxpGIJ++K8d+G+xwhFBmRVwVeBqdET3c+QN//ZxsM0PUDIt4NmsuZpaF416ZikP2th
         Qlx0iDx0SzkhuRWGm6KSdoQy3te1UatiJXTNa/S8iapKaV43R/bpSEQblMhIDNFDPzeA
         Exew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789470793; x=1790075593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rt4p4FNPH1KSDrszwChGPcRmHRzEiIH1d0VPdJxsVWw=;
        b=aEFPqn6xcx+/IcT/wEBLLwgxICSsx8jyaTLpplOIFYMB3tZfa97CxE7wq/IdSTw/z/
         t5k2Jl65U9WwTNE8g5a0BH08oIELr/hAZPbw93H9qkYfELs+0T+3eRqzhPR5wLjyNUOT
         vDXu8Ptmc/6c7VNkxOBrU8+mdo89wkuAPFsdWvWfgF4QPtbN8pCCJeYKP+N1qYH5dXO0
         f7dqAK6/54Gssw4GrS9gDnSSJK5Fs0exEm/CAY/Stf+vvKklQHdFvLXCTG6BwBCU1tbf
         Iu++lYnJ3D2C9UuTcBa8tkhIUNzE+KR0ymu2grxqtAtvgorPQbSUSmdNRDlcesWK6Kik
         HYJw==
X-Forwarded-Encrypted: i=1; AKwUvBwkJz/mcrY8pZTWW0IkWVtm2QUzSRMD/ddu4M1k5RGM0lsg+v7zQ5QXClE7GaIRrRV6gQAoBdoNdNdjlA==@vger.kernel.org
X-Gm-Message-State: AFuF++mhXTJdFZi1DcVoJ2ytgGSlFTXgAaOUUBTWzmGzVCBd4X8If1VF
	04WkDjvTKhzWV2p92zbm0HwPuwHGFz13rMtpSfNNGWZgjR+g7QYx5Ly8
X-Gm-Gg: AYBFou1gHKT1uYwIU28bFEObAxo0oXWAp1Au6IRPvULzOa40Wy65V0JZK51qxu26iMK
	ASAr73lR0Pb8prRzAA0hhDTbUVISP1NCAkHehj9FhJFrbQcA0dlKUgQEqXRUvUhs2v3iRhWwonN
	x9BO+h4XIc7iwDdrY1LthjQRvjVV5T35ASghA+Zis1xzYDHk8ZflaiC3ztbj3AyvCHAzTRjgS8o
	obKIf2CqgqeLLcNIF3qWuLcy3znyjLE5x2OZiYtUbs0kQShRv6MpP8UfvdNnYy1lqqFBXJqJJ5M
	lnPc7Rk3+vdyc/V07DNdNfTmr/p2/wPqtKWk4RkV759JYDssiDDCazDziwFy69zazWrio5h7CZc
	ct+zkDreb53h/dsMGPHgkOUhTRkF0s+LiSRrlyuncsLFj/xkH2QMKVPRciFSpU0WqYm0449E8w5
	Hk5zt22jActxrYP2+Gvaj/QkLp6t/NkfyYzoXsDQz5CvnYZZBszW3iEdr/9QXVDZTh
X-Received: by 2002:a05:6122:468c:b0:5c7:ac2a:770 with SMTP id 71dfb90a1353d-5c99393b496mr356493e0c.2.1789470792795;
        Tue, 15 Sep 2026 04:13:12 -0700 (PDT)
Received: from beelink.. ([187.13.206.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c846e05523sm16095573e0c.0.2026.09.15.04.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 04:13:12 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH] nilfs2: validate segment number in nilfs_sufile_get_suinfo()
Date: Tue, 15 Sep 2026 08:13:04 -0300
Message-ID: <20260915111304.2725651-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
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
 fs/nilfs2/sufile.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index eceedca026..e3733d2be1 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -864,15 +864,21 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
 	size_t offset;
 	void *kaddr;
-	unsigned long nsegs, segusages_per_block;
+	unsigned long nsegments, nsegs, segusages_per_block;
 	ssize_t n;
 	int ret, i, j;
 
 	down_read(&NILFS_MDT(sufile)->mi_sem);
 
+	nsegments = nilfs_sufile_get_nsegments(sufile);
+	if (segnum >= nsegments) {
+		ret = 0;
+		goto out;
+	}
+
 	segusages_per_block = nilfs_sufile_segment_usages_per_block(sufile);
 	nsegs = min_t(unsigned long,
-		      nilfs_sufile_get_nsegments(sufile) - segnum,
+		      nsegments - segnum,
 		      nsi);
 	for (i = 0; i < nsegs; i += n, segnum += n) {
 		n = min_t(unsigned long,
-- 
2.43.0

