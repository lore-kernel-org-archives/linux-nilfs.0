Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7364D4F054E
	for <linux-nilfs@vger.kernel.org>; Thu,  1 Oct 2026 16:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790873477; cv=pass; b=CBmi5088t/ayWpm2JEozaG6ijXv2b73Ebrk47NU9w3+xZQfFbX4notIM2O6wboIaFCWFR1m2vUNY+fqAnvvNX4ITJFhhLxwbaIvws/p7K4U+Z5mOEMVgQvvRhHUNWQWNsupZZreo4s4ZmrUwpTCmVsKGXQqPFfLO5UVsZGXvaAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790873477; c=relaxed/simple;
	bh=4KbqdCl36AIJM/s6WNDAH6sNRCOYLlvAyEdd/stZfyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BAn5UzvHLCSoELG7jvWQ0zvpl1B+Q8uwsJQuJG5huROVDcD4oAodi3roWslGoaSpoZW5vuQdYQLF01RhCRvRraB2U27VOGrFhNBnplcBM9yQPtsENRmG7t4G1aAtaWfyjMq6BmCvTRFJgAPGB3fsy5dcJC8dSt8vnnzeLBdsEak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WMwdO1kE; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WMwdO1kE"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f635552aso5253843f8f.2
        for <linux-nilfs@vger.kernel.org>; Thu, 01 Oct 2026 09:51:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790873465; cv=none;
        d=google.com; s=arc-20260327;
        b=IEksOe8VwHYfgtdml3U/fWWcvmu8OBTiePeP1mc66hoSQI86Tluu2/avvfItivnYZo
         +O9fRbCxgoxIPfC+CVw2ESOR4KpHyTA2mkW/ZSzHV4SFGU9VQhi/KmklkTZLivVj4lVX
         gJ8ILHCqx4elAAmnrnPLQZt4RdYBT5yKm0t/YTdC5te77/BLw8WemVlh9Uk66UUeSRRf
         Wi9eXr9HQBmUuHy4DENXGpGScQC20KHx9pB+5Lvh8NwKDLtKNmfG8/HyjYXtl8a2ixs1
         9Ip8xpVbU88/k/Qh4473GZDjUaVgzKda4jNO13E7C5QT63M+SHWxgsVdvpYkgsofB0J9
         rVww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pVfmr+bCVPJjuiFlgihKj7bw6659VUdFabgbzNd4Etk=;
        fh=6RA+86fliXOp82Fz3ZeWSi8QO0jYcE9/ZUc9d2yxyQw=;
        b=QP7DzaCiQqtlIPk8LQI5vc4OsmBaf/E5VgHeDu2Cw2OEFI99vrZYqMDsXjQPTHah4j
         M3uhb3Mbaqu71SyEsW0IJCGWOOzRSChC0Ohtdg0c3ai9iO5A8yhnO44D0QSPG65j8Xg4
         45Aq5sqBO2GXsg1hROZ3FKDgmejlt5X4dzl8rZ9QtUD29qYegK0wkY9Bv+ww8SVOJPsl
         SFu0u0oSm4Myop42ww3Fdwm5WIiw5c6ADsSG+laRT5vMFp4wgDjS9zBRFtGaEUbF0u1i
         kShlBA1FRmLc2OBtBdvO+yewZ5peDgz84ojgwmG+tLDo3bzdA0vSGlZAkS5x71GKYHOt
         ASzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790873465; x=1791478265; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pVfmr+bCVPJjuiFlgihKj7bw6659VUdFabgbzNd4Etk=;
        b=WMwdO1kEwla5x6C0OTtvp2Qgpo83kvN+gMmM3OiMpzaHpwY72Dh+O5qQ5+ccuKSyL3
         GulqrhPQ+jX4pIhtNkgQSYy5D9GKnal1DmxgPL2bWSSf1rf58OQr56OS7RsOtUa3m6HQ
         1uYpwCG/dYLSAPoo0oFLI0hYsX8AmibYdNXnXfvgfkCmAjc7nvrD/ut3EIodN6F7FdqM
         1r3VaXgAqam4YCJMyIk8KAgb4CPGmBcw4Yvoy6XrrS2/xoXzpIek/PV0/vT8mmT4+8FJ
         LcnpJNvtZwX8wgwT24/KP+zhrxwcwIIrrAPEkQonX3lL8lvtn/4nlV8PbA3vouQX4gUf
         Qi7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790873465; x=1791478265;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pVfmr+bCVPJjuiFlgihKj7bw6659VUdFabgbzNd4Etk=;
        b=1zSIWNCvUMci7yoOvZbhPcSaU73k/i0FQQepEVffu8McNDPZbclpM1dFTedhbQzH2U
         8tZYnfM38gLEOajIIGwFxaTDLFrC810F6X8zpx7H6kNk+JMUzZyACAxLRCijJqCWB2MV
         1vR99tw8bJB+E4QjJHdpItros+yGmS4VaEEEmakGtUlteopXtTmqFT4JXJjJ/afje9DT
         CgHXOJ4f70ef3c634weFhl0pNF0w85J2qi1zrdobVTClUp7MiZdpJZpM1d5OS+oJowm/
         vdfL5ncaeWOBeJ9nz0wrgBXM+3TTJU5vBoM/EhLav3UMM3YyAIRVHN820YOmBcD3S3ZQ
         WUug==
