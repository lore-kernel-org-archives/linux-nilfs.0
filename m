Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376432D8771
	for <linux-nilfs@vger.kernel.org>; Sun, 25 Jan 2026 04:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769315676; cv=pass; b=SnuPqmYA9YR4Y6yovm6mf2y0KrS/4gAtNvc4eaH6X/UqC6cw2pwCdbINjVq8WX7Yg28pihWiESXjy5ZJ59FexPOE5E/dL9eDUcWW/45RK4KOlOYrTCwaRTEGg/ds/MaC+k777ZBBZSBv1Q/kAzZAiw77p2l/EZA9FRscX6kjGkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769315676; c=relaxed/simple;
	bh=wONh/QnSh+U4caZ/z5FuQZDEREqk+A6dUwRI4ZIR6s4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=j+PZ0TfNMjPFpufL2NY5c7lerepaEjtLFDr1Fy13QFxBBIbjATs3bWNsAwwTDNyNv/tB13REyXSFPS2X4t6B3/4LXcER0j21Wg1woz70ezGDGztE2WVX3c5seOZk07BRe8ldAgzvwQ1d2ziT+5FJiU5g0+Bks2c4b/SXvjq34hU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IKlZElKk; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IKlZElKk"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65063a95558so4821774a12.0
        for <linux-nilfs@vger.kernel.org>; Sat, 24 Jan 2026 20:34:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769315674; cv=none;
        d=google.com; s=arc-20240605;
        b=iMk9rmC5Rp68HUU88unhiQrfq9pWx9igTwQ6swtEafTnKMMR5nKXS9UR1e0/l3hVR0
         gJehopiYps6cxQ1Sw1HNTQBKVehqPpdMeUX1JxwY0LIq0YKXbwe++QEip8WuJ86bSGrX
         U2n8dTRpA8wXsqNRyVE7jbUmd6nWAhhz8zNkjM4k4BY2wTMmn8z4WFMYiAxXRnv768VV
         /JiRPq+P30wMD4LCXDq1LzoPJ+QfooP0vExkmcFCFc366k/l+v+7SBvIyU1BJKLZuboN
         ChK/6WdfOerZP7oa17S4LT6Zlnu/JnL8+RfFDEXAxjOw5RCysQXnzpIsS2uzBKpKRZf+
         JJZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :dkim-signature;
        bh=wONh/QnSh+U4caZ/z5FuQZDEREqk+A6dUwRI4ZIR6s4=;
        fh=Afbqn6eya/G+dOUTlJ1LpDbmd7FU0jRH4DaWLsAvfgU=;
        b=fdgTf+1NBrlRL4ZWUqjEFTOR6l0p6AjP9WZySW+4ujTS2aFdYZaWXACeR7++h1Dif4
         Wgr3uFXtid5QTtL4H85fjt7xC63q6jTBA2CbcLXP04CfX7sfHrvlMVAD0rilh4QF0gpq
         9Ufm4nD3PEYZ1/O3w8P2W/teMfj7wb3eW0NWGqbCwEluDWQYDhp1GdHJlb0o2kwnS4MR
         lzLQqCxN07YM6AJWkNWrz7lHLMQpPOlxTBvnsqZ5DlahihbQrENrfjLFN9RXnePslwhn
         HX/LP4b1DDcNUEjT387E0lypWJHlRqLrYzuZX7bzNGtPm2AOfJsg5LX8nINjsdUD7jiz
         bEuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769315673; x=1769920473; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wONh/QnSh+U4caZ/z5FuQZDEREqk+A6dUwRI4ZIR6s4=;
        b=IKlZElKkGEtg60zpGFVlCqJ/XJrZFELMEqG3ebFZv+7TS+gISHPODwgCR4gA6dSJJZ
         WAIx0UJBGAK3Dt60DdrGLoUKgE4W7Qz2OZjdsEEkua1/k829lfxEWn7ik+p7e4NUqro/
         2UuMf9j4kU5jNkJOTusFtKiXCkOqsD2mo2097ezxXFTdkQGbUWuw3Q034mO7LKdoivC+
         vy+4gSGfm23CJzOcXskkitEqUAfq/7pJkljFAbQYVVcTjLgw0v5WHAZfPMC2bKYP1J1y
         /s6ysy9LWgOpIqvbwqU/xIpwT+EjEod/PoIOH/i9/4hU0X1gG1BG1RzfNlUxaOos8H0k
         3RQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769315673; x=1769920473;
        h=to:subject:message-id:date:reply-to:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wONh/QnSh+U4caZ/z5FuQZDEREqk+A6dUwRI4ZIR6s4=;
        b=iMZyf61V7cXADsT5PbyJ0j1WbNw9s+rYctnQP07LD0K0HqxMvUdZu01SmulSVk3+Wq
         oEJOga6xejOzWuswm96LFa+Xm60od6cidfNPuBD9eDkE3yBuD08Bimmpb43BM8WTX5lu
         pQZBibX2lYtemBlzNvlPziqs7riOr0XAuVKlDPRZ4W0a7RWNb+BZn02lZ0w2EFRjDgIM
         yeDpWPRYYQ4vuc8yMJAL8Z0p+rg6LohcqscUCGcep99HJzFo+CpwGWiLDdIaIk+kl73M
         fwWfxxlc8l4zgGA49BGepGcU2LYWjFXgYD1RSXHyrg2BonbcWfrhYDaq7sa8gUSU7hns
         rH9Q==
X-Gm-Message-State: AOJu0Yz2NGiz4QAnzwKzkgBMyFAkiQe+6qHh8wVSjC0BzT6sXCVmO+yj
	Vdj7WRGui/hOSyUMawLMWs1BfcewV6l8JBMhRUqI48oIViqHz/OymgxxCTVZVnROMWdsdQ/iEDK
	vWGwfG8CStXhyc6SxvkJfzVQb1pQyKpLoNQ==
X-Gm-Gg: AZuq6aKAz96p64E+OwDQlCO3giXIm8aTR2EaIns9sReRCSXDCD8JiaPZF68+V49G8Cl
	+UvkNh+fetM7qFB4aZOw+7/jIDf9x6nYDSSHa6crqdiNkFtCGLFjI49g4uddck07s6UUjQ3aMCd
	x+mocggLaLFk4YoOmWwGZV6A0J+3rhWMMGPsrZTYL+Wna7LaffOmoamMgDF0yF3tDI3NVtXlMN2
	DVAXTZPFxSHEB2eznz1biCqV7NlSn3jea4SCOVytV2AdqF0+DqwyHq6M+Ze/VhCqaW8Gxv4
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a17:907:1c15:b0:b83:15cb:d491 with SMTP id
 a640c23a62f3a-b8d2e500141mr40764666b.53.1769315673436; Sat, 24 Jan 2026
 20:34:33 -0800 (PST)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 24 Jan 2026 22:34:32 -0600
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 24 Jan 2026 22:34:32 -0600
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Sat, 24 Jan 2026 22:34:32 -0600
X-Gm-Features: AZwV_QhdhRUMxh4Q5xIWJz9Hs5ZEDHGq9DAOiedLQwTkLUdQxQPzydk9cSZDFwc
Message-ID: <CAE7Udf_u4zPXp_VwMnFqLf0_HoLxqeccfJ-tertuNhqnDsi-Mw@mail.gmail.com>
Subject: NILFS utils 2.2.16 was released
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fixed a build issue on environments with fully merged bin and sbin

from https://nilfs.sourceforge.io/en/download.html#2.2.16-u
