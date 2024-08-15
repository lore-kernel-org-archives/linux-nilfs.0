Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693A815DBB3;
	Thu, 15 Aug 2024 07:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723707906; cv=none; b=tjWmI5e45q+ZCDu2W0pSw6JkOdbh+02uPRFSW06DXga0b8tuzzU2k4fLtXNdBDJNenXJg5kcFWceAJFk1pKhekHN2M8bOdJunP7fBCIQvOgTpoVuumN1mM0RMx41P5RLhciWzMy7ww31V2TQCuM3A9HxLJrDNfz3smoWhqwcqpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723707906; c=relaxed/simple;
	bh=NEfBuxFs2T4YRZfiXMEo6zCXwWg19qcmD0UqaKdiavs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mgJESaIHjCOqpORZdizMEZBSXaUwTxIz8UTS822UjucUzdpq0P4qAcjbPqq/4U+P0fmcsVLA0Wk71s2arE8Q4YulTxfqg1ZLZbIEWzasccssedoBCTjy3SduPcgemMp7FTX7FomWSLKi5+GYQFbCPI4qWMng+8sT/RpFddJWFYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lUTJHvUp; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lUTJHvUp"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-70d1d6369acso1155088b3a.0;
        Thu, 15 Aug 2024 00:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723707905; x=1724312705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nz7RFxEOaUMumtj/tLnRMqvezdcc2Y3P3gbItolsBtc=;
        b=lUTJHvUpUI0kBtIziuC1FSA3FAsQE7uBpgBOjW05nvInhN/WEz8pi4pZ7u7ZEy9NOu
         E/KO+/dbOTGRcK3ccpYXDgi5Iavp7Y2MNnKTdNv3cD6D3JbtcLCKZBUBowekswBcOTkQ
         2Fs1WCNZLx+Zg/YS+xgyW4DxOV0R9UYXPlVJwR9p3AGxd0q/LtsOB2Tzx2orIhUkrcFa
         U0TD/PSb54nxL2diboeo9+419FvDZKlPesiW+WAICcINzdPKhc0DmoglXQr4pROOKuHg
         X3YjJZT9FFZQepIRxaPuIeg08BcR0H25CWQXV6A56pVmWsAjZp1/bG4InWBRvtvawqqC
         lrOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723707905; x=1724312705;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nz7RFxEOaUMumtj/tLnRMqvezdcc2Y3P3gbItolsBtc=;
        b=n68Szquq1RGGVdT9+9htE/bOk+poggorMp1v0ZVVkZnuQrTu2caVMYP2uAePKJC7WH
         1hdpNmXJ8gOgPE7Dk/m7pgaYpuHMq7mMQhS8RUWtdgMwudXH0IaYeCN+kDFAnJ4MJSM+
         I+X1hF67+xy79VUZ+XwwTq8sG+m1qpBcJ1crGgwVyn2163nRL4Xhz1td5PMClwaiTZja
         egyTfO7LqEKZUBIlf5qKrgcnZfysjFpkJuNudXO8jsn5hGfYi8dfOcM1lciJgrNQQeTH
         WEJdWXSdu4VTHaKiTMDkC/QqJZvufbD2KvmhX+I2+3j+M/1kR3NNHc+YAzNLNKc5VQ2P
         yDJw==
X-Forwarded-Encrypted: i=1; AJvYcCVASA+d4/JW9Goqvbka3SsPFhMmLulUDNidmP3UsLBkJ9G5tfKJCZW5pENYFPzCPEwhrDIOrxwWb8rJLEmN60GN3Jked5HQnkB6Ax6m
X-Gm-Message-State: AOJu0YwlOShIq7A95YMg0fhi1KfWEfFvcDhHRsa0wR2Ipm2an5fLkLmG
	5eBsi7LG6kZSlwuBGyH5K7KmRDCSLhzF7i3IMlJhxkWVmXjKVqlEoD9s0A==
X-Google-Smtp-Source: AGHT+IF69tcV5wZeUrj3UU3riglK0aJO6lQksr8Z6WxKWKLYU+VWFCh1Saxe09J648B8Ce7YAsS0FQ==
X-Received: by 2002:a05:6a20:dd92:b0:1c6:b0cc:c510 with SMTP id adf61e73a8af0-1c8f859e84fmr3558137637.9.1723707904489;
        Thu, 15 Aug 2024 00:45:04 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127add721dsm584767b3a.42.2024.08.15.00.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 00:45:03 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] nilfs2: add support for some common ioctls
Date: Thu, 15 Aug 2024 16:44:04 +0900
Message-Id: <20240815074408.5550-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew, please queue this series for the next cycle.

This series adds support for common ioctls to nilfs2 for getting the
volume UUID and the relative path of an FS instance within the sysfs
namespace, and also implements ioctls for nilfs2 to get and set the
volume label.

Thanks,
Ryusuke Konishi

Ryusuke Konishi (4):
  nilfs2: add support for FS_IOC_GETUUID
  nilfs2: add support for FS_IOC_GETFSSYSFSPATH
  nilfs2: add support for FS_IOC_GETFSLABEL
  nilfs2: add support for FS_IOC_SETFSLABEL

 fs/nilfs2/ioctl.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/nilfs.h | 12 +++++++
 fs/nilfs2/super.c |  4 +++
 3 files changed, 108 insertions(+)

-- 
2.34.1

