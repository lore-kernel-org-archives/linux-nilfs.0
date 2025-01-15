Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D043BB54;
	Wed, 15 Jan 2025 19:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736968023; cv=none; b=EBAZTUzwljEVWspNGCByJvyLcEaxwyPMQUukIvHYx2CAGSyvJhsO+uB0pXD5hG+/2zqtQVfZbWmkp5vpmY/I+AmYgSXFHxXUjFkvqS8ZTR3Eh2QpfAQ09h+GEoi67Z4lrKkLcK59ZgdeRoDQ/bpVk+Kd90HZjnXncRGCitJD+MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736968023; c=relaxed/simple;
	bh=T/RAYlNG+kVoVBnG0CIhRhBIztDBVdlAn1tLLv4GnDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XROuHY/BViA3qldP0u5HQpZ8c0aTIUJQSAahIXwItaiQDt6CmgfoGUgFkm04QU02vEfo89j7sRdiSOithMVABxIdLbK1FKyw5InSriun7ev5Q98/c5O1mO6jJmakQULO2I6fijvDmXxvlqYURCojV+pf5QSXiEV+UBFXo4/PYPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PN6L/nG5; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PN6L/nG5"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-53e3a37ae07so147146e87.3;
        Wed, 15 Jan 2025 11:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736968020; x=1737572820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XNGMS5Jwaq95wuwxv0iO0lHXRaiK02GZjl+3Hx0gQps=;
        b=PN6L/nG5MEy8N6Fdsvtqxtqift4KrqGsDOW7DVVyN7wmpAhk/qYOBOnDNzmjtLW8uP
         Rhsc/MQwbjJikO4Dl6OrtEip0hXz853t5ubSdOKhnKVPmG3BvfcHQETNq7gU00jVnQfw
         DtTqEyKW6AScnwzRRKnOLhSEhIfWpk64YQU5Tu2/XrzF99eeZK5aOkMQS3kQWwg1zUB+
         41APJHRpoph2ByJ4I+e2Jh38Z4aK8Osp9/zMzR4vvinBmRwC5Z1KQB5EIuCbOlPa/s6F
         IRDtqnfoa+NICx6ciakuUMeA+Jx9HdkGnWQ5qrX1uLPYa0jz+db6WoC/gH65c3qNVtP1
         ypXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736968020; x=1737572820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XNGMS5Jwaq95wuwxv0iO0lHXRaiK02GZjl+3Hx0gQps=;
        b=kNMvLMD/6Xhp/8CwsSLq8a7FgSgiru77PVepEHoKOk5x/CvsttO61pemIolNNPuNJE
         t2POjgnJ/QF/vuT6ejKh73Cg4oO+OMa+LPaogiHEat4RBMbiavFsemtYHhLW1sHoXX0E
         rUvF5cHzI0DNcEcriYB8Pe/fjRvggECaMvEZVoCqdHA4gw6pPh83j4PEzccR7TDYfORS
         /LkU4WMxHDhMB/sU+e9XQaDFEVrynnIbF1F4sCkSkYKWf0mqmYAf7ohgZ+W+QpvxmNXI
         OPkqYyrQpAD5GoCf+fnKsFsPDBoDSxXXQOlTKc9E8kRXxihTtKUftxJvzenU0DSuyqeD
         RriQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEjBDV97TqOx6QiLvypa/jmfLoJfrRaQCeIR81yRkcIb3ryklCBe/8TOxTLU4eF2HcoR9J0TNWtHjWd4s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFqIUK5f+VciFmcyy7KRhLHGMzVOxgr2Dz3bGpEr5/BkZVEMBY
	lP3A1r9hKJmsMN1vgqMz+yCjDjiVkp1dt1GE69V9Q7MvKwYwMMNpVfyZLQ7uEM2jYRg4M8TQiFj
	AVizsF2AeATFTmsR9Xmy1/90BPRwALI8r
X-Gm-Gg: ASbGnctZqBBHsbyt0VjSQPSfuDhQZfbynfQEQePCfRvww624NXpzh7ZNMzYVJr6gWJ/
	KCe4aI1RtjEDmMAa4Ztngk4wXVk+SUL0k9ke+0fUkfHI1yUJrxscYJzD3G1GUinXllDTbtVde
X-Google-Smtp-Source: AGHT+IFcPAaXquUURo+ZfRKeuBsrFg0cwPU9XZym9N+NCk32IsS4+kfh1SPWCzrppapzsfQoFo/zanUYoOCmi1romvQ=
X-Received: by 2002:a05:6512:159b:b0:541:3587:9d45 with SMTP id
 2adb3069b0e04-542845b1b7dmr8425735e87.4.1736968019646; Wed, 15 Jan 2025
 11:06:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250115170818.20177-1-n.zhandarovich@fintech.ru>
In-Reply-To: <20250115170818.20177-1-n.zhandarovich@fintech.ru>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 16 Jan 2025 04:06:43 +0900
X-Gm-Features: AbW1kvZShJZnKGtA9yOqqI0r15_A5Gkv9gHh2EuSjnFMtUMI9FL5tx9CNSQB-Io
Message-ID: <CAKFNMonqeRS_S=k9T9cR7dq3cd9XeBjGJSfuDAp9u15FT+VVGg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix possible int overflows in nilfs_fiemap()
To: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 2:08=E2=80=AFAM Nikita Zhandarovich wrote:
>
> Since nilfs_bmap_lookup_contig() in nilfs_fiemap() calculates its
> result by being prepared to go through potentially
> maxblocks =3D=3D INT_MAX blocks, the value in n may experience an
> overflow caused by left shift of blkbits.
>
> While it is extremely unlikely to occur, play it safe and cast right
> hand expression to wider type to mitigate the issue.
>
> Found by Linux Verification Center (linuxtesting.org) with static
> analysis tool SVACE.
>
> Fixes: 622daaff0a89 ("nilfs2: fiemap support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
> ---
>  fs/nilfs2/inode.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 23f3a75edd50..81abb58dcbd8 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -1188,7 +1188,7 @@ int nilfs_fiemap(struct inode *inode, struct fiemap=
_extent_info *fieinfo,
>                         if (size) {
>                                 if (phys && blkphy << blkbits =3D=3D phys=
 + size) {
>                                         /* The current extent goes on */
> -                                       size +=3D n << blkbits;
> +                                       size +=3D (u64)n << blkbits;
>                                 } else {
>                                         /* Terminate the current extent *=
/
>                                         ret =3D fiemap_fill_next_extent(
> @@ -1201,14 +1201,14 @@ int nilfs_fiemap(struct inode *inode, struct fiem=
ap_extent_info *fieinfo,
>                                         flags =3D FIEMAP_EXTENT_MERGED;
>                                         logical =3D blkoff << blkbits;
>                                         phys =3D blkphy << blkbits;
> -                                       size =3D n << blkbits;
> +                                       size =3D (u64)n << blkbits;
>                                 }
>                         } else {
>                                 /* Start a new extent */
>                                 flags =3D FIEMAP_EXTENT_MERGED;
>                                 logical =3D blkoff << blkbits;
>                                 phys =3D blkphy << blkbits;
> -                               size =3D n << blkbits;
> +                               size =3D (u64)n << blkbits;
>                         }
>                         blkoff +=3D n;
>                 }

Thank you Nikita.

I'll take this patch and send it upstream.

Since nilfs2 extents (contiguous blocks) cannot cross segment
boundaries, these overflows do not occur in normal format.  However,
in an environment where the segments are tuned to be larger, these
overflows can theoretically occur, so as you pointed out, I believe
this fix is necessary.

Thanks,
Ryusuke Konishi
