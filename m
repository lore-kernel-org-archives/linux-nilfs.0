Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3ED16FF25
	for <linux-nilfs@vger.kernel.org>; Thu, 29 Feb 2024 21:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709241303; cv=none; b=Fsv+YBMSzKcEcNm57+qOcmRCBNxwTg01gOSUm4kpcscSdd/p+JoJOhMueg4mNa7JnO0k4OPQefdVmXqBsot4ixDQuxtUBxz28YaHOlEFF3f33gV8o3KBCIEmF9JdXHWl4H3kcdQocvF+BXh2xGouwx4E83b+joxZX5AMIHQrC3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709241303; c=relaxed/simple;
	bh=X5fnAUTNVB5E1nS/HE+h4eWD5PRl4JvDW+rjzkoREhU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=VYNggKf9SXXk7BoW9tTeb91IXz1hh4AvOF53DUNs3FJnc1MQ0lzFLLjDcDJ2uL5gPHC+NOsEFrBHoHJiQZq/tltGL2g1eCmKcmlMs4pZfycxwmYHMdT3dGYhVVrwZXYA3myrQPcigBM14WBmsgjEfqpToRSK2GIxh/G4vQyoknI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=w7POS9lx; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="w7POS9lx"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a34c5ca2537so234754366b.0
        for <linux-nilfs@vger.kernel.org>; Thu, 29 Feb 2024 13:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1709241300; x=1709846100; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X5fnAUTNVB5E1nS/HE+h4eWD5PRl4JvDW+rjzkoREhU=;
        b=w7POS9lxcR7lOEtxqCepB0Qx/npBzbYs+roIXsRqn4t2BYtKJZ/wpFHxNhKlQ5pBk9
         Xq8t5ennb11yzPwinVyl1eagOqglCn+o+j2JcGc12mcMznKB0XKvmhKfQtbnOwGxi+G3
         aKUt334ifu/qban7UihCjbRuW1+heC3nU8vdD7suOkYcwBfNk3OhOKB2YgxBusNzEFdA
         ZFFfQUhD8cSI4amHCfkx2KuDuvwKI7HBtA8kW04719LlOe1CyzOurpqMgXtE9hhoMSF/
         LT60HPXm+DwCldwIYvYZds5HcfbycyB1BXUucHFhBtCFCejAVhf3ITy9aeCVdzFAjblF
         +W0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709241300; x=1709846100;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5fnAUTNVB5E1nS/HE+h4eWD5PRl4JvDW+rjzkoREhU=;
        b=er35xbTRZ4Ug0rEfMeoGNBszz7Z90OxNcvguLt4NXiD24jP+BSZC2cSeOJk5Ljf/7g
         amfvqHGq9C7YFNSIMAxgroJR9IWhjtzuCompBx1QxUVYqNspNhQVhDL/y40QcZJCqEYq
         QqexfDlv0VRidF3uDJIfsboqG1PmLF9OscN/v4i3Jmbbu5iALvBJXcTJzj9vnfG7lyVp
         ZOaNDAK+pAldzi2hJUMXe45lRpKhRrDVs1/OoKPKRfdiPZXwRzmHAPN5qk/khf71tOFg
         X5vxS6/RriM/GZC2PLogTUHYKJEcooOkHvxoLjo3REhBZDpxP3pMAro/tI7bC3H8+Dxb
         TiTw==
X-Gm-Message-State: AOJu0Yzv7LT82RsUiw8yNoGQv64lPfBL4cOXCONfJiR5k8GeH7kzmxHk
	UZFFA3AvJTyjiKLui0mmvIcuEErvlNR75RgXxk7UKve/8UH1fRAHxUo/rGvLszo=
X-Google-Smtp-Source: AGHT+IHbRqbb3QQhTbSEnTrcrs34FIveCIS4tXNzk2mvYxkOuYflsMH8fhz9wWnJlAbyijS6zEK1JA==
X-Received: by 2002:a17:906:c2d7:b0:a3f:3c26:b250 with SMTP id ch23-20020a170906c2d700b00a3f3c26b250mr92460ejb.40.1709241300274;
        Thu, 29 Feb 2024 13:15:00 -0800 (PST)
Received: from smtpclient.apple ([2001:a61:1069:f701:6c1a:d05d:ad7c:b80d])
        by smtp.gmail.com with ESMTPSA id jg29-20020a170907971d00b00a4412406741sm1032579ejc.131.2024.02.29.13.14.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Feb 2024 13:15:00 -0800 (PST)
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
In-Reply-To: <BFEA2A31-3147-49EF-A9BE-592C90E783DD@toblux.com>
Date: Thu, 29 Feb 2024 22:14:48 +0100
Cc: linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <215C3176-D6E5-47CF-BC48-7A75CF75CE3F@toblux.com>
References: <20240229121650.33983-1-thorsten.blum@toblux.com>
 <CAKFNMomtp7ZwB0gmxoemp_ums4rqOSbfF2BMS6kX+LwtKYtvCg@mail.gmail.com>
 <19910196-DFF3-4F94-B6D3-B9BF722DF8B8@toblux.com>
 <BFEA2A31-3147-49EF-A9BE-592C90E783DD@toblux.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
X-Mailer: Apple Mail (2.3774.400.31)


> On Feb 29, 2024, at 21:40, Thorsten Blum <thorsten.blum@toblux.com> =
wrote:
>=20
>> On Feb 29, 2024, at 20:41, Thorsten Blum <thorsten.blum@toblux.com> =
wrote:
>>=20
>>> On Feb 29, 2024, at 19:45, Ryusuke Konishi =
<konishi.ryusuke@gmail.com> wrote:
>>>=20
>>> All of the fixes in this patch seem to be correct, but this doesn't
>>> cover nilfs_resize_fs(), nilfs_max_segment_count(), and
>>> nilfs_sb2_bad_offset(), which also have do_div() that doesn't use =
the
>>> return value.
>>=20
>> For nilfs_sb2_bad_offset(), where the dividend is u64 and the divisor =
is u32, we
>> would need a dedicated function like div64_u32() that doesn't =
calculate the
>> remainder, which doesn't seem to exist. What do you think?
>=20
> Never mind, there is div_u64(u64, u32). I'll submit a v2 shortly.

I left nilfs_sb2_bad_offset() unchanged in v2 because div_u64() still =
calculates
the remainder.

Thorsten=
