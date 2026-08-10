Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F51145B3F
	for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 00:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786320954; cv=none; b=EM5cVsK4FNOjEHIUAxzKCu7E+UN+8wtpwhGBloRcV14n1oROYM87R8HdlOyN2vxHSvoNUK7ueXBz0hZib8qD/A+y/pVlSBalYcgZ6rLWNGlY/pM5s6xvXLYRZ6eYoeLjDIrFIYpJGq3WsShsSUo9u7hegY3cKBH7tkjI+2H+PSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786320954; c=relaxed/simple;
	bh=AaPlFmXt3mTC2YTK0wuANbxjn4M10ryqdnyborU+XA8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gYiPjCukzpFfGkV1IDqlVe4UeczuN43pliDCA1MNY7SUNq+RBkHyU6FKKr9PG600vsA440t0u+tU4sIFGpgp6eM9yLNhDzZaE5L2zWcTJ1sRmHgK1auB/pC6rRrNyrgdQQiLM4gNsx8I5qGREDvnOP0GzBE+GXjO94ya+X8vnAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=y+WpukCq; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="y+WpukCq"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81f36179dd5so15932727b3.2
        for <linux-nilfs@vger.kernel.org>; Sun, 09 Aug 2026 17:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1786320952; x=1786925752; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AaPlFmXt3mTC2YTK0wuANbxjn4M10ryqdnyborU+XA8=;
        b=y+WpukCqmqajDJV/Wdr/l3/RpouBDkAIdcDWftwWMKu9J3/HnwYHINwnpAiIUxsaGN
         K7+bt0ESuH37YVPYfr24LbFjYKliRPWCtqmjs0UdUGVFMpoXw0GpOmtyK/1Ct/CdFTEk
         YHJ1sbN/XadESBdhKI/DZ5hyeQEFUN3kDGTdTeSGsItINEb3utXx9N1W6bE2hTU0Txg7
         piuTK0cGD7KEoH86PrhvwOqJ4cW31ELJhakQTP2e+bTI69c9yr7Tb8eWW29DWyKlNw6+
         3kjUzKMO9BC7ZF/KNZFTMZf7ie4+VLEIbUE0LRaYbfpyvEn36d2KSL92vdkxwJyuHunl
         rImw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786320952; x=1786925752;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AaPlFmXt3mTC2YTK0wuANbxjn4M10ryqdnyborU+XA8=;
        b=lyfKTNBYOycLtjkG5ZnGyMOVWhFq2cdTDBGkLFeSIt+iovscSw9+D5fu5fGUSOrFHE
         ximWMp+johoPunXTwqjKrfSZsGB5u/g39x1MfoTFY1lcIsup4I3vicD2g8i2YmQlGasu
         tPFhgzL1BrDTG/f7LZ/y/wpfTzeNPAkhYpsLYkjcLWLZIcjuLBnH4eHQyx7exjlvd/9o
         m0OA+pjqeRROhrWfvierp5p0HefNeT4ejbl5bbTnsDrOH6aHpwaoVFUc8aQ3DAikCB8x
         bX7z3Ou63Kg7Db5INV+R2P2GK3CBq57ZYe1bdyuLtx7xyW9Fg28ZV5rml95LATcggmor
         Kl3Q==
X-Forwarded-Encrypted: i=1; AHgh+Rrv4q13SypN0C5QoDCocisHEezH8Jgb+IT5dLchFT5qFgqN+bjkvS3zQumtZG3HYWGU+h2TJP2bsjFMuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxAcDeKFer/825d8RzSZJV+r0qOeDzzOLBoUJQzzeLYC9G6LlMe
	NWdBOf7jSqaIT+D/gwFnULpj6PstSCvXp/7YZrBgf6JtpEmMK4cPQMQeqOC6F6exV4g=
X-Gm-Gg: AR+sD10ax5E/Advha8tp8CHPYfDpsQtriWhWppqZ4a//r4hVtWYEYTXzZJL+eSSXPyL
	6zQ5qB9+xve4D9qrEw9swUlAj9zgjDnPyhJCyAw7CflzUYjzzTNF2Yi7ERwNiZSebv9IdLAdlbu
	nqioVCvxYia0dEvMAV8YsGhr6WlQX1gkrYC8NJr+IFtgI8kESaAD721IxCDTc6lUULScY3pPTWh
	GolXYIhAZngMOeD1BXQ7dZzxG5UNLCSSU4eE/FbQC1BzsmlMN1LRfFlrLqSxHcWdyQgdR/SINTf
	+wbrO79yLVVV0d3FBMn3E6i/qrR33aNJQO2sgzH120vSNy+8bRdZ3lKwcNBts/8Hw3Aoq4sy5Qy
	95qaB1x5Ixq32dEERnrpRfhqjdISAFHkGAKm3DB4EyuK0WdJE6zAG5CsQrX/YiOeRORwy2MkSMz
	QbTB75xCqst/h/afbnHDxsLfzH+kbKbbhGf7BzGSh0epXGH7uGe7wqkV0bsluJehTxBXhYetzna
	louvfmfAumdYfPo9uQsyyp7C5WbGFbF6gQLtdVQmd9MUjEWv3Clwmlt4LAMcZktfI88rkdQMDZy
	3yWCXCkxPDTTJ01M
