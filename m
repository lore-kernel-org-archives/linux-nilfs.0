Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A591BA87C
	for <linux-nilfs@vger.kernel.org>; Tue, 20 Aug 2024 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724175589; cv=none; b=rS8dSkfru8ooJFCQczlHkdR17ty9+UDv7g8AlLwWQa4nveyRcYgF1goNWtKzxcmifl722JDiXDZ8bMz9UtJzRGiS3ijuEp29SdQ1q1zeGqK6QKIY97ZX+QrtbdRNiMqe/XXnoscKupK6ZfVSV07+7fIi7b9R4Qc/5HkUKxweycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724175589; c=relaxed/simple;
	bh=XfBa8gBGh5/VdEW6uW3HRVScp+RUTMj67wBueykQS9M=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=V/BnYwBvTtLivbUrVWBrndYBcXd/EBN1gLfcWLaINEGymUeyEhtoNEtVZLZYht4cTxYrZAPt0tl/n01J8aQDmufM6JOGdRFb8OjK+DWL+0RjwW4ayURWa0FQ2AZLCyWKOqTrQuY8K3brwQzEtSCzd7gZ/lJFBzLX6I1ne88iCZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HnAzaPC5; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HnAzaPC5"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3db14339fb0so3585676b6e.2
        for <linux-nilfs@vger.kernel.org>; Tue, 20 Aug 2024 10:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724175587; x=1724780387; darn=vger.kernel.org;
        h=to:subject:message-id:date:reply-to:from:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XfBa8gBGh5/VdEW6uW3HRVScp+RUTMj67wBueykQS9M=;
        b=HnAzaPC5gdLP/jHNSJ5t4NBQ70MYKIvHELMG61yW+tYyJMiMWA8DDWORGfHq6lb4sS
         OqggQaTH1Q607Et6ciGbpblPbcE/SA/3yFteHSztfbeMTilAbyR+xm8DQ7qb68WBVjQp
         Lo/po43UdI4LebksPm8dspLsweP0eZDW0AUydHFXbBq2dgZC8Iiq6B5rrEIUp4daK5Lp
         k7+Rq8h5ORqdSHRPy/W/srpriPgmqDrgfeSlrwi+un1QwcWmVeWcwg48Vb1DYn2AndCG
         tZSgoVftXAQFpRXEbpnjY0NSAopIatUJjytBM79a7KYxdP8IVezweQOhmf+SqIJ2DSqe
         XWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724175587; x=1724780387;
        h=to:subject:message-id:date:reply-to:from:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XfBa8gBGh5/VdEW6uW3HRVScp+RUTMj67wBueykQS9M=;
        b=prOof0Cb6XYcqvg8RPyKZMV7KkswL9RogbMCxZtDhE4QFoHTWEyb84Kb6XmT+ORlWR
         UwxdSeK6EDx5CASU1u+Q4LGSreZURVRylT16n8QvgypE3rH0vQOzhaleSX6AJMUvaM2f
         raf+wcK/bnMZaU8iS564zfTimMvZblnaFf6YqETN3XNMREZPXP2OtbTF9jZSS4amTuZx
         gMYljT3Ylwtal765blNhdGcw3ICPnTXY2aqV5npGjnoKp/PCM+E4to/BXlV0pCqkKOi6
         OKnPUzAk8XUY7MiVVOss5E+Yqw27CbIysAM+uTt2Zn1sVydHL4XNU4g/4elIEUOf5A1t
         5jVw==
X-Gm-Message-State: AOJu0Yx9GR7PCci2+bc0Byw8mH6GtbuJKGxTR8pw3CCyhg3fvQuzfqvZ
	eweIoVUNJE+/3H+mNYe0GqY3nMFky2a5QqLkbJEyn+pTvkwCu9xfLTrLKKhhrW5h1RaUzWR05k9
	DX23ohu5TiABbCmk1huugZxIX2laFng==
X-Google-Smtp-Source: AGHT+IHGSbXCmZ9nJQDWY0orkt2MF9+x9p85dj6S0/oE4HwT/vdNmlF8gyqvYQAN5zaakp/Wu9vsG9Jy3ensx8I1ioo=
X-Received: by 2002:a05:6808:30aa:b0:3db:1ca7:3618 with SMTP id
 5614622812f47-3de1950b97cmr13110b6e.23.1724175586858; Tue, 20 Aug 2024
 10:39:46 -0700 (PDT)
Received: from 927538837578 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 20 Aug 2024 10:39:46 -0700
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Linux NILFS <linuxnilfs@gmail.com>" <linuxnilfs@gmail.com>
Reply-To: Linux NILFS <linux-nilfs@vger.kernel.org>
Date: Tue, 20 Aug 2024 10:39:46 -0700
Message-ID: <CAE7Udf-XLt592O3_d8q05XiWG=k4qAjpeGebF0PyxgZrVH17mA@mail.gmail.com>
Subject: Published nilfs2-kmod10 preliminarily.
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Published nilfs2-kmod10, a standalone kernel module for CentOS Stream

10. Please not that this kernel module release is experimental, and

depending on future changes to the distro kernel, there is a high

possibility that problems may arise, such as the inability to build or a

loss of OS stability. For details, please see nilfs2-kmod10 releases (or

ChangeLog, commits).

from https://nilfs.sourceforge.io/en/index.html#n140
