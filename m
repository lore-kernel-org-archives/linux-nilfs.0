Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D822FC875
	for <linux-nilfs@vger.kernel.org>; Mon, 13 Oct 2025 09:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760347113; cv=none; b=DpnofXgy1DYkfY3yQ995v2Ay4IpuNxpMxlPH7guPFWuLTEvTr6KA/KX91Te/AGBec1h10cmHRfU4/ooj31A4WotRFqQPkiQuM5gAcbZB0vOzqGbVfTQDKK8mFNtpNsTzWMYtePLlQH3CdhdZWFchyrpkHyUBSydAzVOp6hUP504=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760347113; c=relaxed/simple;
	bh=zQ04kJMvulXBDhJ6WmqFJqA0Vyg/xCqGs/ntwRq3C5s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=IJnsPwySef8q+A+If0CZUlPPe/xbKWeTcOlyS9/eNBNuDHGP0+byCHwOSbj8EPOd9qK39pigG7URUl3q/w0cNZMvbzuzur+AQJNfZKbr4JOth1ljrzOuxsol7YKN4bdBTwvisf9aaXERosGiXysgBDutOqxA3Tf8KHKQMgJQpY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-937e5f9ea74so1035548939f.1
        for <linux-nilfs@vger.kernel.org>; Mon, 13 Oct 2025 02:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760347111; x=1760951911;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P0laP8EeKth6R1NgHIrN+JC7w+ZEUl/qF2GCsYmoFEo=;
        b=c1DoMAnAvXScwua4C659cTLreRRuI2tXWmlJdqFwd5+Jmq/Vuxf2VuBJmQ9kGKsd23
         z6o4cf416SEwlOX3fuMfxS3p89fDEFqlkxzx7J85sn3ueGoTz7fgIb8nm6UO3+UkxlYk
         wnglS1iK6Xj1dylSoOKLZSjGm9iVLPv58iRickx74xdQ8wgb/Xi514WghaDOcF1XwCXu
         jm2dbMpWng0N515iCAy67V/amtuLMfGqmMpIw9Bdm/4zJLHV3OHwKp4wq42ZSOwKA7FW
         c8EY7Kw0Yvdw20AVNne+tVkCxtQM0MNsA9HOVQLmjMpw+go/tCUGxz/xCKFwW3Gb//fP
         GVbg==
X-Forwarded-Encrypted: i=1; AJvYcCUuH6lQnRgyQyV09/lugN2J4QIiM3Ys+daOTT2b4buaoV8styfsMfRzdMyQQxdIp3VxIWZ1XZ2kcC/bZg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRXKoDPbWV8d6VpoPn1xxpKFyncGr2GujkhmaSRjzv8/pH2Sfl
	K7TK3In64suHKsYtWGY00JxeF9zYvoKnXatvETQCUx93O94WUOF7gqAggQ59UdmJ0dTvHvZuRos
	MEFoIcVsV0XeRZASEA+3S3AiF69eAjE6wADN9u3U+u6MT5hXdcgJhsd8qI7g=
X-Google-Smtp-Source: AGHT+IF5V+oWCmqM0HfuIQ88nOy3VMUgRK5cRx725Aul0GoLvxWIBznmInpSPo79qN1Jb2CGYMPHP8qp7k6whgQvmH9F4AJfe84H
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:318a:b0:42f:8ee7:6494 with SMTP id
 e9e14a558f8ab-42f8ee76610mr186770395ab.9.1760347111433; Mon, 13 Oct 2025
 02:18:31 -0700 (PDT)
Date: Mon, 13 Oct 2025 02:18:31 -0700
In-Reply-To: <68a82586.a00a0220.33401d.0251.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ecc3e7.a70a0220.b3ac9.0018.GAE@google.com>
Subject: Re: [syzbot] [nilfs?] WARNING in nilfs_rename (2)
From: syzbot <syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    2b763d465239 Add linux-next specific files for 20251010
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15847304580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=99cb6b007a8889ef
dashboard link: https://syzkaller.appspot.com/bug?extid=f6c7e1f1809f235eeb90
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1191867c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13847304580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6a00344625c3/disk-2b763d46.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cd34c500f8eb/vmlinux-2b763d46.xz
kernel image: https://storage.googleapis.com/syzbot-assets/660905c62cb2/bzImage-2b763d46.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/25cb8f01270c/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: fs/inode.c:417 at drop_nlink+0xc5/0x110 fs/inode.c:417, CPU#0: syz.0.217/6748
Modules linked in:
CPU: 0 UID: 0 PID: 6748 Comm: syz.0.217 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:drop_nlink+0xc5/0x110 fs/inode.c:417
Code: 70 07 00 00 be 08 00 00 00 e8 07 da e7 ff f0 48 ff 83 70 07 00 00 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc e8 dc 26 82 ff 90 <0f> 0b 90 eb 81 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff
RSP: 0018:ffffc9000c52f9d0 EFLAGS: 00010293
RAX: ffffffff823e1d34 RBX: ffff88805699e008 RCX: ffff888027213c80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff8f9e1877 R09: 1ffffffff1f3c30e
R10: dffffc0000000000 R11: fffffbfff1f3c30f R12: 1ffff1100ad33c0a
R13: ffff88805699d368 R14: ffff88805699e050 R15: dffffc0000000000
FS:  00007f06f15f66c0(0000) GS:ffff888125d0b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa97ff3f000 CR3: 0000000072f60000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nilfs_rename+0x46a/0x820 fs/nilfs2/namei.c:418
 vfs_rename+0xb34/0xe80 fs/namei.c:5216
 do_renameat2+0x6a2/0xa50 fs/namei.c:5364
 __do_sys_rename fs/namei.c:5411 [inline]
 __se_sys_rename fs/namei.c:5409 [inline]
 __x64_sys_rename+0x82/0x90 fs/namei.c:5409
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f06f078eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f06f15f6038 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00007f06f09e5fa0 RCX: 00007f06f078eec9
RDX: 0000000000000000 RSI: 0000200000000180 RDI: 0000200000000040
RBP: 00007f06f0811f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f06f09e6038 R14: 00007f06f09e5fa0 R15: 00007fffd3cbc518
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
