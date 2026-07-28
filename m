Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61BB3191D3
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 23:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785281313; cv=none; b=UmveIYI60ijILek/yj6V5j+Ie9mWsCJMeyyIwFMPhgHBZKzsfqrZGyNsAI9/Z6y8Ba96YasTIkN8R/4M2U/zVZcGU0emXwkAcMXcKEFOA08TYAvNHS8QW9VuZj+8lAyEY7XmFyTmCgkkil//JjBPJG9MBxppnwCsbEu6kP6shqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785281313; c=relaxed/simple;
	bh=4m6pWDn1HnETrR/DTSnPEE8CIGw4wwjQ8fI5TZHi/U8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Hc4/EGkhtXsgulLZIqqRYL/03IFb99TBBSWrczrn4UqICKm+Jf6E6V0JOa/NwEr9ujDzOzzFYrLcn4uK5V7UVouBqv65Hia1cxNu/Mly0aX9U2y8PO5MyspZvPRT7kI8IwDkH24yNd5EaDx/pN0LG5mQ0V49cYn1SYVoTWgoJZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=KYt2opUx; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="KYt2opUx"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so280378a91.2
        for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 16:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1785281311; x=1785886111; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4m6pWDn1HnETrR/DTSnPEE8CIGw4wwjQ8fI5TZHi/U8=;
        b=KYt2opUxydhPinkGKxTkp+1wuX14wPyaWwv2AoNc4ZqNvEFMQcVvVy++B6GPq98PNg
         RjzIlxV+6mYkVSrdvrSmLJ178A5iPKXZ5K1Ckmem6fphxSAGuwir6OV4CRu+qKCEMYtB
         0uyoZYCtJUEDr9Tc0G4YbGH0Zaz97/uN6HBPQDsbRRe+ffSmBtt9pqpO8Xo7Z9DZh6j6
         zMO1iyFQwskIXAyjlOMlXsYmMWfPFiLCZP/5fp+NxSCje6t1T10TSZsERdSMq17xCIWD
         jMKolmFavDwi1ymQyw0r+QMrYQjBOxFWlHobn0kjS0r92hQq572sCxOVi7Gm8m2FO38C
         RdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785281311; x=1785886111;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4m6pWDn1HnETrR/DTSnPEE8CIGw4wwjQ8fI5TZHi/U8=;
        b=PEQjwfMit3srAOiK7lbGhxjhouV0CMAM+9c1dU6knTe5xs+IZdS+aWbKPuPCeuZ7aD
         oVMJeX3jV+Bsm2ZnSGDgLG0dDB1V1JpeWG4gZ+2EdQWddVt6VKU1QnBRqob1CJk0T7Gp
         jEnZ3EUGBk/Goq0qI0uJ1qqdrA0nfMNJFKc01APTlZAjVAmC37HtCIj08E1QF4gxq3aP
         co18Sa+JxvGrgtOgS1UONhqcllS+qylD1S/ceYlSTQrMy8VjOdkjUR0z4jcVW3TdEIFa
         qLzlXnzC8iyL5/gZj9rmcD7xx3ktnilCS9e6TCMYgdG9DAnLV94HpEeV+eRZleRFYnRi
         IjUA==
X-Gm-Message-State: AOJu0YyJH046BriUjpBOIJ5azq/re3cJpJvZYMWfsmQEo498ZHntGWNL
	H3Up4O5fpDs2Qb3vaXX8JovdrWbBClovN/Z8Ys/CevckVOJBcYnUhQr47dLJi8n+3UB/d73D8Z+
	67xcRZXSuS+tB
X-Gm-Gg: AR+sD11cPZryHxxHC2PCeFI3I8O6JEhRTW+KZccqLjZdx05BBJXEY1PuEG3RZ2H1T5u
	NZuUPAG8hIQoGB2UMHkTmZJeFjf4MCu5sAvMpY83iXRbPtgoCXnOpFy5Rvsovy/V5VAvlLQV4or
	OoiWl9fk1opa0UvMEndamug1f/II+D13gNF1EzfcWPS/cz7efxfa9feGOpodV2gNQXq6DOGx11S
	d/5vdoL19qPP6+USivXO8e6OBwbhg3/w2TtNlVLtrwQfmqmGvxWuqWvnN6q4BLWZKva48Q7CwMP
	8aStihM3uMjg6ChkatDxOk6ITdUpoCS8z9LPGCNBg/lA/u1EUlsKSr5ZVgS2jTKY8jMkdrKkiS+
	6yMGeBRWEPbyGs36qvzjxahpeBI4hzva3Cg79rrhgmEjuzA1N4ubP1dXp5Wzotmzv7EM4/Y4MLY
	E2j7/jboBVt+qUmz86uIy34AEKYqRHDRuNaMu6oPiB8XR//vZghcyyfN7Kj9mxhpv+Q9WmdKp0g
	sSvdJ/QqK+BCFe23yyHmghe8/lQLWwV+LBBp8uzoaMTcL+qaoOw1JdqCPsUDxVk4h+6Vsb29Bgx
	g/f/aCCgZmS3N5An+JlnlpRjot/3i9NVgKFwHUTNepKHjUvRiHBfaF8=
X-Received: by 2002:a17:90b:2d4e:b0:38f:474f:e6b with SMTP id 98e67ed59e1d1-38f6a5ae1f2mr5159593a91.41.1785281311290;
        Tue, 28 Jul 2026 16:28:31 -0700 (PDT)
Received: from [10.0.0.3] (162-197-212-70.lightspeed.sntcca.sbcglobal.net. [162.197.212.70])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7262bc27sm3538601c88.2.2026.07.28.16.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:28:30 -0700 (PDT)
Message-ID: <61617a0287d6e0bf0914088712d0b57d2e5cec75.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty
 state mismatch
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, 
	syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Date: Tue, 28 Jul 2026 16:28:29 -0700
In-Reply-To: <CAKFNMonu620z87=b=+9Xwn44Zr9-CssQkn=mes5EqEc=iJUm0g@mail.gmail.com>
References: <20260720141716.205384-1-konishi.ryusuke@gmail.com>
	 <CAKFNMonu620z87=b=+9Xwn44Zr9-CssQkn=mes5EqEc=iJUm0g@mail.gmail.com>
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

Hi Ryusuke,

On Tue, 2026-07-28 at 13:32 +0900, Ryusuke Konishi wrote:
> >=20

>=20
> Hi Viacheslav,
>=20
> Sorry for the disturbance while you are busy.
>=20
> Could you please pick up the following four pending patches -
> including this one - for the next cycle at your convenience?
> Excluding those already applied, these are the ones submitted by me
> or
> requested for direct pick-up since the weekend before last:
>=20
> - [PATCH] nilfs2: fix slab-out-of-bounds in nilfs_direct_propagate
> after truncation
> - [PATCH v2] nilfs2: fix infinite loop in nilfs_clean_segments()
> - [PATCH] nilfs2: prevent out-of-bounds read in super root block
> parsing
> - [PATCH] nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state
> mismatch
>=20
>=20

Sorry, I think it was a glitch of the email client on my side. Let me
apply the patches. I've missed it.

Thanks,
Slava.
