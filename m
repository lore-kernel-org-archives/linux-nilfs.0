Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D790437BE8B
	for <linux-nilfs@vger.kernel.org>; Sat, 25 Jul 2026 10:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784974069; cv=none; b=GCtfL3LMF0BU+4jG7Cq8uhRC367oXfMd036GMcnBLIVXw0ZEKXznDvnS2s6OamziAa+euh8QTP89gNJvLy5Skd+IX5Tr/HHQw3OCDXz2XqzQmBaje2uiL4ylr3TBL8mUuPugSjlQi4uUWo70rO/42tz2as/65ITCYmnuTVbL9ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784974069; c=relaxed/simple;
	bh=aJ4LSo/NTaSTwZMJg9a3/I3GRWq3GIZtPlmMs88YImY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UHt7ytM0WK3lcUlIV1FUx8vNd3P5RyjAmtX3GSaWTvC/mGih/zcfgQtiDEPwZ8nffeDFSHjHhmXbeyuGReOxuEvJNfffkFTMMaWumrOfAl8O4GfjXYacDLr9AYCkxC3JEnQrdR6k9UkpHt+NqoDRebSf6OzrBjZDfI4SlP/1Ths=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lFX7V0Bg; arc=none smtp.client-ip=74.125.228.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lFX7V0Bg"
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-ca696c4b152so521961a12.1
        for <linux-nilfs@vger.kernel.org>; Sat, 25 Jul 2026 03:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784974067; x=1785578867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=psDEako9igS+JMXNeDJWp5ofaqiZnlHSmrShqcd17Ss=;
        b=lFX7V0BgqsIbZAiRYK+9OS6ngz7cKLvJAiklO6tJIoHukhAbMya16UEVaYpl8HrfPj
         dJCfI+nQ00XJjdbHfxUlGwe+0WEbppWX01VjLJqNTGZCNRvbqAnwQqUnlbDcQg5qM8aF
         pdHxmCh/Oa9zuTxHrC+nuhD+usWTG2PzospbMNig3utEErpmWXpaFqNJhCWVT9Nm5orU
         x+YgJ50QZd9UrrNFxl5jFZRUyHnd7k0ovQki2o/4C+8pdiwm5O+KDlgRS/+dR9JrqCJ1
         tM5MpWQ0WigVoGNvQPp5kg9/F3cJC9FNto040qbWigofwuC2Q11N1KPjgpnBNasF3wvd
         MAUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784974067; x=1785578867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=psDEako9igS+JMXNeDJWp5ofaqiZnlHSmrShqcd17Ss=;
        b=MO+qJGJ9/dzflHYAm1oXbryIv0xS3AWDYjz+mk8TChy3AIbR9X2XuakSeoJwnMjLX2
         z6jyn3qUN85gsWQM7vAioNRdERMPsDCDzWXw/3d3za8EV5ISTgkJ5ZqW0+pyNHzslwU1
         x0EBTVK6QIWMKXNxEwM1CxzKbwbAXE82JFH7r1r1BVVIPMQpEz7VWmrXWN8/TIiA4aZ+
         Pk2j7txrhMmFlL49qt5zieaUAggHSbHB79GbOCcqlnYF76GAeAzxApBJj7gF2Z4vcaDN
         zU0fKf3SYouVuOMJQIa7ZkB8F0xEEyIjkxvIDDLaxRxVU7meXmvoT8UF7EkLmeE2NBVA
         R/5A==
X-Forwarded-Encrypted: i=1; AHgh+Rqlk/qP+1XVGe72rAnIlJn1bDUXdiER2aMr/zdemADM/qvaVsi4SaOLtxFXS/bPVq3WV/hhB/6Wq0xvUg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyScZcrpkpFi+Q9vWXUTvpQ9xaciHepzwYXUReNmLB+6nC1dVoP
	h6YNp2KbRr1jQp9Pc6QU8lRF9dlJw0nl2Ibdyx00lz0vD1TJF3YrO4aU
X-Gm-Gg: AR+sD11/q4X4zXriI/kZIoGfepoemipsw5Lun1tX2yee8LL4zpPEoMUoQR50HqalVQZ
	xvTG5Miaqxz7Tb56XpDD41C0o0fp1BLvC6lCiwtUU2vxnnhkpxWPSkPf3LfjnPQLAjQf7f1taHM
	rEBEvukLXw1fwH8pCUBr2OiDd0BDl5TYsWJdUIF5Z3wM2V1kJqRAySiZdx/9DxBwkWeo2Dk+d0Z
	NDXtHQBR37uFdI0XjsDgspr4UHcetpDfrEBBptim301GhpzjaF/iE6QP+G4At+DgsZz/VVq7U/a
	RYuk6YZ6guJsBL6ggZEjIkUlR9VgK3FIS42e8+ABfOBr/EiDJkaHQI85rWHRpEseiGflWj7AcDJ
	pc02AonwL3i9ySJPveHPgRnQBo1uaqVA7yUSN/so8t9HqnJTqz5vLuqpGrzFQxH03SHuVSIV8bJ
	6nqQaStPQcCoO49ul4m4/4gIPr
X-Received: by 2002:a05:6a21:2c11:b0:3c4:d47:9146 with SMTP id adf61e73a8af0-3c67e083246mr1684101637.70.1784974067153;
        Sat, 25 Jul 2026 03:07:47 -0700 (PDT)
Received: from DESKTOP-G5LNDKT.localdomain ([49.37.214.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc288a79sm8840990eec.0.2026.07.25.03.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 03:07:46 -0700 (PDT)
From: Manoj K M <manojkm24dev@gmail.com>
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com,
	corbet@lwn.net
Cc: skhan@linuxfoundation.org,
	linux-nilfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manoj K M <manojkm24dev@gmail.com>
Subject: [PATCH] Documentation: fix grammar in description of nilfs2 recovery code
Date: Sat, 25 Jul 2026 10:06:58 +0000
Message-ID: <20260725100658.1705-1-manojkm24dev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Include the word 'at' to make the sentence grammatically correct
inside the description for nilfs2 recovery code. This improves
documentation without changing the original meaning.

Signed-off-by: Manoj K M <manojkm24dev@gmail.com>
---
 Documentation/filesystems/nilfs2.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/nilfs2.rst b/Documentation/filesystems/nilfs2.rst
index e3a5c8977..a0124d22a 100644
--- a/Documentation/filesystems/nilfs2.rst
+++ b/Documentation/filesystems/nilfs2.rst
@@ -252,7 +252,7 @@ The following figure shows a typical organization of the logs::
 To stride over segment boundaries, this sequence of files may be split
 into multiple logs.  The sequence of logs that should be treated as
 logically one log, is delimited with flags marked in the segment
-summary.  The recovery code of nilfs2 looks this boundary information
+summary.  The recovery code of nilfs2 looks at this boundary information
 to ensure atomicity of updates.
 
 The super root block is inserted for every checkpoints.  It includes
-- 
2.53.0

