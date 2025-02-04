Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8EB23B0;
	Tue,  4 Feb 2025 02:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738635638; cv=none; b=C/pLK98e6C3JDgF3Hs4TaO7xv9ZeV5uokua9mWM6vvHeTnbeYgxQ8O5XtihoIgHnrmwMtt0vEJS7JKng6zv75OECCmrQTzmjw0C3vyoDP7tgL/C2RBwo+fN8xd9LsFvjYAaOQOJX1szVxBH/HcF4eKzOOZpVFVSDWB0IY7XEFuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738635638; c=relaxed/simple;
	bh=w56wgNTcHy7sN4WrtDrSW2hWwGFeoKdy/o501PjU634=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VseCD1gM05y/KoR7VBZXtf3g/0Sb+mc9Lh31EFm2cVZLcJJ97MvSORrVEHMR/P+VhqAJUvYGExMNaUb0iwvwPJyxk2nmivvadRfwv23enXoMEu4Ec3+io9itQSV7x7VJhxYvZfFhBkqaUNOl8nY8mRn0iC/is3zu8J+7Z8QzmY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iBhoCSq1; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iBhoCSq1"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53e3a227b82so4703744e87.0;
        Mon, 03 Feb 2025 18:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738635634; x=1739240434; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sib5koDEj9hSsupiDaUBfbc6ojkqSjZC2kdEMK99roU=;
        b=iBhoCSq125Gkqow89H/gtJuCapolce3+uc0AlkCCK+QeWssfh+3ZP5cniT5u2KAFOu
         O+sIhPQSVULVu/rY6Qj4bqIb/RvoOnVPjzY0c0hhuQjTi/kLi5H/zNlu/6eUX47NwL6b
         An7t9CvlKt23VAOLlrWQ1ESgGL4t+BO1hTd9scrNEQ3MSMqFpe39H8HG/B2dcaFbeHxT
         /w1U5w1zBAVwYzOfCnX2qTmzIkzieiUV3SPkWEjGCs+UybEY0qI8z+SoNtkejt/gd13q
         SkuzfGmTl0Gt9ql2LFpQzVyOStNTLgZZPK+DwdKr+pof7Z7/D3UdNze8QiUS2/TGfEb0
         J66g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738635634; x=1739240434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sib5koDEj9hSsupiDaUBfbc6ojkqSjZC2kdEMK99roU=;
        b=kO3FbTqqS5GSYxcei7FmXCY3sGsBX5zPmq8aZrUGoPFfDFwCtK1+tsQjJQP+tqGZk+
         wHFVgQnKHyXSUSTttMlNz4J1m/LzbidS2HsQLXmACKefqrb0sUh6FdcCOUhHNukvFVWf
         mHMztcjcRO8b+vUF/mXpV5efVJvA2tavpZ84dRlsRwyQ0s8JdmbBBuQrTX2h+rpPPKiA
         KGKIABu3NwOr2LGeCgslnMM+is93391EIzib73sR1X1OXg+qs0Xibz/15ofvhI4aakhV
         SwRmKxco6gLhv2ZEnNvAluNOFvZZ1cFeHx6HU8SJBEev4UlfmSY9wtqDTNTjqhfmUFvk
         2mow==
X-Forwarded-Encrypted: i=1; AJvYcCVfYKdC/WqEMTa+ohvoSM2tE28kEuY90tztW9jM5d1P1sEF8aaKHtOCACtHjnKdJFM4HN3olILnTtAFlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgVnTgWWH2XlOE2g8Cv8KZlrGqABcLfztLTBbShs1ZFk4twWp9
	PHPx5nVhbDOxjAkyeLP3nhOz6tlYrQ0KugS/7FuvNMDdiG3ue4hB3N3sf6b8/9UXrbly2sgZGa7
	M7vc79/ldMtEO+jUCqKbMc4PXPY7PLnJD
X-Gm-Gg: ASbGncsZY3f6ksBfZDw9PD5oeyBh6/0GKj0QOeRxTde8vyIv7dLmMuNnO9mN8+puYo+
	vw7JDNVCJMx5zu/njHBXYLT/E+Bh2+r+x2zxbas9gs2IQdXYuyHO7gmicZvEg1hb/YCYpbX02rh
	af6F+R2IhHcZOdU4SwTcXhFkTQzzCMb7g=
X-Google-Smtp-Source: AGHT+IF2o0crBa1jdxmEaZXDPdSh1BZhrQylfMPAdu5TCkW+OvSWbXj1VdCN+42syPn8Qi7Jcl1wixFTU9gU/+XgCVo=
X-Received: by 2002:a05:6512:32c8:b0:544:b5:7487 with SMTP id
 2adb3069b0e04-54400b5765emr198654e87.17.1738635634102; Mon, 03 Feb 2025
 18:20:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67a1111a.050a0220.d7c5a.00a4.GAE@google.com>
