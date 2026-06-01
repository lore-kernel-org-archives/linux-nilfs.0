Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D143101C8
	for <linux-nilfs@vger.kernel.org>; Mon,  1 Jun 2026 16:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780332467; cv=none; b=T0pRg6XxOpk1RBJ9YaAlOQe9nmDxqxkZWmvg21UHTRggcrARdieg+qgehez+0bR5IOBcWvQD6SKoirSed5pjLcmP0qGlhn/gkY64uXjroY8JDey1WQPxRUtypWgnYKpRKeaVfMa1bbzO48nzkniYDiHbfEvzwpNbCc2L0gaBXXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780332467; c=relaxed/simple;
	bh=k7d7WO1IGhjE1EeoOZERJmeHfwgMycEtCXi2A0ollLA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=js3aeH9aqkIvOZHeLrk905kmfcxaoyCKI+dn+hi7YcamxS+Gdf1lNZM9oqezYAL2/oDEz34D3gQdvIerMQntLWJFoIcTYX7F23FkTxz0oWMoeQosZaU5lKQXr4UjgrqvLKpEUatvBpgxqm1kllzSGVfqexf8A4pptTZ0auhkuuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=CcIrEj3p; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="CcIrEj3p"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4854d5cc708so7002756b6e.2
        for <linux-nilfs@vger.kernel.org>; Mon, 01 Jun 2026 09:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1780332465; x=1780937265; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k7d7WO1IGhjE1EeoOZERJmeHfwgMycEtCXi2A0ollLA=;
        b=CcIrEj3pMQecm/JhQzqxTy9ldZE7pm8Rq4vKM/JctnD7zQ7BBF+4+opt5fK355v5IA
         HwtdiX7A+PFaAszOKj1QW0lTtVlUoKVbSMbUfhzbdwfXYqmmfiXMbSwvcbXSy1E4TL6T
         /DCLjA0FM6iRKVSmWhjmsPHOm74hAHZx903+lBj35v5Whgv8vSv7G2XwSWcX8jDDLZHp
         lveuspIj2BQQxssLJWj6hr4Z/8OCo8T4kfEJFmq5+90ufy2cOezTdaAnfqmFaC+jNm0J
         L5dgHRbgnVLArN9LtDi0O8dg7+BRoj3HY82gVHqlMDRCmtOTv2Yv4DiQ+FqO/AeOrw/f
         JHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780332465; x=1780937265;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k7d7WO1IGhjE1EeoOZERJmeHfwgMycEtCXi2A0ollLA=;
        b=Qdk69vex1l+M+2haxOXULkX3zsiOv3GSgaU7+4nocKH7wigDYrLS3Jpez6/DUQ732Y
         aRloLNHu316ECEqrAVFCpao5BBBEPOFu+tEsVmqIfFQjfRW7uj+234kmYu7OjS+8UpJS
         AQD0HAoItyy74LqdWBuMe/Vp1meFShjaWQd1daWyDIAydnR08o4wPYjTuTB6NrPKTCs/
         FlWx48klWXenNeVRZTa+dD2Ry2JgmTzCym1iW5Sub5dZNZI08gfRGnCnula/Mxrs3Oq+
         RakitZ+QKyzhLp7ZnbWVL503lKcN1YM4/wlVvXLUe5Nrp8nTAIVAhXkwe32CdMS6gHkg
         sUzg==
X-Forwarded-Encrypted: i=1; AFNElJ9QhfT4ow2eB7xjXQfdMD1A5NlyR4clx2PPWPf/FIiQWAQB6hSlDGFAo3d5VgTYSazxA8KxRnDpcPlc5A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzblCyiQNTxtpPvuXxkcHUZELCKvNy7gHYR+zQs6C8A+HlXOec0
	F8hv4usoL8cyng436nquIkrGuRy4cNC4qI0EC3rYGus6GsOljIJVbgm+DoyrzN7m+FE=
