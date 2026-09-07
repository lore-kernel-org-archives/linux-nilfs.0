Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5CC51FCCD
	for <linux-nilfs@vger.kernel.org>; Mon,  7 Sep 2026 17:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801483; cv=none; b=TQpUxbUm/b59N0Pc6SzLW7cWkgkHy+RIg6ZkqUJli/tzPSlhDNZn7ZEyIaeTPHuV/S7PkDuLkR4W975d63qDczaLjPkF+SzJQ1zhqVIzYMBHg9pI1XRR1TA/MtngrBleC/sDo9S65WCfIbKhC8nai6Rw8IWBXuCxapSU0pmiMkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801483; c=relaxed/simple;
	bh=bI8Yp0e0/f/vnKBx7xlsGswepzbqAuf/L6YMuVSCcto=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JYom6wO6yFwRCWnotqSBpefrxb1kO0mCI4wrQmv+ouLa27ZS/4wYfTG2aoRcTWa/762T0AuYjsEo/R+eStzAAaRp5HGi2Ru/dbZA3pwLhVwz5s0S8Jg2UTQu/WnHJN0JwFZSB/3PLkYTPvAYwW7NQSgbc+zYX1zU63utx8lQeLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=zDO91GlC; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="zDO91GlC"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5bfc54558d5so5160420e0c.0
        for <linux-nilfs@vger.kernel.org>; Mon, 07 Sep 2026 10:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1788801481; x=1789406281; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bI8Yp0e0/f/vnKBx7xlsGswepzbqAuf/L6YMuVSCcto=;
        b=zDO91GlC9uac1R9g3mjIRvC4W3x9fw1Hk3oFcYJ2X7i1qdOiIqZH9479UI8YlbXRd5
         h0vag2g/1TtAY0A1RVsZQS5ssWsEymIFVU5oS8g7cT+W9cGJQ3Xte9LpEtfHGuCWC18M
         ohxYUMcOczVP1+zPsbv/a3/9Jm1sWOGFQNqdVi5xXFZtiELdU6YCTJB312SrCJeQeuGd
         Kw6h5rzvN1UQdMnvHHJ7C1XFPT5r8HboQfP2WgwCgrJ0nUofD9Er3RBeUeKz2h7Z29a7
         OwPaizGqomoE1GwNwptbGPChylHmfTB1Eu0L3bc+uJDwx3+DuGUpha7RrLpuNx3K9b3k
         jVug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788801481; x=1789406281;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bI8Yp0e0/f/vnKBx7xlsGswepzbqAuf/L6YMuVSCcto=;
        b=nmrBQDuh3bb2KFHIMaDiFqpFUG56D9kbXFVcDzgzkJ1D3ra9TUbkQEjfldRUKUd6Yu
         ZmMzRuqRMnNCKc1V9G6NW+oYLntLMJ0hXsKokg37AbwmN+bOainc5Gj9/SfALEenGO6b
         3DMc123MPVxOHG9LIuND63i2raoax+prGSK9NAKQWmOXeEJbN31I02UzdlT+RmJqZ0XG
         F1GYGkYQiPhWrS4+YxfX/l62lO2btq8AP21nLpLH5Vd7LCN07hpmqLiW/2gr5SJH5kfS
         rqcniDGddFlRrIXPHQ2nSTdSsWo4tWJlr+Pq93SgTf6lLBGEQ7XK4eyriZY4/HPsPsnT
         E+iA==
X-Gm-Message-State: AFuF++lEhg5NLNBe3QCSpNWuTowNf0FmULLw5H2iibxsb5d6wRQECfy0
	nbF/bsGSc3PPGHlfKNg04lZSI3B/2nfnIoeor4YefdLvoCmNmQz7+WP9QK2YhtmK1rTkhPI/0M7
	Df+67WO8=
