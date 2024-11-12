Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5AB15B96E;
	Tue, 12 Nov 2024 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731420742; cv=none; b=F5B7PrYotRYJz08iIpji4YjH8NcrJKQl35/PPJbSsNirzlbdj/tcTihh266fJoA72y29w+/Rt1pg4jM3USTV15Nu+FO16XgM509qE8liwcTyzo2wNG3uaqKBU3cVWjzCpdy571Zcnph0NPnkmiv0zMlawjOmmu+c798dSiRQ5yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731420742; c=relaxed/simple;
	bh=ou7ezqA0TNWzMyr0HmClASWLboIsghAng99ctQDbhl8=;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:
	 Mime-Version:Content-Type; b=H3+KA2QjkSHF0o4HnYXEJg+vpE5C4KZ8VvqEXFCYyWhBlyrJ3xywz7QmAP6r/9zs5Z6dyGEhEEfd6dBS9mt+Ei67DgghxY/MDE8EDU/lksCnYxTj6xzjg2Pp379N2+LPaHDhsuNrxnLKxYcJs+Na+3VqC5vWhOCGmICSXWmFrU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=amuLbjfy; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="amuLbjfy"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20c8b557f91so61407785ad.2;
        Tue, 12 Nov 2024 06:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731420741; x=1732025541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9u5pQpmGFQwkUqBga6uY57rzoIEg00Rx4MhRYBHm4dY=;
        b=amuLbjfyKo7nPqk53jD7dMRnBvTI9hlFw9PfT8bw8dKFyIalpB1Cq4RLZi66f1z9CT
         BNFJ7iuI7RKgyagies/ZqHICg7vDEK7t6zXTZOeTmg1l8UgWajas8/jLh+TR7A4Cq87u
         iL8Mpjk7FRbSpdBVxh+8Bnu2CxOfQIfbYtcaX4D/Lhiy9ruPaJTTppgkF39ZUlBHGlz1
         m+2U/ntsz3DCMdgtESElU/8Ia4++1klhGNF83pKuWjlM16mNwnNV+i/KxXH9r5/GG8Iv
         mKGFQF2Rv1V6UnjXMwlelllMyO9KE7KyawTbrxqrceVfg/cl48CCOdKtSjTvpdD/NrqF
         uCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731420741; x=1732025541;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9u5pQpmGFQwkUqBga6uY57rzoIEg00Rx4MhRYBHm4dY=;
        b=Ai8phwo9n35NE59em13g9lzNzt30w9MfeCOWLHiDFAaxic80m9EWLZ12g0xiZYOEEZ
         Jeaoeyj4dxqTRknmgNMueHNyAUjGWhrgC7hKr7B1bXUULQg/BduyTpSGRD0HbGx81WqX
         k8qL9f2+77uDECuNb29lxwqk9zyGVVcg+a1vz3/eBv6eNOXf/3bphoWv45WmVXGuA9tq
         EwkY1OJQhz5cv601mWSrWy/Sn4MvkTmR7c2b81KNet2GIJX8RXiEslkcbrJUI0xvQGcO
         8r5LvoHXsoyA+v7B+vhi+LwvV6+7wTYUWFqM5fxhdEP7TUjQCawNkVnGCatm7jB0mIhn
         4CXA==
X-Forwarded-Encrypted: i=1; AJvYcCWUIh8x7RWxKCgEZRy13B8Xuoh5V2mvIhGC4TT1f3Yo3K9lY1BU5Mmxp6UBkIi64V3xmweU8VjnNhtzEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMrB+NTXEcAQBj+8to3G1vaakXnZspOrN0UXguBnBR1qFT5iSw
	LTXdZXXk33jUO69u1yxUtFjt+MWHECzFPV2HQ+uPZRVhJcFja5m/
X-Google-Smtp-Source: AGHT+IHEzA6o35XgcasNkDEdzNuBi9P0oEDGl/qk+75rz24Wf9Z51pxnDhwa75dGBCvPw2TWKZlWPw==
X-Received: by 2002:a17:90b:1344:b0:2e9:20d8:4147 with SMTP id 98e67ed59e1d1-2e9b178fdb7mr22211558a91.33.1731420740686;
        Tue, 12 Nov 2024 06:12:20 -0800 (PST)
Received: from localhost (i223-218-156-103.s42.a014.ap.plala.or.jp. [223.218.156.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9a5f5e513sm10661966a91.12.2024.11.12.06.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 06:12:19 -0800 (PST)
Date: Tue, 12 Nov 2024 23:12:15 +0900 (JST)
Message-Id: <20241112.231215.1262254749077533950.konishi.ryusuke@gmail.com>
To: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [nilfs?] KASAN: use-after-free Read in
 nilfs_find_entry
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
In-Reply-To: <6732e1d8.050a0220.138bd5.00d3.GAE@google.com>
References: <6732e1d8.050a0220.138bd5.00d3.GAE@google.com>
X-Mailer: Mew version 6.8 on Emacs 29.3
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Test fix for local variable type in nilfs_last_byte()

#syz test

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index a8602729586a..6bc8f474a3e5 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -70,7 +70,7 @@ static inline unsigned int nilfs_chunk_size(struct inode *inode)
  */
 static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-	unsigned int last_byte = inode->i_size;
+	loff_t last_byte = inode->i_size;
 
 	last_byte -= page_nr << PAGE_SHIFT;
 	if (last_byte > PAGE_SIZE)
