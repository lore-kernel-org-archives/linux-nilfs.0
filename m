Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEEB36D9FE
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 03:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785210565; cv=pass; b=AP4Daouj1g0z4KEBC6ZWX7fmEYKOCuvi5ySG68aRguWFki51fDcb301OUB5w2cDKQOwhgA2phdDFpOLl4juCI27XYRuIrbf4sUEAiykDl0lVd2cx9cR615ojVNwMcOlq2sHxtF2jSrnbpvG9E1NPjUk40oafPDDtyP7gg0gjgGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785210565; c=relaxed/simple;
	bh=dujJLBIcIKS5PN8KWDYWAqd56jSfY4IpNR+KbOL5HrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZBno/kql+i/Fpzy82Bdf/uOgdUkpTQPYlGvGSe+PGRCAeekFAEtQ1xo6R6PE8ibC5PjQUrHQJBKIWKmxV2unmhnVEzm5Znqd6Puu1nFnvABnZUD8fV44XbWCjbz+uAqfkUYHQVCclo/WHAjWu5kl/0xliKQQx9TED3wOh4jnMb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2PpyzP3; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2PpyzP3"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b28c91fba5so652976e87.1
        for <linux-nilfs@vger.kernel.org>; Mon, 27 Jul 2026 20:49:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785210562; cv=none;
        d=google.com; s=arc-20260327;
        b=C96BoSNuHpKeLsJ3P1dDD8VjpNrN8vVEHSeYS8gtKTzbSXXoyXmyElgnA5JlT1uC5u
         BTdXNXrSZs85m88HUFO0Ka6e7xLzYQ1Mi+T/yjIXPYy0jsondm8K+vIPj8OUtdO4UBkD
         74XNcq3CdmlMyEVUxoW0+ZBg9P0Fo2/eNp3rJ3BEh2u1jSefgCUYld8d/fw1lXHdyUW8
         O9+8AxI5UQx0/Zeyt7XHoqz8+j22G8VVHUErS7TErmJkmIB1wa2eIb66YpCB9DxdM/qe
         zdK3Hu5VqEdLkjkVu73sAkOvRc/NvxzrXZWLIyC1J6tJsbqdVfbCYFWbI9B8GPvzh1Kn
         d9jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dujJLBIcIKS5PN8KWDYWAqd56jSfY4IpNR+KbOL5HrU=;
        fh=ygh8rkfGLU8YV0tQcispQiLpo8WvdHhXg0+rmC27bL0=;
        b=e0yaUnD2wbb7iSMXF+qHAM+sPLCFrM6FcTwuiPRCQlse7xFZTjLPl/yMvNLvAkYASl
         RqGaAUUm0/gJiKBX6SNuH6k0BWHUpZChWvLjcN+pwdVl7X4TxmxQvMQpPFLZmugaZsjj
         hGFTNXUQJjsRg7GbN1M6gLLdC8UJYdE3vCpMnACTTL++ZgloF+PXR763S1JRa995Gjh3
         sRY6/1mSXlqP/LmZQqDwH48/dB44U9914mu+mO/jDplbicSNURKdJYtJKnqBADb51GaQ
         uMy+OMYpXL/C1A5WRnKsSDSeSlgXivs/UsxJ9vyg6CmFUWhhHFtvY7b9KnuIFkcXlk7R
         XlgQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785210562; x=1785815362; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dujJLBIcIKS5PN8KWDYWAqd56jSfY4IpNR+KbOL5HrU=;
        b=W2PpyzP3nerpMNgI3agITjQtpgUm28lRy8UptjwF0gIBgQEkIWQ7yv5UVCorCYQk4Q
         SYb0uPf0OpDHggX+Il4KfQkllulrkBSgiWFU9u7AhLrQ8f25v8kwl9dWLblcHf7aCJmC
         aHfm0iy+LjiyrnDB5FY165NpYoj1JeMCRX/avCSGw24lyFjIQ7gRdZg38/LSnOfrxfYZ
         s6yxdI7fIJ42Ix7ZdubHsn7n8SIoaDAtXSh+nu1C5jNh0q2JohtrqFr5P5yKk437W67P
         9n0M8IvvWQ53kdwT0iKGqQGRhljgXibmmBt3eE1en4/v1Qx4BarvAV+dWHBZQ/WQ6nAG
         buUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785210562; x=1785815362;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dujJLBIcIKS5PN8KWDYWAqd56jSfY4IpNR+KbOL5HrU=;
        b=JFw7viD0HTBRhxTmXQM7ABAM5yMP2HXf8yfevYFAjG7mrV5qnLjSxUVzAAGcleFGl1
         klSHLDw5t6/SqGDCxKV14Enm1NIwYYTDrWZjkTg28po/FKewbLlr/TrOh/5m+SdyKI/6
         p2CFIem8zOZFxoVWkdxYSYJ9Q+8q+xvFhRqAGG+pgAXtFmTnrYVBLmDr/ALQsI/btLT5
         Auf8Pa8JQTOIpKGOpDutwPdh1WY3yc2RTRHzgH8eI6duDkV/r4QJmeoT1Hxpqm8gas0p
         lmdPg2rRSGLJWWBowrZ83+wf9wnCEBKXDwgkc5D4HD/LFYp1eH5MRA0aOjKDwZV08l4z
         XNmQ==
