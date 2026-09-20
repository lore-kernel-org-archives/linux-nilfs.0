Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2C43DB964
	for <linux-nilfs@vger.kernel.org>; Sun, 20 Sep 2026 20:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789937746; cv=none; b=Pm2154i6iFrevYeiLpzxMf15bfrRSl05aCoZfz4S/se4+OVxFxw5xXen20bh3BxEYt3Ue6ZP0e2acplNxOUtGQs+l4l7Mbs6dSxyqsnmkkBZZm++Bc+EqRP8icSLkeHLacCQrGDxFOGCM5+RViaTk9QaC7vNNBNH/ipUchs6uk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789937746; c=relaxed/simple;
	bh=+FkLzLYvYMRUTNkmBWP9E4Wiqz47uOMW79iHVKnMbPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lp61Yju0g8v/+mcFEdmbg6f3KKCNWjWbGgOt9IK0iXtpz26w7NptcUgmoEbrqAUkc0OpNLCmdU48eXCosaQ8k/RTVya5PpwlOnDGcqvIovdQG4tXEaDCAGBI5tgv3ikmzp0bMd4P3MZ5cyNQTGuNfSDUtZo4bN5V3/BvBGP7iQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RpXzhcNV; arc=none smtp.client-ip=74.125.230.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RpXzhcNV"
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-5329fc7b325so15823561cf.0
        for <linux-nilfs@vger.kernel.org>; Sun, 20 Sep 2026 13:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789937744; x=1790542544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KyVcAhqKGm1oeFlxHMif/Qn368a2+Dnvz7RPTWu+i9U=;
        b=RpXzhcNVI35uQk3kWNz3TWcAbctsjX9s6aJIOTmCz+egqlcZ04fb5XKGOh2PwSyDPs
         i1i/ErMbzeFJINw/WfnUoqcsFb8ikGejqLvLK/rNLUqB28yKDXjaY0OHEYXxi6MlE7at
         tg780rYfaIqGzYO7G0corOBEtsvUZH1f0lbgOs1LWOSVOu//yjxCPj7iObdJbj+HWG6S
         +YBdsAMu2Pz78eRSTeK3u6YBX7yVmpXhnrqUzKh5F+tOXFsI8E9XnMW6/PSeOfRL6/ym
         h0eGRmdKuWch7fEe3hhqxMYXi2AJePP1G+LNzYsJsy0Wyx5mFZGoqUuGR15RQfturep5
         k0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789937744; x=1790542544;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KyVcAhqKGm1oeFlxHMif/Qn368a2+Dnvz7RPTWu+i9U=;
        b=Oo4wb/oKqEw4YILbRKIexM7/D0kcOvCxFfJyL/5PnbXMAN9McPI73Z54vOTaQxAsep
         KV6oOVWGKD7eaVuwiyb3l5fblGhCZIVIUsP2oOy6HLWo5h872ky1MwLBb9ctDMjpkQ/7
         M154fPcMbdiRRKZbiROOh0CLm/Xlhv2w8iG/g767QUekOyu653xZOMTwiUtCneZyy++x
         7Q3MRqb00ABGZ+aeDydM7NQe1rnxippacSrtr38uhqDtdah+zp2u2dipc6AX606H9Zql
         CLmexG7nZ/g4Kstcb4bzC/m3GrrfAoFj1LkDD0eFmkna8bn4RaRTElEtOL5Hv9VZeIE2
         BNzQ==
X-Gm-Message-State: AFuF++mQPv5TvCZDwwG5lpZ5HNQUN+f+B0h+PdIj/XytWcKI1iw2EHem
	8QaaFEQE0S3gDrWXW7mpmM7oo1C63pip9luw8zhTxq+eQU99ESkCa3/is2zeinuo
X-Gm-Gg: AYBFou1CONG+RzClh95UJXaM7zA0uqKHSG3BKDf/LBk7ZmpRmjoBtdcXzDL1892Ar9J
	hB8EEWmVrXlFY3z+BBDgPNYzjasb9EfaeaQStM04hZUxMfCHl/K/vYVTeoQy79d2n+bxPXNTlzf
	XOjJ0p5obPNo5XSMJ6X+ujwNJGv6GYC2B7KF6NCAsaPRFKq7eZLzTGLinZ0ap19vmM1kp74ayba
	NoG2PQ8SVNETrf9onfOwleHI6hRn//6wttqgwn/5+AQ1WqJhjZt9cZQsHyNqo92kIv+ukpLeMK6
	t9OnpqoQKHw4W1ntJOr/mG9hikQj6VCNAFJZP3cfzS9xXFlUeJa+aH7wgcyKNXZiLEDmbEv0az0
	rWzzJxRK5jUPgRIA/9ZyNMuTGgfKfes5jxTFIuo/bnrmNLe8Pmynf67KS4Ti7Wft1dr19Cr1gNf
	LhNYyYrRYBQwTen8c9ANNFZRAEnr1vQKy0f+UuWZS8AxQuB/iIF6J8RO/H+gjouLXBkbmUluaqg
	fQ1ghFutHpiNwYCubwVzAMdypxoP/meaql3sesU
X-Received: by 2002:a05:622a:1651:b0:530:cb42:3bc6 with SMTP id d75a77b69052e-532b71b8bdemr76231901cf.10.1789937743742;
        Sun, 20 Sep 2026 13:55:43 -0700 (PDT)
Received: from jake-B450-I-AORUS-PRO-WIFI ([2601:84:8f81:33f0:4668:3d1a:1c3d:3767])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532ae511d1fsm48075091cf.3.2026.09.20.13.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 13:55:43 -0700 (PDT)
From: Jake Labelle <southampton.jake.labelle@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org
Subject: [PATCH 0/2] nilfs2: harden dsync recovery and readdir
Date: Sun, 20 Sep 2026 16:55:30 -0400
Message-ID: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While reviewing fs/nilfs2 I found two robustness issues with corrupted
(or malformed) filesystem images, both dating back to the initial merge
of nilfs2:

Patch 1: roll-forward recovery replays dsync logs without checking that
the designated inode is a regular file.  A log entry naming a special
inode leads nilfs_get_block() to an uninitialized bmap and an indirect
call through uninitialized memory.  With the patch, mount of such an
image fails cleanly with -EIO.

Patch 2: nilfs_readdir() parses the directory folio at whatever offset
llseek left in ctx->pos, without snapping it onto an entry boundary the
way ext2's ext2_validate_entry() does.  dir_emit() can then emit bytes
from a bogus entry, reading past the end of the folio.

Both patches were tested against current mainline (arm64): each issue
reproduces before and is resolved after, and a mount/list/create/write/
fsync/remount/read-back pass shows normal operation unaffected.  This
was initially reported through security@kernel.org; per Greg K.H. and
Ryusuke Konishi it is being resubmitted here for normal public review.
Reproducers (small Python scripts that generate the images) are
available on request.

These patches were developed with AI assistance (Anthropic Claude) and
manually reviewed and tested.

Jake Labelle (2):
  nilfs2: reject non-regular inodes in dsync recovery
  nilfs2: validate directory position after llseek in readdir

 fs/nilfs2/dir.c      | 27 +++++++++++++++++++++++++++
 fs/nilfs2/recovery.c | 13 +++++++++++++
 2 files changed, 40 insertions(+)

-- 
2.43.0

