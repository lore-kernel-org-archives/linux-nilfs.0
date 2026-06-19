Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8302FE056
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Jun 2026 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781888861; cv=pass; b=YBrTcLItkIHRhnbUPk3ngySMykdGh0ptqOtOwsX1ggxCy84dUpgSYexf4vBjGr2d2l5PzPqlQ0sS7sufisG36XtzI/T9KaJECMAHm//1VwIc6U/UZi5OseQ+18f3rqjqHHvWhPyUO9S7uhCSza4yKcbMMTf+nlH5scIIEock7j8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781888861; c=relaxed/simple;
	bh=SbV9FgChYJOJVlI6gF5ezWIzNMHYHaEnSO3A4pV8Vw8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nnjPSQnXd4vw96FjfE+KnIvNPe/hfNwBAtywGt1XDBCxtxqgRrk6wh1Nz3fOCEJkh8XoAPYUQkpwH/2Bb1ywi2Qq+l4hZC5LcA0BH2B0vck082PZM+JwK3woql4p26UhAIYFeGBQYZeIUXIUo2bJ9Htu5UPSArfjoV2mILlfpws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M+UmEWOR; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M+UmEWOR"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-7dfceeaf168so33788317b3.0
        for <linux-nilfs@vger.kernel.org>; Fri, 19 Jun 2026 10:07:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781888859; cv=none;
        d=google.com; s=arc-20240605;
        b=JN5vp3QmRVQElPrsSW755iratK/ohGD+D0E4lh/3P8FwquJ7pfTmGrS5fJubmRlU84
         DhGs5eS2QlHmR3ePi5EYLIQbmGj3B7OuZya64lDMftQ36ksFngw30XkWRoyMK3KuZMKi
         tqoDFHLTQtiYvssYhzOikZZ7EFY9L57Hk6R54v5u7NMlE3RErPJlLJ8B/HapQMh1mSrS
         snivROKHJ0ljy7JZ01xIqeScyzF8AScVIFWQ8sOKJqgY4O+HS8ckTrgO4vvCxgIo5XuB
         tFcIPAtMczVYRLZqMxuQGo8EzOvWWfok4sCrKpVRpzzVFFz+0Ue5ECgx6oJLIODIDQ4n
         maCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :dkim-signature;
        bh=SbV9FgChYJOJVlI6gF5ezWIzNMHYHaEnSO3A4pV8Vw8=;
        fh=Afbqn6eya/G+dOUTlJ1LpDbmd7FU0jRH4DaWLsAvfgU=;
        b=G9hn3MbKcAAXoNroIJvO4yhOOmcd6WKI4BWiYNqVV8UmwsKXpCp1c9CUWpLXB1LSeI
         /ZK5M4a7eBQmR2nFIGPpOWRq1AiQ3jbyghfbGX1xbBhu9j3zLVJfi4Ywuxkn41vXaNgG
         1cp79NAUpwhr/ZK3Q/Akrlfv1O9MvM8LE5sNg/u54YtgBiqXbXNNZH0Yrfdgu+X938d1
         DS94nyRTjf+WM+3+MOTPI0d0wkdviK3MVG04LMAHXp4QfO+9O429V5+ktYz/3+9VvLpp
         rw5A4cEIRIeLapvyjnUQQNSlraIhcQ0H3doUIB5/DeUZ5AcGbK/pwKHwvPL2ybxe5fkP
         MkfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781888859; x=1782493659; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SbV9FgChYJOJVlI6gF5ezWIzNMHYHaEnSO3A4pV8Vw8=;
        b=M+UmEWORZxh6HS6iYylOqAHtIAw/7AsQBrWFzMsLxJPkBxNy1heGhItkVAS8YIYlAR
         64B31llx3DUiXckKWnrOx9uHBAAwY2FJtuAmNlwrxEcq1DoWM3FZhKcMyfzRYZC6cj1g
         Ojzo6A9jDWzRl7+G75OnY8/ZGmyUSxXzAM+2t/rUPdOQVmYN41om3r/GuDgZDXyop3rQ
         dN5t3kleZ9PjPtDomxWB5vYgqPRyBwElugyem7YW/gQKXZOrL+mangl52QHNXnp1TBV0
         wc9Rj4iUDigC0LGESyVneR4iC1u97vbWH1//z2V2EM4Y1MQ8hmhc2zLf8HN+8hOcHFHY
         tW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781888859; x=1782493659;
        h=to:subject:message-id:date:reply-to:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SbV9FgChYJOJVlI6gF5ezWIzNMHYHaEnSO3A4pV8Vw8=;
        b=I9qKOx9SIwgTwv1EY7lRqMar4rttKNLUkikfcMDIN6EbTDySRG3XmP4fl2ywLgk7Le
         EWB5fYilSFkohXsv/AAjDkD00ZiuN4n3Fol8mPqBPGN6uRLI77CYTLB4Rp/QbnJDnJTa
         gERQj+pcNnZjOV72LhbQhBPkRRA9df+/ErTggoK33XM2/XFkwmVpl44yB43vDNIaRRYT
         sQU86lGNIKTeosrITevNoFQVxdA0xjoEN8Vxutaiu9qJRnVRPQx8tH092eLEnFPK3928
         cAfVQQmvimqzSYl3/ebk4JA7iRHdvExqTuvXD7iJqk7TSzVGjy9T/FCLP2RqErP8DqSU
         l8Sg==
X-Gm-Message-State: AOJu0YySnuikuSO70GIoABFnfmSKhNB6Co7MtVUodRKGc+mg8jb6yZbY
	mjEMaCB8/hTEq8OcOqXQuvj366yPxSGYhqOEYXIk357AkPngcH4VHtp/PdqdcbnuRaR99CT3u2b
	nIzgVs/lGMO08+JihGoOBEkQEa0FoJxQVJw==
X-Gm-Gg: AfdE7ckrF4TNelOdYTld/E5nLpD6n94xEfp3dshlwTuvPjzeuU2wva3FFIX2phpKZWF
	NZr00FBBNNyQZOIDMTMQBKKIL5BTdMO1kcm9tZnxEqcpt5gKnMpI8m+Hv4VGS1VPLDs2csOBhaj
	tc9i5QZXfgNc9fsb9rTszD6iUJOy27Jleyh6A23uogQO3WPvDdjLh8uMVFlvvjHPT/zUC8vp80e
	A6D2D9Ar6EHOZqbiGNJxI5xYN3R7wwmHpM4ZDhz9DiWxZkDCet+E2FLkCMozeMVnHVB9MZ2
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:690c:c250:b0:7ba:f2f1:86c0 with SMTP id
 00721157ae682-801761c85f3mr33814387b3.12.1781888859153; Fri, 19 Jun 2026
 10:07:39 -0700 (PDT)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 19 Jun 2026 13:07:37 -0400
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 19 Jun 2026 13:07:37 -0400
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Fri, 19 Jun 2026 13:07:37 -0400
X-Gm-Features: AVVi8Cf5TKxpOytwC2QJQc5Tfq4z2QAx6XjEW0YYXOKoMCHFEaRTUG4FFIugVHw
Message-ID: <CAE7Udf9xR1DifccyaRcNUApivarV2wBrrGnLaKrv1PiaoWdsSQ@mail.gmail.com>
Subject: NILFS utils 2.3.1 was released
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fixed a vulnerability in the library routine that determines whether a
superblock is valid, as well as a bug in the cleanerd fallback logic
during memory shortage.

from https://nilfs.sourceforge.io/en/download.html#2.3.1-u
