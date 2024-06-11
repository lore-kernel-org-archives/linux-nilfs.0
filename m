Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F62548FD
	for <linux-nilfs@vger.kernel.org>; Tue, 11 Jun 2024 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718129423; cv=none; b=b5+65syY3XA9Opn6d4hrxTBPlrfV1ZogxEOWgsLUcMexlcynCwe1MOv3akQWE6qXAicIhADe01L329mGZcRTObbhkY8QB0FOnN5tEwERgHnEEMWgoNJbnbVM6i34z4nyJkK1pl9GCcStSIyD3FF5oJZTraHRqggQb/e2fI61Juc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718129423; c=relaxed/simple;
	bh=vjwA2Wok040zzVZKo9uLs1c0qCD7WK2bUs+XerRBhsY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=m1LtpeQvY5kIgPwoVe2eoehnKCZkaOvKrH+w5JZM6LZCbXefYukx0BabAfv10JvP6yt+IV7tdcmen5PbVo0zG3dQKm8I9eFqkhWMOZqAWs7+NqTzHdmceE7O1A+6Ra3TMYx/wFXXpCR1SuJSOsmAgNNcRHrdz9S+iiMB86fs2v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7eb01189491so717524639f.1
        for <linux-nilfs@vger.kernel.org>; Tue, 11 Jun 2024 11:10:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718129420; x=1718734220;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDQFxHrZ69GwrtBel7yWdCxXld5VZHKA5oIAYvqQHAo=;
        b=aeIufO1deN4ZiR7SLxnEhK4NPZFhIlrjCEuPFmNHpXxYb2P3WPnwXQCkUuIa5jtxVz
         0kjlcA3VEnQtFcQ8lJsrSRe8mrxDepYaG5psoDSB2MRVrAhoLfC8zogYJHuToId0JHjB
         foQyYktCmJgZWVoLbSVjfvdVdVd8e3dVqQJ6p/vTZuZqaBah4vI1pqvpPC0++0XBjXhn
         9cMT6pdzsmJp3VFMeuls/mmK2rigW7QfYASQymYsJtgmh/U2ThAvPqNwr1G6Dgq3Nonv
         Wl3L3aB8JE4KHbI/7SDAKYZEhkDsoYyphpGmd1SRDVWmGM/ShEKM1ER7pGEgj8WagVcg
         0o8Q==
X-Forwarded-Encrypted: i=1; AJvYcCU6pqVvcDTY5S13m+hhpqEuaN/1WU5YJVNkf4UMiMSjr3y1q/fcMkDCCq3jIrIAXP3dDTlSLsl7fB33CGoeuCRv6HHYQzIZrLHOmC4=
X-Gm-Message-State: AOJu0YzRmyZnREWPbecQ1rkLpEHs4/ZLKyhdoiSKWoB1biHmbdAFZX3j
	tqfLBRRW16LdxPiWd/R8VhDI/3/x6Kv38AUZmCeEZlOzBHNHCs6DXWLGlDX9IextWGyuxOvw52C
	L3eA/qrmRI4ttE7yBFYjDvZhyaHGJWHcpN2JnwfbHP0OL4oYVRzeZq9M=
X-Google-Smtp-Source: AGHT+IFqxJT9CInXqqquCh7b1RzHFeU5HXwk86pYWutqpMT2QJMYc/z4ZMlqpbyEMPIDj+NOtqtpF/vV1+EhEGTsLpT4+nY9Qa70
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1602:b0:7eb:85f7:5fd with SMTP id
 ca18e2360f4ac-7eb85f711c4mr35077739f.0.1718129420587; Tue, 11 Jun 2024
 11:10:20 -0700 (PDT)
Date: Tue, 11 Jun 2024 11:10:20 -0700
In-Reply-To: <0000000000008874480617ff1bad@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cae276061aa12d5e@google.com>
Subject: Re: [syzbot] [nilfs?] [mm?] KASAN: slab-use-after-free Read in lru_add_fn
From: syzbot <syzbot+d79afb004be235636ee8@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, konishi.ryusuke@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    83a7eefedc9b Linux 6.10-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15eb4c7a980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8786f381e62940f
dashboard link: https://syzkaller.appspot.com/bug?extid=d79afb004be235636ee8
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1073d8ee980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17c645e2980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-83a7eefe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c1eea9d0e321/vmlinux-83a7eefe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1a79e458e1e6/bzImage-83a7eefe.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1f873a22e09f/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d79afb004be235636ee8@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: slab-use-after-free in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: slab-use-after-free in mapping_unevictable include/linux/pagemap.h:259 [inline]
BUG: KASAN: slab-use-after-free in folio_evictable mm/internal.h:353 [inline]
BUG: KASAN: slab-use-after-free in lru_add_fn+0x192/0xd70 mm/swap.c:184
Read of size 8 at addr ffff888032180b10 by task syz-executor358/5362

