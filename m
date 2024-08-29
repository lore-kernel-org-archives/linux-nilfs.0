Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E521B29B8;
	Thu, 29 Aug 2024 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724950043; cv=none; b=iy5qa01cVm9yLsDolRSPkRaclomeprawzUgJfafJUVaVL+eQHDGCJm0OlGzxkm7sdnLMvumBTQoba/2Sz0VJD27eUwmK4X+MLgEKY5wt4VRJwB3KbbnUfE9wLZKbmoh1++64PGFRqG5BuzGKrWtJe09BCfxd98902q4SXu8WZuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724950043; c=relaxed/simple;
	bh=4YaAZj0aI3sfyHjFEbYSrOsCmiOYvMHEKnuTD9oNT4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hE/gD/maOaEYwESqvVfW7GDDc8HOEohq/EQT9qvjKJxZc8OyL2VaU7llUw3TsAljqzoGf0aBEf8zQ7l0CtRkMsTuwoROJXNQH5kZPuAQYA1sCvdILRH5CL4xBteC/KK3s9vVWwZEzMPOabRJmfLFUAC7/Ct6/pZV6+Ph9oissc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j0AzJAPj; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j0AzJAPj"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-533488ffaebso1024347e87.0;
        Thu, 29 Aug 2024 09:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724950037; x=1725554837; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fafiv4aWzoBJ8Jl4zsxzIAg9PdZ55+QC1PcI7sssSDE=;
        b=j0AzJAPjAbnlJuLTvw2vcCtqvid8RXqsPNack+PfcHWTQL2LCTeeSrLl45v2NW+sxX
         lLMDUDhpsMaaWqdscCwkVhvGPRfLBWvA/FAUQ40A3C6qliUCm1/9AvuinQ5t8+5B19Hw
         pi+nlZOb4pVwtP+Z/2yh1gOvdkUOYeutEHAbD9OQCkQ8Mi5COSH85TdR2iHAkBb5FhBI
         +hX5PWWoz1wfBeucQ8ccnxl+/9B+CvA8c3Jy6Nr6HxG+0yIA3X5LFFd9h5r8mLC8GtXX
         pwF+fTVdCiVIv8Ekj0V4ekN6eTqktl3F98IivRsKNfz7SE6VVStR1hMjL8IsnAm5dwKV
         JzGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724950037; x=1725554837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fafiv4aWzoBJ8Jl4zsxzIAg9PdZ55+QC1PcI7sssSDE=;
        b=f5/y80z91iNv5Iw3YEOQ6feYV04TjrCWm8EPHdyba5N3EmhkQObA2nhwM4VJ8CQXCJ
         9Acljvwyynw5LGqogMeFC8DT8focApEpDBZ3FwaDrWVaqIk736u3pgTq7EHUqkzDZ0tl
         WN157yutpj4NvjZHWnqZPdVBER0GePxmchrdRjZXzZImVFEoQVao6+tie50ZgSDSuBBA
         4wW0jGhHKbYNIX6HAZVtBiSJZhrT5zgVPrumQdFw8uVGpfjZp3FZMeoI8Bo4XF+opZLz
         DhvqwgjeAty9P2/LA6bzgZ2rPEts1Ak5X9/H+AhPMreBendvaiPiQFK5YcMkN37D9/F1
         w5ew==
X-Forwarded-Encrypted: i=1; AJvYcCW96jwfqoEkvq0i9/UG5UMWbZvI2Ud4aZN5hTlDyeW4ZK3bgCjTMVArDiTIppiA4E+dspAedihTjU4aCHk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUjU6XImFUorUCpDCfNmCC59Op9m19ys8cS04xlKAW0xaF1otX
	8iGsPsy/sCY4kaCxFQ4Ly7jz5fY2Rbd9355M/B3dhZKIENZbqtYORf0BnPFDU34Sy2iyjNXUfZR
	EO1Xsr29aqs9l54yMIQeEQ+uBqhI=
X-Google-Smtp-Source: AGHT+IFU4QRZnjrVNo79BoXWHbX92zIpxai/FBq0igJeyZSDlNxCwctQUbBUrC/FWFDyk8YC5e4x4C9B9kgVCo5EZc0=
X-Received: by 2002:a05:6512:3e0d:b0:52e:faf0:40c with SMTP id
 2adb3069b0e04-5353e54365cmr2303984e87.3.1724950036535; Thu, 29 Aug 2024
 09:47:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829071600.30706-1-kunwu.chan@linux.dev>
In-Reply-To: <20240829071600.30706-1-kunwu.chan@linux.dev>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 30 Aug 2024 01:47:00 +0900
Message-ID: <CAKFNMo=1xjz8ZPXHMeWk6dFcya+c3wrCD2=svh9XoeHxz01BZg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: Remove duplicate 'unlikely()' usage
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kunwu Chan <chentao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024 at 4:16=E2=80=AFPM Kunwu Chan wrote:
>
> From: Kunwu Chan <chentao@kylinos.cn>
>
> nested unlikely() calls, IS_ERR already uses unlikely() internally
>
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
> ---
>  fs/nilfs2/page.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 7797903e014e..9c0b7cddeaae 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -262,7 +262,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap=
,
>                         NILFS_FOLIO_BUG(folio, "inconsistent dirty state"=
);
>
>                 dfolio =3D filemap_grab_folio(dmap, folio->index);
> -               if (unlikely(IS_ERR(dfolio))) {
> +               if (IS_ERR(dfolio)) {
>                         /* No empty page is added to the page cache */
>                         folio_unlock(folio);
>                         err =3D PTR_ERR(dfolio);
> --
> 2.41.0
>

Thank you.  I'll pick it up.

Ryusuke Konishi
