Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C93D8634F
	for <linux-nilfs@vger.kernel.org>; Tue,  4 Nov 2025 10:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762252913; cv=none; b=AVxusfrsbpBWuGEsC7l6GS/6s0llzMvJS5+U5GGNiyMokErmhNrpEcyRvyIF5+nM9B25uj9I/oiI6So+CN4ORE8DevnkF2zcpVGBvXkHmkJaTW5dod68hWc+M7fbDm72PnEN6WklVOsZE8uNNNFWrNIP5eRtqIgy0sEDwJHC5ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762252913; c=relaxed/simple;
	bh=Ckegc7TsysE5nKeKFzHv1CB2CqbK0xTBJn+2rqCY+IE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pw3XxOFmUs8HeTOrsYvkh7m3kA+YFHGF04nh2vqFwTFk8gGH00xtqNGA14gE1aN/rb2+ohaGcATceWqLZ6ASzrg5/kdWFXCwSs9K/++QEZwI4iKXHb9Bc6FLYarLTWOaSLUhSJ+4AKx7e1o8dUwT/2eEPDxH6B8YXU4DuvuKUc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KTrkRhdQ; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KTrkRhdQ"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-57e8e67aa3eso8949465e87.1
        for <linux-nilfs@vger.kernel.org>; Tue, 04 Nov 2025 02:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762252910; x=1762857710; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ckegc7TsysE5nKeKFzHv1CB2CqbK0xTBJn+2rqCY+IE=;
        b=KTrkRhdQnlYP1HD/iyOoi2gWvpcqMh521neW5k4cJsdCPoEy0tNBXNfbV1IJcPlkzk
         v4lbp+iTXiN9XNvHHGyxdx3saNEVqrtFA8n2y6ymRb834WCvm4I2MibkdKYlBIstod+E
         voprf3TSPJWv9/q3mRoGVN1P4VX+2WObtTGR6eVZjoDiLe6ahIjiR2K8DCE08OITqmGU
         Kxelb14DRYvaXQuWKKZX27TevIUjpVzS+kfF4WBO7zrRsy7wEl9ZBsttVa+ghX17OjdV
         2Xw2yzotMWuLHxsAdZN+NCuHOCgLPxRcjGS5IlBRS8OFlkot2lLmImvZ+ecuyG5rrxoK
         K2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762252910; x=1762857710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ckegc7TsysE5nKeKFzHv1CB2CqbK0xTBJn+2rqCY+IE=;
        b=TRgx0Uwr5oFeF7IilW0HletnRkafWIWKoM4bVWXI1Cw2ELxmPH3dA8b39L9Bbti70I
         sZhdX3x6fkMzZNeziD0mtR+bEBMh/Rtuvwf0TyeuA3grOIwr9QgwHkJq8F4fsBP1tRcP
         hy3KX+vQW3Il+ePqldibu5aCbzhsDIKZvPL2re0z8Fpeu4ASYYixQuWpgn2AzyObMYKb
         aIkZX47283E0LjffP41zcrUryeFWM/MU/qYxpPLAAKF+mH7ecuJAkjqfyHdZuVL8SJ39
         gcFImxAmLFnI/exI22P2j6ZoLXEC3engTKPGAzEELLULjIPLV7AWvsHlwKw8O8GWrVGa
         naiA==
X-Gm-Message-State: AOJu0YxmdGDb0cSBirm4y+DcXzTi/sSnmlXTByCK/GHorrJOTvQbqBpI
	JLH25/vvfwG0+GuqA2CUCVV2oRHD4ygkCxmaS1fS1BInPGU9zt3rcWRhx0eEu2bQ2qpyHNPDx8Z
	BpOnh44zv7Gi0LiyCuBc3+Ro+YtAbFfQKJbv6
