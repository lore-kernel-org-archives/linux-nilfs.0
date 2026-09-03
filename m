Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E29503BE7
	for <linux-nilfs@vger.kernel.org>; Thu,  3 Sep 2026 20:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788467432; cv=none; b=SO0A2HC0lz6xTMdapnDXOQ3x3Am98aJOEiVdvoS/Dtyze/UOwaV2YKJAd6hK1JA2KJ6Pqoq4B/0YCOXBbsKaZ2V/H/m5E4zaCTfaSYA20h7Cv7gBUWIC986Y+bF6gzaczdnRAG/mfZYxw0bmnfyPyUJIZGeQodtwRl5vR/Ebmlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788467432; c=relaxed/simple;
	bh=2E9w1aqzF66RZURnTfgMHXRSpmJeluzd3kwgBHEa5DY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dYsRPjPgKTusRLpH2b1IFwOcYV5Q3Ar9ObK9jGVVtMEDA1Ey+WBRvvJLMiOT52WyhRm6KRl1li+8YnkyYnSwuV2xST7tRZPld1Wcb5iW2fn5RV95dvCtltKvvauDlCROSSz8cfLBv3RkxA3BKvI+7zBxJl93dgT3OqfbX7FW3y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=jLaL570o; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="jLaL570o"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-855de2d0d4dso3548397b3.0
        for <linux-nilfs@vger.kernel.org>; Thu, 03 Sep 2026 13:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1788467415; x=1789072215; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rwkmZsQHsgzSLObYQT2/MFZyLzJswR6lF4jrfX1emmg=;
        b=jLaL570o9mEf3zE8vj6f8PZS4J1Hs0T79g+vlPM5W/9K580ot2iABJb6JcmMd017Zf
         OvfhsCWPUvN6I7R+QVjT9XkY8v/FP9lUrLJrza9JcwXA/dx7jV6q4vKN81fLZM1cTGq2
         ANlZQocDyqHY62zVsmV9v82MQ8/ojjWTa3qPDK+TvDmFJzj1G6R55cyaLq/OxMyE7YxS
         QgYPnHW0AjSN4AXrXYtn1Sl7J8mlfBIavf3SIEbTOogkj5FjaurjF0SeKpDvG0cIgZGF
         w+bSSYEw3VuIfK9aZdVv6/eNi5xBIU5H7CKGzYsqfX4YSsGdgmnvcl3ckKQfb/PEx3YE
         CKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788467415; x=1789072215;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=rwkmZsQHsgzSLObYQT2/MFZyLzJswR6lF4jrfX1emmg=;
        b=lx1PbMMXX3/DhLZVmM45+vHVHEiIO7/Zg+7K9QY6VCCAYuy7Lt340+VBpRjhY2utSg
         yxJwnS3BkoP70DoWzwB6c2iOeLj8jxUM/ZwEwGy3KT29eVcQsgVFTIFCdJSlGr67H915
         jdYAa/IkEY5iv5gZ9JqsBJIENs3GdClh0nKb8kB3x2NPATy8XqyCVd3tTAeMXYKF2+I0
         L6Usazp62rY6O0KzgeAwp8twRyp7UoypTb38YpEJENdX38H1nKGEEPCqC1TzgtRONHtg
         2vi1pHzCygxPVVuBpHtge1aVz0m1n3N2L+2hj5W6oOx/rmlBNPrIbKmszJLnOhsP7X6e
         dDAg==
X-Gm-Message-State: AFuF++lnPFc0+3Qz9S3OaYJRVPFhhxOxudYVIOochfpdHbTvZkdHkGqV
	Yc6WTQE4Wdp1mfxgN5ZIlep8wcdJX4BmfkvplcytBNgZQtAyrQexgSm+s3LhVnAxbG0=
