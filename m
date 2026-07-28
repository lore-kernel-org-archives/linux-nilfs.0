Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F4623E33D
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 00:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785200065; cv=none; b=fxDwqmYOMzWAziG4s7jTHj5zUqDRd/cAdnks1g5rxXVMWEzMyl82dIZ3zsTsXCKCOtwAVGretINnkfNEgynVpsIRYoU781ika1xfGTip77TNcPlYWvOSI7Fujl1PwFST0ktbWhEqBOcszhXyCC0GYyEZekXnh3VHewADuc4kVF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785200065; c=relaxed/simple;
	bh=/dx0mWAxIaVHUUWGsJAglMEC5vbZJ2jL6OThFOp3oaw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ksermCShtyi8mVC9Dy1Tfqdtz4dObQmvjRdscW3qCsR2TVb+d4sc3moJXd3TBFUURuYYIs3s3pC+dHLKAfAiqiJkl2wNhAnM1V+R9gB7naKUHSeXQ6nn4kZZ21Gx9fQmAganEXtEXvyYE7YslEQuYaEPtNRjosHbFXcOxPxOtcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=lwjSPHtk; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="lwjSPHtk"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-81ec29f1d07so40024987b3.1
        for <linux-nilfs@vger.kernel.org>; Mon, 27 Jul 2026 17:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1785200062; x=1785804862; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/dx0mWAxIaVHUUWGsJAglMEC5vbZJ2jL6OThFOp3oaw=;
        b=lwjSPHtk0iFx/qAfXdw+tTt3c+SeI3ahGEpzoLeLxVUDgvfQ+V+yNUo6wrUJae8yLt
         lW8+Hxs7cVrsHCkG8/fmXbgnhHPIOM77FIPCzikg4kIwJtebwGpMqhIltDeitWKx7Kvq
         QzAnKaYUpSxK+Ge22Km25j9UGnuy9raqJDAYhs02EUpSKRvfCXLFkXO7299z+wnJRRZK
         WtsggCkH4w6wtGhWcecHIAou93Tcn+G/GoytYfqzVNE4ZK7iegLMoEFiVMNjnx4U6vbO
         TM4X5C8MWU9JuEVGvL7h4PgSjO24DU3DYTnPluxWqwvnBtFMzynZBDy8ZzGGw0f106UL
         eBLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785200062; x=1785804862;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/dx0mWAxIaVHUUWGsJAglMEC5vbZJ2jL6OThFOp3oaw=;
        b=cV1aQ9mPo6pDdHfRK7Qb2VDyCPlk349mLgDav4Eyy1+pDE3t+V1xSc1lCcR+pYJq+3
         HPpNhx1quIHq4V05D4bCk2bXyDlfxflUQVZ5O3f9jJOWLR7Agln+tuvksnGyTr0KAXVy
         J0Q0SLJA/WY19dtJBL0gcLcK/a3XdIx64eOEyiM4RNve6op62ux13vBuvn3/1vxCt9qw
         wrSQ5u7w/Rmcte3KOrOhkcOWTMYmyAN5kHNHbYcGaUwv7j9hB17mVTbsfP7hK1gQUQ3T
         2Nmy4/OU83YAE7GFmb09COrT5ObYgyuE26sizZKavWfZkMJ9T4cFXHlOzwDVXa/yKDNR
         s9Dg==
X-Forwarded-Encrypted: i=1; AHgh+Rrh8JRgMjD17WHLO90tD0qZ7xGc0hkFMWxf9PdU0G8aGRZKTtvERsDpEVHNno89zfsxlMyiERrx27pm/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxelhWkPf9Sd476CMBC6T9SzxBHz5b7tkqygV5qZtWSjr0CpBuf
	SPfWYhI2u4vzAy/4wiShTc7r0C2t2S4tDe4QNYcxB/JzLHFczrNu4gFva9Y9dj6vnDfQXb6IjvG
	qNiD/WQHElA==
