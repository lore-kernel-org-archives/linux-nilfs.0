Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794898290;
	b=eoi1ZycT6XVf6mO9rmbf9hhBrbz09x/j/YdFFhPX3zYoPl3rJVIi98BDMESqupzSK/7K
	 /x61xCLyCccN1FSAZkXinK8PA3csFQ5KPcX9MdsUNHTyZyL4BV3umtC7GW1oqgnMcyP6n
	 I2quWYFFtaDFs0pK5Y8ZF6gSxlPzFURzUsm4/5ZCa3PXJWPBPNWmKjYA+GimvygUhVor2
	 +vJQRwiV0BNM9X+PPQOMy4jSWd+NQr+Ikow1CqoxFkjBJNhyb8oFti1N4RVJp/BeZrpzN
	 k6n5XubCqZzVRLnyVc2KQnndsAFjZ2/mmvqISMRVRU/ZEnaNyXi9kwJ9pLw5GZUId9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794898290;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H7rBBGAWYyx/YFYo/54ustyS3rwja5fxSbKif0iz4Xg=;
	b=RHVkJaWyXr+pyb8WmnQwCUSb4ll5+xW+BAsfoUmIAdg/E4wA4HL2cejLXrVNLKGpI/rL
	 qrqEb8b97qZbzSa3edxjItYUWJNw/8Ly0fKNZz93v3hdxGnuuf5quGFvSd0/9DqXmAAqM
	 EP/jh+a25DKahy5ghlrB+IJjp0DhsgTMb6bugscmxWWDg23yFtWCFm5KA2yn8SpagC4VI
	 +Vy+ZxJULJCf5518mXsnve2f8ksv2eZ5/TP5vzQqwwXYEILs1q5fyEqmH+TVPGezANAnm
	 Wzt7SY7ONPNzxiFXsDvdE8OY8q1J9fMVDGNLpNGY4sTdyn/FEteFxDRi3IO4jausM+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=laLPAhJj;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D22606A332
	for <linux-nilfs@vger.kernel.org>; Tue, 17 Nov 2026 06:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84D22606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=laLPAhJj
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-36dbde64409so6305106eec.0
        for <linux-nilfs@vger.kernel.org>; Mon, 16 Nov 2026 22:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794898289; x=1795503089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H7rBBGAWYyx/YFYo/54ustyS3rwja5fxSbKif0iz4Xg=;
        b=laLPAhJj/HJqN+aoxjqsUhoEII4ZKM6F/f4iNTCjaDSi+LXBcv9tFE+le3r0s5q4xx
         99Cy1/KxBEGyyXKvLpA4X1eo+COL67UcS2dXkfn0UZ3VMQkN6hz0Uc3fAlidr4lefm+2
         f11MvjJiqXWL/TPTE6iMjSDOfOC9bcE9YRDZa1Q+/bPpKLvpupDD7pduNWoudVrGTQRf
         6UiNbgM03/+vcyVlIjF5F+ExVjjckoVHBzaZ60APBGKopdsYGGU8vONoMCQ22Ctej+gM
         gZo+ReNjWXYHDlFd3/CafjFWE8AWTd+ro13nCRJhfIysCtNi9N4HtQCHW2zjbvife2ss
         kZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794898289; x=1795503089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H7rBBGAWYyx/YFYo/54ustyS3rwja5fxSbKif0iz4Xg=;
        b=IjpUIEhNs7vsCbuCv4zu3JMl1NF3sCRh0O+1ep1XEYt1+XvMUeduLT8E8bCK7NCfag
         nztNdWiZN+b+HBsfgxndOCfTyFQVSn2PbE2vaIAZD/mk3WhOPwnROuvHX3qpJQXthRH2
         wBKmnbO6p//DxRGTVA5jBRbIBDKbBmYYT1CT4C8Y3B3EVoLb/O/5SKzlbsJM7waKtXAU
         W6CLoXekEUEMqtxBxFMCRQGpWVRDk325V9+ZFxwwoUUYHW9A1cYP2fUDKXN3IVOAwXyx
         dJp/GqQ8ES3utwMtV8RTLyn5syVNSIaa/E7FXOR3hWSLLTJF4rv3FGEszHC/kDsTpFUv
         EVjg==
X-Forwarded-Encrypted: i=1; AL+hErH2gGyf0bbQZSUE24ZlnhvJdmSsCwZH6bjjz//+WdHxlBtFYzgipd55i6E58Uqbteu0PZ+GqnQR9ssplA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/V4t2Mn0hhetBxRaWYVhtS3RPnEm6KF4SkSyBn5Cx/yr4O37At
	QekxjgBltcK2TdXn7SDiLprToiNguHQmp7IK91p7Dxw5sn0n+wWQg9uY
