Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFC33AAF60
	for <linux-nilfs@vger.kernel.org>; Thu,  8 Oct 2026 16:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791477681; cv=none; b=aK3A1uEQnOccUm+OmklEN+ud9/xGeQ2/WqqtiA808qMFGT1EUJwsfS1ww9sXUiqviXyhpHUsCDyHPj/YTAUUe7yY4PQD6pYFpuNrOS1AJHw7m06u9RdoS4f1xdfAOySF0iAtg/EhVfNM+cgKt74ZqD3HnJ09kpVwZx4txVQR3R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791477681; c=relaxed/simple;
	bh=cwGj3w9GBfrKN+7Z6mna8pb2lw0p0OKqenVTtrTPniE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q5vvHC9tyFqADr1pGLQ6p0fLNmj6Sx/nc+d1ooKf2iU2hP+tCYcK+XXN9IHzMZzKXQXAn+nLbKE3wnVtZycaydODV9fT1Fwmxo5Vb0MKbJacWv6BajhCDjKr553DOEaAo4fLwzXiP7hEBexoyXIUtgiq2/vOTmPVQ8fGZev5qIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=fwwVb2XF; arc=none smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="fwwVb2XF"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-67921b515a7so1062687d50.2
        for <linux-nilfs@vger.kernel.org>; Thu, 08 Oct 2026 09:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1791477678; x=1792082478; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cwGj3w9GBfrKN+7Z6mna8pb2lw0p0OKqenVTtrTPniE=;
        b=fwwVb2XFjtGqkFnJ2HdXhojFVY6jb5o8kjB1WntrhaP4hfV8zuWgc9ESLxp4P3BS40
         3G237hhDgkfENIxtoiY7CdHNTFx4MDoEOnEkXJfctspe0lndPLPUQWDed9368rHu6GFS
         yI/BlHWGbeKKghBtAk3aW0J/b+xx+XaCvfqypRhA7Jh1pE8+ZzYuxOPQKAJ+1NGEMBBQ
         xNIABRx3Ke6lbpdaL5w3wlivDzatV1yWeYqtTivSfrDqFAZ7UPLVZ/FVYlnw9s2MFI4W
         B4op3zgiVrKxJsbWAcTXJ5WUT0HN+w30Eacc7YvNIhBD/kVk4/kzcGrcww59NkU2fUFe
         WStw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791477678; x=1792082478;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cwGj3w9GBfrKN+7Z6mna8pb2lw0p0OKqenVTtrTPniE=;
        b=wWpHHSZB5P5Wrcpr6jJHE0WRlnl4rvFPq7L1ohaNTvhjT5gTqhYiSwV+FArfoZut8l
         FjsPLTcfmthELrpdifGPZ/mA/926ohZksk/QdHmmUSP00WHtKmLm18gmeaAy1WxAVden
         ZGiIAiM1cibO7y6o/VSoEStR/F4WwsHb9k9hNk3gnSQH8quxMQNRB+hFCqsBM68LL0En
         tbNbJllorFlSATl7HovYQnyTQ5oM5NTVtBZ40DtqHDfr/ghR0GpKyMggkJ+mPMh3H5Z2
         rG60PN5+cWssbzisupZiZUe2FZkM2XOMujg97XBbXyE06CHH0hFl7UW0zFOCZTqBoz5U
         uIHQ==
X-Gm-Message-State: AFq9FYIjcwkvx2vLNBUwhIUoZvFxI2aufg5ECXlNlU6rWBxrTnRuwFE3
	h28fRpZ4Zj7U57y7WVKdJSZKunXQZbt94UH19nesjDLsT6YTqy/h1gtjKDVaDbwXq8g=
