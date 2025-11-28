Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81802DAFCB
	for <linux-nilfs@vger.kernel.org>; Fri, 28 Nov 2025 08:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318612; cv=none; b=iTrejEu2Ha4H8OZqap/jF9xRtKUa5UDyPkKPKN2V7+TYSAK0Jw36MwsCwQMKLM71pIEV/hM3/yBu9HiQHrP9lSNdzcTnX3Qu1i9GTpJ/lHRVm/5wqJu/oQgMHsMHG3JFVn3ORqhiSdk/O6sDxBgOLrw9eG9Wd5pL15P9HrE++TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318612; c=relaxed/simple;
	bh=xGVVT4BmmsRmHwqCM1tiEInfhWnT02u6MmcaLhXikkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bHiHUn0gSmqRplROrJnXOe+RlE3ARIx8vhQxsERFywhLfVAqfaXnS/TppRMLjFmbMecGotlHk8kiehaW+Y6+keDLgFaDImWDVDYIBNVzKfKMYHCvKuP7b7c9BMLreGBYn1EHYekNpck7fAsSN1bJEN6eWv1RYpOWVdR/iVL7PJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NDGoubHc; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDGoubHc"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-37b935df7bfso15448961fa.2
        for <linux-nilfs@vger.kernel.org>; Fri, 28 Nov 2025 00:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318609; x=1764923409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pCwgUbh0sJ3MW4qm5ntqbPbYd8695ZF95DhESNdRP2E=;
        b=NDGoubHc9A3rQR9Kn8i2pS8JEHPLGUSllFFPMd0QGjzFT5jQnqhLUzN+fg9W9Hs78M
         gaiGkHWSab3gDXk4ScTHSiCt5sTHL2CcpAnrVraW9QUpmOneWI8tPjexyaYkZW5pJ4Vn
         K86FL7dBkcxf1cV+7HHSh4vCc37D6qIFGkItmxMi+p3ohLDI5c68UJ2SqKhRucQH6qYw
         ms07eiM9/cUtrQHgNdee2SrVuzdG7SRWJcw5HWDKfJBwhkEbhjVsbTFcyrQ2zeCj4028
         yonDYSQb0fcEivI8dmWuFXInghqQY6eEfmLIhQMKPCD3r58mCEWaY/W6kL56N8JEhcEE
         Tjyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318609; x=1764923409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pCwgUbh0sJ3MW4qm5ntqbPbYd8695ZF95DhESNdRP2E=;
        b=g0tupHeFk2wwL5TYyTubMaxZXnBtB/y8crhA4MU3jFVXKswKYZuG2yaGD5X2TRQjii
         3W67oOmbIQG6eqNu91/7CCycMgthVATmoryEPpAv3mLp8gdtXshCGsHWIH6m0Vp0RTg7
         aN3rPyntSgwGDlW+NXIdO2UkzuffbVH4ZEneglACxb/18Vz5uNzV7Fih/0LkgWoCYkwp
         W0iX/VwHMfpusCmw6ZkNRtDAfc3vSk2r7wv9FQJutKwNBnsQdZNroxKJ0PygTBpNHsZ4
         TbH9OMtwfoAIVTY/CY8Qs+hqU/yw2VPyYJgFGY4kKsiFmOwHDr/Fs+OJ3vnLFCSOmrNy
         yQQQ==
X-Gm-Message-State: AOJu0YwNVWs1Tx0N4xNW3HvkEmZ6aL9BS7QGHvKitN8mK+DgXSBCqm7G
	LnmwhGjItBGXPfnHQnghAxSOaZfyy6ECiYwc4AFClcJJcnASa/7Zkcp0dvCemmxUaVaNgORCZMu
	S35ia/Uas9kxYpwZdmr1hpN48iVjkMOU=
