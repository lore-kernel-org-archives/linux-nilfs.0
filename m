Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B243115E90;
	Fri, 10 Jan 2025 01:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736471229; cv=none; b=lDZ78rpkai6M1Vo2Bg08dimymszj1Tn+EqvzdlH6z12eVfuWgqj3B4vLWadyfygnYB5TJ9FJltLexKq2GHGRlLrH2B+vllNRLQ+nW3pkIIoqI2YZrzY60c86ZDqtHFSks2rUX6Q6Lv1HguEADp3wjf7GRnOOpZlaGDLaZ/10HAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736471229; c=relaxed/simple;
	bh=tSOlNkDzzQ5h4pEcVGPmTNaIEQ88+cEiN4pfuOhFWT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8d+P2WDYmo2//Z09CqVqW4ywzTsS1LRI31x2CMg2YeAXrklcSkuHDb/pIw+L8TqxlH74+1AP2tFvJK9m8YqLDh0PuUp9rmgzt9BGh39jKkk/5ouhhcLHmohDugn5/HOO/uF/YMxVInNkJZIit1Wb14+ehid489nQrvMAiN+sME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XWQy/78s; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XWQy/78s"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-216281bc30fso29423645ad.0;
        Thu, 09 Jan 2025 17:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736471227; x=1737076027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSD7wwqA3NPwOWw67AZeqj8Bavxm8bOTKHpP8Z1y9M0=;
        b=XWQy/78sTDNE6eCKGOH6ke5cdznY3Odqi/vQ/S/4afxGfOK2Cw+JeX77RvBTqjiQhG
         mBwcHIE3Zs8o43mkaNdvkh7KOVHptcN5GkhBWwov6t20Re1bEmY5buaZoEMDK76o7fnG
         TDgVGik2O9L/6IgzNOjvzMaJuwM0EYT2XvOCcRv6VD/RHpelovjLUGQgSy7HEbaTY4WF
         WUPXryrw5px83FeE4rCugo+zLJCuYLkF6bixwEiu0KBMd4JGHeKO/V8hoxsPrxuZ7cZ6
         Wlt1CAwybdwOnXRgnYk203oU5Z64hhP2DYN/L3w1/EsEzeCurTeYOnTV5pX5yx5a01mR
         9mVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736471227; x=1737076027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gSD7wwqA3NPwOWw67AZeqj8Bavxm8bOTKHpP8Z1y9M0=;
        b=KEoST9NswwyHSMUmJ2EK0qVstZAXuit0+wLhqT6hguQILu7Ii0oqoFh31ysFcssuUJ
         qXWGyuEKfIRblOcr1cNC8anhJZ0nDuRrkebQy7Nuu8F5/BIcuNA0XUwPE9Lkfc5AwNiF
         tac81o0uBtrXNasS7F1xha16UtNgHwBkuJWPySISWU090lKlwTSnBMUFJiB0wTLFw7Ur
         Z4xtQLeeX+gU/V80Q6WkOFzC51NfI+X7jHVxDoej87+9mQkOf9E+OBGPW3xKQd/Df2oE
         BS8Erg+PFy7MUunaZPmcR2vkKNT9i3dkev7JYvrI1eD/035vrLfmh2Vs8R9uodNEJRDa
         Hd6A==
X-Forwarded-Encrypted: i=1; AJvYcCUgoutPUWmx8PcqNI3CuafxPfv2Qe2RXor5cjJBmMGOpnTW9vuCCL5qw7ryRnE04yPHqi24wxBZw1HtqvA=@vger.kernel.org, AJvYcCWsKBOIofqtXP+dJRdAK0UvdkiW8iSRfM73w/x6zHEmD/4cQxoU58PkXjMHDOtYdWxvEnz3MzFotLVJOpY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoE+y7j6Fs2EXTZttZYW3SysUmkv3NVou500xqJQstY1y1ipqw
	tb6v/pTugBkOQuhz1ou5tRBmWSw7UrFdqetH+Wnl1IJowZweRwhb
