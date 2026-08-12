Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B814E402420
	for <linux-nilfs@vger.kernel.org>; Wed, 12 Aug 2026 22:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786572744; cv=none; b=k6ofCkY6nG5y2kZyaC/65m+VlHMuz4Dh94nWbRyK8B+ZLyChOvc7rPQc9iFF0DxbbWlOfmSJgc6fT8lbuQjJRhdlRVsTBLP6BoRUO7LNOSPi1PWgIBNFIPCNMhItOwhq1b1lpaVyi9t+AtTZPNL3ZLppYH+6lT50zfAaRaeiBck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786572744; c=relaxed/simple;
	bh=hWYZSCjKbisHjTsFzwbNajvf7HpA83u8NazXJr4/ayI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N9oX7fFTdqF5B98hGg5hTj/939ixviAxxZUFHfhq9I8UxdueqbiPdVfPfGjlGY/d7i0qYHTK93Bcej/ZgGDUV9KjUvU8r/peDG8C4ZfM0W7ppzafCTn5YxvqNr+dal4hF2E7C4Ym8fzzdV7koGSCssms4cGR6xG9ghBR5WgtYm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=zLKbbcej; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="zLKbbcej"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8111c0c7561so17191467b3.3
        for <linux-nilfs@vger.kernel.org>; Wed, 12 Aug 2026 15:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1786572741; x=1787177541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T2z0e4W0fIw9tW2pTB+rxIakCo/O2CcFfrFmQ18Vahw=;
        b=zLKbbcejtCeAPW+FcUd3AzKjQQv1scmK71nENTHn/4fPLjYgIR5ARAxEEabxyR03xG
         Dxra+l18C7eCYLWy3G6v5vNIkkFbQut/zHgRoon8MT+rsmS/+D4+DG3prZHja1Ieow61
         oUKpXlMc7MgiMtHQmOd7LnJD2AJ7+PRRrvi5tKMoBToJfcJca5q7mt5kDMBNJpHaUI6Z
         leXpIFptQG7oBYcTaRUh0zWfHQD/TSgIUiOPzf/jxZvfiFrB6yKMmIyGKyDA5R8k+TDR
         mrBTB6gq2I8HmDV9o5VqCXMrTR9puh6vwhyW2WXyRJq2pg9jh3LnAuHxY3c/EPyPOv0y
         Gz+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786572741; x=1787177541;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T2z0e4W0fIw9tW2pTB+rxIakCo/O2CcFfrFmQ18Vahw=;
        b=FRGZifw0VZIf5qhzvuw9GEzJUFHDlFAIZwKriZDcR6PVxN1ljDy2pxTQ2NFE8mMXaa
         ZWk3aSQZZH2YozwGksjzC1S80dt+RacGmCu83tvIkKU9ko5axbVyWlIJJyi13sGBFJnD
         WRcPiYJs+wL0IDtmFSz0wOIV/tWbAQWhZhXkSMwIVOLEJUCzK+g/5t4zLWEP1z6wbOTS
         aUCWKqJHLfSjAp3xLRJmPYmTTBJOUwFR1S+hU1q52qBm+lWGKJ7G9+aSbLXGah8Ksr9D
         KnOLEUght7LgX6LYsBVwnD9aemikWRWyaTPpcS6KZhrvwB/MYNMK5Amz4MFfOVyWPGTu
         hISg==
X-Gm-Message-State: AOJu0Yw6O9aYOIwDUYlbIn0Q6OP3bZLp9YOZvidMEwCrNeqtoqGL1s3E
	BiBj/TdKrJ8oEYCCLt6N3RdBlEi35m5CvhQq8TEU8cMeDHDGvEfTlSZxL1dOJdlNWlo=
