Received: from mail-yx1-f66.google.com (mail-yx1-f66.google.com [74.125.224.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD1726ED3C
	for <linux-nilfs@vger.kernel.org>; Thu, 25 Dec 2025 04:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766635722; cv=none; b=o0x51htVrBb6hh6ySO5qAoQ/VMoSDIkxPLyHM+MHAvKRlY7g5Ou4WEAo6HghPU79F55bYgEPnGJy3L1GQycp3fKuGZ113rHWAKARse9CMFxqj68CftKcP3On1fNGXQZBIe98LxkOxN5/fVGKRssb7iWapyTBgqpjfMUOBp36LEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766635722; c=relaxed/simple;
	bh=Hx/kNNhPB3SSp9YrmFRGhkkXcpMv+Mo7iEaZsZH7lJw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Grf1qN5OCTNW8zhB5h/g2ckAQoreOkAwgN7vAWZL3vYWpnJE6BIOr1GXHQaRbW3pfpaf2UWwiOEVRp3TUhmiCPOBmWmArVyqjpWXfK24Cr5hXNrfiY1Mki5oxYZKDfjnlhav1B9/iTGEFW0XWRtfLytbI44Z+cvLnyjRhqXOFNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=EQQgM0zJ; arc=none smtp.client-ip=74.125.224.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="EQQgM0zJ"
Received: by mail-yx1-f66.google.com with SMTP id 956f58d0204a3-6446c924f9eso5797082d50.1
        for <linux-nilfs@vger.kernel.org>; Wed, 24 Dec 2025 20:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1766635719; x=1767240519; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Hx/kNNhPB3SSp9YrmFRGhkkXcpMv+Mo7iEaZsZH7lJw=;
        b=EQQgM0zJrnmZWUXHxb4dKCTE9CKVV/5LvOJbJthUB5K2f8Lj4NYNo8Ln23q09Uaa/k
         mqfaxNtxjTPap/MGN+PlIxT2QJak9+BoZghKvpcG+OH15PHEiWRybGzvP0QclUQ2VPPN
         7UtfEhJ1/Dk2tjBNYMuEh/xhUwsDNhPptk2jIlxatJplyc2btB6oBxxFagrnLs1SzVwt
         7MiWkgHMrQQNE+cDi5kVbgxH7WogDrui3L4RogSfu5oBZ67AaNZ70xD7CUBp03m3Do9z
         LIDQoPZ2rrTjK4+Yht5diVjv2+dmvNyNYSPdR7Fk66/AuCVbNG0JNKB73s+FhLb7dKMW
         3gNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766635719; x=1767240519;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hx/kNNhPB3SSp9YrmFRGhkkXcpMv+Mo7iEaZsZH7lJw=;
        b=YA3hW33T5WJbZQJ6oGzubLktcMTfi3G1cMwuk1HpNNdUSRlng3BZN3dLCmePEYYRWV
         ingq4xI2wrRsZ9Du8rhSAU+HkG2efR5TbtDxBRZLUZuH9fBxfJnQB+40l/cpHDPe3WGJ
         1ynXRWxj2UgShEIFYNEz7ZMt1JkQPRbYl8X27GJP1Zd45L3usS28i9AN7v3cgN7bmViO
         4gvQUdEBC8jvFKxuUx/tQ6MNX3u+Hb6CcNrqeb3VUC5MUmKBFSj9J5AIKe2vItiL8UP7
         ah+n0e4oGTYUb1JXRdmgQAmaUZXJglZptxcCLbePUFXN+k/0ejEvux5g2So5rczSWyeh
         WiVw==
X-Gm-Message-State: AOJu0Yy83U4dlheIV+e/L+HLVweQ9B1oleJV96ACqQAApGLauGfmGfmg
	jcWmtJcn3c8Nm6Kx/BbU/FfB2foTRpQjg7S06gr9axxKfF/G+ILGVar73DmZxPv1LxE=
X-Gm-Gg: AY/fxX7Wv1D6AKxqFihwmUWEHwyNbirtBkmA5mrG/6XWj/G305zOLybWR0EIk+dgHNp
	lP/UbeaZTVieth+7iXooo8MFFisBrtse0aO9Nn6KbeSpRcvHg7dYkFLnQuEXM6d4aPT1mTpwcZ1
	/DHW59D4t2qMKuvuLLFLdIlStrMH8QuiU7FCezTGfs79pMaJQ7ww9HS5adMX0nZmyNMa3nxgaZn
	NJi+AbdUK1jCqg+6oIWPiRcj1GRl/40Q0FROFWHSQS5qcCRbPt54Z+mfkrIxj7vGu+9bgXVkrc4
	QC9lPP8R+p2YXzZB8M3lb9fl3D+3CsuDyzU9Wj1doE//bRxv7OnhGbb1sqaRQcR/Vgy5YcrR18b
	2y5/i1AprsF9kxMkt9hgaD9hSx33nW9BzLioQY4FLVKtgFTq+Ex5BsTQfaNdZ1gQJDv5EYUzZbl
	KvAY2jZqs1sDIK5RswbZhNemuzDI3sbaCczbnWw9Xg323ykGao5MBftCTle4hfVumuYYYWrfE4+
	A7gMKl8sJ2u
X-Google-Smtp-Source: AGHT+IFGoV/2HZJTUi19ve/WQQlVibfAOgsPfAfM5igRGjQZGheeOvemscBE6jBGpWeIL+tjujRmrg==
X-Received: by 2002:a05:690e:11c2:b0:642:2cf:f9fb with SMTP id 956f58d0204a3-6466a87ee15mr13155655d50.4.1766635719183;
        Wed, 24 Dec 2025 20:08:39 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:d657:3387:9f65:590a])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6466a92d913sm9016894d50.20.2025.12.24.20.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 20:08:38 -0800 (PST)
