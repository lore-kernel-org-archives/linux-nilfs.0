Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A06F226CF6
	for <linux-nilfs@vger.kernel.org>; Mon, 30 Mar 2026 09:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774863659; cv=pass; b=AefarlfKwMhkgsdr+G7PM4ahcGgcgJPV1b/0ILzHFUfVmZTUF0Axs4BMq1cvrJhmIiK59nfKi2qtf9rxPXjlCmdEJ+zVuuHS2/bOWOCKxlCKcIXZgt44KdVnlcPu30qqmV2k0j6uk8WWpFveH0mO08nrUQebe3nAZUTRmY+unsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774863659; c=relaxed/simple;
	bh=9JHuqnfjJJqENHCSCWaV0ED5MpJiIF9YLFG+HVRq5zc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cw6b9AjHHrtZ1OJfuKzQEEYl2gcB20nm8yuVZI3aGS+xdLnUfB/i/FbX5xwZ5WofRhHDTtHeHwWbfXR8xEuYz/Jv6ZREUrSAvXq5q5gcYzEZIn9JWImWfun8f37fXtwGVeI3sZY838tCXOZkfcvOHoVpD5IDNlYmLCcNl+SpJ4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vmd00oJg; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vmd00oJg"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-64937edbc9eso4514976d50.2
        for <linux-nilfs@vger.kernel.org>; Mon, 30 Mar 2026 02:40:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774863657; cv=none;
        d=google.com; s=arc-20240605;
        b=eKhVWnWC/MxbrTfG6vWlnCVX7kK3DELqt/SN9DO86L9ozAAFruZwrsCjOgRZw51/0r
         tkZXjzvawc73QqczmYMXfgBHKxkJ0EXDgn2JMRy/rnViTATokQP1u/NsjQaBVpCdV1AM
         HQfN/ve1JvhQLrPJuAN9mW3ePWUObfFcYp3N3/LiHvRR6s69w1ANBRU6TrjN2T/YNjxz
         fWkifiMeBX0gq5bfbXeGkpzDt2HD9q1oDOVF+xgFOczaFTWcOBIz3K2sLn+oRQ9I0bvF
         Da9r4mhjdcKCnp1McNppf6jUlfEj7ZlPrL3Q4S9SvoBpxEtTSuUif+0UHRFilS39m7kr
         hMeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9zvuL5VP2kOeMmTnXJQ400c6sYnkOHYg4bc7m8Y8xZY=;
        fh=LYjMalS0VZqOX1NWvJNdOoLt1ra/ZuUNX5a8rbKH9Qs=;
        b=DcoYCoBkT6gqBilp2GmMzpAKpAk6aDpU2/sTA03imc1/2jAdewtlX96HARuIeExYjp
         ZVc5AKuNfLOYAc1fpoIpKZKU3QI4Q7Kf00iBzi/A516sAfXUzo6sfGyiVxff/h8Ska0W
         reB2dBxW5aa6RE95ossrfFqYuilyeXX80uNL1IpdyaUxTOIZ1ZaEjKHwWzbf2+IFcSxn
         yFXn22xO6EQPcOcFCs0Gsks6u5SyiGtYlSfORC3eI/K0KYSHslHdqgRbKlpqPquy9FCt
         JQ2lgEZrZNV9k9w4vQ3AJSQElI7zhXIcaIZIG3bBUAni7mcNKztgwvCJyWVS9NM44fTd
         cM3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774863657; x=1775468457; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9zvuL5VP2kOeMmTnXJQ400c6sYnkOHYg4bc7m8Y8xZY=;
        b=Vmd00oJglj7QVcCQEJY1nTxSaEB8/popLpniF8y8rh88gp8AuABjSDhVKxaAEDVccE
         GSdOtZmjqsXiGCCPpgB1y8tYO68mqpJWTXNrPI2zzTEx/nHfLFMlD9DPMBGLmA7B4URt
         bCDUsD8q5nwXX3QFGoA6E1aBKTCfVAGK7uRDaSpsPyQ0uDCq2pcwWDEY79hEgs35PrwY
         2mn61p2mczwoFWx0Ex8KY43ps4arPtSC429Ryl4Goi8vfa8pVWDVnu7jklYYoj8CmzAt
         TW6jU1Ov3eFco2LMzZYZ4CBa/BikidusihLn04TVL5AoJcdR6t2sO17Np59a+WisB8md
         GOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774863657; x=1775468457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9zvuL5VP2kOeMmTnXJQ400c6sYnkOHYg4bc7m8Y8xZY=;
        b=QYpsh6FtObqkWhwdY2NzHoYSj99JXVw2XXJ84F7XOfYOynZ8xqb9SptFl334yxXvlU
         xWn3Djac/k6qqPa/IkdzwVWf+w5tFvfHYmC069Vq/7Iqo+OfpUzHW2H7Q8JsZ4h3p3pG
         hAyWnOuksy9k+o940TBYD7WfHWKUVRqSBxHnqUJTQ8HGGaXtAF4s9bW6703qeqOX2pex
         LtVk9JknJ1jj180/dPdu7kPZIuZdxAttbhfs9Ky5Wss2H1PB3UDuojYJjEBCxJZx7JK+
         KE9Ne8IYK0l+P7Z44FOcCeEtVAwhXPWCVRMy1eonc/FTein45eSsRisXRfQAhL4U5ayl
         3q/w==