X-Gm-Gg: AZFdTZd8hcYyyzrRhxhQsmMrDjZAga5qmo69BVEEjXzPDEKYLhRXdH4clV/dZU4PNIR
	bBZeeVufflpmPmGr1Nndo2lEe9c/v4qVvjwh7X1WaoK53YYWd/8dDW1zeTcQ5zGWrSRWeU8cOq7
	SpHkeADxRiNeHwG+fjdSh+SSh2UGDwXQiykmaCtIpa5560m7I0nbete0ihtwlJgAzHuZhrKcmml
	GP1c0oAsoU5iJFVkupfTC0V7wXNTqOaJIcRsxifP/8U/nWoEqW4OCGTtv3kDgCcotXAcmInqj6n
	LxRunBmPbwKlE7HUiKIUIvaoXnNjbuI7oojkegQaL0AUZAQv24xoD8BOAbq8QhMnPe5At7L7mNx
	31tZI+hqFfSs5YQDf+WxzCFbgLeUoz7No+VpArnahctykH/2qyC2YMI8qdg5+I1HnSOT/vdQNza
	jd/AGCvphFx0i1EVstlQ7cfhtoYbQ7QM98U73fPNWgNAQeiM5bYv7OcLnDDAf8Od37Q3WFM7OFG
	ms8dKH3ZLDV/muKawoEHH5qBSunduJU4JpZqQrFoM2a2RwaeMaoIS/nO0AN7SXG1WrPxcOYvGLl
	vy58250XGqCse80kL6w1B8woOgBwFdmRQ1vBSL62G+l6+vD2dC3w0ok7hfvb8Q4=
X-Received: by 2002:a05:7300:6027:b0:360:e2e6:f849 with SMTP id 5a478bee46e88-37966e3b6c9mr13703517eec.28.1794898289262;
        Mon, 16 Nov 2026 22:51:29 -0800 (PST)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379565d269asm44099255eec.23.2026.11.16.22.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 22:51:27 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Wang Jianjian <wangjianjian0@foxmail.com>,
	linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] nilfs2: add atime compat_ro feature
Date: Tue, 17 Nov 2026 15:47:47 +0900
Message-ID: <20261117065122.41553-2-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261117065122.41553-1-konishi.ryusuke@gmail.com>
References: <20261117065122.41553-1-konishi.ryusuke@gmail.com>
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

From: Wang Jianjian <wangjianjian0@foxmail.com>

To prepare following atime support:
1. add read-only compat feature NILFS_FEATURE_COMPAT_RO_ATIME.
2. add the_nilfs.ns_feature_compat/compat_ro/incompat.

[ryusuke: added missing kernel-doc comments]

Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/super.c                  | 3 +++
 fs/nilfs2/the_nilfs.h              | 6 ++++++
 include/uapi/linux/nilfs2_ondisk.h | 4 +++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 2e3b591c117c..f92bcf1a9544 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -872,6 +872,9 @@ int nilfs_store_magic(struct super_block *sb,
 	nilfs->ns_resgid = le16_to_cpu(sbp->s_def_resgid);
 	nilfs->ns_interval = le32_to_cpu(sbp->s_c_interval);
 	nilfs->ns_watermark = le32_to_cpu(sbp->s_c_block_max);
+	nilfs->ns_feature_compat = le64_to_cpu(sbp->s_feature_compat);
+	nilfs->ns_feature_compat_ro = le64_to_cpu(sbp->s_feature_compat_ro);
+	nilfs->ns_feature_incompat = le64_to_cpu(sbp->s_feature_incompat);
 
 	return 0;
 }
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 4776a70f01ae..5143dbae5788 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -86,6 +86,9 @@ enum {
  * @ns_inode_size: size of on-disk inode
  * @ns_first_ino: first not-special inode number
  * @ns_crc_seed: seed value of CRC32 calculation
+ * @ns_feature_compat: compat feature flags
+ * @ns_feature_compat_ro: read-only compat feature flags
+ * @ns_feature_incompat: incompat feature flags
  * @ns_dev_kobj: /sys/fs/<nilfs>/<device>
  * @ns_dev_kobj_unregister: completion state
  * @ns_dev_subgroups: <device> subgroups pointer
@@ -178,6 +181,9 @@ struct the_nilfs {
 	int			ns_inode_size;
 	unsigned int		ns_first_ino;
 	u32			ns_crc_seed;
+	__u64			ns_feature_compat;
+	__u64			ns_feature_compat_ro;
+	__u64			ns_feature_incompat;
 
 	/* /sys/fs/<nilfs>/<device> */
 	struct kobject ns_dev_kobj;
diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
index b3442b16ff6a..19587700c92c 100644
--- a/include/uapi/linux/nilfs2_ondisk.h
+++ b/include/uapi/linux/nilfs2_ondisk.h
@@ -253,9 +253,11 @@ struct nilfs_super_block {
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
-- 
2.53.0

