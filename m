Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC26382F01
	for <linux-nilfs@vger.kernel.org>; Wed, 27 May 2026 16:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897761; cv=pass; b=mRACT0Zcjm3KO3D5biFC9TG6ClSu/EUks/NCEaktQJ+mZ3c+ejjEUeenLP+xrl8OcnJRcmaIVr3b8U/hseJ68FHSLRTWb+ITDFmz3nJoYXdjgdxII2QdnvqTSOIXNidYc62MimeX3NVMIym2e3ieLweLMGbH0YVSe/PB+e/aNXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897761; c=relaxed/simple;
	bh=AHt0+86vpId0YnypIvt+8kocwI6bTxlsvlDW/zwRB5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hU03rXLm9i9Fsow/0TptI10V1USZ+X+lKY0Yw2FUpP81lDiOUQLb4+qPwPvQ/VIIOxqSfHJ4+wvKT1knfIXjgRnouZbQB0Ma03RrMVOg8J/njB8pDaAb5IAvdsb1yUP5W3RCli3S2599M71s9/uLypXXam457JhMJ2w2W/4k0QA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6AweTLN; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6AweTLN"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aa2c25c632so6949489e87.1
        for <linux-nilfs@vger.kernel.org>; Wed, 27 May 2026 09:02:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779897756; cv=none;
        d=google.com; s=arc-20240605;
        b=XZ3RSFs5G01aPm0bZbK3qW34ze+BFS/ZbacBfIPaqIYXT+ROBgWfpM9ZQl7OQiROXU
         Jcw0xf+n+/WMSvf4Cz1v/M6FHutJmQpPsLuBK00eNq1pzxDDE6NBh6ssgSbdyLTE12sy
         cGjBuIcqPLMnF6HPhDXqpfF+FS/E2x2bZWj+dQhpiSzBx1ftPGSRHFDKktRnXP0d2v1L
         pdarwOlNlb7Ex/AAOB+IgxrV4lYNoFnvTx9FusRdN9CfcUNPo0Xvn74YVRK8jyMR5GAO
         lFqVDSlPes5Z9wl1vJ3cleeUnYcLBBl6UWIKlXpRjRG2dJyOfp9KdYSnCOqju1OD7Fiy
         PxIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        fh=NXBuf+F41ZuAsYMkMpxRhD45rIFeYeoZaa+RFSvHFMo=;
        b=WActUkampQD3qY9IgodN1p8ZVkPY8BjKk6/EhspsZ9xSnsKfYnxokV44UqYYHeS6eM
         jz3PZ6eEtMu5r3+mFilr3IVjs6qFTGxV1L9/NfbPetYJKFZ7nOBFtpEBpFSH60bYQTkj
         gb36rZNpp1jU9cotFgfCePx3MCaWpJ011lOugLkdfc7Aw4usdd1rCAjr8KGxbEYm3o//
         0qLHSoDFtzahKy+x4TpGdZQ0haZ3pm24LJGuWHWaWkvpun6DhBEbFTuIjkUe87kubTUQ
         k6u/XN15uaBXlcHMaMm27oBPUXW0t5RUmkzjr2gAU8ASYu7Yfz4hGVt9TvpFhx55Gy0Q
         UV/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779897756; x=1780502556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        b=L6AweTLNHy/Z0BzaB6cRHkDYdErwcaMUEx8sJqTCu6h0qBQaMI0UE7aPhCgR72qWxR
         SZBJ7t2RaoXpz4Fldpeu3WtNvtR9fGkYodPHOCr6ktBnEdknHAi631onR1oC5MFvlZy2
         moajP1VpZItzXpnNDN9Vh/8h3PzgP5amoobLKOr4RvS6L4yacQa55e2mV8a00urNt5nn
         HTjaq768EtXo9tfUIVpinlcto7s/5nLIsy4HiNkmZN86ifJim24oHWq+N95dQY3ntf3J
         Z5ZtSXPJv5DKW3uIy9zRs41yXQqczJ0rvHLa8rUvUrd3+qC9SeiuGsQYj4VxNAhx6cpR
         KzGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897756; x=1780502556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        b=MDZjjY4+rCWYI56gfIo+Kv4sgahaQx2kwjbDX0+GSzhzmuSi1QORY4EJ6XtV7mKsdT
         VIMpFniceJQys7uo7QjzlC9uzfuHeikgA056IvU43GlWXThJJ8kX1Tkouk5Uz75jHjWb
         uB4tFsOlghfO315IP7iw65Jw3nt+jPyyZHUUyZAN0Z0pJsPxqDmbPIjLc1op9wyjd2l3
         ch3/YQ6cMMAc2xbwP7/1HpOwYbXnmP/l4z3/TAIlRhiXlRVJf8cuwcxUyqn88Fmni1gv
         OwH/h5iCxEBZCzKsCC5KN8M5fPOmBoP7UxsJ7LSNLn57HulVR6DGPx8KlfUd3VYXnVJe
         hc5Q==
