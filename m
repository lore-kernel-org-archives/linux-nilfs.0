Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E57185B41;
	Wed,  4 Sep 2024 08:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725437650; cv=none; b=RASJSVqgyOnv7uP9G67YxCDKfW6u8Vj0P6M13xzENLnsznL7oggUrmPctJo7ToT6rogyx9J+Tc+NnZUIpxKuJ3xoIKZV6ZtMamSVHqgpR319fvalD0sS3+G98IcdswmzZ85aoqzyEBMeA9hGkQlF6jd/nImfpFTzsdVgxPO7j9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725437650; c=relaxed/simple;
	bh=7xeXDz0ogvxZ2opXy+/mlqtWj0vw9q7sHLRdtbF0STk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TH2AvIyRk7bEkl7ZzDWhVO7K2+oQZx2Oa4rhpUfsMEilnuuqHvP0d0zsZ+2AQXFVTkWnTgGorNpHL/Q0/iUkvzJjh3Ux1oKZ3yDZraCaaWW6EuPy7V7BlDlFxGxULaDk+5FkgDmd73Kt/YUoMZ8M3PoMyI9J5jto7hBx/G282jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pv4Pr5ZQ; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pv4Pr5ZQ"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7d4f2e1d11cso436247a12.1;
        Wed, 04 Sep 2024 01:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725437648; x=1726042448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDYSAyTGMhWQsvqMxqs2OTBOzQM2Nh8wMEQC0ec1bDY=;
        b=Pv4Pr5ZQuqWm34Rw51shL9B5W3F9iRmoaA30r+5xa+GUXbvF6NuEUtJ80UenNv/ImS
         xwNyBqQePRhl0KLlJs4IBzvPDf2WJ+zjRNHt4z7kkmTj0C99uxFQSFbZjrJEPOJAmWvq
         t3dREpsUYn3GHndUN7qS5/vLvDzDBd76ZZpq1j43Mj0onhp5r3yInJZr71h+CQuPXns0
         mKz+ZmfBwvszD1hwpfld9nXUYX871YiBJ83zvUpT9hmnwShA502v8atU8IaeOOKkucnB
         N/HUScHdTHwqI5rYaJNLMIkgRzT19+x8wmyfbmSvj9qPMXjsT9p8klJM2luH5RebNWqM
         EIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725437648; x=1726042448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WDYSAyTGMhWQsvqMxqs2OTBOzQM2Nh8wMEQC0ec1bDY=;
        b=fkE+UY7nViyIY70kh//ZDlDs/E2f8LRegPCI6LH6fbJzpe0borPEmAQkj68Xqxt1X2
         sxmg7cDRzS25HQbyQLn+91l5m4T6WTD9Z55rMjbjZmIxVq0l1pMPs3L3VBSJuGTExggo
         iba2jSITchGE7ySAsa6dKC85jhXEBasQPqNHzvhaCwM/zSyFBTD4fpOgYJ415JBzoFy1
         9meea/dua0JUUe3EJfP2u4dNRCApbJ/MPSX1RY3H7lU/Uh0rnEeXaM+OFm0kCl+3hGRN
         PK+9ZGtcjM6Opp20gBvMYcbeJuehaiy9hBGXguN6JWzSe1GWDVJlHgvljuTsBq9PsN+F
         16Dw==
X-Forwarded-Encrypted: i=1; AJvYcCUCHdcSwkj40Wr1akYGsJ4vyg0jH5NA4OHdFXg4nKkK474F1OxcSaphwMxJqkvefG4QgfbEmP9GKtwVc8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAXKJW6ZJiayqsWQl2JQTZkYIAZta/s+X82GSxZNnh/ydSYs5a
	g662rbi8NGcUd/A/jJHhDBvhqOVf5xp8QQjVBP1ruPPKWmmJ+50c
X-Google-Smtp-Source: AGHT+IH/AVntGWfHxijvKfTvvpOpEjhHD+bMJUmAbfQSAPWIbNCTULB0UOvYruNiWSQ2sop4EX8ZrA==
X-Received: by 2002:a05:6a20:e196:b0:1c4:9100:6a1b with SMTP id adf61e73a8af0-1cce101dfdfmr19510685637.30.1725437648157;
        Wed, 04 Sep 2024 01:14:08 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea5832dsm8836485ad.237.2024.09.04.01.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 01:14:06 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	syzbot <syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] nilfs2: fix potential issues with empty b-tree nodes
Date: Wed,  4 Sep 2024 17:13:06 +0900
Message-ID: <20240904081401.16682-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <000000000000b4cf9a062114d132@google.com>
References: <000000000000b4cf9a062114d132@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew,

please add this series to the queue for the next cycle.

This addresses three potential issues with empty b-tree nodes that can
occur with corrupted filesystem images, including one recently
discovered by syzbot.

Thanks,
Ryusuke Konishi

Ryusuke Konishi (3):
  nilfs2: fix potential null-ptr-deref in nilfs_btree_insert()
  nilfs2: determine empty node blocks as corrupted
  nilfs2: fix potential oob read in nilfs_btree_check_delete()

 fs/nilfs2/btree.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

-- 
2.43.0

