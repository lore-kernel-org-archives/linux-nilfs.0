Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAED7263B
	for <linux-nilfs@vger.kernel.org>; Sun, 31 May 2026 01:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780191901; cv=pass; b=SPgJr62k1x1a9ZMVlqCz6wppZsxQ/GWNuxg4YdyEVJlxXI3MWTqdBMKeoNTiZStAZXI7xjg/ARG8WQD2XRdwJTyqx7BFdWCBeDrnCm8GfML1waAdCOOBmihwuc5rmRR8T8PGxaXrJghJB/n7q788aBw4IponuTVPFSnBAHpXcwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780191901; c=relaxed/simple;
	bh=VwqbU5ro897QX71KGfNrhRfC/Ah5/wdZUHUGHxN8mQk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lvX0UM7fvjZgsFsdEs6CCz+9XSxMWCNoU6edzqDIk2zJuJWKqawL9Wy87l7VVipFewiFKLF5udkr/mzlm9zMzK5II8xpX7jyr/VVumAaB6TYHE4t2crisKeU2h3eJajTGP5G4iS1aiKAvCm32aQZSvllDDY7/oC1DLG4nHlmkhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bGdk28lo; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bGdk28lo"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6603246b66dso3529210d50.1
        for <linux-nilfs@vger.kernel.org>; Sat, 30 May 2026 18:45:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780191900; cv=none;
        d=google.com; s=arc-20240605;
        b=Y3/c58dzs3sn1zn3ZHwePm9kWx0OdOAbzezSDqa/66niaw7ReSEYmXEt34oG3zaYas
         3PlKLtcxUv43CPMfoeqMT+4WlOhQ+p4n40UpzH7PFN7erg7r0hTB7oHqF9BlYzkg1tnx
         Ji64CTbOIr0tKjgATWOVpcGthxX6vlUxYvOmrlUKxWTyKsszDOjKklVRTVq8BTrbwUMn
         Z34StF3ulp3kDCDh1e+Kmk4UawWp16Eb3Gbj0N5Q8iTlxfIsoCXprSFOWuA2gwxQW0cB
         LIQjqbZJHoa+IVY5CdMkbH9W6dw8lFU7JAWIYij/KLt2kvqHOs9Mb9uF9b7SIwrNSNox
         hszQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VwqbU5ro897QX71KGfNrhRfC/Ah5/wdZUHUGHxN8mQk=;
        fh=Yyxc5vOcmj6ibDVeI+jIaRZU99MVDAvNXdMFpwHLjxY=;
        b=Y0FkcJSxs+RIOHhKQ7NjtUWb0MvxRZvRfk5xPPVAO9kaGnvBVfo5fR5gqIUyt80uQ4
         rZExhjYYnpkIw2La5RvxG6+RqKml01FX1gXcTj5lrUdwml5lSZQXgG8HWFG+9inQfeDb
         wW6B1rUsHu1GmEUKrWYZ6Ifh7jp5K4edpSy6TF3aK9ZMLABL3HaHAsSI4emxE7Wvv96v
         hRWK0XutKi17NONRaHWhkdnKhjRHIZ2oFfN2dKAAjz7Jnn7rNl4BzLuNIKb1mPjli2WR
         mvxjaDw6z+2ERmhbBuw36mW8PjW3Hcqpb6USLQmKLGj1AGBwhdx5aGLToiXJx19QGZO7
         SBDA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780191900; x=1780796700; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VwqbU5ro897QX71KGfNrhRfC/Ah5/wdZUHUGHxN8mQk=;
        b=bGdk28lozACXNPKfBywsZ3mG6s4zBF2PgTH9KaAAhWQpAPSYGWFrFSa4Wfq4oq7mXD
         P+NV0gftMhyf+PbSOitcvS4y2Ab9C7kuGJCZ//4ISxAqp/bsugwq6OyENWPn/XxP2RbW
         81y3xLQgLMmBsYOduwi/CN52nHOU4D7DK1ITQqUFQzKCvv6EhwFkDdXXF+dN4Ta9Hc/0
         4us8/1BJWkhQ48lI5giAlszQAeSz+zwLc8T98VLTAXABILzqfRMq/JW+MlsJuD9xT+ul
         R2JXQUu2o8Q0ps2sQ2jUBAMET21+7zT7Mda3sryP9zrAb8DhnbaNS05MYPteIlGGqG4Y
         PK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780191900; x=1780796700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VwqbU5ro897QX71KGfNrhRfC/Ah5/wdZUHUGHxN8mQk=;
        b=GAyTRYtIMvxAHO3h0PRNfxyBI1ae+NIsNgUaE1uXlPuL9KpBMd8hpQJf7m8jpaukQB
         W1nI3t6rjcdiqOHKN7HxwZI6hoDeWq93eKw40AeoXj5lvON/CNXYgRbfTbBdhfW7K9X9
         oBwrsD2WDw+Ik/K2DlAQ09wbkRa1dHeO2AMxwKpDyVKPSDTOdXHr4IU5xVXCiw/52LaC
         1tOP37cDHK6jigK270UNoMMwSCLl29d17ulynD09WRyUDsH6MKQRJqGodoW+h/PcMbJG
         DjqqFAaQF6I0CXCX/32ngNzeHwiYIVZn1svL4W0pWrfZIig+VVlGLzJ9peqfaxWWNhTq
         8jaA==
