Received: from mail-ua2-f43.google.com (mail-ua2-f43.google.com [74.125.226.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74A834AB03
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 19:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.226.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501471; cv=none; b=kSiAxwqCaLQoPqze6pK1nayIEnEidQkZTsYjBoWVF2q3jfcAHks5kWJKQwRB1QGHMzmHe65BomYor9c6gyjpZ0ti6rdtp1UABV/VmSzeQcLfGua2a4pqNGheQ+x9gZcTTQk7qHrZYwnidUowSshEQC72NSIDRZwDNq1wzw+B0P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501471; c=relaxed/simple;
	bh=urDHZl8WwDf2LHgRSrUhtMBRlsSjHVTZIirmLX8Q1zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dYyZeBjikApQLIGyiK1cOKhwPbOeBPT3Tlswmmm9TCwJT9l0M4Sfo3ljXKvoumtwLzDnh8iFBST6LdtbBcuu/ic1a4Q0hKAqi0KB63sU3y2nvpPNFD/Fb1eRO9kfkRVn+UeTEdLLZAA6MoEkMUYfJBecI35Ff7mprChHmGJf9+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N+5ReGLS; arc=none smtp.client-ip=74.125.226.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N+5ReGLS"
Received: by mail-ua2-f43.google.com with SMTP id a1e0cc1a2514c-97ea1a712deso54116241.3
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 12:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789501468; x=1790106268; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=urDHZl8WwDf2LHgRSrUhtMBRlsSjHVTZIirmLX8Q1zM=;
        b=N+5ReGLSd938RPHUWoSZViAsymxZQKNGC5K7+7+uVDKFPGgHQHBAAxNT8UxWUvFnfy
         sgCMXmhnB7eJ+pxTqDyF1wMjKDDCGwkbBsh60IqzJxBQezxXGHNw6tLAhsJPa3rc1Uqq
         EEUxPYopsQX+HI2B6IGC7wmk0j+bQ8UUYhO8KvIvgdz1A1W/HW0UDPBRtOrGG0K6Hm1D
         okGAV+8pOOTpOUqybj/5tRWqYv7TthnOVos+WV61Z//YDsDkfTINxwLeiSwCaW7YRfc1
         OiGcsG+UW2XCQ+2nwGzhOGUwzXDOpBKfYsnCKU8IJzgUS4FZdQEdCUuO9bOmEyySFc3q
         4HGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789501468; x=1790106268;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=urDHZl8WwDf2LHgRSrUhtMBRlsSjHVTZIirmLX8Q1zM=;
        b=FZDRFNRIxt/uUdiCvDgtz4jfLn8UW2xW2tEF6hzsBOBo15SIJcL6H/vd2U+8uIe7XG
         kG/8FzIX2LJBN335wdCi3mC2i0/UYiX5WMYoAE1oCKIaP4vmww6ZssYWDhAUqX/wtfY2
         W/fzONcxnYfzMHULqAuBeP027w9eIdPa9X69jqbytDvRi/BuBFrTdvT4r7mYc526/CC0
         OvvqvJBSWXl+Feaz1GTiHSErq8frw4U/q2GbgJhYyA5efgOiiTqUX9jUv0b7h8zKL+95
         fQ6QdjnLZTIQCruMfS6xqzpfFl7SE3mcP8Vl3Y1dqu5A4vkMESCuBMOHF3BRtQTq95gJ
         mwEw==
X-Gm-Message-State: AFuF++nDlP98aUu/WW6oRGx9xb5yKJN8YJ3IZO9JBDGzrb/si3liVEBP
	imcynpc7jFSwhJoQknPWmTaRh0wnE3EUmHoMSZBNpRqPiyf2CB/e3ijF
X-Gm-Gg: AYBFou1gA9UzYiWjXRBk7Q3T7D604MfIG5Wt+TAJjEU883fLv1Q8R/I9dZPSXcco6mS
	ymM9qQ+PZkeEzR0nv5SB6GZtrRzhau5dMD3zoZJt9kxJ99P+rwyKF1WDFUd6DM7sfHQkkHiEuuF
	BX14VQIOmb8IGPfocXuBCVCTSQdsW+elS34yq8FBxYjm/ons7IcJNc2GnbtmHPbKaocgqgoLQjU
	54qwlmBRczBopCgh5GbOpf6t/EIjnFUa00tcViRERulM1/MvKcKcHsLqbmnVN7JinBA8/HofyG8
	Ym6sH8jYsbFrt8TTRcKOkBqu7pZSEDJj3waYxLX/h6D2hl/k9pZjlO7RKnQHAX7Um6ZTh590h1K
	nemzAgT5VSMim/VoD3e/vceUF8CxRCHbCierMVHzdsvqyfLtTLTJRv+/bIKwZrURiFS3vY9T/wD
	lKga9mpwplqU9VLWUIRZn4cQy2DDJgfA/HILFEv0vrbzR7vCegihydIsSEynNqL6Ot
X-Received: by 2002:a05:6102:956:b0:79b:b696:d625 with SMTP id ada2fe7eead31-7a0250c0fe7mr1440137.2.1789501468421;
        Tue, 15 Sep 2026 12:44:28 -0700 (PDT)
Received: from beelink.. ([187.13.206.89])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-98314dd7ceasm498589241.1.2026.09.15.12.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 12:44:27 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: Re: [PATCH] nilfs2: fix checkpoint root lifetime on sysfs errors
Date: Tue, 15 Sep 2026 16:44:13 -0300
Message-ID: <20260915194413.3314842-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915041206.2430937-1-qwe.aldo@gmail.com>
References: <20260915041206.2430937-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Slava,

You're right, the extra mutex is unnecessary. I checked and all
callers of ns_cptree_lock are in process context, so converting it
to a mutex is safe. nilfs_put_root() can then use
refcount_dec_and_mutex_lock() instead of refcount_dec_and_lock().

I'll send a v2 that replaces the spinlock with a mutex rather than
adding a second lock.

Thanks for the review,
Aldo
