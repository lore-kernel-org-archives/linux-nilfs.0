Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CB2273D6D;
	Mon, 16 Feb 2026 09:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771232812; cv=none; b=iNYr5scbJ0WTPkS/lAdjyjMdBFZ8WW5f0lKOqLszeaJLN2+YjKY8RwBilStkUlbmB3dPy5StpaDov3LVl3GdoV5L8fLVDmgO/QD0p0Xa0ndITV86op7UzQPILnMWzSmSosU4BEqkWREGpbPQhEQCzAsRvRWRbBnQpXyl3nl6mMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771232812; c=relaxed/simple;
	bh=teVpk2XZW67wfkZQ1XKSJ+AuDGNe6REwyeDEOoqWHE8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hJGl15MBfrcl4afU+NqxWcLV/AGIc6X8XNdSwZ1waLtp0O6DR39y7JV3/LjoTuMxOuVwLeaaBVDcMmfWQh2uIFQfVNkG8h+IAQevGWrVGOFaBh18gq/MyDIYB41ziVZC6PMibSwiLF5RUHwSO+0f0Uxn4EIb0IxX6XYDyQaZRlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=dfpIdfwW; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="dfpIdfwW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1771232811; x=1802768811;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QBXQKckpKtA9xxZeWDZVrxYkoL0OJsfPg2X+lblSyqM=;
  b=dfpIdfwW53+0irJHAV+dKbWAFhkeQSczV651iK13WzSa4mmS9EE/9O3Y
   ijNLF7+58Ad1BShvK4e33ZWKsTVWgfX8Aw3Uw90ZphJ5tTbMRnxRT5h/o
   GUyuY5sR/1MBhz+stW1PLvZiOyKkIlr+A1VTnc8u+P9gKJsERVMeKJh2Q
   fvDkVGcaVf2wenbWaOZu/Zg9u+7ehWq+NLudlf35j4hOu/EDlE8d1FKa4
   zZeu4JVtGMbqQVoAW3PXM95aeITqq+qm/khatOIc0obDQWYmkQL1XT1E4
   Hd7Qg9ra9WXtwX6a/4heVySA4We9yiR7h7DwUh6BBeB97L5rhFPrXAnUr
   Q==;
X-CSE-ConnectionGUID: UJFg1NUcTiqyvEBSx97Ijg==
X-CSE-MsgGUID: ltLFHf3/TFaAxCrO1FypUA==
X-IronPort-AV: E=Sophos;i="6.21,293,1763424000"; 
   d="scan'208";a="12918401"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 09:06:48 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:10964]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.33.12:2525] with esmtp (Farcaster)
 id 8bf631ae-f39c-429a-aee1-a17fd5aee6f0; Mon, 16 Feb 2026 09:06:48 +0000 (UTC)
X-Farcaster-Flow-ID: 8bf631ae-f39c-429a-aee1-a17fd5aee6f0
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 16 Feb 2026 09:06:47 +0000
Received: from c889f3b07a0a.amazon.com (10.106.83.11) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 16 Feb 2026 09:06:46 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
	<slava@dubeyko.co>
CC: <linux-nilfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yuto Ohnuki
	<ytohnuki@amazon.com>
Subject: [PATCH] nilfs2: fix i_xattr comment to note it is unused
Date: Mon, 16 Feb 2026 09:06:37 +0000
Message-ID: <20260216090637.97744-1-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D045UWA004.ant.amazon.com (10.13.139.91) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

NILFS2 does not currently support extended attributes. Update the
comment for @i_xattr in struct nilfs_inode_info to clarify that it is
reserved but unused.

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/nilfs2/nilfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index b7e3d91b6243..41b8b42be21d 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -27,7 +27,7 @@
  * @i_state: dynamic state flags
  * @i_bmap: pointer on i_bmap_data
  * @i_bmap_data: raw block mapping
- * @i_xattr: <TODO>
+ * @i_xattr: reserved for xattr object (unused)
  * @i_dir_start_lookup: page index of last successful search
  * @i_cno: checkpoint number for GC inode
  * @i_assoc_inode: associated inode (B-tree node cache holder or back pointer)
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



