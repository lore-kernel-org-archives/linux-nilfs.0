Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B753D27E056
	for <linux-nilfs@vger.kernel.org>; Mon, 13 Oct 2025 10:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760349607; cv=none; b=ic6C5ckq/wPcBY0IzLFkN/a8TyHfaJAkAqWV2zg0MGmeG3ju36Lj0U2yBcAtEkk07SwA4jeV8NpvAu6Nq4linyfv0BGaGbuN0Po1aUpOsGTfE5uWqsbIL00lS2z5/lpFVDGs+3AKuhp6nJF5+e4yeMoPtsm9uTdhF4f0/0HsH88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760349607; c=relaxed/simple;
	bh=ggnyA3kxG6CoQ3vXWGlwMnvcvMktf+5EOF746UrDjRc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VL1Ah0RGWeW420V7HIB0cprOnDcpOVbv5kZ1sdi9oetyOJQt5hKZmJ0xIhqSNDbQvM9XpGUPlDp87v2FL7KRjk4b34qBzWGE62hqfReDC6Y0HYLa+lSSzq0A2hHtZ2r5kJRoaBVIevo1yTghQtngJfm5lG6EIVlUFDs1aHStK4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P7CdS07l; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7CdS07l"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-37634d352dfso27079471fa.3
        for <linux-nilfs@vger.kernel.org>; Mon, 13 Oct 2025 03:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760349603; x=1760954403; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EiFGsv+q7tjprCxeoeL7dgR+ZZNn4QBuvfBmQxN5GYg=;
        b=P7CdS07l0TG/mQgf4wXhCtRyTaxuY21/uxdgPnLiOKZ6lLfrXA2wOL+XFm48njcgxX
         v9BbYEelxDfH3Y3VB+YGIXjLFZcsu6KaWudYtcnST0ZNVHoqcf5XJihDizLGGpzYM/xb
         oMOslezwXQTi7m/2D9yca6NmBuUXKipHkYje81bTXMHzGmFDZ6boHEnyxkpcktAgcHEo
         AMiLx86mD6OvgOWYGQy72TENr1VZ4Ma2llF/3GdMTyfdkJsUiSsK2uWrYigqBm06x7Fo
         L/CFR9ej/H7ParedQiedp2B2l81Nfw+zXWw7YpkC3tZKq62GKU7/z7AGtmI/dar/7Bao
         QIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760349603; x=1760954403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EiFGsv+q7tjprCxeoeL7dgR+ZZNn4QBuvfBmQxN5GYg=;
        b=NC/WujcUYa7BOn2zw8gHEWXBJpBc2SvGzty6Ik68jwdw4M9Yl81yhUha6LhA5Wk6RC
         kvX1z1EX78RHEV8Ug1/1/iOtKKknZxzeHS1FfkeXkRHQofuQ0j7L8q83ApEK08lhwIQJ
         NUKYmp5/b8r+z0DSLW0rw8i+5HXu/Qsvg3ndhkCNMbqdeC8Fl+MaYXmyeASoAjkl87QE
         YcgpkqfIy+S5El0PEpy8DqwEV/nDsOmbmbe+3eVhibtFILmYyOu1QK0AoDaLlesmEsdn
         V+fctNJHC56tS0Y5xoP5milWwbRk1VIDqzySnmAp6cZGPYBaYTp2/YpTUIPkMjeyf6ww
         CYYA==
X-Gm-Message-State: AOJu0YyUpRnO+BZODDAL5F5FHvGbZrJ6Xqw2QJiYemdNSklN/JDBREB6
	Kge0yoJdjx62ve/5qLjp7OO4gL9JN1jdppVO4rB67cqCfjxWNOBWbzbMoz3PYsfwP9K6DbQSvOG
	AF3yOLbu6UM8To6Q0u/mgn4jKMT9UjdE=
X-Gm-Gg: ASbGncvc/nfBPSfihub712M+vmmVmk3X526ulZjbxC+J/jkJdV8zj7gsNWjBaK6/XDv
	dPVl6Emvj5gmE6pOQQxj7omHvNbwGlUoD+n7n7MEN3lrsBolSTuxvH6xYslvn2kMxG15fWULH15
	ijz8K0bBP3h5KbKddG++y36pMMhINtPn71n4wXtJ9BAecfrlnkXbQjQxbHGxzZO/KP3KiyOEwuN
	IGJiZnjw5MSsMPLHRAt3fAeLxQbN6LFUPPOZicyUTDLZOwOJMUwnaDcVdal
