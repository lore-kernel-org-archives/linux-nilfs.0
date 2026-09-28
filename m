Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6785012BC
	for <linux-nilfs@vger.kernel.org>; Mon, 28 Sep 2026 21:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790631875; cv=none; b=HUK8Os9Yj/xRDrVJPrJvAUdCPf0pkC++C6masKrrY7RIbNhMMvR50kEoKlMHuerD+sDwc0fXUplQvAz2vtIFTqlsork7lw4gA3IKWFwLyjGySP3OWBlDNJxJtBS50eMz1S0jGVY4z0mENcmr164KMLLhBcJ0js+eiguZencPpUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790631875; c=relaxed/simple;
	bh=NaClvdD0/ETuQdJMkmipvGIkUEjPXyjdSiiTPbWCnfQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=hpDBSgsbuYmst/a6ARfYJ3h+3esclyNkLGyI1ncUHebsnor6Gm8xn7w7/Vdp/JxkMqIBc0pYzZacY2EMhikxVOXduUwWI4TtmsMrzTAWKCgDXiurcumnPUN7G+wXQPbO9dPptnU+rK70bscyVyt7GdQYz7KXIU4+g+uo0i6zXVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4ec4d68543eso816284b6e.2
        for <linux-nilfs@vger.kernel.org>; Mon, 28 Sep 2026 14:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790631873; x=1791236673;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LCFafPM7VamF37q9WZwvbaU7b8Ls5X7AGvGZOLaOOK0=;
        b=TjqNpqmu3TBu5ySeRE81iPZI1zs39EtF6KvTRFN32Arfq/aSKX+hsaptCb+1Ez4XO1
         2ZeWtL0cFukbK2G1I+t/ZaHNoabwJQvWSh7Y7hnha3y4kIJ4ix8c/GNUnTtPIotTZiJh
         wvW5u2NpmdPp2QSAjlijDnnanFFTgkUNzR9KI1lv6cpNbtYWnK4qtCo3RRt4W9iUPHfZ
         +LCfTDgYv1hOvwR34A8U1/4gNdx481fcTaqhBsONIsiMQ8TL1I3/yzA/KCe4TJbZQXjf
         uiz7sNJti9ZIreK++7TFCHuoIb9LeSPlZfcjww4nUNJB45gchUO7cLa73ZT1RJOwv+IB
         HCcQ==
X-Forwarded-Encrypted: i=1; AKwUvBzKclz0zgkcoCLOTPF+8d/Od/NyUDd9HjY4uzedQe1oj43szvibC8ZluUdreTZnc2oMYqB8Ki3OohNa4Q==@vger.kernel.org
X-Gm-Message-State: AFuF++nYc0CEE0rkxBxXAjD68SK/bfg0xXOfgmuXbhfpuZC9/nGlixQM
	MQJm0nZ8BeiWIrELrfzaEBfykmx+cu2kH3cR9v1vIJ01Sgd8LfRwasLviAdSFrUGAGYXuBPlykV
	By45VV5OaAkdIUoXYBXoNMHve5S7YD5Y5wfOESHUI0YsEyZxPkGjFWscEm8g=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3448:b0:4d6:93c3:3e91 with SMTP id
 5614622812f47-4d72f539c15mr13092691b6e.68.1790631873264; Mon, 28 Sep 2026
 14:44:33 -0700 (PDT)
Date: Mon, 28 Sep 2026 14:44:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abadfc1.69bd487b.a6f8c.0008.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_rmdir (3)
From: syzbot <syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f49a343b305c Merge tag 'pinctrl-v7.3-2' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14834205580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=718e346eb0b8f38
dashboard link: https://syzkaller.appspot.com/bug?extid=c388db0347b7fc88fa7a
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/01e174be12f9/disk-f49a343b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5ec6480f0b31/vmlinux-f49a343b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8e3bdc42332b/bzImage-f49a343b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com

NILFS (loop3): deleting nonexistent file (ino=12), 0
------------[ cut here ]------------
inode->i_nlink == 0
WARNING: fs/inode.c:408 at drop_nlink+0xc5/0x110 fs/inode.c:408, CPU#1: syz-executor/5581
Modules linked in:
CPU: 1 UID: 0 PID: 5581 Comm: syz-executor Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:drop_nlink+0xc5/0x110 fs/inode.c:408
Code: 50 09 00 00 be 08 00 00 00 e8 67 46 e9 ff f0 48 ff 83 50 09 00 00 5b 41 5c 41 5e 41 5f 5d e9 d2 29 12 09 cc e8 dc 54 7d ff 90 <0f> 0b 90 eb 81 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff
RSP: 0018:ffffc9000587fc70 EFLAGS: 00010293
RAX: ffffffff82495fd4 RBX: ffff88803f613d78 RCX: ffff888037560000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed10053f5d2b R12: 1ffff11007ec27b8
R13: ffff88803f613d78 R14: ffff88803f613dc0 R15: dffffc0000000000
FS:  0000555567408500(0000) GS:ffff888125cc7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f52937858b8 CR3: 0000000058ee4000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nilfs_rmdir+0x1b4/0x250 fs/nilfs2/namei.c:347
 vfs_rmdir+0x3e9/0x6b0 fs/namei.c:5515
 filename_rmdir+0x292/0x520 fs/namei.c:5572
 __do_sys_unlinkat fs/namei.c:5747 [inline]
 __se_sys_unlinkat+0x71/0x1a0 fs/namei.c:5740
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5a90c2d277
Code: 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 b8 07 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdb3170b78 EFLAGS: 00000207 ORIG_RAX: 0000000000000107
RAX: ffffffffffffffda RBX: 0000000000000065 RCX: 00007f5a90c2d277
RDX: 0000000000000200 RSI: 00007ffdb3171d20 RDI: 00000000ffffff9c
RBP: 00007f5a90cc44bb R08: 0000000000008560 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000207 R12: 00007ffdb3171d20
R13: 00007f5a90cc44bb R14: 00000000000296e0 R15: 00007ffdb3173ee0
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
