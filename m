Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572872620DE
	for <linux-nilfs@vger.kernel.org>; Tue,  4 Nov 2025 15:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762270157; cv=none; b=cChyipMHbBzLE9YwXVrJ/W6uwyU776tNpvYiC2KNT5CbNZSRg6ZWsn3t2jHX2D6J7kk22KVL1am7/hgblu5+eGt7LYAp85bU/GQylmXp0J9fYA2o17WKyZBRpSKUZ3Xvp/FOk+xgYQmBKc1K8VCYxFfxmE1dwyD217nFbq837UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762270157; c=relaxed/simple;
	bh=lvUlzmQDICbuFXm7g5Q+44V+LEKq4GaNIyG0JSW/DNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cIS7AiBpBdVZqSQlxSCauBjZqr55PTaf/w6XGTjg9mEnbkiSinyaZPZ8Dysxn+pQj4g73TOIn0LP6okbs7N4PryfRR2M/bNIH4GOa1datXlMzv6OFQzk4nxZAPbUAWZUbTHq7aVLoSf5qF1MjXjQbAyUZ19HabPT81QKXgGuOqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H92jp/Wx; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H92jp/Wx"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5930f751531so5436919e87.3
        for <linux-nilfs@vger.kernel.org>; Tue, 04 Nov 2025 07:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762270153; x=1762874953; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lvUlzmQDICbuFXm7g5Q+44V+LEKq4GaNIyG0JSW/DNU=;
        b=H92jp/WxCO0kRkXCPaEx/O5x9ulbrraqLy7JxvaOJBAPAQE9uK6MLXbQ8wDpAU/kN6
         nYPIiM0p1axmBrU2Gw0HTTdRq9dMOZf/sh/G+yaRECUnuqv9CcKuPVTfQxaKm4GnYvbH
         hyUUpU6vKatlYz4AmNMvfeHFA3JQoExUbn+U5FJsQW6+bx7dAQUYZSozK0ek69StXwZh
         zfBQtvQbKEZayMye0nw08jcqyuUxAcgxZavutY2q7A8wbz4FRN1gJefEfm7q1J9eSjam
         ZkvyHgS/dm+K4x04eeRrzbyCLGeXMaya99V/sc6V80fMAY1XxfKvXhbbuuTqHB9W4B+h
         7eFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762270153; x=1762874953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lvUlzmQDICbuFXm7g5Q+44V+LEKq4GaNIyG0JSW/DNU=;
        b=HrWo2DexG5rJENzhiHQGSDbHsmyQIeySF9+2EKnwdhmlgCQsrhVNdBF+hgmjqYjU5A
         +5jjWFmLjpaWlCUJA3/n9LxdPlBMl7pN1RNqs7oMO3DBJTb9AfK7VP3HK9iO2PGFqucS
         oHrQlNr28TvRR4d0TNM3VyQtz69KmXo5lIQ0sYwe80XJgrEMFIX0iauiTKMgGZYo2gPF
         G6hGvK+o0BlXmwaABuhD25kIFzvjVpjcR8HGs/3z36xFPsqNqDrDsZEiM0pBo25TPg9A
         C4h/HHIHgI+n2s/HTgRHRbCyYln4SV5GINql4gE8mpV5QylvRPtvBpHEakfOziYo+F+T
         4i9w==
X-Gm-Message-State: AOJu0YyXSXMgtHti/8Cqzk6ApnmXpMxCDRURGFxcWko2kiuA/1tiKw1d
	Do55F1TwcEGG5rnFXhFnLGRuWMi1roKQCqWJtf7seqKgqNJnXc2wENHDZj6XjGin4mIyrw35gU4
	8nmkqHMGTFKcEpTYPMNbbxxN9S1hjOX0mw0AL