X-Gm-Gg: AYBFou2UtSlaZpduL1yf2dhlh3hMP6/zACu3rcnLyhIN9WbOYUHdcxkocFYfHqd3RU5
	qaIBMurux4n2pSA0qD8vz5hxhXx0woycDm5QPrH66KgbD3rzB683qMcIXURoust/wTQEiMeSfEE
	hi5Aa83n12CVGzN/3CrsO5QrI3ab6/e/n3H8R7O3Xryd0Wuw6caowc9JRxTaZxfRGxDankCZHkv
	wg8PtiCDcFPh1iw+Mv1gzwoNqHsiqhN5FfnJjp8j/DHZoHtELZEdli6EgW7SWz0CtyrV+T4xOAg
	qAjbRe+C7w6rLIQbzK7aG9kTRzAgqjczyPu8PQTrkT47L2HjmFgOHdwI9qVhMEDXIxfUd3z4/dX
	xzVglIZaJBlJ5lVTlXIoB8xvQAJOXAksO/Ww0fSTdHolEviIneD71e5ACbk4caWx8OB1eRs7Kw8
	7yLG35eNSZZ9Zguwf+xD0KuLQQNktupnU4TYpmaF7+CMDJu0Y2wagOEPi65/f3r7VEwsneiRhoF
	FmmeB1LVWDTARMAcZW/xgaotDWu4d5NN7MZOwYiOk3dBmHg3g7spqtqTlbYmfHSsPnnSDjj4Q2r
	XNntfuJtPLECt1v9Dur6sFEpSlSodCnma0P2CNkDI5q5rJzmj07PHuKsniMcQ9PH
X-Received: by 2002:a05:690e:4506:20b0:676:8c58:c607 with SMTP id 956f58d0204a3-6790a2830eemr2371131d50.27.1791477678411;
        Thu, 08 Oct 2026 09:41:18 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:3f86:e8da:ef35:5cdb? ([2600:1700:6476:1430:3f86:e8da:ef35:5cdb])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6791ad6d3d2sm1422783d50.1.2026.10.08.09.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 09:41:17 -0700 (PDT)
Message-ID: <9f511baad8e209506f8c304c32f54036e4114d35.camel@dubeyko.com>
Subject: Re: [PATCH 0/2] nilfs2: robustness fixes from Jake Labelle
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, Jake Labelle
	 <southampton.jake.labelle@gmail.com>
Date: Thu, 08 Oct 2026 09:41:16 -0700
In-Reply-To: <20261008115312.18482-1-konishi.ryusuke@gmail.com>
References: <20261008115312.18482-1-konishi.ryusuke@gmail.com>
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

On Thu, 2026-10-08 at 20:52 +0900, Ryusuke Konishi wrote:
> Hi Viacheslav,
>=20
> Please add the following two commits from Jake Labelle to your queue
> for the next cycle.
>=20
> As this cycle is getting closer to its end, I am sending these ahead
> with
> a minor fix applied.=C2=A0 If Jake responds with further comments or
> revised
> proposals later, we can discuss them as needed.
>=20
> These patches address two robustness issues:
>=20
> - Patch 1/2 rejects special inodes during dsync recovery to prevent
> =C2=A0 dereferencing uninitialized bmap function pointers.
> - Patch 2/2 validates and snaps the directory position after llseek
> in
> =C2=A0 nilfs_readdir() to prevent invalid or out-of-bounds page reads.
>=20
> For full context and background details, please refer to the original
> cover letter here:
>=20
> https://lore.kernel.org/all/20260930000954.371774-1-southampton.jake.labe=
lle@gmail.com
>=20
> Thanks,
> Ryusuke Konishi
>=20
> Jake Labelle (2):
> =C2=A0 nilfs2: reject non-regular inodes in dsync recovery
> =C2=A0 nilfs2: validate directory position after llseek in readdir
>=20
> =C2=A0fs/nilfs2/dir.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 34 ++++++++++++++++=
++++++++++++++++++
> =C2=A0fs/nilfs2/recovery.c | 17 +++++++++++++++++
> =C2=A02 files changed, 51 insertions(+)

Applied.

Thanks,
Slava.
