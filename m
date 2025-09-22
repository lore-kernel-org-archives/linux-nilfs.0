Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5254F305E2E
	for <linux-nilfs@vger.kernel.org>; Mon, 22 Sep 2025 11:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758540714; cv=none; b=TgKjZ9wdswYujcBLyekIuc97H1O4XEwnaywQQMJp66GgYg6rdRfDvQa9kmvM7vjH8s1t55Kudv7tJgrQ7YxwHKBpUnNLU3lBtjQaroipJhAczrUotNFbSojYt985CLkcjOIGZOXgfZz69/i2oamJtZ7Wxj59m7Y3g2gGWKrnueo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758540714; c=relaxed/simple;
	bh=dANdkwlfmo0tcArc8elboZSdF4cgC//Y1NVfjwPAcyM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=dwqlrVMAX06cTuYC3ZeHH8rhwKzTjCEPP9Ox2kOo+8qApuNcZR7wHYPUYDEh4J0yuApiqnpuz7d5ZD//cT8QFCpgIzWgF5uzpAoVsMlieN49UJ2t9eNZh4YNo5+FshcABn+AN4yX3/rXLooLA0MQbmo8cSMcddnuGPqGAIZEgpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jquZCTZ+; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jquZCTZ+"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-3326d9ee5edso3646157fac.3
        for <linux-nilfs@vger.kernel.org>; Mon, 22 Sep 2025 04:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758540712; x=1759145512; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dANdkwlfmo0tcArc8elboZSdF4cgC//Y1NVfjwPAcyM=;
        b=jquZCTZ+XnhGI5kA5iakC2a6FtjjXa6SW6pxnztfV4lRlrF6eR/+YXQ0wm+Rq69Bth
         NvSlIYBcIt1w8iDPpUJm7ezSlldc7CfBTGGCQBl/joySK6P1tcyIeeE6W6mBNUOJUIeF
         soyNGW8p/Z9rxiInRe+HZ3pV7zQ/4lQuYQVJnHa6RoOBIvp42jUsFTLvuvn0k0XQeCNE
         /1Lvjlatke7OQR5/W/ZEaQU6oKj365jMIKMy2WSUhF3gsjlbsvS5Sk40Fd4epM2Vrw8j
         +3W6c8aM+2ONeqUBfiJicMs7+br/QYG0boU/4KI/Wf1IbazPjsw6/EkNUP44nGzuC4b0
         tG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758540712; x=1759145512;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dANdkwlfmo0tcArc8elboZSdF4cgC//Y1NVfjwPAcyM=;
        b=w7jAa8Wj32gobWL2bTEvFlzj1ml18Xdcmchyr6aVttrRF5cvTRYC/X0mwfX9Zh495q
         ZoToIsaSrASd07AvTXlkC2kaYt47cLglgwZCMiILrODbr11PDvkpp629BBWoGFuSotQs
         w1aB8k6xwisDE/noLnfxWmCzu87LNt8b82I5gElH0TLtZra2gnUTUcfNiRdmZPM9Lr3l
         QnT5v5+bZoJff5omWDU5VsdMmSsky++hbRfUUCX1XQpA3FXITKJGAhGgajdnq5BFjOR/
         eHO7cpCZIlfrhBcie/2h7crjs1Mr0mmjNhe38Y/MXkh5TqJ7CVrzq1LgJej178N7PxSI
         g2AA==
X-Gm-Message-State: AOJu0YzhDeA/jMFFHWagM42HM9WUhrQn5WyYOrlqB9xuBqdT7xyde44f
	3LsUPxk4bx+tihfJy1xA2uSAQ0KZaJT/LKeljsYgLME/OqU0rSY+qALV8heCzjHNuRboBEaTPVf
	LbQwPhoznsCsSx+1IHC6Tw46TS6iFWhKqEg==
X-Gm-Gg: ASbGncv5Xlzwd6DfHmUuCs9Jx9dcOocHFBdxgoF95MyiEJ8KSMRb6SxwfJ364NAZKRm
	efWyOlFS998ggIKDhHJafvfOhsF35nYWh9CEBdleqxdQASUpRdjrwZh6/NTWauS1Mx0btuFAeqX
	VJER9qdJO7ZowTCcAh3M1VXchiXa6P+akZDS1/dqvrF8hJ79maUQgT7HmaWLN0mmu78j4ef8DVA
	SATl59O
X-Google-Smtp-Source: AGHT+IFqhePEdon2VaTqVtqL0k8kAHdgRI0jI7RYO3xpbT1fL6llwJJxZDe5FxSVgCf0WEVwJdrVIjSAKyMVp6z+a1E=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6870:458b:b0:307:8dc:edf2 with SMTP id
 586e51a60fabf-33bb4412e0emr5638019fac.33.1758540712265; Mon, 22 Sep 2025
 04:31:52 -0700 (PDT)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 22 Sep 2025 04:31:49 -0700
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 22 Sep 2025 04:31:49 -0700
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Mon, 22 Sep 2025 04:31:49 -0700
X-Gm-Features: AS18NWDandsZRtFaSHG01HDABo7alq5LKpx-NNxH65tImfubLGdIhwZ7mvIXlgc
Message-ID: <CAE7Udf86m4_V+9DEX+RZD4GfYA-LGhocWT7nY1TwEzP7O_DxPw@mail.gmail.com>
Subject: NILFS utils 2.2.12 was released
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A maintenance release that includes a fix for an issue where the chcp

command could crash when malformed arguments were specified.

from https://nilfs.sourceforge.io/en/download.html#2.2.12-u
