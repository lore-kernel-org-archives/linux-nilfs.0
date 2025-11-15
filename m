Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6355F29D27D
	for <linux-nilfs@vger.kernel.org>; Sat, 15 Nov 2025 15:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763221515; cv=none; b=tPY9yiNrpn1GnZGe75Mc8sRD7VJnTVIXBoQxCzhVamaNSo5tFTbvyIJ2Lk5bC97N+thPF9pkamrbW3P2IUWAtjMd4LJdzQiXUOYh+m0cPysa05n3tMRA5c0UUKb53AlyIWaiVWEfY9587h3dMGK6qAtdKRhYO9rZjjYKQOidCLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763221515; c=relaxed/simple;
	bh=DxmPnCQA6yMWPWscNGakzmFjADmR85Hgnsx+DwSN1HI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LQamVLYeNLQFEe5h728RiKJpgTrYpPGo1IHKz/MJO1ANcxyXxwzwzrmTfzeE6psDwOmuW5POFy9nerBaMu6hC7ROjt1+KX0WIbid+zwNYU6X3AsJTRjq4CG39wqStFxtDwOl7tNxHNWSq/xpq/QPNxejj3D0g22iLssUNcTgZAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SK03FXGi; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SK03FXGi"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59584301f0cso2761790e87.0
        for <linux-nilfs@vger.kernel.org>; Sat, 15 Nov 2025 07:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763221511; x=1763826311; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlFRgicySMMdt47wQVwSSNc19frhEf5/ix02n4IjwPs=;
        b=SK03FXGiApxM2m3TDYyeQ8lvUWZGtkPWSCh+M4YYF5HrFgxwaCdJRyEgVELiYHbZmo
         BIEw2RIk2vHjMwaRwtX+kDgKpS5707pammicoA5qYwkYKIJ6/24O3Ten+9xFA9zwQODz
         P1FhiPqix0dMT3ourXm3KFdga4Vvar/VVtADy/WRqhWFxjl24OHennSA2lCDqQv7MfCS
         XpdqM4nsYaqc9cpWwdiz8EN2C6DEiyFnsLKvAWUILeP3HkYfJS8cpHiz9DhqkgkPk3lx
         V4d/EKYtRvBnzQwYGy61hupVP7WtXSMKwDfcm7H/nv7IjD475imR2UG7GKeWLZmQ8A+M
         ByQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763221511; x=1763826311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nlFRgicySMMdt47wQVwSSNc19frhEf5/ix02n4IjwPs=;
        b=kcRJkhlTbintJbv5NawFf97ClsXo7t8tUm4B4vO+wB3E2IF6ifJd8bbufE42HE2Cms
         FKsYH8LBE2s0U4XOjQEbFo59m/K3Nm3iYxwthXKR1quNJQa+8lOC126xR3pfXBCutyug
         J2Do6Vz5uRf0sjl2lNDBbr56C6A5VVOLs3vIGT1kCprc3hvqmhJ8Ai63jMmA+NSY6Uzy
         mOVZ4fn+jSAx+G/CN+rhMkJJeEOu0srfkeFU5yEdnQTigju3rUhyrOO40ENfAZVV23lE
         Mox1R68YcHnc47zlhjgFpb34kbdGluLBemwQuZiKnA+WJSHectWd02c0ZfJMsbUq6eWj
         YYZg==
X-Gm-Message-State: AOJu0Yz6KagDDUYMhZJ3mH2XEwlVx0HH8SRNZTq9UPxywbYsMv/6ednT
	yTdspkGYKPivyIT8pTaKt4f/FLcLgSalEca9An5xObLsGzm+Vl08/v24EaNjaN8mQx3YMGwp68V
	kINEiPid7PI1fWW6SxGdpHLJDnZj0YCBIhBrv
X-Gm-Gg: ASbGncu6b8ZxObF1vMKbAaxNp0GiekQNcsth83y9NpZGCKYBoxYUFt6j3P+ceg5fHU/
	F2kEw4cT8xpKfEH2X9KhtflpzhfA0Geyj+FvWmARlxVL38Iav/5SeQ/b9adIx6b1T6PYcydjqjV
	6DQrWjMhGdgeV4Twty7N8ctwf3sb+ndc0zZKQms6lHhLKI5JO3+33q6mWVIy8pTs0Ju53BQDRc/
	fJuhJ97vQ7Zpg54rlSIOhVKOiAAfFtRTzE7hPsDHWdZ7nkhtee5+Xg1DohL1pV0WSVT3UZN
