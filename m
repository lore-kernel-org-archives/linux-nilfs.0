Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF37D3AF677
	for <linux-nilfs@vger.kernel.org>; Sat, 19 Sep 2026 03:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789787268; cv=pass; b=ljCNjxC2Zze86DeckzwYH3FyNDGC4lNHl/E+E3QySOQ/r8XPtJL0Csm27OGYQ4+GeZhjYGIzDb73O2ImVf7AC/Cs+w0u2IcPzhdEEFBYaAC77FM7LQk5/HhNQSn+mfPDTfpVv38LDKi8fEkC/H1TqFCQGqe7oFJcShQKT4p6I3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789787268; c=relaxed/simple;
	bh=w0FzqTkWxvgr+7fjcUx1t+0g43Cb2S3hJxh82YqqopA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SGtzT9jKnE7F8iPAcxX9xwLCC4OwvwL8kh1/rSQYPBAPdMN9W3XLNKNvI4bE2LehXMre0tA5zCeV5aPEHdvX5BNkQ5do8rB6/AIGwk3bKqjcKbVBd+6qxF2jWWe7RksPAeR45fW5CQnugI/D9wKwLtxB7TzUts5ooxmpvUBr/iM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PWF0nMm3; arc=pass smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWF0nMm3"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b5f21afe8cso2771653e87.1
        for <linux-nilfs@vger.kernel.org>; Fri, 18 Sep 2026 20:07:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789787263; cv=none;
        d=google.com; s=arc-20260327;
        b=Ee6w48HSqdNr56aAqSbiihrP91RaHKgF20NC06pxUyiTkfpphyd9u3fVaiJvreZE/H
         2FAFs0r7FLGLkFf6xyJ7jQ/yvRdk7+qlw1FtFrtMEOna/Wat6P1ghwxuEeB+sPy4/rv5
         GHFqtCFskqHBhw48HSc/AZRJip5Q9ER95HFBhnGlH6AIZuX6Ngv/ON785s69bGxh+QUY
         gDrIis0F5pZnAZKqTiNKepTbQwCYqqwtX2EAUob1cdhUVAbTJqcUMD5zj69fMa25kF36
         acNQ7R2d5ap8HHbE3yR8e30mi6mhAnsFZUl0OKS/z1jG7kmjD02qEncug+SrbbFTotn+
         9Y6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w0FzqTkWxvgr+7fjcUx1t+0g43Cb2S3hJxh82YqqopA=;
        fh=Lt7a9rlRZVrfsyNBHQxuKmPahRGMWY2a/sHc++sXvXc=;
        b=mqtcK6C2788mlCd0nmlcn2yZLMqPJezW6f7srXhpgHNJUrE0ovv4DJKy6EbBfwDEu0
         nVrs1vvEnL441o2TO6/FYL3X5HR0X4lyZOUx8FUkYQg5UlF+OVw/oCfcE95fPkxNtQ5B
         ZzavcTMlgJxlicr7zrh7KKA7KHsKVFC2GKIXRCoNEwBJgVNkKwJzr23WRoW6sF+BSXaz
         2hMHUOFPOabbbfgZqayHuh4hGHM98HkHbsH6gm9qR5I1puBKnYnzTp4G1HW9OMoMyh52
         589W1cobJBA65frqqb4SRHKwTPRv2fcrkaedRCE+vJQM+3cghp1T8PvB0JhqSNmHC71l
         6ptw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789787263; x=1790392063; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w0FzqTkWxvgr+7fjcUx1t+0g43Cb2S3hJxh82YqqopA=;
        b=PWF0nMm32bsts05N9GBf+6CFTSNwZOkQCILOyYWvogxl1k3kk/xkXI5Chx4ImKcGoA
         I70f2KwLZG5JgygwJ+/bw1ZokfCxdEt6YNxYNPTC8la47zSKSEy3Ch7BUnzf0Y5B87L0
         NGZauxfGZ3VpPHQqGuSJgwNN7MyZjfdZa3mLb2aRnxI6NOxo/IBJKET9XIrZt2O7enj/
         XYGYND3Evss+W8ixfwVRFJFcqOJpt4Lk0K0ovlRtiDe2NXrrLJVIFnG+zVtp/2TflS/f
         7Xdb744AMBpG0+kwwvujDcghWQA+ofTYeAHpIm5xJVN/f9CnXdRIPLoJU/1Qy3gI41H2
         If8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789787263; x=1790392063;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w0FzqTkWxvgr+7fjcUx1t+0g43Cb2S3hJxh82YqqopA=;
        b=Wx+LBTGqpqjddm2WrUL/OHhJPvFdPIsMrkZ+pfqe/ikIQGHoAb3zJz+7H5H6fwDIeW
         vQdTwLQG6BxPQLxKjupbYtSMTkWfCVDwgCZL9lCAI6WzqIn1yw98M9OvroeG2pArgcZ6
         GUyjkAyi7MPNh/2m0NKDCpmTMKX2qbcFriucdzIGvAD2j3uHoXDHm7z3POoeDDGEPr96
         mzE/4RaYt5NjEG2l0vAXMMvS/XUlUKGLqgpiinoH7a+8Xe8jqRejqzKVTIIKsovXYh8T
         71emXrZrsfTfckUsnsIawRHbXVcev6s+GCU4VOmPilkmkwtVPZ/CPpB+ZUrSq6kACu7E
         C13g==