X-Gm-Gg: ASbGncv1APQ+vRZuqM1KTcBKbs0sKARfH1scx6mIAhL0exi4D3iAi5tjZCW2Ovu7ga1
	xPsbZvc6/3BM+fOB9XEVYLTmYEzKOruetLryNB6BvN6kRPAlX+4iRjx8NyIiD7RyG7uScw5oSJT
	wtTnzidE4p27oWNUV43slDf42QkVqbimnWuZfimDLOeYx0JpdTOqFvOciMl8OsRwYZz0uk98iMJ
	47guZgsOmgrg8DWN0DFThbVzCsvqQhqj9qJYCBoQs5PzH/l6Sp5vbfS3ABvjRTZ53Y2PzDr
X-Google-Smtp-Source: AGHT+IH7rcb6Kp/ZjeSItF+L5Tj7viapfOdmedJcol3Numj6Jk8obSzfneNvABLt/AF3cR9a6REpqZ3DjEUCNiY1kZY=
X-Received: by 2002:a2e:7c05:0:b0:37a:47a4:d5cb with SMTP id
 38308e7fff4ca-37cd91b06d2mr69453421fa.11.1764318608383; Fri, 28 Nov 2025
 00:30:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ad4826a48dba37fee0fa9949bfdeef8747ab8e93.camel@ibm.com>
 <CAKFNMok6sj9EPgCBSn=3Uc1ze51jbPH69xEXQtFTej3B1JcTLQ@mail.gmail.com>
 <66926bf9a9cb9488dd5f8fe9493d366fb3fd7e66.camel@ibm.com> <CAKFNMokvQpOS6KcyxKjHs9bQ7a6Oi37EaaMD+0Vp3xE6HuYOkA@mail.gmail.com>
 <c2b125c3f1a2b792241800c3fa7b6d6b56450add.camel@ibm.com> <CAKFNMomX4eBT2xFyK3XpK86ghEyB=ZGsLZr7H2C_xqm7Ysusyw@mail.gmail.com>
 <6b77c17169a39f75f4731073b3315df25f706e82.camel@ibm.com>
In-Reply-To: <6b77c17169a39f75f4731073b3315df25f706e82.camel@ibm.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 28 Nov 2025 17:29:51 +0900
X-Gm-Features: AWmQ_bk6FWrvilXCNLzCYsR2Rl60J_BqKBJbNdrVUKNBg1Uw8L2FBFNcwuHjDUA
Message-ID: <CAKFNMokERKfS2GyYhs5DJ4Yb=5Gw=-cD_GOaksvmPkoSj3G9pg@mail.gmail.com>
Subject: Re: Status of running xfstests for NILFS2
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "slava@dubeyko.com" <slava@dubeyko.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2025 at 7:43=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Wed, 2025-11-26 at 22:00 +0900, Ryusuke Konishi wrote:
> > On Tue, Nov 25, 2025 at 4:53=E2=80=AFAM Viacheslav Dubeyko  wrote:
> > >
> > > On Fri, 2025-11-21 at 23:17 +0900, Ryusuke Konishi wrote:
> > > > I'm still looking for good BTS, but it might be quicker to start
> > > > making them on github now.
> > > >
> > > >
> > >
> > > This was my point. :)
> > >
> > > Probably, you need to enable the issue system for NILFS2 on github so=
mehow.
> > > Because, currently, I don't see anything available. And I don't remem=
ber already
> > > how I did it.
> >
> > Okay.
> > I'm thinking of creating a nilfs2 (linux) clone repository at
> > https://github.com/nilfs-dev/   so that we can file issues there.
> > Is that okay?
> >
> >
>
> Yes, makes sense. Looks like a good place for collaboration.
>
> Thanks,
> Slava.

I've set up an issue tracker on GitHub. It's at the following address:

https://github.com/nilfs-dev/nilfs2/issues

For now, I have registered the syzbot issue and an issue that has been
reported recently on the ML.
At the top of each issue, I've included a Link: URL with a reference
to the related syzbot dashboard or email post.

What about the xfstests issues ?
Shall I add all 156 reported failures? (In that case, I'll just create
separate issues and include a link to your original report for each.)

Regards,
Ryusuke Konishi
