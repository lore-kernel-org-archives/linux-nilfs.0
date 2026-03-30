Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4B63DE43F
	for <linux-nilfs@vger.kernel.org>; Mon, 30 Mar 2026 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774894199; cv=pass; b=ZW3Jz+AirQOGdDS+nf8HY4EJgAL7eYNhFtpmY/lmQeZ0gFcxHMmMHJoU9coaGOsOq3fmytcZ44w6G8rWG6rFT/Sig3DgtXUCxeKlij9sRlFzwLET2fqaeg55irAkImKKliqjDeKk9FSN1vk2mvWA1Wb4xxtCru1tK3klYSN3sK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774894199; c=relaxed/simple;
	bh=fpn7fhL3kWiSgURvKQ++4sfDneF5WpbSmy/1rbvEalo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MvdR/2t0UeQPqwmG+UQ9p/TWdWvAH0hVmDCNqIZvWscx8t/OM6fPx2Oog3UCvIXWXS1oyLcSKG0gGM2fFTkfwKKvj5g3YacNTKKTtztu55mMqxZFWrRZgRpXYpVXSe/ie5fvg1ttTq6LoLId83QOj5+gY3zvTSTBrJRmBZA6F4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MB4XX1Dq; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MB4XX1Dq"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-38b13652c87so40880811fa.0
        for <linux-nilfs@vger.kernel.org>; Mon, 30 Mar 2026 11:09:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774894196; cv=none;
        d=google.com; s=arc-20240605;
        b=ALetU9ddJoXzrN6A2zCW/EvTHIytB0+eogx0FZlgCuouxwuBWg85QO7v2Nv4TzRUK6
         46zbQ87Bqr8yJAPuLc2uPou0VH7cEkfxec++bFXdsdhp02YCzoUHm3bDKrsCBlAs62YG
         +B7fr0nAFYWv8w6H3lxS5ic0htnIf7LqWu4sOPkINk7eQO2y4fX7/Sb9DMp9YJr4wgmE
         KJPPrqEFsfiC6DJ1+Byp8tarhqfwt4oQLHYJDpqi/uJdrQvtFIoqKKwadEWwrvfqot8i
         ZkdEry/RKa+G7V8BliooU0AZUwb8QsQRzB8HnNt6BWRAej8c5C/VxozSpTI8waGuO9l4
         N+dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W6WY5ahJo/lOwyLpu8hq94ynlTb/YwUp6BI6SZCZt2U=;
        fh=zlpj//ZSe+MvKvfWcWtpPa8OeaaYwhmg8t+u127UjSU=;
        b=GQQXo70EnV1SbSkZlsAL5u0o9QXGZ7PmtY79MtHlV8whQJWlmiipbWJpHsM8XX9bwj
         z8U0CAf7YianeER4qYc8YrBMm/e2BmarVjyockrg/gTKFatyisDuS+d3XespfBey6Fj2
         zJU3zy1c5+YfJAcORBOvWtm+fNcNRMYVCNFQ2L5onKkkPCaf42e0DG0sOMU1Fxr1fgUv
         Jkry9YNxdeGqX2IlQNmy4W9wSuiRn1oTrcb+zglivD//YNkH+zGuLFAmuYS5E2QKA7Tk
         ZLCUM/UIwlPG+uIFHaFqME1VXIFHVqa32CMTSC1NMKem0uo93U+zWFhnxeKqdUYG6iLH
         TPfw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774894196; x=1775498996; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6WY5ahJo/lOwyLpu8hq94ynlTb/YwUp6BI6SZCZt2U=;
        b=MB4XX1Dq8cXf7k0w6oGQaWpRG0drUNJE8to8mrm7VfiqBGwt9JpWtxMf1Tkwghol3x
         SZBoxxc8T1Qd94eWK6NhH0OxtXp1YJC40Evn4xx9J1QcpljHYPKn8iJUJm32JVHcMUyq
         6VHbjZsF4sOFthf/pwpr7VYDXihbn57M9YbiQZXYjOjzP7WBHGmGy2TaYtWIkG1zjGSH
         ubiiADxCg81Ln2wkHCPO8VGqTp0iepH5ne6pdparB7c8MBqDsX+x78JHmnlG/eM9ne+r
         abdHcy47XHtxQ1OfaXRDnyHEZ28OH4SFaki5meggJwvW1VDukCURk763t5t0i0LSddw6
         lDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774894196; x=1775498996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W6WY5ahJo/lOwyLpu8hq94ynlTb/YwUp6BI6SZCZt2U=;
        b=XPOm1rU+tOjAuWLPpEImnZKOXT4nLG+Fq8G0Wcar0bojnALQF+o8daXxWw4Ckg1BG/
         7q0C6qQS/xRQibcCeGwWfmYAQiB0SIamvXPYdJzlPyc4QC4J/Z0kdzKfBD8aru1UPFI8
         rV1nGHqppuRldcBA/FG6lOu9eVw2yl/h7X/MmIM4/jn+BYvGj3WTiTDIsUij0/GrceSF
         21pRKqH4GzPnnu200wei0VpYydkXVn2sZqZw2ooysmtshVHh/3vEZ52afUntvY7UWOXJ
         zXlB2xhXxLsGthhsvRhMYPVHQHBiTc2S4ZupXVPAlyfhGmbJAt4jLZWuHiB5OS/sWpOa
         wEuA==
