Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBBC3CB561
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 23:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282677; cv=none; b=D/omwrYZ/Yyq2fMX7Qc45sGoDsA7Cz523HRCKPZIXlH1+wE5PtZHCpngRaUGn4FxxYsf92O+lU00SyZintclEJQeMANNzpCN1zRdN45t2bZp4eQ/FFP5YJI8tMWJKI2CHjvNevRt1UpVQafR+HElcm/b4H5Kkc0/DMiyCkqjh5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282677; c=relaxed/simple;
	bh=ajUzpkc2wT2rKsUtrIOzENhOhtVAYhqMQZ//RyKY3VQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F9M+gCZ4J2l1dUKX8rZ2G96Kr6ax/XYf070DPxuigpEOmMJz0RnxoZTqDxpi1a1mC0MxAe6lMd8jNVhCagJ6abqOISr+mjPhQ25LPraBYtRXY81d3s8mBK4dbzZHvG1lx5M82Vq9ZhioGxt1cjkBG7LV/Kfb1Fpo2FOal34lRV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=QthAxwfS; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="QthAxwfS"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e3efab7e0so350595a91.0
        for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 16:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1785282675; x=1785887475; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4K+cmxTWwmfNZxuEdGpcpmlb33it0JRnk5PNxofjx84=;
        b=QthAxwfSHY+YsF477A5cks3n970G5aza7jLI+FYicFpEQuLAILnIc0WqLr2GJrJYRL
         GZPzhdIAoxXZEXdjov1jF1vHjBkcf2UVXlcSkw2ZDcnW1p81KbUtslDZpymfmw10X6Ba
         JoNmDY7nE4O80SkIVL16zM2Pde33tzZEvFK6gyCyNBkXYi437MbmaK2djaaPV1Vo9DIV
         z4smrXP11K9he3Z1EL/4HQYObpYYF+FsKzH3pAu2ZXDro7QdGgbo1bik3DIP9t0m69ft
         exGWynvRzvdPnYHOlVtjjMlkMjLzUO6mGVNxuKs9nhCfgIL3+gAhf66mQlFQonW1oAHK
         l86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785282675; x=1785887475;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4K+cmxTWwmfNZxuEdGpcpmlb33it0JRnk5PNxofjx84=;
        b=EdegDTVMClchnbH8h+wmQ2KuSkbFxjG+nTqAhYMM+jDC6mBLwlzBLDmsFvailCrlSK
         zRbR3vqxnmKFC+M1rhfNmbGsJJyzzNJNE7cXrxNWdn6nCWlFHcfCLGBbcAJ6SupcgTw0
         A6eozFLtTM8twpUZdz69hlDJ51O40wcs3HPOGTtTQETyiy/F/CTQpMdRNVyRSpFx9LiG
         QHnt5BN31v/mmqvNUoSsLN9gsM18cqnhIdLYB+wCMk5SGX81ENDy2e/d9yevV9DEhzB0
         OlGD5mXO7ysVp0gkQyJ9ypAIlFEnSwk7hpHavIFQKuvknsewsRpQvNx3VoqyNZ7FrQ/Y
         OVUA==
X-Gm-Message-State: AOJu0YxNL6DoH3HDfdjosVDWr25hMsztrMomOQTCOH03rspnsBCi31FO
	5ZchGzYTJoQBMb7Qitb/2voVv95FQPjJhek1y2z0YnhAoq0lER3FPsznBKlE5S0hEjo=
