Received: from mail.inka.de (quechua.inka.de [193.197.184.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053011E0DCD
	for <linux-nilfs@vger.kernel.org>; Fri,  7 Feb 2025 04:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.197.184.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738900861; cv=none; b=ZdkgALPh6uNRmub149R8eM3Q4suGBU/ScOdZeBb5zl8yo4fLjg5ZJteqrygDJmBYrqYi9W1vt6r73W9To21luHxaBvPskFDzI4QgR6MzBjaKJrQJEmTo71DcRuWKlGnYoKCZXtZgQ/VtCb8XM1cvWjtvsKZeYo+LjUfyf5SCySM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738900861; c=relaxed/simple;
	bh=8zi50VZyRS+S0XipTHVhmPgivV+djLPPABuu72GhnCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T8Ec4jrYRcn+MgupIq5LmrAB2m/9m+aUQY+i3OS4NAkxTVLmnYbmW7VanSsb5OliK+6UE1NguA3saHIkIFS2k+x3oO/y53Kp0BlLTf5p7OubTwdsRcHf3Pa0MNpVb4Qxpl435MZDDM0lSMpskCmPeNL4LEdZFO2kRALuuYuPhIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inka.de; spf=pass smtp.mailfrom=inka.de; arc=none smtp.client-ip=193.197.184.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inka.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inka.de
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by mail.inka.de with esmtpsa 
	id 1tgFXs-0045If-I7; Fri, 07 Feb 2025 05:00:48 +0100
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2f833af7a09so2321247a91.2
        for <linux-nilfs@vger.kernel.org>; Thu, 06 Feb 2025 20:00:48 -0800 (PST)
X-Gm-Message-State: AOJu0YzRxdBtBqcfxeiQUwA8AC9icBe9ZIfHN4oehvMUSkeVJoLgWT/n
	h8jQ5SzvpAS/lse6crtJQDOrESizKl7MJEJcP05U34etRk7P3m98XdCT7m5pAoL87geE41cU9I6
	nCOLpwtS6sk4aiaVaIOMTO8c/pqv8pjVMnF0a
X-Google-Smtp-Source: AGHT+IGpSGy02mT+2iMpXkElq5VDc8rQEVASp2x2Y19rOeG98Uk/o2OKvTBhNoXCeVnTUS0cnqiMPpVvy6wJVkNPPgw=
X-Received: by 2002:a17:90b:4d0c:b0:2f1:4715:5987 with SMTP id
 98e67ed59e1d1-2fa240642f5mr2709279a91.9.1738900846506; Thu, 06 Feb 2025
 20:00:46 -0800 (PST)
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
 <CA+m_8J0UjaOONaRwSMTCup-8xFmjkf6rHaLv0XSMOmvR3_d=PA@mail.gmail.com>
 <CAKFNMomMZB9oBppxqfAebOQNHAS1+fQRTDPORVH4PYTVnapBig@mail.gmail.com>
 <CA+m_8J22Maw3+=13QvCKvy5fQpFQ+taCZDU3m2yXHAh1+B3QcA@mail.gmail.com> <CAKFNMon2MZkOY3FA_cH2pR=g1UxuFNnb2D__cUjeR=g+TDR5fQ@mail.gmail.com>
In-Reply-To: <CAKFNMon2MZkOY3FA_cH2pR=g1UxuFNnb2D__cUjeR=g+TDR5fQ@mail.gmail.com>
From: "Felix E. Klee" <felix.klee@inka.de>
Date: Fri, 7 Feb 2025 12:00:19 +0800
X-Gmail-Original-Message-ID: <CA+m_8J2evQhMURCX6wdHoF6O2k+Z55oGBHjiY=qXLhq9GwyO6g@mail.gmail.com>
X-Gm-Features: AWEUYZnK4xqx9JAqAcROtWMr9Us79MGaBzic8a4FhaqqBMGPRivaoynV0w8LntM
Message-ID: <CA+m_8J2evQhMURCX6wdHoF6O2k+Z55oGBHjiY=qXLhq9GwyO6g@mail.gmail.com>
Subject: Re: Massive overhead even after deleting checkpoints
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ryusuke Konishi, thank you again for the detailed explanations!

On Thu, Feb 6, 2025 at 3:08=E2=80=AFPM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
> Generally speaking, copy-on-write file systems such as ZFS and Btrfs
> are newer. The concept of LFS (Log-structured File System) itself was
> proposed in 1988 and implemented in UNIX in 1992. It is an old method,
> and I believe there are few surviving implementations today. In that
> sense, I used the word "legacy".

Haha, but we=E2=80=99re still using lots of old methods around today, such =
as
UNIX and UNIX-like systems.

> > High frequency snapshotting is something I am missing from other
> > file systems.
>
> That may be true, but frequent snapshots are in principle possible in
> copy-on-write filesystems (apart from the actual support), while
> retroactive snapshots (the ability to turn each checkpoint into a
> mountable snapshot at a later time) are unique to NILFS.

I should=E2=80=99ve used the term =E2=80=9Chigh-frequency checkpointing=E2=
=80=9D. As an end
user, the only difference between checkpoints and snapshots I see is
that snapshots won=E2=80=99t be deleted by GC.
