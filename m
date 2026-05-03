Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DCA3A9D94
	for <linux-nilfs@vger.kernel.org>; Sun,  3 May 2026 07:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777794183; cv=pass; b=NMMbleXCz8eRY2vokXx/m3DuxWg22wTCIaal9Md42gZwumF9Pz+2s1J0fzammXf/MptsiH6U/AsFHiZZswkKtE4x3x6bEfW8kialBnGyE/vQ5Mm+lHDZzuYLJyDz9BFb2gvIKglZWiGYoVPs+CASBDRPf5/a9TEOt+aoIAH3KS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777794183; c=relaxed/simple;
	bh=vO0BgCyCCBpw4io20N5pClr3ouvmEWnp+K6Fn8YGvFg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h5ykmzmOjhlB7Bf9zoDjhna5DWFVOhdAtuiw2PzRBZ2GAcjFq8HDPRWIPYAmIMCkUk7kwZdWdZmFeRVV54wSzNKphsw9maAByxXbvICWew6D/PnToBDvQehKPpRrGK52QtFi+mbgqGRg+pB+cZNvYsaRg9LzZ0xxu/FawLWY9Yo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PcZyupcw; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PcZyupcw"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-39397d63804so1105701fa.2
        for <linux-nilfs@vger.kernel.org>; Sun, 03 May 2026 00:43:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777794179; cv=none;
        d=google.com; s=arc-20240605;
        b=MvhCsPdQ09dOfVfUNej4TJlYQShuPEyw4ge0Kq1EZs8ZaBon1RSm1nMCxg2jcRMOKY
         urichJmvqD1rFnD6nNnGqoI721ae7xRBp4cQo2nY+axa1YSajS3hzmqaCJ6G5bIIsXuw
         Ndw53q+ilZby7FAhXWkUnZEde4JIUft0Cqqt+t0n4nsMFQsX9jhOfY+zBuNkRZ8qAr8F
         ajCAoQVW2qo6dMUlBMpgjbc4Vwv0NMWAFMEU/r766rMh8BPClwbkVukIOd1hJ28sihvi
         ySu2uFXJ/ZLfiClHwY/65tjmcWTJMFcE8XJLrCm/NppfPcr1b6uYp5tOdG5XmYOCYTnQ
         TiKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t2Zci70UN0+ctGCkjt4JpXFz189jhyPmf5LWqO2185c=;
        fh=7cszRMNhPm82vcvKtMrzeZmQNTXXLkPr2cCrYF8xW4k=;
        b=WQ+/+fW55mG98Jw2YnZE7DOuVw0v2ogXwP70Ux5jIJvehq73eDxdCqEiNRfEJ3RbJl
         hz/L2dfH/7nS/0z6BO5Kt3r1i8lZR6+nkZ1uwpULbA7PoJCzKHkC87uEavK7qiueFShR
         YJzAyvACjC4R66fN+Yb+KU6P5o08yZHkPMif8GqmFDvY0gyM6Q7kt+9oT+h1h0miUpLs
         9YiSqxyV1Q3le1kgEPRDYFb1Jh0jwyChfHNg5Bb3MQ+czBQgzbKObrrrvi4qmrE4mJM2
         pCrGLcRE9pJU5Tsrll3bRcA3fR6S8KtYc49wSpPf/YrhqlbTORJYD9LPPzcAKuQFiZ9C
         bGBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777794179; x=1778398979; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t2Zci70UN0+ctGCkjt4JpXFz189jhyPmf5LWqO2185c=;
        b=PcZyupcwybOBq+W0Ir7TqF7Z7QIO2G/P3jnQddhgNwB8uWouxQ4LxLxzR/p9CmF5Qn
         FPhWFcp9vaZjfc9pNWSV+j5y3fIX7MNmJB4bx4hvH10BBfv46UBia+YQo9PzHgV4ganu
         JEO9izSbuMrJ4lFc0YCncrIOv4476KCbB4hpy39kRVPOj3Pcd2nmzqOftNX7ieIx8xvc
         yt7U02mOBipBr5JemnWQgkh3KG6zg+liATP0m0RkCTCA/FXKCXXpbGMXiNUW0dj1+eh+
         34z06Rx1Bwi9sd2B3fZH13p18V7Eb2yA6pacobnSZ635UaYY++GHfh3YUV/oVDqc0ZRU
         MkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777794179; x=1778398979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t2Zci70UN0+ctGCkjt4JpXFz189jhyPmf5LWqO2185c=;
        b=JxuHAD162fY49Lu6LJ/AN7apIIT7483l2sOdpvFfkC8iuiqIdZt8z4AW9AY46IBlBF
         mwtTH+WStyXuzdSeDlR/O4dv/eLQD3jtNsl/g4l5aJ6ninUfR/AtMiJ93rqfcTZcDmvf
         as3l31LoJCs+Ne70g+p7Sog2PY0e9z68RtQst3jUxXBRp5bS+LrkoZZkrf1S/JkswRZT
         sybSQA8VAo7/k5LU7ysmhv4tTZybB5OD8YqpUrdiNucg2H6Jq3fgGlJ9hppHT2T/S74z
         Oq07eDuOuL1wTskHalQl/BnqDzv1C8TGkpMrBBDIie09bIHUF2lNOz8PtLdqzmkhdohk
         v7Vw==
