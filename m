Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51E2165FA4
	for <linux-nilfs@vger.kernel.org>; Tue,  7 May 2024 16:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715099130; cv=none; b=ofZXz+By5S+nDxh6R5KuKrOiH/TthYTDngiDEmtvqWDRLDwZHAqlnaSvwZ5zKfXiZxSAX91w1lVrKlzWq8BBwdsPS/j5/oiIhwNCZMOwema9RZwaFiqQrmwWshKTziV4mpzf5gnz6T384f0UW4HxmJtfJLYcaPS5XFJpRzrVIFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715099130; c=relaxed/simple;
	bh=5/4nUFGzVCKyh1B64hVam6vzkGBnCWQpN7HzGYdQUhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KHMLcQPo3gH+XPjTnJ2fa0V3jmc3ELyLsTEt1mNgQ5FJoBhyoD4EqxROUSMmuTWwL/0UTTyqV4vPjnDpkBn6XzwB+C951ugUDd8ys+W6FEYKYwiJXGyP1qUHeCginq2z0OMfeY2M/qXwg2n9W9Y3EFjmR0acVV2587Er8PT6bLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L3FruZzs; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L3FruZzs"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a59a17fcc6bso772270766b.1
        for <linux-nilfs@vger.kernel.org>; Tue, 07 May 2024 09:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715099127; x=1715703927; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qsg2qiI3lz3EhCF2HZdFnC7wmOTqjTes666QVJJQB9w=;
        b=L3FruZzs0HaKvGnuQxR0jF7PdeALJRIlGBpcLZKx5sBfxRv+ySo1LK/iknCVL889sG
         LRlC0oy/r4BhvJzSwY1b1UKkI0/rr3RuEjYewtz1p3m4FY6wvFzlu3pbwaG3TyRHVKD9
         j3pm3lg06DYdNbM5B796G77pqKRQQ8eEApFBA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715099127; x=1715703927;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qsg2qiI3lz3EhCF2HZdFnC7wmOTqjTes666QVJJQB9w=;
        b=qajmAlfs562oS/i0MZ8F9llt9LaMh87B7UHGEpylhH1P/VCxzGzhGFzwO+UZar5gFg
         6Dk/YR2drknsAsTaoysvwOD/nkV4uQOzDZDdfEn+hPVAkLYhrHD5PzHZVAyhqiYnMiNp
         e07OoYG4ntpkZGmJahFtNUf9PG1o4ZnnpltN6GWwlWXhHpBC5ptqaX9vm0vN3/0QGFtA
         bEVqSFDDkMP5AVTrHNAUmgnMB6MXt7vyncer1GBr2qnlPm51TMi/245gsRcPf2hgYIli
         8Qok89xygAwtP0lMIU+BLmUzRBXKvZrXOrciS4ZZCD0mgCzi7m0uzxxEOjz/WTGPIozO
         Z7cw==
X-Forwarded-Encrypted: i=1; AJvYcCUcMWHv6Tbo8g3/5j1iqlYxfv+yKLyPDFqSDY43Zcsa2YFCDce/Pf3b7nuOp0QE0fBH1/FMLzWfetuyBCZVdrC4t8LGexRKy6FI6mE=
X-Gm-Message-State: AOJu0YxoBT3+yHy3fkmQROgNqKC/UueRYnsec98i/CYtISGJNPw4KVq/
	U9StT9EuUyWo+eFbFdFbZVxJk/0GKvt+ujuZV7TC/+EW56Z9TeX/0Q8Aqp9YRvRIHiVbAmhE5Oq
	e6n+ozw==
X-Google-Smtp-Source: AGHT+IGBhK1I1bKft5zoswkBijANJlXG8DPXhwiRN2jUiWg4oyQDG+h/pTB/McwquUM1A5SXZf9kow==
X-Received: by 2002:a17:906:2b84:b0:a59:a5c3:819e with SMTP id m4-20020a1709062b8400b00a59a5c3819emr5839783ejg.11.1715099126976;
        Tue, 07 May 2024 09:25:26 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id b15-20020a17090636cf00b00a59ae204e2dsm4079283ejc.43.2024.05.07.09.25.26
        for <linux-nilfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 09:25:26 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a59cc765c29so579992866b.3
        for <linux-nilfs@vger.kernel.org>; Tue, 07 May 2024 09:25:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUZcU4lZdvL8PfGnwyP3tOIvSqAsJN/INegicL6SCBksuoUnpR2/s3zFMfVtE2Rinv4Ohnfk9rP4Ysb0qQjlc5AHPH1P0fiU5LjRYU=
X-Received: by 2002:a17:906:7804:b0:a59:f380:1821 with SMTP id
 u4-20020a170906780400b00a59f3801821mr1149640ejm.69.1715099125946; Tue, 07 May
 2024 09:25:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240507142454.3344-1-konishi.ryusuke@gmail.com>
In-Reply-To: <20240507142454.3344-1-konishi.ryusuke@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 May 2024 09:25:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgogPoSdCYw9jhc2Zm=BaE19nXYwFn_F9SwD2C-DyrmCw@mail.gmail.com>
Message-ID: <CAHk-=wgogPoSdCYw9jhc2Zm=BaE19nXYwFn_F9SwD2C-DyrmCw@mail.gmail.com>
Subject: Re: [PATCH -mm] nilfs2: Use __field_struct() for a bitwise field
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"

On Tue, 7 May 2024 at 07:25, Ryusuke Konishi <konishi.ryusuke@gmail.com> wrote:
>
>    Despite that change, sparse complains when
> passing a bitwise type to is_signed_type(). It is not clear to me why.

Bah. The reason is this:

   #define is_signed_type(type) (((type)(-1)) < (__force type)1)

Basically, the way "is_signed_type()" works is that it casts a
negative integer to the type, and checks to see if the value has now
become a large value.

Now, it looks odd, because only one of those casts has a "__force" on
it, but the reason for that is that casting all-ones and all-zeroes is
ok for bitwise types (think of bitwise types as being a "collection of
bits" - so all bits set or all bits clear are sane concepts regardless
of any other semantics).

So it's not the casts themselves that are problematic: that part works fine.

But you cannot compare a random collection of bits for greater than or
lesser than.

Think of things like byte orders: you can compare two values for
_equality_ even if they are in the wrong byte order, but you can't
compare them for "larger than" unless you turn them into the right CPU
byte order.

Basically, a "collection of bits" doesn't have an ordering in itself,
even if equality comparisons are ok.

So yeah, is_signed_type() doesn't work for bitwise types.

And I don't see a sane way to make "is_signed_type()" to work for
bitwise types - the whole concept of signedness of "bunch of bits" is
kind of nonsensical - so I suspect your workaround is the best we can
do (alternatively, tracing would have to figure out a different way to
test for signedness).

                 Linus
