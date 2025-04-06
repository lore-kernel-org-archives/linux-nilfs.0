Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9255B55E69
	for <linux-nilfs@vger.kernel.org>; Sun,  6 Apr 2025 04:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743915434; cv=none; b=KFekEk7Jt4SW3mdOuFWVZ6oONRqQJ81aGCu0tUB0AG8e96iKqA+s/KdRs069ofTCTG5IicnwjL32t1g2NQhzkzFe37JxRKGSfqm7/fK4zyZiWsRMg0G9TEKAWC8/bN9X41R9FnO6i492MTy1ZWJHEzOKlo4xeI27+nBZJnztgF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743915434; c=relaxed/simple;
	bh=KBINTlD3NoNJXHb13A62LJlAEz+6yRormY5aeDjMmf4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p2atO9MPegW2rC3bY3xzMCVi7P09moEA/pEYcIh/IOxY8CJqPrkk0IngMVjTmwcA4LPugfUxe53AhcrqRV0kWWDA6RHmeMnZwvNaazegBRnjg+fZk0WuVxinA2vuimlo/6VTsyvM4T77pSGO2GSxGazjCp8DUGW7XOt8kCFZNx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mrvrJxXW; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mrvrJxXW"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-549946c5346so3871234e87.2
        for <linux-nilfs@vger.kernel.org>; Sat, 05 Apr 2025 21:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743915431; x=1744520231; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBINTlD3NoNJXHb13A62LJlAEz+6yRormY5aeDjMmf4=;
        b=mrvrJxXWK/ZD9dzf9ZWE2sooXWPkxS6rU+Dg1zRuP69FDQPD/RRbU9jajQFiO8WM5A
         N34Zy4Daz0J1SZuhoKNfb80M4bb3ttWOfIQFury++/zOT3fTeN7LSSmb08fHPJGzezYS
         GE6RcEip2kQxtGSllOt/C0tnLAzq+mzRwRNpPVGlvNg4Cl3L46yjALW/+A/HUdrFjW4p
         hmC3hJ1UDsLm82BC5FB471RKAJY2W4FWxtheI2DsUzcygDVlJaci94nyIyjI7cW8Abqy
         D0y71BhXwtDeQi1m4hSXSE2dvMUFNl64HhNKwvU9CHtp8YY3WVMwYT7duHEq7dH+W9RV
         gT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743915431; x=1744520231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KBINTlD3NoNJXHb13A62LJlAEz+6yRormY5aeDjMmf4=;
        b=Yyb4iXtWXLo28EYRotwRrLSb5LCL+p0PYjgkmeVKFqROITzYIy++/wChIzoRUyr8js
         /FEZPOJ+W+69mumsVrj5dwWGGeODLvEpoLSQ44Lc1UlsW4KEeh028gJPaIl/Gi+VvU6B
         g2VpYDQ7Zx2jpUBli9qU8a9KhFd1mWZ6h49eUrxDB+ZqlfGYf6mKR8rlKo8qB4NRTOf0
         mT/eRQvLs749SPw6+vocPLyHs+bdSyEqKVPgB/VHMhwVOPZMDyn95hWIxcfHo4yePB2H
         AlX6K3i0/hdN78Rbh+ol8qN2qyodvJARPiJA/Rg9RsHPEuSn8e9hAHmRP1dYAvn188A/
         6Wpw==
X-Gm-Message-State: AOJu0YwdeE+InVNyTu8tke5ze7icTHNwpFoFSk9ok46LQjeShcsplGMT
	XS7cxvcht9s3K6XqukAAJR/7W/YTtbT9mFsgja5Ot852ZZqtWfvm98LjF/Da6gdtZeMBc6iTz81
	C31FqUxfjx54ko2Md3AVLIIJLU1Pq+soW
X-Gm-Gg: ASbGncuLtiEhhBUjChF9741C2cKU3Nxd2MNHZKLENT7tcm3w8zi0iJ62WViZgZRSab5
	tOvtwMHeQFnbs5NFdLvfBWHxmrR1z9kL87MJ83TcoNNa2IRj7kp/5BKZwvpWhz/5NNDCdbwcX8j
	DoKuhLwtX+pm0Xa3TWmaz3Lv17h0kvn1S1daHJHWbuNV5sTVK9kxOVB8f3y10=
X-Google-Smtp-Source: AGHT+IElTh2E/1Qw7x3XXN/lAER/bi9wuiWVJXHy44Dz1g92wwYa6dITW17I+Vq7OluLSsLDXkzR8cUGXVSTDnBDxyE=
X-Received: by 2002:a05:6512:ad2:b0:54a:c4d2:4b83 with SMTP id
 2adb3069b0e04-54c227779d8mr2277601e87.23.1743915430370; Sat, 05 Apr 2025
 21:57:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <822efaae-2317-4002-bebe-538cbb90acbc@askholm.net>
In-Reply-To: <822efaae-2317-4002-bebe-538cbb90acbc@askholm.net>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 6 Apr 2025 13:56:53 +0900
X-Gm-Features: ATxdqUHRsfn4xxYHpfScX0wkMuagpuvfPr9JwoSbikj2RvgywcftAItpBqKNWzo
Message-ID: <CAKFNMomQojm2p36xXAuLA30u8GiNpjbH+yM6GHQ0SxMX-jV2yQ@mail.gmail.com>
Subject: Re: Question about reflink support in nilfs
To: Magnus Askholm <magnus@askholm.net>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 6, 2025 at 3:35=E2=80=AFAM Magnus Askholm wrote:
>
> Some places, I see people say, that nilfs is a copy-on-write filesystem.
> But when I try to copy a file inside nilfs, using reflinks, this happens:
>
> $ cp --reflink=3Dalways README.txt README2.txt
> cp: failed to clone 'README2.txt' from 'README.txt': Operation not suppor=
ted
>
> Normal copying works fine:
> $ cp --reflink=3Dnever README.txt README2.txt
>
> So it looks like nilfs doesn't support copy-on-write, where you can copy
> a file
> without using extra space. E.g. copying a 5 GB file won't take 5 GB of
> free space.
>
> Is this a bug or just a missing feature, that could be implemented in
> the future?

Thank you for your interest.

In conclusion, this is not a bug, and nilfs does not currently support refl=
ink.

Reflink is a feature that allows file block areas to be shared on a
block device, enabling copy-on-write on a per-file basis. It is a new
form of copy-on-write implemented by slightly extending the file
system interface.

Nilfs is a copy-on-write file system, but its mechanism is based on a
legacy method called a log-structured file system, which does not
overwrite any existing blocks in the file system but appends them in
the underlying block device, leaving a history of files and
namespaces. (With nilfs, you can mount past snapshots of a file system
as read-only mounts by specifying checkpoint numbers listed by the
lscp command of nilfs-utils.)

I think reflink is an excellent and useful feature, but nilfs' current
design (format and on-memory structure) does not allow sharing of part
of a file's block area between multiple files (inodes) that exist
simultaneously, so we have not added the feature and there are no
plans to implement it in the near future.

The current design of nilfs' block management has various design
flaws, such as inability to implement such shared structures, the
inability to support the extent method for efficiently managing large
files, and the degradation of I/O performance due to an increase in
the number of indirect references. I would like to improve these flaws
by replacing the design.
However, this requires a certain amount of development effort, which
is difficult at the moment when we need to focus on maintenance, so
I'm sorry, but please understand that it is difficult to support it in
the near future due to design bottlenecks.

Thanks,
Ryusuke Konishi
