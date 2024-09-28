Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326884A1B;
	Sat, 28 Sep 2024 03:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727495651; cv=none; b=ly9S+R79W/jU84JHEKf/B8W2PuKNneMYVAlqk8v0RKm+m9t5MLpoH4ZFHSv6Lr9Mfxmm+LHTLSfoHPpAeK2Jb8uI4yPnVUVUy3QJhg8H447+jrDWCOS0jm0o5btR+PbXpewizVvq/QI5BID8YNybu93xxT/b8DYCmBRpff/qEFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727495651; c=relaxed/simple;
	bh=rj7UqAEj5nQUkjablc7CjxDbfFQSdJCh0F90jpjERnU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BaZPYs8XTmnUiV3dtksGl+mFPN3dWV3mxV16ch3ngy6ApqR9O3v/qUiceFZApIo2pRJYoabsVOAL7dC8kLXJWrdDBWQGqC2cLAPq7QVLTVD/MHP407cHYkrc5an+iOvHTQp8Ba+C/EFHRCVGzvzekXWHKh/UGpufAHJlR8B4h5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Si+OyKUp; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Si+OyKUp"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5398e7dda5fso30919e87.0;
        Fri, 27 Sep 2024 20:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727495647; x=1728100447; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0qu2RbmNt8gPqRKvTmXGhJ0rCOvq4hj8MvwdpxuHcVg=;
        b=Si+OyKUpv2NUa2yqHrr+NWh53JchCduj8/ko0MUU7AlniAHd4Gdh2iSv68VIv1QWPt
         2JjkB9AHWMgrEXd5acgGbGNvhlbn9IhkCiyIlkIbpSXHApIoCxwbKjXfRPIPpFIsAMap
         IhSFljxAvzTssZKuS2m0EDcGVRUfSN5tzx9jarruH66tpqKgAUnbDjxUOH/r3TqEiVDz
         nA/jqXLNu5nCVdcr7Mpc0BkvEqkCSKLHGaRMRKOPlZmb2bGuQJKgGHP4ZGgwC6cC6LO8
         AcAEIul1PpgBFWd6ePyA7rqdIYJEW7xJ/gOWdq5KRJUOOrGvxwa7Jf25Pl0gglYA8lFz
         dqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727495647; x=1728100447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0qu2RbmNt8gPqRKvTmXGhJ0rCOvq4hj8MvwdpxuHcVg=;
        b=WGD1guufRiQGfChw3xmNZivTaequKooDovaS9lYx8TXnOJy4gido0yvu5FFj2jYnpa
         cDxDVWp4RjYu/phtLHsDBjt80a+8QKVQdEpYd0XGrKVKt5P859VwPqutjjcSnyNlIdyu
         E3cru8mYyAr/uzYR/9ss5F6cItucyrID05B4G1alqec0fKwtgkD4mi3bYhcY0Ppv5JX2
         WhT/sVQ1REMB/2e2Y7aiceHuN7gMiTSFqywaZqsN+wPfF1HODePSMuwhVXBwLoJy/XHu
         Mjyye6vRCz98f3VvVTeQ1JLtLlq9+U+siTmKL8gmpE7L5f8S9VJq21M6OAApeR8p24j7
         bVOQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3OozCbRthTnsg0fuU7J+wxU6yP//CxqXBnn5P40e6FsPqOo8x3P1jInQtEFiVE8x8W2vx7Y99n4pBmoIP@vger.kernel.org, AJvYcCUgJjKPXvwbdEs4XVkEG+kv+ws+etyrb2+lRNJc22NI3m36LOh8R0FHHmCniPb6or6bwWxP1yQdp+hixio=@vger.kernel.org, AJvYcCVZp0++iwV5cDdtPc8WJs+Xaq7JNjOxJzEf+2pi2LkaZIup0NIloz7hvXnQWj/II9zU/85wcG+qDjvsT6k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP0X1rG57ovYhb3fq4NKv1OpOERvfS+tUAYXUlzhSBA+Balo6M
	qwh+0BvWcGIs1wjPuknMGdttw9Wbuz+/5AeijBWJtGzZMl40n0g9EgW9jkkP8qYzWopYRuIi6E+
	Zs6Omj4zU5LNfObjc5b1/J3oqFslonbrN
