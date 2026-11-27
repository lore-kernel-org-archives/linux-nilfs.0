Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795754572;
	b=gjzsrZAzO4rpj3Ac9A1dDf1pMrRE29/VQ09D4+xu2VNToSXcrXME6wmXWPQPVZWxu6Qg
	 sDBf+fJfsiUEHI1/TaFUzj/hCkafwAFU+BgOpG/q+X4cv5yyBizVuaodXAgJtatSiPPsW
	 s6t6RawrxAGe8+bn9Hgy2dyZk/zMS4txMBGfkju1Y9eaMtvbKqok+almkxzh3W2IzPP3M
	 a+aWi+ZbtQuTk7egaiN1LV9MkTLzJZdbeZK5lfeAQL8h2KMt3kPi1Mpgmc/3goWOCeLny
	 Yd7yfOqj43XhZuY92ovu4jrNziP3u0AYJKoPSC+RhsGLYN+X3TuVd6BbWxLjM1KWiZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795754572;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bMPrUEvOOl42HBlWFfjw5Fxko7mbQZcBgF1FR/Z2T+s=;
	b=LUwzvQ5giaOIRssj1g2bATl3xuRH6bVsuJIt8jO4KAbc8p2bkDIQp56WC4r32yq5dRYk
	 4mjjFu6wDvWiV4Tx/jU5uYbpzC0AvRG/pr4s8cS+A9TQLXXihnswxwRMbKsCLKeNiXCXC
	 ffF5jSLgkQS8T+cmcI1Hmj0ybEsBrcl+kLpx9iJ+62OaDKTKNSr4Bd2CUWd9kAhuVIRL+
	 SEbAII4mRh7butXjFkBQzARtwc2hoIwnH3E8Mx38uD3uGzp2dNTL5cQZ79T0Jtszkslub
	 a6MUfWOKEEsaq7G4kn1CrnSpuV2q2iBE7u2wJvJzKbzfYnVLV3HgC0/KPNrg0sH2XWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rXJr6Vxl;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A066606A6B8
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Nov 2026 04:42:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A066606A6B8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rXJr6Vxl
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1b50a4bd2f3so6616147c88.1
        for <linux-nilfs@vger.kernel.org>; Thu, 26 Nov 2026 20:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795754568; x=1796359368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bMPrUEvOOl42HBlWFfjw5Fxko7mbQZcBgF1FR/Z2T+s=;
        b=rXJr6VxlyGpQqx8xuOAVZyMRvo3s6fgWg2buV2B+Gd5Zu+lsaluBTKSgRyyMI7hkqn
         AjbeRzNlcL9q5/EdS+271gqmJV2MndDsvEkhhxLyCe0vpK7xFVk3BhqEuVUGoz9Fpyhk
         6dN0dGnA8Yozr01j9vZXxCYh2qGhUZk6vjEMmKl63V70TsZ/JteN6q9ZXiikblpllJuF
         t0a0EXXYngM5vm7V+IXyMo/+NxAvpjOtiNzwoHfGJ2eLgaQzmF9HGA5cyJKNItdfQY15
         4GZiC+FYHWS8gfg8vJ+pdl9qrlQ/N8EiiYMVzs/7KcWyNq4rgzf/HAuDdzLFS82XibYT
         XgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795754568; x=1796359368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bMPrUEvOOl42HBlWFfjw5Fxko7mbQZcBgF1FR/Z2T+s=;
        b=0xv+qNFexA0OI46PpiW9l/IVhZVPeRCNnZ1PDd+y2Z2toFX/CmoOfw72XcP8v4XeR5
         KzCRRUdNaxeeY1A+9Hr0j0T+R1JTFdw/xpTkMH/PgrDgoPlHnT8VlMjTn2+WnuILDMR4
         uq9cDcrClOqhCLYHgqLWGeD5KFw570VrwhNPf9u728DF80mPz6elLdfr31g/tG7dG/nk
         5yXfkT51ewWEQVhbkENSM3U31mI3maGe217PjDi9CkXskhUqkBsl2cLJKPDr2BPGg/x0
         ZYUEw/bDvygKaHPz6IrO9b0UyLfXRdQn1GbLdhMbWUQpYf4YB6y8YpOvbtHJBcyBIseh
         G+AA==
X-Forwarded-Encrypted: i=1; AL+hErHOt/yTelYXiNCNwSqQHFtFnXU7lHIXGjKOxbAhyn9ZSJ24lqlldseZmhLNfbgu4eJEGXR33BW2Fb5vEw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+dxqtgzz7QW/sSUVX1B1XKgxaLB+JKevwnDGnbn54ajHHiEZiq
	vP2tQvHTxJkxF163qznCdGl796lVU7reL5E2tULXO1BaP+SkxK+w90Vk
