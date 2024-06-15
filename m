Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A884179F0;
	Sat, 15 Jun 2024 23:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718494587; cv=none; b=pwbua0/lfk56kmOk/965PFXNe8NvvvCpubYAHDc9ozE/ad217uUrNp8AUVLQyEOvKnL76RZbNNwJSe9vwgHZRg6UGotuvzJk7hgbDVAs9XEv8abGI6OXLx//DnFKMLIUWS+YGad7qThOwqTZX7qxhRsGnVhZ7p+LvG+t9ZG58X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718494587; c=relaxed/simple;
	bh=gJbZRk1lgDNJFrleCKGYFgtdLlDwR+XD35UcewbioYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VhLpomjjOFJAbGdaYcnem8yBcC8MIxw0Xj5bjRLbOZL2ydxOzQim6xWolGl0H2huEePf52ZXd4MeNWujnvioDT5k1BUq05ksJI6FMMLer6aa6qSOsf5JkKR8DLcAo20CE0Q/kt8m+GIrICv50EGJNx7SQMMlaoySJyx7YxkwsF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e6m8aUDe; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e6m8aUDe"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52c7fbad011so3946529e87.0;
        Sat, 15 Jun 2024 16:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718494584; x=1719099384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uu2t3jwVs6P+gBa8LNfJO/zndFSGozsr51+807rPpe8=;
        b=e6m8aUDeDCWregAl0u6FMHRVfcbMQKMKV9Vuwj2YPDCpBzO41hb1BiQnnrWaFc92Vg
         A7MAPxImofA7id3qRGWoVtHggocagqeMF1TV/doMDOoA+6SThxiGKxq1PlbWo/VdzckL
         3FiOYo/Lfj96+m3MwyP08B2TWsHWYnefj2aSsGM5QMbeFasKq+YZIsYu+MHaucEBq7RQ
         v5xoFxsAriTieQOhJ0EC5mXEhpuAQcJj0D66on1RVk7Qk7cNsTK7NIr8GZDPIVVDTNOX
         TCwT66L4PGxbA7KUmkRbDdfFa4tyz3UwpIcPkcY+oUdEmdyAksu0hq4LdlxFSSMOvORP
         cRBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718494584; x=1719099384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uu2t3jwVs6P+gBa8LNfJO/zndFSGozsr51+807rPpe8=;
        b=wD3rtrpvQZxmMaW9PMpw1mZGHDyY5+vHbElmUYknqc2QX41T601WYO5g1paMrsQBXm
         FxnnFhacIx2D9xlpcMkdXhgsVvba4l2tyy2/UObYbM0N+5N7hCWy7G5IkqVKWtZCSnJR
         o/SLHPKx0dnIfWzrWgTVmN/PjkTXAQJUqP0/vD6a9ZuNkvDcACNQ7eI8Spm2bJ1Y/+Ov
         Hm8wq3c3hxQJcTOMM4hm5sAuXjTHp2+gmeJeJjHizJbl3p/isVle0UXTtcNeTewg1z0J
         Hu0lJHwVW3zPh/Tvhi7CjoXhyr+VqMULFKfSfvnDyHdBSV2/eTd7v8GRvBU5Abttmtg5
         ZmRA==
X-Forwarded-Encrypted: i=1; AJvYcCVdpk/GJtmStnD/Z2EC1X6Gwg+MKu0EU0nDyIxbSXA/LyiZ4ympemef5nRlCuKNDEksUs51KubuDbCaflyLVgvAbBpm9fAoHLgNl48=
X-Gm-Message-State: AOJu0YxQoPcXgXr9cntdHVBmcp5UTQb4UbxplWk8oBPrquFGrkAlnaO8
	7ZkzxH2SzlO4fndJHWGnvjsPCc3L3Lw7exJzEYhZm/VZz0XcIgWKJvXcnulCImw3oAZLDEyQ52f
	meenqNctxdDyD+aXPXOxrVJMwu0U=
X-Google-Smtp-Source: AGHT+IE8gmsrj+Ltun9T1K8NjQTLC6ADr31u8bguhUl+sVg13fEuZGB3jcH3qI8nbnFZdcpvwa4EB8OrLHdRv9Owi3A=
X-Received: by 2002:a19:e015:0:b0:52c:a483:4cc6 with SMTP id
 2adb3069b0e04-52ca6e6dd0emr3588833e87.36.1718494583491; Sat, 15 Jun 2024
 16:36:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000cb6fca061af0462e@google.com>
