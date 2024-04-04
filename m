Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C391B286A6
	for <linux-nilfs@vger.kernel.org>; Thu,  4 Apr 2024 22:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712270015; cv=none; b=hOX0Gfhc9/2TpnzvTF55K9m8cOqzcz9rqSZ1gK1UYeF2rInc15mVKslCmuP8zkcAUoAnBmPWmih4uwevugaCYHZfrBoLrW1LZFOv28LEFGEanJxDBB7ufDX8lzJB0eLL6S+bvXYzOfQA1qe0Ri7ju6fWrFxwvmvEV0ct2EJ1dXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712270015; c=relaxed/simple;
	bh=/qbDovDdmb55AKrOthlmm7xNcrtpHCb96U78vzJrRx4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lub6ZBUtilMNaeaD+AYJI913Tu3o2AULv66vk81t1YRky2k9g2LEqDeoeKw4Xrg5ldBotS9HD0K1z7eN++HtQRcyMw7rIGtdcBcmQtnVNKxP4bfnecraLD3zMHUY6kga3dpyzIKWgscVTnR2ASTZ6yyKGaW4CIWJhbLFwoQ7S5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbbq3mOr; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbbq3mOr"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-516bf5a145aso2011235e87.1
        for <linux-nilfs@vger.kernel.org>; Thu, 04 Apr 2024 15:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712270012; x=1712874812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOb+0rWdrRUwm9khvt8wJej/+KZYw8BlSatlx+AjU38=;
        b=jbbq3mOrzMc0bcBVNAfUQQ17htQwCcroikKP/jnEtqJDdxJj1rdmTjz8SkZTwFJh76
         nsTQBCrlwDRBopZsNKvFcCQJsA/Yo/elz69rz5hiX67UMzIrl5T/puVGKmQjHsnBYrwe
         oLTKtnhB4uYweYRdNng0qF8RHmWcRjrKUcUB1NUQLSnaGEF1jk3AVw1WUe9sALCoT7H+
         KPrujXJCXHlnHOL6SrUtONmr6q5jLIC+ioQGjsF6cb/gEpCm1JLTq7+cfoY2Hbx0c11O
         wKOhtmB6C2Y/hyMZ+YawKhJ2AH/soWz4BO+YMwtb7sWog6mfDAuo1JSBBGeUnIPr7Jel
         KmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712270012; x=1712874812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vOb+0rWdrRUwm9khvt8wJej/+KZYw8BlSatlx+AjU38=;
        b=BHwGcN6G5WN07mR7BfbdNT6OMdPTOyZcJq/V2nlSA3d2AriqongX4jkKpdF4VBEhE2
         u7vMrQdDXpGKwase9KzURJOY2iIqtwVmgNbnHvBeXHHKdLe4OtQxK9Tp9Kd58zERLtAR
         6uReFPD0SmsnAjfJeAROEgy1Red0udiDV/NJgBJVh7ym3V4vNulLgWr5YLsxMXk3tW7f
         1lgnkC2LpV/Vkd0BlMJ0pWAexEx2Y9t3DbypZpA9XaZLcJ+IfvqyDvs2arlNSnN7R6wj
         dvW3xgD/VAwn0BTu4s2zUvuhZE2VGXQtQV2Ivq79XFxYyBWUg3nA4+0LxTDtqhlgI6HT
         GCuQ==
X-Gm-Message-State: AOJu0YwsOMdjwj69d46JhX9cFCkLZ3oXy/tGQCaIRAFtWc2hFQwrWgxx
	NENF11ZMWuHAsfmn5+Da0G5u49YJOzyGRO1PqUnvNn8Ws8chMM0zk5pTwKapncvnZb2+v5ci3zZ
	FRKAepex8ERLLG7ePaJFvWH5aUd1ZvGRMs3A=
