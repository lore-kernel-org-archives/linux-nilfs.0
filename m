Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.221
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794706565;
	b=XdobJ5sDgeWFkn2QmOIfKpV9UHBGbcpUNAYHb16aZHpYN4gMf/XxJGPOA4WmvaZxQoED
	 oNkojCOFiCI2z+tdkHqZqud8dRZQ/zsPA2Zgf5t1/qT+W47kj9VN1cDa9RCMY2hES7HMD
	 tehm0yLvTqrFLhpAOzuw/xxdExPDRzt3qg5ibbRXXbIqtZ9mdG/zGmMfBWEf94ZdO7gIz
	 pWe+vhYXgxygdbRUQAtVONYS3oswOvW7xSmwgNUPBzGlvBDcbqvz+L5ZWawKqMKC7Dkr+
	 8g8YqHqpMb8rFRQ0EF07gjgrL2z+fAVj3cADr4wagIziy3DCPHXpQzY6MvRHuAezDOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794706565;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=U9qpgRy4eXnqw2Um38ISACFhw/3ihYsf5U7SWR/9A/M=;
	b=C0/Bd0LAYuVTfPnZiew17HQq2I+f4wdcylM5iGE9lBcRcPzobUXd7fzi9FlxZoIW/WQP
	 7pB1O46CqJj0TlH33rSJyIKl3Qf/WQP9eo3m0Yrpm9bK5DFn7y/mfwUns4a9kao3UrhPg
	 h8QzPJQsXfYbllYcTZmMjoLxS3yER5IJXaM0eXU2KSqZCoakqTbIxdhT5LMkQHc8qE3wU
	 gcaxGyiEfqZdioQ+TaNfbGrNWwRccpkLng6XHQUzGE44rBGelbYlGrBLBjmlM9cO4L879
	 KAMTKLRXcwD5BYsilF2X9ckACfWYVjX6dShFH0U3n/0O6xxtg2znm5MFeNeuDzn1njw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=foxmail.com;
	spf=pass smtp.mailfrom=foxmail.com;
	dkim=pass header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=DZaRbi4s;
	arc=none smtp.remote-ip=203.205.221.221
Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B2A606A329
	for <linux-nilfs@vger.kernel.org>; Sun, 15 Nov 2026 01:36:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49B2A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=DZaRbi4s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1794706562;
	bh=U9qpgRy4eXnqw2Um38ISACFhw/3ihYsf5U7SWR/9A/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZaRbi4snPxUguDVyT6A708zm25sfsCV3PsgNz5Y0Lyd+lc8wQ9Jo0OEL4o5QhDO7
	 aCmeP5wreCSz4odlYRNRT4BTk/RHUzBqMS4S6JbApVXF3IyFvmbnF7jK+MDoIUlwZ1
	 puuSlCSnvOZ4py+47IoJ9bcg214K3h6LUv7qwdH0=
Received: from localhost.localdomain ([2409:8a00:2545:bef4:c8bc:9cd1:4eaa:3])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 8FAB0A63; Sun, 15 Nov 2026 09:35:58 +0800
X-QQ-mid: xmsmtpt1794706560tfyp6b0vx
Message-ID: <tencent_F4720D9A9922A5D89193704FC7DE27C8F806@qq.com>
X-QQ-XMAILINFO: MRMtjO3A6C9Xibn/gGhJ0mezRBlCa+cqR3MUsta45NckHpc2UdbvF1ftdqeDYO
	 JqcU0fsCcTo+WG/ySkDiXzoCW9ozAgpRatynIeK1L8JF+Tb3W9mMjkZiLSPcpUSnKs2rjD4lxopA
	 mxocSGJeXtkfcQzeqW+tlkbc0RMtYpqRv7Gi1mFdUtTVqF4LdIhaEY8BdggQoInHu8xRA6pRBR9B
	 X7isZPZv8q6oIrzdLgKHrClaaSr5fh/2xz7ll2MdEBbGaxjDNUGjDyYNfsC3JZAFmukaEC58MAxQ
	 +cqo9R42iqb2zXvEYSccBbwUo4A/k8OOOqBctqz4iwBaSNz4AoSIfJdwhCXI4OHPWUbQ1gLxpKFh
	 Km05Vu1UV2pl+EKM39k2OzR4S0/dMoNRnTjWpp2OWlNhhmwnS70kEl3W29fB+voaSDFxIgXEssir
	 zkWbVZEL6zA98hI5Ixt0bQzAk5KDTyy7aPXdjUGgJuPKx6swWW1t+bH2eHugY9OUEVAy5P57yOUd
	 A90u/2DmiexTwfzT0mJXxtlwV610usw99MIr9X7JIejLL6pTqyPyfeUNp/FnSWQ0cLrySq3A9t5Z
	 kem/OBG0QtxIWUIIMHZ+7rugcQvsQNys+p7O7autIeCUtnjzceLZ+5vxLurFHBHTVAw3k/n4hNHv
	 sBZpVAPFWDfnhYsxA/1vhra7ZmvYCOAdtktOD7XsccTdU20vkci+DhKlQ2lLpyNmIiqTbzq8Afsy
	 a/BbzFuXf6osti33YjKmZVd58csEFyIWqvqCIkA+ILG9gEkc2y3miPk37mYRzx3qWSbGcIxqQOEG
	 6ibBg+Gg52LlUVZuF/UOFV05D9nQZ8wtN4d7MwfQFg7KPh9cJnqFN4GIZ1EF8bokYL8a4BE0giiV
	 b41xFWuCxawMqIJcFGyqmn6qVPGYAsqVerlGgu9emy8vyDhfhOW0xrRqCK2qpprfdCE6U+5d2nU+
	 zUVcLmip5iCm+sl3CN77bu53eVDDbieLSuVl5BngMLVoUMZk6vJegV7upgso6m8Ify0MTFkGxNCm
	 Aw8J+k7CgOOB99NL9IELFXzs0dc9HZg5ey/zq3M+vzV6DjKsLgQtlZRntpSv14OmTF0F3jXLYS7T
	 PIDC7bux48v1SV3uL1o/83XafIpn/c/7TNcJimUS+84Z4QvX8=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Wang Jianjian <wangjianjian0@foxmail.com>
