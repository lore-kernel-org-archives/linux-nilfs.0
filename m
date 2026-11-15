Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.221
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794706564;
	b=M7GPzp7gCbLcIRKRM/gf4WCTOw00ZUlDMM0Yu2Iiss2nG14q5WByr6o4C31ueGTUP3fP
	 amL3pUo8eYMOEKhE0kctl+tVfUoKp6jyKdDnAbCVFP3/sHCYiPtTqAsMYx5XTQ1GVNc2c
	 D0ncsc+tTkD2pjSJiJzDpiPXZk3u9OjCTr7Ip0O3J6Rj/HHWq7xxRk5PCpDk6bE9ZsSVX
	 HkVp4FlND0bdHWtZ+GO2q1LGjHKO2s51NWuHZNCCEMPTmYY71WEDaxLlHfjuOTOxPfrNH
	 rP6GcU/iHiYHtE3jvARi62IkrRWMCyrsm7FdnXVMUnD5wbRHq9DYikZQz1cp8bWlsGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794706564;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Nm8wurlJlOnyOpdAiyvRqoIMW//he+Fp0Mb2Xpll6DM=;
	b=qoB0rrA8qJ+rKUvB/ek2790N6OHXxo6m/R20Qo8W3h2rrAitNt4uGW64N5Bn6eXPsLen
	 3Z3MdZBds1ZuffSl+vJCzFLH0LvsuksGmlShXMygdXnEjEb/tZiOzg13cKr2guF0CAzAh
	 Oa3yE+2O5CjfkNcBObMOfjopxP8fOWmmfaq3pbC1y5lNQre0W6zfd2r1o8TjQb43RMF1k
	 JH+/p1NOoro54YdlhcRoUCq2xOx9hRD7S8hSJ3szIX4HEyuSRr4ZtoV82iCglyNAzKsqg
	 mcTnGGR0hy/oaps2DqnGLYQNV24ElzUxNTJyf7V04B9Lmp8+N5HNJJDlt0BYt5EaJuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=foxmail.com;
	spf=pass smtp.mailfrom=foxmail.com;
	dkim=pass header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=q6mWURnm;
	arc=none smtp.remote-ip=203.205.221.221
Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891B9606A323
	for <linux-nilfs@vger.kernel.org>; Sun, 15 Nov 2026 01:36:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 891B9606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=q6mWURnm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1794706560;
	bh=Nm8wurlJlOnyOpdAiyvRqoIMW//he+Fp0Mb2Xpll6DM=;
	h=From:To:Cc:Subject:Date;
	b=q6mWURnmU2XihqwDwLP6YJ2QGT71Mn12S+7vvwDFdVQ0U53U6UUVMOSjEGTmVdr6c
	 ubzf5OJ7BA0IyTWolEZKhJPDjqNpbg39CUFQIoTAqVRFp3UATgO63amRvi2a1VmBIa
	 1QAlEm6Yi58VZFHdMflr5DUWs6m73cwk3PceN2EE=
