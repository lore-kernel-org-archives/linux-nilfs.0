Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2372629D
	for <linux-nilfs@vger.kernel.org>; Wed, 26 Nov 2025 13:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764162069; cv=none; b=iag8UQogJYO/T22B7RnpCU9T7xbptbIvAHEQqN2j3mp3jCFAK5lcl3Sg3xggQvZfd0WrWa+1X77csM6naya6v8RLqQzEXKPi9CTn63aara9KLbW6fNUT32GkBaT+xKjawCDfBYWbex9aSdH76T++jtnUHDWW9JFRo7xDMjjT+90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764162069; c=relaxed/simple;
	bh=7cHDrqsS/qccNC9STTchOu38Dv1adJ9TYYw2Cq6nrRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wm54Lu2mFK2kAS5l3pQyOm/oniT/+GrH+KPMk/0cPgsQ9CglGE+Z8kE1nFBqepwEi3drhsorQdxRqugkZt8Yv44OGJu4xs14LMwMOlmg1F1qFnwiFsLC4HAHLx01WyabUGx/Ojcr/5alnzbjgft4oZnLv5nS85vnHV064QYNmI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LMoXRmUM; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LMoXRmUM"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-37b9d8122fdso56094431fa.3
        for <linux-nilfs@vger.kernel.org>; Wed, 26 Nov 2025 05:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764162064; x=1764766864; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3fUVoqKm+uoUSG3lYzJu36XHyjBIoYBCgdHO+Cf9hnA=;
        b=LMoXRmUMkV2l1aoXURNS6rqTdh+NNPf6VBCIakeKYerqMYjTb904yEFdjVkBBbjvsm
         Dx1HP/Shz6vopjsols8BYVYKD7X3GD4fGC1psmlHMNr7dFtKZx1p4ABnNZ+csOXSz69/
         +YKBa3UaIbHjG3u68+6/KkkTG+6stMEyetLwpu8Hqj3x5tzOzsLQA1ieOAJC1BNwF/w4
         neETBQJsHIjCHqvmNBhWwudpWvuS7XgE1Xw56vBtjtG/812uhW6n4/TWQbhA2W4lrJuS
         oTax8HI0JfhCsVZ4Y5N8fHhKld7XNlEJ7dBG/Wc7DObsLjwxde84pHuEOTLNRf/NKLj9
         v1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764162064; x=1764766864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3fUVoqKm+uoUSG3lYzJu36XHyjBIoYBCgdHO+Cf9hnA=;
        b=MgmiB2u9SiXmqkC3Y+mB7Un2y/QhdVgjOlc0sBgtX2641eoThDjmH8Q+1OFFHSvTJb
         /JVca+YZ9bOAODgtx0gCdfaE7CiuIqwbRfqOZnDC3Zr9ue03AUEItG7iShj1u+FkIXDd
         ZERpkxHZQ2MjmgUzBhNwlvZ3RcWwb2ZwAoHVXfZS8p9SkR1NDlzBPYPvShawSipCaxjp
         b3/b0freQloqLfZe3gG0H/kOCnueDSxWQShRULQAgcqHVjnTiSuPFKHQS0I3BvFlVGGY
         g/cU3xmix8N7+MrXS4V1WKx0mb/juOBxIf0V/lJvvPN0rsrDXGD35k4OaDT/W2yLBqvq
         5r0Q==
X-Gm-Message-State: AOJu0Yymj2eW+7B7LTgno2Mmn2t3RnA1tpWdKLSMTMMi/9C2ZtcikDJ2
	Tu1rhxzCP3b//Jnt1Kbwpcpi1aXw27+RCjsPCtrZI4U+8jJh3pQBpHd3gPPY96y5Aby4XNeEsfn
	IQWvEhRzx1kwJefjXqDiYO6vk6KWpioRZAy5f
X-Gm-Gg: ASbGncu8hZL5cTGBY/C+8yscwzEW3cVem4dpcpNJwRn5NgjHQ/ojRfRbym7fvetjmO8
	2TYh61qNfwzJSRSp+d4UViGN5/GbnzlIfAV9OuydS3ZDCjbKUuX9AsvfhfvAee0kjoKKRMW2W9z
	rdO8qswDNUiOK664291qxYvsar/SwR1y0iVtlx+hlj0rZwAU3DQdgYSXHxjg7gdFn18TCum21wl
	mHTs/u4yVujQp0izvnKHe3Dx1NKaELVF3dB83e1B7BA9dPMtzxfhZ/BIiLU+M9GjGaXLaAV
