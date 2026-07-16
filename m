Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AAA353A6B
	for <linux-nilfs@vger.kernel.org>; Thu, 16 Jul 2026 07:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784188293; cv=none; b=rSI4I84onfL07cSCxc2/yLj++h1eoV/w3n/PQVSsc0xb4C5dtbCkA4j3QGAxq0ko7qCnl3OcjE/oCgKIgHtHgPNCNtXpErq8h+WKGZTUmK8CiAv/cK2rf/9YPiUGXHK+RWUTHHNl7sCM4Y029JZGjphHILc860zTC5hiiEOg0Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784188293; c=relaxed/simple;
	bh=MnUA7xvXhdzsDztXHSYSykI73Qz2dZupLilI6Mv8sNE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=boKwvvFnTxvvEL+9YT7h8SV63JzwPNGosi7LLObO4eS6nPHLxDoDYyXomE3R95V7TiQ635m6bNU0PiAlO+qrJXgJ8bfRUyNVzG6GQSLTvv8AAL5SGlr70E8PsApyK7wLOZu/h7Gfo2haJfN10FWuOYq7zBsmFILFgda373D2EJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-4959c49e054so6212692b6e.3
        for <linux-nilfs@vger.kernel.org>; Thu, 16 Jul 2026 00:51:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784188291; x=1784793091;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OVCfrtcYUm9cqZ42G2A6Oc73GeyR8UPAjNa9RWMEReU=;
        b=gvwgRBKTvxE/bz+VEuXEzoq+XuxA8nE+xfpcsQIL3w7U8XA/J8ggm0iZOMkp3nTE5k
         V46nfrm3BlDDLZ7KWYzx3dFLruo4GLOcl67kLY1PprbtMWp4uvOds8vqKmJu4Ma9Wv8Q
         nroDw6h0yCPr7MdO8fQcUw5vmk2+d74PQt5OD8+OwoCUzzF1XhLZsXAQ7FBudqwXushS
         aIwt7whnpbfTevGcDijObngt02lxRwjthb9JPOIuwAYsm+WqZS1UGEBmOmpNjEmzw/Ap
         AFUMEpbK33VzFkRbUePAesvjYUX3g9DPVRlXfMHXBz8aiguQBK+NXhjFtppXE5lsVIZv
         BzIw==
X-Forwarded-Encrypted: i=1; AHgh+RodN5+IcY4S6ZivJOdYWiYLwWdjyjF0thRDjbNuVPhKLRzJ7vk3CMQpdPI1a3zc/zgnuP98h/6aOMABDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXdsQOBL6AVy++zMQZvO892Ixx1bHgQrr5nJa35I6uRTWu/TZc
	nR38BQXnvRshz7Lod1qoROh4ww5qXsEeRPxqniS+XIJ/uv/uTPmjgg8pBTd2zfmYd96h1tEWxba
	SfRLa8W0J8qKx8MIsil8Yma1dwyoqCMLIm0nbpO1cxRbBkpiJzFMKBhfBK+s=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5145:b0:492:973e:1c23 with SMTP id
 5614622812f47-4a495f49ebdmr3933900b6e.15.1784188290873; Thu, 16 Jul 2026
 00:51:30 -0700 (PDT)
Date: Thu, 16 Jul 2026 00:51:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a588d82.c96faac9.59e0.0013.GAE@google.com>
Subject: [syzbot] [nilfs?] INFO: task hung in nilfs_transaction_begin (3)
From: syzbot <syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    58717b2a1365 Merge tag 'sound-7.2-rc4' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e344b9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c4196ba0e33631d
dashboard link: https://syzkaller.appspot.com/bug?extid=cae54346a70bbceeff2c
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=169b8c32580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a454b9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/42eab9b1642d/disk-58717b2a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7c5a694b4f2d/vmlinux-58717b2a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/348d72144bc9/bzImage-58717b2a.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d5827c24deaa/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com

INFO: task syz.3.20:6062 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.20        state:D
 stack:25640 pid:6062  tgid:6052  ppid:5793   task_flags:0x400040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7383
 rwsem_down_read_slowpath+0x6ba/0x920 kernel/locking/rwsem.c:1114
 __down_read_common kernel/locking/rwsem.c:1291 [inline]
 __down_read kernel/locking/rwsem.c:1304 [inline]
 down_read+0x9c/0x330 kernel/locking/rwsem.c:1576
 nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
 nilfs_mkdir+0xd6/0x390 fs/nilfs2/namei.c:228
 vfs_mkdir+0x406/0x620 fs/namei.c:5276
 filename_mkdirat+0x285/0x510 fs/namei.c:5309
 __do_sys_mkdirat fs/namei.c:5330 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5327
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1613b9de59
RSP: 002b:00007f16131fe028 EFLAGS: 00000246
 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f1613e26090 RCX: 00007f1613b9de59
RDX: 00000000000001c0 RSI: 0000200000000040 RDI: ffffffffffffff9c
RBP: 00007f1613c33e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1613e26128 R14: 00007f1613e26090 R15: 00007ffd7ee97478
 </TASK>
INFO: task syz.2.19:6076 blocked for more than 147 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.19        state:D stack:26920 pid:6076  tgid:6073  ppid:5797   task_flags:0x400040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7383
 rwsem_down_read_slowpath+0x6ba/0x920 kernel/locking/rwsem.c:1114
 __down_read_common kernel/locking/rwsem.c:1291 [inline]
 __down_read kernel/locking/rwsem.c:1304 [inline]
 down_read+0x9c/0x330 kernel/locking/rwsem.c:1576
 nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
 nilfs_mkdir+0xd6/0x390 fs/nilfs2/namei.c:228
 vfs_mkdir+0x406/0x620 fs/namei.c:5276
 filename_mkdirat+0x285/0x510 fs/namei.c:5309
 __do_sys_mkdirat fs/namei.c:5330 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5327
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feb9c39de59
RSP: 002b:00007feb9d17e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007feb9c626090 RCX: 00007feb9c39de59
RDX: 00000000000001c0 RSI: 0000200000000040 RDI: ffffffffffffff9c
RBP: 00007feb9c433e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007feb9c626128 R14: 00007feb9c626090 R15: 00007fff8cce9fb8
 </TASK>
INFO: task syz.0.17:6080 blocked for more than 149 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D
 stack:25640 pid:6080  tgid:6077  ppid:5784   task_flags:0x400040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7383
 rwsem_down_read_slowpath+0x6ba/0x920 kernel/locking/rwsem.c:1114
 __down_read_common kernel/locking/rwsem.c:1291 [inline]
 __down_read kernel/locking/rwsem.c:1304 [inline]
 down_read+0x9c/0x330 kernel/locking/rwsem.c:1576
 nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
 nilfs_mkdir+0xd6/0x390 fs/nilfs2/namei.c:228
 vfs_mkdir+0x406/0x620 fs/namei.c:5276
 filename_mkdirat+0x285/0x510 fs/namei.c:5309
 __do_sys_mkdirat fs/namei.c:5330 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5327
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f172919de59
RSP: 002b:00007f172a11e028 EFLAGS: 00000246
 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f1729426090 RCX: 00007f172919de59
RDX: 00000000000001c0 RSI: 0000200000000040 RDI: ffffffffffffff9c
RBP: 00007f1729233e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1729426128 R14: 00007f1729426090 R15: 00007ffcc8738ab8
 </TASK>
INFO: task syz.5.22:6086 blocked for more than 153 seconds.
      Not tainted syzkaller #0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
