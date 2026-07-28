Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26913C3F75
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 23:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785280750; cv=none; b=fn9V5eAWB2NDH2GLqnmRS7IIE0PC87vfiaiwvTOaEI8Vuu4GZJ/WgzJGdg37maydso5YWgFLEtLTXk60WYXQpUn6VfULjQYRVXOpmu+Y8De9fk5LzsNBjpBYYIN1yyuYhw3O5h3P133Pb6KtB3t52HJ5LKlKSGXciHpfUFG2BTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785280750; c=relaxed/simple;
	bh=IqzBT5md9d1L4b26Zj635oQbSo4fx+LTqdVqRSRXkmg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r1n83aP7o+FnL7F8QyzFE6KKW0NsSxFLEpBfTFrk6A7AtfgM4VKwMQiqn/Q5ZBDm04JpWMQFSMhGzK1OQxBzWeKcAE8gr6w/nLPSiT/1ioI1TfV2rpUN0aE4jOwKHH2J6z8+qiGDDAxAkAQvuoSEnpMf/0gvyVV78t+pH1ALnkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=rrgI/OVj; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="rrgI/OVj"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-81f3b227a4aso7006917b3.1
        for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 16:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1785280748; x=1785885548; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IqzBT5md9d1L4b26Zj635oQbSo4fx+LTqdVqRSRXkmg=;
        b=rrgI/OVjHJHQppZlJRg5wcP5Dx0GCtHtQjvsdp843PVfOlOaj5GWbubwXqvD8mj0PZ
         dr2s6acJJnIL1kYCS5tyvWDP5f0YCOexsnFObM1hYvw5F9qZ7idWmuBm+6Aq4gbyhBO0
         mp1mBZ0Xs2ECWBWPr1eHJiR9Y2oVmcpB8dH6/hA60yGdOYRfEsIBlQ5t2iLDqum5NRPK
         RSQRfUs3thlu4LAg89ffnBittKruOu2t/CNHRdH25ki+kT6Doz7iQvDjSI3ufO8eYFE8
         CBFl+9VFkrOwuSb8ntiovBsHO+aJDh3FE32ex4GinclrRSVyb4O/TIJZ3GuTbiGGbien
         4KMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785280748; x=1785885548;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IqzBT5md9d1L4b26Zj635oQbSo4fx+LTqdVqRSRXkmg=;
        b=VNB05RZk0lIOUtxZ4OPQOCO6UJcOFcisOaeVm+4uUdDfZbJfq8sIWNqzYRpo3dkM1F
         3hqE1syoIA17sXnD1vk9UHITwce5eEqIfSWoxs/PQfYvH2YKUh+mhN/tzQ53Ph2RgwAC
         oc82jaSjW2TFtPRT1A8alQUGaTf+/8P6p6QbfIfe9dabvSdnwZvkm2UOhLLGPEQiq3rX
         GNrac0/sXqTm+CKTghjExcdkrT7sz3T2/FdLPPqL2m2DD4ggad8LKkR14A1bFKgfG5Ba
         fkwKWLD963rB4Emc9rcXkevPGGKpvNnoEchBXCs1oWyAuRtun43Opk8uVuxplngjV1h6
         YwOg==
X-Forwarded-Encrypted: i=1; AHgh+RpbEkMVGNDx9REs+Vkr5Lbtms3hjekZz93ZCD/LnFqR/OHYqP1Ui0q9TItP1tRiBJVwS/qZODnTG4L6+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsNmVPzFCrvkZiApGKslGTB57d2FNeg6Q6ERBGvVw7wS+Y0M7b
	nXgFZLnGCvy18Pj4bK8rxZXJM06ty2RPpgF8ilGgmOqZx3yebVFTkWSIdz/mdGvxpm2K2uqvG+u
	Tsf/iGxvX+jBx
