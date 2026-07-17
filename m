Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218BE39D6D4
	for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 10:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784284816; cv=none; b=XrSU8gpsEWOCQIpfFgKhTcu3LCgx+4ykPWpH/1mUD/uYU91O7HfEDlV36q4nqHsrXVXioa1G3lgsyFztnSt8R3C0fOHiHwpQO0rgvfyT992iek3FjxWMp1mBjxDV/uoLBHkN0tOvbe094X8o9rBn9kMGtKoBDkOWSdo+O3mw7bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784284816; c=relaxed/simple;
	bh=hRp7ZDSj39hQz+qZSkot6zSokk47V5imHaPDTgeAMX8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQqM79D1y5ATYstx/gHHGSgbB1kPzwZSZy4ltYNqtseANITZ4v5nooOcqENO9jx4GuwG58t26Ol+4OX6HyVZ4WK8n5UbKLARBB1S5PUAAKp4QseEIp+it0uqov220OksriumWSawPWg1nx/rcuWmRvzUlG5UZ7rcQczZwql9HpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rsV9cVD1; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rsV9cVD1"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47defd0c1c5so3378929f8f.3
        for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 03:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784284813; x=1784889613; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hRp7ZDSj39hQz+qZSkot6zSokk47V5imHaPDTgeAMX8=;
        b=rsV9cVD1mGeScW+zNSaz+w+szoRPAlpAljuwAsVU9GQrfucabWAF/knsdjUNwGm4/C
         6WUTYhaQ0Gd2o4f2BdB35YyGgPotRF91VfF71SwzbpMMoxEggjF1ZNeC7c0btngx7cdO
         Sl1Fv+gd3psjMpEKE4gNNufOquBDdq0A+DIpOgoHQdXU6R4/gM8TANCfJNv6Th36gWjK
         dwjxGEA+U0H/CyQd0DlW0vu5eLNz5bW9QQp1aUmKmDj0ecdIEev3lMKo6jMOgj0Pn4FP
         NJaMeHbpwVqTRgdjnVuzm8+qBxy4Pv/Ggxmzht3fvQIGwnGfUnMox/qvR6I5qeivJIEU
         hMhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784284813; x=1784889613;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hRp7ZDSj39hQz+qZSkot6zSokk47V5imHaPDTgeAMX8=;
        b=PEl+Sq23AsayfGZIukgPUI7HvvEbWIvIgrE7KbYHHYMCRC2XYXBPQOcVmlKjf/2CuB
         R3H0tomsMQHkNIpHQ4NcJzhclWIo2zP0x7mXgyyQ6RndMJDFH2cigxFyvkgPdCQYd8vj
         Dn8JfMRDMlIMUmor65Ggst6K7tLu15gxnK1ydyIRMmuA1hRl1Fu28vjgYxucJMv42jH6
         VUyrAQO6VWEv0OH4Bq3s0lbK0hufy0kjTbjj5W23BKDVEIHenumLYhxaau8q0/6QbByx
         /rueL2pwNNzjvmC4+UEEiNA2q1nt2ZEz/qWXt7Q/VzQClLLnbShNkdmCNxwck9upgv/A
         7Euw==
X-Forwarded-Encrypted: i=1; AHgh+Ro3uB8Z6VhZ+at3doVWiAtHl0AmWPd1dE3nnuTkPsq0gBhTVyhkS1iLPSIWYzlLL7yR3kv4B6LmBT+Jqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBD5f2jddqBAWx3PadQg2siiS/CJsdbKISXfEE6XZApbIUYfya
	AxPynd62cSqdplNbz9NRGqTNlLQHxhCpnLjfaTJAZZmqZo5Wab91P/4p