Received: from localhost.localdomain ([2409:8a00:2545:bef4:c8bc:9cd1:4eaa:3])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 8FAB0A63; Sun, 15 Nov 2026 09:35:58 +0800
X-QQ-mid: xmsmtpt1794706558tfrpimii9
Message-ID: <tencent_41EDF983C02D93A045296A88093905F5500A@qq.com>
X-QQ-XMAILINFO: MD5k9EpssWtDeW7aY51h2Eg5tzwHAB80lSduXQeum/YbwFVY4/W42Tq86yzJ9F
	 7DMJyNTmkLswjz1hEUwzFcxesGEcln+U8RbZ7VFfYGRNZDFtYp2teOcL6IN2D39WzeyUOAERiLaz
	 eYl6l35GN/w37zxX95oGYbdzHqMxCUy35ge0tc7I3RY0IgdxeSrHz3qCi7YcZ1jWmSZE/nIpRgKF
	 J91rTMM6paplEHOGayCk+RaszNXcu77pNkNH+gvL8O8savafaMwaGuLqD/q1fWaMHO6YjS8bZnBP
	 0Q2xjgvuQ+cL4tJ9GZp7+TtddBTue/os9v1n1VPdKaq8xiWYAX9cG7U5H6P1+HrnztScl3hm5+Si
	 Iq5wG6vd/+/QgW8WHM3CpejYWuNctFfj8HmFOgvl3La08l2PtWrYgGr4niNSSnHLoZxHusyhjh15
	 khadDj8SPc/GlsnZWgnM7pUL+i6LHa5Z93PHHFiSUw+NW+DWS1ck+vaA7bOfVlW+9R6aGLN2Shix
	 IfR0FetbzOnLpejKHrPTR4nMlmNz4YBkBucIbDPVIYLCRQXggnZkm/WM3X6PpJ6I5o7MGywf4z4w
	 Ok6QSkjXv/GQicDtSILQ7T+t5XVpeBpt2aA/a/x3DINJjJ4V1LIvb5XYHO5gDBex4uhsATEhpeOV
	 +qjtwpQ5hvzev0JaP/aVVBmsLl1bB/iA9hUeGg49QJEOrlPmHxmOwqtcdLPVLvNAcpwYQ0oLJSB6
	 qdjm33nG322T9Y/0Tf01SOu2D7ssHCasIfDP1QpCSPJwCWsHlYyqUlSY+K892NGaETcVKdhZuQZN
	 d4V1Mo+9u0xNUWT1sWXI2sHHdAdaR4FF/cCZQD4qIPDk1qOxsQl08BidwJeZ717+iMfx4vdDYZtF
	 koerS95jHKSFkut9EwWT+UCTypB5WJdSIdxehjarKTTfRYXZr1gPJjm+cogt4trKX4gtDJAYDJJf
	 jHmGc5FVFXou6X+n8+JwGtRCJaBYqetIzL3MpDvOR945BwNtcMpMpf39YbBSP8KRCObGw2JshuAO
	 /gI9kcduWqVC/C3nTUhutMzDAN9d24g+8tHRhf3P27hOR/irl1LlfKD7zmbDOLw86fYklpbVo6Pe
	 8OR8K23gZ8mUkLvz6esiaIUvqkXoD349hTQ0/Lb7iMoNcw8aU=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Wang Jianjian <wangjianjian0@foxmail.com>
To: konishi.ryusuke@gmail.com,
	linux-nilfs@vger.kernel.org
Cc: Wang Jianjian <wangjianjian0@foxmail.com>
Subject: [PATCH 1/3] nilfs2: Add atime to support feature list
Date: Sun, 15 Nov 2026 09:35:58 +0800
X-OQ-MSGID: <20261115013600.123910-1-wangjianjian0@foxmail.com>
X-Mailer: git-send-email 2.47.3
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

Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
---
 include/linux/nilfs2_ondisk.h | 4 +++-
 lib/feature.c                 | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/nilfs2_ondisk.h b/include/linux/nilfs2_ondisk.h
index 27a6e57..68b1709 100644
--- a/include/linux/nilfs2_ondisk.h
+++ b/include/linux/nilfs2_ondisk.h
@@ -251,9 +251,11 @@ struct nilfs_super_block {
  * doesn't know about, it should refuse to mount the filesystem.
  */
 #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT	0x00000001ULL
+#define NILFS_FEATURE_COMPAT_RO_ATIME		0x00000002ULL
 
 #define NILFS_FEATURE_COMPAT_SUPP	0ULL
-#define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
+#define NILFS_FEATURE_COMPAT_RO_SUPP	(NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT |\
+					 NILFS_FEATURE_COMPAT_RO_ATIME)
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
 /*
diff --git a/lib/feature.c b/lib/feature.c
index ac45344..13bc3fb 100644
--- a/lib/feature.c
+++ b/lib/feature.c
@@ -61,6 +61,8 @@ static const struct nilfs_feature features[] = {
 	/* Read-only compat features */
 	{ NILFS_FEATURE_TYPE_COMPAT_RO,
 	  NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT, "block_count" },
+	{ NILFS_FEATURE_TYPE_COMPAT_RO,
+	  NILFS_FEATURE_COMPAT_RO_ATIME, "atime" },
 	/* Incompat features */
 	/* End */
 	{ 0, 0, NULL }
-- 
2.47.3

