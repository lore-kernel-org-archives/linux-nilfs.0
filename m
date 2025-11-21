Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C3F2609FD
	for <linux-nilfs@vger.kernel.org>; Fri, 21 Nov 2025 14:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763734694; cv=none; b=caGpEMRZ3k5C287MxbxlQQuU4tghWVClf0jzLV1AIp0eaNfR19YJ7SOqzhT11GSpef+LpaZVwHyB+d1j9ldcTahe2ef0OQ0rJkaTlo6OhdzGDEF4QmPp+hDbleC54HfkNW0saYT8s7MihoDpLZu+LhOUIFQ58L3Z2tT60HWdbnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763734694; c=relaxed/simple;
	bh=bvbUKL/SJamLcjrBNBdi6PCEUoIlJwxSWc4qKvr0CWw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gW4JyMSRKz6QHG/RSTrLpEUgD3Ky9k0wbsvEhGnKGvylIfgCHlCxL2NsW5FX6oGci8EUbefu7P9oqkB/eIA1k2ywx5+GLzoNJuYZGUg20rRqc05tHnItpzB9ddzDEZ1iil6KqqrbdYOSsmNJXxpCRTGMF9BDXWPSvQ1qxNfsmIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CQKowFd+; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQKowFd+"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5943b62c47dso2110566e87.1
        for <linux-nilfs@vger.kernel.org>; Fri, 21 Nov 2025 06:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763734691; x=1764339491; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9BoZPgtcIiGo0EOAiP6wWt+zzx0lMzwALnG5TKpmUO0=;
        b=CQKowFd+C+nc9EW7cDhtN0O5zA7zJEpU1rVCvQLiSO2BaKxGiXi1qMhsjs6mPkGZls
         qJjf5+dwok19kCMMKrUNrg3xoY25MIQ6Fzwpc6QIHlmS6rXnl1fJ2UWuZf8NnXFEu/FA
         wyTIy2GrUX2EJ+0nEzZgFuOhT+6joL44GG1a8tYtiNkWPAshPAou0W3SGb1yQhAcM4OE
         cP1sP84PaMJ3OLgR5h3ds8vIUFgjmee37DNOpTXz9KXyvuxVkFC+w/6C/LMvJUKgbLBr
         +3fHLQLwX8BPvHKtXLE17q5mpTrnMKbL35gDpn7OHufRqPjvMyxm9Ljko2Ws8aPHwQgb
         BdCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763734691; x=1764339491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9BoZPgtcIiGo0EOAiP6wWt+zzx0lMzwALnG5TKpmUO0=;
        b=UPIMVSe/ljhf/bVUTdB6wHVhCjCl2sgJ6UcRMKu5xRK9kX9EE6wJx8OkHtubCGs59t
         e1takCXNQRBD3GCQKFq9qA+Gu+WJE+PmgXMnXNj1KgMpRd8+FmTCJRvFcfN7gDvdQz6t
         jN/QfSCdbMWQmxNL0u5LWZLcgqUAYDaL/dm/VxCIiNKxzq/4Aa1Yqxh8JCzXZbIt5IUN
         sf21JttVguDYcoo028Qc74C1wfyJGFwcG4d7v81rug+Cm29/2y+Zrzn4+OBPp0ETcF1h
         qajX1Bf7TuRf3hvpMD3++W/U8Vojm/bsoytWJqWE6Jsxa6vrQxIuWc0h+RLBf+xfLLt/
         IS8g==
X-Gm-Message-State: AOJu0Yw6LPlJotD7/PcMuKOof+o1ofDtpH83thRquR8w6tVyMCuKCbBy
	4W+doDpbB5dP/0tDv2Hnc8ZbI6i+YMttmdOOzoPZPFpfdkZNV/pG7z1dlcueKsEWnitKUywR0dk
	OM2ipLJ1/+uuFKinh3UJ5QI4ImxpmLj8=
X-Gm-Gg: ASbGncvaM1uXgdp4IulV/zZQHsWYOyr/4nr1kCX8xjTC3wPpOKHZ2s4NZ3lPQonpAro
	cE934+TKveQCy1qbWHqK8J97iGCqmvkytZ6UNWqclP8n4i0Kmaj4zQkBBkW946WByrduCg7IpEt
	jzMyHqMxLraONDfWr6IxtOddmDeqZnhdi40lVjyVn7cRfjcgQ+cMjc0PttEczT+NC2GaZieKWzW
	oNBZp9eA3vBiYK/cPfx8u22YwQT/VSOrAPdTs6/janLBXSB/J92M/jR39AWyfIXlh3jDvZh
