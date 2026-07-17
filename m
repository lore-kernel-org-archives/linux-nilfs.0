Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CAD3FDC06
	for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 13:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784294447; cv=pass; b=E3oy0TrbW2icJnnYWY1hAJrN8uZv+DvkG3dfRaW8eEE+eZaK5vzLRpKQ0c3qPUeJTdlSrT5FJ+RWGDWC/tdeUcaLpWN6PUxMuAwW2pSrDLhbQXqYd7M8mCdi+LNZHl9T7MYiNgKynkx5zwSuHQiXm6DibO9dgMRn6QjsJoqEv5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784294447; c=relaxed/simple;
	bh=jrpOhQBY3jZYQs7PTQPUgw99Lvs4eEnLmTsy17LMIGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c2pLN1gDse+lFd9nobX27bP/14Nnpe7yz2LQnz1TdSqJjivphqMp83jFe20YJaEQrwe+q2Y4f4WimkrdgGq7/vv9OxJdr1CMIriZqDcOYT8aOVB+B23EmVOaRNrZs17kagqO5SsNmQsggiOzkLvU6MWP/j9JKdNQtBrLGVa4XKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pcxrbh4B; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pcxrbh4B"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aeb59d54b1so3801623e87.1
        for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 06:20:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784294443; cv=none;
        d=google.com; s=arc-20260327;
        b=KtNx9naigDqfrPiEewb/fQiaWx/IyGZfOyayady/F1puYHWi8YNu9/lyv5N6Jl+q+D
         OfgOGwzrM2r8K5cKetq5IBQW0xobwS7FWoIu9oFPK8G3q+9ENcz8Uiyvyylc0VNy4bP7
         fO43D2oPnNRKxlTZIET1XMBpN1lzFX9WT3ivqi9dnTL+EmSA5XqIo8XBf2cwhPl07d8u
         5i2bNoEM61HuNZcshBtbj1KotmF+2+3UaFT8w01zyEqZXmb/Xc7FRKmc8bG+SxHCYWAg
         AMWdFdvvnvsWa9yGK/JVSW9k/66Lcan6w2EVNnaBMWNy3VNUr6megd8KNNBxDmqmVV85
         eF/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4uaZ7H2Qb8XTb7fPcfk6UsEB9zSmShAVSKAzus36Zos=;
        fh=yeU2WN5hRe3sVQxrcErQu9hW4LlBjmS2kfrlvtBRlO0=;
        b=VeOE6HpG+BJO43tPuHWHcy/VuokRqNO3T1emAZamZAIILD1Do1E5vsFFJkMv34hSKe
         3X6QgI0xjh+yLlk+tISDhzzW75h8pdMiYo3WtVQDJ5kk1lzTvjvFk0k2RSRZelWNZwNp
         FUYjqM7YExaBWzki0vi6VibDeh2xXA+v8M1wYA/8zmsG3BukPiclMppabCCGtUR6hipq
         GeedmO8ORJ3UoqNXoeAA7xIERIrdi79PuiY3hPz65nIL36EJcoCMDz57d66RBRA7v1aK
         OqFVy+Rl/tARnzNAJwA5H5oKPavLP6Ri2MLV2q0BH3Dgrznzesm+/B2xHmTRZsdbBWwl
         a8CA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784294443; x=1784899243; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4uaZ7H2Qb8XTb7fPcfk6UsEB9zSmShAVSKAzus36Zos=;
        b=Pcxrbh4B/yv70l6bYgh1thnnwXJyregxdjjksDgpTTUhKA0D6umRmfr0SmYdPThERf
         bVKcnp2oqECGU/X5G1rBfYAut2fXTmzBzVoflZkDSSyJqJLX5jylT01H+Y/NOeIuvZo7
         zjcUBGZ8WjxYlIw1W5QWrQvLzHCGECcx1DX9L5LtlR5RM3FR7mNBxKNXDLhtyJXRyrn+
         0WMAN9/qlip72IIlQWflAoXbaZDI5Blcr8T53BdvtJt7I6VcjZu3GVrWlOGOYGPVcC2/
         JcnFqBAnTiaWpGvtikl1DSEYnURcGgdVyqIYoPNpNywvps+IhsQBonN/hleTgK1dxl0X
         WDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784294443; x=1784899243;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4uaZ7H2Qb8XTb7fPcfk6UsEB9zSmShAVSKAzus36Zos=;
        b=K/6QagNZo5EMCeRbEXaQU8tUhL9sg2d7E8WDqj7/Z/1XK+NS5vmFlavW6UOh2NhHcl
         nrEzHsVgDzq/ozvdI6fBZBzhvxYwcbcMwrg+UXKmC/XuLSxVsFxxXKegdx8AQYAstoFs
         SS8am1eLCGso/Rt+HgxH6gYe313yO1uka8Ke3ecPB732kqKiIzcioR0B7wwm4F+rXI/C
         GbSfBxER6OFcRAl/nqvfwm5N6mAcmkwhSJJ6c3urCee0Sqcb7bsQmFFYLit7yehb7V5v
         Y8tbXAoa/2ZUI/X0uje65Q4ImVst1nQ9F+CIaZX40muSMDENzQHQV+I8ngFtfAUD4kp5
         f0xg==
