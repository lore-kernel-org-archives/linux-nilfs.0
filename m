Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED8C2F99BE
	for <linux-nilfs@vger.kernel.org>; Mon, 27 Oct 2025 22:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761603483; cv=none; b=ELbTRhWJ0M+uEXVtfcSdQCHeGmCUBE/WL6CFJTtyAv4Y3Wc1CAAzP2mjSZcdEW0zwdlw8qKb07hp0KIdeTaSbKwpw3+FIYHRXdmKoR+tJz+nYHc47OVf/LNyG8GlbN5Q41pIT3SLARvO7FtJxvHhNc1gxKrvsl76W2pnCSOWlfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761603483; c=relaxed/simple;
	bh=UILyFPHH6WFnH48B4FK/HoaO/ta/M9fvzea4oqNQZE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GtEh51uAjnRDAg++7z/2ZYdk0IeoQx5kBX6fdUhhq3aHO1+43aCuLsZ8tdT+GvO05pH08ajnqXC0/Os2dVUNLv6t/mLgWqT5CI3netD2QGsHIOKSUHk3dEqj2V7lfS7lmRebZw6zzthRyWze5Wwss7FXjVh5vVyGfQiHvQyutVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q5BJyzJF; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q5BJyzJF"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-58b025fce96so4513966e87.1
        for <linux-nilfs@vger.kernel.org>; Mon, 27 Oct 2025 15:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761603478; x=1762208278; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ez6u+oyLVjp14aXPRb5LJtS/2qhJekd0zFngxvClats=;
        b=Q5BJyzJFdGjozI2E1vSCEHQNsS/FocAURcy+T474gverGak0qtNyZjfscraxI0OV/Z
         OS44IpOCIpr0nwfQ766/PEvp+UX5hO26YFZkrcav9Yc0aDPEemnM90rVXI1OSr1pQoL5
         q+B4HVP4ViJ/9BiaMhHDw990UFvYEDHUdUhsoY4ClyKuOCsmZqbGn8qm/zZeqhHtTS9j
         M2oQCQSopQQ8o4dnarEevrA3BJ3MP9iCli0utJE9C0Ib1Y16SAd4vMmBO6tm6nY6b7Xu
         gl2xdl2pDFid7g5USm2ohVzMPRNv5vkp4kFhnww+9ka1FryYqD4j+Y5e/KId58msgvkE
         IBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761603478; x=1762208278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ez6u+oyLVjp14aXPRb5LJtS/2qhJekd0zFngxvClats=;
        b=Ev5wryZ2efYItSLGsktuhVWC6liuWFoLxnEPGDav7Yu7Ao4H79pObZWIkOp+0uqZY5
         tbu/ODyULk9pT+mw5hr/vo4wqljjGe4dtbwhwk7vB/naAYTEm9iF5DF0uQFiK2cFgWHa
         EKdDCjipLsJG5StdI/OuSQOmVHTlAuXR0FzKYA5t3op5gsxD8fcGCCFa13ZySQX4OaDY
         A3IH5Poh1tGrgs8W6TeVC1Vn8EpxJj9wckTGp8+mVQEFti9SA4AHlbId3es998UiO1b+
         F3glenBdeJmtL6ZuIqcUE6VGuyvCUgVM1lMO6i2ix6mRS7S4VcwqOK9ZarymbWrylq63
         WCQw==
X-Forwarded-Encrypted: i=1; AJvYcCWw7SpGHnU95Vufp7gxVGFaXnFR4AFLQPzBmvOforJb5neVBsmPPKpXL8t6cLEHviGEb86Xk2bmIndD/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YweMt3aBdD+Rga7fN07BofAid0MH9gObaZczUyhXzW8m8Z5yuyQ
	YPvVATEp5AOykwhh2OfTAmxqKv6DxJaNOaVuDXZGMzhoCif38ePKf6tk1vmhI243ZbHjAUgKBjQ
	LaX/0TaX0bSncq/oRA80cn0CL+CvY1fQ=
X-Gm-Gg: ASbGncvqbfE1XUfizRTsrcgwuT5vqUHUX7NmxaNAbZPOwBIajVhePFOtSy+e8X2O2vm
	rYsDdq2YtzahNTFPHzWKJMJJt9XGv8SKD5XGtBSI9n6MCf9CxbNUUrS3xoDA9npsQR6JTd7jTed
	KOIo37hus2bLK2kT2h6ZGqMjULYH2sFpbbPlZRYUOrgb/q6b1xQUChkQecGsbblePXSfDmV9rTr
	uNI9Tfm5jWv2L5lDQs3NrsYxkzyqNSwPNmhVT3eluSq0M2MhAmIfsjGbHqU+9OanhFMCAeC