X-Google-Smtp-Source: AGHT+IHtdDubz7pqVYObzU4xojBa3nnnaIL2hwCqAR+vXcassmT3B4hu1Tzbxhu/rBPZojkq2XWPDzuoYRnIbMc+47g=
X-Received: by 2002:a05:6512:b17:b0:595:8200:9f77 with SMTP id
 2adb3069b0e04-596a3ea7ca9mr839791e87.12.1763734690360; Fri, 21 Nov 2025
 06:18:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ad4826a48dba37fee0fa9949bfdeef8747ab8e93.camel@ibm.com>
 <CAKFNMok6sj9EPgCBSn=3Uc1ze51jbPH69xEXQtFTej3B1JcTLQ@mail.gmail.com> <66926bf9a9cb9488dd5f8fe9493d366fb3fd7e66.camel@ibm.com>
In-Reply-To: <66926bf9a9cb9488dd5f8fe9493d366fb3fd7e66.camel@ibm.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 21 Nov 2025 23:17:53 +0900
X-Gm-Features: AWmQ_blkg25feDw8xHHy4tAzv0Js7EhSgYtX-LTxQsjk2J7reLEGyT9KW8Daens
Message-ID: <CAKFNMokvQpOS6KcyxKjHs9bQ7a6Oi37EaaMD+0Vp3xE6HuYOkA@mail.gmail.com>
Subject: Re: Status of running xfstests for NILFS2
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "slava@dubeyko.com" <slava@dubeyko.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 8:23=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> Hi Ryusuke,
>
> On Sun, 2025-11-16 at 00:44 +0900, Ryusuke Konishi wrote:
> > Hi Viacheslav,
> >
> > On Fri, Nov 14, 2025 at 9:19=E2=80=AFAM Viacheslav Dubeyko wrote:
> > >
> > > Hi Ryusuke,
> > >
> > > I did run the xfstests suite for NILFS2. As far as I can see, there a=
re 156
> > > failed tests and I needed to exclude 2 tests from running.
> > >
> > > sudo ./check -g auto -E ./my_exclude.txt
> > > FSTYP         -- nilfs2
> > > PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 6.18.0-rc3+ #93 SM=
P
> > > PREEMPT_DYNAMIC Wed Nov 12 14:37:49 PST 2025
> > > MKFS_OPTIONS  -- /dev/loop51
> > > MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch
> > >
> > > <skipped>
> > >
> > > Failures: generic/003 generic/040 generic/041 generic/068 generic/074
> > > generic/075 generic/078 generic/080 generic/086 generic/092 generic/0=
97
> > > generic/099 generic/100 generic/103 generic/105 generic/109 generic/1=
12
> > > generic/117 generic/121 generic/122 generic/124 generic/127 generic/1=
29
> > > generic/131 generic/136 generic/177 generic/182 generic/192 generic/2=
15
> > > generic/221 generic/237 generic/241 generic/245 generic/246 generic/2=
47
> > > generic/248 generic/249 generic/251 generic/255 generic/257 generic/2=
58
> > > generic/260 generic/285 generic/286 generic/307 generic/309 generic/3=
10
> > > generic/313 generic/316 generic/318 generic/319 generic/322 generic/3=
37
> > > generic/348 generic/360 generic/363 generic/365 generic/375 generic/3=
76
> > > generic/377 generic/394 generic/403 generic/404 generic/408 generic/4=
09
> > > generic/410 generic/411 generic/420 generic/425 generic/428 generic/4=
30
> > > generic/431 generic/432 generic/433 generic/436 generic/437 generic/4=
38
> > > generic/439 generic/443 generic/444 generic/445 generic/448 generic/4=
69
> > > generic/471 generic/478 generic/483 generic/484 generic/485 generic/4=
86
> > > generic/489 generic/490 generic/503 generic/504 generic/510 generic/5=
12
> > > generic/516 generic/519 generic/523 generic/529 generic/533 generic/5=
35
> > > generic/537 generic/539 generic/547 generic/553 generic/555 generic/5=
63
> > > generic/565 generic/567 generic/568 generic/571 generic/585 generic/5=
89
> > > generic/590 generic/607 generic/610 generic/611 generic/614 generic/6=
16
> > > generic/618 generic/629 generic/631 generic/632 generic/634 generic/6=
37
> > > generic/638 generic/639 generic/640 generic/650 generic/676 generic/6=
90
> > > generic/695 generic/697 generic/704 generic/706 generic/712 generic/7=
13
> > > generic/715 generic/718 generic/719 generic/723 generic/724 generic/7=
25
> > > generic/728 generic/732 generic/736 generic/738 generic/741 generic/7=
42
> > > generic/749 generic/754 generic/758 generic/759 generic/763 generic/7=
64
> > > generic/771
> > > Failed 156 of 767 tests
> > >
> > > I needed to exclude generic/740 and generic/753. I am not completely =
sure what
> > > is wrong with generic/740 (it could be glitch on my side). But generi=
c/753 fills
> > > the system log with bunch of errors:
> > >
> > > 2025-11-12T18:36:24.171533-08:00 hfsplus-testing-0001 root: run xfste=
st
> > > generic/753
> > > 2025-11-12T18:36:24.175432-08:00 hfsplus-testing-0001 kernel: run fst=
ests
> > > generic/753 at 2025-11-12 18:36:24
> > > 2025-11-12T18:36:24.243745-08:00 hfsplus-testing-0001 systemd[1]: Sta=
rted
> > > fstests-generic-753.scope - /usr/bin/bash -c "test -w
> > >  /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exe=
c
> > > ./tests/generic/753".
> > > 2025-11-12T18:36:26.068288-08:00 hfsplus-testing-0001 kernel: NILFS (=
dm-0):
> > > segctord starting. Construction interval =3D 5 second
> > > s, CP frequency < 30 seconds
> > > 2025-11-12T18:36:26.082067-08:00 hfsplus-testing-0001 nilfs_cleanerd[=
763354]:
> > > start
> > > 2025-11-12T18:36:26.082949-08:00 hfsplus-testing-0001 nilfs_cleanerd[=
763354]:
> > > pause (clean check)
> > > 2025-11-12T18:36:28.111323-08:00 hfsplus-testing-0001 kernel: Buffer =
I/O error
> > > on dev dm-0, logical block 2621424, async page r
> > > ead
> > ...
> > > 2025-11-12T18:36:28.398430-08:00 hfsplus-testing-0001 kernel: NILFS (=
dm-0): I/O
> > > error writing log (start-blocknr=3D49152, block-c
> > > ount=3D418) in segment 24
> > >
> > > I need to double check but likewise error happens not only for generi=
c/753 test-
> > > case. As far as I can see, other test-cases also triggered such issue=
. But
> > > namely generic/753 hangs infinitely with such error messages.
> >
> > Okay, I'll take a look at xfstests/753 and related tests.
> > To be honest, I've been busy lately and haven't had much time, but I
> > hope to have some time after Tuesday.
> >
>
> It's OK. We are not in a hurry. And it's a lot of tests are failing right=
 now.
