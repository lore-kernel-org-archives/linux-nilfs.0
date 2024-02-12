Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C122F5B
	for <linux-nilfs@vger.kernel.org>; Mon, 12 Feb 2024 03:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707709701; cv=none; b=YVji0KpZ89fv1nUFjXAWBvukHfpW6T5KktQHAEBRyhHyhr+FyAbEIdzZFx7Y/gGdjwE3xcrFcrT2Q1q1EbIwhhrg4bW5s2OExQ7tePE7loOBoxcS35TmIkHC0VRv1matJjFdU2uqk1M4LdEt6IT6VcmXl8QtXkRlDYFNeCkSa1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707709701; c=relaxed/simple;
	bh=kvtzmIt/EOT7PpXzfY5kmDNaU/Bk2y4ZOvK4gc3kax8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=io1nHLcRbZd15UY92YCVnJLrK7E1AmfRJhCdsqI3yw3CxLo2XCqDb0rC6H6mQR4Ol4wcoAY+Of+GYGc257T2PpegXUwJG6bL27FwlD0mj7fdSEsd4fUXKvSJ16/FSgFm+WOM9mcE2rYjMjYwtAhkupvoJZMNXLDoR9A3EM6Brlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZO5LPYG; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZO5LPYG"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-21920c78c9fso1688842fac.1
        for <linux-nilfs@vger.kernel.org>; Sun, 11 Feb 2024 19:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707709698; x=1708314498; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kvtzmIt/EOT7PpXzfY5kmDNaU/Bk2y4ZOvK4gc3kax8=;
        b=dZO5LPYGRVW2fggRYQVXORtQX8Jr6Wu/qWF9WlO/P8F+FfXPcjDk+ZIZ+mCXZnuQiR
         rvzm5eVnMhNcU3BUiOL9TKk0whYU0fjeuLzB/hceVSnswz8agNEZa9RwB9JTnnrqlljQ
         BUTwqTETnfAZpQ6tIPIy+iBPObfkvkLCABxVBKcm7BopEVjbWpWNCWUtvAlv4ooY5JER
         YQc0HFle/4UmbrY6MrN2WUuSLd0UTUZs2/Xrhu3+otYT9ySORnBPMEt4ALNAlmJslXs5
         3LFfyG8TiQA+e+qDUGu1xy5ReUKM8+i3gthmALSqEaZSy50WO/t73p520fkga7mfGQzT
         r1OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707709698; x=1708314498;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kvtzmIt/EOT7PpXzfY5kmDNaU/Bk2y4ZOvK4gc3kax8=;
        b=gzZlzmqnwi4K3xa1ahswQh7PNEqOgo6E3iadNgs8L9JZjf5mbrll3dmMFgO1HFofk0
         KCyR02xkujuuRtfhhA56OQAQ0hNel5yoQdTPDYgd+v6FodaFLalGQcLsoHgkKoGfudhe
         wDu9h7Wv3CbocQwwMoTnpaUuG1Tt+6J7jtFaMcczFV0pfEIeU+FGZvu8eZN32hFs9S+A
         0AR7+ajQsKlaDF4nZSJlXbzZzLLnfdwazUxXgY6WLbuxLw/MmOT9FI5qYqo6SWgYqH48
         VBFKzxhpDdYyib7PBIUcZLb6+Ru1t4BfeJ1fx2G2VxSbTOxbI8jrN8ln3R2vBChCJNvf
         kCtQ==
X-Gm-Message-State: AOJu0Yz1KXFY9xXU8S+lFSeptsJD9HnRR+9LZxzP/ll80hG85YCjFm7F
	SPTun5nC3rxPIyPCP3i/Tj2BIS7YY7o0emB/yHl5AUrqtfRR1KzrYFxlIiiuN6ecDHupr822ESk
	/e4s0M5u4DSzcFA5k5iFoQPTSbK+gqsZI
X-Google-Smtp-Source: AGHT+IHjURdvCtTK21UBvVwuty4dBaMop2XpnYB/88NbNFoOK+Ulduz+pczJhe0kjAUvXNIQM/GhdJcEWqV5Tm8vpEI=
X-Received: by 2002:a05:6870:a68b:b0:219:76d9:ee58 with SMTP id
 i11-20020a056870a68b00b0021976d9ee58mr6440852oam.59.1707709698622; Sun, 11
 Feb 2024 19:48:18 -0800 (PST)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 11 Feb 2024 19:48:18 -0800
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Sun, 11 Feb 2024 19:48:18 -0800
Message-ID: <CAE7Udf-zcr2cNCx5+e79ffHueJNbrEgtr3Fsuq5Nbd0w=qCnTw@mail.gmail.com>
Subject: Released important updates to standalone kernel modules for RHEL clones
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Released important updates to standalone kernel modules for RHEL 7-9
clones (AlmaLinux, Rocky Linux, CentOS Streams and CentOS 7). If you
are using these modules, we recommend replacing them with the latest
version.

For details, please see

nilfs2-kmod9 releases

(or ChangeLog, commits),

nilfs2-kmod8 releases

(or ChangeLog, commits),

nilfs2-kmod7 releases

(or ChangeLog, commits).

from https://nilfs.sourceforge.io/en/index.html#n136
