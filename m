Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.236
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794706414;
	b=iEl/KkENtc7DBZZ+D3uzp+9FTiTV0l6sXv/1d4brQkH92GgD+4teApJJAZlEa1fsSg6J
	 ZkX11TBH/gZ8jHMWFUbhbWe1KXJUybtZI2FVj0/Afjz4bw93KrRc1bd9Y0y/c5RpCRAx4
	 4tKUVqm6u65NU2EXm+xt7cUdc3xS/BqfRKr3eEUb/C8LR0w2ByMEJACkMBg9+jmvhUItV
	 2lyXLBnR5ecL/FhDaNMJmUyt6ZhBYLdtR7eWyy74TGla3JBmCiY0SaECsKv+Nlc3DGPVK
	 aReSGW44WOgGHArvYTrLKe//vn9YzaMC2D6+o2MTMY34IyFJLYVkLpcyvucLzI+NhtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794706414;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=pLCPYEj6a2+/+vsSAhzPrTk+vl3QUgYLd5YGo87M8w4=;
	b=k835HspxAgzIb3MpHSBiiV7gGG0CBAkVJeOW5Vm/q228wZ1u7s5hG7yo+YIPqMHJetVk
	 H6R1CRtHj9PswEpTbtTE4498+h9oc0jK7wwKHt3Xg356TlPPh3MygMWrTL0Xh5FqFkBSp
	 7SxsixxAi7DU1g5v3m96Lm3cqyzifAadqqUOHNlsbukpUEDxmWdBiX5nyMeTmF+WFnfGx
	 mBYKu40I6m79gdTsj+716qwaac5I1ezSXF3cBTz5RXFPa5XIki7KhpeA1SJ44vO3xtJJZ
	 xqXuTYivsMbrC0nSnIexmkQ6Yn1DgP6NBzHZ9FseM9EdLx8PiGr2h0HK4wL8S+axTAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=foxmail.com;
	spf=pass smtp.mailfrom=foxmail.com;
	dkim=pass header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=RON935lO;
	arc=none smtp.remote-ip=203.205.221.236
Received: from out203-205-221-236.mail.qq.com (out203-205-221-236.mail.qq.com [203.205.221.236])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC823606A323
	for <linux-nilfs@vger.kernel.org>; Sun, 15 Nov 2026 01:33:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC823606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=RON935lO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1794706409;
	bh=pLCPYEj6a2+/+vsSAhzPrTk+vl3QUgYLd5YGo87M8w4=;
	h=From:To:Cc:Subject:Date;
	b=RON935lO/t+jahJLX6qsTungryMSYlw97TsUl+nDjc2HaNqHFA1Q1Z5l+Fyjp5KfQ
	 04ZisyLkk29/DT9c67ib/xHJDSVjAbzPEAQYQl70HOAWJDO/akUjwUQQ4mf/CnguAY
	 7sgO4cIMNt1BlLj57h+CqPIa6easu2uViKXhPlSw=
Received: from localhost.localdomain ([2409:8a00:2545:bef4:c8bc:9cd1:4eaa:3])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 85BB5C45; Sun, 15 Nov 2026 09:33:27 +0800
X-QQ-mid: xmsmtpt1794706407tj9jz6lcg
Message-ID: <tencent_E3847A19056D4E914FACD269A3C77BAF0905@qq.com>
X-QQ-XMAILINFO: OWaeKR31G3nej2aEh15Kh3EgpGrqzTeBmff0PpJ4bao1fJSmkoHHXRX4Brd8dY
	 NmbGEA7Iy/gzsvuSsEjBYAB7M0O4nXRu7q5zJIGUg549raBf3AwzRGr1NtXKr+vvZnc7w7vZVzcb
	 q8fkn6Kt2orDoGnIQu7WfF/b0Ea0wecjsymHUKWaVxc6OSL/MBL+DvtDQmFE2R4z10/a0E8pQK9x
	 4jR53oiIBG2OVGDeWP5NaiYrob13NdeDycp6yJ7LJl4L6AnfoYcdx4eww18TRPi568fcgqF2CK8x
	 /DR7kXw4U8JSYK3VEbpss39r97w7c2ZiGCJ+hynW2POeICGj9pZbM03ox7kk/uazK9gG2QMiSX7M
	 fq8ayok61FAKkAm32PYFH/kR1+sBCHH9z4lU9pf3UsTU0P3PaU4xBwJ+kCXpo1OG6S0C3Bc7h/wo
	 zePxrz6lji7R3WKGoKKb83KXIAlHEGnR3le6seVNeqaXMrSuq7OqFthtUP7sD2URUxB1wd3WeOOB
	 vDUyj3yr0dmOczcwQ07f7l2Spf7zXSNLEJbciqDuAm2sw9Aq1C53MTWMLVCUcC2odu6EN9iIzMK/
	 ClUba49JTqj8GJBXzuxMXa9/CQOIHFk6Jjt8A2dBBSST9foQ2iWdNIsrbXX/xBJVC7Sh1TyYpA9Y
	 ljSOEqvNqs3B1eF0GzunqOKhuMy17BiT1HAlYWCxgTsh4igEI/ua1bG39Su+y5j+8vHz4yymD4h7
	 nIy1aMLpKgHIcYsxjxun+klyLWa9UeJBDHpqCKlDWYGeGSn7IP0Uc85a9jNZX5NqGOf0ysNecucm
	 TO7f76cOYCq+x1k6lWtJbhvk2LH+M1o3MW3KVmBPlhveM2qy/CeLCzYaWCPrfjhbnSgLpGph4Qb2
	 uxnkHNMNocHAsIXxpfG2wOy02Pk1Hsmqx1RVQ0GTQo4jzPWtnIZKIx+7KJdDjoT2U320azKvOzee
	 CMTIKGWPPpO23eWnMa6zLhUOIY8BTX7M3c6PRLu42s04esj4U/q3yLXaaVrI14/NLhwMbHl0cjAl
	 UzwsONzrGK/GI2op2Cf06dEcabHqpyzfLs5uVvtpwFOWi+fr/YFphfzjk338+E9DnU4DhKhgRMrB
	 EUw4N7mZ3V4CEZ8U047JwZJoiKHGYmAV6axKgJj6JcVUQ4R4igqi5by8Y5936Y8WVGG2S/
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Wang Jianjian <wangjianjian0@foxmail.com>
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com,
	linux-nilfs@vger.kernel.org
Cc: Wang Jianjian <wangjianjian0@foxmail.com>
Subject: [PATCH v2 1/2] nilfs2: add compat_ro feature atime
Date: Sun, 15 Nov 2026 09:33:27 +0800
X-OQ-MSGID: <20261115013328.123821-1-wangjianjian0@foxmail.com>
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

To prepare following atime support:
1. add read-only compat feature NILFS_FEATURE_COMPAT_RO_ATIME.
2. add the_nilfs.ns_feature_compat/compat_ro/incompat.

Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
---
 fs/nilfs2/super.c                  | 3 +++
 fs/nilfs2/the_nilfs.h              | 3 +++
 include/uapi/linux/nilfs2_ondisk.h | 4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

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
index 4776a70f01ae..cb54875d2350 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -178,6 +178,9 @@ struct the_nilfs {
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
2.47.3

