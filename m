Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73153305E3F
	for <linux-nilfs@vger.kernel.org>; Fri,  7 Nov 2025 19:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762544887; cv=none; b=nGtgEYoiP2Doh4yjsMB+FLbZQwD6erloAgSFeIXzG/OaXljcUyfQAzS4eQEqRoQKhwjI99DZ248U16KQNcbwH+YREoSkAR8LpaeTuQmWrTOsSizQxcSE9hCoxJ8gAnX1NfhQhhqKzb2dO0PTMTZKs1sL9yfXNTIv9F6OUMRFr/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762544887; c=relaxed/simple;
	bh=PHkFRpI4O4rLYmseZGAy4T7hC/2L7HbgEwTula52N4g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mEezFHPQGIp3H1crnaCDzV9O9rd5zbEnNxeiTNAlrJRVslO4l7QKK3hygbqta25gBgoMykTBWG612VmetHims6dWmwdQd2H8dHHZSD/as5YrE6CEvMaTpHxSJPtmVH/oUBNJQV+ubYRUO4mYtUHxwZq2qUxWv3TuDosx4j7SfZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=C5IRLwV0; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="C5IRLwV0"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-781421f5be6so13277617b3.0
        for <linux-nilfs@vger.kernel.org>; Fri, 07 Nov 2025 11:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1762544884; x=1763149684; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Nro56fmtpV0Qy3jJBBxHTQjxrwd+4kIWS8M+8A6MCao=;
        b=C5IRLwV0kqpHk4k58UbeYX614KZpRkiGtlIRKvY8lJFb7DmYy0CgGy/lYaLVEuVdvk
         +ribGQRKOMiI4YH3MtqMTMftFWjYiX9UBLp96WzIT0Iw7sqXSHYuENDZkT7UWJXLidUt
         UUQmUBjtWhskCgOwBVAgcjRM5Q8zFV0h1/RYi7K6MKm9gc+4JR9zCJChlgo4TMkbH43k
         SFCUJqeMzxaVecq/rfkfVTrTIqf125JxOQK2j7oeiaAR3dlPbk9a0JRro9yvhLqKCG8y
         pUwX1Q14nZpOssX6qSPBLCf9I0VrRlJGwCFG/inWD5a//XnR+IRQSkYowgN4QKS9LzFl
         mYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762544884; x=1763149684;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nro56fmtpV0Qy3jJBBxHTQjxrwd+4kIWS8M+8A6MCao=;
        b=Rz9fJtGFkiog/E1NgziWtUpPtZdGjJI/v5Wn/F9oGTJVtdDRefR8X5w1+K7WUQP0QS
         QxsoED54IFrVJYECU/FQFagQJWdNW5r5jpThIm6rkAlHsrcuZjoYVJtYU4uiSPfgYmlK
         8+l4oc4P3beQ0tGH8ylR00sBj4V5051tbAeZmGcbOZSNkEmaKJSZjc0x3sCVvcFv30Ra
         sy6k4prKZycnsL/dVZ7vtrddVjdY0lO14nA4DIRKhKz6+c/zE3VzKvqHyxZ6PKm8ZtB0
         Q1iAblJaegvPRK+PplDqbYvXx5HmcVQIjzAzLhMg6lPhyPi0vTUfxsjPfKVp6XDmpAmq
         kEiA==
X-Gm-Message-State: AOJu0Yw9xjmTaLq9meNw5jgkkeBnKDwQ57FyYgbul9nHCQNPu3Oydn2H
	lQEE6WN7lOCqULI+JkMrJDZF1xTwMYKDNh7tB9WrRVzUQYdh0rA+tbh4xgdR8+kYg0E=
