Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C0B86341
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Dec 2025 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167598; cv=none; b=XHTjwwv97Cr4cV5lqDogOm8mChSYxzmP+XFRYbWcekgYHeWD6Twa+k9tLrbMuQbJwGHlelLTT8rXDc29xGO/J76Ed7G9g+5PRZUlxmhfs6QnuqnnoLfwlNP8CQ0+jDkjhlW1DOs/Kic5dWAQwL7+Ks7q9xJgJR/ykXNGQkJMFOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167598; c=relaxed/simple;
	bh=M/C2lPYcUpu9xDp6hTyHmesVnGZe+jjELEQBJYJjDAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dpI5LM9vdcAp2uMo/FlcfR5yXxJDFOfn3CSzCTfIhJIVnXh9pKZEjsZ3XHlVkIv+qowcgD8cD0XuvS9bmxTuP60g5ONv9q65spshzGZd/GxDafHgFFDvPl+HulLHrWR/DkJCUnUtu1TdeACTVNiM148DT9sXLdv9sumi9SgdqZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QsMSyj19; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QsMSyj19"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7b852bb31d9so2508286b3a.0
        for <linux-nilfs@vger.kernel.org>; Fri, 19 Dec 2025 10:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766167596; x=1766772396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ge0zlv8amWah3v/B6Qb4hlgIprHBkZiMmuyhkBtuaLk=;
        b=QsMSyj19/2o0mnAqA5rTm0B4lnuJVOjT9duJDvEvS0fsE5s3O462Qhp9tdYEnkfqEY
         WcDc11eJOjXgbhSgZ1vHKja9AbnsB3O0nqJT8ZXfDHgCdV+Cg6Zz28Ni6J+sMICtR1dc
         mN7XBL0no63KgPpT1BqJU7/bjhdHyO9ksCmRjRZkkd0T5JrGYHm3WdksfxHyKKiRsAXs
         E9ixNUU1Sm4GcpfXi49t02v0nUAkO+WL8Y4n0QDXn1hNzBmA/4F8cSWeNchVz6Lp9/9u
         TJlYZBseP+bSg/COCaIKdgPHrdd9FLJW1DQA2XGDWXpTgAcNpOe2tEiLIQiviMSbbeN+
         p+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766167596; x=1766772396;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ge0zlv8amWah3v/B6Qb4hlgIprHBkZiMmuyhkBtuaLk=;
        b=VUzZjy0q4dj2dP90ErhRI9Z9wsirv/JHLbLWpNm16AqPUS4nf/UpeTDwGxCyKrQNAt
         ZLLi7Nj/C3894KEHD/8+k9wFcAh44XnILkEY9sgYKrpVGij0GBARbOE/ciT9Gq1CugpS
         P+snXR7g70r8TuXbGjGZLHI6MLHr3W1E3FyTa56nEYm9K0H1dEZxbeoxG8R/oOn8n2tT
         HvrM3aorhVN3azezMv+snihWIPpuBqmNOxNH757kd6Wz8Qr2lOKbzwjrTwQhpHGPIKYy
         R6AYPiqe+MgHbK7qj2jsnw3MFk3SdbpJDC13dDHy5AV16/5nwWgfKY4uTVmTapGENtfW
         G7kw==
X-Gm-Message-State: AOJu0YxO63krBqMe/uBkDYmQSyy2qe6uL4l7zpDjA3uKN/MMWrX6r3m8
	FNeno6PvFVG42Mb05lgTb5TmTRRVKfhJ3oO+ANIJdLWMJQ019fMmjrxM
X-Gm-Gg: AY/fxX7bZV5g1ZFBtKnkUgokmxkMTQ6MurKv0m3NtFNUKnBzNn23eiGTql0EmTzfShH
	9yKjpBqWMQiuUsiPz/Xam07rYIR3obSbp01R7BNqr6Uda362if5lwfZQI1kGjyIQVqOnLbHzhaw
	BtdC0Hl4cvBChccai1JoOOuW0y5vKWRT54hsWt0hE6se8iRNSuNO1+ch3VKKRQ2IncLMY0jyvo1
	5jGBAAZ8hMLPNLp5TizxB1ECrEPLETkQYJywg01c0vUydJg4yBafGiJjSf2C23KnCGjaPa8YjDk
	6V+yGwwJncLptCCPKSpVZeRLEAGHub1F5BU/kRNko3cjHgzLv0HbgUBPsr1QTP02GL9IvB5kVZj
	RmUBE9JtpUMDWkkcW58KdxXCstYfdKMGKlWTxFqjnYZUj+9ycrrU8eXwCcRFCOtLIKI9nfIjeYG
	DbmLr5uKWyPLbtbJF96FwxJ8VTWkImg1H4Ry7sA8qcbayGvsboTZJ/AdnHy0QRDoW/nnq5JOE=
X-Google-Smtp-Source: AGHT+IHx+Vb+tD6kH6yHQrLjhaj4yOlLct0KOkaYxhCpXW0qjZZKcq8nSEq/mU/rya4ykd1aEAds4Q==
X-Received: by 2002:a05:6a20:7d86:b0:364:37d:cc63 with SMTP id adf61e73a8af0-376aabf9cb1mr3671382637.56.1766167596315;
        Fri, 19 Dec 2025 10:06:36 -0800 (PST)
Received: from carrot.devel.local (i114-180-53-102.s42.a014.ap.plala.or.jp. [114.180.53.102])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7961c130sm2688468a12.3.2025.12.19.10.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 10:06:35 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] nilfs2 fixes on v6.19-rc1
Date: Sat, 20 Dec 2025 03:04:24 +0900
Message-ID: <20251219180631.27554-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Viacheslav,

I'm submitting three nilfs2 fixes as a patch series (rather than a
pull request as previously mentioned), so please queue them in your
tree.

Two of the three involve kernel-doc issues in uapi header files. These
are suitable for the next cycle.

The remaining one, which I'm sure you've seen, fixes an issue recently
reported by syzbot involving the FITRIM ioctl, and is a slightly
higher priority.

If possible, I'd like you to submit this as a bugfix patch without
waiting for the next release cycle, but if you're limiting your pull
requests to merge windows, feel free to submit it together with ones
for v6.20-rc1 at your convenience.


Thanks,
Ryusuke Konishi


Edward Adam Davis (1):
  nilfs2: Fix potential block overflow that cause system hang

Randy Dunlap (1):
  nilfs2: convert nilfs_super_block to kernel-doc

Ryusuke Konishi (1):
  nilfs2: fix missing struct keywords in nilfs2_api.h kernel-doc

 fs/nilfs2/sufile.c                 |   4 +
 include/uapi/linux/nilfs2_api.h    |   4 +-
 include/uapi/linux/nilfs2_ondisk.h | 163 +++++++++++++++++------------
 3 files changed, 103 insertions(+), 68 deletions(-)

-- 
2.43.0