X-Forwarded-Encrypted: i=1; AFNElJ+H/hq7K8kSGAbLpQmeCCS2+PfZx5L865SDESvFk/NjsX5ehf6i+04TCNTN9/44NKT2DMg85EzyAjylFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywsu30Ckky2ORqNjwcO2WdI1js0mq0RB6PUElMNjSMZoaYHQycx
	3rJE+kSamFrOcsIzJq92po2oo6WTUxsmC1yzZ+nUz2YMB51KmXMnvvFAvuvVSpiamIPLZ2GCWOI
	1EboMRtrLtnKr92QEozyU7metC0RUeBQ=
X-Gm-Gg: Acq92OEw0bn1Ds81TJKqtCfHsheD7cluKEea695YdluJ7nCFInN7OxBMuQub6M9d9rE
	zvyBqaUf9wxybPQ2d80lTehav2F14hQoqyn8K9N7fH8tLNcliP8bR/pJi3AvcXs6w2GNNByeA1G
	DLGp6sCCW2sQ59txPZBfLMZV4LE7O6Slee4QhdnXM+4JUpc+A9YKxU4SLHHWWT8o/6lWAVkUFpw
	SnuYjiaX+7CXjq2nRyB1mkL2msQoleicGkJ5mPXdsyOOeew55m+YuI+52NecCXnPBPs6w/6tb0q
	ruQDmsvAEZnHwA1jdNZ4xKygQt1udElCP7+xct8X7AT8NOMvndiF2VEWuU0HsNTSUgJpM6zeAZr
	N1waSeQ==
X-Received: by 2002:a05:690e:43d7:b0:660:460e:254b with SMTP id
 956f58d0204a3-6605f068571mr3687927d50.38.1780191899729; Sat, 30 May 2026
 18:44:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430040704.113622-1-kartikey406@gmail.com> <eea194aa0f8734f38fa645db935aca47175bdf17.camel@redhat.com>
In-Reply-To: <eea194aa0f8734f38fa645db935aca47175bdf17.camel@redhat.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 31 May 2026 07:14:48 +0530
X-Gm-Features: AVHnY4IoW1fZ_suyNHPqLDrDuECtYKSHSM3mNf25rwJnNEPZzvMHT3qfHLCFemI
Message-ID: <CADhLXY66nCRtQk-gzHcZGm596sB2BAVKM1Ehue0ELj=OjuC-=Q@mail.gmail.com>
Subject: Re: [PATCH v3] nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range
 segment numbers
To: Viacheslav Dubeyko <vdubeyko@redhat.com>
Cc: konishi.ryusuke@gmail.com, slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 11:41=E2=80=AFPM Viacheslav Dubeyko <vdubeyko@redha=
t.com> wrote:
>
> Usually, I prefer to keep the err variable at the end of declarations. Be=
cause,
> it is the ending state of the function. And I am feeling that something i=
s wrong
> every time when likewise variable is hidden inside of declaration list. :=
) There
> is nothing critical in my remark. But anyway... :)
>
> The path looks good to me.
>
> Thanks,
> Slava.
>

Hi Viacheslav,

Gentle Reminder. I want to know the status of the patch.
Let me know if anything is required from my side.

Thanks

Deepanshu