X-Gm-Gg: AR+sD12Aa+SYi4/z/qmtP0KhweiAQ5l4CSZOvp16e0+e+f8GQK1xpYcfOYEdapULudf
	yt2I5l1w5zW+E8jtF3WGePTQXL+nr8a9yQE1eqDJfYhUOvCzYbOfyuKZjWE/o8GkEb6Wz5nTed2
	Nlje0S3ERJiWi58CQ1Ubx5X/NnhPlKFD0i3d2/W2dVbYhR2q8G4Q6ow6shQSEM9jbACeLcO0tPm
	QnqUgpeMJYyeNSOE4XMXo+USuPaPnNltxXxh+E693ZSFoKdulDQyzVO0Ctr4UkrVPGdFCcufUuy
	yeh85DdkE7SlPdaAUQvKdv2qw9sKRuuEkVTSVq95W/OyqB5Rx0c6+N8nOjnk+lFlaDCung3MlIp
	kbhHAJS1G+F4GzsUNd+tEmiW+0SHWfOuhCP2R+4v8dYBMjRuHieSRY8iuDX0tN6owRC4tJ4nBX5
	A6z3MFJ8ufg6Qyco0T7WnqhAWh6luhTphty0BT2XPTxtnSYGWku1TqY43YSFPIhRd5YOtAZMKj2
	sp9sB1UQ4e93Zj6AFeFb4u+yoTVRS0L7oxpByEbYyMyiJbGIUQU+7l2iJ6CUwhBPXyO
X-Received: by 2002:a05:690c:f06:b0:806:b6ab:a410 with SMTP id 00721157ae682-81f98f0fe37mr914147b3.0.1785200062238;
        Mon, 27 Jul 2026 17:54:22 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:273a:c0af:6af:54a7? ([2600:1700:6476:1430:273a:c0af:6af:54a7])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f6592eb29sm39767947b3.43.2026.07.27.17.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 17:54:21 -0700 (PDT)
Message-ID: <357b5cca187ddd4651b6079434b728c403748bec.camel@dubeyko.com>
Subject: Re: [PATCH] Documentation: fix grammar in description of nilfs2
 recovery code
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Manoj K M
	 <manojkm24dev@gmail.com>
Cc: corbet@lwn.net, skhan@linuxfoundation.org, linux-nilfs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Jul 2026 17:54:20 -0700
In-Reply-To: <CAKFNMo=zApDzM10dv66TgcKcvJyzWmur=88zRpfK=br_BGY02w@mail.gmail.com>
References: <20260725100658.1705-1-manojkm24dev@gmail.com>
	 <CAKFNMo=zApDzM10dv66TgcKcvJyzWmur=88zRpfK=br_BGY02w@mail.gmail.com>
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

On Sun, 2026-07-26 at 08:12 +0900, Ryusuke Konishi wrote:
> On Sat, Jul 25, 2026 at 7:07=E2=80=AFPM Manoj K M wrote:
> >=20
> > Include the word 'at' to make the sentence grammatically correct
> > inside the description for nilfs2 recovery code. This improves
> > documentation without changing the original meaning.
> >=20
> > Signed-off-by: Manoj K M <manojkm24dev@gmail.com>
> > ---
> > =C2=A0Documentation/filesystems/nilfs2.rst | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/Documentation/filesystems/nilfs2.rst
> > b/Documentation/filesystems/nilfs2.rst
> > index e3a5c8977..a0124d22a 100644
> > --- a/Documentation/filesystems/nilfs2.rst
> > +++ b/Documentation/filesystems/nilfs2.rst
> > @@ -252,7 +252,7 @@ The following figure shows a typical
> > organization of the logs::
> > =C2=A0To stride over segment boundaries, this sequence of files may be
> > split
> > =C2=A0into multiple logs.=C2=A0 The sequence of logs that should be tre=
ated
> > as
> > =C2=A0logically one log, is delimited with flags marked in the segment
> > -summary.=C2=A0 The recovery code of nilfs2 looks this boundary
> > information
> > +summary.=C2=A0 The recovery code of nilfs2 looks at this boundary
> > information
> > =C2=A0to ensure atomicity of updates.
> >=20
> > =C2=A0The super root block is inserted for every checkpoints.=C2=A0 It
> > includes
> > --
> > 2.53.0
> >=20
>=20
> Thank you for the fix!
>=20
> Viacheslav, could you please pick this up directly into your tree?
>=20
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>=20

Applied.

Thanks,
Slava.
