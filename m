Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBCA22068F
	for <linux-nilfs@vger.kernel.org>; Wed,  3 Dec 2025 07:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764748392; cv=none; b=It93MlByPa+FNxaEMPCZ5ifdfy0FEkAlOKwJXdA+rAukH6tgZh7xbY/PqoXtnfOXi/Fo0DYUGSsHQA+JX6LGVa4xSZLACL23qbuqcxKFJmOFANWIpsITKJGbl5Yd78vIzUk3KwIGufUNc8bGEL6wS6plMr6jbvM2vgbn1EjtJA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764748392; c=relaxed/simple;
	bh=+iulPvi45voXyJLSAAQzvxu+KM75M6O/Zh/+nykXVh0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ninxgRdrkcvx2f+9meSLhCoQo2U2tymK9wfVY0cfTgnziUszRnVan8fvp11xfiGF3gqyCu4OxJFJiCaEQf7qlwfg06qGP7Kbkma49kdprx0rCJCE94jmNgQeJqiq/kk9cmxAnes1GfPKKyxcGvgqfEvG7aG2xzVvsdczKm621wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/E+ANPJ; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/E+ANPJ"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5969c5af23bso6552308e87.3
        for <linux-nilfs@vger.kernel.org>; Tue, 02 Dec 2025 23:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764748388; x=1765353188; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dSo1ZiQnRFMkeBsxaCa0cDR3A/N2JeofvEiFLfbo1v4=;
        b=h/E+ANPJKS+3zqQxZy/I6T2wkMpQE3O7DWwjp6MzHEsuNZRe+cyhBz1X0Ew+RW9WrJ
         D3AGuyGE4y9goh+vlD5UaSiRjUy9Nllj24Nj74nxLivD9s0t7F8X45L9SNHq/46eRSzT
         9rinlvXtLbJ9SFuPT5HM6pFjxFmT3TKBEmRieokC27tz70E7pXjbtHwZH4kPb5sFx/bD
         8bJVr9aihzgXFx32ZwCUF9Y0CjsYQDmvByk2F+/H3dhNg2WKkwZ/8wIPpPx/XuJC5VKD
         9U5YrKIyfhOWc1xCS3n48qEIuneNGMyTbuxIEonL13hxfHBzWd16ZsgBd0dAIBw7c4GM
         Geug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764748388; x=1765353188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dSo1ZiQnRFMkeBsxaCa0cDR3A/N2JeofvEiFLfbo1v4=;
        b=Gb4JIcl4FXlpsmCwDrujvz56rb2dniDLC2PZbS0gd8bAAVMplGqiop1Vxk9l2E45C1
         H/ZW6aZixJrgA3rawPmMi5QM97ysewSelyio2smvVAwgaCg8YrokEDcoyeDo/nthh0ix
         HOAwEs6ht28DZYTOsqIgOYv1P0c4Eg1+7TuA57yg3jWeIsSgU6clOBvtdwk/V6k9yB6q
         mkMlZ/F4whqCLaCFpRv6gDzDkv6/0BVV1NfpyUh8bUP5hEprY2X1XKy4RS9y5fxM7FKm
         zX+k7VxWYS5Ki+kdnEr+iOxB8BAv5cC8mT2i3LCBqi+WJTRyfv6mhritQz+Gu6kJG093
         F3SA==
X-Gm-Message-State: AOJu0YwLBHKO+LtAhuMo4ig3zbU7xfRyM6t88aNlJL39HEIFul4dpcwj
	VlXa5eJ0u90hw+kAXg/znsJ7QA6XruwKGNLk68NiPc/Wtj+8z84O8Ep34lfYePBc4JRpUU9Qlky
	vhd6p21C4WSRPzFzveurQzs2CoCfzgo8=
X-Gm-Gg: ASbGnctjUF6M0SrteRL+UywFD2cn8gh+PPzxcp/q6AyLzlFaNahpJhjEJaoRxRGLW5q
	KTpq53eW613dh8Mdib+Fd+rv+7DBiOebLxoq452Rm3eB2x/JP++4kst0T0bNGSbprQfgrMrjUQi
	5bU+pCe3dSWSYp9xGywqixaZZmwDQy+lCL92IRLaFSwJVbXVPZ76AJr0S/fNqrXIOtx7ujLX5yd
	jWLdB0pGeIsPFu7iWxCNcIEfe+YS2DEcAgvzlgBsVn4NvNRCv2T2WaV1eKQzLDbWy/vFe+o6lVM
	kW2GBOw=
