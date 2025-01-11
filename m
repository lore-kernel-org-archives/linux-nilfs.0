Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5296524B22A;
	Sat, 11 Jan 2025 14:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736606126; cv=none; b=BRsV/mKVo38P8q8HNK6m7yYHduFvaCWj+AW/noqJfVN6Z5V64687BCfoUUDixxyOJO6pOneMw+L5J7z6d1BbgodE4jERp/dFKoEB1FQxhpMpSH70dE1otqFUTKDZnHEXQ38MNB8s9iww3tuxddFKKo9dApIoxugPKM4rVbSnWWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736606126; c=relaxed/simple;
	bh=q6c5s2eRmCagwfqSZOsldyYzlQhNfovqNgiz8luLwoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfIir2clcps94G7kzcJ77R9zpVfhMYa2El/Gt4KBOexzQWT04YsnFDvIe65f0uA0zGU7DDJKOwcdTASA5olgXsPQfN3IOfMhSUYIwhp4deeaV5uJzZRafUJUGljFaaRdyLwD7nJE0vrAs4T57zJ74npFeMdjPo+TQ5noQ9vtu1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kOtknJHd; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kOtknJHd"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2166360285dso50661065ad.1;
        Sat, 11 Jan 2025 06:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736606124; x=1737210924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i9b3i6awUULJrF5mx3BUBsHFMfaDDZu0dulCYqwSa2Y=;
        b=kOtknJHd55UBSH6wdxKrJ+JTb0OLdkAlBv64Uxj0YT1EMjhltt2F2kgNvAuHG/7JqK
         lT+W4/S6+7ZtXgT/pDvepshZrL47JjB2nI+sUjCn2pMozWS0DkFmkAn8ru3ONeccs//P
         eAhCnBZ4ouAP32dkQBTocfhNVAw/Qr1GJUBbh5hLciTCnoUSNDrFiNGvgOmaa4NLx2s8
         4Z7hI+NMNxCNZF+eWYD7aoXUCZjKeDkqmpSe3tGjM2EJhLkmXJ7jaLK19LUR2i0co2RJ
         L3j5xZG61RTxb6+7tazAoZkRvM4r/mp8yfLTjX9VLUzCwQ/70MAIk/WD7kYyyE3nDE1V
         qpZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736606124; x=1737210924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i9b3i6awUULJrF5mx3BUBsHFMfaDDZu0dulCYqwSa2Y=;
        b=ju0bb7twj5qqrjqonmpCPMZ9o6dcLPRajt5s8Qj4FBLG4RHAx0riyQ1bMdxG1WIexf
         uC1Tz/IvM7TQQhiiw/bzqUDogBmJ/xKmn/WVOcvpvQrd8KtBRPQRS2jsZBBE4RIxiHta
         CJPdrxoZfh3lpqIUczBiCtEuoJznwSdG1E18G7tVOOExZ6/ovgbr4XW+RzfncAdEWEX8
         YQjlCdieljff+QkcazIk4+y48sa+BX9jEdnFNsv09tPSvBDRrNwQKlzUTQvS5WJhcYwN
         poX+gJxM1158D7yklmN7eV+zUNBs4nLpkEAMjPNML9yt1eofXAnfGPHyANRIa4rfpM+g
         O3BQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnWh8hZJ0HoGBLSZE9yo+RlYmn2g+kpX+TNLNIPDCDVyBuXW/diZdTGNbEe5SVpNHm6uJUTVULKYilpis=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnTE0fFqCE/6wf84tYF11jHHFeEQzcaARwFlHtDSBLrxzPmZyb
	iDz2NvrkvxtMBMn228oU9vfThYImeuusoQvf4mFl19EkuvdoTwJq
X-Gm-Gg: ASbGncvJ5EZ2pUaSemIe14mH08JTSYTdbEPDVGbIKnoEyN+UtkC9E6mnpQRHzTDA62g
	OmZUnlLIboqt4GVxQIxQLIEJBgacwKSzRtPI24oTXCfCG6WSbGPkyUrdxmB//IAYr/n46/WW+Ti
	dNWJoqTZBdtyhd1wmnaaxTYS4+9WtJ1PsAdWiTnow6yecPyUTJ3BB7HmsIM/Rxrbd6RBSh/1e+T
	wjaH6xYMTtzIS5Uc2L/DxJ5LTo4X0jIxGUB/nsyve4O8vl2mlwQnliYEFmDNqHxedqRHk5F/+/j
	3cPpusycEeceJ825sxsGQrbQwiJ1
X-Google-Smtp-Source: AGHT+IFGeEMU7948ikIYsSQOs6528dK0BXmNEcxeKhsCGPyZ2MdB5KCDd/24Gsbcna2/UwPa3bh1zQ==
X-Received: by 2002:a05:6a20:394b:b0:1e1:aef4:9ce8 with SMTP id adf61e73a8af0-1e88d2d5ecamr26005553637.28.1736606124434;
        Sat, 11 Jan 2025 06:35:24 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d40549322sm3095362b3a.8.2025.01.11.06.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2025 06:35:23 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	syzbot+1097e95f134f37d9395c@syzkaller.appspotmail.com,
	syzbot+32c3706ebf5d95046ea1@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] nilfs2: fix issues with rename operations
Date: Sat, 11 Jan 2025 23:26:34 +0900
Message-ID: <20250111143518.7901-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <678123bf.050a0220.216c54.000f.GAE@google.com>
References: <678123bf.050a0220.216c54.000f.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew,

please add this series to the queue for the next merge window.

This series fixes BUG_ON check failures reported by syzbot around
rename operations, and a minor behavioral issue where the mtime of a
child directory changes when it is renamed instead of moved.

Thanks,
Ryusuke Konishi

Ryusuke Konishi (2):
  nilfs2: handle errors that nilfs_prepare_chunk() may return
  nilfs2: do not update mtime of renamed directory that is not moved

 fs/nilfs2/dir.c   | 13 ++++++++++---
 fs/nilfs2/namei.c | 39 +++++++++++++++++++++------------------
 fs/nilfs2/nilfs.h |  4 ++--
 3 files changed, 33 insertions(+), 23 deletions(-)

-- 
2.43.0

