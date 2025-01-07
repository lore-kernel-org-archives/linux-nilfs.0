Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CD0132111;
	Tue,  7 Jan 2025 20:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736280136; cv=none; b=N1mppBeLzZ5xvJSBiokcGeAKo+iXDHy5RPmjI8DWDDK0PcFX6zVyuBkTZ3np0aMeyhyHJc8a6gLcibS+LAuY4N/oxgOkG/92+odas3nLd6Y3tKzQoTiaC/JCTgvuJuRwvo1MnKr4CYyj5OiD7wdIsTvPwISM6/FMN3KnP+UxEuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736280136; c=relaxed/simple;
	bh=cuwZxJdi4JYVUeY3A6mpehmo6jWV8QugCd1uDvnqvJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz1A0gHH+RDB9/KKUOLdfs4mcHXJpjVu3F/GhBApUBXsbrHBYRuBiT1n3nWCm9zPYemXMlHk4KcycwEhpVnUhbMNdV7oRtD3uti5Ahh2p4meikFl7UpYV708DWw0jm+9x49QwbfodvPus0+4mrIU2XzlzvMiNWKZEqUnhWJ+vWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WKVVrbi7; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKVVrbi7"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ef760a1001so23107085a91.0;
        Tue, 07 Jan 2025 12:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736280135; x=1736884935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KxeNmNQGfFXt8t6IHa9ytkj5ANXrlMl2SxLC5Q4jl3g=;
        b=WKVVrbi7R9ALM7zidZn8GRIw69egQC4FETbuldhawTGIDb1V3sLVxVS0ZItobG62pp
         5xtMbAC1FCBHZ/ZU2MtJ4lCUqMyEx9d08YY5yX6yZKDwkzi0qpdrAx6feVzgrVQFbc1o
         ozHkhXMkphJ829Ju3vzTVQJyv53kdvLvvmQ3ONALkWrcznMdDVThAVGgqmjBQATauHj3
         MWxfMVETkVYoerLU0AT5oKwb9KtidGXXMkMcchf72O9qUosDCVLti2MhQaQt8MTarxsx
         4LLGRuXldpghNBecjLRkjXjt8tU6Fxj1xtZ7lNB3lnxeRe3Q9pboCR/OtKP5Dudijhjb
         G5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736280135; x=1736884935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KxeNmNQGfFXt8t6IHa9ytkj5ANXrlMl2SxLC5Q4jl3g=;
        b=cwcKdfZui4a0dqqVWoY40KYBfMI0JDdalc9LGiy3bPik5q8CDmv+xS2DQoZt+Dukeh
         OfBu7OevxQdld8mjk0PXX4Vf94fB5k2l9AXrFqL7MJxFxoFwz7m4Lr0m4tHBhk0j2lWR
         uIHnM4hdsCA+sQz6tkpnbLtemudKbABUaEveIJJKE0Uihpy9AyUjPkX4+M9RECdyHnFm
         EKIi2NpYb+Qy9jAqz2P961LOKsJ5CFtCaGwN2vnSfW5Ti1tmE7qSJYHAbTbH+ctPErNf
         XovG0q5OdHy2imv/sQfbMOPaORFczPri6nGXjmKMg+CF52EnK/VgFTEa917rFfMtaQrm
         gy/w==
X-Forwarded-Encrypted: i=1; AJvYcCUwQpxdmNoCS2qWGpSqWIpURe9nLhdaSQgNKqmOEh4O7YSAa1w66CllC4G3Yo3LcypoHyjgGLEYnbbknCY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOYUcNtMKXx0Mi5NUbrQ/6DcRJ9MtAy0CB1f3R3OBzS7AcXGCo
	J3zlz9YFcPNUwX6Wt6q0ibt1MXyjButgM6bOHG76vB/2+gRYEsp++auMxQ==
X-Gm-Gg: ASbGncsbpw5ge2JpzncWQ2PN8JlgXp+lgrrdn09yfiDM+OASWRMFY6wl8SLitXxvPb4
	jw+2m9YT2pa4NnTxTdRT7wYN5/JRm96KePq8MwVqR9LlikIIRL6ef0oNQTAoNKbgX72V3k+Anxf
	KRDv52PTBFcr9/IGqr8HNbLQZ6L9yBVVZ5nuWOjqjke/ApoGiZwAStNoYfYYoIprCQaGfU0oiog
	h2L7LJ0pFg99z2oCZG1+TkkRUborRk1TVeUSnPu7CDcHhTHkZje0gmZjl/GEo35v9axyz78BXPR
	yvC7c17MEewIScoWrMI4IFkCQWdp
X-Google-Smtp-Source: AGHT+IGE5BvRUXaSRXRjb9VvXyOqunqQl+/8KczkmgjXLMorFq0POxuRTDwEFlkKpMG4qdrdoE0vzw==
X-Received: by 2002:a17:90a:d00c:b0:2ee:aef4:2c5d with SMTP id 98e67ed59e1d1-2f5490a9987mr172904a91.26.1736280134616;
        Tue, 07 Jan 2025 12:02:14 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dca02b3fsm314332365ad.244.2025.01.07.12.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 12:02:13 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com,
	syzbot+d98fd19acd08b36ff422@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] nilfs2: protect access to buffers with no active references
Date: Wed,  8 Jan 2025 05:00:47 +0900
Message-ID: <20250107200202.6432-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250107200202.6432-1-konishi.ryusuke@gmail.com>
References: <670ea678.050a0220.d5849.000b.GAE@google.com>
 <20250107200202.6432-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_lookup_dirty_data_buffers(), which iterates through the buffers
attached to dirty data folios/pages, accesses the attached buffers
without locking the folios/pages.

For data cache, nilfs_clear_folio_dirty() may be called asynchronously
when the file system degenerates to read only, so
nilfs_lookup_dirty_data_buffers() still has the potential to cause use
after free issues when buffers lose the protection of their dirty state
midway due to this asynchronous clearing and are unintentionally freed
by try_to_free_buffers().

Eliminate this race issue by adjusting the lock section in this
function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
---
 fs/nilfs2/segment.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 587251830897..58a598b548fa 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -734,7 +734,6 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 		if (!head)
 			head = create_empty_buffers(folio,
 					i_blocksize(inode), 0);
-		folio_unlock(folio);
 
 		bh = head;
 		do {
@@ -744,11 +743,14 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 			list_add_tail(&bh->b_assoc_buffers, listp);
 			ndirties++;
 			if (unlikely(ndirties >= nlimit)) {
+				folio_unlock(folio);
 				folio_batch_release(&fbatch);
 				cond_resched();
 				return ndirties;
 			}
 		} while (bh = bh->b_this_page, bh != head);
+
+		folio_unlock(folio);
 	}
 	folio_batch_release(&fbatch);
 	cond_resched();
-- 
2.43.0

