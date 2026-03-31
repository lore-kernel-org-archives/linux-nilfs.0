Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8162727FC
	for <linux-nilfs@vger.kernel.org>; Tue, 31 Mar 2026 00:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774918052; cv=pass; b=cE4z+lY15djsBcD2EPjuvXefItCv3sVm0nXTVmNrYBYVu2B3sDiwR4TovL5Ui7dVHflZhi1jC0j0+c7oAkAdXB2Jj46OQTpHKn/QmzNkQrTr1CU9/2o3tKBIDfu8cVz5zkPGj72/NOLPOJvrDeWvyMlvVc+tEc8hhCtk99G8wss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774918052; c=relaxed/simple;
	bh=CqD6y05Kj1qHC2NVxwyO3FlXqLyTH06MLp4i1n1SU0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Izfq0PNsl7QkAq/+dgz1NOXL7WqBvjmS7fr9LMnq/GMYrnlTt/TGGP81g8sikyPEvVHx2TvZ/K6nc8aq2uugzJSV80eNTrKRa+7kIcFdmMAQohZicET5lNmTVUVClLKNY2wyWkrY4Xn/Yicev8XNlGtuVup4qVr6eFv4D6J/usY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d9r2vL02; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d9r2vL02"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6501d242e3fso3030303d50.0
        for <linux-nilfs@vger.kernel.org>; Mon, 30 Mar 2026 17:47:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774918050; cv=none;
        d=google.com; s=arc-20240605;
        b=DgFyM4m8bms7/F+EPeWy+xjJm/J8ojnsmGjbp2U7+/erxPIx9kqabVlw6+KQ+ety1R
         jxRNjUlar+jXySLYzxc69mtHFnZ3/BgxKQQfjMsBgeSXi2lAOIJ4gOojsYdhkpNa1DoM
         Mt+hI2ABJvTlbumM68KvJn4my9VS9/5uco61mSwylANbkJlZfhkbNSuEQCiOBBhKn2kA
         c5HColtxLbgsr8BHCn/oqHe4aueEs9KAXsbUqdPyQs0170Kd9Z0GAdYgUloeBo5FM9jw
         NVqGcuP5SzR4kaN4D4W8e/KSVA8t7bqdVtyTmAY7uslgtYCCLdzxSo6sjfXzizwPRDkR
         QeiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SHefEe3ELaF4oq+MFReBWulz5lEMbeNmeroONvLID5w=;
        fh=QWAZHd7RO2RFjJKVJXfLlsOu0YWs4pOAUWXkypOUWGE=;
        b=B4lLdBwkj8nhx7sYQblpMGIjY4i6/xspG8saN8YsLJwriuns14YOlsLmpAT1Z4Q8DJ
         l2rfAvqtE02uAfwQywP7fhEZ3Mdd8dUFMhcoe/NOmzy8C+Iad4Yf7wY4dCFX0Y7bZhRF
         pqekIKFOFZv+RS9o/D7jR8TQU+ZZbzFenXiXxgjbmud19Yu36QOG8jpUM2MQ/+rK96gL
         mfKiVL13u9p5xpL3Z5//Q8IgywehdKvud8sP7Vij1fcL1eaTX6GEoZdGLegjGO9LLTC+
         qAYcdeBKaZ0TIY2hg3nBZ/6G34LL6knv7La0NRmZ34pEsJByL3mIdpXVkvH00kFLCBUV
         Pvlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774918050; x=1775522850; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHefEe3ELaF4oq+MFReBWulz5lEMbeNmeroONvLID5w=;
        b=d9r2vL02T7XmFERJJdUwTgx5X5KseSScO1AuVGxSs06ocowbxnXPSTCSi/NPYoQGpD
         LThyd1cGZ1V7EAapcyH5WlM3NYxT8mt7bp85TvDIt75U5yEc8gM7suiri3tZzcUlyJ5P
         YnhkO8sIkBdtCum6MjCj6hajLE25jLlWoNt8Q5RuQsqzklY0QqGWKA4rUW2Ui0K4WVKa
         Nney7xCjDjesCqYYEBEU6Sg6WpXMhQy0zaeJWvl+lrFwdDXT7ag8qmQ+Xck8kM5xHDei
         oBks47Tcae6WyeI1fGFRsfnUYY/lR8hjQ+PG/kyjIAXfVM+KCEiBkqg7vfsVfPJfAmAk
         V1NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774918050; x=1775522850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SHefEe3ELaF4oq+MFReBWulz5lEMbeNmeroONvLID5w=;
        b=UCDVHRUuABmtjHsfgBcmxPfqAuGOt9uU41VIzv+6d9hHfRGvCVTWT+9kRoKFK3lmU9
         iSAyVktfq2yh4US9d2L4ETBBalLGJ1MA4uWTXStTfmEbT0S6RG1X+W1XBLX61Y2ISZ1r
         hw5zSDW44h4gXaRM9lNSYv223Ai55LXbaipsTw+xZJwYg+d3C8SNFYWauClDQAfA2bkq
         e6TJlvFoj2o2OjQ86mOCy+feQnxGCDV4VB1Mj9npJJIZ3Zf6EGeJsPqd2SrNU4p2I3Mi
         UgIKjLIWEbPdrsJbAn9nALGGCCT4BrmJKc2UV79oGKREOosjGD0TocgQZA8c3VTGexnL
         yR4A==
