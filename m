Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DC83264CB
	for <linux-nilfs@vger.kernel.org>; Sat, 19 Sep 2026 00:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789778837; cv=pass; b=BlLSN6zKj0htdC70w3zS//ZTF3w6Xjoz/rjSRk2goeeqkSE03cE6IFMMJCfUCs3eaprnRdJ0Vu3eyUn9UyN6tSGS7JSAVM8jxhLln7lAwwhQLLxrckxxNIqEISOSBpw8itd9BvBXzfbdQbW4MdlsJkOq+A9GxttMMpmDov2EDj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789778837; c=relaxed/simple;
	bh=ULS1O9H2vl1xXhjc8PA6+XCr3+Fn6BHRdst9HWjSmQs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DZ5cvoNCGRsOb7MyilpV8PXbKjWcapC3Q1GAAaQWoXbXbySedb3fC3jtuRy+dqdFTKwiO2xVgr3aZGWiUPQ84slfsVdLdcUSzNul6tbzvaNzC1mvS42IdJXzV+xbzOAOCkGV/z9fv9srRsKqrA/gMHWJvQ43vavDONnWFlThJFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kpn0g1O9; arc=pass smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kpn0g1O9"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b8997bc6e6so885329e87.1
        for <linux-nilfs@vger.kernel.org>; Fri, 18 Sep 2026 17:47:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789778824; cv=none;
        d=google.com; s=arc-20260327;
        b=agHepyV+PLK21Zg/6JhMhf+aE+9ntbT5lLcDqNRPEX9ghyi1LWDGBDEF6KzhC1VLJc
         P/fmbVnA2nLqs0pK5hG0pCFsCut0Z/hJmwrx2zj0AEBVSMtW/CkejZ6/qWg0ar42bGta
         U/o4C1a3TiVSbVesp2MbZG8LQ35PGSh9eu8uh0ryujnkrHwFMYCRZtQa9JxDYVKFrxTA
         /Her/RlgNkBAk6GNk0N+Xo928xS/Oc4Zg+q3r+VyeK/Y4KxnFEeLcbZwWQyuosRdj5OS
         0ZNKaI5WXlFmibF83R1jRLAfCI1KltrOd4bZdWkvGFdMJCMoD2Cg4PH3HCpH7AQdR6Mf
         FsYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ULS1O9H2vl1xXhjc8PA6+XCr3+Fn6BHRdst9HWjSmQs=;
        fh=ON/i+DxuhERVoliaiHkGanr17ymcvrKVcySJpcsf8c4=;
        b=NEgK7+GMAWHNN/yhuMOEYYfxtw4oeY/tNsoMF/1ZCX4rWZG2u3lcVGDnUix/GRD/O9
         6y1jldRyGK3wGPDT+myBBE+tE6QmilMecTy4StbbnLfwNF2Q0a//STxaOJKCI/38wRn3
         2CwgzeoK7HxRjYdvSdCWxXHBy4lw649LM7kEGF0l1ZMhlCtKQiQL6i4rnMhHjWwF/O1x
         lBGvLHFUKdo5KvfcCWFWpO76FKqo3EyXB93ev1IJVbxna8PQwKlRxWOiRh2SSlDaggss
         IOP9r6pjLDKzofyuj2BXM8nyu36tiUFlhhhYas5o7Jvvbqc9X+qax7oy4FQCW5KxpelQ
         WOUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789778824; x=1790383624; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ULS1O9H2vl1xXhjc8PA6+XCr3+Fn6BHRdst9HWjSmQs=;
        b=Kpn0g1O9/UWfCTZBkJUmCb365BAxASdEW72zhbBFwtvvJ/oydoACBLO0Dt6FNC0S0c
         4O1FhJIO66yaoCNjPx1lwDg2bmK6nMX1BAs8HjlTSsuGdUu9cxke5NogT72PLBUVENK4
         ts4bMqbRZLbYWA1WS0bv/oFvzAPtBAmWhAe9mEE2f7Qd8DvnkLfNEfeCsV6Z9TuZ48B0
         8ZRBMcU2B8YHtb59Qq8qzG9AewLT2kdCw+3Ck9XOlpIPRU6M2xihUnHQher5pnSosdzZ
         bZ9ahl1YjKSgRRO0bvRbZ+JPW3zXWZjAJPcHh9z5Jr0UpiIV1agd4K0f+QCdLMo/+FzE
         zXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789778824; x=1790383624;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ULS1O9H2vl1xXhjc8PA6+XCr3+Fn6BHRdst9HWjSmQs=;
        b=ks6Ser5v9xECppbWkmrsCJeyAGDmQPk+0e452FU+9eROF9VU8iT+pXgyTDgah2jnaP
         jSbxGwKk0qDfUH3cS29zmkO+PUsR4XM0s40sfA5+Co6bGdu9Qvb02Iki6lWt3z+ipJ3m
         XyhBx+fmbXLuTbVEOcZknaJF5fX+dUBWXWKUVYerkYDmjB1ywkIBAzHarTcAAEexLTbh
         2AgwZlQ0iw9T7IMeOnfCfDQZ7WAouw7H+dqgn7RlDQKQopLI3QWmNTBbPS7om/rwRyx/
         5Tnov4VuiNsjyf3FEJbRdVS+G+ejgcLIz+1+Gxc+FLTMqzD5HAWqd5aLMJrPkSyoU9Q6
         Kitw==