X-Gm-Gg: AYBFou3ssBGaD9UeXhpMn3FYTBGFg79RF1F8Mrha3SItlBu5OHFpbAGx7iXfBoSxOIq
	41ujcQ/LQ/VxcpQgF3INYxA+G+42IvFI8cUw6BaCwQda4FjLlBZRALsGXFrP954YkiuuhhHdX5m
	rxnAjR1lUkZsf4e4f1thN3Jr2s21m78DDUKZzN4azyvcDW/YuVCiR17mOyGKfjUQoySycmi7dpR
	RiuZViUqMlQmMs2KHLONFV2LSOJG2+d6o5qF83FMOikYey2dAL+UdGnpWhnAWbi2vuQDS1lrI5Y
	5HALJ4jbc81kGaB2/zq9QStRZ4bKOzprw/s/qGXLxwk9YYy7LDMrR67yopSZpVWHf6Pbldru/Hb
	pyInv6a8j87mzZVnmRv7D8kVXqXo+hutMa8Izfr41QKVMtwmYWbH1Aw2RJGfEugYthMstHs4JZ7
	wfnc5H63WGtHSLLyaMfXr/XauyJdeMy0z0FtMe+HDaBnaeShiIS7Uk0WZgTUmnwTuRHTDvHVWTG
	jgqbJqOS2CukDjE1WGJAM+Moj0uwzK2KkO1b19ax/NkqMW9mUnwRIV532JjAUgOjdkD7lJajL8i
	x5n7YUKomR+7306YBr6fa9BFzqI/Xbh6uXsv04dRIxUdTu+NTI/ccOA=
X-Received: by 2002:ac5:cacc:0:b0:5c2:a30a:1a08 with SMTP id 71dfb90a1353d-5c7dcdea6e8mr6330780e0c.2.1788801480693;
        Mon, 07 Sep 2026 10:18:00 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:51d3:d0fc:6793:303f? ([2600:1700:6476:1430:51d3:d0fc:6793:303f])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c7ebf559cbsm8207989e0c.0.2026.09.07.10.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 10:18:00 -0700 (PDT)
Message-ID: <8f5f256ff990d747edbed26240e8e9ffdfe8ea83.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: fix typos in comments
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Hemanth Selam
	 <hemanth.selam@gmail.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 07 Sep 2026 10:17:56 -0700