X-Gm-Gg: ASbGncsROEIyuzQ7sf/tMBfRYmWrgWSkb0CW2H5pJTkJN9t0f1EMMV0aHW0fRGXi8Ap
	NmhTSmNXwhG549IHs5dqCE4ilnSNNlQPiB9ubAlncEm7BFKOt5DhZVa6/aBU6Du5GujI1ZiYbov
	Vbkbb2AWQntBWE2p+J5cK2fyE59A+dJ3zjRGp+rIoJd1eRC8BkyY1s/Tx61pWqT1+YRM5eoDg/6
	jphtom9aNk56UjYAAm+UiWcpjQHlaLGziSrre4YpgB7Z9YN+yOdD9bI070KSpq3CtuMzwpLKV+v
	Lx7fxlo33azg7DO9NnbKbC9374T4
X-Google-Smtp-Source: AGHT+IHe5/xzhYogjB/BhIOpUk6Hz7pMyY/uRJf9e2/lnumVPuS4UHYquZ2l3MefP0TPGQU5qUBq9w==
X-Received: by 2002:a05:6a21:9999:b0:1e1:f281:8d36 with SMTP id adf61e73a8af0-1e88d1062d3mr13799182637.10.1736471226962;
        Thu, 09 Jan 2025 17:07:06 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a31ddb9e4b4sm1862834a12.70.2025.01.09.17.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 17:07:06 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Brian G ." <gissf1@gmail.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH -v2 0/7] nilfs2: fix kernel-doc comments for function return values
Date: Fri, 10 Jan 2025 10:01:43 +0900
Message-ID: <20250110010530.21872-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAKFNMoksY6f5NtVwmn6K0K2QKTvdjq+s0FbdgLvHzS3YueKqYQ@mail.gmail.com>
References: <CAKFNMoksY6f5NtVwmn6K0K2QKTvdjq+s0FbdgLvHzS3YueKqYQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes the inadequacies in the return value descriptions in
nilfs2's kernel-doc comments (mainly incorrect formatting), as well as
the lack of return value descriptions themselves, and fixes most of
the remaining warnings that are output when the kernel-doc script is
run with the "-Wall" option.

Changes since v1 (in response to Brian G.'s comments):
- Fix typos in the comments.  Plus, fix spell checker detections.
- Fix missing -ENOMEM in the return code list of nilfs_ioctl_set_suinfo().
- Ensure that the adjective "negative" is included for negative error
 codes.
- Change the description style of return codes that list multiple error
 codes to match "..., or one of the following negative error codes on
 failure:" (applied across patches).
- Apply similar style adjustments to existing return code descriptions that
 are not warned about by the kernel-doc script (patch 7/7).

The patch 7/7 is an addition, and the rest are revisions that correspond
one-to-one to the -v1 series.

Thanks,
Ryusuke Konishi

Ryusuke Konishi (7):
  nilfs2: correct return value kernel-doc descriptions for ioctl
    functions
  nilfs2: correct return value kernel-doc descriptions for bmap
    functions
  nilfs2: correct return value kernel-doc descriptions for sufile
  nilfs2: correct return value kernel-doc descriptions for metadata
    files
  nilfs2: correct return value kernel-doc descriptions for the rest
  nilfs2: add missing return value kernel-doc descriptions
  nilfs2: revise the return value description style for consistency.

 fs/nilfs2/alloc.c     |  67 +++++++++++-
 fs/nilfs2/alloc.h     |   2 +
 fs/nilfs2/bmap.c      | 124 ++++++++++------------
 fs/nilfs2/btnode.c    |   3 +-
 fs/nilfs2/btree.c     |   7 +-
 fs/nilfs2/cpfile.c    |  69 ++++++------
 fs/nilfs2/dat.c       |  45 ++++----
 fs/nilfs2/gcinode.c   |  24 ++---
 fs/nilfs2/ifile.c     |  37 ++++---
 fs/nilfs2/inode.c     |  16 ++-
 fs/nilfs2/ioctl.c     | 236 ++++++++++++++++++------------------------
 fs/nilfs2/mdt.c       |  63 ++++++-----
 fs/nilfs2/page.c      |   8 +-
 fs/nilfs2/recovery.c  |  62 +++++++----
 fs/nilfs2/segbuf.c    |  12 +--
 fs/nilfs2/segment.c   |  62 ++++++-----
 fs/nilfs2/sufile.c    | 112 +++++++++-----------
 fs/nilfs2/sufile.h    |  22 ++--
 fs/nilfs2/super.c     |  10 +-
 fs/nilfs2/the_nilfs.c |  26 +++--
 20 files changed, 507 insertions(+), 500 deletions(-)

-- 
2.43.0