X-Gm-Gg: AR+sD10aPtVKUO2uu2PGpe+Y15xo/szZRhy+NtVMhguYSpfStbI+11yq5pPuFBIWlE5
	g7DtidVl1pQtyPJS5YKOBRs2J0AFE0hB/ijJmvaOTwW0lBKnURdT7WamLuMjD+a7axR3TDCWGMZ
	apBL260hHMfPSR2IEVYNbWQ4xmHe2G+V9blyZxEfdhmih7klZ2M2r1qOl3wORcy7jUuycitLvux
	K5P7pOGbs5p74oQ1oH345mdCsvPbyEoYdKGljRBAKua1tQKmNcp65ynuSe+cko94lXGK5UIG+1g
	5TD2Wt0LnYxVV7+sRaWoDO6/8boufuCQWfrbQWOZNzVFIoMkhTZzYFnvgmu5wIZbBzCoezR/ppn
	1qngLLhr0/jNISNz5iFNtHUGhV7qn5UdeKTY0BVAiWXBwHmyRIXZqA+Ju+tep8OMJ/G9DwlORfg
	gQFuWnBYD7c/HviPRnj9cwOUDThicPEyiVqH8ZN7POpGRFnkrLzb8MrGI54nCyHZsVqizUTJL/U
	ouTRspkSFnRakloD/IhntK1zSBJEwvyITGjaNzX58fp6bu1ERGfkUuQr87DtCxQuTfys9b+om7l
	0cIopSOjagF42DW6wDG8QjEWPfZvOdFeT0LMKI4/JPGp+xgWyg4dd2o=
X-Received: by 2002:a05:690c:7109:b0:81f:64cf:2c58 with SMTP id 00721157ae682-81f991e4f40mr21075417b3.6.1785280747667;
        Tue, 28 Jul 2026 16:19:07 -0700 (PDT)
