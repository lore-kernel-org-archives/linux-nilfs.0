Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE911643B
	for <linux-nilfs@vger.kernel.org>; Wed, 30 Sep 2026 00:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790727059; cv=none; b=js3/soDRY3QRrED9DurkTv753AXimMUR5kVmU1QlZ55JtR8yMdJoLoltGxI7OEpz2IrtEzSfOQKFcdh2ncg0KYvAaEzeYHZRLH4iNNaijeLyDu9hW54yTFih0H7RmcRplVWloPkij8pjagQeJePsA5yWFp9NoQ6sth+XXn6LkSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790727059; c=relaxed/simple;
	bh=5i5nahGgL3yVacOBGd2z1UIZITTHRQCrFsfTmAF2FRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9B6MgKZWxt6thLLK4YDtHZSJCSjYiaQ8Q/S9CGJzMjKhpC4RI0dX/WXeF1tLwD2DPK8c2iyHhNKCQvsVbzuwshdTDr2Rd876jiz8REgRP7VGdxMdGTmWPVZ0cxY9Y1Xw8ARoVLSn5qP7tkC9yiQGCvFnA6HlHtvjM/hEhA0O58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aRL7HYfc; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRL7HYfc"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-533324e9b13so10388331cf.1
        for <linux-nilfs@vger.kernel.org>; Tue, 29 Sep 2026 17:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790727057; x=1791331857; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k8wPVuH2gUQgwmk+EmiuyQ/d5nhnIH6yITLCFIyBiFw=;
        b=aRL7HYfcpfJiwwKvKeSa/Puy2bkC+XaVk9lP3Seh7tMZn9hFsu+LAPjau05BV2HeXa
         r+Bx2Cv6FsJM/PFQqAQY3OIcVhNCxNEM0Kc4UEi3eiCQ1u4yzN8nd7+3QbITxSSqxYPA
         oNv4vWWQrdjvag7TwWGPE3qyquD2ZgYY7Mp8WZz8HjmqgREc0cklYlr7gUXQg/gRBzY4
         5+9YGRx/IG1hvxROFwPW/LwnJDwuoVZZtwGzjnv0h8jLwLNRBB+x5QIEz8JoSIIi5czW
         ktwiMNMZB1A+cErkxxiJ0nedmhGtvuxUzPpIYY86OJbVbFBfLrqGPcpgPzlYer1DZL4/
         52ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790727057; x=1791331857;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k8wPVuH2gUQgwmk+EmiuyQ/d5nhnIH6yITLCFIyBiFw=;
        b=ZUnA5XCFzS3xciqRz0kYlBbp6RHOVZTzorVaVNkGO4zuWlp3uv9d3BcCgKsgTMOqBy
         2FbR9y+B8bTojdwcEJLaevE0c2ogbgUBDq8DujfJdxnfv44B3oxKpYHAw4CFwHtlG2oP
         faEZGaxsQNTwoL2MWlcCTXe4rNJHy3MVWyC7Te2YERJtx4bZ+/IWk/l+FF2l1wbMKwAb
         xKA3Kvvq4QfKjYUjzQK4sc2TmVb215bpDZInSLZgfiaqSTopZ8QDjm/Gh5dvvaTqUxhP
         KJlGPxVuKZRJBIMw1DuyHdeweyl9vXG2GRm/AvaMllerljrAiudzah2sqXOyWAl+BOn9
         cSNA==
X-Gm-Message-State: AFuF++mD2DQ95x2OjQQsxmU97aCoCa0gCfQeCxSOUpanI7V56nnkaQWK
	eCmyap4UYIMDyrdWT92Lf2F8nQGmUXXtIGRDHjaAKAisXajJdr6fizNxFRRbYQ==
X-Gm-Gg: AYBFou2y2m9dKieMmfnjUt6J8dgpIDbGtiS7U6FJW6ivrQgYNamPcCKldHQFvhL5ZRr
	iU/LEuwIeaIDLS+xpxiCRrVrq/ZXcuyUGlH+AmZ/11a9YEIryFF5JuK0Yr2GLGfM/YIMRRPMe6q
	qiOovFL50BAWdP3T/2llj6ujAbY3Ltv+W0iZDA43NHmNa6fTHYfb843vLNaBwgqx1AnY36ZuNh9
	8jUL0jS/usd+MU6T9YzZR/193ah/IfkDyZifKruqaDty8ZBSsm/W18HrL/ZqmrsvHLBOtl7Pe1E
	OkKlQQkhE6JwX0FrzLgZYYdU7rob9gCpnc1Peo1bZujkndyGcbYPHS6gN0ZbORV6KdSMfxuOh21
	/shTzIFLIZBa22yxR9/4x/8JCep9ahVS4U143nihD+qmK18cqB0Rr8o6YR6tshUmOdHAb3mx6JD
	sVpZIAZZNcMvwBMpnsehunwqyynS+N48uCWte3EDwSHAP7LVn3fQquuiVhf8FJyvaljkl9iP1Uc
	kKkeTqhttZCnJ04kDQCprbRT8+JuN72rdQr8rU=
X-Received: by 2002:a05:622a:58cc:b0:533:39eb:8d42 with SMTP id d75a77b69052e-533581050c3mr84239141cf.21.1790727057097;
        Tue, 29 Sep 2026 17:10:57 -0700 (PDT)
Received: from jake-B450-I-AORUS-PRO-WIFI ([73.194.254.128])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53369b9f477sm7175391cf.19.2026.09.29.17.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 17:10:56 -0700 (PDT)
From: Jake Labelle <southampton.jake.labelle@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org
Subject: [PATCH v2 0/2] nilfs2: harden dsync recovery and readdir
Date: Tue, 29 Sep 2026 20:09:50 -0400
Message-ID: <20260930000954.371774-1-southampton.jake.labelle@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Ryusuke,

Sorry for the late reply, busy getting the flu 😄. I've put your
review comments from v1 into the changes below.

While reviewing fs/nilfs2 I found two robustness issues with corrupted
(or malformed) filesystem images, both dating back to the initial merge
of nilfs2:

Patch 1: roll-forward recovery replays dsync logs without checking that
the designated inode is one of the types that actually have a bmap. A
log entry naming some other inode type leads nilfs_get_block() to an
uninitialized bmap and an indirect call through uninitialized memory.
With the patch, mount of such an image fails cleanly with -EINVAL.

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

Changes in v2 (per Ryusuke Konishi's review of v1):
- Patch 1: also accept S_ISDIR/S_ISLNK (not just S_ISREG), wrap the
  check in likely(), return -EINVAL instead of -EIO.
- Patch 2: hoist nilfs_chunk_size(inode) into a local chunk_size
  variable; expanded the comment on why chunk-aligned offsets are
  already trustworthy without a chain walk.

Jake Labelle (2):
  nilfs2: reject non-regular inodes in dsync recovery
  nilfs2: validate directory position after llseek in readdir

 fs/nilfs2/dir.c      | 33 +++++++++++++++++++++++++++++++++
 fs/nilfs2/recovery.c | 17 +++++++++++++++++
 2 files changed, 50 insertions(+)

-- 
2.43.0

