Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C32A17557;
	Sat, 15 Jun 2024 23:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718492613; cv=none; b=TgDYipqoeIv7FLohqmbFW1DCaX/m+nbcK+buTyp9rDFxTFjz0sCV8eIOCntG7ykV9Rc68hHRESN72sf2u5WsWzwXK+R8H1Wek243c0GTYxUqqaOe9DnDrLqGmmWrXe9dobx3AsMMWLZLovEKwlSsbvTey1RTmDmv+sV3Vs33xQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718492613; c=relaxed/simple;
	bh=XvS2L1z+D9jlUpfHLWr5POLqsFc87mFEhVzBY/AgpNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=alJJrTFpGnsQ2exNMmkG5KMQlQuPk2MhV6W4zgYCpxNodXnSXzRTFJ95ZewCTl6xAs/9w2vQefXmNtqyaktFd3LSsZnpmOEbapeH3prepPVpRRqqfzI3Yyd9mO3+HvGaSbA77JrTvbQNQk1+DigmlaLSsKWIaRIyM4D7kK3YN5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L8LvYxuk; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L8LvYxuk"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52bc274f438so3594332e87.0;
        Sat, 15 Jun 2024 16:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718492610; x=1719097410; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWNkmVPMKJssM+z3oZ8ZidbjWtEw3yUiO5QrS/ig5kQ=;
        b=L8LvYxukdotTVx6LS36tFdQSnU/TFcgSzNfx0ss1N0gG9heZ5r1kiIBPI7pqkGPQVa
         +PuPyRCaK8aA27nOGjHT9SZyHQQl6AvwThkIEZqEIlrEYRm6XRQ65m2/MHqrBf1l7OrE
         I3szu827/+a/Fvuk/iPx0a/0k14d54ocWV1GuL7cskPQGiX9zY8ZLEzSo+eZa0oezEza
         QlrXRrjzV33DWiSfioOpotscJWmaXJD/tLc6nWocITgKksMYVgXDuWxhWKtAdzWZv8PC
         QWCkuTdCufx3nhFAor9vso6wwvmSX4aaRKRVTeIWvro0788rtI0jK/ihRc0toNbVjz/3
         rl6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718492610; x=1719097410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EWNkmVPMKJssM+z3oZ8ZidbjWtEw3yUiO5QrS/ig5kQ=;
        b=V7Fx/oJO6kuOJtOoVbXu2rK3oE9yuk/UnMdWbgMlaYmAPJZyr6GkRCAhF+K1KP1ZbP
         N9+zH1ZIXK2dKsGl1uLH/4gRMCd3ZFM23YzkGnRx0MGkMOAxceiJ5Zk/gjTHbULOUasy
         9fGJpKVYqu4e/m1fZKQaZdUPe+YaoDzrwImVeWzOdZRmuB+dXNy+ZSOxbPzxJd69wtA8
         lYJA+H+iHZ1yCcL2qjgPv+AUo73i722oYwWx7fBrh7TQVAJBud63m4M4uyXlUNxEy9u+
         WZXQfTyKNAWZV7iaOh/gCPP5BxUJRtUTa+BI+EhLFO4DdpwDewDxgv8R3O3xCQwhmFMl
         NRsA==
X-Forwarded-Encrypted: i=1; AJvYcCU5R8VDXuNPMNJvdKR9cqobkB0gVSgHPcxKOLKFhiRB2SyCq2/xeUY8QR9HT/dLA3TLlAuE+apIn1W5b17c3MMCnxix5HuTJm2b4cc=
X-Gm-Message-State: AOJu0Yzan0jAQELrLbFfKeDtRAR1UyYhUABiTLm8V//DVLpEPOjEqb45
	96Cml7QWqkYE3ANWXKO/93Q+ugw6NkcGIG5AAEPMpZk3faZjG4IST7biOZGxSw5rCjARuwVzKFP
	w3lqSmnteiw/gaG4pewM/SzjjwZA=
X-Google-Smtp-Source: AGHT+IGT6UL1/twWtG4CRn2PFxtzmOYr0lIU553OWvTg+N1mxtAc/EcTvgBHMosVs++NtmMtASS7O7vEf69fRgiB494=
X-Received: by 2002:a05:6512:3b22:b0:52b:9037:9966 with SMTP id
 2adb3069b0e04-52ca6e946b0mr5173986e87.46.1718492609759; Sat, 15 Jun 2024
 16:03:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000098d783061af2f133@google.com>
In-Reply-To: <00000000000098d783061af2f133@google.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 16 Jun 2024 08:03:13 +0900
Message-ID: <CAKFNMokFbVm5CBMLUCXoFwL3phAWDZLNhMykOxL+hvGMX8Cq_Q@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] KMSAN: uninit-value in nilfs_add_checksums_on_logs
 (3)
