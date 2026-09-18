Received: from mail-vs2-f40.google.com (mail-vs2-f40.google.com [74.125.227.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FAD52CCDC
	for <linux-nilfs@vger.kernel.org>; Fri, 18 Sep 2026 21:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789766534; cv=none; b=VvwEh+7xMj9vsmR2Cr6S0kcoR67XnfajPLp3cAPIpHOtEZZhn5hcNoKft/RMuFpkFghXH6ME9tIIpyXunD+Oltq28yTvw15Y06TN9+i94iYnqwJFL4cr5k6zoA/ftYlw/7AOZ/kf8E3267xDfNwmCfV0afZIqg8RRaeFexPw6Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789766534; c=relaxed/simple;
	bh=X9OZRbLgJLOqk1WlSsd3gudo9f4gAyD1+kyq5qwCh/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXNrtvBRLCuo6v1XuZYo62Ye+1lblBL1OMPYJ8tJ+n8LaqOjQO78W7nFBifGwFxRbrLwmJes1ejR+7imv7hHGeZF2gDeKBWX0++r1Q4+nt3KWbudtuze2CL5zX99l/ruaj4y/QTsEjBUkL7ixbzCD7QHDXpIG7WY4uC5HKvOAu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uowct0ls; arc=none smtp.client-ip=74.125.227.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uowct0ls"
Received: by mail-vs2-f40.google.com with SMTP id ada2fe7eead31-7a05d236f53so666695137.1
        for <linux-nilfs@vger.kernel.org>; Fri, 18 Sep 2026 14:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789766532; x=1790371332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X9OZRbLgJLOqk1WlSsd3gudo9f4gAyD1+kyq5qwCh/Y=;
        b=Uowct0ls3LatVKgW4aDT9bGdjAu5eqAYiFi3pqhl25mwm9UaID1a6tlkTJ7F9W/Z2R
         +XHVHBvIKKb5P/xKd3AjheebKtm0p+R4OxNFr5LHgWfkz4t3WVtt5iXnmLbfqoiOS2Fj
         KFZnNj+hwvEC3DQKX2Uh72Zz9mdnaLwxpu0ZRi3DMgB6yvXjqpt34L1SM7c/5PQ7Db4w
         P0irXiS6uZBGOVKwSEBKrDBacbYw98fMAMmtFZkAe4n4j0qgH6WpxrydxvI2Nj7MhLNO
         EJCjOnq33uD9o10JqaMYis96vc8Irq6aqbi0Tz3Q4xoY2J/mzaDHkfFv1Wiga1W9zP//
         +OZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789766532; x=1790371332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X9OZRbLgJLOqk1WlSsd3gudo9f4gAyD1+kyq5qwCh/Y=;
        b=bvTijeJxTtzeQBci5cB88ywjyM1x2J42bqwd+tLALJkcOPzdIBRG9PiGlG8LxukkCb
         n0i2wHd6St8IMuR/nQhSY/mlJPnRhHnoy+35MIzzh+Zy1mNB2t2wGGcKwMhylARRXwCL
         Vwwd/gUHRYe2s8vj3/XA5WXqMIMLsnZ/0U0JOVws0bUHeR8kQoP1X2sp1ooEN4rO/Nmx
         uj2VCdTsiY+Kip+PaN7bqXo1t7TZQ2tNjPrg443itqH7R9u4AXB0n/UZigah8o/V8kSe
         8lMY8vEZgTdJQt9NgKk6s+sEzeTIl0KYZtpbKKhLC/r7THjUSF0YbX0pYb8SP6dNpGUs
         Xl7A==
X-Gm-Message-State: AFuF++ltYG3uo7QDL2dbfgvAdmA4o1mmdxAmt46nVMP9Uq98LB2+dJmC
	dOrP+VSME5Mv/cJVqodqUIPLDTG14KxicW3ECK2v/E5YWMJyxgCXj0iC
X-Gm-Gg: AYBFou0UKw8/4xPSu0R4llA5XjDzAkcmVKNWyEjopUGMoXZXCgvkG3kQeDwYLBnSETF
	y7ctHrOhm0ya0xMdX26BN5zo81TlM35gJN52Xz1SY70mYl2IEHKiL7I6j2LuL0SOdKE3qqbmzxq
	uk5YnpddZvp24f5m8gIpc5HZDG6bpjXXqOWj0Q7Olkff6xffArd/7kqeGzu/cv4lY/w2z3U+Rwg
	VhEPxNwt/J9wVGGxZ8gtZS9OswbhoeEHB4MnMctywtE7Mm8eUhg0rmG3RApSmRB0vSmbrxzMzg5
	FfzmYfTZpFdymsfIBIaD+gETgQcgcao/v5cRmNfneI6JI3Li7ppkTYCQfWl4Tit6fSJbOXGtkC0
	AMyCy2/bsYxHAuws8/0r23vFyXpqMhukze7mTyMUBVvZGwx8h0iUwN+5KoMKO7eKDS5UV2dNEoM
	8/uDFJR54NpJA6tGjOxohw8MpgTYKUsExYTdRzZiM0rIz5RDMha1ZjPmgo0gF1xw==
X-Received: by 2002:a05:6102:5094:b0:7a1:f951:664e with SMTP id ada2fe7eead31-7a55d28698bmr2162620137.21.1789766532242;
        Fri, 18 Sep 2026 14:22:12 -0700 (PDT)
Received: from beelink.. ([186.22.57.86])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7a6ac1bfdd0sm649155137.3.2026.09.18.14.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 14:22:11 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: slava@dubeyko.com,
	konishi.ryusuke@gmail.com
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] nilfs2: fix checkpoint root lifetime on sysfs errors
Date: Fri, 18 Sep 2026 18:21:53 -0300
Message-ID: <20260918212153.23651-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <13b330df140a2ee488952b4c7145e261ec884555.camel@dubeyko.com>
References: <13b330df140a2ee488952b4c7145e261ec884555.camel@dubeyko.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Slava,

No, wait_for_completion() without a timeout is intentional here.

The kobject subsystem guarantees that the release callback will
eventually run -- CONFIG_DEBUG_KOBJECT_RELEASE only defers it, it
never drops it. So the wait is bounded in practice.

If we used wait_for_completion_killable_timeout() and the timeout
fired (or a signal arrived) before the release callback ran, we
would kfree() the root while the kobject release is still pending.
When the callback finally runs it would access freed memory -- a
use-after-free.

wait_for_completion_killable() (without timeout) has the same
problem: if the wait is interrupted by a fatal signal, we cannot
safely free the container because the release callback may still
reference it.

The unconditional wait_for_completion() is the only safe choice
when the caller must free the container of an embedded kobject.
This is the same pattern used by other subsystems (e.g.,
blk_mq_tag_set, configfs subsystems).

Aldo