X-Forwarded-Encrypted: i=1; AHgh+RpHRJ9RXCgXij2PrgaOdV7k5/w12wfx9YCFapoCrHEUVGPKPUjiVb++6pqZ5jKUKoOkI5yLLQGYINf+XA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvd3ZVscvQacKP2bQ8bG5afX+aiVRhS7sp0tTlvh0QE1XZn+IH
	xk07WHypjzEaqhcNuaYF2Av02I7/TPBtDsM61s0fvMjcM5IpuytjYdKfJZJnnyJFSHGs6xuYw40
	NCSPkgSt3hkmDb9I2E/GKMrhNlHuUERk=
X-Gm-Gg: AR+sD11vfsZvegrBtkRwLnUDK6hVVC933Wa6A53rwQOXXsQMtfeBf+Eh8EyrpvjkLdI
	MKFl/LAoEooVOHbKi8NUkmBil/MDqgPpdimi7bs1p19e+plUWtTpYPuJuRdbvUDRs0uz1hN8NNY
	KWjdES1/O8DuYCoelIYMWqnwpIQA4Tw93W3H1cqDO6nP8PLKRQOV1JrnQiJJmwGOjUEeernv6JU
	k2S3WVqzJ+RHWKrgHH8nDHdga/Jm+GSnhZejoQ8ru0l6jJja12ruQo26J78FOs=
X-Received: by 2002:a05:6512:1351:b0:5b2:b02c:e8ce with SMTP id
 2adb3069b0e04-5b2d025e1bcmr70990e87.30.1785210562054; Mon, 27 Jul 2026
 20:49:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724222745.2107464-1-slava@dubeyko.com> <20260724222745.2107464-2-slava@dubeyko.com>
 <CAKFNMok2Op3dAAU8zGWLNPLeh8wj42MgQZbEdP1wSj8jnsO_+Q@mail.gmail.com> <81011aff679fbb673a35a4b049f65b59eed7a233.camel@dubeyko.com>
In-Reply-To: <81011aff679fbb673a35a4b049f65b59eed7a233.camel@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 28 Jul 2026 12:49:03 +0900
X-Gm-Features: AUfX_myioaW8LtNvXSArg2YGK6sH4nnA-hREwsfZkF8XIJRy5m0xFV2VL4az-TU
Message-ID: <CAKFNMomBpySX7cqPUdVjdmaBMOnguDT_miNMK04b-H86BUYvxA@mail.gmail.com>
Subject: Re: [PATCH 1/2] nilfs2: add iomap operations for direct I/O reads
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: hch@lst.de, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 9:46=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> Hi Ryusuke,
>
> On Sun, 2026-07-26 at 07:33 +0900, Ryusuke Konishi wrote:
> > After encountering a hole, I think we should use
> > nilfs_bmap_seek_key()
> > -- as nilfs_mdt_find_block() does for metadata files -- to
> > efficiently
> > determine its length.
> >
> > However, if you are short on time, I am fine with the current
> > approach as well.
>
> I think we can rework it later. I am starting a new job today and I am
> attending FMS 2026 next week. So, I am expecting to be really busy at
> minimum two weeks (probably, slightly more). So, let's keep it as TODO.
> Please, remind me to rework it later. :)
>
> Thanks,
> Slava.

Hi Viacheslav,

Understood.
As I mentioned in my comment, it=E2=80=99s fine to put this on the back bur=
ner for now.

Thanks,
Ryusuke Konishi