To: konishi.ryusuke@gmail.com,
	linux-nilfs@vger.kernel.org
Cc: Wang Jianjian <wangjianjian0@foxmail.com>
Subject: [PATCH 2/3] nilfs-tune: add atime support
Date: Sun, 15 Nov 2026 09:35:59 +0800
X-OQ-MSGID: <20261115013600.123910-2-wangjianjian0@foxmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115013600.123910-1-wangjianjian0@foxmail.com>
References: <20261115013600.123910-1-wangjianjian0@foxmail.com>
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
 sbin/nilfs-tune.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/sbin/nilfs-tune.c b/sbin/nilfs-tune.c
index e2384fc..598bdce 100644
--- a/sbin/nilfs-tune.c
+++ b/sbin/nilfs-tune.c
@@ -101,7 +101,7 @@ static const uint64_t ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
 	0,
 	/* Read-only compat */
-	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
+	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT | NILFS_FEATURE_COMPAT_RO_ATIME,
 	/* Incompat */
 	0
 };
@@ -110,7 +110,7 @@ static const uint64_t clear_ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
 	0,
 	/* Read-only compat */
-	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
+	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT | NILFS_FEATURE_COMPAT_RO_ATIME,
 	/* Incompat */
 	0
 };
@@ -485,21 +485,44 @@ static void show_nilfs_sb(struct nilfs_super_block *sbp)
 	       le16_to_cpu(sbp->s_bytes));
 }
 
+#define ATIME_ON_PROMPT "When enabling (OFF -> ON): Existing files will "	\
+			"expose the epoch date (1970-01-01) as their atime."
+#define ATIME_OFF_PROMPT "When disabling (ON -> OFF): Newly allocated inode "	\
+			 "blocks on older kernels will have their atime set "	\
+			 "to the epoch date, causing inconsistent behavior."
+static int prompt_feature_set(const char *msg)
+{
+	int c;
+
+	puts(msg);
+	puts("Do you wish to proceed (y/N)? ");
+	return ((c = getchar()) == 'y' || c == 'Y') ? 0 : -1;
+}
+
 static int update_feature_set(struct nilfs_super_block *sbp,
 			      struct nilfs_tune_options *opts)
 {
 	uint64_t features[NILFS_MAX_FEATURE_TYPES];
+	uint64_t old_features[NILFS_MAX_FEATURE_TYPES];
 	uint64_t bad_mask;
 	int bad_type;
 	int ret;
 
 	features[NILFS_FEATURE_TYPE_COMPAT] =
+	old_features[NILFS_FEATURE_TYPE_COMPAT] =
 		le64_to_cpu(sbp->s_feature_compat);
 	features[NILFS_FEATURE_TYPE_COMPAT_RO] =
+	old_features[NILFS_FEATURE_TYPE_COMPAT_RO] =
 		le64_to_cpu(sbp->s_feature_compat_ro);
 	features[NILFS_FEATURE_TYPE_INCOMPAT] =
+	old_features[NILFS_FEATURE_TYPE_INCOMPAT] =
 		le64_to_cpu(sbp->s_feature_incompat);
 
+#define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
+				 (features[(type)] & (mask)))
+#define FEATURE_OFF(type, mask) ((old_features[(type)] & (mask)) && \
+				 !(features[(type)] & (mask)))
+
 	assert(opts->fs_features != NULL);
 	ret = nilfs_edit_feature(opts->fs_features, features, ok_features,
 				 clear_ok_features, &bad_type, &bad_mask);
@@ -515,6 +538,16 @@ static int update_feature_set(struct nilfs_super_block *sbp,
 			      nilfs_feature2string(bad_type, bad_mask));
 		}
 	} else {
+		if (FEATURE_ON(NILFS_FEATURE_TYPE_COMPAT_RO,
+			       NILFS_FEATURE_COMPAT_RO_ATIME) &&
+		    prompt_feature_set(ATIME_ON_PROMPT) < 0)
+				return -1;
+
+		if (FEATURE_OFF(NILFS_FEATURE_TYPE_COMPAT_RO,
+				NILFS_FEATURE_COMPAT_RO_ATIME) &&
+		    prompt_feature_set(ATIME_OFF_PROMPT) < 0)
+				return -1;
+
 		sbp->s_feature_compat =
 			cpu_to_le64(features[NILFS_FEATURE_TYPE_COMPAT]);
 		sbp->s_feature_compat_ro =
-- 
2.47.3

