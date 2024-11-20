Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CE41474B8
	for <linux-nilfs@vger.kernel.org>; Wed, 20 Nov 2024 17:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732124849; cv=none; b=rWYsMq3+hSGwPWsDyy17lqNsAR2c/exQGE/hZ59r5R0vAPKUp2JDxPSh90FrmH61dT2ZN4l3u30DD4aUMVQALgeVG9Yu2+PH+KWcJY1Wp8uV5s6jGp1ga3rHMSBqVuGb+3Q7gd/v9w39cHjrnij0CTEQ+ExOurpqBoCtM5BlJCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732124849; c=relaxed/simple;
	bh=PLqn2ysYw4nZ+YpjnzOUs1FgcP80h39V0QKPRnvyBHM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=b3OB7YFRJIKhO2TETgoVq32jQnZ6P/4eGfrZwraE+SIYN7PuOAYK0ij5puTWlLQakVQBrJAWveeGdsQMh8trBDMg37OiML2moRG0IKm7duKZkar5J33HwPDXHfUAUbxTHr3GdC9cP4fzrsK9laRZRVmPG8B1ZpQNo+aVq/lj8jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a71bdd158aso26650135ab.1
        for <linux-nilfs@vger.kernel.org>; Wed, 20 Nov 2024 09:47:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732124847; x=1732729647;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r3nJRr+5VPNNH3joVuwJkxP4BmhEXntf3uQO341kZuw=;
        b=BoGhd9nMwkxkskYXMXFAUpZsLj80dStAP9nYbcwE6TqLFHhX6XQzmO1jlMu+iDEFW5
         RpA+ZFmrCia964ao4xgJPfWWdOizII/5jDzi1gb7l6ynK8yIb9H0ra8IzNKqasGVGC2P
         /x12UL3ql7csbUC5TAuBpFjiFPYdLL0cJVQScQagJfSxizIU3P21eI7N2coJCX9O+9Yu
         b/AnCbFUv9Bxm1qfzE8NCuLEV11I8T/yXXg5oC+E13RBBEh0Oe3UY4nihoSxtvrLoqiP
         jLfsZAWsRzCoPfm7Z7Lrz6ijmq3xCuMfYoT+jH+sxadA5WZK2V4u912225Cdc/tY9KLA
         +0Nw==
X-Forwarded-Encrypted: i=1; AJvYcCWC0OVi+108niYyB1WDpVgmaMPjoAGK1Z/LzsEVqySwCKEi1KmHF+mnJHLKa6dNYJayC1GS6/gcS/iyrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwULdarMvk6D6Gz68EYVeGRRZ2sz2EUCSs6LPh4l1wTukLXNPJN
	x2Zi9qKESq1TLmNlmVrt3493+ZoAnA/h3AE/3nAZnI2w2U1RPDuTphQxZEZXTcAKM2SiOu+uaIK
	gtMJeus9QnU9mCgNnAG1rUMeiKZY+S7fjRFDhDUoA5JxyZGPDRnE9gcE=
X-Google-Smtp-Source: AGHT+IFN65bvGFzwvBhK+tY4o20PdbADa0YM1ZLLDf5jBfT7sKj/uCPQppITXtDF+SR86cFEIwMe7HLpe1V9kXJSIK9mdnJxJtoh
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:164d:b0:3a7:7ee3:109b with SMTP id
 e9e14a558f8ab-3a78656ecd7mr42416125ab.16.1732124846849; Wed, 20 Nov 2024
 09:47:26 -0800 (PST)
Date: Wed, 20 Nov 2024 09:47:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673e20ae.050a0220.3c9d61.0163.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_rmdir
From: syzbot <syzbot+9260555647a5132edd48@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    bf9aa14fc523 Merge tag 'timers-core-2024-11-18' of git://g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1093c6c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccd6152c3e2378ce
dashboard link: https://syzkaller.appspot.com/bug?extid=9260555647a5132edd48
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1497e930580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f0bae8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f7f38a2c24fc/disk-bf9aa14f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9fe13f1c9a0f/vmlinux-bf9aa14f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/04d354ff9f6b/bzImage-bf9aa14f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1605c6d5cd44/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com

NILFS (loop0): deleting nonexistent file (ino=11), 0
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5833 at fs/inode.c:407 drop_nlink+0xc4/0x110 fs/inode.c:407
Modules linked in:
CPU: 1 UID: 0 PID: 5833 Comm: syz-executor181 Not tainted 6.12.0-syzkaller-01782-gbf9aa14fc523 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
RIP: 0010:drop_nlink+0xc4/0x110 fs/inode.c:407
Code: bb 70 07 00 00 be 08 00 00 00 e8 07 df e5 ff f0 48 ff 83 70 07 00 00 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc e8 6d f4 7e ff 90 <0f> 0b 90 eb 83 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 5c ff ff ff
RSP: 0018:ffffc90003e97c70 EFLAGS: 00010293
RAX: ffffffff8215f523 RBX: 1ffff1100ef7b1cc RCX: ffff888030afbc00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff8215f4a3 R09: 1ffff1100fb87cee
R10: dffffc0000000000 R11: ffffed100fb87cef R12: ffff888077bd8e60
R13: 1ffff1100ef7b030 R14: ffff888077bd8e18 R15: dffffc0000000000
FS:  0000555584ff0480(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000045bdd0 CR3: 0000000074070000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nilfs_rmdir+0x1b0/0x250 fs/nilfs2/namei.c:342
 vfs_rmdir+0x3a3/0x510 fs/namei.c:4394
 do_rmdir+0x3b5/0x580 fs/namei.c:4453
 __do_sys_rmdir fs/namei.c:4472 [inline]
 __se_sys_rmdir fs/namei.c:4470 [inline]
 __x64_sys_rmdir+0x47/0x50 fs/namei.c:4470
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7febf80a8507
Code: 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 54 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc733beac8 EFLAGS: 00000207 ORIG_RAX: 0000000000000054
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007febf80a8507
RDX: 0000000000008790 RSI: 0000000000000000 RDI: 00007ffc733bfc70
RBP: 0000000000000065 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000000207 R12: 00007ffc733bfc70
R13: 0000555585001840 R14: 431bde82d7b634db R15: 00007ffc733c1df0
 </TASK>


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