>
> > > I believe it makes sense to account all of these issues in some track=
ing system
> > > before starting to fix it. Are you using any tracking system for NILF=
S2 issues?
> > > Frankly speaking, I am using github's tracking system for HFS/HFS+ is=
sues [1].
> > > It's simple enough but I don't need in more complex system for this r=
ight now.
> > > So, what do you think about some bug tracking system for NILFS2?
> >
> > We don't have a central BTS that we operate. We did have one during
> > development, but it wasn't open and is no longer usable.
> > So we either use a mailing list or syzbot, and although I don't
> > particularly want or use it, nilfs-utils' github plays a role in that
> > regard.
> >
> > As for managing issues raised by xfstests, as you say, I agree that a
> > proper BTS is needed.
> > However, something that is heavily web-dependent like github doesn't
> > work well with mailing lists, so I'm honestly not sure if it's a good
> > solution for this project, apart from github-based development
> > projects.
> >
> > In this regard, I think syzbot is good, because email exchanges
> > naturally become a response history and are easily shared with the
> > mailing list.
> > Unfortunately, it doesn't cover the entire issue tracking.
> >
> > If you're going to use github for issue tracking, it would be better
> > if it could be set up to be highly compatible with mailing lists.
> > What do you think?
> >
>
> I like your suggestion. But what particular BTS candidate do you have in =
mind?

Github comes to mind here.
When you use GitHub for HFS/HFS+, do you apply any special approach to
tie it into the mailing-list workflow?
Or do you treat it as a completely separate tool?

> > Personally, I'd like to see a better issue tracking system that can
> > bridge with email-driven workflows, flexibly connect with AI, and
> > support OSS activity, but I don't know of anything other than GitHub
> > that I think would be suitable.
> >
>
> So, this is my worry that we could not find good and free BTS. And, final=
ly, we
> will need to use anything not very good but accessible right now. :)

Yes, that=E2=80=99s probably how it will end up.

> > > As far as I can see, syzbot still reports about 5 issues for NILFS2 [=
2]. So, it
> > > makes sense to account these issues too.
> >
> > I think it's fine to use it solely for issue management purposes, as
> > long as it doesn't result in double management.
> > Therefore, I think we should make sure to always jump to syzbot from
> > GitHub, etc., as an index, and make good use of syzbot's workflow as
> > is.
> >
>
> I am simply thinking to have some tracking system that can account all NI=
LFS2
> issues. The syzbot has its own tracking system. But, from my point of vie=
w, it
> makes sense to account syzbot issues like sub-class of issues.

I don=E2=80=99t think there=E2=80=99s any difference in our thinking.

You mean using GitHub or some other tool to manage the overall set of
issues, right?
Issues from syzbot would be handled primarily within syzbot, but we
would use GitHub or similar as an index alongside other issues.
That approach sounds good to me.

I'm still looking for good BTS, but it might be quicker to start
making them on github now.

Thanks,
Ryusuke Konishi
