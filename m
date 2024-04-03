Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E076314F114
	for <linux-nilfs@vger.kernel.org>; Wed,  3 Apr 2024 16:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712161056; cv=none; b=RwNSNNu+Df+uM/uuGVeU3LHWugFrS+5tzea3GA8LbBWnY7DZlxRW2z8kTM9o1dWiaRX2/R3DcWgT3k7eOEz8To2TUYrfrDkiu0lbY7XKGtHyvva0+ZfThF7DiI9MGQTBJdecu30FAFnUyuPdcTNV+D9VfHY2oRWnx8gVkKwl8Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712161056; c=relaxed/simple;
	bh=DcIFcfahth+82uUXl53IDdkgboCj1APyladV+aPaUzE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=s9uV5TU/rS929LCQ7LwaBJvcB+e3JcnGgf8COYNPjSKxmeocfSz4JffKsR1kdbLr+fd41LR7R6DZjMgWjVVfcNVLnUNOo3uxLCzGKn6viCcZfmI1opvEK3mwgWqTsa5LB+Tjzme/2J5ID/zGHchX+LgmbxDIYn8E+W8SozaTktE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C8WpSBsG; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C8WpSBsG"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-22a1e72f683so19885fac.0
        for <linux-nilfs@vger.kernel.org>; Wed, 03 Apr 2024 09:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712161054; x=1712765854; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DcIFcfahth+82uUXl53IDdkgboCj1APyladV+aPaUzE=;
        b=C8WpSBsGgfBDOLdpjnno3YIk6KGZwmfeS9oAVpemasrrw7zi8sgg28qHOlTcuqmhB0
         hEkXrMivuNsZQGdNRn25hoVLwsEywlHRbTI8PFVt3qApxWEdIUswH+UqJll/fF9AvLJE
         tuSYYJiBzo+sSQ2aiLFONgZzn6ZZP9wiqf0koV6sZzYKS/rHFi+QfKY3j97+muBQiW2H
         4HF5a11nldrTCKtmj0sdBbhDL9DS61jjws5rYkfyG9f1KzDdtVe+ib4icmuygy58akWW
         uHVXICXDHntQgPvArRsvorH0uPFaL+V5A2oHaPUuOzMdFDdM7XCdM/0TI8mG8LwyujY4
         e+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712161054; x=1712765854;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DcIFcfahth+82uUXl53IDdkgboCj1APyladV+aPaUzE=;
        b=O676FJawOOpt36BMRt87OdT7rVTnCzZj9Ze45frJvn2MPnSoUjx4MuCNK2MSnEZaGs
         KseN3O0zBsj5ddK12FrLUXhmsS+vXseyuOfXPMRT953ywJLxUGN4LnSzbj5PMx296jgh
         YGsh4TDC70tjwu6tRcUH7IQueMrRKZHvye8w2D9yeeUaipC5YN14wYvJQoB9lvgF7599
         2DkYz5mPKPyMnjbIOidkUz56YzYEVHxwJ5e4j46bxzKSdALrI3dEvyzrt2je2vHVBtLW
         ailVFQpSYTF5a2eFVhUItxuumwQgmubFEJq8KiSn6IBCMQksRb5jcHtxatNxmRaH9DX9
         m0JA==
X-Gm-Message-State: AOJu0YztgqfvP4lqBwMo+rBY7RUJJKtJWB6GMdOtJ1pxVh69VK2WsD9N
	ALH6EPXvQbtdpPVUaWBx78QLUURGH4vI0wgM49wVbbZG9SQnhqxyKkqJKvG++QfHYd+mV5f00FL
	Bandif0DiACc3DC2PxGUIwdujZJdFUx5b
X-Google-Smtp-Source: AGHT+IH0J6f8BUQiuZ1aK0xTwlQ6dG8Ug4wfCpbma/uHGi3Oy2HcEzLFrfhhf6+fa7mVG0d5j2oA1H34y1GAkapP2c4=
X-Received: by 2002:a05:6870:d253:b0:22e:1458:479f with SMTP id
 h19-20020a056870d25300b0022e1458479fmr15239422oac.43.1712161054120; Wed, 03
 Apr 2024 09:17:34 -0700 (PDT)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 3 Apr 2024 09:17:33 -0700
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Wed, 3 Apr 2024 09:17:33 -0700
Message-ID: <CAE7Udf-raBq4Gn=2zCVWA9Psb-LfeKXZ6UGH4=C70hHpaPg7QQ@mail.gmail.com>
Subject: NILFS utils 2.2.11 was released
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A maintenance release that includes a bug fix regarding escape
characters in mount table parsing

from https://nilfs.sourceforge.io/en/download.html#2.2.11-u