X-Gm-Gg: AfdE7ckRwzwsZzwF76aS5jL1TJg/4Nz3ia7gnoXL230SN6lO4dLcto+YpwEArVRQ62H
	H+eEs/bFLQ01ao3Zl80G5z2trQeTkr2xCTARLyoHHhVFkSuWhg8Vw5GAKFM57wM0dfiOdGcDjp9
	mmLYQwWkcpv5TrGD4Ma7LJc1OuqM41nDskiGJFo2PTAAcgbzyjGWZAY7FA73lqZXFZtU6Nj6Ov3
	tRDAaf1PdI9dX4xAbf6gyMmW+ZNQ6LfiVPkoZlf0wYu2Id+9b2rZWEoRqYBiE1nXPQ4WINT3NgG
	APluIg9JeCJPZE8J7uY7x1dJyzo7Ki2V8Q3SFkugUkNuFcsLmjGww1ZN0mLLp1IHVXX2C1enYmn
	Na+TtwlvBphiaK0mx9rZCfpuG9LB27q/t8fuyKFgbzY4yKUuRqzJJPiDuzhsqnljmJ+aNBbBwPJ
	HBriBlolsJvx0nRiSNyFWPZkH91S8deKJ60n5AAzRzy+wm25uSUBEfcqENEA8c4aeW01UEIaXk+
	zreofeaccMquhBrx0GttiJqLncqnI83uIqInm2QTA/64xKbvGjkIbhP6pxBNFLOm4J22d2BTiqx
	w1dqwlOoB/zyQrChdg+JKTN969go/x1ssiQ1RAHK++2aNGJkHOZ+WgNJOYrq6oLZaYzSUCGu5Y3
	1q4QPTOjqyNlA
X-Received: by 2002:a5d:5d08:0:b0:475:5e4b:588e with SMTP id ffacd0b85a97d-47f6230cacdmr2744381f8f.20.1784284813109;
        Fri, 17 Jul 2026 03:40:13 -0700 (PDT)
Received: from localhost (90-182-112-124.rcp.o2.cz. [90.182.112.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e496ffsm2853619f8f.3.2026.07.17.03.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 03:40:12 -0700 (PDT)
Date: Fri, 17 Jul 2026 12:40:10 +0200
From: Joshua Crofts <joshua.crofts1@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
Subject: Re: [PATCH] nilfs2: fix infinite loop in nilfs_clean_segments()
Message-ID: <20260717124010.00001374@gmail.com>
In-Reply-To: <CAKFNMo=L6fQa54Nd+u4ySOeTAuWF36cgymYwdjKJpD_FLeXKfw@mail.gmail.com>
References: <20260717074710.1397-1-joshua.crofts1@gmail.com>
	<CAKFNMo=L6fQa54Nd+u4ySOeTAuWF36cgymYwdjKJpD_FLeXKfw@mail.gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Jul 2026 19:34:21 +0900
Ryusuke Konishi <konishi.ryusuke@gmail.com> wrote:

> On Fri, Jul 17, 2026 at 4:49=E2=80=AFPM Joshua Crofts wrote:
> >
> > syzbot reported a hung task in nilfs_transaction_begin(). This occurs
> > because the cleaner ioctl falls into an infinite loop if
> > nilfs_segctor_construct() repeatedly returns -EROFS (e.g. the device
> > is remounted as read-only after an I/O error).
> >
> > Currently in nilfs_clean_segments(), if err is non-zero, it logs the
> > error and sleeps but doesn't abort when it encounters a terminal error
> > like -EROFS. This causes the thread to loop forever.
> >
> > Fix this by breaking out of the loop if nilfs_segctor_construct()
> > returns -EROFS. This matches the behaviour in
> > nilfs_segctor_write_out(), which also handles -EROFS.
> >
> > Reported-by: syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Dcae54346a70bbceeff2c
> > Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
> > Assisted-by: gemini:gemini-3.1-pro
> > Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
> > ---
> > As much as I've tried, syzbot is unable to test this and always fails
> > with "FATAL: Kernel too old". Nevertheless, I've tested the patch with
> > the same reproducer in QEMU and the system didn't hang. =20
>=20
> Thanks for the patch, Joshua!
> This fix correctly addresses the issue reported by syzbot.
>=20
> I have one request regarding the loop exit:
> Could you modify the patch to jump to the out_unlock label instead of
> using break?
> This is to prevent discard commands from being sent to the underlying
> block device when the operation has failed and the filesystem state
> has degraded to read-only.

Yes, no problem, that makes more sense. Will send a new version in a bit.

--=20
Kind regards,
Joshua Crofts
