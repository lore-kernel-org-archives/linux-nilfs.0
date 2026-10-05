Received: from mail-yx2-f40.google.com (mail-yx2-f40.google.com [74.125.224.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6432A4E4328
	for <linux-nilfs@vger.kernel.org>; Mon,  5 Oct 2026 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220596; cv=none; b=LkmnwszBkoMYdfEedoSvUHqs5DrE4iOJ5OSd8sKHp8UIjyYezmfYTd9XhWMi8ex/pvdnG/shb0FM6byyuHGRHp3zTJXZx7a+j1pb/zKxwPWfDSB2+IITGeviOq5zcb6IF95P/Rnnhtjrq/dMm0enyv51iDtoYz1+jbRygYzo/v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220596; c=relaxed/simple;
	bh=spCsFwIR1kBqjdKFmaT3rO3/WSvOIuog8p6LU7IadYw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cl17iA6AhLixKTwRPvv+f/1T/inTEhVHiReJMNSs+JPMHyzHq9UuNpMgddaJtR8qNR/J1JHKKycKICj4FSc8ncopw5qaZ2jsVv+pyOV6wBmW29xn8AwwbrvX9cExLY4D/yzGdY/zbWOKpMGLU4R/Vv6p9A+sQSKRtko1UAJY5UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=BTd0UR53; arc=none smtp.client-ip=74.125.224.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="BTd0UR53"
Received: by mail-yx2-f40.google.com with SMTP id 00721157ae682-8a87fe69060so14200787b3.3
        for <linux-nilfs@vger.kernel.org>; Mon, 05 Oct 2026 10:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1791220593; x=1791825393; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6aX5X4Yn7Qvu8UgoHgFGENT3jbs4Y44FkeeaTsFT230=;
        b=BTd0UR53+ud2jkMnjM2dHrzjFXuYkuPnunAp0EFQq8ZPAyzHg3GnXTFbJZk4AHJR0f
         k8/6S+KRuUeMRlgB1R8R0+SRcbZdwK8Xb3mQ4sQMAtMEGRSEh5cV4evRTf9R+sKYEXMS
         951uzEwNVLM4gYxF6Y9jVac/3RZneLVb2/PcezM7I0X5fiq3BGcVYPVINRFBU9ww9oQi
         2RbyffkWjZiGv+ke93yryz6fNVv0xakoxW7BSZoVZGUBsVphoQ61z7IaiXZikXMiy7Hh
         CFC1uXGdklJIBmThL4V5RyvKz+gnW88dfsRA8GavHrlWfPCMX+1JxJ3PLs+cGXNm26oZ
         bYFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791220593; x=1791825393;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6aX5X4Yn7Qvu8UgoHgFGENT3jbs4Y44FkeeaTsFT230=;
        b=HJatEyySU0cyK4oaa7+Qb7HnLvg+/YwTG2YpzlyfPTG1q2KXmprBOBp10RoedOkf+Y
         pfoZE2EVlm0fNZeiRwJXd3QNL3dEiq/4oEhUz2qrimqFQwJQZEcGqL1QRAoOt/+zFLlw
         UBd/JHxo1fgBjDBAkEAR+jtEEoorOzE8z6N97Gb84zUr84ZvylTcOPWmHtK9q/pQXQ8/
         5FkLKQ8J5bjrcLDLXnlsmcK7sDHHWfltkJnJ5Eu6Z0Xsyetq9FPQtiRfmlp+ycKAUqRj
         m9e3wKghmt0NsU5RfI/vGAgljJw2ZSCFDjMEJSaCnOfquD3UHPe6ukJ42U6taVUgm7O6
         ZRaw==
X-Gm-Message-State: AFq9FYJh0JPc97jLHVhvzSl59czUkZ8NVg5qewvtt17hVUUSF6uSKFQL
	2SH0Vz7Uo6q32eEzoZsxob/r/28e0/7VXR7LkANeyQlZK62TvKmpXyGipo+sg5mJvFs=
X-Gm-Gg: AYBFou1k/KHrXDNMis1bm7hulY8Gfj+Dfb22HDrGYd9g/dvFeJ4R1FkJ/H96Un61W5q
	JcYfYRu+vaJ29TUk0NrfkReGN8P4R4JmMdAMRYJwszgV3NgKb5exKXkSt1yKdkk8Yyk/tQvNaaE
	wvB7hKC/CTq5kkZerLY/iWw6tcYlXLl42Nc1zC91XLl1un0LBvs9Zqw0KFvux61IO/O0LZ7UWkz
	/Zq/i2dTjQClhZenDcJ1s3Us7FTT3cjMxboN9VwhB7XrG4l6lVfBYr2QRIAVLevNEPnXDtzH8K+
	OFnrUAOATFXLdpGrQKgq4CUgUBz5IdVKLt8de4c3ME07sxOX8SgAVopdLcU1ELA1BgokJ2w9xWE
	3fVGcgupsA/WMNszSKw4Bftu3llejGRvkHQZM/edy5ZoxYGD4qESD21nyySe1NDWKnin6wSKPmP
	EW4XoJ6EtLoOB8J1+Ar2lpMTtU9V3KM6ywo6AfI4pYwt1MxZ3g57+EmqosIRmD9uVvc8m8L/gyE
	MkiFMbSIhjSSdLlXYBHtl+G14jlpcZUj1nXc0fkQ4BujCv0V8omkM/rMVrjGBiiZgxTACRTCs4x
	9tYsR1WYfIw9SvnLj4Zsl47aCMV9GwteSOmNsCD/FcI44tauazoLNvzPLX7jVA4g
X-Received: by 2002:a05:690c:e210:20b0:8aa:148:76bf with SMTP id 00721157ae682-8ae36a0683amr30450067b3.7.1791220593066;
        Mon, 05 Oct 2026 10:16:33 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:3aa0:911f:4e09:b45d? ([2600:1700:6476:1430:3aa0:911f:4e09:b45d])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8af2755f78csm16120827b3.23.2026.10.05.10.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 10:16:32 -0700 (PDT)
Message-ID: <cba5c89f47212602dfb7e95c2d5104771356a432.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: simplify nilfs_mdt_writeback()
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>
Date: Mon, 05 Oct 2026 10:16:30 -0700
In-Reply-To: <20261004233506.20802-1-konishi.ryusuke@gmail.com>
References: <20261004233506.20802-1-konishi.ryusuke@gmail.com>
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

On Mon, 2026-10-05 at 08:31 +0900, Ryusuke Konishi wrote:
> The writepages() callback for metadata files, nilfs_mdt_writeback(),
> calls nilfs_mdt_write_folio() for each dirty folio via
> writeback_iter(),
> where read-only superblock checks, folio dirty state clearing on
> error,
> and triggering of the log writer via nilfs_construct_segment() are
> performed.=C2=A0 This helper function is used nowhere else.
>=20
> Executing these operations per folio is inefficient:
>=20
> - Checking if the filesystem has fallen back to read-only mode is
> =C2=A0 repeated redundantly.
>=20
> - Calling nilfs_construct_segment() inside the per-folio loop causes
> =C2=A0 redundant log writer invocations for a single sync request, where
> only
> =C2=A0 the first invocation performs actual log writing.
>=20
> Unfold nilfs_mdt_write_folio() into nilfs_mdt_writeback() and
> consolidate
> these operations at the function level.=C2=A0 The read-only check is move=
d
> to
> the top of nilfs_mdt_writeback(), replacing per-folio
> nilfs_clear_folio_dirty() calls with a single
> nilfs_clear_dirty_pages()
> call to discard dirty pages across the mapping at once.=C2=A0
> Additionally,
> nilfs_construct_segment() is invoked once when 'sync_mode' is
> WB_SYNC_ALL
> and the mapping is tagged dirty.
>=20
> With these operations consolidated outside the loop, the remaining
> per-folio actions (calling folio_redirty_for_writepage() on already
> dirty folios and unlocking them) serve no purpose, so the folio
> iteration
> itself is removed.
>=20
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Viacheslav,
>=20
> Please add this to the queue for the next cycle.
>=20
> This refactors the metadata file writeback callback function,
> restructuring an inefficient legacy function organization rooted in
> the era of aops->writepage() to align with aops->writepages().
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/mdt.c | 40 +++++++++++-----------------------------
> =C2=A01 file changed, 11 insertions(+), 29 deletions(-)
>=20
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index b50c88b65183..77dc2be2ce65 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -391,51 +391,33 @@ int nilfs_mdt_fetch_dirty(struct inode *inode)
> =C2=A0	return test_bit(NILFS_I_DIRTY, &ii->i_state);
> =C2=A0}
> =C2=A0
> -static int nilfs_mdt_write_folio(struct folio *folio,
> +static int nilfs_mdt_writeback(struct address_space *mapping,
> =C2=A0		struct writeback_control *wbc)
> =C2=A0{
> -	struct inode *inode =3D folio->mapping->host;
> -	struct super_block *sb;
> +	struct inode *inode =3D mapping->host;
> =C2=A0	int err =3D 0;
> =C2=A0
> -	if (inode && sb_rdonly(inode->i_sb)) {
> +	if (!inode)
> +		return 0;
> +
> +	if (sb_rdonly(inode->i_sb)) {
> =C2=A0		/*
> =C2=A0		 * It means that filesystem was remounted in read-
> only
> =C2=A0		 * mode because of error or metadata corruption. But
> we
> =C2=A0		 * have dirty folios that try to be flushed in
> background.
> -		 * So, here we simply discard this dirty folio.
> +		 * So, here we simply discard these dirty folios.
> =C2=A0		 */
> -		nilfs_clear_folio_dirty(folio, false);
> -		folio_unlock(folio);
> +		nilfs_clear_dirty_pages(mapping, false);
> =C2=A0		return -EROFS;
> =C2=A0	}
> =C2=A0
> -	folio_redirty_for_writepage(wbc, folio);
> -	folio_unlock(folio);
> -
> -	if (!inode)
> -		return 0;
> -
> -	sb =3D inode->i_sb;
> -
> -	if (wbc->sync_mode =3D=3D WB_SYNC_ALL)
> -		err =3D nilfs_construct_segment(sb);
> +	if (wbc->sync_mode =3D=3D WB_SYNC_ALL &&
> +		mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
> +		err =3D nilfs_construct_segment(inode->i_sb);
> =C2=A0
> =C2=A0	return err;
> =C2=A0}
> =C2=A0
> -static int nilfs_mdt_writeback(struct address_space *mapping,
> -		struct writeback_control *wbc)
> -{
> -	struct folio *folio =3D NULL;
> -	int error;
> -
> -	while ((folio =3D writeback_iter(mapping, wbc, folio,
> &error)))
> -		error =3D nilfs_mdt_write_folio(folio, wbc);
> -
> -	return error;
> -}
> -
> =C2=A0static const struct address_space_operations def_mdt_aops =3D {
> =C2=A0	.dirty_folio		=3D block_dirty_folio,
> =C2=A0	.invalidate_folio	=3D block_invalidate_folio,

Applied.

Thanks,
Slava.