X-Forwarded-Encrypted: i=1; AJvYcCVs+xe1oMxJsEylZ+FdGniDXzoQTZ1wSEeB6qTOHKt1h3grM1Gg+0T6U+EDjI3oj2PgL38lLaCcZRs8hA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7sDpS+pvbUqBzbbZ0CQzYF5HXpPlumCYbUwoL9jR3xdqHuKDd
	Nb0YBjIS/US9HcYfL+R9fQ5d8EfpKIdoqmMzoXakDWxGzHMjS8HWJiiloEaTOPutW+uSLgVOg50
	6OS4GEJadR762KZN0Un6gI3Is9a/73Rg=
X-Gm-Gg: ATEYQzx2tAXrcrhYn9uFO2EIj6PKrGDwMCnWp0R2Y6dz+WH8G30ajB3ABJZE19prHxU
	kHnTd72In67vGVanCGZ9qPT+36ZVUYFyfYVoRLvMMewuorsGU8ntBaeMXTa2RQORNr9xraAf/RC
	lpGgfs2FIPlnsMDcwfLGPRPu0jbT//Ph5h/zQMHg6p3B9kLr0hw1hnfvaf4Ey4m/QK6uP/BmlUG
	/W+bSk+WdChPs+gRp/We1GAnKb/dN5w36rMCe3DGLupCXqdglf+oSvDNrnqOtRgTikI9l9EUCHV
	TuXCta5r0tvCGfhI3Fl7L9YFdGrmY2xiBrTQ8ZD5G3mQAjBtgkSHj8ataJCBdi1cp/Y61X6Z
X-Received: by 2002:a05:690c:101:b0:796:3917:729a with SMTP id
 00721157ae682-79bde06ba42mr109097637b3.53.1774863657017; Mon, 30 Mar 2026
 02:40:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260319091930.1088735-1-kartikey406@gmail.com> <CAKFNMo=Z2wsL5za0VUeYh23nodPusUCC9WasSeR5BHc6tEBu1A@mail.gmail.com>
In-Reply-To: <CAKFNMo=Z2wsL5za0VUeYh23nodPusUCC9WasSeR5BHc6tEBu1A@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 30 Mar 2026 15:10:46 +0530
X-Gm-Features: AQROBzCjQphqRfRk0wCloLrJd4D894SlWIaXT_6f1ljOhs37tkuBVZgGEh5RdIY
Message-ID: <CADhLXY7CyKubhVgSc1ptjL0H_5A5N=uuWRKWpf7rJbFCxySRCA@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix missing continue after -ENOENT in nilfs_ioctl_mark_blocks_dirty()
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: slava@dubeyko.com, akpm@linux-foundation.org, sato.koji@lab.ntt.co.jp, 
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+98a040252119df0506f8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 20, 2026 at 11:02=E2=80=AFPM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
>
> Thank you, Deepanshu.
>
> On Thu, Mar 19, 2026 at 6:19=E2=80=AFPM Deepanshu Kartikey wrote:
> >
> > nilfs_ioctl_mark_blocks_dirty() calls nilfs_bmap_lookup_at_level() to
> > get the current block number of each block descriptor. When the lookup
> > returns -ENOENT, meaning the block does not exist, it sets bd_blocknr
> > to 0 and continues processing.
> >
> > However, if bd_oblocknr is also 0, the subsequent check:
> >
> >   if (bdescs[i].bd_blocknr !=3D bdescs[i].bd_oblocknr)
> >           continue;
> >
> > will not skip the block, and nilfs_bmap_mark() will be called on a
> > non-existent block. This causes nilfs_btree_do_lookup() to return
> > -ENOENT, triggering the WARN_ON(ret =3D=3D -ENOENT).
> >
> > Fix this by adding a continue statement after setting bd_blocknr to 0
> > when the lookup returns -ENOENT, so that dead blocks are always skipped
> > regardless of the value of bd_oblocknr.
> >
> > Fixes: 7942b919f732 ("nilfs2: ioctl operations")
> > Reported-by: syzbot+98a040252119df0506f8@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D98a040252119df0506f8
> > Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> > ---
> >  fs/nilfs2/ioctl.c | 1 +
> >  1 file changed, 1 insertion(+)
>
> Since this implementation interacts with userland GC, I will check
> whether this is a simple missing 'continue' statement or if it was
> intentional.
> If it is as you pointed out, I will pick it up and send it upstream.
>
> Thanks,
> Ryusuke Konishi
>

gentle ping on this patch. Would like to know the status.
Let me know anything is required from my side

Thanks

Deepanshu
