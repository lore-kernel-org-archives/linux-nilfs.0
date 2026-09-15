Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B79F4503F6
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 19:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501419; cv=none; b=ecOCdGHGY7aD6divuFbhy5PV8c8uxf/sInfS4AIeU8oIv1Xf/NDaK5cpBjII8RJmpsUwNGjnn2uT01z7knEw0B7H1xkmtsjaZccAjo39NvJPTAX/QJm6+TAyZ4dc+Gb2utdQ8ZXA5XkIqCpVNB4PsQ04W/XM9iPnE3zulmJn4uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501419; c=relaxed/simple;
	bh=cQDi/khXp22kaDJp+dEsEBqmjhvlz1g67boyZ/PQrd0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JsSk22h0Gz4MtozECVFQSzt/6PqWfOFXM0PDQWUUTbmx/Xi6Oi815ZyfuW1021wuYJooRMkqeP87e6lPDUjltZVNBZeWXkpF/ZFp9VHLh/41JL3r25UdyhaSw2GmgdqkzFXh7Gp507pRk9FeXa9q/w11jy+437MBJmyT+47m9n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=Wc8TZqp2; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="Wc8TZqp2"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d4ddd17a0so1535767b3.0
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 12:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1789501416; x=1790106216; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i2LOI0WXXV1VVEC/9ThlMXobGg1l5GAIdV/ERsV+q64=;
        b=Wc8TZqp2fPQJ979amKHsD0hu7IeYyfoeXwMFVxXsXH7khIe6lWfHHuf1u1wcTvcw3f
         ZkFhAfT5M5YPY2afFUKGQ/B7MzILkvkTqIpAo1BHYGdejVJFtNezhvj0GjflPjIl7Frk
         nP2Vi+AHh+ISr3OlgTqbPAaMeV2ghY/6d3KPcQykLK/SZu04G2UlqQPZ/UaS3Gl8JMzo
         QeFSL9JUl6q2f168LHzzQdn0aqtL8xQ8LfjQ0Z1qrD26AASbD/qNWoLmIvkwvaxQxv58
         Kk6GYragnd+eb/W9PcRwoMW4bNXFmXKe5S3yW4iXx9ATzRCNjAlq2Z9HlnrgzZdLoMgJ
         pjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789501416; x=1790106216;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=i2LOI0WXXV1VVEC/9ThlMXobGg1l5GAIdV/ERsV+q64=;
        b=RkK8ZMwFZKb929Qlrrf1lVW2ufedMiRJEGIQp+vEJRUk96D7l2FUfBpRjwRsc6rKHa
         PVh3j8JHbUl2lXR7ijMgAhGF3d+I4pyw+yuw7pvUfHLCe4wgIryojGBiJz3IH3zg4qcL
         i1q3U5+IxfNNpuQlHuISw6z8X/na33IPVkWl38VpeKwNQwtoqbodMrpezJUjEIyzPHiY
         KO/5b088o5j/UVQ4X3qzxZu6aFpQUY73AVJe5eOiIMSOlVIZ1ZQjQvGEeid6oVFWHj8d
         fQEd73YEzVyE0Q5Zy30CHIoYJ0fMAWFtVclG+I3gxaVF3pKKVQwcPy3EtMLVOGknfbDB
         0uoA==
X-Gm-Message-State: AFuF++kLZRAAKvO8VN4RuGoIuohtjGytimE9EDh8YgakUpJdYhFiMhy2
	3ws/nMIBdyIvTQJxsYsDNvuLxHInYRPwChLNErprJOw5yQ1cA8Mla5H+U/8Ly0i60ww=