X-Gm-Gg: Acq92OG86fsSFZ8ijSUah49nMJRYnFq85Xy6g6KYIhkGOhSiyAnzuaIYoLr0VgwySAY
	SL1KBx5T96OpI1FL+jLkNcCPpX9IQzh2X3gdO7WGktecRNH7titdGYjD2m31UwlsTfsl56otGWF
	m9FsDUftfQOnjlTV0HGrlYdrH5rEy7zX2qMxcBNXNbZDVGxMpzF57xjkVqKvU8J4ZlSx5EAHq17
	qd5um6ykvp5y5p/Xnq2auQn7UHBIZmVIL41S3G6U8Nb82yAFNOQjsYzHQ9EfspdXgahx6d9clR7
	q0G4OTUYrl0jyPysWC6sLeAlEoqcXZrm0K1+UFVFUjDTQZGgIAo25Htq6R5ZpMz20Z77NiVlib/
	Gndo6LUoEK+isn3wyWMyV4UW8IJBC6/p4BGptVM+Ww6WB+/ozrW43zVksoQapRfVrXc1/lWT+l8
	FJieedkZhImnlzNQKDvmmFTdC/5x+HA5W22VrwJnPFbrdvBsKUH1/Rf+I1ipKxNGs1IfGUyW2E0
	FgmI1YAG+ucNa1CkoKWHNOH2lYmv7x62BD7GeBsHUrAayvQSaw2yYoqccAoqRkML9Gy6aDW
X-Received: by 2002:a05:6808:1921:b0:482:7a59:47a with SMTP id 5614622812f47-485fbd772b7mr6539898b6e.46.1780332465061;
        Mon, 01 Jun 2026 09:47:45 -0700 (PDT)
Received: from [10.0.0.3] (162-197-212-70.lightspeed.sntcca.sbcglobal.net. [162.197.212.70])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43c93a2296bsm8049707fac.4.2026.06.01.09.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 09:47:44 -0700 (PDT)
Message-ID: <9e7569ab278fc8538f0e44b552856e52f9eab37c.camel@dubeyko.com>
Subject: Re: [PATCH v3] nilfs2: reject CLEAN_SEGMENTS ioctl with
 out-of-range segment numbers
From: slava@dubeyko.com
To: Deepanshu Kartikey <kartikey406@gmail.com>, Viacheslav Dubeyko
	 <vdubeyko@redhat.com>
Cc: konishi.ryusuke@gmail.com, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com,
 stable@vger.kernel.org
Date: Mon, 01 Jun 2026 09:47:43 -0700
In-Reply-To: <CADhLXY66nCRtQk-gzHcZGm596sB2BAVKM1Ehue0ELj=OjuC-=Q@mail.gmail.com>
References: <20260430040704.113622-1-kartikey406@gmail.com>
	 <eea194aa0f8734f38fa645db935aca47175bdf17.camel@redhat.com>
	 <CADhLXY66nCRtQk-gzHcZGm596sB2BAVKM1Ehue0ELj=OjuC-=Q@mail.gmail.com>
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

On Sun, 2026-05-31 at 07:14 +0530, Deepanshu Kartikey wrote:
> On Thu, Apr 30, 2026 at 11:41=E2=80=AFPM Viacheslav Dubeyko
> <vdubeyko@redhat.com> wrote:
> >=20
> > Usually, I prefer to keep the err variable at the end of
> > declarations. Because,
> > it is the ending state of the function. And I am feeling that
> > something is wrong
> > every time when likewise variable is hidden inside of declaration
> > list. :) There
> > is nothing critical in my remark. But anyway... :)
> >=20
> > The path looks good to me.
> >=20
> > Thanks,
> > Slava.
> >=20
>=20
> Hi Viacheslav,
>=20
> Gentle Reminder. I want to know the status of the patch.
> Let me know if anything is required from my side.
>=20

This patch in the for-next branch several weeks already. I will send it
to upstream for 7.2-rc1 merge cycle.

Thanks,
Slava.