X-Google-Smtp-Source: AGHT+IE/Xgnsf6YHcHvb9qMyjwhxeB1ppguGmheloOJfkLYJNNFEylVgR9GzQG4cYtAJsPVX1DA6Q3wpV3gCcrJGaeQ=
X-Received: by 2002:ac2:4289:0:b0:516:a18f:908c with SMTP id
 m9-20020ac24289000000b00516a18f908cmr419513lfh.17.1712270011688; Thu, 04 Apr
 2024 15:33:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e282e150-2bc1-4b6a-8aa1-0417371c2671@redhat.com>
 <CAKFNMo=bbdBsW2xvTMiZcrD37n8MWmDfhH7V2jKZ14=odduRXg@mail.gmail.com> <f99b0c44-c5b4-4e0b-892b-dd9793a80f9a@redhat.com>
In-Reply-To: <f99b0c44-c5b4-4e0b-892b-dd9793a80f9a@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 5 Apr 2024 07:33:15 +0900
Message-ID: <CAKFNMokYkO-WsvrcZh=-FpR=LtCQnsyxET3ZjSzx-o5zXcMU9g@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: convert to use the new mount API
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 5, 2024 at 5:35=E2=80=AFAM Eric Sandeen wrote:
>
> On 4/4/24 3:11 PM, Ryusuke Konishi wrote:
> > On Thu, Apr 4, 2024 at 7:12=E2=80=AFAM Eric Sandeen wrote:
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> Note: This one was relatively more complex than others, so I would
> >> appreciate review and testing. Basic checks of mounts, various mount
> >> options, and snapshot mounts do seem to work. I may well have missed
> >> something though, as I am not very familiar with nilfs.
> >>
> >> You may want to look closely at the handling of case Opt_err: which
> >> no longer uses nilfs_write_opt() and open-codes the flag change, so
> >> that I can use the enum. If you'd prefer to make 3 independent
> >> Opt_err_XXXZ cases, that would be possible.
> >>
> >> If any of the other changes here are unclear, or problematic, please
> >> let me know.
> >>
> >> Thanks!
> >> -Eric
> >
> > Hi Eric,
> >
> > Thank you!  This is one of the modernizations that I thought I had to
> > do with nilfs2.
> >
> > I'm planning on doing a full review later, but when I ran a mount
> > pattern test, the kernel restarted without any messages (probably
> > caused a panic), so I'll give you some quick feedback.
> >
> > The mount pattern that caused the kernel to restart was a simultaneous
> > mount of the current tree and a snapshot, which occurred when the
> > snapshot was mounted and then the current tree was mounted.  Something
> > like below:
> >
> > $ sudo losetup /dev/loop0 ./nilfs.iso
> > $ sudo mount -t nilfs2 -o ro,cp=3D38866 /dev/loop0 /mnt/snapshot
> > $ sudo mount -t nilfs2 /dev/loop0 /mnt/test
> > --> panic
> >
> > Here, 38866 is the snapshot number that can be created with the
> > nilfs-utils "mkcp -s" command or "chcp" command, and the number can be
> > checked with "lscp -s".
> >
> > I have placed the mount test script I used in the following location:
> >
> >  https://github.com/konis/nilfs-test-tools/blob/main/test-nilfs-mount.s=
h
> >
> > The panic occurred in test #17 of that script.
> >
> > I'll also try to track what's going on.
>
> Thanks, I'll look - I was hoping/expecting that you had better tests for
> mount options than I did! ;)
>
> Feel free to debug if you like, but it must be a bug in my patch so
> I'll take ownership of trying to track down the problem and get it to
> pass your test script.

Got it!

So I'll try to understand the patch first.

This test script focuses on reproducing NILFS-specific mount sequences
(such as mounting a snapshot and current tree simultaneously) and
checking the state of user space such as the GC process and utab.
And, is not exhaustive for mount options.

Looking at the patch, if I come up with test patterns that would be
better to add, I will enhance the test script.

Thanks,
Ryusuke Konishi

>
> -Eric
>
> > Thanks,
> > Ryusuke Konishi
>
