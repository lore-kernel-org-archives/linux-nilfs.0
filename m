Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE462C11E6
	for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 13:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784295039; cv=pass; b=e1+kOGkR6m/J6NB0W7Ti7ugU4Mw2YPofdzUj2e+rXylkvwAgmKGn4SwtoGNtBRoHh8YAkrY5UbvXJIHSfE108jdYrQAME581tc65Kr7fYDNp3ALQfeyIb0YjtI3CR7I3pfWPHCAPt39B/sZPdV/69RJEm495DNPYSQqz8ggC4Zg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784295039; c=relaxed/simple;
	bh=7mzQ9c4ig35GG6CDLSBqjkls1q6xRCSH1USvTTct5nE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YTSXKQoTs7a9R1otWV/QNtlsQVnS2Kcnn4Nz0/KS4+ysuD1mCVpwl9Qvr6ByMQxqV0rupN8eRT1ysS2NDHVwKYN12Lovy+D9vWzd4GMY8H1wwUevX3Vtwrtu/vXb7JdPgwXZcEl1YmjfpY3JXVMUqzdmquf7GJJDi7Tb961GZOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dpCWUdnx; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dpCWUdnx"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b013aa02b2so1499374e87.0
        for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 06:30:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784295033; cv=none;
        d=google.com; s=arc-20260327;
        b=KXqOWEfCDLIKZHL72vXZh/wEIQtAkDkbtAIJWzfcHCm8m5u0f9sq+rfXvtNyz9Nm6I
         fn9eC30UZ3DsRibJTLP1ddVx/mWIfbQsvim2RXa8ummfrIP19mS7ChjVIhULhIFflEcW
         RXupu/X03Dc85t8XpQuSal4bVGOl0o/vOrq9c3EFDoUmhyhEdNjVmtVWH9E0nqXrmgRY
         mbXSMxZ6R5RkqNipEZ9aRk1qoBqh73DtZ8wQzyCylDoDJj6HMjnsnIhKdwzboMfnq9wb
         Qc1GnHIw6pXPf4NeYQy46X9V0dVQfokngKSTLh8n27vEOqnX/yWyJdeUp7cx0YPgdLeF
         1Wcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5AahnIzFbEQg4kbJjw2qw8/u6yN93W0Uy7sjS4Mnkrc=;
        fh=u4gVm1vh+ZxpY2dR4J/KVKCZMKY3fK8G6WnDKyz0Nqs=;
        b=qzHS2Wo38iEngz9LRUithGuLzwjv59LYLVco+B4yA5PrZSQQdh0tb2EvqTIzJzpCLt
         W6Qx12sdfKOqsoDIFAESuv+qOJ2xulUXQSlU0voeck9zZlE7j8yVITWQ8DcPJeSVhP5d
         /ErN0+cxe3BYzWX6x5eM3nDherA76CIno0XhPPnGE+MizDkkd5JbXrEgXM3SlJT0l+oX
         Qmec1v3aGGABuXpowQd/4u+bhKzVfcOmUJkihq1CFHxmoLzB49cg5lmJXJ0qdtSldvT5
         c9xDqvR7OO0is+4Aa1zUeZ+9hPBlbHZkSdlWnqetOgG0yaj7UnYxWm79+UpuHeU3nVC2
         SL1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784295033; x=1784899833; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5AahnIzFbEQg4kbJjw2qw8/u6yN93W0Uy7sjS4Mnkrc=;
        b=dpCWUdnxVYAmM7mLOFoHodkgkexW5v/qiydI6Va4rwJTOKgeWYqANRHG2OuFiM5jY1
         en6MwxLGxqeBaZqV0iR+GhOfggIQwKTEHnAQuq/H9CVxnelLWJyQsh0PTE7ds+suJ8a3
         EsJZGviuQP6E50+dmhNzTCXvy/fEZjMWdaVJgA+XIHeVBOonxRHPrSjw576BrWKQ94G3
         zdHPZ69YN6+Hj13hpDNIbUdicIbMpnJDYO0B11Un7FWdj8VOb7xhk5LkWjbTf8x0z3vy
         5Vb6+oeTp+U9XgwowGBFT55BomHDX0Tt90xdVvcK9MGXIyKEdWDlr1+cJCtrXg19MFfw
         3Q9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784295033; x=1784899833;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5AahnIzFbEQg4kbJjw2qw8/u6yN93W0Uy7sjS4Mnkrc=;
        b=DXmUosDnmS9+YtpbtFJOilFKoZE5QnnCsu6gDnvJ6X38lZwpQRuQPCftvRRfwYxwCN
         ZtP6/LbT7LETJlnUN6I84g1K0UarIk0O3ZcrBaOrX145AXY7/i75E1ZdPK4daOfTs4vB
         J5LimhyvYQE88H5HcwS1wYJIvOt7WYUGuR9749N4wfQBT4Ux/YoXWrdfr5uct5+lPav/
         SS5Qz4v0BPvKASTwLI+E+8W1xAstwZxcU1hghzd6pHku40hvjDLNJH/NDzr6YmEhjC/u
         9raU2mUPPrjBKHWdWAgwj+6Dq+1fIShyJefZxszlysA5GiusK7S97AxG0ApPciZd31w2
         aZog==
