Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932C9481AB5
	for <linux-nilfs@vger.kernel.org>; Fri, 18 Sep 2026 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746306; cv=pass; b=elvWt3qJ3doJ6DV5fqf31n4/eUnrnV2tWXDyjjHMsRtT8YxgIY9MSeRDOPnnOMnqSY/Zmr0SQqawWS77RbRVXYBmqZCOTQmxIJzkT8SfjOE22xBrnqTp+yFeGCcu+PN8WXkEQcEuSCBFA5Q4sbKkYE6Ly05abWsYn9VEPKx16f4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746306; c=relaxed/simple;
	bh=0/1+4lJRG/Hkv6PdUL67hZJoHTNmoGhPPghynZYaz+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ouGG8wiF+5kMtkkz8NBfVmXWkwRcsflvwhjJ2CrUIa3BZqdWUNjwDlzN+hiezU/uRXwq5deMsb514BKzQPSa2d5rKIB1YLFNMbvWERkjFiJ93cOF3MdF3SVDEek+1rnLYxbyrORdFkBylDoogZBTpI1erLlaSgicklILcgNAEwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rN9c9dUC; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rN9c9dUC"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8c3de61a3so535448e87.3
        for <linux-nilfs@vger.kernel.org>; Fri, 18 Sep 2026 08:45:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789746302; cv=none;
        d=google.com; s=arc-20260327;
        b=E/IzAbLtlfBw3jqwSjVMfBfFFPk8Ys26D+bK5A0gGKm7i0l8Bx+sf0rrdAUHfN523c
         jDi6owk++x6aOD2xswK/xju2UyidB8d/dyoEoXSOSLE/LjhvbVjXCWxwwXFCKFAVv5pw
         YNLYeNTIZ4d74BVadFzgfze7rBSo622XhK9dMJrD2x2QNIyznKfIYHdJJu99RnulTDo0
         b32we7oIsMa782Y2GqqMqQb4UG/xZIa0ZOstODzWtk9Y8nhTsI9VMDmut1RST2wBBh/4
         JsS8DGA30i8eYPmpaZboKjS42YrNN6cao4p+ZtDjgnxipHcyVjMF2fhe85O32lz9l9eh
         XZEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M849De+JfrPs8EHvjdLAqoSNF4UdGYALe/nW+DKp+kQ=;
        fh=0BVZ6AXb1LFktZ8qH3TBO9zRIFMsPBAocwusI8LYWug=;
        b=iVzbWH7S8i/0WCgjPCkJGYKSd8/oEXhxd5I9/xsqZmEBRVLFI4i9Ybums7C8Wk4gWA
         yrO2ZKjAi83Dj7gOJ3JgsqKiCQccS9zpTeIgqIa/YL/JMVTLfFXyR+zzRb0o2Swull31
         P22BiJH4FZ10+CDmJJBw/6AqzPkjHEWR6vZAgIKPJEWfv7THzLpTxMY01/yR1ftBO/dt
         Ns73whjTiGSavFu58hgRRp+1kJc2xeoGp8wbhM9pifzsPW4QM1VloJ6zPSN8gCOYa7BO
         KakCo9CAD+G4p92IEK+ej7hhROTjU8PR3CcjPLUmVaLispQkRIs1enHpqWFsZeQrOF3o
         1PfA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789746302; x=1790351102; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M849De+JfrPs8EHvjdLAqoSNF4UdGYALe/nW+DKp+kQ=;
        b=rN9c9dUCTI9ToiFMxQfilOfTl96zquqW8mheYkG2SBFD7lbxkBzwUiyptMGlJYr5U3
         hOTpxqHWkGu6GVbkCibvwak9iwAWO7gq6B7kWV5NIl5FVGwiQ6jPwuD34zlL81DITyNb
         kQ/vY4zhzgWfVi0feesRv6Sfx2QSN/rbf/HSRL38PUPVzdkF0LaR+3GCj+g2ksycVDJ2
         lKfghT/rrlEccuToZDjTkliZDRSObjT/JjS+9axFdJlmuKTilw4RshGlfahJBykIHZZQ
         fjQ9DLzW2yzyoqPGhBThGf5n0rgst44yI2JbymtBEiG9Xk4biJCMXtOw5+UF/Hqbpi29
         c8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789746302; x=1790351102;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M849De+JfrPs8EHvjdLAqoSNF4UdGYALe/nW+DKp+kQ=;
        b=OJFdornTMESFkGz62pxHga4sT8BWl5tW1jRRtOSOjm3/qrxQ1TNgdqBRWwYmUUjQMA
         ngQrGDmZ4uPuvnvG1bQRSs58I0fxLXffzWHn+DieEstBDuKrL6uCX9DN0e2i4IzhB0v6
         euZp4U6Wk9Nmr8JmJEmPCQiKyhIlmKj0lZN1jkhIqbntLkslfjrrJUyUYu76jLR+64uh
         SkugsOug4drhi+c2a9OFHsC+PnBeEWkWCAzqtnUUNufOzc14kyCAmo08GUVDjbQvuNc+
         n/Z9/ZE5dJW8zj22XvGPz/VUghqr7V/dh3h43UtrGSGFtatSbKrKIhxTxd8Zxfnu6CaF
         SK+A==
