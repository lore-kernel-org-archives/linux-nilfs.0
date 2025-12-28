Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F9C1D5CC9
	for <linux-nilfs@vger.kernel.org>; Sun, 28 Dec 2025 04:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766894441; cv=none; b=NMIgfWgMokcyqLudjms5BWc8wocPhN6Sqn7wpLkwiq82kRzcmdx8kLjI7MtP9VggqL779B5/p0nwac577MB47uavaBiy+L6wZojMiRWRACyYs1UbKnj4w0EtS/T9Q1iOo9AHt9NcCQdrrzIwh7pj4UTuuLjXtUZS9v8YeZdSId0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766894441; c=relaxed/simple;
	bh=v0UTB3OodgrltQG54ZSa5zpr+lmAxixzQDqi7QtRmps=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=qjOXEwv4ZjLJhQIBz0P053IXkKiDK7i9dXC9HvwAJ6sxwBwVKqQwRBllCX+fA9B89LItbSzBBzEBgKrYosWO6fW80Blnny96/QNIWULvfja6ukh5a0dR78KyrIr3jxCdiQsJgXGg7bH0X0c/Y5+ldVCtE8rpSl45CGjhSAm6+1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RHVRsIIF; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHVRsIIF"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-65b3d3ac90fso2857823eaf.1
        for <linux-nilfs@vger.kernel.org>; Sat, 27 Dec 2025 20:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766894439; x=1767499239; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0UTB3OodgrltQG54ZSa5zpr+lmAxixzQDqi7QtRmps=;
        b=RHVRsIIF68rOM660fQh0lMS8d4P2tQsfEI83NhpdB4Yoa28KWEUYf3mXh/CWUsczof
         aqwlUgehBGQu7HD+NK7aYr/xpU4G3ozE6K5o3/b2vn3PcsE0zIL/fob2LPYLkcID30Ci
         VfV4Pj6zsaLmfRu/mwpEyBHSAnZY73dJxWHgAEn/vZC2uHN62tNmaXb3mGYPBp3MJnNl
         hPPDtnjZs4uYsA9qTE01iZXAOjluRV4uTbqLbo46w/Y1WSf7/dNuSuWn6aBOp+Ie/Cxv
         VA7XcuQ04jlyRscGPQrfNve7VjThnaSXXT0orsdtJtitD8yB/kmGmxw25c8NcMD4CH5e
         r8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766894439; x=1767499239;
        h=to:subject:message-id:date:reply-to:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v0UTB3OodgrltQG54ZSa5zpr+lmAxixzQDqi7QtRmps=;
        b=Q45sOOUoD15DOGa/zSEKznCYp+kmfTfp9AfGFRCROnAYNdr9XSRpW6VPgdNIbWn30Q
         3XuppRWk6j0RZSIDDrM3p1wDZF5X6ZJJ5tU6pZzrKDxZK9OMlhPCTtfbQzDGypj+6rvq
         jFegvouoip/4xg5JtkIpqaahV2rq+hghgXvJbWweSHCQY+0qJ5+3sHfEVUGD+NMDHL3s
         9UE8eIvG4mYHsYt/aWBLGmAY3aDxs8gc/qNA+2slgXj3KNubbZ1TIY+eyGX+OIlYww8a
         h8MnvRpgw/DnRxhp4PPo82tXXA2udwZ55XDDd3Wt9KLImu0eQCHo/ri2WjxpqbHObTDA
         M/pw==
X-Gm-Message-State: AOJu0YwFNb9hXt+jXch6Mr03+VytSsmgVLSD1pdwRgxrLvraRAv8J0B2
	gcgek4US+AzTqK5JHTctB9h6sUhIIkgcbysd8+3cZB1Po04BGxfHhM15FJHLk7VNQY8eUqrNyOk
	c8n7Q56L5sIxnYShrQE2weOChHduO5rAmSg==
X-Gm-Gg: AY/fxX6+34bC2RZqlBnIUIjd3ZCZK1xBLUHsnPbop1fyFg47qRVkzgyc8Q6klLqtJIh
	KVzq+gxWbtWIbdDKHYhebwuxMsRZqC3T5YXMzILvc5gK4HyANcOBDGYuQnbMncLnczHZavrI86F
	KquQZoIlbZn1DhsJtZrLq8SIRm8AdQTmcvdk5I0y26zI+Jd54S9Vwk6TXQTMbk+kQUcI5IldiJj
	qVja359PlZzAyfvvHRGGt9EA2PXjSxyHOB7+91r4oD/vy0ndWaIE0F5rDBPJEKxQ53n
X-Google-Smtp-Source: AGHT+IEEOtY/gyTXeKXUZYgLts+N6obP6JcSlhPnvT2EDtFx0JXsaVRjpNr6n3rtsMEXqTcUQjqqXCEYGNZAVc6e3fU=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:447:b0:654:18f9:10f4 with SMTP id
 006d021491bc7-65d0e697aa0mr8793415eaf.0.1766894439033; Sat, 27 Dec 2025
 20:00:39 -0800 (PST)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 27 Dec 2025 22:00:38 -0600
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 27 Dec 2025 22:00:38 -0600
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Sat, 27 Dec 2025 22:00:38 -0600
X-Gm-Features: AQt7F2rrUGRRpd3J4pfpvy48CYvtRseaApnDgAzNixe5GtUcO0fnl2TATTDAH_w
Message-ID: <CAE7Udf_QP9_t1VR5Kru_LdBMG_nfJXYAJd3kumY16tA0xpTvjw@mail.gmail.com>
Subject: NILFS utils 2.2.13 was released
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Added support for installation based on UsrMerge and Bin-Sbin merge

configurations, and revised the README file.

from https://nilfs.sourceforge.io/en/download.html#2.2.13-u