In-Reply-To: <67a1111a.050a0220.d7c5a.00a4.GAE@google.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 4 Feb 2025 11:20:17 +0900
X-Gm-Features: AWEUYZkzSuMLPSDnVa4nYAmvlCX4V6arde7JCzuuxH1kvZF0zfyznhLKB3sP7ZE
Message-ID: <CAKFNMok7t_KgxgS3vRL8YbTLcCmZd2F85=zk2zucvH2JwYNtmg@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] general protection fault in __d_unalias
To: syzbot <syzbot+ab57f676a518849a8d57@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 3:55=E2=80=AFAM syzbot
<syzbot+ab57f676a518849a8d57@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    69b8923f5003 Merge tag 'for-linus-6.14-ofs4' of git://git=
...
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D14fbdddf98000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D57ab43c279fa6=
14d
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dab57f676a518849=
a8d57
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Deb=
ian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D15da95f8580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D165f8b2458000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ea84ac864e92/dis=
k-69b8923f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6a465997b4e0/vmlinu=
x-69b8923f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d72b67b2bd15/b=
zImage-69b8923f.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/7d96d510aa=
23/mount_0.gz
>
> The issue was bisected to:
>
> commit 30d61efe118cad1a73ad2ad66a3298e4abdf9f41
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Mon Jan 6 02:33:17 2025 +0000
>
>     9p: fix ->rename_sem exclusion
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D148b7b6458=
0000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D168b7b6458=
0000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D128b7b6458000=
0
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+ab57f676a518849a8d57@syzkaller.appspotmail.com
> Fixes: 30d61efe118c ("9p: fix ->rename_sem exclusion")
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000000d: 0000 [#1] PREEMPT SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
> CPU: 0 UID: 0 PID: 5821 Comm: syz-executor287 Not tainted 6.13.0-syzkalle=
r-09793-g69b8923f5003 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 12/27/2024
> RIP: 0010:__d_unalias+0x199/0x2a0 fs/dcache.c:2969
> Code: 98 00 00 00 4c 89 fb 48 c1 eb 03 49 89 ed 80 3c 2b 00 74 08 4c 89 f=
f e8 65 62 e7 ff 49 8b 2f 48 83 c5 68 48 89 e8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 ef e8 48 62 e7 ff 4c 8b 5d 00 4d 85 db
> RSP: 0018:ffffc90003d9fa98 EFLAGS: 00010202
> RAX: 000000000000000d RBX: 1ffff1100996cb61 RCX: ffff88804d821e00
> RDX: 0000000000000000 RSI: ffff88804cb65a70 RDI: ffff88804cb658f8
> RBP: 0000000000000068 R08: ffff88804e530f6b R09: 1ffff11009ca61ed
> R10: dffffc0000000000 R11: ffffed1009ca61ee R12: ffff88804cb65a70
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88804cb65b08
> FS:  000055555b892380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffe074ff000 CR3: 0000000078440000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  d_splice_alias+0x1e6/0x330 fs/dcache.c:3037
>  nilfs_lookup+0x1c2/0x2a0 fs/nilfs2/namei.c:77
>  lookup_one_qstr_excl+0x126/0x2b0 fs/namei.c:1693
>  do_renameat2+0x706/0x13f0 fs/namei.c:5176
>  __do_sys_rename fs/namei.c:5273 [inline]
>  __se_sys_rename fs/namei.c:5271 [inline]
>  __x64_sys_rename+0x82/0x90 fs/namei.c:5271
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7cc482fad9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe074fe328 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
> RAX: ffffffffffffffda RBX: 00007f7cc4878fc8 RCX: 00007f7cc482fad9
> RDX: 0000000000000000 RSI: 0000000020000800 RDI: 00000000200001c0
> RBP: 00007f7cc48a35f0 R08: 000055555b8934c0 R09: 000055555b8934c0
> R10: 000055555b8934c0 R11: 0000000000000246 R12: 00007ffe074fe350
> R13: 00007ffe074fe578 R14: 431bde82d7b634db R15: 00007f7cc487803b
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__d_unalias+0x199/0x2a0 fs/dcache.c:2969
> Code: 98 00 00 00 4c 89 fb 48 c1 eb 03 49 89 ed 80 3c 2b 00 74 08 4c 89 f=
f e8 65 62 e7 ff 49 8b 2f 48 83 c5 68 48 89 e8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 ef e8 48 62 e7 ff 4c 8b 5d 00 4d 85 db
> RSP: 0018:ffffc90003d9fa98 EFLAGS: 00010202
> RAX: 000000000000000d RBX: 1ffff1100996cb61 RCX: ffff88804d821e00
> RDX: 0000000000000000 RSI: ffff88804cb65a70 RDI: ffff88804cb658f8
> RBP: 0000000000000068 R08: ffff88804e530f6b R09: 1ffff11009ca61ed
> R10: dffffc0000000000 R11: ffffed1009ca61ee R12: ffff88804cb65a70
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88804cb65b08
> FS:  000055555b892380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffe074ff000 CR3: 0000000078440000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:   98                      cwtl
>    1:   00 00                   add    %al,(%rax)
>    3:   00 4c 89 fb             add    %cl,-0x5(%rcx,%rcx,4)
>    7:   48 c1 eb 03             shr    $0x3,%rbx
>    b:   49 89 ed                mov    %rbp,%r13
>    e:   80 3c 2b 00             cmpb   $0x0,(%rbx,%rbp,1)
>   12:   74 08                   je     0x1c
>   14:   4c 89 ff                mov    %r15,%rdi
>   17:   e8 65 62 e7 ff          call   0xffe76281
>   1c:   49 8b 2f                mov    (%r15),%rbp
>   1f:   48 83 c5 68             add    $0x68,%rbp
>   23:   48 89 e8                mov    %rbp,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   48 89 ef                mov    %rbp,%rdi
>   34:   e8 48 62 e7 ff          call   0xffe76281
>   39:   4c 8b 5d 00             mov    0x0(%rbp),%r11
>   3d:   4d 85 db                test   %r11,%r11
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

I tested reproducers locally and found that the issue was fixed with
the latest commit:

#syz fix: fix braino in "9p: fix ->rename_sem exclusion"

Ryusuke Konishi
