Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9971023B0;
	Wed,  2 Apr 2025 11:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743593488; cv=none; b=hfHdSvLxG2sYGTvNVAR/gEXQ4yo9j9LC17TSXpNoR8wkZLGqyG35dPTmvGVvfiWzCwUO9Ov8u5ZEodKfUPGW0a9v29BMQMebcmEGg+vTS14MiZUq9gdM6uNSkHkjaKEBY0yg+C6klMk9GCMfbRZUJuGyTY5Lax8hFdmidqa4kaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743593488; c=relaxed/simple;
	bh=k1UyVXVWg2z8ebfSXRRxAGOouyZA/x1/w5HRrCKSSeE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LWYICxTcEjO1/4n2xdDrFH7gSc1QywKbSC/1p1qvaA0JiiELP9HOtVyY6LFPAVaMKJMoFNh8HPGspb9magPcVardXLqNnumyDUknRvm4X+C4u8BiEYOSixg/FPB3SkByhVgyTdg76ldJ+O9GP9mU9hZ0ZwRJM9Nhh0HlpWKTNC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cJq/UmwN; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cJq/UmwN"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-54acc04516fso6275728e87.0;
        Wed, 02 Apr 2025 04:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743593485; x=1744198285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VOAVNu9Kqf7PZaTRYwlcNfDlS68QrPwBXmLNyWX78Ag=;
        b=cJq/UmwNsnm6BB47UEoGq890CcvjzKwUw85HuQbuKaMo4gX62zoQfVRcCYYTxqhNA5
         nnj22pQ4pW0aqXEPoDmEl+6O34WRb33xmnFkyt/YTkB8arh+YJQ/cwAmdoROnFRSAF54
         fpYr3IvAtenOly8YR84ksBq74qV9Fm6z5J+yWNrowYX49wOZKf+H2lLW7xQe9/1CTSer
         H/DJgAXe2pIj0xJUs0vyTIzraxQF0SbfnvfnR/tQJcupze4MlK0PJmkq0xM+xgsZD7VG
         ++dXhjDshFOrhC+ynCC+iTQR5NB4flA+nZxpJ68bDnUbu16yWggcHeDg5UKvKwNlvzIH
         C1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743593485; x=1744198285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOAVNu9Kqf7PZaTRYwlcNfDlS68QrPwBXmLNyWX78Ag=;
        b=vdA67KE7AJwbw6+5cJZzl1eQsli1qDV6CmDBBAJURs1EGrYGVEqO4tG4hcC0Tvpi/p
         gXqNjS2+Gkvn5g7Jlj7n8yWEIgOHcWYsQrRqBs6uqMUol+WdsiTEEHLCKgUqZPxAsRJo
         EInSvxhzyU3Ilgu17XErSezfLfPjisSs7n26wm/sdKFqhM0nU6hxoPvLLXAoEYQQ0jFF
         YxrgiMuHil016TWw9LHNHa+hL+wzX6tYmxrslVa9cVLRaxBE8+6U4s3et5ekj6BHu0WP
         qw9k10jYksrOh7n46kblj4UCuQr/cFBgy83sLN8FsK2Id5hxFIYHpsMXNTD/sM9RSATt
         CSxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJ7H9aKjA9eVcEGahWDcjZTQ8HAWV++KMnyUQgJR8d26p26576p5hbJ8aFQqe/wXT3lsNgdJd6@vger.kernel.org, AJvYcCXyKbqqdNiuiTJzn/Ggpe5nv0+LKjuLnw7ntJc8msmfa2A48DMNjrmE/z9Y0ODrfSz3o102e03cB2mC3eQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOAEdu/KtCCGfkJSAK4M6gOaZU2zLr065PLuliCv/JTxi3s9Va
	W7d0awnEczVOS1hQbPSg4Fi36Msx5GAeZkZa/HJ3GFjUluWUnzk4EbUGlhBtpPCGuQt7C7oIef1
	70/p6p2ILl4gSrB3e7U182vl+SJ7lKdMy
X-Gm-Gg: ASbGncupwAW70wl+NsN7moB1sonOxekLRyoO72dZVtpZaybivyzQDeIrXO+P7bz4ZVd
	KSIqCMDsi7B03NptvrlYe+0u5HBekaT8TmqIAS3GrWmjAPNzo/069s1opereTugu1QSTtATapCV
	rExT8p2rfUyf72Agig0bj5TSmstZ313+yRuG6fwzwuSKa3zCqSPGV1QQ4ZELiDmvIT60v+G20=
X-Google-Smtp-Source: AGHT+IGDP7fN/mlgeR1ejgbnG6v2T05K9e3eS+G5D4ks1NyMNbGzNy7b9fCSqq7Gay9J6tYjG5W23A4J+hlZdsO25Ts=
X-Received: by 2002:a05:6512:2c99:b0:54b:117c:118c with SMTP id
 2adb3069b0e04-54b117c11f5mr4261792e87.57.1743593484370; Wed, 02 Apr 2025
 04:31:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250402085856.3348-1-vulab@iscas.ac.cn>
In-Reply-To: <20250402085856.3348-1-vulab@iscas.ac.cn>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 2 Apr 2025 20:31:08 +0900
X-Gm-Features: AQ5f1JovFhM7rRGBrJhv4JMkrXTr2ISvt_zbXmpfVi3qcZyzfqwkEJEsTyuCYdM
Message-ID: <CAKFNMomx3hpQrntyO0zQZviPa40LiC5KqxFa-m1PZcnZ7ku58A@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: Add pointer check for nilfs_direct_propagate()
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 5:59=E2=80=AFPM Wentao Liang wrote:
>
> In nilfs_direct_propagate(), the printer get from nilfs_direct_get_ptr()
> need to be checked to ensure it is not an invalid pointer. A proper
> implementation can be found in nilfs_direct_delete(). Add a value check
> and return -ENOENT when it is an invalid pointer.
>
> Fixes: 10ff885ba6f5 ("nilfs2: get rid of nilfs_direct uses")
> Cc: stable@vger.kernel.org # v2.6+
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  fs/nilfs2/direct.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
> index 893ab36824cc..ff1c9fe72bec 100644
> --- a/fs/nilfs2/direct.c
> +++ b/fs/nilfs2/direct.c
> @@ -273,6 +273,9 @@ static int nilfs_direct_propagate(struct nilfs_bmap *=
bmap,
>         dat =3D nilfs_bmap_get_dat(bmap);
>         key =3D nilfs_bmap_data_get_key(bmap, bh);
>         ptr =3D nilfs_direct_get_ptr(bmap, key);
> +       if (ptr =3D=3D NILFS_BMAP_INVALID_PTR)
> +               return -ENOENT;
> +
>         if (!buffer_nilfs_volatile(bh)) {
>                 oldreq.pr_entry_nr =3D ptr;
>                 newreq.pr_entry_nr =3D ptr;
> --
> 2.42.0.windows.2
>

This patch requires review and correction.
To avoid noise, I will comment on it separately in a reply email that
excludes the stable ML.

As a comment in advance, the commit pointed to by the Fixes tag is not
the commit that caused the issue, and the version specification "#
v2.6+" includes versions prior to nilfs2 mainline integration, so it
is unnecessary.

Regards,
Ryusuke Konishi
