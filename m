Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27146378839
	for <linux-nilfs@vger.kernel.org>; Thu, 25 Jun 2026 10:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782384209; cv=pass; b=nPJUVdF5luOn06UA2H3FMHHGSUGe3sHI+C6/twLyYHAEe0K/NNePXbA350W7zmIsIWOccI7AGOlN25CTzk8ecyiit46+iBm44+HPmXAU+sUJsNu5Ga/DsMyW8h2HorTKYnjDvrFmGQTT83JaioL6wmeip35UTSoy9X164D3v8Ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782384209; c=relaxed/simple;
	bh=L+Tww66Gi0HVQyfEXxt/Mm7D7qY5CI8GyF0pFTLdjAE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ieex7SvKxwos7EIebgvMCPAxB4oa/oR9Krikh8gamYLIeRq87m2KtD2SP08JMmMQtngl2geMEwzDsPJMXLf6LPY4b5ZD0KGSGN8sDHdZs/aNgaOmqc9ihjz5cgF2xjdFxmJBDGeoW9nK/Pp2lF6cZtLhQdyO9+scDxhAWYCywHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T1/yLG6s; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T1/yLG6s"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5ad4a5647e5so1982606e87.3
        for <linux-nilfs@vger.kernel.org>; Thu, 25 Jun 2026 03:43:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782384206; cv=none;
        d=google.com; s=arc-20260327;
        b=Hi+EHcGgCCrGSfjHvrSSqHD7mtTTtenZ1eh8UN1NuTGNbStJm6ZBdcduA8bs0+iJgX
         2IOe2X8Uv57JsTAK4PYEqOvZsWXtHyVKSLN+EW+RoFMvW10Gkb53+TuI8E3jAJgdpiOu
         zeTRNuKQ1+gMFBfq3S+mI5PpzkC80E+TtZN+X4Aujx1NETY+eMz6DAQewLght9BaAuMx
         M6oOIqvYcOjj7r0K/bUTHzsNDSyAGHpTeN/NdVSk8zNf5a+pDMuJsigN0W8Tcfe0zBTi
         ioTUxJ/iBLXEsjJRqnLhYEki3hCxZY2U7spAkeksHWhPt2cRL+e2vgCi/Op9lL63GsFd
         ZVzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V0o9GExuR0Ux+TjU9F9sF0wawXg9XX0jF+jaTnMVqVA=;
        fh=VhRKeBzoI7mJuYXp4G8ZzT379qig2qhx7m/u40LWS4c=;
        b=J2ROkVlwV0q/GVVax+deWXRZ0mrUloPBPW1rFQvx7SYyFqIg1VFCW3REbxCrn2Gf8S
         BHBfmlkrjnm8jvjgRXNtAz09uXCxV106nxA06+q3vH7hQANnhkcnTnbVVOsLjtefR5m6
         /CxpYGEUi78UMIrWDHkNBNdKYoRn6kSvXIG2og3tLNkYEkwMf7KOEOyYiFLffXcy5mBz
         QtWEIP90Xm2Dc4BxtB9EnyGTU3Lm1Jc8a/2GHVGNliigu0kVMuNK1AmmkzgoVG0YPVnA
         C2t5CwEpKfdrg24SCtNVQvgxFgeq+/C4XmzZG07v1CvWVepLawYj1PPArxAOZjWiVQmQ
         bOLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782384206; x=1782989006; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0o9GExuR0Ux+TjU9F9sF0wawXg9XX0jF+jaTnMVqVA=;
        b=T1/yLG6sIJR3k50A4UWHgMIQ/14Kt7riBRCyosiQ/dL12W7QXUOJWcA8cQa0dhxmWX
         c+6G74zZOWWytY47muynKCyDrBTX7jIONQyPaRe2h0T2jyKGNCSnM+5xcb/KNJ+RS0a/
         Zb+lp8F3Ubz4LLq57yRZafSpt5hResKmuIOJzNRtHKL/7BIFY7ulzUKGIvTcedmfiK65
         O9tpXyg5f4yIQFcVwKdHp0cou/xotGhOM77NvBm3gnLjuPCBPPTHE0mQEyZ78ulckvJR
         HFWAkdYvfytNpeMQW7AOoIShr4Im6JPGjeQhwyhMjDn2UdO6AQzqHZUcXdz3vSwamPbk
         cdZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782384206; x=1782989006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V0o9GExuR0Ux+TjU9F9sF0wawXg9XX0jF+jaTnMVqVA=;
        b=EfjkH9cQVv4/uX1L6vN+gI7EIdy0oV4jqOKAxe2WZO0O33jd1/FdGkm+Xt2Ppr9Zna
         pMPxGleygNC0i7SgD+D4nqivPWWi9GFQbNZwqd06ZxT1unyCB97ColMELQ0XmQRqf5eK
         a03+xozdIYhLz7hPlaz+y/7GekcLrghWmFicMm0zDcADTJsaUvjoDIorUyUSjoknJM7n
         04gDS1kekoCxdibr5sPLU5MX0Aga7cnNuVTbt3740VJMJfI0XSOZHLHunIx0P5M3kpZc
         qWiaj3yMRXqIgj+LsgVM17D8EU9RGRDb8tyYSAaW82/dJyOxSbc1pC599ov0apXvuV4q
         nbxA==