X-Google-Smtp-Source: AGHT+IG/6XgnIFUzaUNsLmEvqzlrZse06D6vHBtzCl/rNtlFBgY86EimCbXkuB883/WWmtCFsQRHqMAlhp0jDmB6Qak=
X-Received: by 2002:a05:6512:4028:b0:595:7e73:995c with SMTP id
 2adb3069b0e04-59584211dd2mr1914852e87.44.1763221510866; Sat, 15 Nov 2025
 07:45:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ad4826a48dba37fee0fa9949bfdeef8747ab8e93.camel@ibm.com>
In-Reply-To: <ad4826a48dba37fee0fa9949bfdeef8747ab8e93.camel@ibm.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 16 Nov 2025 00:44:54 +0900
X-Gm-Features: AWmQ_bkEK0pajcFpniakjM4neuCfieYEFkh_jtX6ccpS7KetPLRJ-69_EcH5q7w
Message-ID: <CAKFNMok6sj9EPgCBSn=3Uc1ze51jbPH69xEXQtFTej3B1JcTLQ@mail.gmail.com>
Subject: Re: Status of running xfstests for NILFS2
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "slava@dubeyko.com" <slava@dubeyko.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Viacheslav,

On Fri, Nov 14, 2025 at 9:19=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> Hi Ryusuke,
>
> I did run the xfstests suite for NILFS2. As far as I can see, there are 1=
56
> failed tests and I needed to exclude 2 tests from running.
>
> sudo ./check -g auto -E ./my_exclude.txt
> FSTYP         -- nilfs2
> PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 6.18.0-rc3+ #93 SMP
> PREEMPT_DYNAMIC Wed Nov 12 14:37:49 PST 2025
> MKFS_OPTIONS  -- /dev/loop51
> MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch
>
> <skipped>
>
> Failures: generic/003 generic/040 generic/041 generic/068 generic/074
> generic/075 generic/078 generic/080 generic/086 generic/092 generic/097
> generic/099 generic/100 generic/103 generic/105 generic/109 generic/112
> generic/117 generic/121 generic/122 generic/124 generic/127 generic/129
> generic/131 generic/136 generic/177 generic/182 generic/192 generic/215
> generic/221 generic/237 generic/241 generic/245 generic/246 generic/247
> generic/248 generic/249 generic/251 generic/255 generic/257 generic/258
> generic/260 generic/285 generic/286 generic/307 generic/309 generic/310
> generic/313 generic/316 generic/318 generic/319 generic/322 generic/337
> generic/348 generic/360 generic/363 generic/365 generic/375 generic/376
> generic/377 generic/394 generic/403 generic/404 generic/408 generic/409
> generic/410 generic/411 generic/420 generic/425 generic/428 generic/430
> generic/431 generic/432 generic/433 generic/436 generic/437 generic/438
> generic/439 generic/443 generic/444 generic/445 generic/448 generic/469
> generic/471 generic/478 generic/483 generic/484 generic/485 generic/486
> generic/489 generic/490 generic/503 generic/504 generic/510 generic/512
> generic/516 generic/519 generic/523 generic/529 generic/533 generic/535
> generic/537 generic/539 generic/547 generic/553 generic/555 generic/563
> generic/565 generic/567 generic/568 generic/571 generic/585 generic/589
> generic/590 generic/607 generic/610 generic/611 generic/614 generic/616
> generic/618 generic/629 generic/631 generic/632 generic/634 generic/637
> generic/638 generic/639 generic/640 generic/650 generic/676 generic/690
> generic/695 generic/697 generic/704 generic/706 generic/712 generic/713
> generic/715 generic/718 generic/719 generic/723 generic/724 generic/725
> generic/728 generic/732 generic/736 generic/738 generic/741 generic/742
> generic/749 generic/754 generic/758 generic/759 generic/763 generic/764
> generic/771
> Failed 156 of 767 tests
>
> I needed to exclude generic/740 and generic/753. I am not completely sure=
 what
