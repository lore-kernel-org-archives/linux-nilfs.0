Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3B32367D9
	for <linux-nilfs@vger.kernel.org>; Wed, 27 May 2026 17:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779903934; cv=pass; b=drxtF8+hj5MiQx/uzfdPAFKLpdObCUNEAs36CwiLAhwxdTa2UP1cgQSziqPeRNc2DfUOG11ZjpZj+F7fFWXQR/XCUgE3aEp+nltqJ8axLAW7Y1L1BuZ3DHaZoFsV8KEddTj2DOivR1ZMFZFiozYqk1Yf9R/7VTPgljW9nCbPcQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779903934; c=relaxed/simple;
	bh=b5hC+lCUmxhklhZzKQ1tvJz89R/bn00ZL3r0t0qYg7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YOzNl1MFKL9htWuq4cl273o2M5000Xmv0jZsQky8hIyxIfgW83dqelbQpop6LoOvZFpZpf4ZT+UfGFtLrgh152foLir2L2lxYicQcJvNQJXW7M+gLmHn906W6KWbP7Ee/rJlgYQ0oBKANKnC/KWVk98GbogvKpMc6Il38/g8rWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P9V3rrGa; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P9V3rrGa"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a995ab70d1so14226454e87.3
        for <linux-nilfs@vger.kernel.org>; Wed, 27 May 2026 10:45:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779903931; cv=none;
        d=google.com; s=arc-20240605;
        b=YJPmzvz30ruJmir+D3NI9K+i4pPbXXa6GlW4x6vPLlX42PgRHqy69EVwLtxwRFZ/hb
         Zgq9a3hlfi7Na53EMSeK6JPZhVX20XAy+jmpXBseWFYfhjVMx7anQMSNRoVaJjmQWZE+
         PZ85hT0CwQgsFnfYKLPls9sSF4xoAf/vuRAzfQtCP/IHAGAgnbTP4MkTtSjzOLySm7QO
         zviTpiX+YREgYpwfObw6MSZeEoXJkbeTF1lWE88GDcm67PQvQ0Wx3DdFvdem8XCig5PA
         pQ+WgQU6CEwg3ZJ99b2zkYbSDUAfriikHdA3dUWu4BbarzLG+CDRZgQrV5/G8bPahnnd
         4+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E2KbyWfoe1K1NYU8w+TYnSm8ZSxgqFTHuqB6tEIoUF0=;
        fh=5bUvH+1qRzRteQ+us2svhEaWwih4Do6IZDzNK6SmKQI=;
        b=d7HQsszhRmxR3//zh4K4KCuNVcmftiCKXBTTWH9nxX6R1iaFX0sKJYlMUJf3poLj1V
         9YZgQ7Jq5WGMpJGCul1qI9f3girlBws+Yil4Mwu1ZfFYvdnqucIFut5bOMDomWfvw/b1
         OG1xG8fJGjCphOCLoWLdUCDBA3ZHSbTeM6432y4eNA6dAKOz5UTXSw5qu/vb02Z4gei8
         pGscvWMabxotWFWl/UVpomO9j3ZQ9X0u7bCCKUC5EN9Cr+/8WXjB2f+R1HSBglSWsAUC
         k1VOTpGqS+GnCtRj2uCl6bHc+23wNNbjrhjuOKBcJKx2qa5woq+70DNsXY698nfOrgbA
         uRGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779903931; x=1780508731; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E2KbyWfoe1K1NYU8w+TYnSm8ZSxgqFTHuqB6tEIoUF0=;
        b=P9V3rrGaxoqaustcnTp/oy9PRz6sB8mg8/rgbR+jfh1nYSIEFgsx2sKnzsl6ABKGq3
         1U/jluIpLM24MVtF0mfDUVkd+FpooD9M10/nS1yoXstICmFlj/wDaLp3F0J05H5UjcpO
         mYesMTlVf0QagYQJ0zljUWkNQ+eTRYC0dASdmMnYcfUVJsLJdf0spgJpjKFCG+1aVMxO
         brFL/mj92sj3rd3lvpAaOPiQcYS8IhacurhEu50fzTGx7U8mN36dtprFNaPi6Pq6hcDy
         1ep7sB76yZGAUoHjdJ8ASmsmSsfnAbXbfRf6ZkYfeP14r6j7uOIfWjA2NGnNZaGhybAY
         ovaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779903931; x=1780508731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E2KbyWfoe1K1NYU8w+TYnSm8ZSxgqFTHuqB6tEIoUF0=;
        b=cgDHZfXsQVGORQXTn8Uraspiw7cuGfn6/F6e+9VQ4fR69sDmqc4YBsOY+8+WNwfDYI
         4+Nml5TdFTpp5xLVNoDPWfIECQMugEPnp6546YZfpLTP8VO4gu6NDyKbEO5wQaRGjGQK
         8oX3Z5qaZNVOMmiRl43Pp/iyVeGF9unTnejuhNLLG/jOn4HehG5Moq0i4sCtE6lq5s4k
         muQuYZcrXeq+ovB6AAcONXhag2DW0ehDBJfduVvpou6K0H0tGFZZk91Q3/qdmgqlV6jX
         zEMV9ZgC/HNiRaB8KwwlXsdyG5BoZwUkGHDqNOb0TNXN/HUztYlfrz3pM6ed1McO/+Yj
         0hlw==
