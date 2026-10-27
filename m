Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138320;
	b=vnThVefZFt572pi0NWKCXDoI/JaCXmc+xoHx6JlDUtkatBpIkAF9f7HcvI3S4E1pG5Qs
	 k8cRVSI8RkKscul5InDZcagCFb+URgulXk79e80BPEGhx332Nl9B14dQeK7y2MhLJDLtS
	 3U+lp4bv3+owl+KdgfHwRIHDSUDJ4+vShVkvfhhA9eVhammLXFssRkW/TPXAo1HBjyAzw
	 GCGO2VWDNwkhPSSy0N985+Rm0g7vGD86xKuHVejnV29PMaCzkK96UTk13iY2wnc1PIbEf
	 PTLgvLJNmOkfMfD1UdjEegITMsM4XKLbpSmlVbMuMiQTH+QVKM2cNdOUE9hWcJAZraQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138320;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=43G9CXaG7qSF4UFTj5k8Ql+kaR9Fc0A0Kgr5LG/j+HQ=;
	b=bkAWImDLWbRcZucJYArTiKf9cHJf0H29A4gff5shJtnb1CgO2WQU1lmsRnJLK31oh8qx
	 LCdUNKGuydxmyvBqNE4Y9Me9bminU+cranNglvjDX0+C5eUZJPWrz/LIaLZa94D4t+ihE
	 zRynxco04+NCiRoWaMY5yPDcjsYC0+TyMWRA2v1e09ZXq604nKG++Q+/DaRYCBtbNuIHi
	 b3giPIoLEH4dKFhw/tun+oHwDHlLU+N6CkYARVGMSgMl9cxR0QksOSWee/C3f0EJgn9Ap
	 dycwlzYvln8eLG5VPGfBZWun0MC5xNqBS4gFS9pKbSRkgw9ECkfkt3ELgFrcVy/Rv1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0JoWngSl;
	arc=none smtp.remote-ip=209.85.128.174
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B0A606A326
	for <linux-nilfs@vger.kernel.org>; Tue, 27 Oct 2026 21:58:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78B0A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0JoWngSl
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b118bea471so2484847b3.0
        for <linux-nilfs@vger.kernel.org>; Tue, 27 Oct 2026 14:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138319; x=1793743119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=43G9CXaG7qSF4UFTj5k8Ql+kaR9Fc0A0Kgr5LG/j+HQ=;
        b=0JoWngSl/7Wd4baloUpWZfgYNcJsVWiereAE7th7R2Ip+sXgtUEhPJO1hjFXHapzbR
         yPAtjz+ezQBhpAMDxbiS6NCatGfpLLaiWx3O1DQmpz0O86H1LD/XTr04UMKmlmbO/Vo9
         4xfaa0gGx4eWPRM/ewD4WBEPFHsEj5k8P9e9oSmnQTcm+8DivDfjUd7A5oR3TGka4RC1
         vJv+hHOEGLK5VpjdEhPVM/J2fOv+egtjbFUGk7eBJREyknkrXfZnUtf7klqTWt0ENeiz
         xUBRXMjgnVeAVE6Dbu/WEYJzXgstdrpDAg+ijV1WUiyayiW32T30xxd0cGoPgh6z5wgq
         Ns4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138319; x=1793743119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=43G9CXaG7qSF4UFTj5k8Ql+kaR9Fc0A0Kgr5LG/j+HQ=;
        b=kLmRJMkHSpLYn7770+/XqXSsz9BDWXqPx6/oLA+Yf2vyoFxe0h3tl2SFIyAuZgsTVz
         WuHsjtPiA4wRdwAFrDNkXug3lIBa/z5kdA1t9eNwI8AK+uYN/74QEfyFpxqUH0xKTjYZ
         FXpaXyhTdvLbRXfri2uwCVJ425fHybfKsFeMk1jS944d1RCBujS1/CfCP7mI8w1Jf92v
         tveYP28oXaybF7tvDbMDkxzDkP+suFi5D/2UjEVtqA2wL0S9LUEgJ6DQqxQYV28HEWYk
         wEnePLP2vf7Up2JqV9qh/s6QUPpE5J5KBtbPX3kQBZc3yBlZ/NITIkPb52bJvFGHmCiz
         YMVw==
