Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4803B6377
	for <linux-nilfs@vger.kernel.org>; Mon, 30 Mar 2026 10:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774864843; cv=pass; b=IEhpMSBlIuKTdNCtObXHWjtbFKc+u2WTl7S3ZVXeijlJk7EYaI3MSCj3PRALCkLZedaCSUJyltV/lr9RU2mpr+PojeebskiwO5eLFm6reiCyg/8sEYJi5Z3Z0kAqsHlckrD3uq31W/7gEDKCM2MjXH39sgGx56U9ifeqweGmpwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774864843; c=relaxed/simple;
	bh=S+ZZ6EdwCF6lvaqJriEhxzPhQUzcLztVDhpYz9Q80Ds=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hJyQFlsY0twqe4i3otU6yU0LeCNpXmYrpBOwQ+ue4ACXMx8Vya2k+yjio6YP4JySzJm8zY5yUBEvRFYWTNTOEwOY5sUjP3oFP8oqnzerWaUA3+2nubEYSNIxOz6dDH7hgnRwNbCy+bJI0QWJ4zHiWKcTaTtyynYTcv7iPTRWtvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRq1DorG; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRq1DorG"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a1443780c4so4343853e87.0
        for <linux-nilfs@vger.kernel.org>; Mon, 30 Mar 2026 03:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774864840; cv=none;
        d=google.com; s=arc-20240605;
        b=KCgPsaRaLuyPmE5eexTR30Lw2USL8KjPgdBiQznxBDIAxPpsnM6ickAe4aHVczc6vD
         ubI4Nh4zejqM229bY0DZa1PE3a0nqUmGD+DJIpFs2/gPIwZW62NdTZlCJfOTBC3bBs3s
         J9r1mK0TwRMCvbn/8cJkaKiRTgSluDiNoazh0x43ru+a33hieqWDAa3rwbzc+wJ2osOp
         U1LL9uY1s1p2tBsBNMGAPgv2BMbaofQ2a0gCAPFdzkZeZcgQttKAYWPKo7SyDAUl/nXf
         KpbD5TFtslMyKV3agbBW1MIttsmznd4TeGaBvmlAihuPLftXMxr2cqJ0+fXwoCX8svT9
         zbYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O7A81rTgvJo724voCFOT4zYNI6IDWRH0PhVti7JMwVA=;
        fh=fUGYWf2a4M/MZotEuHr2b0Bu7mZR+gjYYG7FMk7kHDA=;
        b=Ddw+pWbbyUpjfMhKX1LMZ/b3sN+FKLWvIT11TtJaxtZAP/uw9gNFvXUTCUu6uAvshp
         Tnfkl10eAro+8T3QzUbFAzWP9caxkB0PgTsQG1W0n2wPHfiQV4hthpDcuU4m8gRVVbcW
         nchZRIVLMhzTEX3cBoRNX9D5bJyr34+JrO2CBZ9/LwDiMGhbhy2wkkz8bVcCR4MiVrdD
         hqpAAF5bZCz+Rl8q+Ij7aL339X+a2MTrM9uNDjVjXmyLB9qcOTa8HJlTefOTMjFGZ1rq
         4upiQH4WzSEp0o3NjYbNAvw77TA73KsGwuNOewwtELX59wUdJpoP7ZF9G4yymh7/W9gK
         Nl5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774864840; x=1775469640; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7A81rTgvJo724voCFOT4zYNI6IDWRH0PhVti7JMwVA=;
        b=VRq1DorGlIM+W5J+IVx+MxTV/uYL1xPTZ8IQ8UECp12y0ALBoa6qL0RQ2fG9BtB+wC
         QDVH8UmccZuFG1qud22RcPTao7jHiQAEN3jesPcn9Y/En8yebbDTDxP+vGm58oqTGBHc
         i9b3VIRectU6Tli3HAmDdbEsHI+tfsRwc7saOv5DDs8F+UAiLNJjsH4oXG7gkm+gApBN
         BwrBovBZiNnInxJJPd72pfnmDGx976T1oDpsGyGCiMiZNQtq4NS06h3lDmtrECvYxzri
         caMyaZBxau/w+Fu0Z3/8XbJb3MM8NlvnkxGYxVNmRv49crA/OlSJU+9NyUibtGugRw4R
         wiqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774864840; x=1775469640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O7A81rTgvJo724voCFOT4zYNI6IDWRH0PhVti7JMwVA=;
        b=oZSFUk/YZKwewc566V44wtP4uN6c+faIcCCHs3pxKrPq8rtd2JsePUeKfa8XUTF8NX
         Px0QDO2Pi16VqmkmxMC12rQG6+lLuQ/eK+GzEO4UU5Edj7aLeMEMQzorUTC9nv+Xu4je
         B9cn39XF2Sv2OkLARQ8sFtLFXM1KrUcjdLrn4fIkvYyBSuiA9qmIg4GCQkT/b1GQX3br
         +b0ZgGgKiKeHVd9SuLJx7clwJQrMVmHkZB9LTPFKKANBosRCmHIHPvjn4LPTDZclvnrF
         m09oUDYhFxj4sziijlhLD76K+bgyG/xmlnsZkaGkUr1KBE6wLDmNXdmHW0gyDgVMqbFY
         cKFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWOsXUGq78zJZC22542nKOizZUE7I9/yvoUB6TeZBinM7d7TdgjmPL1+nhCeyVJIgSzSxA+Mq+dLPJtA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo2tPIZzkuuqKRzisu3JHJgV89uQrk/QV8xnTkEqbJSSZ4mhnd
	gyU8AniAB7eiqwPl8He0Jw1DAamQ6/M3woss4Xu7sA/QzAneXQoa4dXJaMK40Nq6d3pR8u+okan
	vuPFMPjDBtXVU0QSSJoMhP4hziotTMm4=