> is wrong with generic/740 (it could be glitch on my side). But generic/75=
3 fills
> the system log with bunch of errors:
>
> 2025-11-12T18:36:24.171533-08:00 hfsplus-testing-0001 root: run xfstest
> generic/753
> 2025-11-12T18:36:24.175432-08:00 hfsplus-testing-0001 kernel: run fstests
> generic/753 at 2025-11-12 18:36:24
> 2025-11-12T18:36:24.243745-08:00 hfsplus-testing-0001 systemd[1]: Started
> fstests-generic-753.scope - /usr/bin/bash -c "test -w
>  /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec
> ./tests/generic/753".
> 2025-11-12T18:36:26.068288-08:00 hfsplus-testing-0001 kernel: NILFS (dm-0=
):
> segctord starting. Construction interval =3D 5 second
> s, CP frequency < 30 seconds
> 2025-11-12T18:36:26.082067-08:00 hfsplus-testing-0001 nilfs_cleanerd[7633=
54]:
> start
> 2025-11-12T18:36:26.082949-08:00 hfsplus-testing-0001 nilfs_cleanerd[7633=
54]:
> pause (clean check)
> 2025-11-12T18:36:28.111323-08:00 hfsplus-testing-0001 kernel: Buffer I/O =
error
> on dev dm-0, logical block 2621424, async page r
> ead
...
> 2025-11-12T18:36:28.398430-08:00 hfsplus-testing-0001 kernel: NILFS (dm-0=
): I/O
> error writing log (start-blocknr=3D49152, block-c
> ount=3D418) in segment 24
>
> I need to double check but likewise error happens not only for generic/75=
3 test-
> case. As far as I can see, other test-cases also triggered such issue. Bu=
t
> namely generic/753 hangs infinitely with such error messages.

Okay, I'll take a look at xfstests/753 and related tests.
To be honest, I've been busy lately and haven't had much time, but I
hope to have some time after Tuesday.

> I believe it makes sense to account all of these issues in some tracking =
system
> before starting to fix it. Are you using any tracking system for NILFS2 i=
ssues?
> Frankly speaking, I am using github's tracking system for HFS/HFS+ issues=
 [1].
> It's simple enough but I don't need in more complex system for this right=
 now.
> So, what do you think about some bug tracking system for NILFS2?

We don't have a central BTS that we operate. We did have one during
development, but it wasn't open and is no longer usable.
So we either use a mailing list or syzbot, and although I don't
particularly want or use it, nilfs-utils' github plays a role in that
regard.

As for managing issues raised by xfstests, as you say, I agree that a
proper BTS is needed.
However, something that is heavily web-dependent like github doesn't
work well with mailing lists, so I'm honestly not sure if it's a good
solution for this project, apart from github-based development
projects.

In this regard, I think syzbot is good, because email exchanges
naturally become a response history and are easily shared with the
mailing list.
Unfortunately, it doesn't cover the entire issue tracking.

If you're going to use github for issue tracking, it would be better
if it could be set up to be highly compatible with mailing lists.
What do you think?

Personally, I'd like to see a better issue tracking system that can
bridge with email-driven workflows, flexibly connect with AI, and
support OSS activity, but I don't know of anything other than GitHub
that I think would be suitable.

> As far as I can see, syzbot still reports about 5 issues for NILFS2 [2]. =
So, it
> makes sense to account these issues too.

I think it's fine to use it solely for issue management purposes, as
long as it doesn't result in double management.
Therefore, I think we should make sure to always jump to syzbot from
GitHub, etc., as an index, and make good use of syzbot's workflow as
is.

> I am working on Kunit-based unit-tests for CephFS, HFS/HFS+, SSDFS. So, I
> believe that NILFS2 could benefit also from having likewise unit-tests. H=
ow do
> you feel about it?

As for using Kunit, I'm not sure how to effectively extract unit tests
while avoiding I/O and page caching.
Rather, what parts of HFS/HFS+ do you extract and write tests for?

>
> I am going to attend LPC 2025 in Tokyo (December 11 - 13, 2025). And I am
> planning to have 2 free days before conference start. Are you planning to=
 attend
> LPC 2025?

I'm not participating. But welcome to Japan ;)

It might have been a good opportunity to meet you. However, since I'm
not a native speaker, I honestly find email communication more
efficient than face-to-face communication.
Also, while it's not a health issue, personal circumstances have been
making it difficult for me to move around freely recently.

Well, it's not like I can't come at all, so if you still want to have
a face-to-face discussion for the future, please let me know via
private message.

Thanks,
Ryusuke Konishi

> Thanks,
> Slava.
>
> [1] https://github.com/hfs-linux-kernel/hfs-linux-kernel/issues
> [2]
> https://lore.kernel.org/linux-nilfs/6911ad30.a70a0220.22f260.00db.GAE@goo=
gle.com/T/#u
