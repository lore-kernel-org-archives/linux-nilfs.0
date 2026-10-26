Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793033999;
	b=v7CMZ06T1Nr1F8xZpksfU4giJtQ8W11q3UBGm5DtrTsy/23+jcYx4itAxiYU6RYwNFM3
	 L7epLITAbbam7ZSX9TJBpQ26FyRUTUP6lhDJzZGPT3MUkca7RA7Ih34P0qkPU5mhsa0bn
	 FOsvfMqVJvTsXHN2mk+Y6iEtLyywe64Kjc0meJDsUaSU/MA7YborFnp/tjKDANTnMzjOG
	 Czddv0fyLFwbtWGHPwxXFQSYpMoAdjr5LJuLJmZ62gyYS+GRBJbfkGWyYObrdSxa0x3ZG
	 4ANdIqUDbw+TKn9H0zaLIZorxQSmi1NGjhbyR/+bI0N0Iex5C56IVW2QMhaCPQnmjlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793033999;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Subject:
	 From:To:Cc:Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=SmKresnM181ABUUClYsztqkK6jIT00C1iyRhD1wPWZM=;
	b=k3epC/YSLs0imG3pmy3FNV5M42heUMElg4CS9Kov1ABQ12GMoqUlHEhNydq4U8c6Xuhd
	 4PfirF7uqeCXd9IlxplPCFNjvMEM8kBgy42OUWirmlMRsnwMx3ttkGALAwCII3fy2kMu/
	 9L+ml6pcj6pvaWYkiXBZZUv3jDMPBCh3a5yWsmbTOjnXxOeEwJQ5xf+THm414Ti9XqVGt
	 Y4ZkAzFvNJN0vHudGnF434OeAN2IySXfSjQkbAB0RCloDcRlGNXGUSl0HeiKmv5MrZIwE
	 vmoh1T9kCeTmOvqDFFoIVm1ysk4wvg4MFWce43sjyUmcqEEI0MPs2uZ0cKoTjV+ti+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b="RPBIVjJ/";
	arc=none smtp.remote-ip=209.85.128.181
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28453606A31D
	for <linux-nilfs@vger.kernel.org>; Mon, 26 Oct 2026 16:59:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28453606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=RPBIVjJ/
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8b0a28a720aso31135657b3.2
        for <linux-nilfs@vger.kernel.org>; Mon, 26 Oct 2026 09:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1793033997; x=1793638797; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SmKresnM181ABUUClYsztqkK6jIT00C1iyRhD1wPWZM=;
        b=RPBIVjJ/mfszH8jUZRAsvxN5N1lh3RGCU22mGjM8xzPVt89PBgLDaTqMnhP0SCjBmG
         G4PBQqrSAXuliSGoqBu1lTIdfeKs4ViafsBBGsKEx/dVbPWNiqReoWe5vXPnAJ7mkORW
         AqcZLzkcDFp6y4FyG0WdjNtehr+Cf7ra2wo9vUw1jfx9rm3+//geUXxkeKliGBEhGVon
         qIuYAdAd0YSDq/Jr3KSQwFF6eDw2j/FyYk4ZcbEzlftlmj8LMhkr6dYbBBAyYR+3JekR
         kOtbWL/IvEgrpssMMabZYlgv2l16BVOmxzed4eL30ofEuvX8T0LjayYIJuNQYZe7EVJa
         npbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793033997; x=1793638797;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SmKresnM181ABUUClYsztqkK6jIT00C1iyRhD1wPWZM=;
        b=MtCkl8OqdzTuzNFrLWmq8qQr07h1+L59dz3Dg36kM0VvsFULoes3wGh6vOrfSFUKNy
         6GQno3B9SJQJP0IXXxR/jDNtH7U+NYi8A2IVz/jPH5bpL8YjmV/9NP9HYSuNP5tTUssh
         qNf93ig/OYGV279g+GrAvEkwXkK55/eggIuSBESqXTUjAAh+uz+3qh9xyKGRbOAe/MPA
         MzXisqUhZFYM3u+cp20iRtYLTl+m6WhX6CCAro6ZUowFN/3mHYHYcd+QvhOdrIsyKYrU
         I/d5an/BsBL+wn/wFtWNYlBqrr8wAOTwD+1tK5XGCZjEmJrWRUxB/t8HgHMlw0dVXC8u
         dRMA==