X-Forwarded-Encrypted: i=1; AKwUvByHNVOZcmQ44Enlrx1Gl4vMFjdA2oYLkhHoXHPMs9xKwU37pFNxlyixnpokl6iRm9VK5RzC/9nFlZnaWw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJkKwCCdHU+qgaG+vjK2ByPUm1vn/GViPt9tAehZerGleGXKR5z
	Xrqd0dNlmI1y6JN6YoFCyg/bPUdwyKq5+6DkG5ce5o5iAK/URwLBVz1f8q9mYmO+yiOHyKmvejc
	2cknss8mNn50hmpskaX1AFRH3Epd8D1liCEeW1+I=
X-Gm-Gg: AYBFou3cZqJwKVHhCoUM3Yf8nncPHhdQdwCR/NTXZ0RurZOkVICspeYPSDUzs6T6qH8
	NvO4qaZ8WoWWY5RQEhLd4EmBjmNvABJJFjIzLBlpODZa/JCZ9gh4sYQAkMv6smCu5T1JPmxaUFn
	Qfx7+R1LUsDEFdcPt7EQeb58QpZ58QpYeIwr7jVVuwdTxqA2ISw0Ahy5CvxqG2Dn9t4oOkOi40y
	bcLmYYYu0dED42DHRXNiaSWybqz4T/L7wTzxfKVeLdQ16KmoXPtOI4DZ/nMLwreh0Um4I+vyVEW
	OKulhy2eZA4L40EmfyFnayXgDDuMDzohGpwxHxECZ7Q9Jnmok/p6iY3r
X-Received: by 2002:a05:6000:4717:b0:48b:10af:f857 with SMTP id
 ffacd0b85a97d-48b12729ecfmr349124f8f.23.1790873465176; Thu, 01 Oct 2026
 09:51:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
 <20260930000954.371774-1-southampton.jake.labelle@gmail.com>
 <20260930000954.371774-3-southampton.jake.labelle@gmail.com> <CAKFNMok2oRBaSxmRLOs1+g6LWDbDAcstg1myzRjZ=y6t_mf-=w@mail.gmail.com>
In-Reply-To: <CAKFNMok2oRBaSxmRLOs1+g6LWDbDAcstg1myzRjZ=y6t_mf-=w@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 2 Oct 2026 01:50:46 +0900
X-Gm-Features: AclHuK-QH4x6CiiMZO-c-ecInxGcDu4I1v8EYV3wmHPhdcGlE1U6L-HxHawWJT0
Message-ID: <CAKFNMokQ_iwmSig2PruoncoxqhTNCYrzYSp+KMF=6vMjct12JQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] nilfs2: validate directory position after llseek
 in readdir