X-Forwarded-Encrypted: i=1; AFNElJ+gzykk/uOw5B/Q9629ohjHLctBXuq3mOhd3EImdAhnS93VzPel35HIuTWLCQd848FC8DAR3ChDMLcMmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLUWKHQiUGL8YgJILXHwwoRXebjjMMiXOEKbBXe5OjEB1mtmEt
	X+XGNp+l6n49YiQkT3D6ecAbc1ddv+rj4kCH2Ads7wKjMTvlkYFTgGtGEnZWfwCLhrGJbSnnC0x
	ZON6i4hG7x6ggcjq8MropMdNki+jRxWw=
X-Gm-Gg: Acq92OG9RjE7OaPxycqTC3S6NBrJIxnoJ3RuahPrxBNs0V9x0EiunCgAOrYLzvDxriC
	2/0rG2ZeFFffbmQTrVgBHwoHCBDorlb74shWsdK4gdwj25tBwNLtRyGnVhsd/kdoMOsB949Hz0j
	H4LeAO5ykzoWQbk7AIlyAYEJuUaY8YzMd68QvdTB85YFA6r+hcDq8kt+1cwE5SHn9zt3/n8FrD0
	PjG+CocZggwP1LLnUxxsalnIwl5wdxDCnCUxA26VJkZnA9Css+ii92fBMtGQalNTQKXGDNXcpm3
	tZL5cgYbooUYroI5n4Y=
X-Received: by 2002:a05:6512:3e16:b0:5a8:e367:4ddf with SMTP id
 2adb3069b0e04-5aa323b34f1mr8807488e87.16.1779903930710; Wed, 27 May 2026
 10:45:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260525171931.4144395-1-willy@infradead.org> <20260525171931.4144395-29-willy@infradead.org>
 <41998b761c6b7968016365f499b1153a26c7cf17.camel@ibm.com>
In-Reply-To: <41998b761c6b7968016365f499b1153a26c7cf17.camel@ibm.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 28 May 2026 02:45:14 +0900
X-Gm-Features: AVHnY4J5Cw6CRKPOH6YrvrOO8Fewrh5g6EQYJ4AEzdxZ39HZEQdRbm2ltBqv68A
Message-ID: <CAKFNMomK_ZXx138bzRW1=fwf9S7=vM8EseYX1BuTyYRhG31J0w@mail.gmail.com>
Subject: Re: [PATCH 28/34] nilfs2: Convert nilfs_gccache_submit_read_data to bh_submit()
To: "willy@infradead.org" <willy@infradead.org>
Cc: Viacheslav Dubeyko <slava.dubeyko@ibm.com>, "jack@suse.cz" <jack@suse.cz>, 
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "brauner@kernel.org" <brauner@kernel.org>, 
	"hch@infradead.org" <hch@infradead.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 27, 2026 at 2:54=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Mon, 2026-05-25 at 18:19 +0100, Matthew Wilcox (Oracle) wrote:
> > Avoid an extra indirect function call by using bh_submit() instead of
> > submit_bh().
> >
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: linux-nilfs@vger.kernel.org
> > ---
> >  fs/nilfs2/gcinode.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
> > index 62d4c1b787e9..f979dc9d04b8 100644
> > --- a/fs/nilfs2/gcinode.c
> > +++ b/fs/nilfs2/gcinode.c
> > @@ -83,9 +83,8 @@ int nilfs_gccache_submit_read_data(struct inode *inod=
e, sector_t blkoff,
> >       if (!buffer_mapped(bh))
> >               set_buffer_mapped(bh);
> >       bh->b_blocknr =3D pbn;
> > -     bh->b_end_io =3D end_buffer_read_sync;
> >       get_bh(bh);
> > -     submit_bh(REQ_OP_READ, bh);
> > +     bh_submit(bh, REQ_OP_READ, bh_end_read);
> >       if (vbn)
> >               bh->b_blocknr =3D vbn;
> >   out:
>
> Looks good.
>
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
>
> Thanks,
> Slava.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi
