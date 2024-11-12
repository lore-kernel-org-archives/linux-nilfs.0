Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13D4208208
	for <linux-nilfs@vger.kernel.org>; Tue, 12 Nov 2024 05:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731387867; cv=none; b=shwhbMomQf0yCoKdXcFJFbJmsVQ6xWp7wPJPDdd7eAI5dieXFZ3smuf9OjrcpaPs0IO4VDvl5mcGtF9jQpoSZv1G1MygPKUOKc7cf7aD2joqW4mV3i/5IJQUuSdIwYtJPAh42JIqnFP75bczdd4/H46TJCP7pqfXialyLIdG3Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731387867; c=relaxed/simple;
	bh=W0dj287dzjIJjdbZaulXMh+X213+2qosiWy2Vk8RocA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=a5cs5Y6sk4471EKzgSK8lVI5hiIX0vpeE4VA/JGifhEBsVhKXIVde6qUVgybM3I6bVhKvaf8c7VlI5Pz/DQyakkqSlfyIOI+Bai30tq2JtpQ7dwLe+SaBWiBHVVMpw2ANHXpZ36PTffr/yVh60d8nasT8dSveh3J5OKQcLNR/Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a6bce8a678so61373185ab.1
        for <linux-nilfs@vger.kernel.org>; Mon, 11 Nov 2024 21:04:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731387865; x=1731992665;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YB3Ah0RGLaYdvbFDPZ8cvoDOA7IY60wa7/IUSI9QoEk=;
        b=N695R12Dssyhgodw+2FLhdSB+qHzgvwNwu7qLbpJw+4LfQFA/2BT6aRsyp+GY8lJUF
         1PdoM5b9ICZUSxx7HKCrX9557pfREATcBkjA48yYF0JDEaTygcYdcF/9Okzci5fquM8N
         IDNnXEEKsYq9Iv99pGywLLq+cTFbi/kH2yZvC3r++IciB/rmR828JGpI7PssMAzLtFWu
         slZ4JdKC/ARbrzDf0gXjjm7oa/QIigLTqO1/YCrcRlHe9r65PNcnHTGNcqhYAOCaV8Jo
         9xeqNrqmllOiMxZJPT0Zn1UC3cAGSngsJH8AvW3OjDit/B5TjjzEXcF1NREqVERz6UNL
         YgUw==
X-Forwarded-Encrypted: i=1; AJvYcCW1Mw+jMyAy4R9l4WmLy7Br+5i37b1jWVs9h0OEA8FnuRyj+y57epczZ9FYoiINkJpdaTySCQJu1p7ORg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxCrAaqI5ZQQeTIIRfiKkLpxKAEMxj7B6BlTt6ax+r/K7R5DiYg
	c/HtdUsb9bGjyQc9qxTHTq1u7oL71PBAE3YjmNwE7vvBDnz/PuSBOC1VR2SX/xUqJ/dTgk+BtSM
	pkRQ7x0dhF7YmULnFRM+t6JLlCsbLZvKemC3mGqUJldL/4L0MZY094Oo=
X-Google-Smtp-Source: AGHT+IFImIOExvTVlu8RRxhUWLiI1/7SG7AeXvSmrGeKoAbLhlp+fCECzbixJLdZEnFYA/zhjiwRxP4bhsBcbktqJGjpnFm6+cuQ
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fe3:b0:3a6:c976:ed6 with SMTP id
 e9e14a558f8ab-3a6f199fbf3mr148704705ab.4.1731387864947; Mon, 11 Nov 2024
 21:04:24 -0800 (PST)
Date: Mon, 11 Nov 2024 21:04:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6732e1d8.050a0220.138bd5.00d3.GAE@google.com>
Subject: [syzbot] [nilfs?] KASAN: use-after-free Read in nilfs_find_entry
From: syzbot <syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    906bd684e4b1 Merge tag 'spi-fix-v6.12-rc6' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1418ee30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64aa0d9945bd5c1
dashboard link: https://syzkaller.appspot.com/bug?extid=96d5d14c47d97015c624
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1218ee30580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13647f40580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-906bd684.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/88c5c4ba7e33/vmlinux-906bd684.xz
kernel image: https://storage.googleapis.com/syzbot-assets/07094e69f47b/bzImage-906bd684.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b427c083d0d8/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com

