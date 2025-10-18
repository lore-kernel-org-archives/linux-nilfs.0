Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11831C5D55
	for <linux-nilfs@vger.kernel.org>; Sat, 18 Oct 2025 11:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760785489; cv=none; b=tu1X8SusZLXyzEhlCsmJBfYSXLwFq9p9VUYDv2sZ6YQ2QLVGKDMcROpY1IBPtbm/bevPOuEQ/+eGlWlkc7kIISKtrzOM6Sqpy9lzlCTLoXYSRVeJ8CS+ONmnwkjkmquKVMgzHzEq3pY1W5E8LzQ113dEsRkU7EaZodvJR8T/BY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760785489; c=relaxed/simple;
	bh=m2ZP6SqcE+GcGJL6Kd8kiljOvnwYOw2hbodsY7Caj/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IwW7C0cjNMhHJWjtgccLe2moIq0XtPHFsC48bqynYLxYuHuFZvSydoa6LUvHhojBFaMlmFofUaj+yzq8CSLSRT4UF25CDYY1dZPndunIpBHb8kDlY49L2Lio+eHocbZnKQLMC5ekTF0NOnV9K41abbV68T+sLg2lAzixvLSM87c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QvUbjfwM; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QvUbjfwM"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-36527ac0750so27257191fa.3
        for <linux-nilfs@vger.kernel.org>; Sat, 18 Oct 2025 04:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760785485; x=1761390285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2ZP6SqcE+GcGJL6Kd8kiljOvnwYOw2hbodsY7Caj/4=;
        b=QvUbjfwMV/JqMdQK/MpgekxiqwDBGnY3Hpc2AQQp7YSO9r3eQM9NiJZus3qp7kL96w
         mb0h1p77h9EfVGPhUmDnaje6U/Lt2VJ+w/NT9KMtakJRlDZzywYEYzZRI3q4I8OWCci2
         sURHx9KXxX2d4YpJA9xsAyLL9Xm26235/PKy9A785fmLJfMbBP0mQchs5SAeWb3herCl
         OTvEKhVm18beMORKGfdnInQRHVJ/aRLrPQ3Q23YtAuhmJvoJjK7/hbfzF7BBSbzIKzFl
         I97W7FrRwnFaOZFZkCYb3TEq3jNLoE9FiZqztnUy9xu0hfzuaTcDeweOX2j+uznJNQ20
         coMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760785485; x=1761390285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m2ZP6SqcE+GcGJL6Kd8kiljOvnwYOw2hbodsY7Caj/4=;
        b=p6he+mWQyivy4rd+yyxbbupdBiLvVO4s9IKE5ZzbVjXHMHVF/oa2m3pGoVa5/MsVow
         fQWkYTOhMXctCpmB/2uv1JKrzzPxm1oaZ4+rDSCTlFUvWiPBY+KjlsBpQbZcOsgfAqNh
         p2QQHWl13vI4tQleuGLsFZmUgiDn5U++qJecr/N+i5WeMVvvb4UnqdvfZenLKpEPwNIl
         SzKAkuVs2Pp5Z/ZdNubLxphmJg9SiEskUobQ6RvKCFjicKEr1SM4oLr1xi3qy5rZu4yo
         qv/WyrjiqmAIYpeBIqXAim0os6M1BT32UqGyWPyjwA4F7h+pQBU5v8cvelx+Rn4TgoUQ
         J6HA==
X-Gm-Message-State: AOJu0YyXwrNaHFpdzkEfJNzjhmOeSRlFbRL5S+tkQv+B0rPtZYzEX3Ne
	L3fFgJGqvLI81Pir59I7j5UeYJ51V3YCTGoMX0uRmd9wJA6k8AbN07W2tD8v/igU6GDUQLW6sCr
	SpCqDObz/r28nDTIzGHrY5m0NuIdu83o7Q7Ly
X-Gm-Gg: ASbGnct8K9r7Owjw71SI/IgsH5os8kTuUUdTwwdjRaa7YkMO9pOHPwBoztCiouLapih
	/5rybG/0oXtjdfwTSTDAb4lGwkAxIDiA+WIc9dtyT0G1jFUWYSg9lQwo9BiWsuKezceMjgQiVY4
	TBXmtiS3CBtXqCT6JFUofWLU5DE/YFLvvHSBz1QFuqdVyPJY8v24UotW7s85cdMReQM+V2vtIUQ
	78MKJ+e6YwYr0R3ADWROfSAZdeD/o2B+ioLpvIvShSMPVqT2ghqddb/PycYn62sab2oZHuo3NBt
	kF1n342Y+1t8Yyq4g6Tw29Y7owC5