X-Forwarded-Encrypted: i=1; AFNElJ/tug8kRBby0OVt+/p1Z53GcqF49Vw9SXECuhloZPYC6JVaLkwMVBdQyl/f4dmNLndYQvyT+MLRdm26xQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJj1c2NwMVFY6Ta4Ou8ZXbuOHtRM37HWnZvcCxHvJ/kYKuQFSE
	2qS5gcjK+0KGyPyGGzVO7EMIK4Vf/9ViNaf/Dx29IVHh096kMEif26zeDdYWwrnmrAIKNnUpGlL
	qGNyh7nr5gE58NoC3PgondtJ/b5wvTyGV/Yi5
X-Gm-Gg: AeBDieuBMp3Z4P1sLryaenqTYpMJWLyAr9/mS06pn4GsuNLYrcGCzyPdVis2a8H54WX
	knqS8Pvn0l6Bm51uSQs3uZfWbiODgxu9M4xJnvUCnUpDd1oIWBPRihSiU1mHLLGzoM2u7n+qCLm
	H7W/Dxlqy/OmmvBhjkvpOHy3pl0y6D/2dJ8vZGJpQI7NDgSb4gg+SqBij4q9rfXF2cpcCsRocgF
	a68qNIlb0oawTzsA5QjzqhVDWsHhm6SdpOXsVtbkkuMJrec61zTlPBq1zb+biNGShv3LcXDQZdR
	3VDbti/IWBtGvOHcnLA=
X-Received: by 2002:a05:6512:3ba8:b0:5a3:d375:f587 with SMTP id
 2adb3069b0e04-5a8631c7911mr1628582e87.35.1777794178749; Sun, 03 May 2026
 00:42:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260503041612.201421-1-zenghongling@kylinos.cn>
In-Reply-To: <20260503041612.201421-1-zenghongling@kylinos.cn>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 3 May 2026 16:42:42 +0900
X-Gm-Features: AVHnY4LEI3C6SMAWNV7AVQEIB3Vlqm_nEQmJbgi9R3rFdd8Bjk9KqE2oDK4RqlA
Message-ID: <CAKFNMomo6Np0=83XtJphysi6CbN0i9_r5h6K=j8suR6Q75CRdg@mail.gmail.com>
Subject: Re: [PATCH 2/3] nilfs2: Fix return in nilfs_mkdir
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: slava@dubeyko.com, neil@brown.name, jlayton@kernel.org, jack@suse.cz, 
	brauner@kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhongling0719@126.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 3, 2026 at 1:16=E2=80=AFPM Hongling Zeng wrote:
>
> Return NULL instead of passing zero to ERR_PTR.
>   Fixes smatch warning:
>      - fs/nilfs2/namei.c:261 nilfs_mkdir() warn: passing zero to 'ERR_PTR=
'
>
> Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dent=
ry *")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> ---
>  fs/nilfs2/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index 40ac679ec56e..e2fe95de3d71 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -258,7 +258,7 @@ static struct dentry *nilfs_mkdir(struct mnt_idmap *i=
dmap, struct inode *dir,
>         else
>                 nilfs_transaction_abort(dir->i_sb);
>
> -       return ERR_PTR(err);
> +       return err ? ERR_PTR(err) : NULL;
>
>  out_fail:
>         drop_nlink(inode);
> --
> 2.25.1
>

Thanks for the patch.
This is part of a series of fixes, but since you intend for it to be
treated as a standalone fix, I will queue it as such.

Thanks,
Ryusuke Konishi