To: syzbot <syzbot+206133fb2e7b32bba4be@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 16, 2024 at 4:43=E2=80=AFAM syzbot wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of git:=
/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D12d26ada98000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Df5d2cbf33633f=
507
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D206133fb2e7b32b=
ba4be
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Deb=
ian) 2.40
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/89eafb874b71/dis=
k-614da38e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/356000512ad9/vmlinu=
x-614da38e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/839c73939115/b=
zImage-614da38e.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+206133fb2e7b32bba4be@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> BUG: KMSAN: uninit-value in crc32_body lib/crc32.c:110 [inline]
> BUG: KMSAN: uninit-value in crc32_le_generic lib/crc32.c:179 [inline]
> BUG: KMSAN: uninit-value in crc32_le_base+0x43c/0xd80 lib/crc32.c:197
>  crc32_body lib/crc32.c:110 [inline]
>  crc32_le_generic lib/crc32.c:179 [inline]
>  crc32_le_base+0x43c/0xd80 lib/crc32.c:197
>  nilfs_segbuf_fill_in_data_crc fs/nilfs2/segbuf.c:224 [inline]
>  nilfs_add_checksums_on_logs+0xb80/0xe40 fs/nilfs2/segbuf.c:327
>  nilfs_segctor_do_construct+0x9876/0xdeb0 fs/nilfs2/segment.c:2078
>  nilfs_segctor_construct+0x1eb/0xe30 fs/nilfs2/segment.c:2381
>  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2489 [inline]
>  nilfs_segctor_thread+0xc50/0x11e0 fs/nilfs2/segment.c:2573
>  kthread+0x3e2/0x540 kernel/kthread.c:389
>  ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>
> Uninit was stored to memory at:
>  memcpy_from_iter lib/iov_iter.c:73 [inline]
>  iterate_bvec include/linux/iov_iter.h:122 [inline]
>  iterate_and_advance2 include/linux/iov_iter.h:249 [inline]
>  iterate_and_advance include/linux/iov_iter.h:271 [inline]
>  __copy_from_iter lib/iov_iter.c:249 [inline]
>  copy_page_from_iter_atomic+0x12b7/0x2ae0 lib/iov_iter.c:481
>  generic_perform_write+0x4c1/0xc60 mm/filemap.c:3982
>  __generic_file_write_iter+0x20a/0x460 mm/filemap.c:4069
>  generic_file_write_iter+0x103/0x5b0 mm/filemap.c:4095
>  __kernel_write_iter+0x64d/0xc80 fs/read_write.c:523
>  dump_emit_page fs/coredump.c:895 [inline]
>  dump_user_range+0x8dc/0xee0 fs/coredump.c:956
>  elf_core_dump+0x57c7/0x5ae0 fs/binfmt_elf.c:2083
>  do_coredump+0x32d5/0x4920 fs/coredump.c:769
>  get_signal+0x267e/0x2d00 kernel/signal.c:2896
>  arch_do_signal_or_restart+0x53/0xcb0 arch/x86/kernel/signal.c:310
>  exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
>  exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>  syscall_exit_to_user_mode+0x5d/0x160 kernel/entry/common.c:218
>  do_syscall_64+0xdc/0x1e0 arch/x86/entry/common.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Uninit was created at:
>  __alloc_pages+0x9d6/0xe70 mm/page_alloc.c:4598
>  alloc_pages_mpol+0x299/0x990 mm/mempolicy.c:2264
>  alloc_pages+0x1bf/0x1e0 mm/mempolicy.c:2335
>  dump_user_range+0x4a/0xee0 fs/coredump.c:940
>  elf_core_dump+0x57c7/0x5ae0 fs/binfmt_elf.c:2083
>  do_coredump+0x32d5/0x4920 fs/coredump.c:769
>  get_signal+0x267e/0x2d00 kernel/signal.c:2896
>  arch_do_signal_or_restart+0x53/0xcb0 arch/x86/kernel/signal.c:310
>  exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
>  exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>  syscall_exit_to_user_mode+0x5d/0x160 kernel/entry/common.c:218
>  do_syscall_64+0xdc/0x1e0 arch/x86/entry/common.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> CPU: 0 PID: 5368 Comm: segctord Not tainted 6.9.0-syzkaller-02707-g614da3=
8e2f7a #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 06/07/2024
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
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

Ah, this issue appears to be the same as the following issue where a
memory dump generated by elf_core_dump() gets mixed into the
filesystem:

https://syzkaller.appspot.com/bug?extid=3D47a017c46edb25eff048

However, the kernel that syzbot tested had the common fix for this
issue, commit 61b258b0d2f6 ("x86: call instrumentation hooks from
copy_mc.c") applied.  So the patch may not have fixed the issue.

Ryusuke Konishi
