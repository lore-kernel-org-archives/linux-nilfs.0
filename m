Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D412D7DE8
	for <linux-nilfs@vger.kernel.org>; Thu,  6 Nov 2025 19:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762457635; cv=none; b=BRduuQao1uOH/FmNoILcrp3sUMrC/bsClKTq+a88wuUz/zx2Rr2Yww2h0h0YidDTbp1JZ1hOphIIyqsxQoU4TVInDloyYEFRTF/7vHuv0UvhR3xEaWiSVS9LZvEJS8eT7GW7qc+L0j0RywgCNoKpYvIxc7W0yREUvXUX3XY4z1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762457635; c=relaxed/simple;
	bh=4EBJSSA67DveEw/Z7DWhSxlfza5nIkff5O/yMyGngyA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WLOC1uuJhMi6c8H+9EDlodUmJJFllDIifQmOHItp2WvDQEdFt30tdBq6ahB2aYQubKfI80Pk0kz9ItATfR0Ul682jWBbKFl6WebSmTHbyTdVJGYQMs8pgQ34qOGshgvz0FYzeX/82oqYScNxd06McgyxnOiv1kmBm2eXJHItZrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=syGn/4Jt; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="syGn/4Jt"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d6014810fso15177b3.0
        for <linux-nilfs@vger.kernel.org>; Thu, 06 Nov 2025 11:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1762457632; x=1763062432; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=moGTcsgwbwjaNcZHrUXCpdZhNHUnzeQB21HzW/CJGiw=;
        b=syGn/4JtvUaVDtULbOOm1mM6m/BoSWQU5rujsOKB3YTC6RHVzQTyWgDbLXuUeWhSIu
         hDPqJAr0G63GK8zMXISi8fBjXexKEd401I+IBw84dX+NSoFEaFtXuIy5d1f+HyiwCsft
         cSjtfwwJWjdHkfCxdMDw+qH+0uemANLxVdhbyo0z1rIIjaiVQIa7ucwV5QqAqw+K2DZV
         3Q4NthKt3uaqdo90rilM5MHWB6nLB0f6Wt1ipZnaRUOSKXMTpkGJTxPXz3gwG+X7nk9P
         /XETnij53zbQv5AN9A1foMAOeHKWYM7SrYi654kh/KXrfi/cHM/xyV1V+xRd+eVKLEEg
         1n8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762457632; x=1763062432;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=moGTcsgwbwjaNcZHrUXCpdZhNHUnzeQB21HzW/CJGiw=;
        b=FcdCrd1jU1mBB7oAtWN8gm8RUPaf8syaaa8Sjrsi6S4QcZUaqI21cCCC3IIlqXeekX
         1xEG5aFsRtB6JADFh848goNgTO7JYNIMzWBYM4EdN8t87sVMgYBqUY9zETKRJvwSGUyS
         agaLZpPZGb6uLv4vw9DyfmSYzZAjDX0it8vCXL0ppuQsRBEy21AMZBKNzxm4mO7ZNcVL
         fWRhEA0a4OeBgd9kpyfiD939tDVD4/FcnJs28SJWtSjaCxv8I0E5Jy0nJ4eTVk6bZR1P
         Xw9qnamqZVNwASQrp3nnbFg8yicSHWCNfKS97Ej9eU1VXytSLpxEzzXhPbZrxBctE/TU
         6VsQ==
X-Gm-Message-State: AOJu0Yzaw+SIvvyIt6nODmVE7/GgoF1heN37ckbFukt2DdKN7vKjLNey
	Jtjt5iicjk0yonzBJ3j9/gEkPYl0IcpoPrwidQVVmnRCONeoYi29ASJoPUpgZzpqI47sWuRHRpB
	UxYJI
X-Gm-Gg: ASbGncuZligIvPWriHv03RIdPNcVX15f51ZDmvVi9nO7oawGZO9gLr6WPOWbETeW4At
	DvSSv/mqLrX/SzcN2boX4Wn4MsAOtXWd9WfPeqMzAv0ApAwrtOf8INWrGc62B1807iWDGSNGza1
	FrFxI94yEY2U+OvWety84fAPmH00UMr8dHYXeXKiskn2S/Eh3iDbcFSCMZWtK1PvjaphX8ls5Dx
	AuGC/6pmoUfMkM2eibcrrThmYn8DPdtXslxWKxLjUiqjciXnqv8v5Ui5FNDCrFq9t7qQYsnQAuD
	p7beLGOur62VdshJJ+RHWBEjvhr3zYADc5ZYlWio92wwBp2FrSo+NAKEpdU0qE1CFSsmUvVpQaU
	wOXh08cQX3MCI4Kxu6eNZ7ug1ir/ntyhLImDw33uO/MLIySBaY7Y02ePySE72KiCOMf3s83LXWc
	OzP4qv9PjEqd9Rdz2gzs/kmZ8=