X-Received: by 2002:a05:690c:7247:b0:81e:4aa9:d025 with SMTP id 00721157ae682-8201bc8540bmr245573617b3.6.1786320952099;
        Sun, 09 Aug 2026 17:15:52 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:c24:25ad:39a6:33c1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-823f1150104sm47024277b3.21.2026.08.09.17.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 17:15:51 -0700 (PDT)
Message-ID: <7cd1c574330b89f502f8ac3851090414455d481a.camel@dubeyko.com>
Subject: Re: [PATCH v2 2/2] nilfs2: switch O_DIRECT to iomap based operations
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: hch@lst.de, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	lilinmao@kylinos.cn
Date: Sun, 09 Aug 2026 17:15:49 -0700
In-Reply-To: <CAKFNMokwaRf7e1yzYBNAxpHhvMZCsEzeqc8L066OaJRfS4b4zQ@mail.gmail.com>
References: <20260808003523.2760509-1-slava@dubeyko.com>
	 <20260808003523.2760509-3-slava@dubeyko.com>
	 <CAKFNMokwaRf7e1yzYBNAxpHhvMZCsEzeqc8L066OaJRfS4b4zQ@mail.gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

SGkgUnl1c3VrZSwKCk9uIFN1biwgMjAyNi0wOC0wOSBhdCAwODo1MSArMDkwMCwgUnl1c3VrZSBL
b25pc2hpIHdyb3RlOgo+IEhpIFZpYWNoZXNsYXYsCj4gCj4gT24gU2F0LCBBdWcgOCwgMjAyNiBh
dCA5OjM14oCvQU0gVmlhY2hlc2xhdiBEdWJleWtvIHdyb3RlOgo+IC4uLgo+ID4gK3N0YXRpYyBz
c2l6ZV90IG5pbGZzX2ZpbGVfcmVhZF9pdGVyKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0Cj4g
PiBpb3ZfaXRlciAqdG8pCj4gPiArewo+ID4gK8KgwqDCoMKgwqDCoCBpZiAoaW9jYi0+a2lfZmxh
Z3MgJiBJT0NCX0RJUkVDVCkgewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
dXJuIGlvbWFwX2Rpb19ydyhpb2NiLCB0bywgJm5pbGZzX2lvbWFwX29wcywKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBOVUxMLCAwLCBOVUxMLCAwKTsKPiA+ICvCoMKgwqDCoMKgwqAgfSBlbHNlCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gZ2VuZXJpY19maWxlX3JlYWRfaXRlcihp
b2NiLCB0byk7Cj4gPiArfQo+IAo+IEFtb25nIHRoZSB0ZXN0cyB0aGF0IHVzZWQgdG8gcGFzcyBi
ZWZvcmUgdGhlIGlvbWFwIGNvbnZlcnNpb24sIEkKPiBmb3VuZCB0aGF0Cj4gcnVubmluZyB4ZnN0
ZXN0cyBnZW5lcmljLzQxOCBhbmQgZ2VuZXJpYy80NjUgbm93IGZhaWxzIHdpdGggYSAiYnJva2Vu
Cj4gYm1hcCIKPiBlcnJvciwgY2F1c2luZyB0aGUgZmlsZXN5c3RlbSB0byByZW1vdW50IHJlYWQt
b25seS4KPiAKPiBUaGlzIGhhcHBlbnMgYmVjYXVzZSBpb21hcF9kaW9fcncoKSBpcyBjYWxsZWQg
d2l0aG91dCBob2xkaW5nIHRoZQo+IHNoYXJlZAo+IGlub2RlIGxvY2suwqAgVG8gcHJldmVudCB0
aGlzIHJhY2UsIEkgdGhpbmsgaW9tYXBfZGlvX3J3KCkgc2hvdWxkIGJlCj4gcHJvdGVjdGVkIGFz
IGZvbGxvd3M6Cj4gCj4gwqDCoMKgwqDCoMKgwqAgc3RydWN0IGlub2RlICppbm9kZSA9IGZpbGVf
aW5vZGUoaW9jYi0+a2lfZmlscCk7Cj4gwqDCoMKgwqDCoMKgwqAgc3NpemVfdCByZXQ7Cj4gCj4g
wqDCoMKgwqDCoMKgwqAgaWYgKGlvY2ItPmtpX2ZsYWdzICYgSU9DQl9ESVJFQ1QpIHsKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW5vZGVfbG9ja19zaGFyZWQoaW5vZGUpOwo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBpb21hcF9kaW9fcncoaW9jYiwgdG8s
ICZuaWxmc19pb21hcF9vcHMsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgTlVMTCwgMCwgTlVMTCwgMCk7Cj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlub2RlX3VubG9ja19zaGFyZWQoaW5vZGUpOwo+IMKgwqDC
oMKgwqDCoMKgIH0gZWxzZSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9
IGdlbmVyaWNfZmlsZV9yZWFkX2l0ZXIoaW9jYiwgdG8pOwo+IMKgwqDCoMKgwqDCoMKgIH0KPiAK
PiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Owo+IAo+IEFkZGluZyB0aGlzIGxvY2tpbmcgcmVz
b2x2ZWQgdGhlIGZhaWx1cmVzIGluIGJvdGggZ2VuZXJpYy80MTggYW5kCj4gZ2VuZXJpYy80NjUg
aW4gbXkgdGVzdHMuCgpZZWFoLCBtYWtlcyBzZW5zZS4gTGV0IGRvdWJsZSBjaGVjayB0aGlzLgoK
PiAKPiA+ICsKPiA+ICtzdGF0aWMgc3NpemVfdCBuaWxmc19maWxlX3dyaXRlX2l0ZXIoc3RydWN0
IGtpb2NiICppb2NiLCBzdHJ1Y3QKPiA+IGlvdl9pdGVyICpmcm9tKQo+ID4gK3sKPiA+ICvCoMKg
wqDCoMKgwqAgLyoKPiA+ICvCoMKgwqDCoMKgwqDCoCAqIE5JTEZTMiBjYW5ub3QgcGVyZm9ybSB0
cnVlIGRpcmVjdCBJL08gd3JpdGVzOiBuZXcgYmxvY2tzCj4gPiBhcmUKPiA+ICvCoMKgwqDCoMKg
wqDCoCAqIGRlbGF5LWFsbG9jYXRlZCBhbmQgYXJlIG9ubHkgZ2l2ZW4gYSByZWFsIGRpc2sgYWRk
cmVzcwo+ID4gd2hlbgo+ID4gK8KgwqDCoMKgwqDCoMKgICogdGhlIHNlZ21lbnQgY29uc3RydWN0
b3Igd3JpdGVzIHRoZW0gb3V0IGFzIHBhcnQgb2YgYQo+ID4gbG9nLAo+ID4gK8KgwqDCoMKgwqDC
oMKgICogd2hpY2ggd29ya3MgZGlyZWN0bHkgb24gYnVmZmVyX2hlYWQgbGlzdHMgcmF0aGVyIHRo
YW4KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIHRocm91Z2ggaW9tYXAuIEZhbGwgYmFjayB0byB0aGUg
b3JkaW5hcnkgYnVmZmVyZWQgd3JpdGUKPiA+IHBhdGgKPiA+ICvCoMKgwqDCoMKgwqDCoCAqIGZv
ciBPX0RJUkVDVCB3cml0ZXMuCj4gPiArwqDCoMKgwqDCoMKgwqAgKi8KPiAKPiBBbHNvLCByZWdh
cmRpbmcgdGhpcyBjb21tZW50LCBmb2xsb3dpbmcgQ2hyaXN0b3BoJ3Mgc3VnZ2VzdGlvbiwgaG93
Cj4gYWJvdXQgc2ltcGxpZnlpbmcgaXQgYXMgZm9sbG93cz8KPiAKPiDCoMKgwqDCoMKgwqDCoCAv
Kgo+IMKgwqDCoMKgwqDCoMKgwqAgKiBOSUxGUzIgbGFja3MgZGlyZWN0IEkvTyB3cml0ZSBzdXBw
b3J0OyBmYWxsIGJhY2sgdG8KPiBidWZmZXJlZCB3cml0ZXMuCj4gwqDCoMKgwqDCoMKgwqDCoCAq
LwoKU29ycnksIG15IGJhZC4gSSBtaXNzZWQgdGhpcy4gTGV0IG1lIHJld29yayB0aGUgY29tbWVu
dC4KClRoYW5rcywKU2xhdmEuCgo=