X-Forwarded-Encrypted: i=1; AJvYcCXeRnbLLUVxmJIRhX9Wx/Fy5qsGXnivfmRyPT9r65jaPpr/DUTPNRLw0z/C3xgxPVv2TJeZRYc4woz5eg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSyLX1XFxl9A6zxscj4oJGu0rmVlHxMjuJvnrqIy0cw/iB0bfz
	e+9hgXbJJXObkD3YrpI7ezmGSQDrT61Tr0aji8GMjewq3/T3TCFRlhPDdfiHE3siQAAAsxEaDeD
	8A0WhZnfD8dLr8AksQsJ6h7Uw0mq1Uzcrq5Sz
X-Gm-Gg: ATEYQzwH1zHo/GnLSn8efDtNrf6s2FedeUeyzI7SG7hkW65nm0HZS9EiIq2EAflwWHQ
	AEuJcO5YK8O78JuDEpcqDAVdgRpvJNthZrsWQ0dCgb9FUb9F9s2ZiZmZCxcMhffVKPP574QpgKq
	I2Cg1AEBU/jIY5hBcPl19VHtrHPRpi8FLkHqmxm+k9sDbHuT0MgNjZVOpvbdeL5+Afo+zqQ1c0W
	mWrmXxbZSx1wWTTtGCMS1jT71Tz2XUJrQ+EgcDrGedYzlrmzCcgV/fS2Q0rZRccgDX4rs/FY1jO
	cUGFagwyPs0wdDhaBofxr5x6+5L9hZglJnehdPKxkjgUjtFHQFj5pyZ3MFhgzM1xmtHMXZGS
X-Received: by 2002:a05:690c:c4f9:b0:79c:c51c:7f57 with SMTP id
 00721157ae682-79cc51c845dmr108727257b3.27.1774918050428; Mon, 30 Mar 2026
 17:47:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260319091930.1088735-1-kartikey406@gmail.com>
 <CAKFNMo=Z2wsL5za0VUeYh23nodPusUCC9WasSeR5BHc6tEBu1A@mail.gmail.com>
 <CADhLXY7CyKubhVgSc1ptjL0H_5A5N=uuWRKWpf7rJbFCxySRCA@mail.gmail.com>
 <CAKFNMokwd5aeXROH6sLHZhO_7FvCmivquntJrzJbvfNYkn-dDg@mail.gmail.com> <CAKFNMo=HUZ0Zuwh5yzAgjNUfsrpuvGeaM2-nkenrm9W9sbfGPw@mail.gmail.com>
In-Reply-To: <CAKFNMo=HUZ0Zuwh5yzAgjNUfsrpuvGeaM2-nkenrm9W9sbfGPw@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 31 Mar 2026 06:17:18 +0530
X-Gm-Features: AQROBzDHp8f8AS8Jj4zV4UlxjsuFM3ZaNkvznfi8nZLIGZGFZaSSAfamdOT4tIA
Message-ID: <CADhLXY6n1WwaTsRxJusvHxNw9Zdabst5FPZREuJnMgYSB+h+tw@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix missing continue after -ENOENT in nilfs_ioctl_mark_blocks_dirty()
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Junjie Cao <junjie.cao@linux.dev>, slava@dubeyko.com, akpm@linux-foundation.org, 
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+98a040252119df0506f8@syzkaller.appspotmail.com, 
	sato.koji@lab.ntt.co.jp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 30, 2026 at 11:39=E2=80=AFPM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
>
> (added Junjie Cao to CC)
>
> Hi Deepanshu,
>
>
> I checked this and found that this fallthrough was intentional, aiming
> to detect and skip a dead block by the subsequent comparison with
> bd_oblocknr.
>
> The problem is that it does not reject cases where bd_oblocknr takes
> an unexpected value of 0.
>
> This bd_oblocknr parameter stores the location where the userland GC
> library found the target data block or the target intermediate block
> of the DAT file.
> As long as it is valid, it can never be block 0, which typically
> stores the primary superblock and others.
>
> However, due to the missing check for that anomalous value, the
> corrupted ioctl request pattern generated by syzbot triggers the
> assertion failure you pointed out.
> I think a check like the following should be inserted at the beginning
> of each iteration of the loop:
>
> if (unlikely(!bdescs[i].bd_oblocknr))
>     return -EINVAL;
>
> Could you please restructure the patch in that direction?
>
> Thanks,
> Ryusuke Konishi

Hi Ryusuke,

Thanks for the clarification. I have sent patch v2

Thanks

Deepanshu