X-Gm-Gg: ASbGnctWh/xkzBTfPPFGc0XSjNbqvKCCtObQSQnerwjr35V+/nOEfGI4VN75jlG5LMa
	jMW+T744Pz3+MsXFnjvAPgTxcSeuw37kLCcx/rCIkrmiLbq1XSF9oShmkVnP352K64V2CKoQaCb
	QA8FDQo+sFfnXK/ko8PrDCXZYiYfR6paNL3mfUOgqWTrGKb+Zj2h0AR3j8Jprvg5hxz3GdXMbmy
	I77hhW2hd0A1l8uYlL6tsi74fujUlqXn1dNwnvfMdINITt+PrvzmjpvzKTIRsC7CdkbNK5j+Qu2
	MzDkcq6275cLTVZW0w0KdV4Si7jieE26o7PXKOUhZt0jKmyCROKs0s9H3HGxACsKimmbaeR1GPW
	KcKchaWJaQAqIuzVDnYZrKnymuhkDneODitQHzsJ7hBKkHIWFgQufAfVYS1KqWYyYO/F7KfIozt
	qH5FzjMZnPe9fk/hMRdu+R4Nbcvq6LShWjJQOW/2F4TolOYXKwD15kk0iBvK4=
X-Google-Smtp-Source: AGHT+IGDDsSfKpJ/MqK/76Fpuiv2Sq2hBBwoioBtcCYtzcTvuMt6aqULGYvN7FDmSzaLKWDS4m0FKw==
X-Received: by 2002:a05:690e:1507:b0:63f:b68b:1eb8 with SMTP id 956f58d0204a3-640d4520d88mr236906d50.7.1762544884296;
        Fri, 07 Nov 2025 11:48:04 -0800 (PST)
Received: from ?IPv6:2600:1700:6476:1430:8c91:1a8d:c064:e9bc? ([2600:1700:6476:1430:8c91:1a8d:c064:e9bc])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d6809dfbsm453857b3.11.2025.11.07.11.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 11:48:03 -0800 (PST)
Message-ID: <dee71ba8e018f7eedbe8e86b0e37246eda2e0a40.camel@dubeyko.com>
Subject: Re: [PATCH] MAINTAINERS: update nilfs2 entry
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Nov 2025 11:48:02 -0800
In-Reply-To: <20251107153530.9023-1-konishi.ryusuke@gmail.com>
References: <20251107153530.9023-1-konishi.ryusuke@gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2025-11-08 at 00:32 +0900, Ryusuke Konishi wrote:
> Viacheslav has kindly offered to help with the maintenance of nilfs2
> by upstreaming patches, similar to the HFS/HFS+ tree.=C2=A0 I've accepted
> his offer, and will therefore add him as a co-maintainer and switch
> the project's git tree for that role.
>=20
> At the same time, change the outdated status field to Maintained to
> reflect the current state.
>=20
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Cc: Viacheslav Dubeyko <slava@dubeyko.com>
> ---
> Hi Andrew,
>=20
> Please add this to the queue for the merge window.
>=20
> Viacheslav will help with nilfs2 maintenance (upstreaming), so change
> the entry in the MAINTAINERS file to acknowledge this.
>=20
> After the next merge window is over, I plan to send nilfs2 patches to
> the mainline through him.=C2=A0 I sincerely appreciate your cooperation i=
n
> the upstreaming work over the years.
>=20
> Thank you.
>=20
> Ryusuke Konishi
>=20
> =C2=A0MAINTAINERS | 5 +++--
> =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 46bd8e033042..d5e2c1524a96 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18254,10 +18254,11 @@ F:	net/sunrpc/
> =C2=A0
> =C2=A0NILFS2 FILESYSTEM
> =C2=A0M:	Ryusuke Konishi <konishi.ryusuke@gmail.com>
> +M:	Viacheslav Dubeyko <slava@dubeyko.com>
> =C2=A0L:	linux-nilfs@vger.kernel.org
> -S:	Supported
> +S:	Maintained
> =C2=A0W:	https://nilfs.sourceforge.io/
> -T:	git https://github.com/konis/nilfs2.git
> +T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git
> =C2=A0F:	Documentation/filesystems/nilfs2.rst
> =C2=A0F:	fs/nilfs2/
> =C2=A0F:	include/trace/events/nilfs2.h

Acked-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.