X-Forwarded-Encrypted: i=1; AKwUvBwOAJjs3m8BVS60+CMPiR1cwPzQdkv+stH6MVMT0d4Vr1jekWzrSekglO7j8N50QRq6954gPVI4uVm7CQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYL5ZX/aUsDUF5Yj/NpPBUMmYMtsOoz1h8bhZ2KmaKS058aAcU+4
	A6NuyA/mr/+Pn2489EWoKY3bZbsdy3eB5Ohh7gGvh97XfStF7gywVTGB
X-Gm-Gg: AYBFou2Cl9T2t+ZWzbwD5Z2LDnQgQHqStauc4n+9HRsWNW94ksOcGaxEd3hAutO60Hb
	b0xW5pg0ZDvl3jpHGwaOB2jdjVxnkKiOXNpYAtZW9ycN+qYC1eOTzomPWnMH3sevd4LvSC1W0rO
	6O7+dnxUi06DxyT3vsKTV5269wX5ABtJk0KCpp+zCdRzx8kqiikKeZpwH850zM/L8JHmmd4Q8kY
	9QqmiEqfl7vT+y7bceJGf5mvTIqMICxF1al5KB6277Chb9j7es0RkFdvmxLgmfenGKEVlbkRq9C
	pR4Pw9r7flUNETte9/0bdeaqsMDNHP4VBq993vOmjmaSzijYfCWmveaissBIVoxdgUJN42Ts0ca
	6FbemChMpe3Uc/CumyKoNOqXyWF2JBloryofi+71GvgqP9TKAMBi2kXuDEu0Zf9XBqfzjN9/fhK
	D7u4PoBzyf7rTVjVoaG2cYGuMD0UacO+BCRxaJcLhThiZPVr4gEle7awZdgt1NAck2bjHikCOrp
	tKGkmT46LRHi3ALZmbKhMdSPiWWOz4Vps8K66UblpfvG/NcgjBHUS3SkfWG+oWVOZvPLlcv7O6H
	0rP5bf8cjhPzTe4yn+8/kx8/ellheJ4M
X-Received: by 2002:a05:690c:f89:b0:8ab:485b:9bc8 with SMTP id 00721157ae682-8b1b5a8ceffmr2994117b3.24.1793138319600;
        Tue, 27 Oct 2026 14:58:39 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e5b83b9sm18877967b3.27.2026.10.27.14.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:39 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 3/5] iomap: remove ->iomap_begin()/->iomap_end() legacy path
Date: Tue, 27 Oct 2026 14:53:24 -0700
Message-ID: <20261027215326.2693300-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
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

With all in-tree filesystems implementing ->iomap_next(), drop the
->iomap_begin()/->iomap_end() path.

Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 6 +-----
 include/linux/iomap.h | 6 ++----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index fd8791c4963b..8b6da9750a93 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -119,11 +119,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 
 	trace_iomap_iter(iter, ops, _RET_IP_);
 
-	if (ops->iomap_next)
-		ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
-	else
-		ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
-				ops->iomap_begin, ops->iomap_end);
+	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
 
 	iter->status = 0;
 	if (ret > 0)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 59718f73c15a..95d4995a49ca 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -195,7 +195,7 @@ struct iomap_write_ops {
 };
 
 /*
- * Flags for iomap_begin / iomap_end.  No flag implies a read.
+ * Flags for iomap_next.  No flag implies a read.
  */
 #define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
 #define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
@@ -240,8 +240,6 @@ typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
 		struct iomap *iomap, struct iomap *srcmap);
 
 struct iomap_ops {
-	iomap_iter_begin_fn iomap_begin;
-	iomap_iter_end_fn iomap_end;
 	iomap_iter_next_fn iomap_next;
 };
 
@@ -256,7 +254,7 @@ struct iomap_ops {
  *	incremental iter advance.
  * @status: Status of the most recent iteration. Zero on success or a negative
  *	errno on error.
- * @flags: Zero or more of the iomap_begin flags above.
+ * @flags: Zero or more of the iomap_next flags above.
  * @iomap: Map describing the I/O iteration
  * @srcmap: Source map for COW operations
  */
-- 
2.52.0