X-Google-Smtp-Source: AGHT+IFMFYtqRx7R2MtY+vJbKiFwScQM6685ttz21KpZqNxkwJe/YPCBqFxxy/srJSqAPy3XcWFnngfTNtlBMkIrfjk=
X-Received: by 2002:a05:6512:2350:b0:58a:f88b:25a1 with SMTP id
 2adb3069b0e04-5930e99bba2mr522791e87.5.1761603477847; Mon, 27 Oct 2025
 15:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68ffe1a8.050a0220.3344a1.03a1.GAE@google.com>
In-Reply-To: <68ffe1a8.050a0220.3344a1.03a1.GAE@google.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 28 Oct 2025 07:17:40 +0900
X-Gm-Features: AWmQ_bljhOEzlenxMlB9xull_iZ5GoO0D5mYiCd2ityCdsjvzvDTGLve7KZBGYU
Message-ID: <CAKFNMo=KN0_D0bh2UjxSAtUxdHt=uTKdMJeODVTY0wUh=z5-bw@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] WARNING: ODEBUG bug in nilfs_detach_log_writer (2)
To: syzbot <syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2025 at 6:18=E2=80=AFAM syzbot
<syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    b98c94eed4a9 arm64: mte: Do not warn if the page is alrea=
d..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux=
.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D14144be258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D158bd6857eb7a=
550
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D24d8b70f039151f=
65590
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b797=
6-1~exp1~20250708183702.136), Debian LLD 20.1.8
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12ce5d2f980=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16136e7c58000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/2c82e514449b/dis=
k-b98c94ee.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a322ed38c368/vmlinu=
x-b98c94ee.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/059db7d7114e/I=
mage-b98c94ee.gz.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/3ad719caa6=
40/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> ODEBUG: free active (active state 0) object: 00000000dacb411a object type=
: timer_list hint: __ll_sc_atomic64_andnot arch/arm64/include/asm/atomic_ll=
_sc.h:-1 [inline]
> ODEBUG: free active (active state 0) object: 00000000dacb411a object type=
: timer_list hint: arch_atomic64_andnot arch/arm64/include/asm/atomic.h:64 =
[inline]
> ODEBUG: free active (active state 0) object: 00000000dacb411a object type=
: timer_list hint: raw_atomic64_andnot include/linux/atomic/atomic-arch-fal=
lback.h:3675 [inline]
> ODEBUG: free active (active state 0) object: 00000000dacb411a object type=
: timer_list hint: raw_atomic_long_andnot include/linux/atomic/atomic-long.=
h:964 [inline]
> ODEBUG: free active (active state 0) object: 00000000dacb411a object type=
: timer_list hint: arch_clear_bit include/asm-generic/bitops/atomic.h:25 [i=
nline]
> ODEBUG: free active (active state 0) object: 00000000dacb411a object type=
: timer_list hint: clear_bit include/asm-generic/bitops/instrumented-atomic=
.h:42 [inline]
> ODEBUG: free active (active state 0) object: 00000000dacb411a object type=
: timer_list hint: clear_nilfs_purging fs/nilfs2/the_nilfs.h:206 [inline]
> ODEBUG: free active (active state 0) object: 00000000dacb411a object type=
: timer_list hint: nilfs_construction_timeout+0x0/0x50 fs/nilfs2/segment.c:=
2893
> WARNING: CPU: 0 PID: 6673 at lib/debugobjects.c:615 debug_print_object li=
b/debugobjects.c:612 [inline]
> WARNING: CPU: 0 PID: 6673 at lib/debugobjects.c:615 __debug_check_no_obj_=
freed lib/debugobjects.c:1099 [inline]
> WARNING: CPU: 0 PID: 6673 at lib/debugobjects.c:615 debug_check_no_obj_fr=
eed+0x390/0x470 lib/debugobjects.c:1129
> Modules linked in:
> CPU: 0 UID: 0 PID: 6673 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 06/30/2025
> pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=3D--)
> pc : debug_print_object lib/debugobjects.c:612 [inline]
> pc : __debug_check_no_obj_freed lib/debugobjects.c:1099 [inline]
> pc : debug_check_no_obj_freed+0x390/0x470 lib/debugobjects.c:1129
> lr : debug_print_object lib/debugobjects.c:612 [inline]
> lr : __debug_check_no_obj_freed lib/debugobjects.c:1099 [inline]
> lr : debug_check_no_obj_freed+0x390/0x470 lib/debugobjects.c:1129
> sp : ffff8000a1547910
> x29: ffff8000a1547950 x28: ffff0000cf608400 x27: 0000000000000000
> x26: ffff80008aed7f20 x25: ffff0000cf608270 x24: ffff800082080a4c
> x23: ffff0000d8cabfc0 x22: ffff0000cf608000 x21: dfff800000000000
> x20: 0000000000000000 x19: ffff0000cf608000 x18: 00000000ffffffff
> x17: 626f206131313462 x16: ffff800082de9540 x15: 0000000000000001
> x14: 1fffe000337db6fa x13: 0000000000000000 x12: 0000000000000000
> x11: ffff6000337db6fb x10: 0000000000ff0100 x9 : c941407f25652900
> x8 : c941407f25652900 x7 : ffff8000805638d4 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff8000807d4f2c
> x2 : 0000000000000001 x1 : 0000000100000000 x0 : 0000000000000000
> Call trace:
>  debug_print_object lib/debugobjects.c:612 [inline] (P)
>  __debug_check_no_obj_freed lib/debugobjects.c:1099 [inline] (P)
>  debug_check_no_obj_freed+0x390/0x470 lib/debugobjects.c:1129 (P)
>  slab_free_hook mm/slub.c:2454 [inline]
>  slab_free mm/slub.c:6611 [inline]
>  kfree+0x120/0x600 mm/slub.c:6818
>  nilfs_segctor_destroy fs/nilfs2/segment.c:2811 [inline]
>  nilfs_detach_log_writer+0x668/0x8cc fs/nilfs2/segment.c:2877
>  nilfs_put_super+0x4c/0x12c fs/nilfs2/super.c:509
>  generic_shutdown_super+0x12c/0x2b8 fs/super.c:642
>  kill_block_super+0x44/0x90 fs/super.c:1722
>  deactivate_locked_super+0xc4/0x12c fs/super.c:473
>  deactivate_super+0xe0/0x100 fs/super.c:506
>  cleanup_mnt+0x31c/0x3ac fs/namespace.c:1327
>  __cleanup_mnt+0x20/0x30 fs/namespace.c:1334
>  task_work_run+0x1dc/0x260 kernel/task_work.c:227
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  exit_to_user_mode_loop+0xfc/0x178 kernel/entry/common.c:43
>  exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
>  arm64_exit_to_user_mode arch/arm64/kernel/entry-common.c:103 [inline]
>  el0_svc+0x170/0x254 arch/arm64/kernel/entry-common.c:747
>  el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
> irq event stamp: 136662
> hardirqs last  enabled at (136661): [<ffff800080559f90>] vprintk_store+0x=
898/0xac8 kernel/printk/printk.c:2329
> hardirqs last disabled at (136662): [<ffff80008ade9670>] el1_brk64+0x20/0=
x54 arch/arm64/kernel/entry-common.c:434
> softirqs last  enabled at (136170): [<ffff8000801f95fc>] local_bh_enable+=
0x10/0x34 include/linux/bottom_half.h:32
> softirqs last disabled at (136168): [<ffff8000801f95c8>] local_bh_disable=
+0x10/0x34 include/linux/bottom_half.h:19
> ---[ end trace 0000000000000000 ]---
> NILFS (loop1): disposed unprocessed dirty file(s) when stopping log write=
r
> NILFS (loop1): disposed unprocessed dirty file(s) when stopping log write=
r
...
> NILFS (loop1): disposed unprocessed dirty file(s) when stopping log write=
r

It seems that a timer-related resource leak was detected in the final
kfree() call of nilfs_segctor_destroy(), which releases the log writer
during unmount.

This issue was supposed to have been resolved already, but it=E2=80=99s
possible that something was overlooked.

If it can be reproduced with a reproducer, I=E2=80=99d like to dig deeper i=
nto
what=E2=80=99s happening.

Ryusuke Konishi