X-Forwarded-Encrypted: i=1; AFNElJ/p1GRBkEqbB/CuW1MpmaCywE/EZ826z+JwFO3DzzoM7TUww9u26VzmyAYs6GQUG905PIQMQKZtArPeQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0FlQPiiV3iGzMRzQpK/p0YSwXn5D3ktR0pcZ7nY9OlirZako3
	IaxXaJBWQF5E0bACuUtnbiX9nF68P18RnQyHrbeemcVQOFk4SwavE5RBv11xAiZsG7S/E0tCldi
	uMG/fOreazkO034vvU7r+Y031/nfj2Vs=
X-Gm-Gg: Acq92OEGpityls2K2xreZzN54bZB0OukkGCodsKa2YgwV3CcD7kD3jwRi0gcm7iUZhI
	WOUtMNDEJLKJ46G62njx2VZmoXSiK8F17B9r8F3LM98qyK8nRMmLNu3cEiXYwTvcTv6m8jSs9GM
	un8S3vh6jRmlyEJm8JLjRO2uk12TUBK56gQCBYNhLtt0aqJDAhJwpLUtKYeVFGjqOgMDchB5LFF
	LVF1Og9tGHyYnMHQvQjzQZjgAE6vwocP814MXOfTPAaoRHX7rkNzjqQEkb7ibY3xw9cusJty0km
	e0qk7Ppt
X-Received: by 2002:a05:6512:1082:b0:5a8:96cf:c8c4 with SMTP id
 2adb3069b0e04-5aa3232a140mr8148267e87.15.1779897755653; Wed, 27 May 2026
 09:02:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org> <20260523-b4-fs-v1-4-275e36a83f0e@kernel.org>
 <1bb537f6dc36b00788b613fb8f71579478418457.camel@redhat.com>
In-Reply-To: <1bb537f6dc36b00788b613fb8f71579478418457.camel@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 28 May 2026 01:02:19 +0900
X-Gm-Features: AVHnY4KetSSI45sZ2YEgAEZTRsUQAA2DaTD5AcJyh7fDYB4FmiHhDhxOxGAj9DM
Message-ID: <CAKFNMokr_mk8xhMQ7u8RGRd1XPQSSd_uVKXR=-ui5Zjk8AhfTw@mail.gmail.com>
Subject: Re: [PATCH 04/17] nilfs2: replace get_zeroed_page() with kzalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Viacheslav Dubeyko <vdubeyko@redhat.com>, Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2026 at 2:07=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Sat, 2026-05-23 at 20:54 +0300, Mike Rapoport (Microsoft) wrote:
> > nilfs_ioctl_wrap_copy() allocates a temporary buffer with
> > get_zeroed_page().
> >
> > kzalloc() is a better API for such use and it also provides better
> > scalability and more debugging possibilities.
> >
> > Replace use of get_zeroed_page() with kzalloc().
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  fs/nilfs2/ioctl.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> > index e0a606643e87..b73f2c5d10f0 100644
> > --- a/fs/nilfs2/ioctl.c
> > +++ b/fs/nilfs2/ioctl.c
> > @@ -69,7 +69,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *ni=
lfs,
> >       if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
> >               return -EINVAL;
> >
> > -     buf =3D (void *)get_zeroed_page(GFP_NOFS);
> > +     buf =3D kzalloc(PAGE_SIZE, GFP_NOFS);
> >       if (unlikely(!buf))
> >               return -ENOMEM;
> >       maxmembs =3D PAGE_SIZE / argv->v_size;
> > @@ -107,7 +107,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *=
nilfs,
> >       }
> >       argv->v_nmembs =3D total;
> >
> > -     free_pages((unsigned long)buf, 0);
> > +     kfree(buf);
> >       return ret;
> >  }
> >
>
> Makes sense to me.
>
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
>
> Thanks,
> Slava.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

This conversion looks reasonable and won't affect the behavior of the
ioctls that use the modified function.

Thanks,
Ryusuke Konishi
