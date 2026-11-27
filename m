Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795754560;
	b=ygYmY56ibPgZUra/VDrnHW5pjXF9P24WAfxh0O9QwKNKWtfMM83MeFIj1EeokfMsUKF1
	 S5eOFtTjZ+uYE57LtnVSH5E07EUmu1UKXuacCwjmHpLXiub5xzw+amys7Do0rYxWvENZG
	 Vnk2CFtMCI8SzlJgOF+2bqOVey6siNpjbZdAEea8aIsteQCAdXf/UScwHbg7eov5ALYo8
	 GspsjtRh0quKPd4hU4uSwRDUi5qpoOy5gsOx6khou6mlT1sasHtFktMzc76t67hAOU7cl
	 Xln9ERMqn9TsyAIj+rL8d5lHQDPeUugLGHQDdke+JK71xkBERKcuoFTFJYWTbRixZog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795754560;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fTkNUFbOEJacY/AArIMMZE4synA3rFS1O0j/Gy2pLMc=;
	b=XSRC3FjboNqdpUr970/gs1iPB/5nci8UY8Uxu453VIAos0QFAe8FgLUQK7kOsSUHyPMB
	 /7a+B8QmXRJAHNJNmbFEB0oO8SF3zSLp2t9LDSygSXeiZbRuNxrOLnUcraQSiMBv2h7TY
	 tIaOy8XZ2OLGahdZ0ZaqhUWIublbO/Zp7BkMDNJ3DsJdwavIb74slX1ZE+2MZe0MaOQdk
	 utsEMC3WeVCFbEAiHY93nsDHDNuvlNPld0sIjqGQDsrP0LZBMHVCGBgl5bECEZ/aaLV6F
	 +3tC9beOeMBAdv/OIvDJs4mqyoEj90+Zj7V23Kv7rquT6YBf+5BMoe7zcfR1zUbxZDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w4bQNgov;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AB7606A68C
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Nov 2026 04:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9AB7606A68C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w4bQNgov
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-14394530ec6so1439240c88.1
        for <linux-nilfs@vger.kernel.org>; Thu, 26 Nov 2026 20:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795754556; x=1796359356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fTkNUFbOEJacY/AArIMMZE4synA3rFS1O0j/Gy2pLMc=;
        b=w4bQNgovzBqbn7wxOtFeBfzCfEE0u5Fil39UVkVXhFPypQYAdMCS1RQ+grYYbfB/GZ
         P+5SKNxUSFFzHSISI09IXvqpBKdHMWWLped1dL9ulASEktS8UgtIuYUdUqgcjohqYb+f
         MYLUP144mAKp0vK2ZrL0F1hwmFHh1dU66k+jG2Ld40jQowLRB7wyXe7d69ID9NU9PpO0
         o6kKT06AUBD9IHuGQ8IBOgsmp+Zozg46EMx/CEFIXdXO5wcMs7QuKhcB9UqHwS8YkKdW
         Alfe2fhsS/SxqXGaFNEHedVoBUVxvm9y+0pVY62nNewws/zdJyk4JKIVjnQ5fZqm6pXg
         QZdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795754556; x=1796359356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fTkNUFbOEJacY/AArIMMZE4synA3rFS1O0j/Gy2pLMc=;
        b=pPNMVdyo8D+w+3PZs/s1GDhPS3q7Hea1hv+OieXtDxGkiv7An1g5CHzJdFasce3YKZ
         kUsaLYhjOd0kTYqZVGBhwwTnqGm2iX9znfY8clXHyGkrhmE5fZgW1grf7Jpf8QTpKG9N
         +aoKEd2NVFRG7yKh2JMLE9eccLKeMUYAAmI1aoT/KgOCvk3UZihQ3g6SenaPfLBqNmZi
         jUf2T4ffv5/bOkyazEq1HOTrPQlIhnRWhumd7CMndsAFJv7t2x9uNhUruZs4T8nefL59
         4mGbT6HLjVK8bnift2Za0XhDwebl7VhXc+4/S55M6slvibxRuZY0JN13JjSHJDqdTI2j
         TgFA==
X-Forwarded-Encrypted: i=1; AL+hErFTkj89hWVECUOXFjg9Dm+YNXNiizx48rEo1TZYpaAgpSU+YzQUuEcwb5o9lTj0JVdaQNe4jLINcbOd6Q==@vger.kernel.org
X-Gm-Message-State: APuU4Z8EDMJdCTloV016XTOf4b4YPZs40jaTQLvMNK6mZGLBkTb/dC/l
	Fdajilndf7m6/L3tDmd3DfZtBaSUFdUVVHfH5CAj/zSMy3gfbsKzF1jfsC68ng==
X-Gm-Gg: AZFdTZfpTM/loesj4YvDk7hxiY7OvWznGcunKdT8tjDZPF+qH5gEdiCnOeZIlMaDD8k
	29j5uYiHap974Bln+tn/MH48z3DJ3rjncUKixFJ57CFa8ri/q0j4HY/yA6X8bvnuQ5VeApkYqc7
	djOXJELuN2mUYhT6Mvo36HtrQxeueQfkVWgvib+KD9mQXgoPuUHc/+Mgg2hFdmflwGblO4d38ET
	uRmzBKjBYF3+zxxjLGLNX4wTPl9yf23asT8DywMPsMqK9E9GEWpi1lOxTvw3TyA3b2unT85/yHi
	ueD7n9RQ8b/aNzIlQ8MVHtIzSsdJxpgKlb9FAi6hI4/HxWBof4R83bs1ZLwCAwV/9TJvfVL/T0J
	zECwW3yzO/VCyx7a7Kall7RqXuBlaB2tvZCBAWy7JBjEs8kP0zGXTBgxvv/NN/MeY6WlfFFfVu3
	4QZOgZfVk9orxDgtx7Ay2sewC6Z7EYnqUgcgSNka0Zr5+UAvHZhd0Pd3osqk4S/TlZbF/uwJFAE
	tfq6dk0TDZc4kMs6AtQ7lyQxG75WGFTLvfOpFY8+72z7TzTCJiV72UFvoTc9ZuC3WxN80tNFQDD
	uCQkJebxkVNLKJo4PI+gE0eyFlavuIljHCRbctBxoilaj3JF/6ujWp+a2MO/CmQ1
X-Received: by 2002:a05:7022:f516:b0:143:26cf:8615 with SMTP id a92af1059eb24-1b5568ded03mr20134659c88.25.1795754555855;
        Thu, 26 Nov 2026 20:42:35 -0800 (PST)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556829d31sm88000388c88.9.2026.11.26.20.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:42:34 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Wang Jianjian <wangjianjian3@huawei.com>,
	linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Zheng Zheng <fengaojigui88@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>
Subject: [PATCH 0/8] nilfs2: support GC error rollback and avoid infinite retry hangs
Date: Fri, 27 Nov 2026 13:40:53 +0900
Message-ID: <20261127044231.37630-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Viacheslav,

Please apply this series for the next cycle.

This patch series rectifies an early design flaw in the garbage
collection mechanism itself and fundamentally resolves the task hang
issue seen in the GC ioctl (NILFS_IOCTL_CLEAN_SEGMENTS).  To make GC
safely abortable upon errors, this series strengthens the error-recovery
and rollback logic for metadata updated during GC, specifically segment
usage information (sufile) and virtual block address mappings (DAT).

Historically, NILFS2 GC was designed around a point of no return: once
the log writer started, it looped until a full-format log (including a
checkpoint and a super root) was successfully written out.  Because GC
runs exclusively while holding ns_segctor_sem for writing, any
persistent error during GC blocked the log writer thread and write
operations indefinitely, causing filesystem hangs.

An initial fix by Joshua Crofts (commit ce5a5ad1a833) took the right
direction by introducing an escape path when the filesystem
transitioned to read-only mode (-EROFS).  However, two issues remained:

1. Cached GC inodes were leaked when GC exited on error, which Wang
   Jianjian addressed in the first patch of this series.
2. Persistent errors that do not trigger read-only remounts (such as
   -EIO or -ENOSPC) still caused infinite retry loops, as further
   reported by Zheng Zheng.

Whenever GC aborts mid-way, however, an underlying issue arises:
bailing out of the GC loop leaves irreversible inconsistencies in
on-disk and in-memory metadata.  While this was previously masked
because the escape path was only taken during emergency read-only
degradation, expanding error exits to general errors exposes this
problem, breaking subsequent GC runs and causing userland tools such
as "lssu -l" to fail permanently.

To build upon commit ce5a5ad1a833 and make error exits safe, this
series implements dedicated undo mechanisms for each metadata change
performed during GC before allowing nilfs_clean_segments() to bail
out on general errors:

- Patch 1 (by Wang Jianjian) fixes the GC inode leak on error paths.
- Patch 2 makes physical block location updates in the DAT for
  GC-relocated blocks (other than DAT blocks themselves) reversible by
  restoring them from the shadow mapping on error.
- Patch 3 makes the removal of GC target segment usage entries in
  sufile reversible by saving and restoring them on abort.
- Patch 4 fixes an issue where stale nilfs_redirected flags remain on
  primary DAT buffers when GC is aborted.
- Patches 5-6 make the deletion of obsolete virtual block entries from
  the DAT during GC reversible by saving and restoring them on abort.
- Patch 7 defers this virtual block deletion to a safe stage so that the
  freed entries cannot be reallocated while GC is in progress, which is
  required now that GC can abort mid-way.
- Patch 8 updates nilfs_clean_segments() to bail out immediately on
  errors, retaining only a minimal bounded retry loop for transient
  cases.

Thanks,
Ryusuke Konishi


Ryusuke Konishi (7):
  nilfs2: cancel the relocation of GC-targeted blocks if log writing
    fails
  nilfs2: restore segment usage from the save buffer when aborting GC
  nilfs2: drop redirected buffer flag from DAT when clearing shadow map
  nilfs2: save DAT entry blocks to shadow mapping before freeing
  nilfs2: restore removed DAT entries when aborting GC
  nilfs2: free virtual block numbers just before collecting DAT changes
  nilfs2: avoid infinite retry loop on GC failure

Wang Jianjian (1):
  nilfs2: fix leak of gc inodes on error

 fs/nilfs2/alloc.c   |  14 +++-
 fs/nilfs2/alloc.h   |   3 +-
 fs/nilfs2/bmap.h    |  23 ++++++
 fs/nilfs2/btree.c   |   8 ++
 fs/nilfs2/dat.c     | 181 +++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/dat.h     |   5 +-
 fs/nilfs2/direct.c  |   1 +
 fs/nilfs2/ioctl.c   |  36 +--------
 fs/nilfs2/mdt.c     |  41 ++++++++--
 fs/nilfs2/segment.c | 108 +++++++++++++++++++++++---
 fs/nilfs2/segment.h |   7 ++
 fs/nilfs2/sufile.c  |  27 ++++---
 fs/nilfs2/sufile.h  |  37 ++++-----
 13 files changed, 404 insertions(+), 87 deletions(-)

-- 
2.53.0