X-Forwarded-Encrypted: i=1; AHgh+Rp8sPrKqIOF2tLCtXXLH6prz62IUf7v5KVv6XRmTIiET18b6xi5+6Ia3B/u4TtyMUcX0th4Z4zYVX6W2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHYh4IBHZtDc7WRXW4UEEBfRfPFor93TCDIDLNy+9BpVyI0Jfa
	vAvuNGYFxYo0KoYg85Nlqxfy9L5z4RjSe+tANXINCcf+bRbxxdk9OC0yaPvOKqSBD+0Fj+hxDo+
	UTAj9gqip2jqg7PQoxB33gWuv8D3ZO/Y=
X-Gm-Gg: AfdE7cm9x3lqKfYQxxDDHbZ+Tkw5/6RUN5CaM4DrzWp9uVWgeSrzYW8pUmew/tsLNkx
	tG/iyFuPrAnNCrsyk24uf+HGeFUTkeFVmg+VEa1LUgJWNMVElUm/u8UxkWGocI236CuHF+Avp+W
	0aEWuBVf+XaUsrWgWTQGQCsIEK6pWlQCNGOQt9BpPYn+39Ck6jd+PBbXzN8NCJeZWWLKrRJL079
	xkv7CmmS2bX7Mc+5NdWhn7Uj47KID8lsEsDFmK6v5DrKer2hIJ9dhmRn0Ij5U1WgYQctW8AoQ==
X-Received: by 2002:a05:6512:4203:b0:5ae:9d23:2887 with SMTP id
 2adb3069b0e04-5aea1f4b643mr628542e87.32.1782384206066; Thu, 25 Jun 2026
 03:43:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260625052639.241024-1-wuyankun@uniontech.com>
In-Reply-To: <20260625052639.241024-1-wuyankun@uniontech.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 25 Jun 2026 19:43:09 +0900
X-Gm-Features: AVVi8CcfiW5fTtqnEVzGSXN9sbb8rOuWi2o7RvZ_4l7TE7UxEzzVrF3kP1SbbjM
Message-ID: <CAKFNMokkDqSYUzNkmvztUHx9U3YWPOdYmJ-9xkkQMnutN6H-ug@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: prevent double insertion of b_assoc_buffers in
 dirty buffer lookup
To: wuyankun <wuyankun@uniontech.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 2:27=E2=80=AFPM wuyankun  wrote:
>
> syzbot reported list corruption caused by double list_add_tail() on
> bh->b_assoc_buffers in nilfs_lookup_dirty_data_buffers().
>
> A buffer_head can still be dirty and not under async write while already
> linked on another association list. Add list state checks before enqueuei=
ng
> in both data and node dirty buffer scanners to avoid re-adding already
> linked nodes.
>
> Reported-by: syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Dc37bed40868932d790e9
> Signed-off-by: wuyankun <wuyankun@uniontech.com>
> ---
>  fs/nilfs2/segment.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 1491a4d4b1e1..09202d155903 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -741,6 +741,8 @@ static size_t nilfs_lookup_dirty_data_buffers(struct =
inode *inode,
>                 do {
>                         if (!buffer_dirty(bh) || buffer_async_write(bh))
>                                 continue;
> +                       if (!list_empty(&bh->b_assoc_buffers))
> +                               continue;
>                         get_bh(bh);
>                         list_add_tail(&bh->b_assoc_buffers, listp);
>                         ndirties++;
> @@ -779,7 +781,8 @@ static void nilfs_lookup_dirty_node_buffers(struct in=
ode *inode,
>                         bh =3D head =3D folio_buffers(fbatch.folios[i]);
>                         do {
>                                 if (buffer_dirty(bh) &&
> -                                               !buffer_async_write(bh)) =
{
> +                                               !buffer_async_write(bh) &=
&
> +                                               list_empty(&bh->b_assoc_b=
uffers)) {
>                                         get_bh(bh);
>                                         list_add_tail(&bh->b_assoc_buffer=
s,
>                                                       listp);
> --
> 2.20.1
>

Thank you for the patch.

This patch adds a fix to forcibly avoid double registration of a
buffer head to the list at the list manipulation level.

However, we need to clarify why that happened in the first place, and
what caused the state inconsistency that led to this double
registration.

The search routine for dirty buffers performs a gang lookup for dirty
folios, registering them to the list in ascending order of their
offsets in the page cache.

Furthermore, the construction and destruction of this list take place
inside the log writer, which operates exclusively. Whether the write
succeeds or fails, the list is released by nilfs_release_buffers()
(called via nilfs_destroy_logs()). Therefore, double registration
normally does not occur, meaning there must be an oversight somewhere.

As this issue arises from calls made via the GC ioctl
(nilfs_ioctl_clean_segments()), the underlying implementation flaw
likely lies there.

Since it seems reproducible with the syzbot reproducer, I will also
trace what is happening to verify if this fix direction is
appropriate.

Thanks,
Ryusuke Konishi
