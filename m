Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935782AD32
	for <linux-nilfs@vger.kernel.org>; Tue, 23 Dec 2025 00:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766448973; cv=none; b=enGXRAlmaQfoh8HS4tExUuUxciIjazcDGu8xhRKRmakNv/p76Czjit0R6hkhh0AHFtVNYq9JwvL+llihwIvr7zDzkePpiScs8cBF3y3o1joU3sE90wpL9xeEza4QYQffM+xqZ4eU2Pk6Ypt0eqW6Mb37FXQhHyLG7xOi3YkBHTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766448973; c=relaxed/simple;
	bh=TIgOQ1XTZG9V5btyhSaIH3i0yX+DT56WjaX7gZ5oTgU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BgwI0PFxnAA4m4xcJGBQdMfLK8ZfSLg8XTOPoMhzzv9dPubFmTeH+eP2a53T7HK9lzpMUcLf80Tt1uFenpV7Wk0HIbmCVFU6EMCFl7Cw7ioMOX2o+Wf5y2x9KzAuzuSk+be1Czq9OchkJpFx7PNUgHrAXkvcRZ4Qski/uN8MOCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=s38hGwsz; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="s38hGwsz"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-78fdb90b670so11547637b3.2
        for <linux-nilfs@vger.kernel.org>; Mon, 22 Dec 2025 16:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1766448970; x=1767053770; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TIgOQ1XTZG9V5btyhSaIH3i0yX+DT56WjaX7gZ5oTgU=;
        b=s38hGwszlPXJ/Z/B3mcFsXcqpxZ45c3xfMAa/2wnR5L1bH7DSt/KDaRL/EZ0YylXjT
         kfuOBWQ/erruEmGChrbHxRsfUbdamu8o4K4VyNwNDpbQuOQkYf9d9Lu5ic0gYTAH5kMx
         cp1LVToyg2dl6ZJ5tYU3ZpeWSVDx+k2lm0MpxyG7jnB3gtMNdIYUWL2LVInC0ZkveRVF
         okK5b6Jm2vDTYVTbQN3vnjIApK4ofLeTvflQ9Y2o9ESsBHA3iO3z5e4V6IBQKypzDmut
         EmpBzBJ0JYMgC00F+++smcpDwK8r3pGuIVgiKFT34Hn4qq7FaeFMRLzWMIyBofRZK71J
         NO2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766448970; x=1767053770;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TIgOQ1XTZG9V5btyhSaIH3i0yX+DT56WjaX7gZ5oTgU=;
        b=eXT73y62xEbcqhbwV1nhcmUaz7M+yzV9tq8hGx5PUppHcC7mYAG64wNNq4px+oZ34r
         zVG0xvkOZU9+C7PpFlJlalpGXSsemBfyYPlpiws0qcphOTPzTi5mpSX1p/pPS6vTpzwP
         NcEBQemNsrBHoGU92NQvEDCT7hpfThH/MUyjA3XyPp3sDdXhaNNZOtr71jh+15XwrZCQ
         v8bJAzbay0a0M1dqTq/8603o8JeGyQuPEfY+FgHTQ4VPkFneWsxF2acEYmmwpqP3cBDJ
         TT52ogNQ9ibs9O86tdO8JK9GPh4Ms9EuMq5A/r9UBj0GQQaO2DNfRH95eYdIGUizj20Y
         cFcQ==
X-Gm-Message-State: AOJu0Yzrt3MRVho045jpmpr6p9N9JepXgSusIST6LzoOiVVeskVOmaS0
	9AldlUHQ4H5Ictt5OukgeAoTPKy82wvKB3zKarVPXa9ufkCVPcqRTkGVNp71QTP6Tu8=
X-Gm-Gg: AY/fxX4iXFuhBbU0VYV/LTKVuqJOcYxBHJH2vTbTq9PxgM1vTxx/1cuabOXIE4dP2Do
	1S3HMREMQMYIPKLCDWmZhSC2lG3fILBkHRgdc1FFaOJodq+5Mod8zlISNPRqo/Zf28P4dAdd9OP
	NVwMml0Z3JEKq0H5xsX7N6kC13cOwvsy7VvaEyO3TKCXFOx/88b4HIM9WAeGkqQ3lOpJSFzNFXW
	M5/tyNGnU4oPiW/e3wAT863gidRy0qgFGqvj23O0nSBdPT8Aoj5FfHh44Nu6Kv8O5EY0ZTaPhNv
	v1QxSZATauLkB6pVS9ODinA6IN870KfapCivhJ3Kzjy7mDaKL73rnoVYfEm4outi6WxSuOyPILv
	aGVXBx77P5HuL65Lp83H8gRxdrXL1Ls8EkEm5UvtJSfK1RYWUWaua6j9OR6kI9SL5URASjGOXE4
	/6oYurehRWObFpWV5PvX0jVApU0K5ABj7FhoS8akkFMfcG0XDxB63dGjnqdcie/ylzwQif4DvpV
	ANXLzz30CXRu/NPB5Nj8oJCbomnnKwkP/aMbE9a7ZrPmolK
X-Google-Smtp-Source: AGHT+IG4o1Cr9XMNOBdkMAFSNGaF+u2R1n7WfuDDEvMI/CsWeZTCMB/GnktAPm3KjYQXvfCmwpe/LA==
X-Received: by 2002:a05:690e:b83:b0:644:7398:6676 with SMTP id 956f58d0204a3-6466a86bdc3mr10343193d50.32.1766448970300;
        Mon, 22 Dec 2025 16:16:10 -0800 (PST)
Received: from ?IPv6:2600:1700:6476:1430:127c:8e1c:f0c3:8914? ([2600:1700:6476:1430:127c:8e1c:f0c3:8914])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb456c349sm48448927b3.57.2025.12.22.16.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:16:09 -0800 (PST)
Message-ID: <4cb74f51f29a4aaad6cf4bfdcc7c4c61625b6ee0.camel@dubeyko.com>
Subject: Re: [PATCH 0/3] nilfs2 fixes on v6.19-rc1
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>
Date: Mon, 22 Dec 2025 16:16:08 -0800
In-Reply-To: <20251219180631.27554-1-konishi.ryusuke@gmail.com>
References: <20251219180631.27554-1-konishi.ryusuke@gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Ryusuke,

On Sat, 2025-12-20 at 03:04 +0900, Ryusuke Konishi wrote:
> Hi Viacheslav,
>=20
> I'm submitting three nilfs2 fixes as a patch series (rather than a
> pull request as previously mentioned), so please queue them in your
> tree.
>=20
> Two of the three involve kernel-doc issues in uapi header files.
> These
> are suitable for the next cycle.
>=20
> The remaining one, which I'm sure you've seen, fixes an issue
> recently
> reported by syzbot involving the FITRIM ioctl, and is a slightly
> higher priority.
>=20
> If possible, I'd like you to submit this as a bugfix patch without
> waiting for the next release cycle, but if you're limiting your pull
> requests to merge windows, feel free to submit it together with ones
> for v6.20-rc1 at your convenience.
>=20

I've applied patches on the tree. Sorry, end of the year as usually
"unexpectedly" busy. :) I think that Christmas and New Year time is not
the best time to send pull request. Also, I am finishing of creating
the tickets for xfstests issues. So, I hope I could start to analyze
the issues soon. And, probably, we could have more fixes for the next
merge window.

Thanks,
Slava.


