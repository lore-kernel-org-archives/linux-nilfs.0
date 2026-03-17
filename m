Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD0C2EF652;
	Tue, 17 Mar 2026 08:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773736210; cv=none; b=bbRnjM+j2UbKfUzAunp3Cz/9jwjojQE0FpGN4VWlKV7nZRRMWmH+jKhsH6/2ovoytMWsXIOHVmP0TKIqUnPSDJbuAhdXXKzB6qzRVcDtIJW8X+IVLYuP7YOFrYg27UlSjimRjTZNxM7OAOF7XJFOMrXlQ3p/WPlwHNJqGwWENT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773736210; c=relaxed/simple;
	bh=D/llmGos/e+GxHSFX4FJvLp3tr5a/xQIJ6D2rvbzYMQ=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=DUMjLMJ37XhdkFgpfSCL8gc60uyU2pjCZcJ8MjBAeIIFsxdDyCyp56r/2y0FoNaD2XLaQUTkDW9bWe9r/SybEemGPe/TL3Zj/KHdQTskMq5x6L0qNGG7RVqjDb18k3MqRi64Yxc3X/oCYvEKp+2idTzpJRMYGTjQoTAmOsbHf18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=XeX9QpNK; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="XeX9QpNK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1773736195; bh=Ldr2L0fuMunzyvxzCND5l189lNABZjita0GvpSUT4vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeX9QpNKi/C75nIvv+bHpoAW37YFEsGcPowsqakDiihiM5s2+RZhvTuTTk2kmUtwE
	 olgBy0lKJt1b0jGkGnI0KpcxlfLy8zywrCVXNVxES1Fga6Y0xKEcHr7aDUWhHc8cH8
	 Sqe5UNh3GDpWY8px570TU+Z3VkFaiaTMM4ZlpLy0=
Received: from lxu-ped-host.. ([111.198.231.89])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 77480CD2; Tue, 17 Mar 2026 16:29:52 +0800
X-QQ-mid: xmsmtpt1773736192trs6b5d5f
Message-ID: <tencent_5E9ECE1B9E4B941B182565BAC2BB48336408@qq.com>
X-QQ-XMAILINFO: NAOky/E1C/NcBBO3VUstH+w8nRUaS2TRfRtFtV8W0ysv4JBfUyWc6FRr5HGG7j
	 npr7UmqngDuApMQHbQ+MF4wEyj1LyrTrisySstKjoPTNFUHBewr4Yc/7OhPH1MtgKmNaYeCwmL4l
	 Wtj6Jqr9UY0xogfxgXWkx8oz3w1QBXRt4L0Cf+mFp+Ke6OkQLf5yscz6VjM5ugAXswNY6sUEMuQl
	 GPQ2os7LvpASuBohC1xvc7WIahhECERNJY8o/uMhcVKZYZqXwZ/b8Ui+2h8gYMKgD41f41HkmNcM
	 jOjGXxI9T/8m5fGtzLRvvuVYBUXgrvoJeUL/eyHO+b27OwrDifulcit03uyeiGP4Stc5mwO7WZsb
	 Ixtz6h2ThUsYzMdBua36es7UCPGtCkiQkDmafqtQKPYPOmHy5gtEPvm7uG3/trajY9+nzhdf8IKT
	 CAAXh7HhTWB0NEEM3HDaKON6Dzjy+XyhnuilPZp8GpzXO0vOeasnLr2s7kTxn27oZK9PrNlcQy4T
	 nuxx9iMEdwITouovJl+DHTKqQxyxLRNMG2lC5cpzeeELiNUJHvj0E6u25bWeDieIPILbxcfU6JTf
	 BypzxetFboMeusBAwOmj2JjiO39qTbZC0rBXVjnE3ZgeqDyhuvFWnfDksz2xvT/Jzk+A0KXFYgz6
	 ZGDoO0LJDmsFxp76cX/KgGG9Z5K4Aj6GCrgtYRSUbn7r5lE7JFI8h89SHJYY3hW33ito1CoiK/Yd
	 yO98AIuu2cy0WAWvb2y24hJdc2Sxms4W4Vz7Qc5q5LpDR0mnFArFXELPeKROnXB8/XtL6HwK+Vw9
	 FCoOJYyXuADT/y8kJVp9mUgw+tVLx/ZfroblAQJQfvJb0C4lQf3CuxNhZxkUzg677e3M17o4HFi1
	 NMG1CJLncsq5XGARtvo040tprGDDnJMklivHitfKWXuVU5264y5/AW00T+vzRpnkzFKP1rxyswmf
	 ApZvY78NcsHtLSnoaDxrNPKnR7uFyLr7CZ7WceIeXhY/NkgGkC5XifaWV2lPsu2NNnS01URo6RHO
	 SGV6Y9IaT/TwIEF1+2
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
Cc: konishi.ryusuke@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: no longer save to shadow map if the num of members is too small
Date: Tue, 17 Mar 2026 16:29:53 +0800
X-OQ-MSGID: <20260317082952.184228-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <69b8c713.a00a0220.3b25d1.0029.GAE@google.com>
References: <69b8c713.a00a0220.3b25d1.0029.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The value of argv0.v_nmembs passed from userspace is 0. This prevents
nilfs_iget_for_gc() from being called to initialize the gcinode during
the execution of nilfs_ioctl_move_blocks(). Consequently, this triggers
a null-ptr-deref involving ii->i_assoc_inode within the subsequent call
sequence: nilfs_clean_segments()->nilfs_mdt_save_to_shadow_map() [1].

A check for argv[0].v_nmembs has been added to nilfs_clean_segments()
to prevent this potential null-ptr-deref of ii->i_assoc_inode.

[1]
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
Call Trace:
 nilfs_clean_segments+0x162/0xa50 fs/nilfs2/segment.c:2521
 nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:916 [inline]
 nilfs_ioctl+0x261f/0x2780 fs/nilfs2/ioctl.c:1346

Reported-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4b4093b1f24ad789bf37
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/nilfs2/segment.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 1491a4d4b1e1..7e0b24361d0b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2518,9 +2518,11 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 
 	nilfs_transaction_lock(sb, &ti, 1);
 
-	err = nilfs_mdt_save_to_shadow_map(nilfs->ns_dat);
-	if (unlikely(err))
-		goto out_unlock;
+	if (argv[0].v_nmembs > 0) {
+		err = nilfs_mdt_save_to_shadow_map(nilfs->ns_dat);
+		if (unlikely(err))
+			goto out_unlock;
+	}
 
 	err = nilfs_ioctl_prepare_clean_segments(nilfs, argv, kbufs);
 	if (unlikely(err)) {
-- 
2.43.0

