Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736F113E7D9
	for <linux-nilfs@vger.kernel.org>; Thu, 29 Feb 2024 20:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709239237; cv=none; b=B0oS+nFsYl6IGj5xVLlxuqSelQrmk2vPnITsnTc2/5lK36a9MPOuhGHMxrDCCSAi/kfxv26oxdL6O84H2Cvn2DdF8j1P+a71KarXu7hAA3tNe+pFq/uj0zFksCuzKWsb/B3Af8T5mlb1ldlTb6WMvFnySvvR5XE9P1/GqTiBEOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709239237; c=relaxed/simple;
	bh=BbgG5w7yu+QX5FfjrTF2VmLEo++5O/1fX3vCzvCmwjs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Chf9polt+Wx2HRxvZ4iI0BhdnMkfyOoyPqek/BGBogRfb64UrKgEMdtKmQOsLhv0xPvNMy0YiylMHzZ8alMQ9V9Ss5k3YOz+oW2So9n5nlppC4qmjVFSsiVjXeIrwMA/P1MhFL9okGu1cSi6y+Pm1Vp2n9GKO/Q4FXiQXpqPO7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=dj1ocBUj; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="dj1ocBUj"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a3f3d0d2787so210804466b.3
        for <linux-nilfs@vger.kernel.org>; Thu, 29 Feb 2024 12:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1709239234; x=1709844034; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BbgG5w7yu+QX5FfjrTF2VmLEo++5O/1fX3vCzvCmwjs=;
        b=dj1ocBUjYxX3wEF4+Tezmioygx9UC2PReUf8BLuKZ/Vba4woFBgd5wavj3GMWlIbcQ
         On/POQiAYmB9irzQRJDahx2RsnBnJph/8/HGg0WdcwD9bITCJJ9Mxl1rgmJ0eC28fxdr
         lk/szNMOAvtB8wM1MnRoxZrmYW6LUJsnodaz6cb2BxeQjLsFKN+GMrV/QbEm/E9qOzkS
         bMBuKuBFQfo6dDwRHpHyCAqdOv9L97LERKPEd+IWhN+MDmdU5Sjr5eH0eSshTjbtQ7t6
         0Wabmqakkl1RFJtqe/5UltzA2wXPBFINymCun5DeUZ3aR3+rMmJ62eqoKQBnjatulOhr
         TWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709239234; x=1709844034;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BbgG5w7yu+QX5FfjrTF2VmLEo++5O/1fX3vCzvCmwjs=;
        b=FTZVJl99STfpyGaK/jjtQYIMQ1LpD+KINjcnOT90S+rpOIpP1D2f8i/fcK6TIyGBSG
         RN35YIQ0YEbMdmsUo8Lr1Fd1bQ45vBV+s2pTaog6oTdR8XxnAgQGBxbP4+exJK2Nh927
         GFXtdOP0XJZNe23MElNqnH+cEDdLTQc9IvOT+112K2qMIwTjWhn7VFmZGKbrwVEAxekW
         /uVegijFlyJW/upmkNTRkKn62bRlcXlsHG9q+dc+n/ygO0bxP8OKbTQanKx6UFqMOXDS
         Al9KwktFpcCW6UIUO5D44NfYjj5NrTTVD9grA0TSHEp4ylpmDTKQH+72xZ7kBoftrq6B
         q29A==
X-Gm-Message-State: AOJu0YyHatAX/Y1Jwjk5v7fxxkf7rCrRWi/K9k7pEUjoXfcnRh9pzcqs
	jFF2vllkSuUndLc1ecIfVu4e29gI5sVAZObD9RNxQtN1A5KhUNC8vBS2REmKA9c=
X-Google-Smtp-Source: AGHT+IGv5uEYgl89DteoWDxb6zYSseqqzqDjr0ESVcRHsq9OxAzM6rSLUoUkrjTp7IKh8Si+k+ojHQ==
X-Received: by 2002:a17:906:5a94:b0:a3d:b6c2:fc58 with SMTP id l20-20020a1709065a9400b00a3db6c2fc58mr56249ejq.2.1709239233697;
        Thu, 29 Feb 2024 12:40:33 -0800 (PST)
Received: from smtpclient.apple ([2001:a61:1069:f701:6c1a:d05d:ad7c:b80d])
        by smtp.gmail.com with ESMTPSA id f26-20020a170906139a00b00a4417c46efbsm1013526ejc.82.2024.02.29.12.40.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Feb 2024 12:40:33 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: Re: [PATCH] nilfs2: Use div64_ul() instead of do_div()
From: Thorsten Blum <thorsten.blum@toblux.com>
In-Reply-To: <19910196-DFF3-4F94-B6D3-B9BF722DF8B8@toblux.com>
Date: Thu, 29 Feb 2024 21:40:22 +0100
Cc: linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BFEA2A31-3147-49EF-A9BE-592C90E783DD@toblux.com>
References: <20240229121650.33983-1-thorsten.blum@toblux.com>
 <CAKFNMomtp7ZwB0gmxoemp_ums4rqOSbfF2BMS6kX+LwtKYtvCg@mail.gmail.com>
 <19910196-DFF3-4F94-B6D3-B9BF722DF8B8@toblux.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
X-Mailer: Apple Mail (2.3774.400.31)


> On Feb 29, 2024, at 20:41, Thorsten Blum <thorsten.blum@toblux.com> =
wrote:
>=20
>> On Feb 29, 2024, at 19:45, Ryusuke Konishi =
<konishi.ryusuke@gmail.com> wrote:
>>=20
>> All of the fixes in this patch seem to be correct, but this doesn't
>> cover nilfs_resize_fs(), nilfs_max_segment_count(), and
>> nilfs_sb2_bad_offset(), which also have do_div() that doesn't use the
>> return value.
>=20
> For nilfs_sb2_bad_offset(), where the dividend is u64 and the divisor =
is u32, we
> would need a dedicated function like div64_u32() that doesn't =
calculate the
> remainder, which doesn't seem to exist. What do you think?

Never mind, there is div_u64(u64, u32). I'll submit a v2 shortly.

Thorsten=
