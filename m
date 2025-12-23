Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADDD33E7
	for <linux-nilfs@vger.kernel.org>; Tue, 23 Dec 2025 03:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766460800; cv=none; b=G1qc400KSrdtHsEgv+ky6nRKOAq+FhpqIkV4gONC9e4bAi+Rp7gigCYlN0zbtMsZvUhZ0F7v8Y2FcSQ8BACICE0g4IPgzVZAyk4fv/T8g7b1ULtAn06lZCqHXy6MbxxWiZu4OicgX1Cz6Wcs9sfsbyAQ/TzUpVmKjq9DdAD9lSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766460800; c=relaxed/simple;
	bh=hFEEyzNykS7UQVVDw0M+ttrkfAWIF5lnWFAp9x+blZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W0mYT9fQ2Li7nc892QT+92tsvPxAMdBWueSr7VY9gsvUd41Yb6xEvE83NNp6M8BnoMG8ImGkr2OV9Un5kRias46fq+ftgTg9F2BOVymhwwbSSRnpvmRdQECkRazO78qQUhhcBOEzSSeDGsou49V2aSFMcZVNv252LhFtVtZrnZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mPpREear; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mPpREear"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59584301f0cso4989004e87.0
        for <linux-nilfs@vger.kernel.org>; Mon, 22 Dec 2025 19:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766460796; x=1767065596; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjCTHsOOQrjNzCbe83mBzJpfUE5MLqRpTEw7bUL3Vsw=;
        b=mPpREearN/JpsHzzHIjd7D4A4FMIjQn8QYM0Hkw9xvy66yIzKsh1pT0mULZWxCvAdh
         u4HvESiaLgjsXGvygV9FYjzod0RxCkKJF5V6QZ43C4qag7678zE8RKmxgdvUCOeh+9+R
         C6T5XHx2uKG+JsfFTQhd8Hh8ItlT/2tu3T4WNIbyzAqvmulPob9PTsXEGfriCQuWPkSv
         72zB49q3jHR5xsoypkg5tptAygpepodXq59WelzTP+CO3E0W5NtWuEkl/7OdxyiOWbR/
         euyhlPYX2cKHdu+1BcxbwrWuw3Lcgykom+eyeXDTJEKROnsm1PHn5EM0OLKO9Q21hV4p
         7J9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766460796; x=1767065596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TjCTHsOOQrjNzCbe83mBzJpfUE5MLqRpTEw7bUL3Vsw=;
        b=oziwkKnZko4V33NigEpDfFZws52kTWBZYoyCPycvrPyHeHp1LvvpNfdf/GTcymj1RK
         i1A3m+1SgjjWCPCFCUxsF3ZsVI4ATzkpuXmsUZ9GMS6eIHkZTm5wuCzUT5kMe/DO3N0W
         OdQvIOx5T1Ane16dFXQpa3K8uaC1P0y5sDSzBs5Qb/W8dyLQQwz0zstYbeV+d6RyzhDm
         uWVARxOdu97IJDnE7DTtDa/PI7uU2wm/jjXE8uSL4F/oV6BrFJ+1dTOpcI+RPy2NVjnx
         3QYv3Ft/ME8dlzf79n/lh9puumijlz7B/NxQZ5rmHyeWY/+bnf5J4ecQCNU0fS5jdEfM
         H9LQ==
X-Gm-Message-State: AOJu0YzaChSVz/OT5sz6Bbhc9dBtLodbvTVVfImGGPaUmDk/0+Eq14LH
	8Zs8/C++vknOPdhjeIWGPK/e5FrQQv8AgQriKlaUMv8GBgFV9EcA/G04v+uHdh4YRBtGZqtcBzb
	a9TcsaePLX6qqb/fu9ISiyIekVaGE6JH6hjaBuX0=
X-Gm-Gg: AY/fxX7/KduEhS0XgQFmMtPQ5sIlJ5M28jebtsLTjJvXDk4SqGxg+3rvq0wjLNq1IfZ
	d36WJx/NqOesbAkLpFN0YJeOplhyMbKHXvVhkcoDL8P+X6u/ExRdmrVmFU8S6HKMMWi9pRHRZfP
	EjcnHbQsypEKymthLDDeZjaSTF2b9dn8OAX0KJC2YWgJq3MSUFgUcO2PclpCvRYE8R3/20T29WC
	6GYEbT/88ngogSB1+1n8qcNrzSxJ2iv2HIb4EpVS2EjwaP9V3PEYYGsnii20r6o6iNB+E2X
X-Google-Smtp-Source: AGHT+IEksXsBkR5LgK5r120sIzkj7jtCUSGSQPzoc5F33/Ryn3gFDzz+DVKpMZJbG+vCGun+jQZq/22U2Qto0ZjGNn8=
X-Received: by 2002:a05:6512:2301:b0:59a:1238:2f4b with SMTP id
 2adb3069b0e04-59a17d57a11mr3628817e87.25.1766460796257; Mon, 22 Dec 2025
 19:33:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219180631.27554-1-konishi.ryusuke@gmail.com> <4cb74f51f29a4aaad6cf4bfdcc7c4c61625b6ee0.camel@dubeyko.com>
In-Reply-To: <4cb74f51f29a4aaad6cf4bfdcc7c4c61625b6ee0.camel@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 23 Dec 2025 12:32:58 +0900
X-Gm-Features: AQt7F2oPT8-aAEFOS1iKVCZeIB9AfdGO2C_dCMw3ridHyvM80t4JMvbOhUXqX5A
Message-ID: <CAKFNMo=9_KAfLLttaYUuD6d9nTmht+T8En15DwxL_6-uaeSb5Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] nilfs2 fixes on v6.19-rc1
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2025 at 9:16=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> Hi Ryusuke,
>
> On Sat, 2025-12-20 at 03:04 +0900, Ryusuke Konishi wrote:
> > Hi Viacheslav,
> >
> > I'm submitting three nilfs2 fixes as a patch series (rather than a
> > pull request as previously mentioned), so please queue them in your
> > tree.
> >
> > Two of the three involve kernel-doc issues in uapi header files.
> > These
> > are suitable for the next cycle.
> >
> > The remaining one, which I'm sure you've seen, fixes an issue
> > recently
> > reported by syzbot involving the FITRIM ioctl, and is a slightly
> > higher priority.
> >
> > If possible, I'd like you to submit this as a bugfix patch without
> > waiting for the next release cycle, but if you're limiting your pull
> > requests to merge windows, feel free to submit it together with ones
> > for v6.20-rc1 at your convenience.
> >
>
> I've applied patches on the tree. Sorry, end of the year as usually
> "unexpectedly" busy. :) I think that Christmas and New Year time is not
> the best time to send pull request. Also, I am finishing of creating
> the tickets for xfstests issues. So, I hope I could start to analyze
> the issues soon. And, probably, we could have more fixes for the next
> merge window.
>
> Thanks,
> Slava.

Yes, that's fine.
It's the end of the year, so please proceed at your convenience.
If nothing else happens, I'd like to address some of the necessary
improvements to the NILFS utilities build and focus on  issues around
rename operations.

Thanks,
Ryusuke Konishi