X-Google-Smtp-Source: AGHT+IFhvJLe27KdjkZ3nhPAKadgpehDnrCg3V3j5B8FSZ2L9iBcuvKGAWVXeJV889MRUBeOohncNNrxFhp+wJnTDW0=
X-Received: by 2002:a05:6512:1054:b0:52c:e05e:849b with SMTP id
 2adb3069b0e04-5389fc63377mr3217782e87.39.1727495646768; Fri, 27 Sep 2024
 20:54:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <66f59678.050a0220.46d20.0001.GAE@google.com>
In-Reply-To: <66f59678.050a0220.46d20.0001.GAE@google.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 28 Sep 2024 12:53:50 +0900
Message-ID: <CAKFNMo=mAYHtfq+QP2v4v9YL7RxEMu-m0BdM5VCW65boHDt34g@mail.gmail.com>
Subject: Re: [syzbot] [serial?] INFO: task hung in vcs_open (8)
To: syzbot <syzbot+8a192e8d090fa9a31135@syzkaller.appspotmail.com>
Cc: Lizhi Xu <lizhi.xu@windriver.com>, linux-nilfs <linux-nilfs@vger.kernel.org>, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2024 at 2:36=E2=80=AFAM syzbot
<syzbot+8a192e8d090fa9a31135@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    88264981f208 Merge tag 'sched_ext-for-6.12' of git://git.=
k..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D1187c19f98000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D74ffdb3b3fad1=
a43
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D8a192e8d090fa9a=
31135
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Deb=
ian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D16aa3ca9980=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1587c19f98000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/87eaf0ad6d60/dis=
k-88264981.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/30c01cf8bc82/vmlinu=
x-88264981.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a1407424ea54/b=
zImage-88264981.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/a8a56914d1=
d8/mount_6.gz
>
> Bisection is inconclusive: the issue happens on the oldest tested release=
.
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D16154c8058=
0000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D15154c8058=
0000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D11154c8058000=
0
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+8a192e8d090fa9a31135@syzkaller.appspotmail.com
>
> INFO: task syz-executor199:5270 blocked for more than 147 seconds.
>       Not tainted 6.11.0-syzkaller-08481-g88264981f208 #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor199 state:D stack:27360 pid:5270  tgid:5255  ppid:5233  =
 flags:0x00004006
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5315 [inline]
>  __schedule+0x1843/0x4ae0 kernel/sched/core.c:6674
>  __schedule_loop kernel/sched/core.c:6751 [inline]
>  schedule+0x14b/0x320 kernel/sched/core.c:6766
>  schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
>  ___down_common kernel/locking/semaphore.c:225 [inline]
>  __down_common+0x346/0x7f0 kernel/locking/semaphore.c:246
>  down+0x84/0xc0 kernel/locking/semaphore.c:63
>  console_lock+0x145/0x1b0 kernel/printk/printk.c:2808
>  vcs_open+0x5d/0xd0 drivers/tty/vt/vc_screen.c:763
>  chrdev_open+0x521/0x600 fs/char_dev.c:414
>  do_dentry_open+0x978/0x1460 fs/open.c:958
>  vfs_open+0x3e/0x330 fs/open.c:1088
>  do_open fs/namei.c:3774 [inline]
>  path_openat+0x2c84/0x3590 fs/namei.c:3933
>  do_filp_open+0x235/0x490 fs/namei.c:3960
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>

The problem caused by this reproducer seems to be an issue on the
nilfs side based on testing with Lizhi's patch (not all logs recorded
are like that), so I will add a nilfs tag:

#syz set subsystems: nilfs, serial

Ryusuke Konishi
