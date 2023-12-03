Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E629FA
	for <linux-nilfs@vger.kernel.org>; Sat,  2 Dec 2023 21:17:19 -0800 (PST)
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1faef8466f9so3253147fac.3
        for <linux-nilfs@vger.kernel.org>; Sat, 02 Dec 2023 21:17:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701580639; x=1702185439;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=56szsQ0vYmImcqcyB2sjouYaueQTl9SlxBw3VczB0Q0=;
        b=CryY9RfUseJAYgI0zNy3xU1bET6/vhpLNWpA3uOebyFq4ffBL/oELratQUjIdoI88l
         GkDzaSqfxskHDDS7Y/XTgwIOHcc5p0GrwI9lckwQvOrJ9W7g4OzUO4bywmzCmKN6cKys
         wpVU3TqdRXqVyZy956gB0WuRI7ZcT3WLHeQTTKl4sqYP3+DVzMSadQZdUIAkhNinjiSM
         OQzDjA2jgAp6HkVJeW7ihjXCW4da4AxVrFIof/P3aZWmIlrPQLjh93JtW+g73UEuJy/k
         bfs9u96XIbIU99a5BMuCR5Mddm44S3VN0BXBoCWftmd3GC7GOaZoSljcbiQLfXLImk9q
         FqwQ==
X-Gm-Message-State: AOJu0Yz+VBGYfF+ulhGowqF8+DMdoM6hhSZZRYrTeaWeWA3CVXRQOK7I
	l0E4r64TcrvexnEL5p37YZSmZNmwcNxtX6xLAGgcI2QrtgzS
X-Google-Smtp-Source: AGHT+IHOeJMskL3ClffFi++0886zk+JzoTKYxYR4xtvcxIR+0JcaxurkTl1w1lcvVFySfjiP9uVBIqu5pJIAkyH5iIF/mSAxzzDU
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6871:111:b0:1fa:de88:1f3d with SMTP id
 y17-20020a056871011100b001fade881f3dmr1440866oab.1.1701580638914; Sat, 02 Dec
 2023 21:17:18 -0800 (PST)
Date: Sat, 02 Dec 2023 21:17:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008a0e15060b941d04@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_btree_assign (2)
From: syzbot <syzbot+9f22ab249b48e3877e87@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Level: *

Hello,

syzbot found the following issue on:

HEAD commit:    18d46e76d7c2 Merge tag 'for-6.7-rc3-tag' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=105eaac2e80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2c74446ab4f0028
dashboard link: https://syzkaller.appspot.com/bug?extid=9f22ab249b48e3877e87
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a7e129b54034/disk-18d46e76.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e17ed7161adc/vmlinux-18d46e76.xz
kernel image: https://storage.googleapis.com/syzbot-assets/89a7c739e757/bzImage-18d46e76.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9f22ab249b48e3877e87@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 21731 at fs/nilfs2/btree.c:2283 nilfs_btree_assign+0xab7/0xd20 fs/nilfs2/btree.c:2283
Modules linked in:
CPU: 0 PID: 21731 Comm: segctord Not tainted 6.7.0-rc3-syzkaller-00024-g18d46e76d7c2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/10/2023
RIP: 0010:nilfs_btree_assign+0xab7/0xd20 fs/nilfs2/btree.c:2283
Code: 0f 85 80 02 00 00 44 89 f0 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 f6 c6 35 fe 4c 8b 7c 24 38 eb a6 e8 ea c6 35 fe 90 <0f> 0b 90 41 be fe ff ff ff eb 95 44 89 f1 80 e1 07 80 c1 03 38 c1
RSP: 0018:ffffc90009877560 EFLAGS: 00010293
RAX: ffffffff8358b356 RBX: ffff888036b43358 RCX: ffff8880752c9dc0
RDX: 0000000000000000 RSI: 00000000fffffffe RDI: 00000000fffffffe
RBP: ffffc90009877690 R08: ffffffff8358ac9b R09: 1ffff11007864d22
R10: dffffc0000000000 R11: ffffed1007864d23 R12: dffffc0000000000
R13: ffff888038e7e900 R14: 00000000fffffffe R15: 1ffff9200130eebc
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555555aba788 CR3: 0000000030425000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nilfs_bmap_assign+0x8b/0x160 fs/nilfs2/bmap.c:390
 nilfs_segctor_update_payload_blocknr fs/nilfs2/segment.c:1626 [inline]
 nilfs_segctor_assign fs/nilfs2/segment.c:1660 [inline]
 nilfs_segctor_do_construct+0x37ae/0x6e40 fs/nilfs2/segment.c:2092
 nilfs_segctor_construct+0x145/0x8c0 fs/nilfs2/segment.c:2415
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2523 [inline]
 nilfs_segctor_thread+0x53a/0x1140 fs/nilfs2/segment.c:2606
 kthread+0x2d3/0x370 kernel/kthread.c:388
 ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:242
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
