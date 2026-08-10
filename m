Received: from mail-yx2-f0.google.com (mail-yx2-f0.google.com [74.125.224.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D813B47F9
	for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 23:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786403287; cv=none; b=raxHku+KX0uwH2WYQwzfn4mCOOWi9E+lIpExAP6TGhS4Im5KSJ67SfG8deU4lF4AispWKZm15A4sf+soZAAUPztTbAsnisSaf4tgUZVLlxJeXsrGVW3vS4hff0WfqtfvHIzRsV4ub+BqBmKdlrTezrbDBoEczRtwX+2xuZ9boqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786403287; c=relaxed/simple;
	bh=DMsLUIyEJGOYTep53sgJgATSiHEzIRxC/j8g6yEGI7s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oldvP7Lu5/rOQHbmVgyiNZ0l6mYXi02Ay7l/Yup0w1FU0XsJ3QrnD2PgXmAULYTDuue9Pm4UzscSX2iYFqJP0HhcpqlGmEltOrACNSJASDNHV9fJJDnW4GU1ygZXFUUUlxtEF2B+TziRvNvCI2fVaLGmyHjObeE0GrAWMpkExy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=WG1Nvrwo; arc=none smtp.client-ip=74.125.224.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="WG1Nvrwo"
Received: by mail-yx2-f0.google.com with SMTP id 00721157ae682-81e7a64294cso4812597b3.1
        for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 16:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1786403283; x=1787008083; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qKj8f314idig0cXPDS7OIdfyYeu2IZajiYfg+XcptMc=;
        b=WG1Nvrwos+naY/gt2ffp9lb+03SF5vPFMEpWMUnqoAXKIR1wCF5/MV9T/rqDeG9Zsd
         9TzYDVAHcMQR5/7ZqVN/CHme/jpx8O63nPNPYkgkTNp+HspT7vwoiKI9dP/fDqDbK7Wx
         gadDcg67LHY8Rv6BE8DMYwI4wS5DLcLQhnwO6cnziVQUL3UtCnggKsSqC+51NB7thNk2
         BYTxkz6/PXOZGmRY+dWEoyuvWqfA25UsKLFA3DacmrjHXdkSSJZAzehLdlBjA1CuDL5a
         EEuT7E83c1uvN1A2IzAUarMA9IcQPmyt8aFVmjkn2wnfrFNvfOWt33jdi/+EbmHp/nNw
         AZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403283; x=1787008083;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qKj8f314idig0cXPDS7OIdfyYeu2IZajiYfg+XcptMc=;
        b=EWvSl44eTq+kqKLNJv+z4aZzjoA9XZt/3kIlUWFzOLfaPScr9BMX//ZbVivDLOkoxd
         cpZIQdHE/UcPFfStvGLIdKCYYTMotjfOklXQhUHiIi2I6+SilBTIQSjcHzY5uGfeWDOx
         iY0MRzKER4RAo5zgOTz5Bs+ix4I1AQ+3+Mp3lN5k1Z6dAnp/ccHnqXxak2iikGcu+Hiy
         vSD9hPcHT2OQb+zRFZWJIVKBVTRygZEcSF36ppvFTinsgEcypBX43jHzRQHhx4zf974E
         bbRou1j92NcZME3NhHy27YzLn7Ye7mB22uujLnIe8GvusiFUT7eTTb3PvaL32rZRXq4P
         xa5A==
X-Forwarded-Encrypted: i=1; AHgh+Rr69CHIohyG7Az3BakwnBXxwiNgo25ADJidPQEQ4i20rNC4pdn9E2D8ukEfQy1oQayta7knuxlKMisWVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo5x6+AcfC1sdGS1moBZPwawz/w5MbaPAPfPKuV+1eT5vGOD4Q
	ZZDh1As7XrF6VaW/tWajEUs4D1dsHR2EMHK50JMOh85o+sq3p0ggk6xN5QX9jaq7YRs=
X-Gm-Gg: AR+sD12AzeznwDZwYOjStB0Waj9XDBcuBeqOkeyWEa4a07N2v/m+YDcRSAjCj3bFJS3
	Pm8r8F2rTP8N8BFAbbFtS0rBImydypHwClR/RSJZHBfn15xG+VQA6CKZBISPxW2trNK1SQhfvTl
	oXCZr8M1W5DGl3/zFosmT+gF7gaoNdVejE/J00vZyzW4fM52msev3pO+A4ewGtoBeC3VNz9m2OV
	y77CQZe3vOuiAQgYxx6itMrUMGvGzgbTloEFgzDp01JaWtFZG4jKQJiqEEKBxjwusyUE+eB3RPO
	UIW5EfWJfU9hA0yqfbnwrI40M90AZs3hPLQCCBbnG/Va+omLDfkUpuKNu2ONvapzZ7IHVtkWvN2
	7yFvSPI4lsejKV4JSb9bMpCykmMqCoTDM1sbXmWs2ow/f1nYMaKRDYtfv8dc4nvh/3AREJyUmOU
	lH3nP6S7jRFTQcq503v1gB1bP8hGzumOe5vH2MrDQr1UqUOdu7ULjTwaxV4/HxFNGXE3fsAswaQ
	96Yait9YJS9ESNjHi4m2S5fD+PRCZ3VPg9e2gZ5NSeUT1c8PyqAo+DDZfQnCc9amgufmr0x+HqA
	UaGjCtfhlObmIosAxBdG41GRsw==
X-Received: by 2002:a05:690c:4011:b0:825:c3fc:e63f with SMTP id 00721157ae682-825c3fce6ebmr109530697b3.8.1786403283196;
        Mon, 10 Aug 2026 16:08:03 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:9c3:cf0:a72e:f469])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-823f6a0c633sm65486177b3.38.2026.08.10.16.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 16:08:02 -0700 (PDT)