X-Gm-Gg: ASbGncvym5rNePDqSJJi9o2SeqcT3+aVQVoo8dVzgnCUnObbr373gbYM/FGWVUNey/p
	NVq9ntkcb2O5Td96dQRcO4lLtCS35A4H94KIP40JOT4CCgKczqCQ+xNdVUWGvZr6zxMhkqiFPyF
	mGH/58DJyfc/6LFfyRAEgl7trQWWjyd/keGT46KJYzy9oSZyoMEyZrtL6lfpX/S85bXSnRCpJCG
	PTAja4rjd0tLODoa55GZ+OOeWPLFnVfK+cdih60h8X55diwGUq+FhiwUMnq4g==
X-Google-Smtp-Source: AGHT+IFXdmHUKJRXO85DvPhGWuqKgteJX2coKaiMmeOuCOK0mfQVSskPHt6hgxaTNkCAdtTkkvYRqJvMokOTAX9bmqU=
X-Received: by 2002:a05:6512:b27:b0:594:35b6:2639 with SMTP id
 2adb3069b0e04-59435b62763mr1096588e87.6.1762270153020; Tue, 04 Nov 2025
 07:29:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aPJNYX4UtFfUo8DX@merari.gmerlin.de> <CAKFNMonRtuknO7G6p-eOuY+WgSQQGsYOWrDdbO2Zh1mBsGp3RA@mail.gmail.com>
 <aQoHEXBY9tusAkQ9@merari.gmerlin.de>
