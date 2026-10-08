Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791B648E0FF
	for <linux-nilfs@vger.kernel.org>; Thu,  8 Oct 2026 11:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460398; cv=none; b=mFiS7izgYeKiWWQVMlHzLGarICZccbbiSo82Wtw6jSaBhcPvtXG1WghaYx+a4V4Zas7oiWF/ymwSj3kpY0MdbiHrBlDRvTth/uFJ/0zqkrdaFtWCE18r5r9y3y9qr4ZDpltJhrUFwcCQPST4/eRj/+Ly0isxQ9k3m5kcE4oFfp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460398; c=relaxed/simple;
	bh=aplZdT+SUciUNx7wLWHE1WIyitdllN3DIch/NmyPwLo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fpav49MMrKYZe6poebvFDgbIqEWDHy5YcGfUvCC8r3BQ01wHvFYtWcLDx7a2JapGWTlgTJEQDY/PAaYX0mU9+dsOd5o2LjmqjShIprfzCGp6eax4zxLRRWA1HFyq3GZb4bBZgbcGF2zXKgtIev+jZsso1E4JMFWZqg6dYm4w6lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ieMdl9JB; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ieMdl9JB"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3a4d455ace3so2973791a91.0
        for <linux-nilfs@vger.kernel.org>; Thu, 08 Oct 2026 04:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791460397; x=1792065197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pORXAQAlb7DhrMRDqcuEGOhapDhJ6cJiXRLHYOoZZBA=;
        b=ieMdl9JBU7htgRVzQ2f+1OnlQhgQVylAuAOMp7jKw0im05vsv1pUT8CMXfxgmDUOGt
         ow9MYHuMAWVlmPviipeht3xzjMHe7ozCBmJ1n+/vVw05+FRIfKJBqLdBLtr5FXq2bTEH
         6hSMEA1FvF5Hkka10rX53ZLuHWQbfCeo/48cYIaXPyOGwiic6A32XOUHM4h2lqL8CsWi
         qDuRhHh9vlSr43upUCXpuIMl/e9JQ2xqbWrTmwichRVlP0rrqeVjvIlNPMJcS5b04dr8
         j6qjHgpE2VxsUHRTaDFTGNjTHD0yAIGHS6b/W0TwkAhEJZJSlIhojwSWlXPoaJJfvC1N
         Bm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791460397; x=1792065197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pORXAQAlb7DhrMRDqcuEGOhapDhJ6cJiXRLHYOoZZBA=;
        b=mW1NigMP58cGDwdZw/5xO9lPGkArJfLuNn+RyVmQE0XfBjceT2TO7vf9oGyWU9a/pk
         yT3MFTqk28hanei7sBcpq5xom/mNFG0sD2STlHKOf9ob/bXRs5Hu/scTnLmr3kCDZ1V6
         cmmW4wFGSeC+qbGTUo/1eojkEVH1AepJRUx+1VqNUBhrbP/FeVZ+Q8zgqb62Wn2U3mpB
         4bjgv8HcEhLdSk1qYZQsIjeudrlZqu4h1J3jYy8v3GD+jnuYwrlFmNCPvc01So0o9HTY
         G8Jc4Mi/JqX1RPGOUKle8FLO1Rl/hiSiTKbnHofw2t26SO0kb+iB+FcbL6VGaupGszmv
         MJHA==
X-Gm-Message-State: AFq9FYICimdZd+sUOgPvo+KYRhZud5ERHAfPQJYuNe4Z8c/Vvtqj2yES
	Vvs5r2qRNPvYQlAoPWqRSuXOJicU88h9nm7g0AQileDcfLOReQXoqsHp
X-Gm-Gg: AYBFou0wuANvujeXDagqT9DZ8x8p0M6+exPHXP40K0shdwTWU5w/jaWyPUStKBUCxmk
	nX/gv5ZeFugBEXpyh3xGicmE0u3FcoHQa/AuPB+wVj3VAKA8uagfQSVPi18Q9xSFsINYkdqVfhF
	TFzYybmRV22+VxDE8qtV278Apa/HrmObL6Odk7CCdhQsu7FDE5Y341BaSVusgZ5ea3CBBXokg4t
	FXlppZ4g0y2FRaKz1qcLRovwi+uvqGXrBZuRLUtFP/x0D90rXP8xKP2n9Y7HzURkOpqKtuUtLYC
	7v+erWbE/kMbt14NH75oNgKC0fsbNh/aoR9j0b9L4kigElS8khwFjWXgUz7vepWmbmVEQwCtawV
	jUu247Ct+WbZuUOGBOfqH/nSw3JFDwzLFYgJdmHEpVj5Q8tkyDLlXI83RVQVL7hh644DmPCQOVl
	wszjRCS1o0uOO0p7OdtckJnwYSfdMcXkbYmi5aB6NHBlMR4zXCStJPL+0fO5UCKp7GDhPOoASeE
	DGXFT+OtcVZa72igQ6FwsoHhg0isY7W5MTICgmu+Q==
X-Received: by 2002:a17:90b:560e:b0:3a4:c946:9f4e with SMTP id 98e67ed59e1d1-3a8a151f240mr4255704a91.58.1791460396754;
        Thu, 08 Oct 2026 04:53:16 -0700 (PDT)
Received: from carrot.taila25129.ts.net (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9f1c17b63sm4760164a91.12.2026.10.08.04.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 04:53:15 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jake Labelle <southampton.jake.labelle@gmail.com>
Subject: [PATCH 0/2] nilfs2: robustness fixes from Jake Labelle
Date: Thu,  8 Oct 2026 20:52:46 +0900
Message-ID: <20261008115312.18482-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Viacheslav,

Please add the following two commits from Jake Labelle to your queue
for the next cycle.

As this cycle is getting closer to its end, I am sending these ahead with
a minor fix applied.  If Jake responds with further comments or revised
proposals later, we can discuss them as needed.

These patches address two robustness issues:

- Patch 1/2 rejects special inodes during dsync recovery to prevent
  dereferencing uninitialized bmap function pointers.
- Patch 2/2 validates and snaps the directory position after llseek in
  nilfs_readdir() to prevent invalid or out-of-bounds page reads.

For full context and background details, please refer to the original
cover letter here:

https://lore.kernel.org/all/20260930000954.371774-1-southampton.jake.labelle@gmail.com

Thanks,
Ryusuke Konishi

Jake Labelle (2):
  nilfs2: reject non-regular inodes in dsync recovery
  nilfs2: validate directory position after llseek in readdir

 fs/nilfs2/dir.c      | 34 ++++++++++++++++++++++++++++++++++
 fs/nilfs2/recovery.c | 17 +++++++++++++++++
 2 files changed, 51 insertions(+)

-- 
2.53.0