X-Forwarded-Encrypted: i=1; AJvYcCVNBD1AHTxXFN/iWQPvHeRGFTIbsLY8hpkP7YTYGlENJPyN73An8lPLjuuyl+Eh7tmwODTvp2+OXuHv9A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDfi/fW1tDf3mA2fAtoHw1z3FtRCxJFUaiNuPOoHBrpf78q+lK
	3pfIx1inqgcB+aO1wu/t87ZzMwIcfB45J3MJsAcUrkkKpLQ9zTPq0NXcGXHTFjLef2FmCv3BtPg
	9ZcjvwGoZC/kNoaBKwRqaY77Ck3OPBk8=
X-Gm-Gg: ATEYQzx2QTrZr+aVUn1I1NIGVRGDDGxaJvTsz4H0J8UruAOLVvzPuLyDNoa3GZnO7iP
	RUguQqkx3qt4Yw77waNzeicCoyVmpCnyqUtfLakTKWf1blLbtXC5JkgqbL+4WDi+MFi6kSw2SS5
	tFCRn5a6BIF8BbTSkIRt9zJpiE25kJnmXGPyMcAH/ZnnRWGPn7ha8ih6TwQgiOfYf2gnNdWW3tb
	bP5cztr0EAzPUPbyK2Tp6qwZNeu4WOIuvI/GRTiMUthayJ4VTbr+IaW3V3E5tXlyg6bFOGyD62Z
	z432yOk=
X-Received: by 2002:a05:6512:3b99:b0:5a2:a3c0:ac4c with SMTP id
 2adb3069b0e04-5a2ab7fa962mr5311059e87.14.1774894195231; Mon, 30 Mar 2026
 11:09:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260319091930.1088735-1-kartikey406@gmail.com>
 <CAKFNMo=Z2wsL5za0VUeYh23nodPusUCC9WasSeR5BHc6tEBu1A@mail.gmail.com>
 <CADhLXY7CyKubhVgSc1ptjL0H_5A5N=uuWRKWpf7rJbFCxySRCA@mail.gmail.com> <CAKFNMokwd5aeXROH6sLHZhO_7FvCmivquntJrzJbvfNYkn-dDg@mail.gmail.com>
In-Reply-To: <CAKFNMokwd5aeXROH6sLHZhO_7FvCmivquntJrzJbvfNYkn-dDg@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 31 Mar 2026 03:09:38 +0900
X-Gm-Features: AQROBzAeKHhaRIpZ32yx6smuVIjUFaOt6sEuEodw-5itQWSb51Xtoud-ccfhDAg
Message-ID: <CAKFNMo=HUZ0Zuwh5yzAgjNUfsrpuvGeaM2-nkenrm9W9sbfGPw@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix missing continue after -ENOENT in nilfs_ioctl_mark_blocks_dirty()
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Junjie Cao <junjie.cao@linux.dev>, slava@dubeyko.com, akpm@linux-foundation.org, 
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+98a040252119df0506f8@syzkaller.appspotmail.com, 
	sato.koji@lab.ntt.co.jp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