X-Gm-Message-State: AFq9FYIW84prv0auJuHFBqpGj2pEG3KwOp+/yPJeZrPFyNJK0we1maqV
	aSlgK8TOUQjWKCuybEJMbqYs8ssXIjy5gZlkLtcBILuqXCPG5M9IjYYHGy5N6A7K0Tw=
X-Gm-Gg: AYBFou1ltqFmhpN/icqyTLa2/b26i+A6rOpxvjoepZIZcGn/AtRupGj0a5xWc3usgLJ
	Lr0VRVZzVeSKL/j3f4SIsFrZVIMp/nZSYE5AU6DomFQAMgJ4oED4DAKe8Q9oRzoG0Q1MJUSXklE
	Iv9KJhd08TV1eOjzgJDdyqT0HjsRNFSGk0P4/fMAzNDDkfzn4vqMn8UiWv9aJj0xPQnmuTGOI6D
	JmFyAbiHB+nH1XKUdrmCfdQ1ftCE1P8ebnYovMVlx1VD7CErb4t4slAgtN+SaPoxpepWNxRF8kE
	BsXBFlgcrwTogu9glWDdv+RK3Y8698cE696tBUsjKBQi3JZFXRDPm3tFx3iQE2qrz2h95k95TzA
	U3lmBBIwP0r0+suqXqgCZ1KKDhHmlmFahl+FPTDR2+S9FkASpHANxS7vGW+AeZU1PZvOLXy/mY8
	561eiLnZF+za7gNp+qxT3DQkwNDLUB56AiwlmnSKBHJ/dJ0f+lA/tHZs/kfL45lz/Mj/2uuI1uY
	lud4kVjGbxp80HGn3xBY8AyyI8n2vwpVxkdmHA6CWSDHCoHgQyh9RfKBNbI8OCFKwH5E9A7P3Jl
	G1oWe+x2DSTlcs0HlNuaLJW/6mRF1oJG4FcIuPZzHVZjhiUGtLjs8KRbW8iycmnE6HurCBFHMGS
	uOhxwC2P2j7Tu6X94BEHchxV6pg+EBmG0X0+6P/8Rn/oM56A=
X-Received: by 2002:a05:690c:34c6:b0:8ae:a9c6:2740 with SMTP id 00721157ae682-8b166c51804mr36321077b3.48.1793033996947;
        Mon, 26 Oct 2026 09:59:56 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:5187:d81d:3a9e:a63b? ([2600:1700:6476:1430:5187:d81d:3a9e:a63b])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b166eb116esm34522267b3.37.2026.10.26.09.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 09:59:56 -0700 (PDT)
Message-ID: <ef6de636ae209a86b7ea262831c8fdbb8258b866.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: add atime support
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: "wangjianjian (C)" <wangjianjian3@huawei.com>, Ryusuke Konishi
	 <konishi.ryusuke@gmail.com>, wangjianjian0@foxmail.com
Cc: linux-nilfs@vger.kernel.org
Date: Mon, 26 Oct 2026 09:59:55 -0700
In-Reply-To: <eefa16b7-506e-47e1-8ab9-b4f5738733ea@huawei.com>
References: <tencent_A1BD1C90A8E503B41B451E310527DC9E9F07@qq.com>
	 <CAKFNMokNhGtWE-uAmXBAXneuqwFZ9bP++jRexS+p3Xdbq8G+Zw@mail.gmail.com>
	 <eefa16b7-506e-47e1-8ab9-b4f5738733ea@huawei.com>
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
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi Ryusuke and Wang,