X-Forwarded-Encrypted: i=1; AHgh+RrUgzq41J8lMOjYbj6kQOAybaqluNnfmTHkSiACACTalFbEU7vYE3p2IzjL1CDBiB5H5H11rox7aNn80g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ/QsHuC8TdEgZNB9P60ntllJIwIjVBBiHy5pZZLKcavl/FxKa
	2A2IApNVGPKnr/59y5MB8lhWcP7LUl9dSLqiLsRXRXbuP+fbAr52Ory0+ffKvD3ugrY+y+A4C5g
	8aqkpOqpv/SG9/dkp2vMw/bMuuqzhWIs=
X-Gm-Gg: AfdE7ckAzcqP8TCC0Piz7cXv5+VrTj/BlO2ESnmmaksKULt2RoAQsw9mCh1blQXB0bF
	gInvVI/Mbc56Wku/UdGOGNY6x8FnRPMOoKVewMnfdL61/Yv35wBe8VQUZTBmQewNub4CQZLPcvY
	W6Lu3XHYiI9oTdabIGb+uzQIdLIBurJabCJe+0tzc+dNyHBUs9sxgDhc49LDKwmACMsS5gHMsOe
	mtGGuJRUHd8ChrooRNxHr4NjNywFY4fwH1PTQBQxaS35aJuvwjPSOqUbwjlorl1dr3DOHcIew==
X-Received: by 2002:a05:6512:3c96:b0:5b1:6130:b859 with SMTP id
 2adb3069b0e04-5b28f99ae27mr704383e87.31.1784294443260; Fri, 17 Jul 2026
 06:20:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717103831.38492-1-david.lee@trailofbits.com>
In-Reply-To: <20260717103831.38492-1-david.lee@trailofbits.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 17 Jul 2026 22:20:26 +0900
X-Gm-Features: AUfX_mzwNsnfrelIsRFAeXpnbC3OSI-cmXle4luvtELjx_f92ObBqitcdpVMVWk
Message-ID: <CAKFNMon_DCsPC4Nc-98ORnkKpOGBS7zQ=kF4HX2R+_46vgztvg@mail.gmail.com>
Subject: Re: [PATCH] NILFS2 superroot inode-size OOB read
To: David Lee <david.lee@trailofbits.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org, 
	"Dominik 'Disconnect3d' Czarnota" <dominik.czarnota@trailofbits.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 7:38=E2=80=AFPM David Lee  wrote:
>
> super-root inode metadata size is trusted before nilfs_read_inode_common(=
).
>
> Reject super-root inode sizes whose computed on-disk footprint exceeds th=
e
> filesystem block size. This prevents malformed filesystem images from
> making nilfs_read_inode_common() read past the end of the super-root bloc=
k.
>
> Fixes: 8a9d2191e9f4 ("nilfs2: operations for the_nilfs core object")
> Signed-off-by: David Lee <david.lee@trailofbits.com>
> Assisted-by: Codex:gpt-5.5
> ---
> Trail of Bits has a reproducer that triggers kernel panic demonstrating t=
his bug and can be shared if needed.
>

Thanks for the patch, David Lee.

This patch is certainly necessary, and the checking method and
location are appropriate.

However, regarding the patch title, I would like to modify it to
something like "nilfs2: fix potential super root inode-size OOB read"
to clarify its purpose.

I can make this change when submitting it upstream, or you are welcome
to resubmit it yourself.

Thanks,
Ryusuke Konishi

> fs/nilfs2/the_nilfs.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 7b23e373a106..f3805e7aabeb 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -461,6 +461,12 @@ static int nilfs_store_disk_layout(struct the_nilfs =
*nilfs,
>                           nilfs->ns_inode_size);
>                 return -EINVAL;
>         }
> +       if (NILFS_SR_BYTES(nilfs->ns_inode_size) > nilfs->ns_blocksize) {
> +               nilfs_err(nilfs->ns_sb,
> +                         "too large inode size for super root: %d bytes"=
,
> +                         nilfs->ns_inode_size);
> +               return -EINVAL;
> +       }
>
>         nilfs->ns_first_ino =3D le32_to_cpu(sbp->s_first_ino);
>         if (nilfs->ns_first_ino < NILFS_USER_INO) {