X-Google-Smtp-Source: AGHT+IGJoRIseWBLrtx85BP++7c1gyP81XJ0w9VVVoK6wBi3/UJzIXNl9Qzwh7sXxZngEaq4F39H6u+pRR80r0SVjew=
X-Received: by 2002:a2e:954c:0:b0:37a:c4d:8215 with SMTP id
 38308e7fff4ca-37cd91b3cd5mr41528391fa.12.1764162063598; Wed, 26 Nov 2025
 05:01:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ad4826a48dba37fee0fa9949bfdeef8747ab8e93.camel@ibm.com>
 <CAKFNMok6sj9EPgCBSn=3Uc1ze51jbPH69xEXQtFTej3B1JcTLQ@mail.gmail.com>
 <66926bf9a9cb9488dd5f8fe9493d366fb3fd7e66.camel@ibm.com> <CAKFNMokvQpOS6KcyxKjHs9bQ7a6Oi37EaaMD+0Vp3xE6HuYOkA@mail.gmail.com>
 <c2b125c3f1a2b792241800c3fa7b6d6b56450add.camel@ibm.com>
In-Reply-To: <c2b125c3f1a2b792241800c3fa7b6d6b56450add.camel@ibm.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 26 Nov 2025 22:00:46 +0900
X-Gm-Features: AWmQ_bmR2ycepwLtN3XpwwsNrrvgsp8AMllCoyVQi78jthA3V8rCM5FqRB0kwes
Message-ID: <CAKFNMomX4eBT2xFyK3XpK86ghEyB=ZGsLZr7H2C_xqm7Ysusyw@mail.gmail.com>
Subject: Re: Status of running xfstests for NILFS2
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "slava@dubeyko.com" <slava@dubeyko.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2025 at 4:53=E2=80=AFAM Viacheslav Dubeyko  wrote:
>
> On Fri, 2025-11-21 at 23:17 +0900, Ryusuke Konishi wrote:
> > On Wed, Nov 19, 2025 at 8:23=E2=80=AFAM Viacheslav Dubeyko wrote:
> > >
> > > Hi Ryusuke,
> > >
> > > On Sun, 2025-11-16 at 00:44 +0900, Ryusuke Konishi wrote:
> > > > Hi Viacheslav,
> > > >
> > > > On Fri, Nov 14, 2025 at 9:19=E2=80=AFAM Viacheslav Dubeyko wrote:
> > > > >
> > > > > Hi Ryusuke,
> > > > >
> > > > > I did run the xfstests suite for NILFS2. As far as I can see, the=
re are 156
> > > > > failed tests and I needed to exclude 2 tests from running.
> > > > >
> > > > > sudo ./check -g auto -E ./my_exclude.txt
> > > > > FSTYP         -- nilfs2
> > > > > PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 6.18.0-rc3+ #9=
3 SMP
> > > > > PREEMPT_DYNAMIC Wed Nov 12 14:37:49 PST 2025
> > > > > MKFS_OPTIONS  -- /dev/loop51
> > > > > MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch
> > > > >
> > > > > <skipped>
> > > > >
> > > > > Failures: generic/003 generic/040 generic/041 generic/068 generic=
/074
> > > > > generic/075 generic/078 generic/080 generic/086 generic/092 gener=
ic/097
> > > > > generic/099 generic/100 generic/103 generic/105 generic/109 gener=
ic/112
> > > > > generic/117 generic/121 generic/122 generic/124 generic/127 gener=
ic/129
> > > > > generic/131 generic/136 generic/177 generic/182 generic/192 gener=
ic/215
> > > > > generic/221 generic/237 generic/241 generic/245 generic/246 gener=
ic/247
> > > > > generic/248 generic/249 generic/251 generic/255 generic/257 gener=
ic/258
> > > > > generic/260 generic/285 generic/286 generic/307 generic/309 gener=
ic/310
> > > > > generic/313 generic/316 generic/318 generic/319 generic/322 gener=
ic/337
> > > > > generic/348 generic/360 generic/363 generic/365 generic/375 gener=
ic/376
> > > > > generic/377 generic/394 generic/403 generic/404 generic/408 gener=
ic/409
> > > > > generic/410 generic/411 generic/420 generic/425 generic/428 gener=
ic/430
> > > > > generic/431 generic/432 generic/433 generic/436 generic/437 gener=
ic/438
> > > > > generic/439 generic/443 generic/444 generic/445 generic/448 gener=
ic/469
> > > > > generic/471 generic/478 generic/483 generic/484 generic/485 gener=
ic/486
> > > > > generic/489 generic/490 generic/503 generic/504 generic/510 gener=
ic/512
> > > > > generic/516 generic/519 generic/523 generic/529 generic/533 gener=
ic/535
> > > > > generic/537 generic/539 generic/547 generic/553 generic/555 gener=
ic/563
> > > > > generic/565 generic/567 generic/568 generic/571 generic/585 gener=
ic/589
> > > > > generic/590 generic/607 generic/610 generic/611 generic/614 gener=
ic/616
> > > > > generic/618 generic/629 generic/631 generic/632 generic/634 gener=
ic/637
> > > > > generic/638 generic/639 generic/640 generic/650 generic/676 gener=
ic/690
> > > > > generic/695 generic/697 generic/704 generic/706 generic/712 gener=
ic/713
> > > > > generic/715 generic/718 generic/719 generic/723 generic/724 gener=
ic/725
> > > > > generic/728 generic/732 generic/736 generic/738 generic/741 gener=
ic/742
> > > > > generic/749 generic/754 generic/758 generic/759 generic/763 gener=
ic/764
> > > > > generic/771
> > > > > Failed 156 of 767 tests
> > > > >
> > > > > I needed to exclude generic/740 and generic/753. I am not complet=
ely sure what
> > > > > is wrong with generic/740 (it could be glitch on my side). But ge=
neric/753 fills
> > > > > the system log with bunch of errors:
> > > > >
> > > > > 2025-11-12T18:36:24.171533-08:00 hfsplus-testing-0001 root: run x=
fstest
> > > > > generic/753
> > > > > 2025-11-12T18:36:24.175432-08:00 hfsplus-testing-0001 kernel: run=
 fstests