Message-ID: <a26d265d95ba5b0d56e5769f0171a9f79f78b9b5.camel@dubeyko.com>
Subject: Re: Status of running xfstests for NILFS2
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
	 <Slava.Dubeyko@ibm.com>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>
Date: Wed, 24 Dec 2025 20:08:36 -0800
In-Reply-To: <CAKFNMonHVHMD0SSc_7AEuzNugFNiQDbru7QkD2qM+9VgXVnTBQ@mail.gmail.com>
References: <ad4826a48dba37fee0fa9949bfdeef8747ab8e93.camel@ibm.com>
	 <CAKFNMok6sj9EPgCBSn=3Uc1ze51jbPH69xEXQtFTej3B1JcTLQ@mail.gmail.com>
	 <66926bf9a9cb9488dd5f8fe9493d366fb3fd7e66.camel@ibm.com>
	 <CAKFNMokvQpOS6KcyxKjHs9bQ7a6Oi37EaaMD+0Vp3xE6HuYOkA@mail.gmail.com>
	 <c2b125c3f1a2b792241800c3fa7b6d6b56450add.camel@ibm.com>
	 <CAKFNMomX4eBT2xFyK3XpK86ghEyB=ZGsLZr7H2C_xqm7Ysusyw@mail.gmail.com>
	 <6b77c17169a39f75f4731073b3315df25f706e82.camel@ibm.com>
	 <CAKFNMokERKfS2GyYhs5DJ4Yb=5Gw=-cD_GOaksvmPkoSj3G9pg@mail.gmail.com>
	 <4631272e19f77b681e71ad649a23705c63cf34fd.camel@ibm.com>
	 <CAKFNMonHVHMD0SSc_7AEuzNugFNiQDbru7QkD2qM+9VgXVnTBQ@mail.gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Ryusuke,

On Wed, 2025-12-03 at 16:52 +0900, Ryusuke Konishi wrote:
> On Tue, Dec 2, 2025 at 3:42=E2=80=AFAM Viacheslav Dubeyko wrote:
> >=20
> > On Fri, 2025-11-28 at 17:29 +0900, Ryusuke Konishi wrote:
> > > On Thu, Nov 27, 2025 at 7:43=E2=80=AFAM Viacheslav Dubeyko wrote:
> > > >=20
> > > > On Wed, 2025-11-26 at 22:00 +0900, Ryusuke Konishi wrote:
> > > > > On Tue, Nov 25, 2025 at 4:53=E2=80=AFAM Viacheslav Dubeyko=C2=A0 =
wrote:
> > > > > >=20
> > > > > > On Fri, 2025-11-21 at 23:17 +0900, Ryusuke Konishi wrote:
> > > > > > > I'm still looking for good BTS, but it might be quicker
> > > > > > > to start
> > > > > > > making them on github now.
> > > > > > >=20
> > > > > > >=20
> > > > > >=20
> > > > > > This was my point. :)
> > > > > >=20
> > > > > > Probably, you need to enable the issue system for NILFS2 on
> > > > > > github somehow.
> > > > > > Because, currently, I don't see anything available. And I
> > > > > > don't remember already
> > > > > > how I did it.
> > > > >=20
> > > > > Okay.
> > > > > I'm thinking of creating a nilfs2 (linux) clone repository at
> > > > > https://github.com/nilfs-dev/=C2=A0=C2=A0=C2=A0=C2=A0 so that we =
can file issues
> > > > > there.
> > > > > Is that okay?
> > > > >=20
> > > > >=20
> > > >=20
> > > > Yes, makes sense. Looks like a good place for collaboration.
> > > >=20
> > > > Thanks,
> > > > Slava.
> > >=20
> > > I've set up an issue tracker on GitHub. It's at the following
> > > address:
> > >=20
> > > https://github.com/nilfs-dev/nilfs2/issues
> > >=20
> > > For now, I have registered the syzbot issue and an issue that has
> > > been
> > > reported recently on the ML.
> > > At the top of each issue, I've included a Link: URL with a
> > > reference
> > > to the related syzbot dashboard or email post.
> > >=20
> > > What about the xfstests issues ?
> > > Shall I add all 156 reported failures? (In that case, I'll just
> > > create
> > > separate issues and include a link to your original report for
> > > each.)
> > >=20
> >=20
> > Great! Let me check that I can access it.
> >=20
> > I believe that it makes sense to create a dedicated ticket with
> > enough details
> > for every failed test. I am ready to create these tickets but it is
> > not quick
> > process. So, we can do it in parallel. I could be not very
> > productive during
> > these and the next week because I am going to spend time for
> > preparation and
> > attending LPC 2025.
> >=20
> > Thanks,
> > Slava.
>=20
> Well, as for the schedule, the merge window has begun and LPC 2025 is
> coming up, so you'll probably be busy, so please proceed
> independently
> at your own convenience.
>=20
> For now, I've labeled the registered issues with xfstests.
>=20
> It seems to be working without any restrictions for now, but please
> let me know if you have any problems operating the issues.
>=20
>=20

I've created the tickets for all xfestests' issues that I was able to
detect. As far as I can see, I can stably reproduce around 50 issues. I
suppose that the rest ones are side effects of other failures or,
maybe, it cannot be reproduced in stable manner. Anyway, it makes sense
to account these issues too for checking what is wrong there. If there
is nothing interesting there, we can simply close these issues.

So, I can start to analyze the issues now. :)

Thanks,
Slava.