X-Google-Smtp-Source: AGHT+IG7Vvd+EbqWJ9Fq93ynTxsvmlgSIP76WxU+PGqW3LIvmG6XXlXkLAC+zV/ufKtPHhl8cwdN6KzLo5NTAhK2M2s=
X-Received: by 2002:a2e:bcd3:0:b0:370:4d3e:7a7b with SMTP id
 38308e7fff4ca-37609e4638dmr55220001fa.22.1760349602430; Mon, 13 Oct 2025
 03:00:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68a82586.a00a0220.33401d.0251.GAE@google.com> <68ecc3e7.a70a0220.b3ac9.0018.GAE@google.com>
In-Reply-To: <68ecc3e7.a70a0220.b3ac9.0018.GAE@google.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 13 Oct 2025 18:59:45 +0900
X-Gm-Features: AS18NWDHTAsGWZvODheBc1kJzZriUQyKA3xAnTof13KyeFZuiD8P2150oFmETqM
Message-ID: <CAKFNMo=Q3eMgxwH55v4D-MAzU9n-fUvY4OCfDqbhEb=y1_o61A@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] WARNING in nilfs_rename (2)
To: syzbot <syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com>
Cc: linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 6:23=E2=80=AFPM syzbot
<syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    2b763d465239 Add linux-next specific files for 20251010
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1584730458000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D99cb6b007a888=
9ef
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Df6c7e1f1809f235=
eeb90
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b797=
6-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1191867c580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1384730458000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/6a00344625c3/dis=
k-2b763d46.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cd34c500f8eb/vmlinu=
x-2b763d46.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/660905c62cb2/b=
zImage-2b763d46.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/25cb8f0127=
0c/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: fs/inode.c:417 at drop_nlink+0xc5/0x110 fs/inode.c:417, CPU#0: s=
yz.0.217/6748
> Modules linked in:
> CPU: 0 UID: 0 PID: 6748 Comm: syz.0.217 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/02/2025
> RIP: 0010:drop_nlink+0xc5/0x110 fs/inode.c:417
> Code: 70 07 00 00 be 08 00 00 00 e8 07 da e7 ff f0 48 ff 83 70 07 00 00 5=
b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc e8 dc 26 82 ff 90 <0f> 0b 90 eb 81=
 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff
> RSP: 0018:ffffc9000c52f9d0 EFLAGS: 00010293
> RAX: ffffffff823e1d34 RBX: ffff88805699e008 RCX: ffff888027213c80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff8f9e1877 R09: 1ffffffff1f3c30e
> R10: dffffc0000000000 R11: fffffbfff1f3c30f R12: 1ffff1100ad33c0a
> R13: ffff88805699d368 R14: ffff88805699e050 R15: dffffc0000000000
> FS:  00007f06f15f66c0(0000) GS:ffff888125d0b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fa97ff3f000 CR3: 0000000072f60000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  nilfs_rename+0x46a/0x820 fs/nilfs2/namei.c:418
>  vfs_rename+0xb34/0xe80 fs/namei.c:5216
>  do_renameat2+0x6a2/0xa50 fs/namei.c:5364
>  __do_sys_rename fs/namei.c:5411 [inline]
>  __se_sys_rename fs/namei.c:5409 [inline]
>  __x64_sys_rename+0x82/0x90 fs/namei.c:5409
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f06f078eec9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f06f15f6038 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
> RAX: ffffffffffffffda RBX: 00007f06f09e5fa0 RCX: 00007f06f078eec9
> RDX: 0000000000000000 RSI: 0000200000000180 RDI: 0000200000000040
> RBP: 00007f06f0811f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f06f09e6038 R14: 00007f06f09e5fa0 R15: 00007fffd3cbc518
>  </TASK>
>
>
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.

I have confirmed that this issue can be reproduced in 6.18-rc1 with
the reproducer.
It is not 100% reproducible, but I was able to reproduce it by
enabling the panic_on_warn option and continuing to run the program
for a while, so at this point I suspect that it is due to some kind of
underlying timing issue.

Ryusuke Konishi
