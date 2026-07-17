Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752642FB97B
	for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784284716; cv=none; b=Mwm2xRTFNFTcY5b1NBOd5Uoa/GSCtmjpfifMN2lhmu9dCEkjrCYnQUVJ0c1Okm+t+JbL+dtVYCT6IzHLylNZyRYkLGeUx1IFLqJ6cMC77SlqpxK9IxtJyrCh5kV6oOqLsxFz/9a3od87rgvtlnyavG5kU+18WS1TrJ8kPyXJAJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784284716; c=relaxed/simple;
	bh=u5M9wdtQ4nbu8mWPmfgLxQD5GRtN9bWbigfsKbcKOzM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kU8jmxXhjmUhUXFt6thfcDt4Vm5oC12cU4Cw7Ei/v/OWDiIUDUhmUGBkqhqVwvziJK6DSNSl+jVFrrkopgij30lAvxwYIEGBAsLh+iZDZPK00Pb7hOKhzdS/wOxlZrtUpXUccmQRN4v2Uwgx5U1kcT28qL0+tY2Ofw4aP1qn3r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=WtRF3xmo; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="WtRF3xmo"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e6a434cabso318135185a.1
        for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 03:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1784284714; x=1784889514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VVQ5U1p0pPiqFfCwN3xL6jXBxqNVEEeNn+I745UCOQ8=;
        b=WtRF3xmoWO/5MuTLRK5nl8s9kMYfkxkm7B2JiAM1aqdJVRSX/5+MnoFQQGe6L0mBb7
         4rayrpMHDJxr7AyZnmfrvMENbe+uVoot+tqs+ITMW+0Ova1dEz2Ir51MGofbHgmnesg1
         HT+YlUDPzv3UfUimKksDYhfNOcxkqE/fYaLjLzd8QYuNo6zAAEZp9LsJ5HCkHc3zzK48
         RkhT9d2SyusGUlQZMyzFz7raXVJjGpd7R/BQPGy4Nom2dGV2oGh2Yd8mg4NWgO2dRJyr
         Zu4CYZtuFM/SpjG8oiNhvF+N4pjOBr1a88CYRc0v4u1iKdFVSjQqe0xcGzs7Suhi1U96
         KYnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784284714; x=1784889514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VVQ5U1p0pPiqFfCwN3xL6jXBxqNVEEeNn+I745UCOQ8=;
        b=tVYhbnDdx0trnjVCLi1Gk12WFCY4q7k8IgO3Z3FhFZ6pp0XxSfTnOZBzNNFB0b6B9Q
         hpDbXfzdCl3FhRCWvw+pPd3MnP9wmMXaKkVyLTW66/TNQQFqb8gEJeJKFfNtSKSF3nep
         gn9thnFq68TkWwfpaiID2VLtJuoNUkFzvVP+ewZeD0S28TbADHCL6o6s5/HMsq4xt5GM
         o9HDO+iWbO2kAwS+938cQsZYG0MzsDm38Tkv1rd+0toWMzFZgBhCM75guI2OEcXCGwRQ
         1/Wd98UCVnHJeY+PoF3/OOqsfCVvXhYL1CK08ZOQzn+Csa2n114S5dtNpc5PcCJFOf1y
         OZuw==
X-Forwarded-Encrypted: i=1; AHgh+RqHmVZpaXlnuy+rUqUea9tTeyTgT+zaaLxfQumSJx5zNzdARIEuYhsOm58JEzSO+nIxxoURfEVXpOagmg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4CtbSK48Ak6Vjk0jYkmI9VAk1MzWJkUrJHO+cmtijDL5oIBH8
	f+fvlR5K40jQAzgEa3QN6byNtL53iFyXrdxlsC5w849NjMlRiZnvo95+StncVeDVmgc=
X-Gm-Gg: AfdE7clmkKSpIMw49stSdRb4tSp5bCK2n6Sx573FX35kVSSIGEiX5rycUQuSGptQ2jn
	q+Q3hQRMMyfxu0R191oITRUL9kIGb6eBVOWhCCnCrEz1y1I0GNVKC6aj22C1muOlaSZchUPlLGU
	JyiACyxk5AMIbiQieLHqXv4pdxkysfJBv9JrqfHj3LJGnLtm40E/ikEStYBWgn1yFdK5FnVNM08
	UNcpAKnluGHDZsnAolJ1GIFaMGkpp+jAhcr+oRvtbxYJi7Ml5FlVokHF20jXj4K+6cHMYzyzCNO
	1Lc72ixWQ6TeJm9WX65id9HKUKCTME8K4QBjsZXa7l0n0SMFU+8I7j/WHQ1nWThbieeL/TzDDfU
	zEAStdXnzgm/66dCRIMulLrYKFy1ia0si3vo4lJrYFrN60b54xLROkiV5DYNqLwxHEN5iiIosST
	VWRXTs1D0=
X-Received: by 2002:a05:620a:708a:b0:92e:5f50:74fb with SMTP id af79cd13be357-930b3ed687emr186120285a.13.1784284714253;
        Fri, 17 Jul 2026 03:38:34 -0700 (PDT)
Received: from localhost ([146.190.222.192])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-930b52fa8dfsm122589285a.11.2026.07.17.03.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 03:38:34 -0700 (PDT)
From: David Lee <david.lee@trailofbits.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: David Lee <david.lee@trailofbits.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	linux-nilfs@vger.kernel.org,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] NILFS2 superroot inode-size OOB read
Date: Fri, 17 Jul 2026 10:38:30 +0000
Message-ID: <20260717103831.38492-1-david.lee@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

super-root inode metadata size is trusted before nilfs_read_inode_common().

Reject super-root inode sizes whose computed on-disk footprint exceeds the
filesystem block size. This prevents malformed filesystem images from
making nilfs_read_inode_common() read past the end of the super-root block.

Fixes: 8a9d2191e9f4 ("nilfs2: operations for the_nilfs core object")
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
---
Trail of Bits has a reproducer that triggers kernel panic demonstrating this bug and can be shared if needed.

fs/nilfs2/the_nilfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7b23e373a106..f3805e7aabeb 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -461,6 +461,12 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 			  nilfs->ns_inode_size);
 		return -EINVAL;
 	}
+	if (NILFS_SR_BYTES(nilfs->ns_inode_size) > nilfs->ns_blocksize) {
+		nilfs_err(nilfs->ns_sb,
+			  "too large inode size for super root: %d bytes",
+			  nilfs->ns_inode_size);
+		return -EINVAL;
+	}
 
 	nilfs->ns_first_ino = le32_to_cpu(sbp->s_first_ino);
 	if (nilfs->ns_first_ino < NILFS_USER_INO) {
