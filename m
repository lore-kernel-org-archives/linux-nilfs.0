Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF551514F6;
	Wed,  2 Apr 2025 08:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743584368; cv=none; b=D6iz6e/kBvswC/K1Ck/z3ZB4dfna/AvZmEqTx38Vd7tJ9wrYRBp2Jncpd04SIHtGlRCNfaP4Nctv+KsU9bTPJ/GHNnYSSNm1PJgHQPtzepN0InSmiyUOQvPvXPqL7O+lxAqNpzmDWAitQQJEfZvC25vZ24FpBowmKusysWOGeV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743584368; c=relaxed/simple;
	bh=m+ytt/uyuNFiuMVG/2fqcdWnTukVvPWuh3DBXrSuYMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q/ZTU+xnX7J6lMuUMt9GFXo0P/peNpPwgjMIAEMNpoZRiRmugkcaWQPdH/i3ipS0ojMhWUFM33GciPl09GzCeX2wp8i707fD0j+zAAtwLV8fUlcvvMNnKIXhyJWvyVQswISAMvPOnacppMRC5WMHEVmRcQ+005bhMZiI+N1MDIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [124.16.141.245])
	by APP-03 (Coremail) with SMTP id rQCowAA34z9g_Oxnew8gBQ--.16811S2;
	Wed, 02 Apr 2025 16:59:14 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: konishi.ryusuke@gmail.com
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] nilfs2: Add pointer check for nilfs_direct_propagate()
Date: Wed,  2 Apr 2025 16:58:56 +0800
Message-ID: <20250402085856.3348-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.42.0.windows.2
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAA34z9g_Oxnew8gBQ--.16811S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XF1DAr4ktr48Xr1xWF1xXwb_yoWDCrb_G3
	WkJF95Z3y7KF4DA3Z3CrW3KF1IqF1fta48GFZ2vF45tF95ArsxZr1DZrn29F1xJry8uFnI
	9rnFyr98ZF42kjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjO6pDUUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwoAA2fszLPTjwAAsm

In nilfs_direct_propagate(), the printer get from nilfs_direct_get_ptr()
need to be checked to ensure it is not an invalid pointer. A proper
implementation can be found in nilfs_direct_delete(). Add a value check
and return -ENOENT when it is an invalid pointer.

Fixes: 10ff885ba6f5 ("nilfs2: get rid of nilfs_direct uses")
Cc: stable@vger.kernel.org # v2.6+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/nilfs2/direct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 893ab36824cc..ff1c9fe72bec 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -273,6 +273,9 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 	dat = nilfs_bmap_get_dat(bmap);
 	key = nilfs_bmap_data_get_key(bmap, bh);
 	ptr = nilfs_direct_get_ptr(bmap, key);
+	if (ptr == NILFS_BMAP_INVALID_PTR)
+		return -ENOENT;
+
 	if (!buffer_nilfs_volatile(bh)) {
 		oldreq.pr_entry_nr = ptr;
 		newreq.pr_entry_nr = ptr;
-- 
2.42.0.windows.2