X-Gm-Gg: AR+sD11Zpgio6hdP3tqJhhRBWFbUqvHGS3UavNeIdrtDXM4jfRDDBETHk1zenkTpbNn
	W+0mtE1ulSNd7jhT6LItvGgTQGk8MZ7LOJXOka9vtELw1Hf612GRctGH+bNmmai2E/+1wJsMNRe
	dmbv6SmsTYuHHjRpBsKCZMvKqUTauiLOK7IXVHkKAN1PDWzU7rS7Pnt3f/7KNZM6w2QpwjhOMzX
	S6aQNAqFLJCotBIeDIvN86RUrugQUWXV+KTZ7RG7rRlkQUxRr3JcVOQOYAok+Wcrsq+a3XHPxMR
	aN8uxB/iFKX5zEZHyLeJz68rTow1exlo6yWtd3w8VVs/rB1wFn8emhK8FkuAUjffjDJWQYEOlhT
	7Mu/jvo4rWoNukZpzluqvQ1mR3IB/fMvr8QmMHxBX8JJWxhBJVsX5wKQ0X60Tw8XOnn+tPoApBU
	yJ6MoPoXERctbCT1RlOCLuLpuKKCxjuRQy0I1JL0I5Vq9e379I9x/jD2bE8fkFXVQtFA2ihwyF1
	P/66E39kM/3WjJaWpTmzRZHUrb+T/hFOCBixpum50wjbIbJhyQekiGgMo1EJwr2ELXHhTbPx1y4
	BwT1/VbiCg5cp248yX3bGStUSC0sNn472C83gvD7Ek1pOX1jCye9q4KIqmnFpYQrd2XBhToKHag
	RAQ==
X-Received: by 2002:a17:90b:1b07:b0:36d:b12b:f57d with SMTP id 98e67ed59e1d1-38f83673e41mr42943a91.12.1785282674599;
        Tue, 28 Jul 2026 16:51:14 -0700 (PDT)
Received: from [10.0.0.3] (162-197-212-70.lightspeed.sntcca.sbcglobal.net. [162.197.212.70])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504baa01dsm3182906eec.12.2026.07.28.16.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:51:13 -0700 (PDT)
Message-ID: <b1fcb1381e88045b503c60890c99663c8cdc83ba.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: prevent out-of-bounds read in super root block
 parsing
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, David Lee <david.lee@trailofbits.com>
Date: Tue, 28 Jul 2026 16:51:12 -0700
In-Reply-To: <20260717165654.151990-1-konishi.ryusuke@gmail.com>
References: <20260717165654.151990-1-konishi.ryusuke@gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-07-18 at 01:56 +0900, Ryusuke Konishi wrote:
> From: David Lee <david.lee@trailofbits.com>
>=20
> super-root inode metadata size is trusted before
> nilfs_read_inode_common().
>=20
> Reject super-root inode sizes whose computed on-disk footprint
> exceeds the
> filesystem block size. This prevents malformed filesystem images from
> making nilfs_read_inode_common() read past the end of the super-root
> block.
>=20
> [ryusuke: clarify the commit title]
>=20
> Fixes: 8a9d2191e9f4 ("nilfs2: operations for the_nilfs core object")
> Signed-off-by: David Lee <david.lee@trailofbits.com>
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> please apply this for the next cycle.
>=20
> As described, this prevents out-of-bounds memory access that could
> occur with a tampered file system image.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/the_nilfs.c | 6 ++++++
> =C2=A01 file changed, 6 insertions(+)
>=20
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 7b23e373a106..f3805e7aabeb 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -461,6 +461,12 @@ static int nilfs_store_disk_layout(struct
> the_nilfs *nilfs,
> =C2=A0			=C2=A0 nilfs->ns_inode_size);
> =C2=A0		return -EINVAL;
> =C2=A0	}
> +	if (NILFS_SR_BYTES(nilfs->ns_inode_size) > nilfs-
> >ns_blocksize) {
> +		nilfs_err(nilfs->ns_sb,
> +			=C2=A0 "too large inode size for super root: %d
> bytes",
> +			=C2=A0 nilfs->ns_inode_size);
> +		return -EINVAL;
> +	}
> =C2=A0
> =C2=A0	nilfs->ns_first_ino =3D le32_to_cpu(sbp->s_first_ino);
> =C2=A0	if (nilfs->ns_first_ino < NILFS_USER_INO) {

Applied.

Thanks,
Slava.