X-Gm-Gg: AR+sD12/NO5GSfjV0LQ2MCoQRAH5spnwzn14KCjBuCdLgn/qwARYEwHSrojguf/V2MD
	xGYynNs8nTr08CJS6cNGOPOHM1nGjFetqRuVUcSRZsNGie/f/47xoHSjvQCeKsTVSTb5W2oTwav
	cjrNDMJ7oAeyzpH+skzt5FmiE1eoOODCoE3IugmQqaATJ9Bz35WfO0xRdH8TRz2+xRQKIRrQKrO
	KMJp1DnCrn5pxdM8KQnby4Lambffo0sZmdpD2S2QueMiCVHRXMecYv/vS8prpO7WEy5Jt5/Xmyg
	oKCXpGj8z/UCGLaKJMOuxV6AiU5I3GGaJnac2/6B6yn5FH12N/4sDpJ9+P9ycoLtAkFNhQCWeTm
	DhNSkbj2woefYKCA5OCgpS4f0y6zW+gS3E0kt4K6B5tqCdAEUOV63EIpEfJgccSs+paW4ENr76l
	XQPAbX4pdA1GEBf1MIotwE/OcmmXR7F/LBk0qIqiw6CLbtyFp0qVEATrNpmMQoHcFAoH/awnURa
	VYUYmIyF/Cot4IYNFOTdhTGdO4rrI1esp1stqvCcf04MlAu4mJGjc9GufznWClQQ8E0PE6YBLLs
	XiPEm9+rY1xLoOdUrw==
X-Received: by 2002:a05:690c:d91:b0:81d:472c:17a8 with SMTP id 00721157ae682-8346a240f02mr6639707b3.0.1786572741543;
        Wed, 12 Aug 2026 15:12:21 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:8bd1:139b:3c08:1f5b])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8346e1a08b7sm2365367b3.37.2026.08.12.15.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 15:12:20 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: konishi.ryusuke@gmail.com,
	hch@lst.de,
	brauner@kernel.org
Cc: linux-nilfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	lilinmao@kylinos.cn,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v3 0/2] nilfs2: eliminate blockdev_direct_IO() call
Date: Wed, 12 Aug 2026 15:11:52 -0700
Message-ID: <20260812221154.1119137-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patchset eliminates blockdev_direct_IO() from
nilfs2 entirely. It adds iomap.h with declaration of iomaps
operations and iomap.c with implementation of
nilfs_iomap_begin(). The nilfs_direct_IO() and the .direct_IO
callback on nilfs_aops are removed. The nilfs_file_read_iter()
dispatches O_DIRECT reads to iomap_dio_rw() using nilfs_iomap_ops.
Everything else still goes through generic_file_read_iter().
The unnecessary "select LEGACY_DIRECT_IO" has been exchanged on
"select FS_IOMAP" in Kconfig.

v2
The bug has been discovered in nilfs_iomap_begin() of patchset's
first version thanks to Linmao Li.

nilfs_iomap_begin() looks up the filesystem block containing the requested
offset and returns the physical address of that block.  However, it sets
iomap->offset to the original, possibly sub-block, offset while leaving
iomap->addr at the start of the physical block.

iomap_sector() adds the difference between the I/O position and
iomap->offset to iomap->addr.  For an O_DIRECT read at offset 512 on a
filesystem with 4 KiB blocks, the two file offsets are equal and the I/O is
therefore submitted at the start of the physical block instead of 512 bytes
into it.  iomap direct I/O permits this alignment when the device logical
block size is 512 bytes.

Describe mapped and hole extents from the filesystem-block-aligned file
offset.  This makes the physical and file offsets refer to the same byte.
It also prevents a one-block hole mapping from extending into the following
block.

v3
Ryusuke Konishi has found issues with generic/418 and generic/465
test-cases execution. Running xfstests generic/418 and generic/465
fail with a "broken bmap" error, causing the filesystem to remount
read-only for the second version of the patchset. This happens
because iomap_dio_rw() is called without holding the shared
inode lock. Adding inode_lock_shared() for the case of calling
iomap_dio_rw() in nilfs_file_read_iter() resolved the failures
in both generic/418 and generic/465 test-cases.

Viacheslav Dubeyko (2):
  nilfs2: add iomap operations for direct I/O
  nilfs2: switch O_DIRECT to iomap based operations

 fs/nilfs2/Kconfig  |  2 +-
 fs/nilfs2/Makefile |  2 +-
 fs/nilfs2/file.c   | 42 +++++++++++++++++++++++++--
 fs/nilfs2/inode.c  | 13 ---------
 fs/nilfs2/iomap.c  | 72 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/iomap.h  | 13 +++++++++
 6 files changed, 126 insertions(+), 18 deletions(-)
 create mode 100644 fs/nilfs2/iomap.c
 create mode 100644 fs/nilfs2/iomap.h

-- 
2.43.0