X-Gm-Message-State: AOJu0YxiJLmuULqWHtpXy366P3mi1foLjCsXrNgQiol3Vm6JtoiHJ1/s
	4ZWBgTLcFXG6fW5OypKgf28iTy8hyhSwpG+qOk8+zYiQpjNZWZCnnxLY934CHkwM42+FcOOaqfA
	uPfdqLQY9nhF7tKcpVak21/REqFpxyYA=
X-Gm-Gg: AfdE7cnOtpSOVZ4sn6ul1CXAF7u5cgZczIUriID4J9Cicae7c8xN+ckiemZ5kyzOH12
	yAAWvwfD1/R/eR4+FAEjcxdGZLU3kzg9ku+jXg+V/nwAJjlJ6P98wKqJcDn3MocwfUcvEjQdap6
	8D4J+bpJogDWPw9vTcbyW2XOXCVGy+vo+4vD670Qn6tohWc2JGqbZR4pdpkGIw6eVibP9HgXeVi
	hR1PeFkpAdag/xOoyIlqL4WqfQD4Rwqki2QFJ3lh+/LR92P7Pg6YPLem9addcw=
X-Received: by 2002:a05:6512:3e0e:b0:5b1:59e1:31bf with SMTP id
 2adb3069b0e04-5b28ff70182mr669893e87.6.1784295033030; Fri, 17 Jul 2026
 06:30:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717105854.1380-1-joshua.crofts1@gmail.com>
In-Reply-To: <20260717105854.1380-1-joshua.crofts1@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 17 Jul 2026 22:30:16 +0900
X-Gm-Features: AUfX_mxY_dnUT1gsv1SBWm6usq8DQdvzJwNJWrZDnAuTmWnLmJTXVztW2uELw6E
Message-ID: <CAKFNMome_9P59vdiP0=kS33H3qKJCNVL--SE7tR1rsUJajBETw@mail.gmail.com>
Subject: Re: [PATCH v2] nilfs2: fix infinite loop in nilfs_clean_segments()
To: Joshua Crofts <joshua.crofts1@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 7:59=E2=80=AFPM Joshua Crofts wrote:
>
> syzbot reported a hung task in nilfs_transaction_begin(). This occurs
> because the cleaner ioctl falls into an infinite loop if
> nilfs_segctor_construct() repeatedly returns -EROFS (e.g. the device
> is remounted as read-only after an I/O error).
>
> Currently in nilfs_clean_segments(), if err is non-zero, it logs the
> error and sleeps but doesn't abort when it encounters a terminal error
> like -EROFS. This causes the thread to loop forever.
>
> Fix this by breaking out of the loop if nilfs_segctor_construct()
> returns -EROFS. This matches the behaviour in
> nilfs_segctor_write_out(), which also handles -EROFS.
>
> Reported-by: syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dcae54346a70bbceeff2c
> Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
> Assisted-by: gemini:gemini-3.1-pro
> Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
> ---
> Changes in v2:
> - use `goto out_unlock` instead of break to prevent discard commands
>   from being sent
>
> As much as I've tried, syzbot is unable to test this and always fails
> with "FATAL: Kernel too old". Nevertheless, I've tested the patch with
> the same reproducer in QEMU and the system didn't hang.
> ---
>  fs/nilfs2/segment.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 9332f5ac6..218926789 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2561,6 +2561,10 @@ int nilfs_clean_segments(struct super_block *sb, s=
truct nilfs_argv *argv,
>                         break;
>
>                 nilfs_warn(sb, "error %d cleaning segments", err);
> +
> +               if (unlikely(err =3D=3D -EROFS))
> +                       goto out_unlock;
> +
>                 set_current_state(TASK_INTERRUPTIBLE);
>                 schedule_timeout(sci->sc_interval);
>         }
> --
> 2.47.3

Looks good.

Viacheslav, could you please pick this up for your queue?

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi
