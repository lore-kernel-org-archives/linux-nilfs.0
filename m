Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4113F17556;
	Tue, 16 Jul 2024 03:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721101815; cv=none; b=KjuvHqmz+4l/TJDnONnGcZA0eLJoGyJL+HtqAAvarZHAqAeTZOOfRBmQd6U6s1Mnw7NVAmR/le2nam/GgLh1TnvQ8QSLAT7KqRs9WTbXWeY3V2k24289moaPYA0C9fPxQws4Opynna6x8egT4ybbVLAoQmsH+we1hI+vUnz+8eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721101815; c=relaxed/simple;
	bh=3uwgV1BPGOp5LI11pjXTSlHn5AJ0MqKK2/hNhZQnv0w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kveOF4l0dfkKAcS+FOL01Jee47ayxkrWDXAZi0ZErrjIwq+3fL9M5IJIaisQt/gwOGjRWS/W2T9kTClrDN7KKArW5CBFW4EyVMi9Co7ql8xcBjIg3r0NCUl0Q7hV+OdYcuoWGzrejCfsObfiV9M0JCNNB+mm28IOCU1wLctBUWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HkrwAQGN; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkrwAQGN"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2eedebccfa4so31069021fa.1;
        Mon, 15 Jul 2024 20:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721101811; x=1721706611; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yivlLehWeWkGzD/Vz1kNg6VHWOFzQFVk0AWHMYW4nk4=;
        b=HkrwAQGNKHOubh1AZe9BqkSLT7aKEUv2RDO3hHwM8QVR1AYpcBbhCyb2T+KpSdWJKf
         mzcx/1d8ZO6Y8v0sXmU4VfkaFx61LfYawO0WW9IWOwDob6IHxrC2VHFRlPeqLFGyYept
         DlnpFX8mHnVA+/rbC17Aax5dNm7JfWSEroQlOSOfzHj13mg7jreixsiE123Wta7xJsCC
         J06kBOp1VKukXB+v3VBwxewo8lFEmOip6qaB2nOVAGNlY55wQvtJGR0z6XpR29HFKoPd
         lzGT7gmYU5tPao0hipx9md/YJFGgAC1bbABRnmb3/t3Wv/djtQVLXtB2wzWXZ1XNwVl9
         FwSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721101811; x=1721706611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yivlLehWeWkGzD/Vz1kNg6VHWOFzQFVk0AWHMYW4nk4=;
        b=AElNdqU127GqteEPTJYE3+vatdW3eZQj7dmd/8jZtI/zDKp7z/fKo1mF1I7MMBnkz2
         UOQoTWrEmjrh84Scx/umVb0N3CTmm4nHYIMT8ZmG10bvtKlZouQlE5EmjbyQU5cwEL4x
         paDQmh5IyBXqm67IeDMjgA+HBhoGOoh7Vse/XgvHMRaHygu9bTecPvRa6RpfOoYb5J8u
         iIwnPbYfSKf+i3g2HawPhyDT5A7Jv+wgPbWI0WvM7S5+JxBeCpRQqOiB2sanNBqpq3Wa
         vBJVc/TwpAeHwpmOsas8C3jSIv3G4n1ylPZFqzfmk1KjujVGch0HTZ1JLSmJVVdM5sys
         qYjA==
X-Forwarded-Encrypted: i=1; AJvYcCXwxHbwyW94xrNq9TQoaUOz1gVVjuXs8gYy0I6JSJjl5qnkcu8A0QQBWQh1Gf1Hd9E2bzQB5cdQLT58zDcRyy7xQa9FiVmczxtZD+Q=
X-Gm-Message-State: AOJu0YyavQnzPGspReEax0GIl5J7PEHUXS/U4ANIIjX0ZK7uFUH7nXGe
	NPsdLVmMrTwDkhaaafojMoWon3W0Jo3noTrEOWGx+Fk44PokK7mLwCNgIiSN4KdCROIyeDm4NWp
	FLUEkE+hM0ZGVKTDR2vSlduPY2g4=
X-Google-Smtp-Source: AGHT+IEGE4nIBBg5HnJ7jxFNH55nZTExCc7xv8PNRrw/vwzTBcn4E3dcYVEnlRxnCYVqDm6D2tGD78G1wrYPNE4dJzY=
X-Received: by 2002:a2e:9acd:0:b0:2ee:56b0:38e3 with SMTP id
 38308e7fff4ca-2eef4184785mr6570951fa.24.1721101810837; Mon, 15 Jul 2024
 20:50:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000098d783061af2f133@google.com> <CAKFNMokFbVm5CBMLUCXoFwL3phAWDZLNhMykOxL+hvGMX8Cq_Q@mail.gmail.com>
In-Reply-To: <CAKFNMokFbVm5CBMLUCXoFwL3phAWDZLNhMykOxL+hvGMX8Cq_Q@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 16 Jul 2024 12:49:54 +0900
Message-ID: <CAKFNMomks7UdhmCjgC=D+8Ez+meLTUdA7+oCZOPnXq4TH_LoWQ@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] KMSAN: uninit-value in nilfs_add_checksums_on_logs
 (3)
To: syzbot <syzbot+206133fb2e7b32bba4be@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 16, 2024 at 8:03=E2=80=AFAM Ryusuke Konishi wrote:
>
> On Sun, Jun 16, 2024 at 4:43=E2=80=AFAM syzbot wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of gi=
t:/..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D12d26ada980=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Df5d2cbf3363=
3f507
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D206133fb2e7b3=
2bba4be
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for D=
ebian) 2.40
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/89eafb874b71/d=
isk-614da38e.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/356000512ad9/vmli=
nux-614da38e.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/839c73939115=
/bzImage-614da38e.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+206133fb2e7b32bba4be@syzkaller.appspotmail.com
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > BUG: KMSAN: uninit-value in crc32_body lib/crc32.c:110 [inline]
> > BUG: KMSAN: uninit-value in crc32_le_generic lib/crc32.c:179 [inline]
> > BUG: KMSAN: uninit-value in crc32_le_base+0x43c/0xd80 lib/crc32.c:197
> >  crc32_body lib/crc32.c:110 [inline]
> >  crc32_le_generic lib/crc32.c:179 [inline]
> >  crc32_le_base+0x43c/0xd80 lib/crc32.c:197
> >  nilfs_segbuf_fill_in_data_crc fs/nilfs2/segbuf.c:224 [inline]
> >  nilfs_add_checksums_on_logs+0xb80/0xe40 fs/nilfs2/segbuf.c:327
> >  nilfs_segctor_do_construct+0x9876/0xdeb0 fs/nilfs2/segment.c:2078
> >  nilfs_segctor_construct+0x1eb/0xe30 fs/nilfs2/segment.c:2381
> >  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2489 [inline]
> >  nilfs_segctor_thread+0xc50/0x11e0 fs/nilfs2/segment.c:2573
> >  kthread+0x3e2/0x540 kernel/kthread.c:389
> >  ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> >
> > Uninit was stored to memory at:
> >  memcpy_from_iter lib/iov_iter.c:73 [inline]
> >  iterate_bvec include/linux/iov_iter.h:122 [inline]
> >  iterate_and_advance2 include/linux/iov_iter.h:249 [inline]
> >  iterate_and_advance include/linux/iov_iter.h:271 [inline]
> >  __copy_from_iter lib/iov_iter.c:249 [inline]
> >  copy_page_from_iter_atomic+0x12b7/0x2ae0 lib/iov_iter.c:481
> >  generic_perform_write+0x4c1/0xc60 mm/filemap.c:3982
> >  __generic_file_write_iter+0x20a/0x460 mm/filemap.c:4069
> >  generic_file_write_iter+0x103/0x5b0 mm/filemap.c:4095
> >  __kernel_write_iter+0x64d/0xc80 fs/read_write.c:523
> >  dump_emit_page fs/coredump.c:895 [inline]
> >  dump_user_range+0x8dc/0xee0 fs/coredump.c:956
> >  elf_core_dump+0x57c7/0x5ae0 fs/binfmt_elf.c:2083
> >  do_coredump+0x32d5/0x4920 fs/coredump.c:769
> >  get_signal+0x267e/0x2d00 kernel/signal.c:2896
> >  arch_do_signal_or_restart+0x53/0xcb0 arch/x86/kernel/signal.c:310
> >  exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
> >  exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
> >  __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
> >  syscall_exit_to_user_mode+0x5d/0x160 kernel/entry/common.c:218
> >  do_syscall_64+0xdc/0x1e0 arch/x86/entry/common.c:89
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Uninit was created at:
> >  __alloc_pages+0x9d6/0xe70 mm/page_alloc.c:4598
> >  alloc_pages_mpol+0x299/0x990 mm/mempolicy.c:2264
> >  alloc_pages+0x1bf/0x1e0 mm/mempolicy.c:2335
> >  dump_user_range+0x4a/0xee0 fs/coredump.c:940
> >  elf_core_dump+0x57c7/0x5ae0 fs/binfmt_elf.c:2083
> >  do_coredump+0x32d5/0x4920 fs/coredump.c:769
> >  get_signal+0x267e/0x2d00 kernel/signal.c:2896
> >  arch_do_signal_or_restart+0x53/0xcb0 arch/x86/kernel/signal.c:310
> >  exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
> >  exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
> >  __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
> >  syscall_exit_to_user_mode+0x5d/0x160 kernel/entry/common.c:218
> >  do_syscall_64+0xdc/0x1e0 arch/x86/entry/common.c:89
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > CPU: 0 PID: 5368 Comm: segctord Not tainted 6.9.0-syzkaller-02707-g614d=
a38e2f7a #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 06/07/2024
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
>
> Ah, this issue appears to be the same as the following issue where a
> memory dump generated by elf_core_dump() gets mixed into the
> filesystem:
>
> https://syzkaller.appspot.com/bug?extid=3D47a017c46edb25eff048
>
> However, the kernel that syzbot tested had the common fix for this
> issue, commit 61b258b0d2f6 ("x86: call instrumentation hooks from
> copy_mc.c") applied.  So the patch may not have fixed the issue.
>
> Ryusuke Konishi

#syz dup: KMSAN: uninit-value in nilfs_add_checksums_on_logs (2)

After checking again, I found that the fix for this issue, commit
61b258b0d2f6 ("x86: call instrumentation hooks from copy_mc.c"), had
not yet been applied to the kernel of commit 614da38e2f7a, for which
the problem was reported.

My initial analysis above was incorrect; this issue overlaps with the
existing bug that has already been fixed.

Ryusuke Konishi