X-Forwarded-Encrypted: i=1; AKwUvBxM81/9AvBFftTu8Zki0udQPc3Hg7Rf91l8AYcoMk8G4X8J9S/7yXciKnUPgUVYLsHryhviMp3puk2X4g==@vger.kernel.org
X-Gm-Message-State: AFuF++knNtby8NO6lpJrR+1907tv1GUl8dLxLnEQ9G1/adAf0SUgQjPg
	hovIKn1SlASBqu68x7ESWPMWxzEUUOOIAHy6Ff/gsyPeyVdrYkJKz/pVq5i6mlyRbTqWokoqMxf
	OHR1YqzwQ8fGmNA2h0FphxoSpZTKsF6Q=
X-Gm-Gg: AYBFou1nfZ7+48JT6uSYeDQpWtxY8qqRSsJDRfL+I07KB+DsRfqExfF7izFa59aOiAA
	39ndnNL78q3wgQhfC6sLqvbejSHY4dYOF6S+zGhKZF0P1aDpAinABhF8B7Igi9XHm/3uf2xr9+x
	AJxABJDI7URP8nx3nfXXGaK03RcjduwcL/ODA4hWL4sXoYLWMXT1mrHgywWq6v+bLFk1XzoXOFE
	QI+X7i9ty90CTGH4sUy9jg8uYQxPFZXL25sWGGn3g3PgcvdzFzPCep9SlYR3TzTWJ5W+9wHjamP
	PRD/EgyaIiaGQ9y+cfTYRhconuyhCIK8Pp0e2ppWLzgr+j/MWgq8xZ8i
X-Received: by 2002:a05:6512:3da8:b0:5b6:1a80:865b with SMTP id
 2adb3069b0e04-5b8c198d00cmr959162e87.66.1789746302161; Fri, 18 Sep 2026
 08:45:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915111351.2726334-1-qwe.aldo@gmail.com>
In-Reply-To: <20260915111351.2726334-1-qwe.aldo@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 19 Sep 2026 00:44:45 +0900
X-Gm-Features: AcwNN1X8ej3rRCLkfczv2RVOrS0_dkKqsBj2-sWdfA8x3U0GxRBrhWL40nsH-Ls
Message-ID: <CAKFNMo=0hDANOd+DxxvKA=RNbiG-zygkWh6EUC6Vr2MYe4npLQ@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: validate file block counts during recovery
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 8:14=E2=80=AFPM Aldo Ariel Panzardo wrote:
>
> nilfs_scan_dsync_log() trusts the block counts in each on-disk file
> information entry. If fi_ndatablk is greater than fi_nblocks, the data
> block loop can consume excessive summary entries and the later subtractio=
n
> used to derive the number of node blocks underflows.
>
> Reject inconsistent file information entries before consuming their block
> information.
>
> Fixes: 0f3e1c7f23f8 ("nilfs2: recovery functions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> ---
>  fs/nilfs2/recovery.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
> index 4d5a6aa521..6e4e0cf4cc 100644
> --- a/fs/nilfs2/recovery.c
> +++ b/fs/nilfs2/recovery.c
> @@ -322,6 +322,7 @@ static void nilfs_skip_summary_info(struct the_nilfs =
*nilfs,
>   *
>   * Return: 0 on success, or one of the following negative error codes on
>   * failure:
> + * * %-EINVAL  - Invalid block counts in a file information entry.
>   * * %-EIO     - I/O error.
>   * * %-ENOMEM  - Insufficient memory available.
>   */
> @@ -359,6 +360,10 @@ static int nilfs_scan_dsync_log(struct the_nilfs *ni=
lfs, sector_t start_blocknr,
>                 ino =3D le64_to_cpu(finfo->fi_ino);
>                 nblocks =3D le32_to_cpu(finfo->fi_nblocks);
>                 ndatablk =3D le32_to_cpu(finfo->fi_ndatablk);
> +               if (ndatablk > nblocks) {
> +                       err =3D -EINVAL;
> +                       goto out;
> +               }
>                 nnodeblk =3D nblocks - ndatablk;
>
>                 while (ndatablk-- > 0) {
> --
> 2.43.0

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Hi Viacheslav,

Please apply this v1 patch instead of the v2 patch.

This function is called as part of mount operations.  When format
errors are detected during superblock reading or log scanning at mount
time, returning -EINVAL rather than -EIO is in line with the mount
system call behavior, so the v1 implementation is the correct one.

Also, please replace the 'Cc: stable' tag with the following tag, as
with the previous patch:

Cc: stable+noautosel@kernel.org # Non-fatal bug fix; defer backport
until a real issue is reported

I actually ran a test where a pseudo underflow of the nnodeblk
variable occurred, but no issues that compromise system stability
happened.

Even if nnodeblk becomes a large value, long-duration block device
scanning does not occur; it simply skips the position and abandons
roll-forward recovery midway.  Since the mount normally succeeds, if
anything, this silent failure is the issue.

However, this is based on the assumption that the file system image
was intentionally tampered with (anything goes) with root privileges,
including log checksums.  Therefore, as long as it does not break the
system, I do not believe it meets the stable kernel rules for
backporting.

Thanks,
Ryusuke Konishi
