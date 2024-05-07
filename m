Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2E8187353;
	Tue,  7 May 2024 21:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715115959; cv=none; b=XJCCbEzyphFQMWWh7Pny5VOAMEAS+xl7Xs6vA7fvN/tuJt5eACKANLjfHOGYtNwKvZpf1v96F46wY32LPtRgtuEJe3pN9JwhnL/A299nuBH8xQnZ4TYAyKuvtnqDB0zTaELnazZpgYqrRTe1Z9jXgn2cfmeGgq3y9fvqmkBhu3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715115959; c=relaxed/simple;
	bh=eETH8qyLZaEqH0jAscPRS9ATGH9bfwR8HhG7OFw2pEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iULKKoCpSjARI6az3xDQCyoNUnQRPmUUQdUmzXvh99Q731yHE6KCWRBsyDCXprliBhPdL+8Ts2UnozBsdPrtKuiealLYxpF7rKOvqDCSCIsGCkb9hZ5wbAgfbgz2JCiTTZrKMhCuvCS7xI3q3JhaRuX2fhtkZwZoMAYLHq6JXQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fkmyOVhS; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fkmyOVhS"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2e22a1bed91so47999291fa.0;
        Tue, 07 May 2024 14:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715115956; x=1715720756; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ef/OTw1FTNHv7I5hPzJjnHJ7ssdwk8G3HA7pFWiHOs=;
        b=fkmyOVhSpq30fxaVZF35CHYrIdhVf63/OzaOys7u8nGP/uva+8JtHlJqTMsK9xCg/A
         VJgFeltcOczLES/TQdJoZlhdDIn+eb05NV2XqmEpnAeDucPzoqE1FVMPRDyZvPWeW6W/
         dt20Qfz8/nORVQSivqR9nEsYVyGzHkuUPTkgJwqXSTi5trS8TzaUyKn+xDQ2eOqf61SN
         1Z1asqXbUpC5obCvrLVVxkP16JQdvALaIEPRK0OIdJZTcQi9ocb2oxZ913F5TVDF2DT5
         7TDvM2evGc0QCKUKvK5nJhJr71srsg5N8GUIITxXI9UpSRMc/UvV8etwXfQE48LB797A
         5XWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715115956; x=1715720756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ef/OTw1FTNHv7I5hPzJjnHJ7ssdwk8G3HA7pFWiHOs=;
        b=r2OWQIm7bCy3LOF+KxyXNZPCdXNcYOhUheQogYyClUvQYK6T0QifwrgrAm6mdjFQpb
         +ZPHSr+FC+bysW8BK1ltwp3UzWwEJJc2+r8iu9QPmFT43EmlFqWjpjPMyunsU4GvlsOp
         TF9bBETXCgxDrSMfNtYt2M7E+1V6H9jsBAWlStybwT6eukgyJVUyxKrzUDe5IpppzYLz
         bFqVadozXk5mCoP6H9MWJ0Qdo48mjF9GPFWBJDZVvuOQuLw6eeeODeypL323zR7gz88a
         z44KJ0eYfFMKF4ECdxYsM4bqgO2q53bAS7E9ytQqKPVccsgXTCpeFrYD+15kVX+1bgVP
         xdEg==
X-Forwarded-Encrypted: i=1; AJvYcCUZ4gAN6kSnJFA8uJ0UTnhNiDCmymG3XPKFEDnCWbxytMwP5Fq2bCD/rhMriSNgP6XKyW5RIdp+XaKezif/Vv9qg2A4NjkUR6u0q9eedb+E8s4sTCM0E1HvSW90zbIeHskkwKph/XaaE+E=
X-Gm-Message-State: AOJu0YwF18jv86VGjSbcQQGjJsp4ZGNO7CmGeGL88TmfjMewxcYa70PL
	FEi+dyHQfplDc/UdTzuVOS6k5OJzey/RcBcElSmYwftznBEHOIab773Cde4sOCCwWyXkYn0KO67
	HDarWHBhZApSbySWVi7eKN6eL1wY=
X-Google-Smtp-Source: AGHT+IEIPqLuIXqUPlxdyHE8emQsQqvKcbB68EsssulBsPpJLcFAWFAY6+qF2e0EvPA5ZpCevCys7JBbmezZOATtWNk=
X-Received: by 2002:ac2:520b:0:b0:51d:4472:c3f8 with SMTP id
 2adb3069b0e04-5217c667418mr362253e87.35.1715115955829; Tue, 07 May 2024
 14:05:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240507142454.3344-1-konishi.ryusuke@gmail.com> <CAHk-=wgogPoSdCYw9jhc2Zm=BaE19nXYwFn_F9SwD2C-DyrmCw@mail.gmail.com>
In-Reply-To: <CAHk-=wgogPoSdCYw9jhc2Zm=BaE19nXYwFn_F9SwD2C-DyrmCw@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 8 May 2024 06:05:39 +0900
Message-ID: <CAKFNMonSDOWt20nq6UngSO1_7L-DLRMiAbcKXmquF04qbfC55Q@mail.gmail.com>
Subject: Re: [PATCH -mm] nilfs2: Use __field_struct() for a bitwise field
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bart Van Assche <bvanassche@acm.org>, 
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 8, 2024 at 1:25=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, 7 May 2024 at 07:25, Ryusuke Konishi <konishi.ryusuke@gmail.com> =
wrote:
> >
> >    Despite that change, sparse complains when
> > passing a bitwise type to is_signed_type(). It is not clear to me why.
>
> Bah. The reason is this:
>
>    #define is_signed_type(type) (((type)(-1)) < (__force type)1)
>
> Basically, the way "is_signed_type()" works is that it casts a
> negative integer to the type, and checks to see if the value has now
> become a large value.
>
> Now, it looks odd, because only one of those casts has a "__force" on
> it, but the reason for that is that casting all-ones and all-zeroes is
> ok for bitwise types (think of bitwise types as being a "collection of
> bits" - so all bits set or all bits clear are sane concepts regardless
> of any other semantics).
>
> So it's not the casts themselves that are problematic: that part works fi=
ne.
>
> But you cannot compare a random collection of bits for greater than or
> lesser than.
>
> Think of things like byte orders: you can compare two values for
> _equality_ even if they are in the wrong byte order, but you can't
> compare them for "larger than" unless you turn them into the right CPU
> byte order.
>
> Basically, a "collection of bits" doesn't have an ordering in itself,
> even if equality comparisons are ok.
>
> So yeah, is_signed_type() doesn't work for bitwise types.
>
> And I don't see a sane way to make "is_signed_type()" to work for
> bitwise types - the whole concept of signedness of "bunch of bits" is
> kind of nonsensical - so I suspect your workaround is the best we can
> do (alternatively, tracing would have to figure out a different way to
> test for signedness).
>
>                  Linus

Linus, thank you very much for your detailed explanation.

I would like to edit the quoted part of his commit message

> >    Despite that change, sparse complains when
> > passing a bitwise type to is_signed_type(). It is not clear to me why.

as follows:

 Despite that change, sparse complains when passing a bitwise type
 to is_signed_type().  The reason is that in its definition below, a
 comparison will be made against bitwise types, which are
 random collections of bits (the casts to bitwise types themselves
 are semantically valid and are not problematic):

  #define is_signed_type(type) (((type)(-1)) < (__force type)1)

 So, as a workaround, fix the warnings by using __field_struct() macro
 that doesn't use is_signed_type() instead of __field().
 ...

I will try to resend the patch later unless there's a misunderstanding or
I'm missing too many points.

Thanks,
Ryusuke Konishi