In-Reply-To: <aQoHEXBY9tusAkQ9@merari.gmerlin.de>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 5 Nov 2025 00:28:54 +0900
X-Gm-Features: AWmQ_bl7Bz2dvPUnMFvW5wtImF_p7tRlwUSu-SZODhakqXsPWg86GghZvCGIrz8
Message-ID: <CAKFNMonYLKSikthtoGP9z6Loetu0LxrUsGC6vMSAwaCPE6muqQ@mail.gmail.com>
Subject: Re: nilfs_readdir: bad page in #
To: Christopher Zimmermann <christopher@gmerlin.de>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 11:00=E2=80=AFPM Christopher Zimmermann wrote:
>
> On Sat, Oct 18, 2025 at 08:04:28PM +0900, Ryusuke Konishi wrote:
> >On Sat, Oct 18, 2025 at 7:01=E2=80=AFAM Christopher Zimmermann wrote:
> >>
> >> Hi,
> >>
> >> this is what I saw today:
> >>
> >> Oct 17 09:44:27 merari.gmerlin.de kernel: NILFS version 2 loaded
> >> Oct 17 09:44:27 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord =
starting. Construction interval =3D 5 seconds, CP frequency < 30 seconds
> >> Oct 17 09:44:27 merari.gmerlin.de nilfs_cleanerd[715]: start
> >> Oct 17 09:44:27 merari.gmerlin.de nilfs_cleanerd[715]: pause (clean ch=
eck)
> >> Oct 17 15:05:45 merari.gmerlin.de kernel: NILFS error (device nvme0n1p=
5): nilfs_readdir: bad page in #235406
> >> Oct 17 15:10:06 merari.gmerlin.de kernel: NILFS error (device nvme0n1p=
5): nilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
> >...
> >> Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p=
5): nilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
> >> Oct 17 15:10:49 merari.gmerlin.de nilfs_cleanerd[715]: shutdown
> >> Oct 17 15:10:52 merari.gmerlin.de kernel: NILFS (nvme0n1p5): disposed =
unprocessed dirty file(s) when detaching log writer
> >>
> >> [reboot]
> >>
> >> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS version 2 loaded
> >> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting =
unchecked fs
> >> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): recovery =
complete
> >> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord =
starting. Construction interval =3D 5 seconds, CP frequency < 30 seconds
> >> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting =
fs with errors
> >> Oct 17 15:11:09 merari.gmerlin.de nilfs_cleanerd[704]: start
> >> Oct 17 15:11:09 merari.gmerlin.de nilfs_cleanerd[704]: pause (clean ch=
eck)
> >> Oct 17 15:51:11 merari.gmerlin.de kernel: NILFS error (device nvme0n1p=
5): nilfs_readdir: bad page in #488967
> >> Oct 17 15:53:04 merari.gmerlin.de kernel: NILFS error (device nvme0n1p=
5): nilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
> >...
> >> Oct 17 15:53:04 merari.gmerlin.de kernel: NILFS error (device nvme0n1p=
5): nilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
> >> Oct 17 15:53:19 merari.gmerlin.de kernel: NILFS error (device nvme0n1p=
5): nilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
> >> Oct 17 15:53:20 merari.gmerlin.de nilfs_cleanerd[704]: shutdown
> >> Oct 17 15:53:20 merari.gmerlin.de kernel: NILFS (nvme0n1p5): disposed =
unprocessed dirty file(s) when detaching log writer
> >>
> >> [reboot]
> >>
> >> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS version 2 loaded
> >> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting =
unchecked fs
> >> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): recovery =
complete
> >> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord =
starting. Construction interval =3D 5 seconds, CP frequency < 30 seconds
> >> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting =
fs with errors
> >> Oct 17 15:53:39 merari.gmerlin.de nilfs_cleanerd[717]: start
> >> Oct 17 15:53:39 merari.gmerlin.de nilfs_cleanerd[717]: pause (clean
> >> check)
> >>
> >> Both, inode 257 and inode 258 were ~/.xsession-errors.old
> >>
> >> What to think of "mounting fs with errors"?
> >> Especially since there is no fsck?
> >
> >For reference, I would like to ask under what circumstances did this
> >occur?
>
> It occured running debian trixie kernel 6.12.48+deb13-amd64
>
> /home was on a nilfs2 filesystem:
> /dev/nvme0n1p5 on /home type nilfs2 (rw,noatime,nodiratime,discard)
>
> >If this happens easily, I am concerned that there may be a new regressio=
n.
>
> Now I had some weeks without the issue re-occuring. Now it happened
> again (after formatting the fs and restoring from backup a few weeks
> ago) :-(
>
> Nov 04 14:31:01 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_readdir: bad page in #170719
> Nov 04 14:34:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_bmap_lookup_contig: broken bmap (inode number=3D259)
> Nov 04 14:34:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_bmap_lookup_contig: broken bmap (inode number=3D259)
> Nov 04 14:34:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_bmap_lookup_contig: broken bmap (inode number=3D259)
> Nov 04 14:34:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_bmap_lookup_contig: broken bmap (inode number=3D259)
> Nov 04 14:34:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_bmap_lookup_contig: broken bmap (inode number=3D259)
>
> want to take a wild guess which file had inode 259 at the time of the
> error? - ~/.xsession-error again.
>
> >The error message suggests a corrupted btree, which is causing the
> >directory read to fail.
> >
> >I'm also concerned about the problem with .xsession-errors, a file
> >that seems to have a short lifespan and involves rename.
> >
> >For reference, what version of your kernel are you using?
>
> 6.12.48+deb13-amd64

HI Christopher,

I appreciate your feedback despite the frustration caused by the
repeated issues.

It's becoming more likely that what I feared is occurring.
I suspect that an issue (probably a regression) that shouldn't occur
during normal operation has occurred.

6.12 is a well-maintained kernel series, and 6.12.48 is fairly
up-to-date, except for two stable fixes that are unrelated to this
issue.

Therefore, it's likely that this issue can be reproduced even with the
latest mainline kernel.

6.12.48 has backported nearly a dozen stable patches for nilfs2,
including important bug fixes for rename, bmap/btree, and preventing
the reuse of deleted inodes. It's possible that one of these patches
is backfiring.

Based on what's happening with the .xsession-errors file, I guess that
the problem is indeed occurring with files that are renamed or have a
short lifespan.

I'll try to create an environment that reproduces these conditions.

Thanks,
Ryusuke Konishi
