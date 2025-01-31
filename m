Received: from mail.inka.de (quechua.inka.de [193.197.184.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18732632
	for <linux-nilfs@vger.kernel.org>; Fri, 31 Jan 2025 08:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.197.184.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738312937; cv=none; b=qa4HgDOKtq/dnN1lgqV/OxTCH6Prn6P5MeVbMVeY9nTcpezPWbTQMBU0Elz3IN0tuBiEIvoj55NwEYLaQBWgpOKIEB43gPI8NGyCTYH9SGDbrOya9tWuiRG73O0x4IkN1Q3Jei6KtcX7fwtXZGbHKuLUHGPTinUHNNPQmrIiWcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738312937; c=relaxed/simple;
	bh=I/RMwky+hgI4v4pq9gBtg8tdf/i5vrV29XN4+j+4sXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZfAZBdn2My3O+PHLa+qZeudypjsQtIVpWTBGgWyy5ULKfbewY73jDDXX5CYpvz/rR91sJXDvC7Y6LDCGBuac8Nb4JTzKw4gQVQbt/6+sh6xxQYasnmTkekzXPkFAFfhRIsOynuQRX1604DxMaLKDOYUZ/SqnxUMJn/A9vFCK4qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inka.de; spf=pass smtp.mailfrom=inka.de; arc=none smtp.client-ip=193.197.184.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inka.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inka.de
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by mail.inka.de with esmtpsa 
	id 1tdmA6-000GCK-KX; Fri, 31 Jan 2025 09:14:02 +0100
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2f43d17b0e3so2959069a91.0
        for <linux-nilfs@vger.kernel.org>; Fri, 31 Jan 2025 00:14:02 -0800 (PST)
X-Gm-Message-State: AOJu0Yw4BQrwaw2XCPBKkgI53C+4s8YYfmLZvxYf6ZNouY77u+3xSEiL
	CRRdxJyh2oocvMv1LpdHaWriMav3TODSVnE/hol70bYmxzTcFNF3gFPPOVXJf4Ao4GBTcoggP9U
	3Uqcq9rSuRyIT3aXYfCiBHwsuz5D0kmXCCAOa
X-Google-Smtp-Source: AGHT+IHoKAt+sKbLyuevFHMyUxsQxKVXW5/f46ppfvaO970zUqosmLB4yRCvOmxxeyb5PmOdEhj21fh0kViHT7WhmwQ=
X-Received: by 2002:a17:90b:4d0c:b0:2ee:db1a:2e3c with SMTP id
 98e67ed59e1d1-2f83abab598mr14537504a91.1.1738311241169; Fri, 31 Jan 2025
 00:14:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+m_8J37qo6fKFUp0wpRuK1FHawXNmCMiEyVYEwpt2Nc3uX5Og@mail.gmail.com>
 <CAKFNMokeyee6PEAHs+zs2OO8gEKftK+_RCt9wYD+2cG6sEqDoQ@mail.gmail.com>
 <CA+m_8J3Cf5BZUB-c4gVko84FuA0=OtyNCq89A3gJR8-vcTxDyg@mail.gmail.com>
 <CAKFNMomiYJhNXTTVH5wRuWSBEEYmHcnxqRU8iUPVxFNmfcezMw@mail.gmail.com>
 <CAKFNMons0oLVgByGXEa4Pv3rgxmgEYP9h4z_fjgMm1qjEJDHFA@mail.gmail.com>
 <CA+m_8J0UjaOONaRwSMTCup-8xFmjkf6rHaLv0XSMOmvR3_d=PA@mail.gmail.com> <CAKFNMomMZB9oBppxqfAebOQNHAS1+fQRTDPORVH4PYTVnapBig@mail.gmail.com>
In-Reply-To: <CAKFNMomMZB9oBppxqfAebOQNHAS1+fQRTDPORVH4PYTVnapBig@mail.gmail.com>
From: "Felix E. Klee" <felix.klee@inka.de>
Date: Fri, 31 Jan 2025 16:13:34 +0800
X-Gmail-Original-Message-ID: <CA+m_8J22Maw3+=13QvCKvy5fQpFQ+taCZDU3m2yXHAh1+B3QcA@mail.gmail.com>
X-Gm-Features: AWEUYZmkO6BreResNGyhe8Gf6efb18z2eBVqwQPkaV9uDg_2XQNrYnmgWC09RoY
Message-ID: <CA+m_8J22Maw3+=13QvCKvy5fQpFQ+taCZDU3m2yXHAh1+B3QcA@mail.gmail.com>
Subject: Re: Massive overhead even after deleting checkpoints
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025 at 2:25=E2=80=AFAM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
> GC runs automatically in the background based on the watermark
> conditions set in /etc/nilfs_cleanerd.conf, even if you don't run the
> nilfs-clean command.

When I run `nilfs-clean` with options such as `--protection-period=3D0`,
will that change the settings of `cleanerd` until the next reboot? Or do
the options only apply to a single GC run?

> If you want to ignore this ratio and force GC, use the "-m" option,
> like this:
>
> # nilfs-clean -S 20/0.1 -p 0 -m 5

Thanks!

Regarding `-S 20/0.1`, that means the cleaning happens 20 times for
every 0.1 seconds? And each time `nsegments_per_clean` /
`mc_nsegments_per_clean` are cleaned?

> LFS is a legacy method and is not common

=E2=80=9Cnot common=E2=80=9D I understand, but why legacy? What does supers=
ede it?

High frequency snapshotting is something I am missing from other file
systems.
