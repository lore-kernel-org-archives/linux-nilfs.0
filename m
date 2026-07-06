Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD9623ED6F
	for <linux-nilfs@vger.kernel.org>; Mon,  6 Jul 2026 06:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783318230; cv=none; b=p5tUx9RjYlpNFq3VNY0lNyFTtgrJ3SUVjSzzPqQ8BqzOTp+vwPQLVxg9ctJ+LzVHcMpXpWCNJk4Go+c9rRMNWymY3F+LFnNTU43zzjdtqMo5qZF/1eUFf4/TNTeRTvwYv+WJ0cFnq7Vvgj84/HRYADvwKKYoIKKOQM9mzi5lzm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783318230; c=relaxed/simple;
	bh=RnmAxHW4VNSgXES/ca9hlrez5V5t40FaJaehXOofSKU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Au1QTpvW02OKX1BOlhexlPiKAx8r//93FJJSejrLX5ChE+IzIJf4HUud7h11JcD+YWcFsDGc9MqwFlsUQ4bHDo36zqyc5humUIdsXlW/5o5NcO1wLUIlw6+J2ed+IvGp9GdxfEAYi3954ofWJYF2VUeSrkipH6/O/Vy86KC+qoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-486055c1c6fso1094961b6e.1
        for <linux-nilfs@vger.kernel.org>; Sun, 05 Jul 2026 23:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783318228; x=1783923028;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+LdvZXVLSiym5V2GL9AFvzCyPT1hHbHqQ7KZlFCqzD0=;
        b=fD9bl/5/4tyIFT06c4BIpUdlRkmuNgS+bVaD80Q34f3R4LKFQ9mQAYW8Za8j/e3unY
         /IAMJnpBnlWocXdEBzVyu6Cni44Eyvsj+s9X7tmVezjCCMZy+AeVyrW/303JUsKAkpYO
         4m+PlWYQ7PZyxWBhvud5VhhUn7PcHb5y27NG3fkKZClW7OUzwRomxu+Lw2ov8FauaOCu
         cs2T0rCpjZQsvxZ9XsxWaS6PbU8EPO6Bf5H9pleXaEgLctn/ltqSRwykSVSJsA2c7OZb
         a41fn0nKP70riqkuknZvUsa5l6UrDOS0jXD5/C0NhJrmeGxgliZmbOnv8h+8NYjIcclu
         ISLA==
X-Forwarded-Encrypted: i=1; AFNElJ+lWdvQCfAmCG+X+uS2qdI5gwF95tq/c4FFZ+NtFV94rqGySmsqiXU9voqgQ5RYnTxIQ1PeG2eApGNmig==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMcLH3Pz5Yc+SiVQ5zyE5SwK0sPRYzYITwYI2DKB1zzuSdFXJ1
	QxUQZmAN7Pgbxkew5qYbqdfdzQtw5DDG4bXLdjK6/Tzf26HN6Qd5eAybLdULnZvBpDPcMU8IVYX
	ddkTDpS5+DKgjdZhGbleflJBFEA4Mgv8qXRw12reYEOMcEUuFdwIw+sztlQM=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2383:b0:497:df42:1e04 with SMTP id
 5614622812f47-499b741a01dmr5412579b6e.18.1783318228080; Sun, 05 Jul 2026
 23:10:28 -0700 (PDT)
Date: Sun, 05 Jul 2026 23:10:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4b46d4.b42ede87.8bd1.001b.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_cpfile_delete_checkpoints
From: syzbot <syzbot+79b815da3aec0a6a4d02@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    71dfdfb0209b Merge tag 'vfs-7.2-rc2.fixes' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10c00d39580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c9876b0f77b546
dashboard link: https://syzkaller.appspot.com/bug?extid=79b815da3aec0a6a4d02
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d01c6e580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12776e6e580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-71dfdfb0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/522f1a761fe1/vmlinux-71dfdfb0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/595943c8baaa/bzImage-71dfdfb0.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/e2143050dc41/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/958ab3f4c7bb/mount_5.gz
mounted in repro #3: https://storage.googleapis.com/syzbot-assets/77f82daa3be0/mount_6.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=15143946580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+79b815da3aec0a6a4d02@syzkaller.appspotmail.com

------------[ cut here ]------------
le32_to_cpu(cp->cp_checkpoints_count) < n
WARNING: fs/nilfs2/cpfile.c:94 at nilfs_cpfile_block_sub_valid_checkpoints fs/nilfs2/cpfile.c:94 [inline], CPU#0: syz.0.17/5467
WARNING: fs/nilfs2/cpfile.c:94 at nilfs_cpfile_delete_checkpoints+0x913/0xce0 fs/nilfs2/cpfile.c:522, CPU#0: syz.0.17/5467
Modules linked in:
CPU: 0 UID: 0 PID: 5467 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:nilfs_cpfile_block_sub_valid_checkpoints fs/nilfs2/cpfile.c:94 [inline]
RIP: 0010:nilfs_cpfile_delete_checkpoints+0x913/0xce0 fs/nilfs2/cpfile.c:522
Code: fb ff 41 89 c6 31 ff 89 c6 e8 e9 f9 f1 fd 45 85 f6 0f 85 6a 03 00 00 e8 9b f5 f1 fd 45 31 f6 e9 23 fd ff ff e8 8e f5 f1 fd 90 <0f> 0b 90 e9 d0 fe ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 0a f9
RSP: 0018:ffffc900025df4e0 EFLAGS: 00010293
RAX: ffffffff83d48d02 RBX: 1ffff11006feb480 RCX: ffff88803462a540
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000000
RBP: ffffc900025df630 R08: ffffea0000dfd687 R09: 1ffffd40001bfad0
R10: dffffc0000000000 R11: fffff940001bfad1 R12: 0000000000000005
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff888037f5a404
FS:  0000555559731500(0000) GS:ffff88808c54e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 0000000044683000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 nilfs_ioctl_delete_checkpoints fs/nilfs2/ioctl.c:680 [inline]
 nilfs_ioctl_prepare_clean_segments+0x158/0x840 fs/nilfs2/ioctl.c:787
 nilfs_clean_segments+0x2b6/0xbb0 fs/nilfs2/segment.c:2546
 nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
 nilfs_ioctl+0x2619/0x2780 fs/nilfs2/ioctl.c:1352
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff42779de59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd20bf4538 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ff427a25fa0 RCX: 00007ff42779de59
RDX: 0000200000000640 RSI: 0000000040786e88 RDI: 0000000000000009
RBP: 00007ff427833e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff427a25fac R14: 00007ff427a25fa0 R15: 00007ff427a25fa0
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