X-Gm-Gg: AYBFou1y1PTrIUAyaPt1nvymex82ci76qRvwSmmcXcCiyzqb7JbO0V6QmIyu1LRmeCL
	ojtsl/LnAEtdBV9Y8loAYX+XfG1sCzTdsLkLJGG+ZndppFDHlmJSYHknfHNyfQg+eewPiq1DpJo
	FLXAbVb1eZ0WJGH1rTtpYDgJpJutYElr8jKI5g296cD/F9WNfWwr34HBYFD199Cq5d1GTBAlRsR
	0UomFfrmPqXptjdn6aY5aP5kJWTdorLSYv/hi0ETX1LOIwkUuH3GhDTOQGh/uAGbUfviEHjC+J7
	9OApyj4fJ7POqmmMazriITf6r7CyhIpc8/L0rLAA8mxaXuUtb0aVhHLvjne+kiTICvkYFC13Mbt
	u936i9jAXSac0frrhtTFrwhSNxO62aJIGTh+a/xo/bD0VZ3E5c6CxkrYnWwMoSgYEZRANh/nuF0
	8QqRLJdqTvlMaf2v7NsDOXGa6VFg/WXC5IRfB5S2hdiXOK2XEuMWnbscDUDiBQpckEAKqt5tj4T
	ifE+dn0ZKcrdp3OMkelO6CPwhUteyTz9aIt94NA0WZ/7LIRCxOSPRYSOt5XdHvexmPNYicrkRG7
	bAPLfp6QEp+lwkhRc05KqatnhMLkwAKKEDA1xn9eH3ZecVfArXlecc1F98csodtdqgbEudtT9fo
	=
X-Received: by 2002:a05:690c:c511:b0:841:e9e4:8ab9 with SMTP id 00721157ae682-88d234ae9aemr34479907b3.25.1789501416583;
        Tue, 15 Sep 2026 12:43:36 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:e9c6:4a77:70a9:9f1d? ([2600:1700:6476:1430:e9c6:4a77:70a9:9f1d])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-891ee4a536asm922997b3.10.2026.09.15.12.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 12:43:35 -0700 (PDT)
Message-ID: <6423c0290e4a92dd0ad4757b896dfebc570a7aae.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: validate segment number in
 nilfs_sufile_get_suinfo()
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, Ryusuke Konishi
	 <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Date: Tue, 15 Sep 2026 12:43:34 -0700
In-Reply-To: <20260915111304.2725651-1-qwe.aldo@gmail.com>
References: <20260915111304.2725651-1-qwe.aldo@gmail.com>
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
> nilfs_sufile_get_suinfo() subtracts the caller-provided segment
> number
> from the total number of segments without first checking its range.
> If
> the requested number is greater than the total, the unsigned
> subtraction
> wraps and the function may process segment numbers outside the
> filesystem.
>=20
> Cache the total while holding the metadata semaphore and return no
> entries
> when the starting segment number is at or beyond the end.
>=20
> Fixes: 6c98cd4ecb0a ("nilfs2: segment usage file")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> ---
> =C2=A0fs/nilfs2/sufile.c | 10 ++++++++--
> =C2=A01 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index eceedca026..e3733d2be1 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -864,15 +864,21 @@ ssize_t nilfs_sufile_get_suinfo(struct inode
> *sufile, __u64 segnum, void *buf,
> =C2=A0	struct the_nilfs *nilfs =3D sufile->i_sb->s_fs_info;
> =C2=A0	size_t offset;
> =C2=A0	void *kaddr;
> -	unsigned long nsegs, segusages_per_block;
> +	unsigned long nsegments, nsegs, segusages_per_block;

The nsegments has the same meaning as nsegs. Why not reuse it? I think
we can do this. I think that introducing another local variable doesn't
make sense.

Thanks,
Slava.=20

> =C2=A0	ssize_t n;
> =C2=A0	int ret, i, j;
> =C2=A0
> =C2=A0	down_read(&NILFS_MDT(sufile)->mi_sem);
> =C2=A0
> +	nsegments =3D nilfs_sufile_get_nsegments(sufile);
> +	if (segnum >=3D nsegments) {
> +		ret =3D 0;
> +		goto out;
> +	}
> +
> =C2=A0	segusages_per_block =3D
> nilfs_sufile_segment_usages_per_block(sufile);
> =C2=A0	nsegs =3D min_t(unsigned long,
> -		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs_sufile_get_nsegments(sufile) - se=
gnum,
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nsegments - segnum,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nsi);
> =C2=A0	for (i =3D 0; i < nsegs; i +=3D n, segnum +=3D n) {
> =C2=A0		n =3D min_t(unsigned long,