On Mon, 2026-10-26 at 15:04 +0800, wangjianjian (C) wrote:
> =E5=9C=A8 2026/10/25 13:09, Ryusuke Konishi =E5=86=99=E9=81=93:
> > On Sun, Oct 25, 2026 at 1:04=E2=80=AFPM wrote:
> > >=20
> > > From: Wang Jianjian <wangjianjian0@foxmail.com>
> > >=20
> > > This RFC patch added atime support for nilfs2. To keep disk inode
> > > layout, reuse {i_xattr, i_pad} as {i_atime, i_atime_nosec}. And
> > > remove
> > > SB_NOATIME from sb_flags.
> > >=20
> > > For now, the default behavior is relatime and other time mount
> > > options(such as noatime, lazytime,...) are not considered.
> > >=20
> > > Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
> > > ---
> > > =C2=A0 fs/nilfs2/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 6 ++++--
> > > =C2=A0 fs/nilfs2/nilfs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 --
> > > =C2=A0 fs/nilfs2/segment.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 3 ---
> > > =C2=A0 fs/nilfs2/super.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 5 -----
> > > =C2=A0 include/uapi/linux/nilfs2_ondisk.h | 4 ++--
> > > =C2=A0 5 files changed, 6 insertions(+), 14 deletions(-)
> >=20
> > Hi Wang Jianjian, (and Viacheslav)
> >=20
> > A similar proposal was made in the following RFC patch [1].
> >=20
> > [1]
> > https://lore.kernel.org/all/20260219204343.70117-1-slava@dubeyko.com/
> >=20
> > Since that patch is more comprehensive, I would prefer to proceed
> > based on Viacheslav's proposal.
> > Regarding atime support, we previously agreed to utilize the
> > reserved
> > extended attribute field.
> > As I recall, the remaining tasks were determining the design for
> > the
> > COMPAT flag in the superblock to ensure both forward and backward
> > compatibility, and addressing the necessary updates for nilfs-
> > utils.
>=20
> Sure. And sorry I didn't notice Viacheslav's patch.>
> > This has been on hold for more than half a year due to personal
> > circumstances on both Viacheslav's side and mine, but depending on
> > his
> > availability, it might be time to start moving this forward soon.
> >=20
> > However, since I am currently focused on analyzing a few issues and
> > preparing patches to fix them, and will be traveling over the next
> > two
> > weeks due to family matters (which have required frequent travel
> > this
> > year), I would appreciate it if we could resume detailed
> > discussions
> > after 7.4-rc2 is released.

Sorry, I was distracted from working on this patch by multiple events
in my life for the last half a year. I am OK if Wang can  take this
work. :) I am in business trip during this week. So, I am expecting not
to have enough time for discussion for the next several days. Let's=20
get more detailed discussion after 1 - 2 weeks.

Thanks,
Slava.=20