Received: from [10.0.0.3] (162-197-212-70.lightspeed.sntcca.sbcglobal.net. [162.197.212.70])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fa29a5f53sm7474267b3.44.2026.07.28.16.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:19:07 -0700 (PDT)
Message-ID: <ec87fd45a7ec19dcddd0720a1634abd442a181d8.camel@dubeyko.com>
Subject: Re: [PATCH 0/2] nilfs2: convert O_DIRECT reads to iomap
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Christoph Hellwig <hch@lst.de>
Cc: konishi.ryusuke@gmail.com, linux-nilfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Date: Tue, 28 Jul 2026 16:19:05 -0700
In-Reply-To: <20260728035443.GB19245@lst.de>
References: <20260724222745.2107464-1-slava@dubeyko.com>
	 <20260728035443.GB19245@lst.de>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=mQINBGgaTLYBEADaJc/WqWTeunGetXyyGJ5Za7b23M/ozuDCWCp+yWUa2GqQKH40dxRIR
 zshgOmAue7t9RQJU9lxZ4ZHWbi1Hzz85+0omefEdAKFmxTO6+CYV0g/sapU0wPJws3sC2Pbda9/eJ
 ZcvScAX2n/PlhpTnzJKf3JkHh3nM1ACO3jzSe2/muSQJvqMLG2D71ccekr1RyUh8V+OZdrPtfkDam
 V6GOT6IvyE+d+55fzmo20nJKecvbyvdikWwZvjjCENsG9qOf3TcCJ9DDYwjyYe1To8b+mQM9nHcxp
 jUsUuH074BhISFwt99/htZdSgp4csiGeXr8f9BEotRB6+kjMBHaiJ6B7BIlDmlffyR4f3oR/5hxgy
 dvIxMocqyc03xVyM6tA4ZrshKkwDgZIFEKkx37ec22ZJczNwGywKQW2TGXUTZVbdooiG4tXbRBLxe
 ga/NTZ52ZdEkSxAUGw/l0y0InTtdDIWvfUT+WXtQcEPRBE6HHhoeFehLzWL/o7w5Hog+0hXhNjqte
 fzKpI2fWmYzoIb6ueNmE/8sP9fWXo6Av9m8B5hRvF/hVWfEysr/2LSqN+xjt9NEbg8WNRMLy/Y0MS
 p5fgf9pmGF78waFiBvgZIQNuQnHrM+0BmYOhR0JKoHjt7r5wLyNiKFc8b7xXndyCDYfniO3ljbr0j
 tXWRGxx4to6FwARAQABtCZWaWFjaGVzbGF2IER1YmV5a28gPHNsYXZhQGR1YmV5a28uY29tPokCVw
 QTAQoAQQIbAQUJA8JnAAULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBFXDC2tnzsoLQtrbBDlc2cL
 fhEB1BQJoGl5PAhkBAAoJEDlc2cLfhEB17DsP/jy/Dx19MtxWOniPqpQf2s65enkDZuMIQ94jSg7B
 F2qTKIbNR9SmsczjyjC+/J7m7WZRmcqnwFYMOyNfh12aF2WhjT7p5xEAbvfGVYwUpUrg/lcacdT0D
 Yk61GGc5ZB89OAWHLr0FJjI54bd7kn7E/JRQF4dqNsxU8qcPXQ0wLHxTHUPZu/w5Zu/cO+lQ3H0Pj
 pSEGaTAh+tBYGSvQ4YPYBcV8+qjTxzeNwkw4ARza8EjTwWKP2jWAfA/ay4VobRfqNQ2zLoo84qDtN
 Uxe0zPE2wobIXELWkbuW/6hoQFPpMlJWz+mbvVms57NAA1HO8F5c1SLFaJ6dN0AQbxrHi45/cQXla
 9hSEOJjxcEnJG/ZmcomYHFneM9K1p1K6HcGajiY2BFWkVet9vuHygkLWXVYZ0lr1paLFR52S7T+cf
 6dkxOqu1ZiRegvFoyzBUzlLh/elgp3tWUfG2VmJD3lGpB3m5ZhwQ3rFpK8A7cKzgKjwPp61Me0o9z
 HX53THoG+QG+o0nnIKK7M8+coToTSyznYoq9C3eKeM/J97x9+h9tbizaeUQvWzQOgG8myUJ5u5Dr4
 6tv9KXrOJy0iy/dcyreMYV5lwODaFfOeA4Lbnn5vRn9OjuMg1PFhCi3yMI4lA4umXFw0V2/OI5rgW
 BQELhfvW6mxkihkl6KLZX8m1zcHitCpWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29Aa
 WJtLmNvbT6JAlQEEwEKAD4WIQRVwwtrZ87KC0La2wQ5XNnC34RAdQUCaBpd7AIbAQUJA8JnAAULCQ
 gHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRA5XNnC34RAdYjFEACiWBEybMt1xjRbEgaZ3UP5i2bSway
 DwYDvgWW5EbRP7JcqOcZ2vkJwrK3gsqC3FKpjOPh7ecE0I4vrabH1Qobe2N8B2Y396z24mGnkTBbb
 16Uz3PC93nFN1BA0wuOjlr1/oOTy5gBY563vybhnXPfSEUcXRd28jI7z8tRyzXh2tL8ZLdv1u4vQ8
 E0O7lVJ55p9yGxbwgb5vXU4T2irqRKLxRvU80rZIXoEM7zLf5r7RaRxgwjTKdu6rYMUOfoyEQQZTD
 4Xg9YE/X8pZzcbYFs4IlscyK6cXU0pjwr2ssjearOLLDJ7ygvfOiOuCZL+6zHRunLwq2JH/RmwuLV
 mWWSbgosZD6c5+wu6DxV15y7zZaR3NFPOR5ErpCFUorKzBO1nA4dwOAbNym9OGkhRgLAyxwpea0V0
 ZlStfp0kfVaSZYo7PXd8Bbtyjali0niBjPpEVZdgtVUpBlPr97jBYZ+L5GF3hd6WJFbEYgj+5Af7C
 UjbX9DHweGQ/tdXWRnJHRzorxzjOS3003ddRnPtQDDN3Z/XzdAZwQAs0RqqXrTeeJrLppFUbAP+HZ
 TyOLVJcAAlVQROoq8PbM3ZKIaOygjj6Yw0emJi1D9OsN2UKjoe4W185vamFWX4Ba41jmCPrYJWAWH
 fAMjjkInIPg7RLGs8FiwxfcpkILP0YbVWHiNAabQoVmlhY2hlc2xhdiBEdWJleWtvIDx2ZHViZXlr
 b0BrZXJuZWwub3JnPokCVAQTAQoAPhYhBFXDC2tnzsoLQtrbBDlc2cLfhEB1BQJoVemuAhsBBQkDw
 mcABQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEDlc2cLfhEB1GRwP/1scX5HO9Sk7dRicLD/fxo
 ipwEs+UbeA0/TM8OQfdRI4C/tFBYbQCR7lD05dfq8VsYLEyrgeLqP/iRhabLky8LTaEdwoAqPDc/O
 9HRffx/faJZqkKc1dZryjqS6b8NExhKOVWmDqN357+Cl/H4hT9wnvjCj1YEqXIxSd/2Pc8+yw/KRC
 AP7jtRzXHcc/49Lpz/NU5irScusxy2GLKa5o/13jFK3F1fWX1wsOJF8NlTx3rLtBy4GWHITwkBmu8
 zI4qcJGp7eudI0l4xmIKKQWanEhVdzBm5UnfyLIa7gQ2T48UbxJlWnMhLxMPrxgtC4Kos1G3zovEy
 Ep+fJN7D1pwN9aR36jVKvRsX7V4leIDWGzCdfw1FGWkMUfrRwgIl6i3wgqcCP6r9YSWVQYXdmwdMu
 1RFLC44iF9340S0hw9+30yGP8TWwd1mm8V/+zsdDAFAoAwisi5QLLkQnEsJSgLzJ9daAsE8KjMthv
 hUWHdpiUSjyCpigT+KPl9YunZhyrC1jZXERCDPCQVYgaPt+Xbhdjcem/ykv8UVIDAGVXjuk4OW8la
 nf8SP+uxkTTDKcPHOa5rYRaeNj7T/NClRSd4z6aV3F6pKEJnEGvv/DFMXtSHlbylhyiGKN2Amd0b4
 9jg+DW85oNN7q2UYzYuPwkHsFFq5iyF1QggiwYYTpoVXsw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-07-28 at 05:54 +0200, Christoph Hellwig wrote:
> On Fri, Jul 24, 2026 at 03:27:43PM -0700, Viacheslav Dubeyko wrote:
> > This series removes NILFS2 using of blockdev_direct_IO() by
> > converting the O_DIRECT read path to iomap.
>=20
> I think the important part here is that right now there are no
> direct I/O writes in nilfs2, not that you only convert the read
> path?
>=20
> > NILFS2 is
> > a log-structured, copy-on-write filesystem, which makes it
> > a poor fit for a full iomap conversion. Newly allocated blocks
> > are delay-allocated by nilfs_get_block() and only receive a real
> > disk address when the segment constructor writes them out
> > as part of a log.
>=20
> That's just how zoned xfs and btrfs work.=C2=A0 In fact they only know
> the disk address one the write returns, so even later.
>=20
> Take a look at the IOMAP_F_ANON_WRITE flag used by xfs.=C2=A0 btrfs
> implements
> a similar scheme, but hidden behind a few layers of cruft.
>=20
> > The segment constructor walks buffer_head lists
> > directly and is not integrated with the generic address_space
> > writeback path.
>=20
> This sounds like word-soup to me.

Are you suggesting to re-write the commit message?

Thanks,
Slava.
