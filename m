Received: from mail.inka.de (quechua.inka.de [193.197.184.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4B6212D93
	for <linux-nilfs@vger.kernel.org>; Fri, 10 Jan 2025 18:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.197.184.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736533564; cv=none; b=m1cCgI94Fa8QuO9snuenAY+pVF5q7F0IW6pxq9l6wEBxEWIkzIkC/556DK1ShtJ+XGfHD1aytQKr1nIqFUQYcW+aawbLOKu4WQILT9NtEOwFQJ3UQ+VqXcPnT1/oX/5HTwNgwk0prqqqhy17q6LenkKNZvoLbfP55aocCMcD9ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736533564; c=relaxed/simple;
	bh=1siNrF7WEnFs3vja1HpzsUurx6y0JQzzzi9ih7kgoM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T067nAhdRPRm3ElOTNS7UElXHexjaISfqPItad+Qe9ENF9qWSSSvdxI5C2KXGPvC2XmscInqegZ387L5FwRegVBzXVzwmhjh0fxlvuDsY8RFTvLLeUYBst+NrbUkuV2OfYfTbZdKwzy+zNtzxgazfYa6mVkQYzikJWHdG4p3LCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inka.de; spf=pass smtp.mailfrom=inka.de; arc=none smtp.client-ip=193.197.184.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inka.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inka.de
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by mail.inka.de with esmtpsa 
	id 1tWJhn-006bu5-3E; Fri, 10 Jan 2025 19:25:59 +0100
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2efe25558ddso3109920a91.2
        for <linux-nilfs@vger.kernel.org>; Fri, 10 Jan 2025 10:25:58 -0800 (PST)
X-Gm-Message-State: AOJu0Yx1x9jjDU+aPX7MUcLFgxILThswzr1tYSLsmfS8MvAGgg3WCM0N
	h//BuulRewBdO0hx8v/fAdUAejaxdypQ7g9uBHFJLasoqnvE6zpKWNAMXbIZY9D4q1N+kBqBcBM
	ZQj22E0JnXjGIfxGpKkN0xXRwzLNZBeYsg7UV
X-Google-Smtp-Source: AGHT+IE5b4ZWKzBU6G5WLlxgo8c20dda7k8IBQoOVO4r8U60U6tElKF4OQ+DyfBq4Jte50yiZaVMhP3RZsBR/rrhtSI=
X-Received: by 2002:a17:90b:3881:b0:2ee:bc1d:f98b with SMTP id
 98e67ed59e1d1-2f548f424bcmr15557468a91.31.1736533557410; Fri, 10 Jan 2025
 10:25:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+m_8J37qo6fKFUp0wpRuK1FHawXNmCMiEyVYEwpt2Nc3uX5Og@mail.gmail.com>
 <CAKFNMokeyee6PEAHs+zs2OO8gEKftK+_RCt9wYD+2cG6sEqDoQ@mail.gmail.com>
In-Reply-To: <CAKFNMokeyee6PEAHs+zs2OO8gEKftK+_RCt9wYD+2cG6sEqDoQ@mail.gmail.com>
From: "Felix E. Klee" <felix.klee@inka.de>
Date: Fri, 10 Jan 2025 19:25:29 +0100
X-Gmail-Original-Message-ID: <CA+m_8J3Cf5BZUB-c4gVko84FuA0=OtyNCq89A3gJR8-vcTxDyg@mail.gmail.com>
X-Gm-Features: AbW1kvZNNsuBRCwXsvL054drv1WrOKdlrvUc-rU472QeTDRktxPn5bhsYOFM1o8
Message-ID: <CA+m_8J3Cf5BZUB-c4gVko84FuA0=OtyNCq89A3gJR8-vcTxDyg@mail.gmail.com>
Subject: Re: Massive overhead even after deleting checkpoints
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 6:37=E2=80=AFPM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
> Example:
> $ sudo nilfs-clean -S 20/0.1

Thank you! That improved things. But there is still a lot of overhead.
It=E2=80=99s 3.0TB in total vs. 2.5TB actually used by files:

    $ sudo nilfs-clean -S 20/0.1
    $ df -h /bigstore/
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/mapper/bigstore  3.5T  3.0T  338G  91% /bigstore
    $ du -sh /bigstore/
    2.5T    /bigstore/

As mentioned in my original email, initially usage according to `df` was
3.3TB. So only 0.3TB have been gained.

> $ sudo lssu -l

It generates 28 MB of data that starts off like this:

          SEGNUM        DATE     TIME STAT     NBLOCKS       NLIVEBLOCKS
               3  2025-01-10 12:19:48 -d--        2048       2036 ( 99%)
               4  2025-01-10 12:19:48 -d--        2048       2040 ( 99%)
               5  2025-01-10 12:19:48 -d--        2048       2036 ( 99%)
               6  2025-01-10 12:19:48 -d--        2048       2040 ( 99%)
               7  2025-01-10 12:19:48 -d--        2048       2036 ( 99%)

I have no idea what to make out of this.
