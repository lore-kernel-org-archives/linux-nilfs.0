Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731B0411FB8
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 19:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501620; cv=none; b=TwH+gXyupXttx6gBTWK+65Vky7noByiVPx5oJLm2P0HDS23kpHZmBkZ64PdBJkb0K80VnBPwIv4Z57AbfNZhwdFBUEHfhzX94PIqeUqm1b13oBCosC7v1cjyztx7lZqyD7qpHW0Z75joF/bU7/yE354Y4yGINBnwbauCV0T8XO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501620; c=relaxed/simple;
	bh=VQCwC59bOcr8xcm3IgBergLZ3aQeYYJJtL+vHT0Rhyk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OY4AhEHCHb8YcIRzVO1wZUhmfHWB5g0etaoVDvG0Chv94LhWutjItyv6KyjXYR70DMNszpt6NkzDEX/egnH8pRtH6azk+mcwu1YC8RUOEhZizfn4iqiurqunGpDds4rjz90aLNtr+02MZaQTxpZDRohdgYr2PxFzrhKWKcjiftY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=lEMSGq13; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="lEMSGq13"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d43db0c1cso2267567b3.0
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 12:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1789501616; x=1790106416; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8qXwlN8LwX2uwh2TzVgNrcfqJ9W0thnfuhSJP2yjK80=;
        b=lEMSGq13YTV/LMvko4UvI3N1Wk4fLtYFSq1RbFgTZKnQ4UrsIZwVmqFh1fAE4NSyOu
         lkq6uf3RSUMiVY7v0Bm87J6U6gkPSmp16P5iaSbr+x+Az57v06evr0+iPDnUplSXGlgl
         eqEJs00NLnEyBRXz/QnJ+ZHbh3I0Dvraozj87mItw+AL8M+QvI3fPBJUSzgXChJImX3p
         r/EalJDbJiWES2juqxZKEuDmv9KagKOrb5CE7JjpkDuzf0ZJmbabwG1sp9YCrzo9qEh/
         Ex6FAABar//qYsuHoe8YrdLN2Ap+g/BVtK1YcGfL3NGk6piyirlIegWB485Mf6eU2Zm/
         Mdbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789501616; x=1790106416;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8qXwlN8LwX2uwh2TzVgNrcfqJ9W0thnfuhSJP2yjK80=;
        b=ZSttyBb++KjgJX5TQy2u2kx95tInmL75gnpgefiEqp9CX8Y7kS30VVk6BSquDWR2TX
         C964WvOOmq9RfmByRU+rj4hMaFsXIMedVcCPU1uZb5gRnFqHfy/gSe0O7nzgPxdTtjGp
         GjihKq6di8ZtexnpxWrB2AMSHcpBpBEQYlepod2QJd5Hk3g+csUe9opmx6VVhtieH+9T
         tRrPmpo3z23dnSxGk25G2hrz+4h/6W5mNtH6o4f2A9GNE/janUv8UeuiKsf9AyjbNtmx
         +OcMO3/WzINYDgt9Mv4+cIkHXkairolhmIXQyXrlP2s5JSRnQ+8qoWhmVHH+Sp2KqTN5
         eMdQ==
X-Gm-Message-State: AFuF++l40furHyEpaCWlacDUxU9jyoZ8pZJB8AeEl+3D+W/qCgfR/abM
	bPL/00nVY5hXvaEY2TEzgMYkhxlS6csakwCnyodxxzg12uJ/+ymcC3Ey+FEpBx5R/4itzjZTsit
	7GNVXiGvvzw==
X-Gm-Gg: AYBFou3DR3VFJRM/jHkVrinJ991ZWRfzXSRFV9ssMcTHCPC7mesixneKJS6WCF+594B
	FO1avxwgJvbxdfV+QlZ9RsmvIXa8WlFFW1z445M0ZBwFAPzBydmSPkK/KYTBef24Be/QdXdnTI0
	kL84fYSGZKFyzyTuVB0BXG812xgz9/Sm64eohw5GhWXN3opgsNzKxaFGjyqwEid1c9AGnMHqYaZ
	RKDhloTAd5vPyL5ITKbWuid7Q+hhiSS5aelg92kmi6/u/EVbl0wQ6IsrR9fmSEamBBRE8eiyVK0
	c29AOX6MtReHkstpguRsQ3njUR4VQOthPRZFdZpYWXKsu7wkOWzwadSoHbIsUiV0b2QV508HhSi
	gZLF09ardRmZe/+RGFvHaMD2YGJHNs197MX1bXybFNf6ZguY+VRp+N2GnApDpcLGyxtCwvDMEvV
	BUuDlfyxYJ+Y9P7FWJihooOyIBKAxNvTQqCfSfKrlet2MJD+gAUGAf2Sq1yWY/RvkSK2zEo5ZWI
	wqKRHMK52KO46L8T5pslirDH2B37PrbwRh2whhzOKzxLJPF9+KS6zAfROIGG+BLzdXGjBxB9CTT
	inKXdu9yRDEMhipwfsE6sZbLyKi4rv5d9Ef6VXhc2rdaPgVqMqXQVConxQ1tRRnf
X-Received: by 2002:a05:690c:e3e2:b0:873:17c9:b054 with SMTP id 00721157ae682-892247b1ea1mr43247b3.21.1789501616280;
        Tue, 15 Sep 2026 12:46:56 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:e9c6:4a77:70a9:9f1d? ([2600:1700:6476:1430:e9c6:4a77:70a9:9f1d])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-891ee4a53e5sm939587b3.17.2026.09.15.12.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 12:46:55 -0700 (PDT)
Message-ID: <5a7a00bdaa378af13ca6b3dfe58992188557493d.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: validate file block counts during recovery
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, Ryusuke Konishi
	 <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Date: Tue, 15 Sep 2026 12:46:54 -0700
In-Reply-To: <20260915111351.2726334-1-qwe.aldo@gmail.com>
References: <20260915111351.2726334-1-qwe.aldo@gmail.com>
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

On Tue, 2026-09-15 at 08:13 -0300, Aldo Ariel Panzardo wrote:
> nilfs_scan_dsync_log() trusts the block counts in each on-disk file
> information entry. If fi_ndatablk is greater than fi_nblocks, the
> data
> block loop can consume excessive summary entries and the later
> subtraction
> used to derive the number of node blocks underflows.
>=20
> Reject inconsistent file information entries before consuming their
> block
> information.
>=20
> Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> ---
> =C2=A0fs/nilfs2/recovery.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
> index 4d5a6aa521..6e4e0cf4cc 100644
> --- a/fs/nilfs2/recovery.c
> +++ b/fs/nilfs2/recovery.c
> @@ -322,6 +322,7 @@ static void nilfs_skip_summary_info(struct
> the_nilfs *nilfs,
> =C2=A0 *
> =C2=A0 * Return: 0 on success, or one of the following negative error
> codes on
> =C2=A0 * failure:
> + * * %-EINVAL	- Invalid block counts in a file information entry.
> =C2=A0 * * %-EIO	- I/O error.
> =C2=A0 * * %-ENOMEM	- Insufficient memory available.
> =C2=A0 */
> @@ -359,6 +360,10 @@ static int nilfs_scan_dsync_log(struct the_nilfs
> *nilfs, sector_t start_blocknr,
> =C2=A0		ino =3D le64_to_cpu(finfo->fi_ino);
> =C2=A0		nblocks =3D le32_to_cpu(finfo->fi_nblocks);
> =C2=A0		ndatablk =3D le32_to_cpu(finfo->fi_ndatablk);
> +		if (ndatablk > nblocks) {
> +			err =3D -EINVAL;

It sounds like -EIO because we have corrupted state of on-disk
metadata.

Thanks,
Slava.

> +			goto out;
> +		}
> =C2=A0		nnodeblk =3D nblocks - ndatablk;
> =C2=A0
> =C2=A0		while (ndatablk-- > 0) {
