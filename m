Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E68D233522
	for <linux-nilfs@vger.kernel.org>; Tue, 14 Jan 2025 07:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736840430; cv=none; b=PgtcySyLEtbZJtkAR7u6BumSJ1/siWiCvpKX7d+8x3PCQqta4soAokP3PMjCpbvAjFUpb3nFMnHSmGxn1cbruDrLraeP9Z1jIb4wfNmGPdS6zn80n9z72wue6XEVCYHS2MCo+WxIcB1qnMNKg7zFnMKEyI+UAFmz5qjCdYWGK58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736840430; c=relaxed/simple;
	bh=W+sybKBZUORKHtVluB1HD9DfHJ5n6vNx6XmHAsUn9Ks=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KSkfWqti6PxFeU5LFHeNkmv3sDGKw+J4dv5ZuaGtxub2evsk8NHY11kIY/bM5NoFTG5NEMWhdPhn43MpOMmjRW0vkhP9OiRW+NYpH0Y6U6JM+jcz5lENVwqvewLK78bKxaKMt2JNSX47Jx45mASzPYix7ox+5iaLWhQA8JpnTxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ce7b6225aeso5897325ab.0
        for <linux-nilfs@vger.kernel.org>; Mon, 13 Jan 2025 23:40:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736840426; x=1737445226;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YzOMITXG2rhrRFWMRxtEWT1X0Hq5zBUt2BcKWWbkhDg=;
        b=gQha2oe+HYdDCZbognaZZ8ommzUgZd9qcEDN6MOiVN+hPW11SexULM97EGQYBKWR+r
         fFJo1chU5jrUk8d7FPhBpHx3RUd0AdVv83CdwUazTh2Tmbn566nb3I2LF0GGO0LgaebX
         dgXL63NyQFyu0nIidQFBAUf/NgAHjzMP0v34BVwGxbBE2gFIp5bY/bD3hWEEF3DvUrDk
         wqnHuSsk80u/PlyAeJeg4S1ok5Q81B2BGo0lKPVxn5sYaRPH6jS//PfTxY+8fk/ve9c+
         59CVszQh2ggUkuO4YCnoDoeDy26X2jbD5nUvwP2Ab8122bDIvR9XQWiGqtWSUypza+hF
         vj4A==
X-Forwarded-Encrypted: i=1; AJvYcCUh1jFMKaNViFVjHhg4GLRcpkcWsBgn/UYRT//8mgdsXdnyjgjNFIjtbR2KW4ahMiqMk0sPh/Cou09iOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxL4lsunm41Qqy6b+ZKvid/sKWayw8MdBfWKt+EesAaokgtAy2a
	bePL0xNuPEmZLU58eYCwSQtm5DVWsreZ1I0fK9T2qioFNs4G4/AR4iiJ+TcaSzljWtfYpTpAFA8
	yJnt01TtBg116y3N7MkM7jJuVIcMScgAzWw8Ncc9puabKzKYjGzU2jBE=
X-Google-Smtp-Source: AGHT+IFCkBpCM8w7m7331YuI8ldxWACRQA+BSZWfk+zmGHd8Ym79trP9y5WiaW3PZJa71wS+dE3+u2hHALc3hrR04pmSrfOsTcUA
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18c9:b0:3ce:46e2:42cc with SMTP id
 e9e14a558f8ab-3ce46e2465fmr168876655ab.10.1736840426395; Mon, 13 Jan 2025
 23:40:26 -0800 (PST)
Date: Mon, 13 Jan 2025 23:40:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <678614ea.050a0220.216c54.006c.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_btree_assign (3)
From: syzbot <syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    643e2e259c2b Merge tag 'for-6.13-rc6-tag' of git://git.ker..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1719a218580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ac4cd61d548c1ef
dashboard link: https://syzkaller.appspot.com/bug?extid=158be45e4d99232e1900
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132021df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1530cf0f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/76410f8b1345/disk-643e2e25.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1ee033602aec/vmlinux-643e2e25.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b8062c57eaa0/bzImage-643e2e25.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/ca71c75d50c5/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/f6a710039269/mount_4.gz

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=140b4cb0580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=160b4cb0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=120b4cb0580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6214 at fs/nilfs2/btree.c:2301 nilfs_btree_assign+0xabb/0xd20 fs/nilfs2/btree.c:2301
Modules linked in:
CPU: 0 UID: 0 PID: 6214 Comm: segctord Not tainted 6.13.0-rc6-syzkaller-00059-g643e2e259c2b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:nilfs_btree_assign+0xabb/0xd20 fs/nilfs2/btree.c:2301
Code: 00 00 44 89 f0 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc e8 e2 52 24 fe 4c 8b 7c 24 38 eb a2 e8 d6 52 24 fe 90 <0f> 0b 90 41 be fe ff ff ff eb 91 44 89 f1 80 e1 07 80 c1 03 38 c1
RSP: 0018:ffffc90004bcf600 EFLAGS: 00010293
RAX: ffffffff837b20fa RBX: ffff8880758fa658 RCX: ffff888027200000
RDX: 0000000000000000 RSI: 00000000fffffffe RDI: 00000000fffffffe
RBP: ffffc90004bcf730 R08: ffffffff837b1a3b R09: 0000000000000000
R10: ffffc90004bcf560 R11: fffff52000979eaf R12: dffffc0000000000
R13: ffff8880330ca580 R14: 00000000fffffffe R15: 1ffff92000979ed0
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020094000 CR3: 0000000030296000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nilfs_bmap_assign+0x8f/0x160 fs/nilfs2/bmap.c:390
 nilfs_segctor_update_payload_blocknr fs/nilfs2/segment.c:1633 [inline]
 nilfs_segctor_assign fs/nilfs2/segment.c:1667 [inline]
 nilfs_segctor_do_construct+0x35c5/0x6ea0 fs/nilfs2/segment.c:2126
 nilfs_segctor_construct+0x181/0x6b0 fs/nilfs2/segment.c:2479
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2587 [inline]
 nilfs_segctor_thread+0x69e/0xe80 fs/nilfs2/segment.c:2701
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