> > > > > generic/753 at 2025-11-12 18:36:24
> > > > > 2025-11-12T18:36:24.243745-08:00 hfsplus-testing-0001 systemd[1]:=
 Started
> > > > > fstests-generic-753.scope - /usr/bin/bash -c "test -w
> > > > >  /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj;=
 exec
> > > > > ./tests/generic/753".
> > > > > 2025-11-12T18:36:26.068288-08:00 hfsplus-testing-0001 kernel: NIL=
FS (dm-0):
> > > > > segctord starting. Construction interval =3D 5 second
> > > > > s, CP frequency < 30 seconds
> > > > > 2025-11-12T18:36:26.082067-08:00 hfsplus-testing-0001 nilfs_clean=
erd[763354]:
> > > > > start
> > > > > 2025-11-12T18:36:26.082949-08:00 hfsplus-testing-0001 nilfs_clean=
erd[763354]:
> > > > > pause (clean check)
> > > > > 2025-11-12T18:36:28.111323-08:00 hfsplus-testing-0001 kernel: Buf=
fer I/O error
> > > > > on dev dm-0, logical block 2621424, async page r
> > > > > ead
> > > > ...
> > > > > 2025-11-12T18:36:28.398430-08:00 hfsplus-testing-0001 kernel: NIL=
FS (dm-0): I/O
> > > > > error writing log (start-blocknr=3D49152, block-c
> > > > > ount=3D418) in segment 24
> > > > >
> > > > > I need to double check but likewise error happens not only for ge=
neric/753 test-
> > > > > case. As far as I can see, other test-cases also triggered such i=
ssue. But
> > > > > namely generic/753 hangs infinitely with such error messages.
> > > >
> > > > Okay, I'll take a look at xfstests/753 and related tests.
> > > > To be honest, I've been busy lately and haven't had much time, but =
I
> > > > hope to have some time after Tuesday.
> > > >
> > >
> > > It's OK. We are not in a hurry. And it's a lot of tests are failing r=
ight now.
> > >
> > > > > I believe it makes sense to account all of these issues in some t=
racking system
> > > > > before starting to fix it. Are you using any tracking system for =
NILFS2 issues?
> > > > > Frankly speaking, I am using github's tracking system for HFS/HFS=
+ issues [1].
> > > > > It's simple enough but I don't need in more complex system for th=
is right now.
> > > > > So, what do you think about some bug tracking system for NILFS2?
> > > >
> > > > We don't have a central BTS that we operate. We did have one during
> > > > development, but it wasn't open and is no longer usable.
> > > > So we either use a mailing list or syzbot, and although I don't
> > > > particularly want or use it, nilfs-utils' github plays a role in th=
at
> > > > regard.
> > > >
> > > > As for managing issues raised by xfstests, as you say, I agree that=
 a
> > > > proper BTS is needed.
> > > > However, something that is heavily web-dependent like github doesn'=
t
> > > > work well with mailing lists, so I'm honestly not sure if it's a go=
od
> > > > solution for this project, apart from github-based development
> > > > projects.
> > > >
> > > > In this regard, I think syzbot is good, because email exchanges
> > > > naturally become a response history and are easily shared with the
> > > > mailing list.
> > > > Unfortunately, it doesn't cover the entire issue tracking.
> > > >
> > > > If you're going to use github for issue tracking, it would be bette=
r
> > > > if it could be set up to be highly compatible with mailing lists.
> > > > What do you think?
> > > >
> > >
> > > I like your suggestion. But what particular BTS candidate do you have=
 in mind?
