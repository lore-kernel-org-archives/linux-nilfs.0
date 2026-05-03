Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8345723A984;
	Sun,  3 May 2026 04:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777781783; cv=none; b=YS+uUmZHY3PLhKoBtlgJAebTqadVIVyeydCMm+PWKIurA4K/oG5QGnAjxV4rNbn5WnqmRw/2+gYIiQ+mtSWThnHTELxTgCts0n/MZOLmctkdnb7wFMPo3Iu4CxooAGcTLrnEviyi2VVCqmrjPPtk2QK+wEBIYQAkViO3UkCufj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777781783; c=relaxed/simple;
	bh=aWdcj9Ear56Kl33eGcWo4ywT8njHodZzJpxxlySV2fE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TCGEjtslRx0E6owQmxhfn79YPz1ZX+lMuvOpXUyBTYGWuNDoAD6laOMM2ZtNe8q74FSFKe95pqe0uvSx4LftMpH66EBqME0t3swbIQ6v1iFNTznRD6gHnCMV4yIIRhvQWYs62k4pE+DO7oZz06RtqKmXWA3K+DPekx8B8lJ4ERE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d3ee2b8246a611f1aa26b74ffac11d73-20260503
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:f0983c6f-f352-4475-b6fa-49e4829ec77c,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-25
X-CID-INFO: VERSION:1.3.12,REQID:f0983c6f-f352-4475-b6fa-49e4829ec77c,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:e7bac3a,CLOUDID:4e3d456e4a41c7622bb66a9030035a8f,BulkI
	D:2605031216172OR1P6P6,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d3ee2b8246a611f1aa26b74ffac11d73-20260503
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(112.64.161.44)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 865375197; Sun, 03 May 2026 12:16:15 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com,
	neil@brown.name,
	jlayton@kernel.org,
	jack@suse.cz,
	brauner@kernel.org
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH 2/3] nilfs2: Fix return in nilfs_mkdir
Date: Sun,  3 May 2026 12:16:12 +0800
Message-Id: <20260503041612.201421-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Return NULL instead of passing zero to ERR_PTR.
  Fixes smatch warning:
     - fs/nilfs2/namei.c:261 nilfs_mkdir() warn: passing zero to 'ERR_PTR'

Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 fs/nilfs2/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 40ac679ec56e..e2fe95de3d71 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -258,7 +258,7 @@ static struct dentry *nilfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	else
 		nilfs_transaction_abort(dir->i_sb);
 
-	return ERR_PTR(err);
+	return err ? ERR_PTR(err) : NULL;
 
 out_fail:
 	drop_nlink(inode);
-- 
2.25.1