(added Junjie Cao to CC)

Hi Deepanshu,

On Mon, Mar 30, 2026 at 7:00=E2=80=AFPM Ryusuke Konishi wrote:
>
> Hi Deepanshu,
>
> On Mon, Mar 30, 2026 at 6:40=E2=80=AFPM Deepanshu Kartikey wrote:
> >
> > On Fri, Mar 20, 2026 at 11:02=E2=80=AFPM Ryusuke Konishi
> > <konishi.ryusuke@gmail.com> wrote:
> > >
> > > Thank you, Deepanshu.
> > >
> > > On Thu, Mar 19, 2026 at 6:19=E2=80=AFPM Deepanshu Kartikey wrote:
> > > >
> > > > nilfs_ioctl_mark_blocks_dirty() calls nilfs_bmap_lookup_at_level() =
to
> > > > get the current block number of each block descriptor. When the loo=
kup
> > > > returns -ENOENT, meaning the block does not exist, it sets bd_block=
nr
> > > > to 0 and continues processing.
> > > >
> > > > However, if bd_oblocknr is also 0, the subsequent check:
> > > >
> > > >   if (bdescs[i].bd_blocknr !=3D bdescs[i].bd_oblocknr)
> > > >           continue;
> > > >
> > > > will not skip the block, and nilfs_bmap_mark() will be called on a
> > > > non-existent block. This causes nilfs_btree_do_lookup() to return
> > > > -ENOENT, triggering the WARN_ON(ret =3D=3D -ENOENT).
> > > >
> > > > Fix this by adding a continue statement after setting bd_blocknr to=
 0
> > > > when the lookup returns -ENOENT, so that dead blocks are always ski=
pped
> > > > regardless of the value of bd_oblocknr.
> > > >
> > > > Fixes: 7942b919f732 ("nilfs2: ioctl operations")
> > > > Reported-by: syzbot+98a040252119df0506f8@syzkaller.appspotmail.com
> > > > Closes: https://syzkaller.appspot.com/bug?extid=3D98a040252119df050=
6f8
> > > > Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> > > > ---
> > > >  fs/nilfs2/ioctl.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > >
> > > Since this implementation interacts with userland GC, I will check
> > > whether this is a simple missing 'continue' statement or if it was
> > > intentional.
> > > If it is as you pointed out, I will pick it up and send it upstream.
> > >
> > > Thanks,
> > > Ryusuke Konishi
> > >
> >
> > gentle ping on this patch. Would like to know the status.
> > Let me know anything is required from my side
> >
> > Thanks
> >
> > Deepanshu
>
> Please wait a little longer.
>
> I have finished reviewing your other patch and am currently testing it.
>
> I'm sorry for the delay.  I was unable to work last week due to a
> family bereavement and various administrative procedures that
> followed.
>
> Regards,
> Ryusuke Konishi

I checked this and found that this fallthrough was intentional, aiming
to detect and skip a dead block by the subsequent comparison with
bd_oblocknr.

The problem is that it does not reject cases where bd_oblocknr takes
an unexpected value of 0.

This bd_oblocknr parameter stores the location where the userland GC
library found the target data block or the target intermediate block
of the DAT file.
As long as it is valid, it can never be block 0, which typically
stores the primary superblock and others.

However, due to the missing check for that anomalous value, the
corrupted ioctl request pattern generated by syzbot triggers the
assertion failure you pointed out.
I think a check like the following should be inserted at the beginning
of each iteration of the loop:

if (unlikely(!bdescs[i].bd_oblocknr))
    return -EINVAL;

Could you please restructure the patch in that direction?

Thanks,
Ryusuke Konishi