In-Reply-To: <000000000000cb6fca061af0462e@google.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 16 Jun 2024 08:36:07 +0900
Message-ID: <CAKFNMomc2XRRT6u5YB9LxYJTmi7bGzq5dL-_VbsMbXuLa=m-sQ@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] kernel BUG in nilfs_btnode_create_block (2)
To: syzbot <syzbot+89cc4f2324ed37988b60@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 16, 2024 at 1:32=E2=80=AFAM syzbot  wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    83a7eefedc9b Linux 6.10-rc3
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D13ab3d9698000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc79815c08cc14=
227
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D89cc4f2324ed379=
88b60
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Deb=
ian) 2.40
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/b45273014a8f/dis=
k-83a7eefe.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/94cd5708292e/vmlinu=
x-83a7eefe.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a89698812e8b/b=
zImage-83a7eefe.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+89cc4f2324ed37988b60@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> kernel BUG at fs/nilfs2/btnode.c:59!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> CPU: 1 PID: 7600 Comm: segctord Not tainted 6.10.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 04/02/2024
> RIP: 0010:nilfs_btnode_create_block+0x3dc/0x400 fs/nilfs2/btnode.c:59
> Code: 8e 48 89 da e8 85 25 73 01 e9 a7 fd ff ff e8 cb d2 28 fe eb 0c e8 c=
4 d2 28 fe eb 05 e8 bd d2 28 fe 4c 89 ef e8 35 00 00 00 90 <0f> 0b e8 ad d2=
 28 fe 4c 89 f7 48 c7 c6 40 f2 06 8c e8 8e c0 6f fe
> RSP: 0000:ffffc90004f1f270 EFLAGS: 00010202
> RAX: ffffffff821b2801 RBX: 0000000000000010 RCX: ffffffff821b2819
> RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff88807746f5d0
> RBP: 0000000000001cc3 R08: ffff88807746f5d3 R09: 1ffff1100ee8deba
> R10: dffffc0000000000 R11: ffffed100ee8debb R12: dffffc0000000000
> R13: ffff88807746f570 R14: 1ffff1100ee8deae R15: ffff88805e399490
> FS:  0000000000000000(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fdd25186000 CR3: 000000007a728000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  nilfs_btnode_prepare_change_key+0x26d/0x300 fs/nilfs2/btnode.c:219
>  nilfs_btree_prepare_update_v+0x397/0x450 fs/nilfs2/btree.c:1942
>  nilfs_btree_prepare_propagate_v fs/nilfs2/btree.c:2001 [inline]
>  nilfs_btree_propagate_v fs/nilfs2/btree.c:2054 [inline]
>  nilfs_btree_propagate+0x3bf/0xdf0 fs/nilfs2/btree.c:2111
>  nilfs_bmap_propagate+0x75/0x120 fs/nilfs2/bmap.c:345
>  nilfs_segctor_apply_buffers+0x184/0x340 fs/nilfs2/segment.c:1006
>  nilfs_segctor_scan_file+0x810/0xa50 fs/nilfs2/segment.c:1066
>  nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1164 [inline]
>  nilfs_segctor_collect fs/nilfs2/segment.c:1492 [inline]
>  nilfs_segctor_do_construct+0x1c43/0x6b50 fs/nilfs2/segment.c:2040
>  nilfs_segctor_construct+0x181/0x6b0 fs/nilfs2/segment.c:2408
>  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2516 [inline]
>  nilfs_segctor_thread+0x55c/0x11b0 fs/nilfs2/segment.c:2601
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:nilfs_btnode_create_block+0x3dc/0x400 fs/nilfs2/btnode.c:59
> Code: 8e 48 89 da e8 85 25 73 01 e9
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

Looking at the call trace, it looks like in
nilfs_btnode_create_block(), the buffer obtained by
nilfs_grab_buffer() is in an unexpected state, triggering a BUG() that
remains there.

If the abnormal state is reproducible when given a corrupted
filesystem image (which I suspect it is), it should be rewritten to
return an appropriate error, or at least handled with WARN_ON() or
WARN_ON_ONCE() if it is caused by some other bug.

Once syzbot finds the reproducer, this will become clearer.

Ryusuke Konishi