In-Reply-To: <CAKFNMok3MaD+fRcG6VbBRND3gZa+APt_jV63KtQzXzpX6vdCCw@mail.gmail.com>
References: <20260907062427.11910-1-hemanth.selam@gmail.com>
	 <CAKFNMok3MaD+fRcG6VbBRND3gZa+APt_jV63KtQzXzpX6vdCCw@mail.gmail.com>
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
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDI2LTA5LTA3IGF0IDE3OjI2ICswOTAwLCBSeXVzdWtlIEtvbmlzaGkgd3JvdGU6
Cj4gT24gTW9uLCBTZXAgNywgMjAyNiBhdCAzOjI04oCvUE0gSGVtYW50aCBTZWxhbSB3cm90ZToK
PiA+IAo+ID4gRml4IHR5cG9zIGluIGNvbW1lbnRzLCByZXBvcnRlZCBieSBzY3JpcHRzL2NoZWNr
cGF0Y2gucGwgdXNpbmcgdGhlCj4gPiBtaXNzcGVsbGluZyBsaXN0IGluIHNjcmlwdHMvc3BlbGxp
bmcudHh0LsKgIE9ubHkgdG91Y2hlcyBjb21tZW50cywKPiA+IG5vIGNvZGUKPiA+IGNoYW5nZXMu
Cj4gPiAKPiA+IEFzc2lzdGVkLWJ5OiBDdXJzb3I6Y2xhdWRlLW9wdXMtNQo+ID4gU2lnbmVkLW9m
Zi1ieTogSGVtYW50aCBTZWxhbSA8aGVtYW50aC5zZWxhbUBnbWFpbC5jb20+Cj4gPiAtLS0KPiAK
PiBBY2tlZC1ieTogUnl1c3VrZSBLb25pc2hpIDxrb25pc2hpLnJ5dXN1a2VAZ21haWwuY29tPgo+
IAo+IEhlbWFudGggU2VsYW0sIHRoYW5rIHlvdSBmb3IgdGhlIHBhdGNoLgo+IAo+IFZpYWNoZXNs
YXYsIGNvdWxkIHlvdSBwbGVhc2UgYWRkIHRoaXMgdG8gdGhlIHF1ZXVlIGZvciB0aGUgbmV4dCBj
eWNsZQo+IGFzIHdlbGw/Cj4gCj4gVGhhbmtzLAo+IFJ5dXN1a2UgS29uaXNoaQo+IAo+ID4gwqBm
cy9uaWxmczIvc3VmaWxlLmMgfCAyICstCj4gPiDCoGZzL25pbGZzMi9zdXBlci5jwqAgfCAyICst
Cj4gPiDCoDIgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+
ID4gCj4gPiBkaWZmIC0tZ2l0IGEvZnMvbmlsZnMyL3N1ZmlsZS5jIGIvZnMvbmlsZnMyL3N1Zmls
ZS5jCj4gPiBpbmRleCBlY2VlZGNhMDI2OTcuLjY5MThiZTZmY2UyZSAxMDA2NDQKPiA+IC0tLSBh
L2ZzL25pbGZzMi9zdWZpbGUuYwo+ID4gKysrIGIvZnMvbmlsZnMyL3N1ZmlsZS5jCj4gPiBAQCAt
MTA1MCw3ICsxMDUwLDcgQEAgc3NpemVfdCBuaWxmc19zdWZpbGVfc2V0X3N1aW5mbyhzdHJ1Y3Qg
aW5vZGUKPiA+ICpzdWZpbGUsIHZvaWQgKmJ1ZiwKPiA+IMKgICogbGVuOsKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBudW1iZXIgb2YgQnl0ZXMgdG8gdHJpbSBmcm9tIHN0YXJ0Cj4gPiDC
oCAqIG1pbmxlbjrCoMKgwqDCoCBtaW5pbXVtIGV4dGVudCBsZW5ndGggaW4gQnl0ZXMKPiA+IMKg
ICoKPiA+IC0gKiBEZWNyaXB0aW9uOiBuaWxmc19zdWZpbGVfdHJpbV9mcyBnb2VzIHRocm91Z2gg
YWxsIHNlZ21lbnRzCj4gPiBjb250YWluaW5nIGJ5dGVzCj4gPiArICogRGVzY3JpcHRpb246IG5p
bGZzX3N1ZmlsZV90cmltX2ZzIGdvZXMgdGhyb3VnaCBhbGwgc2VnbWVudHMKPiA+IGNvbnRhaW5p
bmcgYnl0ZXMKPiA+IMKgICogZnJvbSBzdGFydCB0byBzdGFydCtsZW4uIHN0YXJ0IGlzIHJvdW5k
ZWQgdXAgdG8gdGhlIG5leHQgYmxvY2sKPiA+IGJvdW5kYXJ5Cj4gPiDCoCAqIGFuZCBzdGFydCts
ZW4gaXMgcm91bmRlZCBkb3duLiBGb3IgZWFjaCBjbGVhbiBzZWdtZW50Cj4gPiBibGtkZXZfaXNz
dWVfZGlzY2FyZAo+ID4gwqAgKiBmdW5jdGlvbiBpcyBpbnZva2VkLgo+ID4gZGlmZiAtLWdpdCBh
L2ZzL25pbGZzMi9zdXBlci5jIGIvZnMvbmlsZnMyL3N1cGVyLmMKPiA+IGluZGV4IDg5M2E1MDRj
YjgwYy4uNjVmNDRmZjY3NzllIDEwMDY0NAo+ID4gLS0tIGEvZnMvbmlsZnMyL3N1cGVyLmMKPiA+
ICsrKyBiL2ZzL25pbGZzMi9zdXBlci5jCj4gPiBAQCAtNjU0LDcgKzY1NCw3IEBAIHN0YXRpYyBp
bnQgbmlsZnNfc3RhdGZzKHN0cnVjdCBkZW50cnkgKmRlbnRyeSwKPiA+IHN0cnVjdCBrc3RhdGZz
ICpidWYpCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IC8qCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
KiBJZiBuaWxmc19wYWxsb2NfY291bnRfbWF4X2VudHJpZXMoKQo+ID4gcmV0dXJucwo+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogLUVSQU5HRSBl
cnJvciBjb2RlIHRoZW4gd2Ugc2ltcGx5IHRyZWF0Cj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIGN1cmVudCBpbm9kZXMgY291bnQgYXMgbWF4aW11
bSBwb3NzaWJsZQo+ID4gYW5kCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAqIGN1cnJlbnQgaW5vZGVzIGNvdW50IGFzIG1heGltdW0gcG9zc2libGUK
PiA+IGFuZAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgICogemVybyBhcyBmcmVlIGlub2RlcyB2YWx1ZS4KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBubWF4aW5vZGVzID0gYXRvbWljNjRfcmVhZCgmcm9v
dC0KPiA+ID5pbm9kZXNfY291bnQpOwo+ID4gLS0KPiA+IDIuNDguMQo+ID4gCgpBcHBsaWVkLgoK
VGhhbmtzLApTbGF2YS4K