X-Gm-Gg: ASbGncs1jQEalmnmpC4N1t4VfDeQZ5GkGbujmvnQHMhKHPCwkAEZrRFJi7a1MxQumzn
	WAOUvTsxLwtz4ml2VyM3CpPyPreRwmZ3her+BH02LgEGoW6YeBIWiam+2rb/HJJ1K8SVy4ye3ui
	nTx80C6HXVAvIl4R27hoLbjujLP/qdy6O6f2zn40IYfhy50Th8rAvghEVi3KXxkf8CcNMhYehbZ
	shChSfcoYQsKrxoQPSJRP3xffO7HqJ4i7rhdHUpMtWjB6DpCj0A3isPimmplQ==
X-Google-Smtp-Source: AGHT+IEa0Jsn7E9Jb4EFwAVkbXifwYdVo0u/f1jBE8HBvc9ta4EOlWK0v02AT/4LZKjmfx/Ry2QbKhiFx+F3behvMr0=
X-Received: by 2002:a05:6512:3ba0:b0:594:2a5c:78f0 with SMTP id
 2adb3069b0e04-59434926f5amr786772e87.23.1762252909895; Tue, 04 Nov 2025
 02:41:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <73c75a4192c45e9c8b5054e0ac67f586a8c41589.camel@dubeyko.com>
In-Reply-To: <73c75a4192c45e9c8b5054e0ac67f586a8c41589.camel@dubeyko.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 4 Nov 2025 19:41:33 +0900
X-Gm-Features: AWmQ_blsPU9Q0GLSZfG6-lKQ20eIo21TqAn0S5A4UXOXduXPM0qogTKzrGHJICU
Message-ID: <CAKFNMomaK8UYcgjvx_Pp09P7OU25th2UBo+gAigZidcyTOQg3w@mail.gmail.com>
Subject: Re: [RFC] Sending NILFS2 patches into upstream
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 5:37=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> Hi Ryusuke,
>
> Currently, you ask Andrew Morton of sending NILFS2 patches into
> upstream. But Andrew is busy and it makes the whole workflow
> complicated and unpredictable.
>
> I am sending HFS/HFS+ patches to upstream. So, I can create the
> dedicated NILFS2 kernel tree on kernel.org and I can send NILFS2
> patches upstream. I believe that it can make the whole patch management
> workflow more flexible and predictable. Also, additional maintainer is
> better than to have only one.
>
> We already had some discussion privately. So, let's continue the
> discussion in the email list. What do you think?
>
> Thanks,
> Slava.

Hi Viacheslav,

Yes, thanks for the suggestion.

As I replied to you privately earlier, I'd welcome your help both with
upstreaming and setting up the git tree on kernel.org.

First, I'll start by adding you as a maintainer.
To do this, I'd like to send a patch with changes to the maintainers
file to Andrew.

Currently, bug fix patches and patches for the next merge window are
being sent to Andrew, so to avoid confusion, I think it would be best
to switch the upstreaming path after the next merge window is over.

I'd like patches after the next merge window to be upstreamed via you.
What do you think about this timing?

As for switching the git repository in the MAINTAINERS file, how about
after 6.19-rc1, again to avoid confusion?

Next, as for upstreaming, one option is for you to directly pick up
patches sent to this mailing list, and I can review and test them.
However, I think it's better to change the maintenance flow gradually,
so initially I would like to pick up patches, add my Signed-of-by tag,
and complement them with appropriate tags such as Fixes or Cc: stable.

To do this, I think it would be best to relay patches or their series
to the repository you set up on kernel.org via my current GitHub
repository.

In practice, I will push the collected patches, signed, with tags like
fixes-6.19-<serial number> or for-6.20-<serial number> to my current
GitHub repository, so please cherry pick them to receive them
initially.

Patches with tags starting with fixes- prefix are intended to be sent
as bug fixes in that cycle, while patches with tags starting with
for-<version number>- prefix are intended to be sent for the merge
window of the next cycle.
It would be ideal if I could automate the notification of pushes, but
initially I will send you an email.

Next, regarding the operation of the repository to be set up on
kernel.org, I think you should create a main branch of the nilfs2
project to send pull requests to Linus.

I haven't created a main branch for the nilfs2 project so far, but I
think it's better to have one when collaborating.

In this regard, how do you maintain the HFS/HFS+ tree?

Thanks,
Ryusuke Konishi
