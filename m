Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019FC212625
	for <linux-nilfs@vger.kernel.org>; Fri, 11 Oct 2024 10:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728641844; cv=none; b=AoesNpzGUuFa9bMglJAhpqj54FvCze10mkp+ElYU+JAtd4rbUlqCuZp/WMCxuN4eeM6uX4/RT2MLIMheFLsWRd9mkUZg/F86pNadfWWme1DC4BqZzN9fbhuWkMaUJfuH2v3VsXVNFh5OHYn7O1cwKLVP4i3acsC1n0oqCW0vyGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728641844; c=relaxed/simple;
	bh=7umC4BFsnDEY4cemkSq1uu0jjlt9lhR+IrwCGaNvkK0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mKj95Jp/xfsH2C63oAEtxJwWy/TcI162RbOQS2Ql40x2Js1OspsKcUwx8ddbDztWIuYf3GSMyQGYXRFX/ScAsV9lrOPfx4jGb8D2OiXiOtGk4ZdDMQm98XIDZNw+gVwbIKxeB5sfsVqf48dSwQX+OLG+elceeHUzqow9qYcS9Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a1a8b992d3so21053475ab.0
        for <linux-nilfs@vger.kernel.org>; Fri, 11 Oct 2024 03:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728641842; x=1729246642;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IhiWIxgYZmwLqOTX1l/1/hkuLo2pVgHz9oyhBZxwE9A=;
        b=Ws4vIkd0ey2udGZDpGCQGMuyS2QwQg31wL65dx0w/6FJMNTOzc9G5UyUV32hGfxxUo
         RJEf0AUCYQWsCBY9UzR5Y4+XpNdn/VnvjSSGEk3N2wOK/Sv695zVHc6q+uaUSIxCkX3N
         jx8DxTuhpPkBong8b2Z1jVUlyF3dAOs3gpmijKxZX7aBHAUGq+/CaSYkTJrui8vXJ3WW
         WhmAp5bDuxnqDNrlyy/6GQAc+iGFjxZvHlFdo8RF23gZUuvt37GdhFrw9uptwOX/+jnM
         bpYvU2m9Xf1j38sN+Ois219OG0RR2F7wH2rLokDUrzmR4Wpr8uAm/MKCLLRZO4uzKEBs
         winA==
X-Forwarded-Encrypted: i=1; AJvYcCX3y6HCyHSdR0DiFIgDLdKnXZS1yb7ssAU8vccbJ1H24txYZqr4vnzuPKGkg1YQ3c3xn9Psq1iRQ0Q1GQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYq7F0BcKOEz4SRkk4p/iJNgGLUhVrwtwDJMkqenrMlkomEPTn
	pNSijVklChHqk9f8YaxU3RNlCQQBsKeL3Pe6EHmYMH5rLXHZ8MNNHz+DBbi6qL+qkq45lKWhMua
	jXGn7GiozepRV+NyTP0fknGbals29UWEbNsR8Is6agHOTNbrVF1wqXkY=
X-Google-Smtp-Source: AGHT+IGRj95ls4Dpz8WNRrVxMviTb9VbZzobQJD2q3Nn9W598mJ7/pIIj+nMw3F5BgBellAN6GESq4N1QRUCbagK6oUzxC8ck7rr
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1786:b0:39f:325f:78e6 with SMTP id
 e9e14a558f8ab-3a3b56ead3bmr14759835ab.0.1728641842106; Fri, 11 Oct 2024
 03:17:22 -0700 (PDT)
Date: Fri, 11 Oct 2024 03:17:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6708fb32.050a0220.4cbc0.0001.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING: ODEBUG bug in nilfs_detach_log_writer
From: syzbot <syzbot+c4b312367c177af55bdd@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0c559323bbaa Merge tag 'rust-fixes-6.12' of https://github..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11c2ab9f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f95955e3f7b5790c
dashboard link: https://syzkaller.appspot.com/bug?extid=c4b312367c177af55bdd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f047d65a1c98/disk-0c559323.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b9422453b274/vmlinux-0c559323.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cbd997d77332/bzImage-0c559323.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c4b312367c177af55bdd@syzkaller.appspotmail.com

NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
------------[ cut here ]------------
ODEBUG: free active (active state 0) object: ffff88804a135270 object type: timer_list hint: nilfs_construction_timeout+0x0/0x40
WARNING: CPU: 1 PID: 10509 at lib/debugobjects.c:517 debug_print_object+0x17a/0x1f0 lib/debugobjects.c:514
Modules linked in:
CPU: 1 UID: 0 PID: 10509 Comm: syz-executor Not tainted 6.12.0-rc1-syzkaller-00125-g0c559323bbaa #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:debug_print_object+0x17a/0x1f0 lib/debugobjects.c:514
Code: e8 3b 45 3c fd 4c 8b 0b 48 c7 c7 20 02 61 8c 48 8b 74 24 08 48 89 ea 44 89 e1 4d 89 f8 ff 34 24 e8 7b 88 93 fc 48 83 c4 08 90 <0f> 0b 90 90 ff 05 64 ca 5a 0b 48 83 c4 10 5b 41 5c 41 5d 41 5e 41
RSP: 0018:ffffc90003d87958 EFLAGS: 00010282
RAX: 82bf3185606fc400 RBX: ffffffff8c0cd900 RCX: ffff88802c7a8000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffffff8c6103a0 R08: ffffffff8155daa2 R09: fffffbfff1cf9fd8
R10: dffffc0000000000 R11: fffffbfff1cf9fd8 R12: 0000000000000000
R13: ffffffff8c6102b8 R14: dffffc0000000000 R15: ffff88804a135270
FS:  000055558707b500(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555870965c8 CR3: 00000000549d4000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 __debug_check_no_obj_freed lib/debugobjects.c:989 [inline]
 debug_check_no_obj_freed+0x45b/0x580 lib/debugobjects.c:1019
 slab_free_hook mm/slub.c:2274 [inline]
 slab_free mm/slub.c:4580 [inline]
 kfree+0x11f/0x440 mm/slub.c:4728
 nilfs_segctor_destroy fs/nilfs2/segment.c:2828 [inline]
 nilfs_detach_log_writer+0x754/0xa50 fs/nilfs2/segment.c:2893
 nilfs_put_super+0x4d/0x160 fs/nilfs2/super.c:503
 generic_shutdown_super+0x13b/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1696
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x251/0x310 kernel/task_work.c:228
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f95d657f327
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffd4adf5dc8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f95d657f327
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd4adf5e80
RBP: 00007ffd4adf5e80 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffd4adf6f00
R13: 00007f95d65f0134 R14: 0000000000110fcd R15: 00007ffd4adf6f40
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
