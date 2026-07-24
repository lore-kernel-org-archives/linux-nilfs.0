Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D973B30149F
	for <linux-nilfs@vger.kernel.org>; Fri, 24 Jul 2026 22:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784932086; cv=none; b=ggGr939Jwb06rzvdInujSMbnWhkQH/l7Lic/h2CJ0GU6nfDXvgWvAHwe8CPRHPl8Yp454D0jvS1h7sryRjTeoQcCzqMSESmriJxppOVw3YR/NcgNKT7s8YL1iuav9F4ysoJDj3PMBiQKbzRZFI6nMp2fsNWgJnyCPAsG7gojXeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784932086; c=relaxed/simple;
	bh=hosF7z1IjblzSdT4WinSYBZoR+ua9jNC4c9AyrOeQM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cqQ6s9pGB3kLY+DJpRYb4RP8Ve+eiZxF5TrQeMGA6SHNppXuSHc6D3nHKMiAVYsJlSo2svBWWJM0Ixedze7aIG9u4Qh7lGvfRoqoH2X0TPztU2+9rH5V/YPUFL0wrbKwQAky6mNScRIqufu+kiYBLn7sAgVS2xqjIS8OQcTZmcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=GZinzTpv; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="GZinzTpv"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6685001353fso735784d50.1
        for <linux-nilfs@vger.kernel.org>; Fri, 24 Jul 2026 15:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1784932083; x=1785536883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MuRKRBkTVuDLBRY/ApmyBhrmpdyr3e8z0LFxN8l5L54=;
        b=GZinzTpvjt9HHKW5UqLD052Am7zcw6AlSpI0G1jcUa+0HHhO5fu/KK6wHFhxGv8g5o
         V1dHyKCEFlIu/tuaC+wDoFDvUB09p297rkGSvJJ0KJ5chpCiU89/OafFaUdlCoJ25RiV
         jZ58er/DLDzp4ezevUjXnis5vTz4zK0CV+RO27IG+8JI4yb4N/NFDw/dt27rYZNVOQ0w
         Xxt9eg9T/Qqz3VFazS7pa7NJsyt+Vu0ZpNc1MTKglYR1BpQF4AHCiBFc8k5eWL6khSvH
         Uk3NljT/jSM77vr+Ni66QFNl7UF3JMUduvez5L14TiLecO8x8mgHujpPvLeU96tVfV/m
         IAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784932083; x=1785536883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MuRKRBkTVuDLBRY/ApmyBhrmpdyr3e8z0LFxN8l5L54=;
        b=ee3vKErtOrVnBiqbaXHSmQ/0H1ZpAgm698V4VBUece5N+Bq9eANynLjSAPxgoUU4Fi
         eRd4V39NMlhaX4SM/Dgoow6IpyfyWdQqi1UzbUz1DPqQPUNPVXcUQTJA7MYRu0/1lSvv
         obQ7I0xOElPtleJyIR8emBQKLBADRDUi0/CrMsVmTW9K7IcNxME/leY0u6FihgKzDdCA
         TJQeayGUy2iTVUAqVvbTUeBb09IYRYtuQbHxL/+6medcSbzXjkfIxZHsN+9W+F4Fgq3Q
         wml60pmu3++3UHpINv+3bQcGiu7uQ786dv72Y7fXNqGjdpq1tz+YR0HLCxJI9dTjy+l7
         36dg==
X-Gm-Message-State: AOJu0YxZ5jl7/ZzmuKVtJ9i0A8UGbwi3O4b0qPp1S8ek/JQtmHUkqey2
	PnPD9LEZMYKnDiq8kgM4dVTgVXHRBHgHWuSQKPwXCObs4g6Dyv8UFdCfK8z2d6GJHbhnc+AI8Pq
	KhnYEDgo=
X-Gm-Gg: AR+sD11x8lhhAH2Rn2o7EmeLexXMMc/PK0oGjnnNWZ57YJ36i0SsaD7gVopi66Y76zM
	NwlkxRw8AOGHuh5RWNlWUv1UvBhbv1rlb1VIHbG01d1GHfK3Wq2kgh+/pvyGDl/z949eYrDzA1L
	eigM/Oy7jXWpgPX9eUlLsaDsRc8E2Pu4lNd7o87tHCSihv2uZyI/OdDwyouoohIBLjfNRNy6hzl
	pl0NQoe7R4bvgdR/0lBC4pKlVOVDw49OOhOwp+g9tM831lkCxjRBkzCHrHzzmSO6/OAE/yK3M71
	xblG45Q5CvIXWe0fWrP5hPMp0ffyjpt95b49jGYtTW/+mvYjw7GMGoweTaKY14X3dFcfq4qAPic
	UYmxZHL6sf+gpZ9UpFhmrtKaeFa2I/LLorLftDNircrLLS5TrB44LEq6xv3isDtKcxXFjo8jo7C
	aFq56vmM7uBdk6l1MMZjA0LeRRTQInDjhwV3g/08rS0Yk7+SQRxsD8WsEZcpNJ5jheLb5Z5Ckuy
	lopJhcA/AjwLNyaBeUcjwvTgjgRp+9cMLk=
X-Received: by 2002:a05:690e:13cc:b0:667:838f:cd2b with SMTP id 956f58d0204a3-668c7ab51b5mr35323d50.63.1784932082748;
        Fri, 24 Jul 2026 15:28:02 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:62ee:74f6:cfbb:28e0])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-668c7041256sm90525d50.19.2026.07.24.15.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:28:02 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: konishi.ryusuke@gmail.com,
	hch@lst.de
Cc: linux-nilfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 0/2] nilfs2: convert O_DIRECT reads to iomap
Date: Fri, 24 Jul 2026 15:27:43 -0700
Message-ID: <20260724222745.2107464-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series removes NILFS2 using of blockdev_direct_IO() by
converting the O_DIRECT read path to iomap. NILFS2 is
a log-structured, copy-on-write filesystem, which makes it
a poor fit for a full iomap conversion. Newly allocated blocks
are delay-allocated by nilfs_get_block() and only receive a real
disk address when the segment constructor writes them out
as part of a log. The segment constructor walks buffer_head lists
directly and is not integrated with the generic address_space
writeback path. First patch adds a new, read-only nilfs_iomap_ops
wrapping the existing nilfs_bmap_lookup_contig() lookup.
The second patch wires that ops table into O_DIRECT reads via
iomap_dio_rw(), sets FMODE_CAN_ODIRECT explicitly on open, and
removes nilfs_direct_IO() and the .direct_IO callback entirely.
O_DIRECT writes are explicitly downgraded to the ordinary buffered
write path in nilfs_file_write_iter().

Viacheslav Dubeyko (2):
  nilfs2: add iomap operations for direct I/O reads
  nilfs2: switch O_DIRECT reads to iomap

 fs/nilfs2/Kconfig  |  2 +-
 fs/nilfs2/Makefile |  2 +-
 fs/nilfs2/file.c   | 40 ++++++++++++++++++++++++--
 fs/nilfs2/inode.c  | 13 ---------
 fs/nilfs2/iomap.c  | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/iomap.h  | 13 +++++++++
 6 files changed, 123 insertions(+), 18 deletions(-)
 create mode 100644 fs/nilfs2/iomap.c
 create mode 100644 fs/nilfs2/iomap.h

-- 
2.43.0