> >
> > Github comes to mind here.
> > When you use GitHub for HFS/HFS+, do you apply any special approach to
> > tie it into the mailing-list workflow?
> > Or do you treat it as a completely separate tool?
> >
>
> Frankly speaking, I simply needed something as fast as possible at that t=
ime. :)
> I created github repository for managing HFS/HFS+ patches before I had
> repository on kernel.org. And I realized that github has pretty simple tr=
acking
> system that integrated into repository. I didn't think about integration =
of it
> into mailing-list workflow. Anybody can add link on issue into patch and =
leave
> any number of comments in the issue's ticket. I considered that it's good
> enough. I assume that in your terminology I am using it as separate tool.
>
> Also, github's tracking system provides the opportunity to assign the iss=
ue on
> people. And it is possible classify issues on project/feature basis. So, =
it's
> simple but reasonable not bad, from my point of view.
>
> But how do you imagine integration into mailing-list workflow? Could bugz=
illa
> provide the necessary features?

Bugzilla is a system that easily integrates with mailing list
workflows, which is probably why it has been in use at kernel.org for
so long. However, to be honest, I don't think it's suitable for a
project starting BTS now.

The requirements I envision are similar to those of syzbot. It's not
difficult. Specifically,

- Interactions with the mailing list should be linked to issues,
allowing for bidirectional referencing.
- Optionally, the ability to indirectly control issue tracking by
sending a specific CC: email to a specific BTS-linked email address
using a specific format (such as syzbot's #syz dup: or #syz fix:
control method).
- More optionally, the ability to use OSS activity support features
(such as syzbot's #syz test: command, which allows us to delegate
reproduction testing).
In today's world, it would be something like the ability to kick off
an AI engine and request a first-stage analysis of the issue using
concise natural language.

I think it would probably be a good idea to register issues on GitHub
anyway, use a self-hosted n8n as the glue for example, and link GitHub
and gmail (for ML integration) with an AI engine like Gemini and
ChatGPT.
However, posting AI output to a public mailing list raises social
responsibility issues, which is an obstacle to a public email-based
workflow.
(We'll probably need a moderation mechanism in place to ensure only
developer-approved content is sent to ML.)

> > > > Personally, I'd like to see a better issue tracking system that can
> > > > bridge with email-driven workflows, flexibly connect with AI, and
> > > > support OSS activity, but I don't know of anything other than GitHu=
b
> > > > that I think would be suitable.
> > > >
> > >
> > > So, this is my worry that we could not find good and free BTS. And, f=
inally, we
> > > will need to use anything not very good but accessible right now. :)
> >
> > Yes, that=E2=80=99s probably how it will end up.
> >
>
> AI becomes more powerful with every day. So, I don's see any problem for =
AI to
> digest even github's issue system. :)
>
> > > > > As far as I can see, syzbot still reports about 5 issues for NILF=
S2 [2]. So, it
> > > > > makes sense to account these issues too.
> > > >
> > > > I think it's fine to use it solely for issue management purposes, a=
s
> > > > long as it doesn't result in double management.
> > > > Therefore, I think we should make sure to always jump to syzbot fro=
m
> > > > GitHub, etc., as an index, and make good use of syzbot's workflow a=
s
> > > > is.
> > > >
> > >
> > > I am simply thinking to have some tracking system that can account al=
l NILFS2
> > > issues. The syzbot has its own tracking system. But, from my point of=
 view, it
> > > makes sense to account syzbot issues like sub-class of issues.
> >
> > I don=E2=80=99t think there=E2=80=99s any difference in our thinking.
> >
> > You mean using GitHub or some other tool to manage the overall set of
> > issues, right?
> > Issues from syzbot would be handled primarily within syzbot, but we
> > would use GitHub or similar as an index alongside other issues.
> > That approach sounds good to me.
> >
> > I'm still looking for good BTS, but it might be quicker to start
> > making them on github now.
> >
> >
>
> This was my point. :)
>
> Probably, you need to enable the issue system for NILFS2 on github someho=
w.
> Because, currently, I don't see anything available. And I don't remember =
already
> how I did it.

Okay.
I'm thinking of creating a nilfs2 (linux) clone repository at
https://github.com/nilfs-dev/ so that we can file issues there.
Is that okay?

Thanks,
Ryusuke Konishi

> Thanks,
> Slava.