> >=20
> > Thanks,
> > Ryusuke Konishi
> >=20
> > >=20
> > > diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> > > index 34e6096069ad..c04f6aea5dee 100644
> > > --- a/fs/nilfs2/inode.c
> > > +++ b/fs/nilfs2/inode.c
> > > @@ -409,8 +409,8 @@ int nilfs_read_inode_common(struct inode
> > > *inode,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i_gid_write(inode, l=
e32_to_cpu(raw_inode->i_gid));
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_nlink(inode, le1=
6_to_cpu(raw_inode->i_links_count));
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode->i_size =3D le=
64_to_cpu(raw_inode->i_size);
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode_set_atime(inode, le64_to_=
cpu(raw_inode->i_mtime),
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 le32_to_=
cpu(raw_inode->i_mtime_nsec));
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode_set_atime(inode, le64_to_=
cpu(raw_inode->i_atime),
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 le32_to_=
cpu(raw_inode->i_atime_nsec));
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode_set_ctime(inod=
e, le64_to_cpu(raw_inode->i_ctime),
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 le32_to_cpu(raw_inode->i_ctime_nsec));
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode_set_mtime(inod=
e, le64_to_cpu(raw_inode->i_mtime),
> > > @@ -721,8 +721,10 @@ void nilfs_write_inode_common(struct inode
> > > *inode,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_gid =3D=
 cpu_to_le32(i_gid_read(inode));
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_links_c=
ount =3D cpu_to_le16(inode->i_nlink);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_size =
=3D cpu_to_le64(inode->i_size);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_atime =3D
> > > cpu_to_le64(inode_get_atime_sec(inode));
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_ctime =
=3D
> > > cpu_to_le64(inode_get_ctime_sec(inode));
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_mtime =
=3D
> > > cpu_to_le64(inode_get_mtime_sec(inode));
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_atime_nsec =3D
> > > cpu_to_le32(inode_get_atime_nsec(inode));
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_ctime_n=
sec =3D
> > > cpu_to_le32(inode_get_ctime_nsec(inode));
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_mtime_n=
sec =3D
> > > cpu_to_le32(inode_get_mtime_nsec(inode));
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_blocks =
=3D cpu_to_le64(inode->i_blocks);
> > > diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> > > index 4fc42d3787a4..23e2624f13ac 100644
> > > --- a/fs/nilfs2/nilfs.h
> > > +++ b/fs/nilfs2/nilfs.h
> > > @@ -234,8 +234,6 @@ static inline int nilfs_init_acl(struct inode
> > > *inode, struct inode *dir)
> > > =C2=A0 }
> > > =C2=A0 #endif
> > >=20
> > > -#define NILFS_ATIME_DISABLE
> > > -
> > > =C2=A0 /* Flags that should be inherited by new inodes from their
> > > parent. */
> > > =C2=A0 #define
> > > NILFS_FL_INHERITED=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (FS_SECRM_FL | FS_UN=
RM_FL | FS_COMPR_FL | FS_SYNC_FL
> > > |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
> > > diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> > > index 829573cb6131..3a9a66cc22e0 100644
> > > --- a/fs/nilfs2/segment.c
> > > +++ b/fs/nilfs2/segment.c
> > > @@ -929,9 +929,6 @@ static void nilfs_write_root_mdt_inode(struct
> > > inode *inode,
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs_write_inode_co=
mmon(inode, raw_inode);
> > >=20
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* zero-fill unused portion of =
raw_inode */
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_xattr =3D 0;
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_inode->i_pad =3D 0;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memset((void *)raw_i=
node + sizeof(*raw_inode), 0,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 nilfs->ns_inode_size - sizeof(*raw_inode));
> > >=20
> > > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > > index 893a504cb80c..75c068359b7c 100644
> > > --- a/fs/nilfs2/super.c
> > > +++ b/fs/nilfs2/super.c
> > > @@ -867,11 +867,6 @@ int nilfs_store_magic(struct super_block
> > > *sb,
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sb->s_magic =3D le16=
_to_cpu(sbp->s_magic);
> > >=20
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* FS independent flags */
> > > -#ifdef NILFS_ATIME_DISABLE
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sb->s_flags |=3D SB_NOATIME;
> > > -#endif
> > > -
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs->ns_resuid =3D=
 le16_to_cpu(sbp->s_def_resuid);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs->ns_resgid =3D=
 le16_to_cpu(sbp->s_def_resgid);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs->ns_interval =
=3D le32_to_cpu(sbp->s_c_interval);
> > > diff --git a/include/uapi/linux/nilfs2_ondisk.h
> > > b/include/uapi/linux/nilfs2_ondisk.h
> > > index b3442b16ff6a..ed365ba4565f 100644
> > > --- a/include/uapi/linux/nilfs2_ondisk.h
> > > +++ b/include/uapi/linux/nilfs2_ondisk.h
> > > @@ -65,9 +65,9 @@ struct nilfs_inode {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le32=C2=A0 i_flags=
;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le64=C2=A0 i_bmap[=
NILFS_INODE_BMAP_SIZE];
> > > =C2=A0 #define i_device_code=C2=A0 i_bmap[0]
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le64=C2=A0 i_xattr;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le64=C2=A0 i_atime;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le32=C2=A0 i_gener=
ation;
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le32=C2=A0 i_pad;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le32=C2=A0 i_atime_nsec;
> > > =C2=A0 };
> > >=20
> > > =C2=A0 #define NILFS_MIN_INODE_SIZE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 128
> > >=20
> > > base-commit: a4ff2be345d0abc943da8dd8da98151843b750dc
> > > --
> > > 2.34.1
> > >=20
