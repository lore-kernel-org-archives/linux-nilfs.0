Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568372C21EC
	for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 03:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773717931; cv=none; b=iw1yxsD8SJ/DOrxSEIjgOOdsXFyU59q/88jFM8kiah/iKvh0A1LrS2fsz+I3b8lBTssBjepPhLXBUhvTYZjgZcZMGAkOgO/BIBiDdUgjXbbtV2xhO3IBa5gR2W4iIjpckTVO6OB4REK72gZh7nInPlQdDTnM8ck1erjMQN3LxlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773717931; c=relaxed/simple;
	bh=nC72H9vLIyaAeL3e57mN5E1wb8hweXjKBsA7ZgPSJow=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FYHF/fQQ/EdrI3ciDgdLyHK+Ugrgwcv7jaz0GiTtR6jagxvq8WmcJz2FDgczB4CNtCLbexM8r0Mxsg6YHPsw6nD5lWMgEFTRKOCCmv6YLGC6MtqADG5qHpXc2RfYrj+3gfNEzJhp8bfA75M4uitaFoMJP3PrI8s1y6qHPJXbfpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7d7423ac71cso21399952a34.3
        for <linux-nilfs@vger.kernel.org>; Mon, 16 Mar 2026 20:25:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773717929; x=1774322729;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t/2SCNiBNakF3be1m1A0Bj3Aq0YZ6YpEmxhKRuEbE4E=;
        b=Hi0zkxIiy8M0tjnLrlSD5vxF1oV9avUoOIVoBUTchJuJE1pBqDJ41yySyWxFMOp9KS
         doKtRZgx7Rf4Bvt5ci9/LSdOMLTTFu90NAALhKEh63+h6/HbZiTfnNIAG9JFuCqYIqhQ
         l9DdtNkXyZI6EHibxPb4+AGXomL0dwI4ReATK8Z+A0VXWWbpXPuhAjKjxTF1ZGukQQs8
         o+qre4vjlgc7GyErsIGfW0lfm+yXci2AOHbslfcz8RoFShDHGGJNWM3BJin9G8O+kbXA
         w0EZJsVz0mcmv5LdmRjArLQ5SiRF+mk09nhzu28xcRUKZb0BEbRgz2dc8caGA20LkLDO
         nRYw==
X-Forwarded-Encrypted: i=1; AJvYcCWf+ww4tn3fhkZQ3VL9dtNznWX6bUWHi5IqF/BydhbdY0lBp9Sftd2GN/SloXkzFC5s+Qu/adwUpYhwqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvQmimihZtrKMnvP58fLJlZj732KocDVQYkeIxYvNlpkhBtKQz
	h5aJEe/kQS1D21LoEPIH1SBWFmdzBXzQbuVrD32zT0NIfnsuMI0CHkjZJVOs6q8Lr1pNSVOY6rk
	xWSGNdx2eK09uTSnrHhRStXj1EV6pU2byqJuTscS4ixiZhOaBtKs85bEEIlY=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4a0e:b0:67b:f21d:2c2a with SMTP id
 006d021491bc7-67bf21d2d3bmr5099193eaf.71.1773717929345; Mon, 16 Mar 2026
 20:25:29 -0700 (PDT)
Date: Mon, 16 Mar 2026 20:25:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b8c9a9.a00a0220.3b25d1.002a.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_ioctl_prepare_clean_segments
From: syzbot <syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8004279c41ad Merge tag 'nfs-for-7.0-2' of git://git.linux-..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a7ef5a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccef46afa67b2b19
dashboard link: https://syzkaller.appspot.com/bug?extid=466a45fcfb0562f5b9a0
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8004279c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f56a78af5be3/vmlinux-8004279c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/89a6ba48229d/bzImage-8004279c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 4096
------------[ cut here ]------------
ret == -ENOENT
WARNING: fs/nilfs2/ioctl.c:757 at nilfs_ioctl_mark_blocks_dirty fs/nilfs2/ioctl.c:757 [inline], CPU#0: syz.0.0/5325
WARNING: fs/nilfs2/ioctl.c:757 at nilfs_ioctl_prepare_clean_segments+0x7e7/0x800 fs/nilfs2/ioctl.c:799, CPU#0: syz.0.0/5325
Modules linked in:
CPU: 0 UID: 0 PID: 5325 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:nilfs_ioctl_mark_blocks_dirty fs/nilfs2/ioctl.c:757 [inline]
RIP: 0010:nilfs_ioctl_prepare_clean_segments+0x7e7/0x800 fs/nilfs2/ioctl.c:799
Code: fe e9 3e fa ff ff 44 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c d4 fa ff ff 4c 89 ef e8 14 65 7f fe e9 c7 fa ff ff e8 7a 9c 13 fe 90 <0f> 0b 90 41 bf fe ff ff ff e9 e3 fe ff ff 66 66 2e 0f 1f 84 00 00
RSP: 0018:ffffc9000dd67640 EFLAGS: 00010287
RAX: ffffffff83b210d6 RBX: 00000000fffffffe RCX: 0000000000100000
RDX: ffffc9000ec2a000 RSI: 0000000000000da2 RDI: 0000000000000da3
RBP: ffffc9000dd67730 R08: ffff888032670000 R09: 0000000000000002
R10: 00000000fffffffe R11: 0000000000000002 R12: dffffc0000000000
R13: 0000000000000026 R14: ffff888047e247a8 R15: ffff8880363691a8
FS:  00007fbbd17f56c0(0000) GS:ffff88808ca55000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6d354afad8 CR3: 0000000011c60000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 nilfs_clean_segments+0x18c/0xa50 fs/nilfs2/segment.c:2525
 nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:916 [inline]
 nilfs_ioctl+0x261f/0x2780 fs/nilfs2/ioctl.c:1346
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbbd539c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbbd17f4fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fbbd5615fa0 RCX: 00007fbbd539c799
RDX: 0000200000000640 RSI: 0000000040786e88 RDI: 0000000000000004
RBP: 00007fbbd5432c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbbd5616038 R14: 00007fbbd5615fa0 R15: 00007ffc39685c28
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