X-Forwarded-Encrypted: i=1; AKwUvBwy37pdnayVM0RM6P7gPSQx6sbkdvXlu79pvKPWTQIwwtQiS9yRFaRjuUJPm4b+8QgDe9nLXu1MeIet4Q==@vger.kernel.org
X-Gm-Message-State: AFuF++nPTr3jQM0fVXo9Oxz5TrPBqW6BtrlhT2sJTsxKryvHGLD5DoKD
	QcuJutRrlTk/qvXLgUDMm7OGSzyMPygZqj9zU/i12MTsRaGcQ8w3Rs/6uGcAgRgKCeXtatuWNj5
	oxZWzHNxncj2WJHclH6X52XLZq7Q5TyY=
X-Gm-Gg: AYBFou1R3lvvtMgPpPTl3uwT+ZCVvMX1BpzyFWIL8MEgvTGc2GdCqi0fiPXrsUmDdo4
	wYXn0dfzM1su0eKoz3IaInhrc+QOu7RYZk1Cr0ecwUhtEyq6S0WITjKXwf6BqaeoV88+mCj8fcE
	06k6Y5dCtubbnD+BVhCUHkellVLLBC1PKpROrmG9D7VzOHATScFVpMoMc2uPurz6OXXidSS6ox4
	KWV2fsiz8fqtAGgS2Eb2YU5OUPJgrRVIkEDu0fFW1YsdF3VrJyaaM51eRdXlLmG+7VAV9uQ2XOS
	mtOvxttR6W9ocj3IhTOWviE9eMXRczgqpD6g94+z/kYSZllh4NlWe9g2EFOe9V05p4k=
X-Received: by 2002:a05:6512:31d1:b0:5b8:c53c:468 with SMTP id
 2adb3069b0e04-5b8c53c0572mr850142e87.40.1789787263185; Fri, 18 Sep 2026
 20:07:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915111351.2726334-1-qwe.aldo@gmail.com> <CAKFNMo=0hDANOd+DxxvKA=RNbiG-zygkWh6EUC6Vr2MYe4npLQ@mail.gmail.com>
 <e197037b70377be78b296380bcb31b8c3e8f8d74.camel@dubeyko.com>
 <CAKFNMo=0-rxN0BKG1v+KhrGwnh2ZL_Hn2Jbcqc9sWRV8cwxPrQ@mail.gmail.com> <2f638ff0568a55233899b2a7ef4dba3ed945bc51.camel@dubeyko.com>
In-Reply-To: <2f638ff0568a55233899b2a7ef4dba3ed945bc51.camel@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 19 Sep 2026 12:07:26 +0900
X-Gm-Features: AcwNN1XrKGMdprmXwaOngP5OHZSqj1InSVDqZdmSH5-4vyq3vJ2CKSIXed7wrwo
Message-ID: <CAKFNMonz0QUmCL2L7dcx=sxNp7Ept78QMLvy9hZ766LkOXj-vA@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: validate file block counts during recovery
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 19, 2026 at 12:01=E2=80=AFPM Viacheslav Dubeyko wrote:
>
> On Sat, 2026-09-19 at 09:46 +0900, Ryusuke Konishi wrote:
> > On Sat, Sep 19, 2026 at 4:33=E2=80=AFAM Viacheslav Dubeyko wrote:
> > >
> > > On Sat, 2026-09-19 at 00:44 +0900, Ryusuke Konishi wrote:
> > > > Also, please replace the 'Cc: stable' tag with the following tag,
> > > > as
> > > > with the previous patch:
> > > >
> > > > Cc: stable+noautosel@kernel.org # Non-fatal bug fix; defer
> > > > backport
> > > > until a real issue is reported
> > >
> > > Damn! I missed this request. I already pushed the commit. Are you
> > > OK
> > > with that? :)
> >
> > Viacheslav,
> >
> > Since we haven't hit the merge window yet, and linux-next (the
> > destination where your for-next branch is integrated) is a daily
> > integration tree intended to be rebased before being pulled into
> > Linus's tree, updating the commit message on your branch now should
> > be
> > completely fine.
> >
> > As documented in Documentation/maintainer/rebasing-and-merging.rst:
> > "Some trees (linux-next being a significant example) are frequently
> > rebased by their nature..."
> >
> > I think it would be better to fix the tag and overwrite-push it now
> > rather than leaving it as is, though of course it will need to be
> > frozen once we hit the merge window (or after the official release).
> >
>
> Sorry, I have too busy day.
>
> The commit message has been updated and pushed.
>
> Thanks,
> Slava.

No problem.

Thanks for handling this.

Ryusuke Konishi
