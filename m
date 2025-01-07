Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35071132111;
	Tue,  7 Jan 2025 20:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736280131; cv=none; b=CKoDk9CrPdBwAF9EH2nPxWpUrtP9Mj1RfhGgEIoTfCxje9/DtThkSFv2ZJN9AM/+LuWu+6RAR/U0hJym5U1UgqBCWAp6rK+2JiXEn0ao7+bVkcLRnMyC7mEOyXTPAQJVpENqXs5z5CPAmRDxlX5FL0J3P27qomnMd9ieb0NEIc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736280131; c=relaxed/simple;
	bh=Dj+QtsVIwRWr0G+vnWsFrnKvyK510zc34B8TpmU+Aj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egIdG2BOtrJpMnjrPVu6MKR/diQcq9uSm38pcGcQgS5A7cK93m2bTRLdzpWMIPuOjrCM2LSMePPdjaMuhc1eGvdaz6ba++8R/9EXedHGB4ieCSAgnZg3s+Ktkd/2SitfgzL/lu+mXMcCAex3kWSpiA/klpZ/rts+ySC/60XiGCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YHn4dMws; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YHn4dMws"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21a7ed0155cso16042435ad.3;
        Tue, 07 Jan 2025 12:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736280128; x=1736884928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pEXnpNYgnzzpw/MCazpm+/Hji1cT0Spgp/MB/7AnKJk=;
        b=YHn4dMwsxe5NWXenRWGAbZKegNwrOBirJV654IipXqHzD9xnVQAZJyM/34x7Y7i3k2
         iwX0y8zGSra11z8ya8xp6jG6Mv2C8ewieGNySnSURAa60M6aOB1QpYVmyYLZPSjYl1Ql
         xb8wyxekOh7BiXP2btYv2K+iN8luhw06GxDF1EoNNY/gF1JmZXtGqmTLnzN8TN7PcJZy
         DwVV/rWUeQGgogs6Je/jE0r1eJMS1fB9mO/9Vp7plvU2IlM0J2ljPXQ3NoWj6rLeiwoy
         PBqtgbdxrwzGWwbyGaEVIMX8n5/Fq6r5RX351JtCJh0UnbKV0XEj/WfqK6za6ZbI+hqQ
         6TyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736280128; x=1736884928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pEXnpNYgnzzpw/MCazpm+/Hji1cT0Spgp/MB/7AnKJk=;
        b=ISUGWFdDoiwUsRAYIhFzZ3TUuFuZe+2oh1IzOPNAzfMoBAVblwJneeAVsYSUrfHTEn
         6vTUgKFYF+fJSboHmEPpZ9veelVJwQrx0eZ1c4uQFZeTUnbIAboMIDI/zXdgG575XNW3
         LOtXkbkl4S9teNJhSnAu8ssusv+zd4ZcbOR9ArtIKl0eHTJNgpnhB8/S6FPIotBxHFdE
         h6mcFFC0mnk0JHi5UKvZrppEKXFUDBLKL2Vv3pBa2nuZiLBScioPOzmNCqX5Y0jHubws
         wZRrKJzEYl04lKzKqvkXMWFbZt3BtOMwbc6FbR8HBnmGViWgHRjD8tVwvAZCsoTUMYKc
         LD0A==
X-Forwarded-Encrypted: i=1; AJvYcCVHRtw9Pfdi6Q1xQUPtPIPjEOhg+8+CEPjLRNf0lMV4eiXRhqmI7HMraa4Yeg/hIoVBER/DzaWuCxkpUe0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiOIDHMbkQnptp3zrB2vPf0HHOuqKQz7ocMBq376X27Tcu4a+a
	iJJHYDp2h7bzlbsTT5e/RBfxSFzao0PsZccGgwVFD1EXBe1ZUWeL09oAXg==
X-Gm-Gg: ASbGncsHQglNgFJV12Pm89slMceHynntNtk4WsEI3xDR3XqLzcyuh02MteK9TVpkO2O
	paIM/6ioAadIEJ54eoJh7SPdwpY2QHIEIEFbhkUp8ZrfrZW8+9xB5bOQWzgD8VBlFPdnrW2JjDD
	aW1mX5dYD+3akaObrmI+bufdrcRTUj9rBoi3qhV6nMAK63Ju8y9KNI4yLhguZnybBMSZsyy452p
	MO/F2lZttQCQnUhw+HAw9R5O/YlxgkCdXLe3JHugTw+kbCVuNJhtGpP9NW29VLRCjf/IvBi3B1Z
	+HK8Zvsk9/N7fv6/ly3KNEw804CG
X-Google-Smtp-Source: AGHT+IFshM9mOJHMaujh9bOkVbGZrgJQi+w3zqG2AZCXQEh03WdcFNizDZPE6nvycKekvDd8b+sT7A==
X-Received: by 2002:a17:903:1248:b0:216:282d:c67b with SMTP id d9443c01a7336-21a83fc042dmr4870595ad.35.1736280128401;
        Tue, 07 Jan 2025 12:02:08 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dca02b3fsm314332365ad.244.2025.01.07.12.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 12:02:07 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com,
	syzbot+d98fd19acd08b36ff422@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] nilfs2: protect busy buffer heads from being force-cleared
Date: Wed,  8 Jan 2025 05:00:45 +0900
Message-ID: <20250107200202.6432-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <670ea678.050a0220.d5849.000b.GAE@google.com>
References: <670ea678.050a0220.d5849.000b.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew, please queue this series for the next cycle.

This series fixes the buffer head state inconsistency issues reported by
syzbot that occurs when the filesystem is corrupted and falls back to
read-only, and the associated buffer head use-after-free issue.

Thanks,
Ryusuke Konishi

Ryusuke Konishi (2):
  nilfs2: do not force clear folio if buffer is referenced
  nilfs2: protect access to buffers with no active references

 fs/nilfs2/page.c    | 31 +++++++++++++++++++++++++++----
 fs/nilfs2/segment.c |  4 +++-
 2 files changed, 30 insertions(+), 5 deletions(-)

-- 
2.43.0