=======================================================
==================================================================
BUG: KASAN: use-after-free in nilfs_find_entry+0x29c/0x660 fs/nilfs2/dir.c:321
Read of size 2 at addr ffff888048f39008 by task syz-executor334/5310

CPU: 0 UID: 0 PID: 5310 Comm: syz-executor334 Not tainted 6.12.0-rc6-syzkaller-00169-g906bd684e4b1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 nilfs_find_entry+0x29c/0x660 fs/nilfs2/dir.c:321
 nilfs_inode_by_name+0xad/0x240 fs/nilfs2/dir.c:394
 nilfs_lookup+0xed/0x210 fs/nilfs2/namei.c:63
 lookup_open fs/namei.c:3573 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x11a7/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd472823b99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff91507d48 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 6569727261626f6e RCX: 00007fd472823b99
RDX: 000000000000275a RSI: 0000000020000080 RDI: 00000000ffffff9c
RBP: 00007fd4728975f0 R08: 0000000000000ee3 R09: 00005555568904c0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff91507d70
R13: 00007fff91507f98 R14: 431bde82d7b634db R15: 00007fd47286c03b
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f0a3df02 pfn:0x48f39
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
raw: 04fff00000000000 ffffea000123ce88 ffff88801fc44cb0 0000000000000000
raw: 00000007f0a3df02 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(GFP_HIGHUSER_MOVABLE|__GFP_COMP|__GFP_ZERO), pid 5300, tgid 5300 (sshd), ts 68164329439, free_ts 68237870503
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x303f/0x3190 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4733
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 folio_alloc_mpol_noprof mm/mempolicy.c:2283 [inline]
 vma_alloc_folio_noprof+0x12e/0x230 mm/mempolicy.c:2314
 folio_prealloc+0x31/0x170
 alloc_anon_folio mm/memory.c:4727 [inline]
 do_anonymous_page mm/memory.c:4784 [inline]
 do_pte_missing mm/memory.c:3963 [inline]
 handle_pte_fault+0x24dd/0x6820 mm/memory.c:5766
 __handle_mm_fault mm/memory.c:5909 [inline]
 handle_mm_fault+0x1106/0x1bb0 mm/memory.c:6077
 do_user_addr_fault arch/x86/mm/fault.c:1338 [inline]
 handle_page_fault arch/x86/mm/fault.c:1481 [inline]
 exc_page_fault+0x459/0x8c0 arch/x86/mm/fault.c:1539
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
page last free pid 5300 tgid 5300 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_folios+0xf12/0x18d0 mm/page_alloc.c:2686
 folios_put_refs+0x76c/0x860 mm/swap.c:1007
 free_pages_and_swap_cache+0x2ea/0x690 mm/swap_state.c:332
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:136 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:149 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:366 [inline]
 tlb_flush_mmu+0x3a3/0x680 mm/mmu_gather.c:373
 tlb_finish_mmu+0xd4/0x200 mm/mmu_gather.c:465
 vms_clear_ptes+0x437/0x530 mm/vma.c:1103
 vms_complete_munmap_vmas+0x208/0x910 mm/vma.c:1147
 do_vmi_align_munmap+0x613/0x730 mm/vma.c:1356
 do_vmi_munmap+0x24e/0x2d0 mm/vma.c:1404
 __vm_munmap+0x24c/0x480 mm/mmap.c:1613
 __do_sys_munmap mm/mmap.c:1630 [inline]
 __se_sys_munmap mm/mmap.c:1627 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1627
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888048f38f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888048f38f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888048f39000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                      ^
 ffff888048f39080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888048f39100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


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