X-Forwarded-Encrypted: i=1; AKwUvBy7lk3b0Kq2vmRvaCR5hS14tQBVewPfuR1yF32gH7AnyeRbqqL54QgzAY73VpWV8aE5lDjxZsRz3rHspQ==@vger.kernel.org
X-Gm-Message-State: AFuF++m372KWrjyh3sREI52yXhpu70vceQJXb5iaJ2qqlb0PTW/znmdP
	4wFGq7VaBuGWobHg6McN6bZ9zoA4MQ82Fw9N97xvoBI8wJcjLpZmpJyPYXSucvgDxufuvjETFvv
	3LX5Zdpp2rsPxk3OGYmM76AqENHRz4xc=
X-Gm-Gg: AYBFou3jcHPngyIxvKHrnPHfJNXFigBitDg0khkFL5eT7HOrpJeBWXrnUwAZ5oDH8xw
	99gK9/M05eacler4fs6lQczFfdc+jEMiPdfP/exknYmqx+43hIzGCvrmNWN/sCwSqnJUJltDPUP
	B+5GBs5aa+hc8D8B0KsfZwPcOfZir8fEAU7X2ZlSXDiEKu+Xn0j/uTZds3iRPESLaoaYaU5+DFQ
	aDzrC+GYi/0zfprSSGUePI+x1aA2rvpUsaf38k66j0eCcutSnp92DPqzM4iX2v0JX8FmS/twDNL
	LzZ4welcsG5I6Fu6rFdqpVgjNApvU9empe+2vvABLg2zAUvgFG6CWjvV
X-Received: by 2002:a05:6512:219:b0:5b5:e2c0:510b with SMTP id
 2adb3069b0e04-5b8ba5d1c46mr1750846e87.4.1789778823638; Fri, 18 Sep 2026
 17:47:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915111351.2726334-1-qwe.aldo@gmail.com> <CAKFNMo=0hDANOd+DxxvKA=RNbiG-zygkWh6EUC6Vr2MYe4npLQ@mail.gmail.com>
 <e197037b70377be78b296380bcb31b8c3e8f8d74.camel@dubeyko.com>
In-Reply-To: <e197037b70377be78b296380bcb31b8c3e8f8d74.camel@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 19 Sep 2026 09:46:47 +0900
X-Gm-Features: AcwNN1XvQ7oA7wJs8qNTVXqjcIufwo1diKErI4eQMLUq2UxbIuNp6roz-nIE5Rg
Message-ID: <CAKFNMo=0-rxN0BKG1v+KhrGwnh2ZL_Hn2Jbcqc9sWRV8cwxPrQ@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: validate file block counts during recovery
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 19, 2026 at 4:33=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Sat, 2026-09-19 at 00:44 +0900, Ryusuke Konishi wrote:
> > Also, please replace the 'Cc: stable' tag with the following tag, as
> > with the previous patch:
> >
> > Cc: stable+noautosel@kernel.org # Non-fatal bug fix; defer backport
> > until a real issue is reported
>
> Damn! I missed this request. I already pushed the commit. Are you OK
> with that? :)

Viacheslav,

Since we haven't hit the merge window yet, and linux-next (the
destination where your for-next branch is integrated) is a daily
integration tree intended to be rebased before being pulled into
Linus's tree, updating the commit message on your branch now should be
completely fine.

As documented in Documentation/maintainer/rebasing-and-merging.rst:
"Some trees (linux-next being a significant example) are frequently
rebased by their nature..."

I think it would be better to fix the tag and overwrite-push it now
rather than leaving it as is, though of course it will need to be
frozen once we hit the merge window (or after the official release).

Thanks,
Ryusuke Konishi