X-Google-Smtp-Source: AGHT+IH7lBeSxXmjGpXH2tAR9eIu9GOFHmgfsN6YD+yVOtYvNMM8UZQmKnpRxYcIegqUwy+TNb1KthhiAN2d04GFdSk=
X-Received: by 2002:ac2:4c41:0:b0:597:c862:fd1d with SMTP id
 2adb3069b0e04-597d3f0175fmr552591e87.10.1764748388066; Tue, 02 Dec 2025
 23:53:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ad4826a48dba37fee0fa9949bfdeef8747ab8e93.camel@ibm.com>
 <CAKFNMok6sj9EPgCBSn=3Uc1ze51jbPH69xEXQtFTej3B1JcTLQ@mail.gmail.com>
 <66926bf9a9cb9488dd5f8fe9493d366fb3fd7e66.camel@ibm.com> <CAKFNMokvQpOS6KcyxKjHs9bQ7a6Oi37EaaMD+0Vp3xE6HuYOkA@mail.gmail.com>
 <c2b125c3f1a2b792241800c3fa7b6d6b56450add.camel@ibm.com> <CAKFNMomX4eBT2xFyK3XpK86ghEyB=ZGsLZr7H2C_xqm7Ysusyw@mail.gmail.com>
 <6b77c17169a39f75f4731073b3315df25f706e82.camel@ibm.com> <CAKFNMokERKfS2GyYhs5DJ4Yb=5Gw=-cD_GOaksvmPkoSj3G9pg@mail.gmail.com>
 <4631272e19f77b681e71ad649a23705c63cf34fd.camel@ibm.com>
In-Reply-To: <4631272e19f77b681e71ad649a23705c63cf34fd.camel@ibm.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 3 Dec 2025 16:52:51 +0900
X-Gm-Features: AWmQ_bm3_Al5iku2pOJn3MoZ44pnLzDrjWnT288oGRXAcqMtCkxwIBY7qZNhL6k
Message-ID: <CAKFNMonHVHMD0SSc_7AEuzNugFNiQDbru7QkD2qM+9VgXVnTBQ@mail.gmail.com>
Subject: Re: Status of running xfstests for NILFS2
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "slava@dubeyko.com" <slava@dubeyko.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 3:42=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Fri, 2025-11-28 at 17:29 +0900, Ryusuke Konishi wrote:
> > On Thu, Nov 27, 2025 at 7:43=E2=80=AFAM Viacheslav Dubeyko wrote:
> > >
> > > On Wed, 2025-11-26 at 22:00 +0900, Ryusuke Konishi wrote:
> > > > On Tue, Nov 25, 2025 at 4:53=E2=80=AFAM Viacheslav Dubeyko  wrote:
> > > > >
> > > > > On Fri, 2025-11-21 at 23:17 +0900, Ryusuke Konishi wrote:
> > > > > > I'm still looking for good BTS, but it might be quicker to star=
t
> > > > > > making them on github now.
> > > > > >
> > > > > >
> > > > >
> > > > > This was my point. :)
> > > > >
> > > > > Probably, you need to enable the issue system for NILFS2 on githu=
b somehow.
> > > > > Because, currently, I don't see anything available. And I don't r=
emember already
> > > > > how I did it.
> > > >
> > > > Okay.
> > > > I'm thinking of creating a nilfs2 (linux) clone repository at
> > > > https://github.com/nilfs-dev/     so that we can file issues there.
> > > > Is that okay?
> > > >
> > > >
> > >
> > > Yes, makes sense. Looks like a good place for collaboration.
> > >
> > > Thanks,
> > > Slava.
> >
> > I've set up an issue tracker on GitHub. It's at the following address:
> >
> > https://github.com/nilfs-dev/nilfs2/issues
> >
> > For now, I have registered the syzbot issue and an issue that has been
> > reported recently on the ML.
> > At the top of each issue, I've included a Link: URL with a reference
> > to the related syzbot dashboard or email post.
> >
> > What about the xfstests issues ?
> > Shall I add all 156 reported failures? (In that case, I'll just create
> > separate issues and include a link to your original report for each.)
> >
>
> Great! Let me check that I can access it.
>
> I believe that it makes sense to create a dedicated ticket with enough de=
tails
> for every failed test. I am ready to create these tickets but it is not q=
uick
> process. So, we can do it in parallel. I could be not very productive dur=
ing
> these and the next week because I am going to spend time for preparation =
and
> attending LPC 2025.
>
> Thanks,
> Slava.

Well, as for the schedule, the merge window has begun and LPC 2025 is
coming up, so you'll probably be busy, so please proceed independently
at your own convenience.

For now, I've labeled the registered issues with xfstests.

It seems to be working without any restrictions for now, but please
let me know if you have any problems operating the issues.

Thanks,
Ryusuke Konishi