To: Jake Labelle <southampton.jake.labelle@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 2, 2026 at 12:53=E2=80=AFAM Ryusuke Konishi wrote:
>
> On Wed, Sep 30, 2026 at 9:10=E2=80=AFAM Jake Labelle wrote:
> >
> > nilfs_readdir() uses ctx->pos, which userspace can set to an arbitrary
> > value via llseek, as an offset into the directory folio and parses
> > whatever bytes sit there as a directory entry.  A position pointing
> > into the middle of an entry -- or at unused bytes of a corrupted image
> > that the page validator never inspected -- makes dir_emit() copy up to
> > 255 (name_len) bytes from a bogus entry, possibly reading past the end
> > of the folio and returning unrelated memory contents to userspace.
> >
> > Snap unaligned positions onto a valid entry boundary by walking the
> > rec_len chain from the chunk start before parsing, as ext2 does in
> > ext2_validate_entry().
> >
> > Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
> > Co-Authored-By: Claude Mythos 5 <noreply@anthropic.com>
> > Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
> > ---
> > v2:
> > - Hoist the repeated nilfs_chunk_size(inode) calls into a local
> >   chunk_size variable, matching the existing style elsewhere in
> >   dir.c (Ryusuke Konishi).
> > - Expanded the comment to explain why re-validation is only ever
> >   reachable on the first page of the loop, and why any chunk-aligned
> >   offset -- not just offset 0 -- is already a trustworthy entry
> >   boundary: no on-disk rec_len chain crosses a chunk boundary, so
> >   chunk alignment alone (regardless of the variable-length entries
> >   within a chunk) is sufficient without a chain walk; a walk is only
> >   needed to recover from a non-chunk-aligned offset (Ryusuke
> >   Konishi's question, answered on-list rather than in code).
> >
> >  fs/nilfs2/dir.c | 33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >
> > diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> > index 8b53802b6..bc8cb21c7 100644
> > --- a/fs/nilfs2/dir.c
> > +++ b/fs/nilfs2/dir.c
> > @@ -231,11 +231,27 @@ static struct nilfs_dir_entry *nilfs_next_entry(s=
truct nilfs_dir_entry *p)
> >                                           nilfs_rec_len_from_disk(p->re=
c_len));
> >  }
> >
> > +static inline unsigned int
> > +nilfs_validate_entry(char *base, unsigned int offset, unsigned int mas=
k)
> > +{
> > +       struct nilfs_dir_entry *de =3D (struct nilfs_dir_entry *)(base =
+ offset);
> > +       struct nilfs_dir_entry *p =3D
> > +               (struct nilfs_dir_entry *)(base + (offset & mask));
> > +
> > +       while ((char *)p < (char *)de) {
> > +               if (p->rec_len =3D=3D 0)
> > +                       break;
> > +               p =3D nilfs_next_entry(p);
> > +       }
> > +       return offset_in_page(p);
> > +}
> > +
> >  static int nilfs_readdir(struct file *file, struct dir_context *ctx)
> >  {
> >         loff_t pos =3D ctx->pos;
> >         struct inode *inode =3D file_inode(file);
> >         struct super_block *sb =3D inode->i_sb;
> > +       unsigned int chunk_size =3D nilfs_chunk_size(inode);
> >         unsigned int offset =3D pos & ~PAGE_MASK;
> >         unsigned long n =3D pos >> PAGE_SHIFT;
> >         unsigned long npages =3D dir_pages(inode);
> > @@ -254,6 +270,24 @@ static int nilfs_readdir(struct file *file, struct=
 dir_context *ctx)
> >                         ctx->pos +=3D PAGE_SIZE - offset;
> >                         return -EIO;
> >                 }
> > +               /*
> > +                * ctx->pos comes from userspace via llseek and may poi=
nt
> > +                * into the middle of an entry -- or at unvalidated byt=
es
> > +                * of a crafted image. offset is only nonzero here on t=
he
> > +                * very first iteration (subsequent pages always start =
at
> > +                * offset 0, which -- like any chunk boundary -- is alw=
ays
> > +                * a legitimate entry start, since no rec_len chain cro=
sses
> > +                * a chunk boundary). Snap a non-chunk-aligned offset o=
nto
> > +                * a real entry boundary by walking the chain from the
> > +                * enclosing chunk's start, as ext2 does; otherwise
> > +                * dir_emit() copies name_len bytes from a fake entry,
> > +                * reading past the end of the folio.
> > +                */
> > +               if (offset & (chunk_size - 1)) {
> > +                       offset =3D nilfs_validate_entry(kaddr, offset,
> > +                                       ~(chunk_size - 1));
> > +                       ctx->pos =3D ((loff_t)n << PAGE_SHIFT) + offset=
;
> > +               }
> >                 de =3D (struct nilfs_dir_entry *)(kaddr + offset);
> >                 limit =3D kaddr + nilfs_last_byte(inode, n) -
> >                         NILFS_DIR_REC_LEN(1);
>
> Hi Jake,
>
> I ran some local tests with the v2 patch set and noticed a boundary
> issue when seeking into the middle of the last directory entry in a
> chunk/page.
>
> When 'pos' points to an unaligned offset inside the last entry (for
> example, offset 19 inside '..' in an empty directory where 'rec_len'
> spans up to 4096):
>
> 1. nilfs_validate_entry() walks the 'rec_len' chain starting from offset =
0.
> 2. 'p' advances past the last entry, so its address becomes 'base +
> chunk_size' (e.g. 'base + 4096').
> 3. The loop terminates, and the function evaluates offset_in_page(p).
>
> When page size =3D=3D chunk_size (such as standard 4KB block setups),
> offset_in_page(base + 4096) evaluates to 0 due to wrap-around.
> As a result, nilfs_readdir() resets 'offset' to 0 and re-emits '.'
> instead of reaching the end of the chunk or EOF.
>
> Could you adjust this so that reaching the end of a chunk yields
> 'chunk_size' (including cases where 'chunk_size' equals 'PAGE_SIZE')
> rather than wrapping around to 0?
> This could be handled either inside nilfs_validate_entry() or by
> detecting the wrap-around in the caller and rounding 'offset' up to
> 'chunk_size'.
>
> Also, when revising the patches, could you update the AI attribution
> tags to use the "Assisted-by:" tag format as mentioned in my reply to
> the cover letter?
>
> Thanks,
> Ryusuke Konishi

Hi Jake,

As a quick follow-up regarding nilfs_validate_entry(), I think it is
better to change its return value calculation from:

    return offset_in_page(p);

to:

    return (char *)p - base;

If p reaches the page boundary (PAGE_SIZE), offset_in_page() wraps around
to 0, which could cause unexpected behavior in the caller.  Returning
(char *)p - base avoids this wrap-around and yields chunk size properly,
allowing the caller to safely terminate its loop via the boundary check.

What do you think?

Thanks,
Ryusuke Konishi
