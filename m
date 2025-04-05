Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C1282D98;
	Sat,  5 Apr 2025 14:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743862440; cv=none; b=fawtEAGUIWbgBZyva4BECh1ASMTZd11oIXrlxHSCU7XzKD7iKj8d2M1FJ0FkZNsQj0VxaGphdAI4zYsc5UXzDOs36uINA5dg6jfs8prllCgkJytgrwgRW/Tj8oV6ljl4BCDV7dOnGiFVcCNbtTQUFkKEzubcEvJF2PM2f3SbBxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743862440; c=relaxed/simple;
	bh=P4J9KS6HKX854uNiABwvLAKikcCrRXqFEIVa83Zf9WI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EDXB2wUiCUHgpX+/k+iKcX1qMh6wnQ5Z7sOLA0ak8cUwsBtESKJJZ8rMcJhQtdj5kSfKI5swHOXfRMsopSG2kfZv9+q+CyrL+u+ehHEqU8TR1hKe75VUe7JLJgca3HXMG/3GG7EqbqWyB2+Rcft4Fznnn6+rWJ2Nd3jmv2cAr70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VCEcmjBz; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VCEcmjBz"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-30db2c2c609so28534541fa.3;
        Sat, 05 Apr 2025 07:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743862436; x=1744467236; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZgFOhif6AUBxl+oaVaiAPhmHvSBVyu1yIQjR+GE1eQ=;
        b=VCEcmjBzEBdzyx3zZbb6iOUlP1vSYw/cPNXXGXefiaynlrwj0Z/Owo8Ut7PAoEd9jW
         ZxLXtqZpVsxipRt8Qy4DjC46S0jAN9hiFcDT8TT34DrW1vuo2ERrgQhFO7tHaPrXVmBO
         d8JGOHx4fqEuU/BqFylaMIokUqksTEOuvTN1/6uimubiK4bRZCCdMNBgWjIlf8Db4+hO
         c/fATwOei0YCjjqnVClpfPP7yGj9dv+FY6lKMM2PHtmgV18u3I6RqtpdOIJTB98Kw5zT
         nJVgjQOzzqOI1olV1RphoRhMfmxOJGbrsFbS/PPFn8X6hELXko55t7MJjVJMC8ZBr4zt
         KN4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743862436; x=1744467236;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AZgFOhif6AUBxl+oaVaiAPhmHvSBVyu1yIQjR+GE1eQ=;
        b=KpLIL3PWSf4dTTpRJZIKC1jdteWLOVrAf7XeS+RotYB+qOgWRK1TOirEARbHRvKIwa
         6OZ7D6knuavkccJYO4NE19aBG0MNS4w+FaVc/P2KRh1BgXDtRZ8vORqWC8tnvEyNB5ft
         oPFJxrW5lYqIf8P9zw9isFtYuGdTWrUrjaA7IrjNC8ZpvsdIfvD4h6ctTDsU+/Wckarb
         mmqGYm8bjc7xIem0CWvsLLwjPr2gw80Xp3OhwbcoV2g49o5DbjyHj23fl19G0vu34Cma
         ch3wwZa+9HK7YJGhiPmVJKp59NlhyFPCgtagNtvNqpHkGqWvb2xWTtd7FuQVaeXscmAI
         IJog==
X-Forwarded-Encrypted: i=1; AJvYcCWsf4hfpfd1a58d0yp6R8BeF1y9UQ1aR/CwdLSpYdyYPQKii71FxeK66/cyujhrz0Kk4TVErkYfVQyaPus=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC+mjstmvhCy7ZGzvgoeYE5nJoAAavbL8T06ELtkqM+CGsfRYk
	lhdnVGXdXikSsHCEhQUNVq67IgOpC1mYrOElYJHINHDSMluCUQMNpuiAxZox2WKKfxBlphCFCiP
	Cn+LLDwbxe3gampW3TC+wQP2bOkWnzRsG
X-Gm-Gg: ASbGncuM2lFwQ4OkFNa9a3Lk7NTqrJ0VHvFSJSqG2QpHaG2tGOCsgQMKo1SHBbVDFKk
	HFZcW9UGkmkeDjSBIot5kl7Hrzr1kaTQTdOw2O8+Fkv8WlEn8OlrAperkdEPl1v2FZirM3XoDd8
	jv4ALKsu025EeidedcpGMgMhrjEqxq89IjuRp6W8NXdHeaQGrrZ+PoGGid21D47IE2jaJQ1A==
X-Google-Smtp-Source: AGHT+IGISO1oEBMOP1pM1Z1rBBoXBXuhqvrd86bMxAIHDyBnh9d/puxeci2e6CwCDKEcvHLikD07am+C2lf3kKwU5pY=
X-Received: by 2002:a2e:a80c:0:b0:30b:f52d:148f with SMTP id
 38308e7fff4ca-30f0a12ef9emr19757481fa.18.1743862436318; Sat, 05 Apr 2025
 07:13:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250405095641.2009-1-vulab@iscas.ac.cn>
In-Reply-To: <20250405095641.2009-1-vulab@iscas.ac.cn>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 5 Apr 2025 23:13:39 +0900
X-Gm-Features: ATxdqUGOJhkEs4mkL5fNoc2aqdXOeEQlW-XZxZKDZQbmr-Jplo3H-P1kEDgei-E
Message-ID: <CAKFNMon67-aNMFEd1yhYGqvfabob7RxTo0aQFGUUpKxOH4YF+g@mail.gmail.com>
Subject: Re: [PATCH v2] nilfs2: Add pointer check for nilfs_direct_propagate()
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 5, 2025 at 6:57=E2=80=AFPM Wentao Liang wrote:
>
> In nilfs_direct_propagate(), the printer get from nilfs_direct_get_ptr()
> need to be checked to ensure it is not an invalid pointer.
>
> If the pointer value obtained by nilfs_direct_get_ptr() is
> NILFS_BMAP_INVALID_PTR, means that the metadata (in this case,
> i_bmap in the nilfs_inode_info struct) thatshould  point to the data
> block at the buffer head of the argument is corrupted and the data
> block is orphaned, meaning that the file system has lost consistency.
>
> Add a value check and return -EINVAL when it is an invalid pointer.
>
> Fixes: 36a580eb489f ("nilfs2: direct block mapping")
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  fs/nilfs2/direct.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
> index 893ab36824cc..2d8dc6b35b54 100644
> --- a/fs/nilfs2/direct.c
> +++ b/fs/nilfs2/direct.c
> @@ -273,6 +273,9 @@ static int nilfs_direct_propagate(struct nilfs_bmap *=
bmap,
>         dat =3D nilfs_bmap_get_dat(bmap);
>         key =3D nilfs_bmap_data_get_key(bmap, bh);
>         ptr =3D nilfs_direct_get_ptr(bmap, key);
> +       if (ptr =3D=3D NILFS_BMAP_INVALID_PTR)
> +               return -EINVAL;
> +
>         if (!buffer_nilfs_volatile(bh)) {
>                 oldreq.pr_entry_nr =3D ptr;
>                 newreq.pr_entry_nr =3D ptr;
> --
> 2.42.0.windows.2
>

Thanks for your help!

I'll handle this patch.

Ryusuke Konishi