CPU: 2 PID: 5362 Comm: syz-executor358 Not tainted 6.10.0-rc3-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0xc3/0x620 mm/kasan/report.c:488
 kasan_report+0xd9/0x110 mm/kasan/report.c:601
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0xef/0x1a0 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 mapping_unevictable include/linux/pagemap.h:259 [inline]
 folio_evictable mm/internal.h:353 [inline]
 lru_add_fn+0x192/0xd70 mm/swap.c:184
 folio_batch_move_lru+0x243/0x400 mm/swap.c:220
 folio_batch_add_and_move+0xe5/0x160 mm/swap.c:236
 folio_add_lru+0x37d/0x7f0 mm/swap.c:522
 shmem_alloc_and_add_folio+0x4ae/0x790 mm/shmem.c:1722
 shmem_get_folio_gfp+0x687/0x13d0 mm/shmem.c:2055
 shmem_get_folio mm/shmem.c:2160 [inline]
 shmem_write_begin+0x15a/0x360 mm/shmem.c:2743
 generic_perform_write+0x272/0x620 mm/filemap.c:4015
 shmem_file_write_iter+0x114/0x140 mm/shmem.c:2919
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0x6b6/0x1140 fs/read_write.c:590
 ksys_write+0x12f/0x260 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f882e62a330
Code: 40 00 48 c7 c2 b8 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 80 3d 71 9d 07 00 00 74 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 48 89
RSP: 002b:00007fffd60928f8 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fffd6092910 RCX: 00007f882e62a330
RDX: 0000000000100000 RSI: 00007f8826000000 RDI: 0000000000000003
RBP: 00007f8826000000 R08: 0000000000000ab9 R09: 0000000000000ab5
R10: 00000000000007c2 R11: 0000000000000202 R12: 00007fffd6092aac
R13: 00007fffd6092950 R14: 0000000000000003 R15: 0000000000100000
 </TASK>

Allocated by task 5360:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:312 [inline]
 __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:338
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3941 [inline]
 slab_alloc_node mm/slub.c:4001 [inline]
 kmem_cache_alloc_lru_noprof+0x121/0x2f0 mm/slub.c:4020
 nilfs_alloc_inode+0x26/0x150 fs/nilfs2/super.c:154
 alloc_inode+0x5d/0x230 fs/inode.c:261
 iget5_locked fs/inode.c:1235 [inline]
 iget5_locked+0x1c9/0x2c0 fs/inode.c:1228
 nilfs_iget_locked+0xa1/0xe0 fs/nilfs2/inode.c:606
 nilfs_ifile_read+0x2f/0x1e0 fs/nilfs2/ifile.c:192
 nilfs_attach_checkpoint+0x12d/0x1d0 fs/nilfs2/super.c:557
 nilfs_fill_super fs/nilfs2/super.c:1067 [inline]
 nilfs_get_tree+0x951/0x1000 fs/nilfs2/super.c:1211
 vfs_get_tree+0x8f/0x380 fs/super.c:1780
 do_new_mount fs/namespace.c:3352 [inline]
 path_mount+0x14e6/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __x64_sys_mount+0x297/0x320 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 0:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:579
 poison_slab_object+0xf7/0x160 mm/kasan/common.c:240
 __kasan_slab_free+0x32/0x50 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2196 [inline]
 slab_free mm/slub.c:4437 [inline]
 kmem_cache_free+0x12f/0x3a0 mm/slub.c:4512
 i_callback+0x43/0x70 fs/inode.c:250
 rcu_do_batch kernel/rcu/tree.c:2535 [inline]
 rcu_core+0x828/0x16b0 kernel/rcu/tree.c:2809
 handle_softirqs+0x216/0x8f0 kernel/softirq.c:554
 __do_softirq kernel/softirq.c:588 [inline]
 invoke_softirq kernel/softirq.c:428 [inline]
 __irq_exit_rcu kernel/softirq.c:637 [inline]
 irq_exit_rcu+0xbb/0x120 kernel/softirq.c:649
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 [inline]
 sysvec_apic_timer_interrupt+0x95/0xb0 arch/x86/kernel/apic/apic.c:1043
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702

