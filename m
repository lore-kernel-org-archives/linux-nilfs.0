Received: from mail.inka.de (quechua.inka.de [193.197.184.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC13A1DC185
	for <linux-nilfs@vger.kernel.org>; Thu, 16 Jan 2025 11:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.197.184.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737025757; cv=none; b=K0s31M0VugKqMypb3twL0eehzJQyEUQdbZN3o3NF7Fc6ZiQFozTLlzpdOnF7OgFlIQjyqtQ1tDJOEONZA5kLOTOSWVSLFZk4QyomcobU7rMW4rA3pShF1vO/QS0k/Cp5Fgw3nN4OpGgrqhPpD/1gs8p09gbu2b3J7ThvIoQ3xSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737025757; c=relaxed/simple;
	bh=WHEimvYZPRqiaK5dL+/3qIhFU09jlNtIMuDy76GNIm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lSlWwluye4JDG8d+6GCcHfAlLbvk8WCrQQ8LuttOfWrOQLfJGO0K4UW+mK/hNYkSDEm4IObcCfQeDUhuFQjBeqwCGUxtXucI0U6JE26MPetsVrBF3UGSmmCZ2n/bfiSDVTxuXRFnTL7vLsbq/Au8jVBFhEjqNoDqhcC9MAEp5cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inka.de; spf=pass smtp.mailfrom=inka.de; arc=none smtp.client-ip=193.197.184.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inka.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inka.de
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by mail.inka.de with esmtpsa 
	id 1tYNkD-009gGB-NK; Thu, 16 Jan 2025 12:09:01 +0100
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2f44353649aso1132177a91.0
        for <linux-nilfs@vger.kernel.org>; Thu, 16 Jan 2025 03:09:01 -0800 (PST)
X-Gm-Message-State: AOJu0YzkdhYyw8NOuBMyG101Wq7G6dOUXFx+UMYQniA5Yu16WJdaosZ9
	nSyOh8UTKDwKy9gCe/YH3gQariR0hiRskCR4A8hRyquoLWv24mJb2u3a7KnEqnf2MJvWnBg2vaR
	qAxTywqWscWCJfLt88dTtxHaJbhdLtTQGIeyo
X-Google-Smtp-Source: AGHT+IG6UPjpNKRFIEv2VLsCsWcuXv1QbZ33w2ABCv6NtLaQQ9+SjSVCn/m2vNlCQf0c7IR4Ky02glsl1nYy1fYLtR4=
X-Received: by 2002:a17:90b:2e4b:b0:2f4:465d:5c94 with SMTP id
 98e67ed59e1d1-2f548ebb621mr48424814a91.11.1737025740051; Thu, 16 Jan 2025
 03:09:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+m_8J37qo6fKFUp0wpRuK1FHawXNmCMiEyVYEwpt2Nc3uX5Og@mail.gmail.com>
 <CAKFNMokeyee6PEAHs+zs2OO8gEKftK+_RCt9wYD+2cG6sEqDoQ@mail.gmail.com>
 <CA+m_8J3Cf5BZUB-c4gVko84FuA0=OtyNCq89A3gJR8-vcTxDyg@mail.gmail.com>
 <CAKFNMomiYJhNXTTVH5wRuWSBEEYmHcnxqRU8iUPVxFNmfcezMw@mail.gmail.com> <CAKFNMons0oLVgByGXEa4Pv3rgxmgEYP9h4z_fjgMm1qjEJDHFA@mail.gmail.com>
In-Reply-To: <CAKFNMons0oLVgByGXEa4Pv3rgxmgEYP9h4z_fjgMm1qjEJDHFA@mail.gmail.com>
From: "Felix E. Klee" <felix.klee@inka.de>
Date: Thu, 16 Jan 2025 12:08:32 +0100
X-Gmail-Original-Message-ID: <CA+m_8J0UjaOONaRwSMTCup-8xFmjkf6rHaLv0XSMOmvR3_d=PA@mail.gmail.com>
X-Gm-Features: AbW1kvbi_T1hddsw4YIRIOiZZWe9GluSvEMrdnx5mu-Zlqgbt4g6_DWwb8wO8Ko
Message-ID: <CA+m_8J0UjaOONaRwSMTCup-8xFmjkf6rHaLv0XSMOmvR3_d=PA@mail.gmail.com>
Subject: Re: Massive overhead even after deleting checkpoints
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for the detailed explanation! The overhead for metadata is
what I expected. However, I wasn=E2=80=99t aware of the default protection
period of one hour, also not of the concept of segments.

Now, a few days later, I get:

    $ df -h /bigstore/
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/mapper/bigstore  3.5T  2.7T  699G  80% /bigstore
    $ du -sh /bigstore/
    2.5T    /bigstore/

The used space reported by `df -f` is not 2.7T vs 3.0T a few days ago.
Back then I was apparently too close to a major file operation. I had
geotagged tens of thousands of raw image files, modifying them directly
(exif headers).

Should the following command have freed up diskspace?

    # nilfs-clean -S 20/0.1 --protection-period=3D0 /bigstore

I realize it doesn=E2=80=99t reduce the number of checkpoints.

I really am a n00b when it comes to log structured file systems. I just
want to use NILFS2 for the ability to revert accidental file changes.

One more question, as you wrote:
> Incidentally, the reason why the df output (used capacity) of NILFS is
> calculated from the used segments and not the number of used blocks is
> because the blocks in use on NILFS change dynamically depending on the
> conditions, making it difficult to respond immediately. If the
> dissociation is large, I think some kind of algorithm should be
> introduced to improve it.
>
> The actual blocks in use should be able to be calculated as follows
> using the output of "lssu -l" (when the block size is 4KiB). For your
> reference.
>
> $ sudo lssu -l -p 0 | awk 'NR>1{sum+=3D$6}END{print sum*4096}' | numfmt -=
-to=3Diec-i

Certainly interesting! But, I assume, without garbage collection I
cannot use the space in sparse segments anyhow. So `df` should give me
the space that currently is available for actual use. Do I understand
that correctly?
