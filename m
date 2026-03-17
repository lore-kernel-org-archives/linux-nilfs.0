Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C6319CC0C
	for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773738081; cv=none; b=GSfztEB3WKTBSTTXzzwPPh7ndN2i7P5mnmeRKZJHN4d41H5WQmA/0EIKQ9WgcCd4TuQy1tBUN66PCfPRE2OlodtQQPprN+2Wc9JX8umJACb0TIPOXg8VS7mSM8Jv26AH3652ln/nmH18yFGyiTlzKMShGcP2hRCjiK4HH/6r0KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773738081; c=relaxed/simple;
	bh=nN0x5g2DoAQ5Go7ldIH53w9Og235GSmjJ3oFV9XcwJE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LZAC2OAnATCIkIfzKGtSfY6V6aq2+1/a8p8DUcwhdKAFZkDH9PZtSRhppwSSBKJni/BEgHaCYTMrp+VCL6l0gtB3+Hi661S4feOx8xQAeI7mX09MDVcFbAwCWOuRnnKOWcG9Oa4EcphsWwy3EZIAY+bVBYteAfWeIH/BQzQ1tYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jQsWOAcF; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jQsWOAcF"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-354a18c48b5so5232854a91.1
        for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 02:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773738080; x=1774342880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=03sJZVwXZw+lbk50VCUYHq6xOlFCk2MSYpF/KKFvuBQ=;
        b=jQsWOAcFMlaUGcfKeZxW9aiwm9I827iokHfYf4lX4H7RO/qcasCyasYdV1Ap8nQdql
         APKU/tGoOm/+xmiBQpv6VIwDACQ0ykHQ1Ft8iYM3lcBR52mCEMFnMCatYrzZwjLJW1ck
         Uk+EZ0bLyWGthAEhbsJYC3f217aGdEIsgKiLDYFLqswCNn1dXFKeTbmmOjTh+9o/qHb4
         LL/+gpb6GRWYfkbbHy8QXL0j9ws0iKCTvpM6KaG5AhHJIPxqvJMVHjx/7wIc26mUyVRk
         pUJz6R7GENHSCQ0evo/5gZkpETmN7RskQU4pHKzH5sv4boCgHJ+oiPte19sn8kKFbZJe
         kTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773738080; x=1774342880;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=03sJZVwXZw+lbk50VCUYHq6xOlFCk2MSYpF/KKFvuBQ=;
        b=NcKhQqgHA9oLNkNYceRS08VS8ssN0SINuyX+88VlSHao8mRy2kXz43HVoZdloXa+GC
         YO/FtznJK3ZSjZ8sY4agcAUmrHfzujlSaHhB3E8073XLOKj7rHaMXqsDJS3VO2BeozBW
         OXTzurgCL+SMFmSZSV8VVkbT0DfQX5NrQMqUDJehiOwmlipUJMlyOIsy3jA3FR+3XP5G
         2ndkitYPgFF6GwOivnH/Q/IAk7QSBkgt3vveFK7RCR39RfIh8s/OR23gaownPQKTXecb
         Bz1RWH5TGPqI0liifDkTDMtLfV5+GYDP4viyO2KgBu1+j8+s8Pir/tMI2ldX3bdU5UoN
         0gvQ==
X-Gm-Message-State: AOJu0Yzh8JOKg3DAZnfcQB9M01k1OB/XUG0n6ajNtx5ZrPdecqq+Y9RC
	ni/OfTR6P8sHQJTZuepGSxUZ+oFdlU75mcSWzKaRkG6TtQjr/VIU5fPu
X-Gm-Gg: ATEYQzxkLYckXG4wALStyiiTcTGyOHYAmS/r/uDJS/fzwHazZxnuO6FwdXAfN6UBBHv
	PUQ3SpsJhgldU7g/tZAEdbXXPKf0NJnwrTX8k5EJvd07eyVlDjx8EBvc54wuTjv3eKlaTngH24P
	NqbNnskiFpZu0VTq+Jw9lVeFCwC8kOctHYzZNoollkzeCQV2lBwPsTMEUhS1usDrqX8MzGs37RD
	DFjSZGnhVZ/ygk9jxC0Ca9wKa7k8o2NopwUG9FjR1+/Z6N4SZ9FHD64FLebETOCUVkEqrgx1MOJ
	k9zKPtsuud7dxOoaMa2iP6vhfmaZfkCk0YQLk1NbVvzLuVNm/Bkkn7BHQbGsl8KRWJH9Jdi1Twv
	uMdazEraH8dedtHjDPbCglyoLMNlmjzOe3vO/ywCC5609PLBQG08J1MBWxJe8ttHrW0T/ovduwQ
	DMF4GMI1d8G1MacbsuOXPJG2QebLg5htZ4mgI+x9v/AKGwWH8ULJ75nz8buzCUckQIxrd7K3GLf
	nTo5StMP4tYpf2hPQ==
X-Received: by 2002:a17:90b:498b:b0:356:2c7b:c026 with SMTP id 98e67ed59e1d1-35a220576d7mr14769359a91.23.1773738079328;
        Tue, 17 Mar 2026 02:01:19 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:8eb7:8452:540b:880a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bada2bc3esm2796850a91.1.2026.03.17.02.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 02:01:18 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com,
	akpm@linux-foundation.org
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH] nilfs2: fix NULL i_assoc_inode dereference in nilfs_mdt_save_to_shadow_map
Date: Tue, 17 Mar 2026 14:31:09 +0530
Message-ID: <20260317090109.878401-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


The DAT inode's btree node cache (i_assoc_inode) is initialized lazily
during btree operations. However, nilfs_mdt_save_to_shadow_map()
assumes i_assoc_inode is already initialized when copying dirty pages
to the shadow map during GC.

If NILFS_IOCTL_CLEAN_SEGMENTS is called immediately after mount before
any btree operation has occurred on the DAT inode, i_assoc_inode is
NULL leading to a general protection fault.

Fix this by calling nilfs_attach_btree_node_cache() on the DAT inode
in nilfs_dat_read() at mount time, ensuring i_assoc_inode is always
initialized before any GC operation can use it.

Reported-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4b4093b1f24ad789bf37
Tested-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
Fixes: e897be17a441 ("nilfs2: fix lockdep warnings in page operations for btree nodes")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
---
 fs/nilfs2/dat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 674380837ab9..888dc1831c86 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -524,6 +524,9 @@ int nilfs_dat_read(struct super_block *sb, size_t entry_size,
 	if (err)
 		goto failed;
 
+	err = nilfs_attach_btree_node_cache(dat);
+	if (err)
+		goto failed;
 	err = nilfs_read_inode_common(dat, raw_inode);
 	if (err)
 		goto failed;
-- 
2.43.0