X-Google-Smtp-Source: AGHT+IGNnraG7yuY5y20iRC5dECqim9O3niJA/8PVjjwVSibM9BSyfmcTWpiwgFtut2PxdUuwf/WvDRAZhokXqgfLuY=
X-Received: by 2002:a2e:9a13:0:b0:372:414d:3cf0 with SMTP id
 38308e7fff4ca-37797a79d00mr23615781fa.39.1760785484488; Sat, 18 Oct 2025
 04:04:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aPJNYX4UtFfUo8DX@merari.gmerlin.de>
In-Reply-To: <aPJNYX4UtFfUo8DX@merari.gmerlin.de>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 18 Oct 2025 20:04:28 +0900
X-Gm-Features: AS18NWAOxZ-utJGmOhfUPNj9sBbtnSctPcalaMsKTDmuDXzj6CgyAysu88zwC4E
Message-ID: <CAKFNMonRtuknO7G6p-eOuY+WgSQQGsYOWrDdbO2Zh1mBsGp3RA@mail.gmail.com>
Subject: Re: nilfs_readdir: bad page in #
To: Christopher Zimmermann <christopher@gmerlin.de>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 18, 2025 at 7:01=E2=80=AFAM Christopher Zimmermann wrote:
>
> Hi,
>
> this is what I saw today:
>
> Oct 17 09:44:27 merari.gmerlin.de kernel: NILFS version 2 loaded
> Oct 17 09:44:27 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord sta=
rting. Construction interval =3D 5 seconds, CP frequency < 30 seconds
> Oct 17 09:44:27 merari.gmerlin.de nilfs_cleanerd[715]: start
> Oct 17 09:44:27 merari.gmerlin.de nilfs_cleanerd[715]: pause (clean check=
)
> Oct 17 15:05:45 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_readdir: bad page in #235406
> Oct 17 15:10:06 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
...
> Oct 17 15:10:48 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_bmap_lookup_contig: broken bmap (inode number=3D257)
> Oct 17 15:10:49 merari.gmerlin.de nilfs_cleanerd[715]: shutdown
> Oct 17 15:10:52 merari.gmerlin.de kernel: NILFS (nvme0n1p5): disposed unp=
rocessed dirty file(s) when detaching log writer
>
> [reboot]
>
> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS version 2 loaded
> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting unc=
hecked fs
> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): recovery com=
plete
> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord sta=
rting. Construction interval =3D 5 seconds, CP frequency < 30 seconds
> Oct 17 15:11:09 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting fs =
with errors
> Oct 17 15:11:09 merari.gmerlin.de nilfs_cleanerd[704]: start
> Oct 17 15:11:09 merari.gmerlin.de nilfs_cleanerd[704]: pause (clean check=
)
> Oct 17 15:51:11 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_readdir: bad page in #488967
> Oct 17 15:53:04 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
...
> Oct 17 15:53:04 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
> Oct 17 15:53:19 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5):=
 nilfs_bmap_lookup_contig: broken bmap (inode number=3D258)
> Oct 17 15:53:20 merari.gmerlin.de nilfs_cleanerd[704]: shutdown
> Oct 17 15:53:20 merari.gmerlin.de kernel: NILFS (nvme0n1p5): disposed unp=
rocessed dirty file(s) when detaching log writer
>
> [reboot]
>
> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS version 2 loaded
> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting unc=
hecked fs
> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): recovery com=
plete
> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): segctord sta=
rting. Construction interval =3D 5 seconds, CP frequency < 30 seconds
> Oct 17 15:53:39 merari.gmerlin.de kernel: NILFS (nvme0n1p5): mounting fs =
with errors
> Oct 17 15:53:39 merari.gmerlin.de nilfs_cleanerd[717]: start
> Oct 17 15:53:39 merari.gmerlin.de nilfs_cleanerd[717]: pause (clean
> check)
>
> Both, inode 257 and inode 258 were ~/.xsession-errors.old
>
> What to think of "mounting fs with errors"?
> Especially since there is no fsck?

Yes, this is a flag that should be repaired by fsck, but because fsck
is not available, it is in an unrecoverable state.
This is a flaw in this project and there is no excuse for it.

For reference, I would like to ask under what circumstances did this occur?

If this happens easily, I am concerned that there may be a new regression.

The error message suggests a corrupted btree, which is causing the
directory read to fail.

I'm also concerned about the problem with .xsession-errors, a file
that seems to have a short lifespan and involves rename.

For reference, what version of your kernel are you using?


Regards,
Ryusuke Konishi