X-Gm-Gg: AYBFou1RGEYcUsn4EgF7fmQO+xFFHmzY9NkHAPv+yWvPTfRYChiYZBYqRStxEtEHh9W
	3o+hZXeUhPEW7tJiuUhJEzKu4Kw1ZCoREaKAv4CIM6Nx2HpDCLnDOU36yybC9NKbJN3du2VSCaJ
	ds23o6Q3q7+BytK1VdOwcBgoH/8CwWR7zGpHITp6OPvKxECumHRWYNqYXc19qcZpExy/21TUk4x
	D4uBc/WR5X8/tA1tMgibVJOYZ7lpBcuhFn4XhFJfX5XlwrHuRh60oIAUq6nBCb8pP4eR1myC3cG
	bs1BevW7mokhCQrJ757u5YDFNDpiNhhSXSMX5AjsFwbFpy8y8wc1YBpSt1lqKv6Fj7q1MbVNeCf
	vo6Xt74YrXbtVNWJslPGhfSgW2jBENNm5gHCIvog04GIoJwNAcXuQpSTKyTwjDXgJLKFEV4fyrK
	GbC0DF+6JYaPCrXJrnG8x2nWLoMU93Gccvhsz1JsJc0QZ0AFCwPspVElQYfcO138XvTcO5fXCeh
	Rpro1NroahECXHcWiUTmU4F6Qv8SrQ1DWQvKHqGxjx8pnXIW1QHl/ORCZYy3XodpsUtaSMDI0Qg
	mfrBCfXFlKE2wp2s1tgJ8x5Z+9s+GMU9tT+AWWbby3HPVNSubdNYsZ9UpQvXTgANUQ==
X-Received: by 2002:a05:690c:4aa6:b0:80e:dc2:873b with SMTP id 00721157ae682-871a04e7ffemr214507b3.16.1788467414578;
        Thu, 03 Sep 2026 13:30:14 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:afbb:9d16:d2da:18a9? ([2600:1700:6476:1430:afbb:9d16:d2da:18a9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714c1e1eacsm3714937b3.49.2026.09.03.13.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 13:30:14 -0700 (PDT)
Message-ID: <cdfe97ab759d5b667b5fee9061f3e77f6c0b36ac.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: strengthen consistency checks in
 nilfs_direct_propagate()
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>
Date: Thu, 03 Sep 2026 13:30:12 -0700
In-Reply-To: <20260903172557.9446-1-konishi.ryusuke@gmail.com>
References: <20260903172557.9446-1-konishi.ryusuke@gmail.com>
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

On Fri, 2026-09-04 at 02:23 +0900, Ryusuke Konishi wrote:
> nilfs_direct_propagate() is responsible for updating the virtual
> block
> number associated with a dirty data block in the direct mapping.
>=20
> It is not designed to handle intermediate node blocks.=C2=A0 Furthermore,
> it
> assumes that the block offset of the passed buffer head is within the
> range of NILFS_DIRECT_KEY_MAX; otherwise, an out-of-bounds memory
> access
> could occur within the inode containing the bmap root.
>=20
> While such inconsistencies stem from bugs, they can cause silent,
> harmful side effects unless a debug kernel is used - as was the case
> with a recent slab out-of-bounds access issue found in this function.
>=20
> Therefore, issue a kernel warning via WARN_ON_ONCE() and return -
> EINVAL
> for these anomalies, allowing the bmap layer to handle the situation
> as
> a filesystem error.
>=20
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please queue this for the next cycle.
>=20
> While the recent out-of-bounds memory access issue in
> nilfs_direct_propagate() has already been fixed, this adds extra
> checks
> to catch and gracefully handle similar potential bugs.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/direct.c | 6 ++++++
> =C2=A01 file changed, 6 insertions(+)
>=20
> diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
> index b8643d3aa2f8..64da677dc8d4 100644
> --- a/fs/nilfs2/direct.c
> +++ b/fs/nilfs2/direct.c
> @@ -270,8 +270,14 @@ static int nilfs_direct_propagate(struct
> nilfs_bmap *bmap,
> =C2=A0	if (!NILFS_BMAP_USE_VBN(bmap))
> =C2=A0		return 0;
> =C2=A0
> +	if (WARN_ON_ONCE(buffer_nilfs_node(bh)))
> +		return -EINVAL;
> +
> =C2=A0	dat =3D nilfs_bmap_get_dat(bmap);
> =C2=A0	key =3D nilfs_bmap_data_get_key(bmap, bh);
> +	if (WARN_ON_ONCE(key > NILFS_DIRECT_KEY_MAX))
> +		return -EINVAL;
> +
> =C2=A0	ptr =3D nilfs_direct_get_ptr(bmap, key);
> =C2=A0	if (ptr =3D=3D NILFS_BMAP_INVALID_PTR)
> =C2=A0		return -EINVAL;

Applied.

Thanks,
Slava.