X-Gm-Gg: AZFdTZckpk09tpQBiDLMXvz4BtfDl9xealdSXOE+90EG3gGEd9X2n+5sg0hztDkgn7Q
	dM2DgVSg+dNakIoeUEvgdjhYyUVjpsTDDhMGfYvCOCfjPOYeOSMhb0KZlzmM0XnsDVImOMLnPya
	n6ygTaTCfSALND+JcXtaYtsjlyvJjxHuKhwYliQlrSqpCb/aNHlMLENFItx649EDbKUjnteOY3D
	5FJzhW0Y3kquCVUQO6b7QGM1DUHjT57sqIkQKmPVj/VcXNtGip4xX2kbR+rIwpCrffAsDoi3Sdx
	f53GUYeg159MPwhl5kA2e9HERK8diHLUqCBVtVtp3kkRZJDhXoq5hgNPyhJxTS4BIQZLLTkoNpS
	eFJSyeVGWFP4qk/ELNz2xRv95/yxDHJBd74alVObRz+InitMTuJ4+qSvGCpWmX3zapdtp3kIU9B
	xzKp8gNn0y2kqDdEWC5RJNso1Zzp6khJLGTZ5vRCnTEv5KY5Jw1RGl8pql1MjXalGSq3/YjdIMC
	QoniAtHPHx05tekkeTGRWAjFao4QfUsOYnB85ritIN3nMPJI/1n03vjvaRLNUJXdvZqDvzXNgTg
	XQaw65goxlIOuIhKHwQ9NaAzYD4LBtetgda9OE9P0WIpK4ecCRzpxSAjpOwvmk8=
X-Received: by 2002:a05:7022:290:b0:1b5:283:79c8 with SMTP id a92af1059eb24-1b5567a6eb4mr22486826c88.4.1795754568445;
        Thu, 26 Nov 2026 20:42:48 -0800 (PST)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556829d31sm88000388c88.9.2026.11.26.20.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:42:47 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Wang Jianjian <wangjianjian3@huawei.com>,
	linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Zheng Zheng <fengaojigui88@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>
Subject: [PATCH 5/8] nilfs2: save DAT entry blocks to shadow mapping before freeing
Date: Fri, 27 Nov 2026 13:40:58 +0900
Message-ID: <20261127044231.37630-6-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127044231.37630-1-konishi.ryusuke@gmail.com>
References: <20261127044231.37630-1-konishi.ryusuke@gmail.com>
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

In preparation for restoring removed DAT entries when GC is aborted,
modify nilfs_dat_freev() to freeze the buffer heads of target DAT entry
blocks before freeing virtual block numbers, saving their original
contents in the shadow mapping.

Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/dat.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index d2718944368b..b4156945e433 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -11,6 +11,7 @@
 #include <linux/buffer_head.h>
 #include <linux/string.h>
 #include <linux/errno.h>
+#include <linux/math64.h>
 #include "nilfs.h"
 #include "mdt.h"
 #include "alloc.h"
@@ -306,11 +307,48 @@ int nilfs_dat_mark_dirty(struct inode *dat, __u64 vblocknr)
  * Return: 0 on success, or one of the following negative error codes on
  * failure:
  * * %-EIO	- I/O error (including metadata corruption).
- * * %-ENOENT	- The virtual block number have not been allocated.
+ * * %-ENOENT	- An unallocated management block was found.
  * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
 {
+	unsigned long entries_per_block = NILFS_MDT(dat)->mi_entries_per_block;
+	struct buffer_head *entry_bh = NULL;
+	__u64 start_vblocknr = 0, end_vblocknr = 0;
+	u64 rem;
+	size_t i;
+	int ret;
+
+	/* Save the DAT entries to the shadow mapping before removal */
+	for (i = 0; i < nitems; i++) {
+		if (entry_bh && vblocknrs[i] >= start_vblocknr &&
+			vblocknrs[i] < end_vblocknr)
+			continue;
+
+		brelse(entry_bh);
+		entry_bh = NULL;
+
+		ret = nilfs_palloc_get_entry_block(dat, vblocknrs[i], 0,
+						&entry_bh);
+		if (unlikely(ret < 0)) {
+			if (ret != -ENOENT)
+				return ret;
+			continue;
+		}
+		if (!buffer_nilfs_redirected(entry_bh)) {
+			ret = nilfs_mdt_freeze_buffer(dat, entry_bh);
+			if (unlikely(ret < 0)) {
+				brelse(entry_bh);
+				return ret;
+			}
+		}
+
+		div64_u64_rem(vblocknrs[i], entries_per_block, &rem);
+		start_vblocknr = vblocknrs[i] - rem;
+		end_vblocknr = start_vblocknr + entries_per_block;
+	}
+	brelse(entry_bh);
+
 	return nilfs_palloc_freev(dat, vblocknrs, nitems);
 }
 
-- 
2.53.0