Last potentially related work creation:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 __kasan_record_aux_stack+0xba/0xd0 mm/kasan/generic.c:541
 __call_rcu_common.constprop.0+0x9a/0x790 kernel/rcu/tree.c:3072
 destroy_inode+0x12c/0x1b0 fs/inode.c:316
 iput_final fs/inode.c:1741 [inline]
 iput.part.0+0x5a8/0x7f0 fs/inode.c:1767
 iput+0x5c/0x80 fs/inode.c:1757
 nilfs_put_root+0xae/0xe0 fs/nilfs2/the_nilfs.c:925
 nilfs_segctor_destroy fs/nilfs2/segment.c:2788 [inline]
 nilfs_detach_log_writer+0x5ef/0xaa0 fs/nilfs2/segment.c:2850
 nilfs_put_super+0x43/0x1b0 fs/nilfs2/super.c:498
 generic_shutdown_super+0x159/0x3d0 fs/super.c:642
 kill_block_super+0x3b/0x90 fs/super.c:1676
 deactivate_locked_super+0xbe/0x1a0 fs/super.c:473
 deactivate_super+0xde/0x100 fs/super.c:506
 cleanup_mnt+0x222/0x450 fs/namespace.c:1267
 task_work_run+0x14e/0x250 kernel/task_work.c:180
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x278/0x2a0 kernel/entry/common.c:218
 do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888032180668
 which belongs to the cache nilfs2_inode_cache of size 1512
The buggy address is located 1192 bytes inside of
 freed 1512-byte region [ffff888032180668, ffff888032180c50)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x32180
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffefff(slab)
raw: 00fff00000000040 ffff888016ad9540 ffffea0000c84e00 0000000000000002
raw: 0000000000000000 0000000080130013 00000001ffffefff 0000000000000000
head: 00fff00000000040 ffff888016ad9540 ffffea0000c84e00 0000000000000002
head: 0000000000000000 0000000080130013 00000001ffffefff 0000000000000000
head: 00fff00000000003 ffffea0000c86001 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Reclaimable, gfp_mask 0xd2050(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_RECLAIMABLE), pid 5215, tgid 5215 (syz-executor358), ts 206379124412, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x2d1/0x350 mm/page_alloc.c:1468
 prep_new_page mm/page_alloc.c:1476 [inline]
 get_page_from_freelist+0x136a/0x2e50 mm/page_alloc.c:3420
 __alloc_pages_noprof+0x22b/0x2460 mm/page_alloc.c:4678
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 alloc_slab_page+0x56/0x110 mm/slub.c:2265
 allocate_slab mm/slub.c:2428 [inline]
 new_slab+0x84/0x260 mm/slub.c:2481
 ___slab_alloc+0xdac/0x1870 mm/slub.c:3667
 __slab_alloc.constprop.0+0x56/0xb0 mm/slub.c:3757
 __slab_alloc_node mm/slub.c:3810 [inline]
 slab_alloc_node mm/slub.c:3989 [inline]
 kmem_cache_alloc_lru_noprof+0x2a0/0x2f0 mm/slub.c:4020
 nilfs_alloc_inode+0x26/0x150 fs/nilfs2/super.c:154
 alloc_inode+0x5d/0x230 fs/inode.c:261
 iget5_locked fs/inode.c:1235 [inline]
 iget5_locked+0x1c9/0x2c0 fs/inode.c:1228
 nilfs_attach_btree_node_cache+0x255/0x410 fs/nilfs2/inode.c:684
 nilfs_btree_init+0x1d6/0x2d0 fs/nilfs2/btree.c:2431
 nilfs_bmap_read+0x3fc/0x6a0 fs/nilfs2/bmap.c:539
 nilfs_read_inode_common+0x7c6/0x9f0 fs/nilfs2/inode.c:476
 __nilfs_read_inode fs/nilfs2/inode.c:501 [inline]
 nilfs_iget+0x2ae/0x850 fs/nilfs2/inode.c:621
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888032180a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888032180a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888032180b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff888032180b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888032180c00: fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