Message-ID: <32b74743e9eb4da2c2fd0f045c06a4916389358d.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: enhance btree node keys check
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Wang Jianjian <wangjianjian3@huawei.com>, linux-nilfs
	 <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Date: Mon, 10 Aug 2026 16:08:00 -0700
In-Reply-To: <20260810142125.60264-1-konishi.ryusuke@gmail.com>
References: <20260810142125.60264-1-konishi.ryusuke@gmail.com>
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

On Mon, 2026-08-10 at 23:20 +0900, Ryusuke Konishi wrote:
> From: Wang Jianjian <wangjianjian3@huawei.com>
>=20
> syzbot reported a warning on nilfs_btree_assign:
> WARNING: fs/nilfs2/btree.c:2302 at nilfs_btree_assign+0x983/0xbe0
> fs/nilfs2/btree.c:2302,
>=20
> Analysis found that a corrupted file has the following btree layout:
> Level2(key/ptr): [ 256/15 ]
> Level1(key/ptr): [ 0/8, 1/9, 0/10, 3/11, 4/12, 5/13, 6/14,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 139637976727559/16, 0/17 ]
>=20
> The test truncated the file to 2 bytes, which partially zeroes the
> first
> block and adds the file to the dirty list. When the segment
> constructor
> writes it and assigns a new blocknr for the index block, it searches
> the
> btree with key=3D0 and min level=3D2, and apparently returns -ENOENT.
>=20
> Therefore, we should perform more checks on the btree nodes and
> return
> early.
>=20
> [ryusuke: split long lines in btree.c to satisfy checkpatch and
> =C2=A0improved the error message format for clarity]
>=20
> Reported-by: syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D158be45e4d99232e1900
> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
> Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
> Cc: <stable+noautosel@kernel.org> # Warning suppression primarily
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please apply this for the next cycle.
>=20
> This introduces a check for sorted keys when reading btree node
> blocks
> into the cache, preventing unexpected errors during the block number
> assignment phase in log writing caused by key order inconsistencies,
> as well as the kernel warnings reported by syzbot.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/btree.c | 19 ++++++++++++++++---
> =C2=A01 file changed, 16 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 64bac66af25b..6b8332e8c0db 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -341,7 +341,8 @@ static int nilfs_btree_node_broken(const struct
> nilfs_btree_node *node,
> =C2=A0				=C2=A0=C2=A0 sector_t blocknr)
> =C2=A0{
> =C2=A0	int level, flags, nchildren;
> -	int ret =3D 0;
> +	__u64 key, prev_key;
> +	int i;
> =C2=A0
> =C2=A0	level =3D nilfs_btree_node_get_level(node);
> =C2=A0	flags =3D nilfs_btree_node_get_flags(node);
> @@ -356,9 +357,21 @@ static int nilfs_btree_node_broken(const struct
> nilfs_btree_node *node,
> =C2=A0			=C2=A0=C2=A0 "bad btree node (ino=3D%llu, blocknr=3D%llu):
> level =3D %d, flags =3D 0x%x, nchildren =3D %d",
> =C2=A0			=C2=A0=C2=A0 inode->i_ino, (unsigned long
> long)blocknr, level,
> =C2=A0			=C2=A0=C2=A0 flags, nchildren);
> -		ret =3D 1;
> +		return 1;
> =C2=A0	}
> -	return ret;
> +
> +	for (i =3D 1, prev_key =3D nilfs_btree_node_get_key(node, 0);
> +	=C2=A0=C2=A0=C2=A0=C2=A0 i < nchildren; i++, prev_key =3D key) {
> +		key =3D nilfs_btree_node_get_key(node, i);
> +		if (unlikely(key <=3D prev_key)) {
> +			nilfs_crit(inode->i_sb,
> +				"bad btree node (ino=3D%llu,
> blocknr=3D%llu): unsorted keys at index %d (%llu) and %d (%llu)",
> +				inode->i_ino, (unsigned long
> long)blocknr,
> +				i - 1, prev_key, i, key);
> +			return 1;
> +		}
> +	}
> +	return 0;
> =C2=A0}
> =C2=A0
> =C2=A0/**

Applied.

Thanks,
Slava.