X-Google-Smtp-Source: AGHT+IFgzIlrJqFaWYt8jdo0R0Cb6bVuKbdo+hYDNu7IFGFqab6LsyjwCDPDP/clhDb/5blBmQRhDQ==
X-Received: by 2002:a05:690c:5c02:b0:786:1e02:632e with SMTP id 00721157ae682-787c53354dbmr3885347b3.29.1762457631729;
        Thu, 06 Nov 2025 11:33:51 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:383a:1db6:8e72:6e61])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787b159896bsm10661487b3.32.2025.11.06.11.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 11:33:51 -0800 (PST)
Message-ID: <0850ad95f58a73a39e190dd4e450302158e97b37.camel@dubeyko.com>
Subject: Re: [RFC] Sending NILFS2 patches into upstream
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Date: Thu, 06 Nov 2025 11:33:49 -0800
In-Reply-To: <CAKFNMonZ=pgnHEOEWey_t2Ycd98nfMAAaSm9wDAXv-MEsKYc5w@mail.gmail.com>
References: <73c75a4192c45e9c8b5054e0ac67f586a8c41589.camel@dubeyko.com>
	 <CAKFNMomaK8UYcgjvx_Pp09P7OU25th2UBo+gAigZidcyTOQg3w@mail.gmail.com>
	 <a5bf62ed31574f647fc34ad63af7fda8dc17622d.camel@dubeyko.com>
	 <CAKFNMonZ=pgnHEOEWey_t2Ycd98nfMAAaSm9wDAXv-MEsKYc5w@mail.gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Ryusuke,

On Wed, 2025-11-05 at 15:44 +0900, Ryusuke Konishi wrote:
> Hi Viacheslav,
>=20
> On Wed, Nov 5, 2025 at 5:10=E2=80=AFAM Viacheslav Dubeyko wrote:
> >=20
> > Hi Ryusuke,
> >=20
> > On Tue, 2025-11-04 at 19:41 +0900, Ryusuke Konishi wrote:
> > > On Tue, Nov 4, 2025 at 5:37=E2=80=AFAM Viacheslav Dubeyko wrote:
> > > >=20
> > > > Hi Ryusuke,
> > > >=20
> > > > Currently, you ask Andrew Morton of sending NILFS2 patches into
> > > > upstream. But Andrew is busy and it makes the whole workflow
> > > > complicated and unpredictable.
> > > >=20
> > > > I am sending HFS/HFS+ patches to upstream. So, I can create the
> > > > dedicated NILFS2 kernel tree on kernel.org and I can send
> > > > NILFS2
> > > > patches upstream. I believe that it can make the whole patch
> > > > management
> > > > workflow more flexible and predictable. Also, additional
> > > > maintainer
> > > > is
> > > > better than to have only one.
> > > >=20
> > > > We already had some discussion privately. So, let's continue
> > > > the
> > > > discussion in the email list. What do you think?
> > > >=20
> > > > Thanks,
> > > > Slava.
> > >=20
> > > Hi Viacheslav,
> > >=20
> > > Yes, thanks for the suggestion.
> > >=20
> > > As I replied to you privately earlier, I'd welcome your help both
> > > with
> > > upstreaming and setting up the git tree on kernel.org.
> > >=20
> > > First, I'll start by adding you as a maintainer.
> > > To do this, I'd like to send a patch with changes to the
> > > maintainers
> > > file to Andrew.
> >=20
> > Sounds good! Probably, I can create the NILFS2 kernel tree on
> > kernel.org at first. And, then this patch can be sent with adding
> > the
> > link to this kernel tree into MAINTAINERS file.
>=20
> Yes, it's OK to set up a git repository first.
> In that case, we will only need to make the changes to the
> MAINTAINERS
> file once, so I'll send one patch for the next merge window.
>=20
> Not only do we add an M: field and switch the T: field, but the S:
> field in the MAINTAINERS file should also be updated to reflect the
> current status, so I'll make these changes all at once.
>=20
> Please let me know where the repository is once you've set it up.
>=20
> >=20

I've created the repository today:

git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git

And I've added two branches there:

git branch --all
  for-linus
* for-next
  master
  remotes/origin/HEAD -> origin/master
  remotes/origin/for-linus
  remotes/origin/for-next
  remotes/origin/master

Thanks,
Slava.