X-Gm-Gg: ATEYQzzIMKjC2zCLM7/cxod1hpXDj73scIzSZ1yOZH3E9a7yhgZFYxd9E/4spH3bMx4
	HY8yJHY66YXxabcYv7lWc5bFSfkvmcZl1d7xuGpi0uKS9y1a5g7ZfrfmRUxD+Jlr0OnPgK4nC12
	jsWh43u8oD0nu++IQNnYiN7hBjMk5FwIbipdvffgQrggzA6iVsSEOKES+EuTeazITpPry3lBSPS
	4QJmLgDmYnCUWtKAbbPHFNTLJ5SqM8F/zv5ZykzwmrxxDoOt73v9BGHHnEeSlPyQw6xXQadCGka
	A9oebMU=
X-Received: by 2002:a05:6512:3ca5:b0:5a1:3d08:cfab with SMTP id
 2adb3069b0e04-5a2a508f103mr6445171e87.23.1774864839220; Mon, 30 Mar 2026
 03:00:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260319091930.1088735-1-kartikey406@gmail.com>
 <CAKFNMo=Z2wsL5za0VUeYh23nodPusUCC9WasSeR5BHc6tEBu1A@mail.gmail.com> <CADhLXY7CyKubhVgSc1ptjL0H_5A5N=uuWRKWpf7rJbFCxySRCA@mail.gmail.com>
In-Reply-To: <CADhLXY7CyKubhVgSc1ptjL0H_5A5N=uuWRKWpf7rJbFCxySRCA@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 30 Mar 2026 19:00:22 +0900
X-Gm-Features: AQROBzBPdQT_7U_7Ma_-Pvk5t7WiycLFjjuA_u978Uhm-HfUtlvfP-qBgA0VjFY
Message-ID: <CAKFNMokwd5aeXROH6sLHZhO_7FvCmivquntJrzJbvfNYkn-dDg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix missing continue after -ENOENT in nilfs_ioctl_mark_blocks_dirty()
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: slava@dubeyko.com, akpm@linux-foundation.org, sato.koji@lab.ntt.co.jp, 
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+98a040252119df0506f8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Deepanshu,

On Mon, Mar 30, 2026 at 6:40=E2=80=AFPM Deepanshu Kartikey wrote:
>
> On Fri, Mar 20, 2026 at 11:02=E2=80=AFPM Ryusuke Konishi
> <konishi.ryusuke@gmail.com> wrote:
> >
> > Thank you, Deepanshu.
> >
> > On Thu, Mar 19, 2026 at 6:19=E2=80=AFPM Deepanshu Kartikey wrote:
> > >
> > > nilfs_ioctl_mark_blocks_dirty() calls nilfs_bmap_lookup_at_level() to
> > > get the current block number of each block descriptor. When the looku=
p
> > > returns -ENOENT, meaning the block does not exist, it sets bd_blocknr
> > > to 0 and continues processing.
> > >
> > > However, if bd_oblocknr is also 0, the subsequent check:
> > >
> > >   if (bdescs[i].bd_blocknr !=3D bdescs[i].bd_oblocknr)
> > >           continue;
> > >
> > > will not skip the block, and nilfs_bmap_mark() will be called on a
> > > non-existent block. This causes nilfs_btree_do_lookup() to return
> > > -ENOENT, triggering the WARN_ON(ret =3D=3D -ENOENT).
> > >
> > > Fix this by adding a continue statement after setting bd_blocknr to 0
> > > when the lookup returns -ENOENT, so that dead blocks are always skipp=
ed
> > > regardless of the value of bd_oblocknr.
> > >
> > > Fixes: 7942b919f732 ("nilfs2: ioctl operations")
> > > Reported-by: syzbot+98a040252119df0506f8@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=3D98a040252119df0506f=
8
> > > Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> > > ---
> > >  fs/nilfs2/ioctl.c | 1 +
> > >  1 file changed, 1 insertion(+)
> >
> > Since this implementation interacts with userland GC, I will check
> > whether this is a simple missing 'continue' statement or if it was
> > intentional.
> > If it is as you pointed out, I will pick it up and send it upstream.
> >
> > Thanks,
> > Ryusuke Konishi
> >
>
> gentle ping on this patch. Would like to know the status.
> Let me know anything is required from my side
>
> Thanks
>
> Deepanshu

Please wait a little longer.

I have finished reviewing your other patch and am currently testing it.

I'm sorry for the delay.  I was unable to work last week due to a
family bereavement and various administrative procedures that
followed.

Regards,
Ryusuke Konishi
