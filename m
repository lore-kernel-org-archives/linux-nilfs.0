Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE4F8801;
	Sun, 21 Jul 2024 08:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721549612; cv=none; b=oB9saeeiG71ILuknTybUm0rEpNCqfvRn6SI22lDBOVP2EATHA/EQ8vrifZdYM6fZfat4t3S8zxWQKCExMV+73dc0fsLcDPezLCKklslaBKdZEnjQQVcbLNnarWS8YoU/9zfUWCl/5NtSpwxo+75nB8n7FSHI2KAJd+18+Y9wfk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721549612; c=relaxed/simple;
	bh=J/PH6u99YxTz0EDqOb4oqZ1DRE5vDIjzTUq2RVmJfkE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=szb1+16VYZFlBVSWm48f4HLgjLRhUeMx17vV+sOSSWVnw56OjcMTQt4gIaI41HGiD3FtETagTdDCprMj4L9bT33S58d314o1zmaWsOXrPzX/0AjN3mMnbyPNDMSjMZEIs9xvfBHBNNTxepIT/esgsl1JCqFU9KTGs0lPv79b174=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Goza/qy3; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Goza/qy3"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2eeb1ba040aso48003801fa.1;
        Sun, 21 Jul 2024 01:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721549609; x=1722154409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZeqCo8QchJT16EWgNuSNU/sgikr5yBPy/z/Wy+ZJ0V4=;
        b=Goza/qy3u6FkRyAUyANYdUTQNbbiuiE57gUAJoHO1Ef9yu0UboUSYvvIovFmdbFrYn
         +Uh3UghkKSgiziL8uZx/FM2BZ9xDnMpjmumDYf6uM0vwi88dGqApwgbQIbRw48obQZvs
         Hc9CusM+jGz1YLu6lKej8sz8g92eA/Dsn8Bhu1t1cu0cTbhqzvpCEojXZrWLucPctylR
         4R6cXIcJKSJhL1J8J9qiw5zNPe8tKRBC0VzFWrT6VPXPSTys6MlwobGnMCyBKIEJXsTN
         AzA0wew/irxHCFm+52fQTVA6P+7FMK13X69a27ZJ8LQA4DL6Pcb3/8UNwzvrbWE5AB9R
         +dKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721549609; x=1722154409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZeqCo8QchJT16EWgNuSNU/sgikr5yBPy/z/Wy+ZJ0V4=;
        b=dWFmBW3sVutF2soLU1zvi3b7I97G2guFISSezCkvqo5EBnPo50pWwq0ekZ6Lvk0fg3
         vV7iT9ROh3kW0J02CwtGbAIbqNA3iVKVMz+3ylfOzdTQeE2uBlHSe6ACUa2ENBveJWyJ
         GdVuyFeycHfHk3dy7V7BIwofU8HamoBSDH/QIlkol84FlHKr6jPIjqWhRN3jc/LXGW5U
         5m1cn7lAH40hdfNYF4KL5b0HlMS1o7M0VnLk6nz7Qof3Cp/dfCxsJxlmwqR+BWndNrHN
         lAV2osZR78w4WCFSsCacTUPvCTwLBTvsn53B6IuOzYroOrGPU+jU7yZS+RTX00uFs2AW
         6CLg==
X-Forwarded-Encrypted: i=1; AJvYcCX0Yw8gRQOt8cu7ttwupq7Ml1yP/rE6YYI0LgfaJM6+iE5wnE1s1iTol9lFS03PYiQa41niH6AGHdkyCAU8uRRSg26VgCXIyL1Pq3fUiSFfm1gk01nqRIoKK+LF4pwpm+RD/yM3WIdyma8=
X-Gm-Message-State: AOJu0YwhyDpoqUzG0e0E8TjG7wLYTFg4MpoUsG6NRGaP1p3AuRYDK4Uv
	Py0oPUgXgqhFahmghK5ygIaruDgTbqrzNSMJDr/ikITGF0LRZTPcLCHlKs5EJdPJdF7SFrypxyH
	1kAhwZ3M4kpMk+buzN9dET1/1pfs=
X-Google-Smtp-Source: AGHT+IHHyw8r2fqGvjUU8u6RuoH+4oLGO09qmFyYNQexICnzH++Y5CZEl8mnGdShoY4livHn9DgpkwaB+w/ptxzEfu4=
X-Received: by 2002:a05:6512:ea1:b0:52e:9619:e26a with SMTP id
 2adb3069b0e04-52efb7a590cmr2130125e87.26.1721549608389; Sun, 21 Jul 2024
 01:13:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000002063c0061b84aa5c@google.com> <CAKFNMo=uLOoDBgG=+Dg0753E+gM0T5_Lkhc2G9ReWRNq4Xy82Q@mail.gmail.com>
In-Reply-To: <CAKFNMo=uLOoDBgG=+Dg0753E+gM0T5_Lkhc2G9ReWRNq4Xy82Q@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 21 Jul 2024 17:13:11 +0900
Message-ID: <CAKFNMonmuCg56_T-TzrCB4BA60=Y9ZRAtEpqhiFuq_HVe8VmjQ@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in
 move_to_new_folio (2)
To: syzbot <syzbot+3961aebd12fe0ea4a3e8@syzkaller.appspotmail.com>
Cc: syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org, 
	linux-nilfs <linux-nilfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 23, 2024 at 8:33=E2=80=AFPM Ryusuke Konishi wrote:
>
> On Sun, Jun 23, 2024 at 10:34=E2=80=AFAM syzbot
> <syzbot+3961aebd12fe0ea4a3e8@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    563a50672d8a Merge tag 'xfs-6.10-fixes-4' of git://git.=
ker..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1599afb1980=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc3820d4fff4=
3c7a3
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D3961aebd12fe0=
ea4a3e8
> > compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for=
 Debian) 2.40
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/7bc7510fe41f/non_bootable_disk-563a5067.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/6ef95d163dde/vmli=
nux-563a5067.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/0102d9e1ac9a=
/bzImage-563a5067.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+3961aebd12fe0ea4a3e8@syzkaller.appspotmail.com
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KASAN: slab-use-after-free in instrument_atomic_read include/linux=
/instrumented.h:68 [inline]
> > BUG: KASAN: slab-use-after-free in _test_bit include/asm-generic/bitops=
/instrumented-non-atomic.h:141 [inline]
> > BUG: KASAN: slab-use-after-free in mapping_unmovable include/linux/page=
map.h:325 [inline]
> > BUG: KASAN: slab-use-after-free in move_to_new_folio+0x12a/0x700 mm/mig=
rate.c:968
> > Read of size 8 at addr ffff8880486117e0 by task kcompactd0/44
> >
> > CPU: 3 PID: 44 Comm: kcompactd0 Not tainted 6.10.0-rc4-syzkaller-00283-=
g563a50672d8a #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-=
1.16.2-1 04/01/2014
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
> >  print_address_description mm/kasan/report.c:377 [inline]
> >  print_report+0xc3/0x620 mm/kasan/report.c:488
> >  kasan_report+0xd9/0x110 mm/kasan/report.c:601
> >  check_region_inline mm/kasan/generic.c:183 [inline]
> >  kasan_check_range+0xef/0x1a0 mm/kasan/generic.c:189
> >  instrument_atomic_read include/linux/instrumented.h:68 [inline]
> >  _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [in=
line]
> >  mapping_unmovable include/linux/pagemap.h:325 [inline]
> >  move_to_new_folio+0x12a/0x700 mm/migrate.c:968
> >  migrate_folio_move mm/migrate.c:1287 [inline]
> >  migrate_pages_batch+0x1e88/0x2f80 mm/migrate.c:1807
> >  migrate_pages_sync mm/migrate.c:1873 [inline]
> >  migrate_pages+0x1b5a/0x27a0 mm/migrate.c:1982
> >  compact_zone+0x1f68/0x4280 mm/compaction.c:2664
> >  compact_node+0x1a2/0x2d0 mm/compaction.c:2928
> >  kcompactd+0x76e/0xde0 mm/compaction.c:3226
> >  kthread+0x2c1/0x3a0 kernel/kthread.c:389
> >  ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> >  </TASK>
> >
> > Allocated by task 25044:
> >  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
> >  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
> >  unpoison_slab_object mm/kasan/common.c:312 [inline]
> >  __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:338
> >  kasan_slab_alloc include/linux/kasan.h:201 [inline]
> >  slab_post_alloc_hook mm/slub.c:3941 [inline]
> >  slab_alloc_node mm/slub.c:4001 [inline]
> >  kmem_cache_alloc_lru_noprof+0x121/0x2f0 mm/slub.c:4020
> >  nilfs_alloc_inode+0x26/0x150 fs/nilfs2/super.c:154
> >  alloc_inode+0x5d/0x230 fs/inode.c:261
> >  iget5_locked fs/inode.c:1235 [inline]
> >  iget5_locked+0x1c9/0x2c0 fs/inode.c:1228
> >  nilfs_iget_locked+0xa1/0xe0 fs/nilfs2/inode.c:606
> >  nilfs_ifile_read+0x2f/0x1e0 fs/nilfs2/ifile.c:192
> >  nilfs_attach_checkpoint+0x12d/0x1d0 fs/nilfs2/super.c:557
> >  nilfs_fill_super fs/nilfs2/super.c:1067 [inline]
> >  nilfs_get_tree+0x951/0x1000 fs/nilfs2/super.c:1211
> >  vfs_get_tree+0x8f/0x380 fs/super.c:1780
> >  do_new_mount fs/namespace.c:3352 [inline]
> >  path_mount+0x14e6/0x1f20 fs/namespace.c:3679
> >  do_mount fs/namespace.c:3692 [inline]
> >  __do_sys_mount fs/namespace.c:3898 [inline]
> >  __se_sys_mount fs/namespace.c:3875 [inline]
> >  __x64_sys_mount+0x297/0x320 fs/namespace.c:3875
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Freed by task 34:
> >  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
> >  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
> >  kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:579
> >  poison_slab_object+0xf7/0x160 mm/kasan/common.c:240
> >  __kasan_slab_free+0x32/0x50 mm/kasan/common.c:256
> >  kasan_slab_free include/linux/kasan.h:184 [inline]
> >  slab_free_hook mm/slub.c:2196 [inline]
> >  slab_free mm/slub.c:4437 [inline]
> >  kmem_cache_free+0x12f/0x3a0 mm/slub.c:4512
> >  i_callback+0x43/0x70 fs/inode.c:250
> >  rcu_do_batch kernel/rcu/tree.c:2535 [inline]
> >  rcu_core+0x828/0x16b0 kernel/rcu/tree.c:2809
> >  handle_softirqs+0x216/0x8f0 kernel/softirq.c:554
> >  run_ksoftirqd kernel/softirq.c:928 [inline]
> >  run_ksoftirqd+0x3a/0x60 kernel/softirq.c:920
> >  smpboot_thread_fn+0x661/0xa10 kernel/smpboot.c:164
> >  kthread+0x2c1/0x3a0 kernel/kthread.c:389
> >  ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> >
> > Last potentially related work creation:
> >  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
> >  __kasan_record_aux_stack+0xba/0xd0 mm/kasan/generic.c:541
> >  __call_rcu_common.constprop.0+0x9a/0x790 kernel/rcu/tree.c:3072
> >  destroy_inode+0x12c/0x1b0 fs/inode.c:316
> >  iput_final fs/inode.c:1741 [inline]
> >  iput.part.0+0x5a8/0x7f0 fs/inode.c:1767
> >  iput+0x5c/0x80 fs/inode.c:1757
> >  nilfs_put_root+0xae/0xe0 fs/nilfs2/the_nilfs.c:925
> >  nilfs_segctor_destroy fs/nilfs2/segment.c:2788 [inline]
> >  nilfs_detach_log_writer+0x5ef/0xaa0 fs/nilfs2/segment.c:2850
> >  nilfs_put_super+0x43/0x1b0 fs/nilfs2/super.c:498
> >  generic_shutdown_super+0x159/0x3d0 fs/super.c:642
> >  kill_block_super+0x3b/0x90 fs/super.c:1676
> >  deactivate_locked_super+0xbe/0x1a0 fs/super.c:473
> >  deactivate_super+0xde/0x100 fs/super.c:506
> >  cleanup_mnt+0x222/0x450 fs/namespace.c:1267
> >  task_work_run+0x14e/0x250 kernel/task_work.c:180
> >  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
> >  exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
> >  exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
> >  __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
> >  syscall_exit_to_user_mode+0x278/0x2a0 kernel/entry/common.c:218
> >  do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > The buggy address belongs to the object at ffff888048611338
> >  which belongs to the cache nilfs2_inode_cache of size 1512
> > The buggy address is located 1192 bytes inside of
> >  freed 1512-byte region [ffff888048611338, ffff888048611920)
> >
> > The buggy address belongs to the physical page:
> > page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x48=
610
> > head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> > memcg:ffff88801d879701
> > flags: 0xfff00000000040(head|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> > page_type: 0xffffefff(slab)
> > raw: 00fff00000000040 ffff88801a824780 dead000000000122 000000000000000=
0
> > raw: 0000000000000000 0000000080130013 00000001ffffefff ffff88801d87970=
1
> > head: 00fff00000000040 ffff88801a824780 dead000000000122 00000000000000=
00
> > head: 0000000000000000 0000000080130013 00000001ffffefff ffff88801d8797=
01
> > head: 00fff00000000003 ffffea0001218401 ffffffffffffffff 00000000000000=
00
> > head: ffff888000000008 0000000000000000 00000000ffffffff 00000000000000=
00
> > page dumped because: kasan: bad access detected
> > page_owner tracks the page as allocated
> > page last allocated via order 3, migratetype Reclaimable, gfp_mask 0x1d=
2050(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_=
HARDWALL|__GFP_RECLAIMABLE), pid 5921, tgid 5920 (syz-executor.1), ts 80330=
288288, free_ts 75951829280
> >  set_page_owner include/linux/page_owner.h:32 [inline]
> >  post_alloc_hook+0x2d1/0x350 mm/page_alloc.c:1468
> >  prep_new_page mm/page_alloc.c:1476 [inline]
> >  get_page_from_freelist+0x136a/0x2e50 mm/page_alloc.c:3420
> >  __alloc_pages_noprof+0x22b/0x2460 mm/page_alloc.c:4678
> >  __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
> >  alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
> >  alloc_slab_page+0x56/0x110 mm/slub.c:2265
> >  allocate_slab mm/slub.c:2428 [inline]
> >  new_slab+0x84/0x260 mm/slub.c:2481
> >  ___slab_alloc+0xdac/0x1870 mm/slub.c:3667
> >  __slab_alloc.constprop.0+0x56/0xb0 mm/slub.c:3757
> >  __slab_alloc_node mm/slub.c:3810 [inline]
> >  slab_alloc_node mm/slub.c:3989 [inline]
> >  kmem_cache_alloc_lru_noprof+0x2a0/0x2f0 mm/slub.c:4020
> >  nilfs_alloc_inode+0x26/0x150 fs/nilfs2/super.c:154
> >  alloc_inode+0x5d/0x230 fs/inode.c:261
> >  new_inode_pseudo fs/inode.c:1007 [inline]
> >  new_inode+0x22/0x270 fs/inode.c:1033
> >  nilfs_new_inode+0xe0/0x8e0 fs/nilfs2/inode.c:336
> >  nilfs_create fs/nilfs2/namei.c:85 [inline]
> >  nilfs_create+0x121/0x320 fs/nilfs2/namei.c:75
> >  lookup_open.isra.0+0x10a1/0x13c0 fs/namei.c:3505
> >  open_last_lookups fs/namei.c:3574 [inline]
> >  path_openat+0x92f/0x29f0 fs/namei.c:3804
> >  do_filp_open+0x1dc/0x430 fs/namei.c:3834
> > page last free pid 4689 tgid 4689 stack trace:
> >  reset_page_owner include/linux/page_owner.h:25 [inline]
> >  free_pages_prepare mm/page_alloc.c:1088 [inline]
> >  free_unref_page+0x64a/0xe40 mm/page_alloc.c:2583
> >  __put_partials+0x14c/0x170 mm/slub.c:2995
> >  qlink_free mm/kasan/quarantine.c:163 [inline]
> >  qlist_free_all+0x4e/0x140 mm/kasan/quarantine.c:179
> >  kasan_quarantine_reduce+0x192/0x1e0 mm/kasan/quarantine.c:286
> >  __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:322
> >  kasan_slab_alloc include/linux/kasan.h:201 [inline]
> >  slab_post_alloc_hook mm/slub.c:3941 [inline]
> >  slab_alloc_node mm/slub.c:4001 [inline]
> >  kmem_cache_alloc_noprof+0x121/0x2f0 mm/slub.c:4008
> >  getname_flags.part.0+0x50/0x4f0 fs/namei.c:139
> >  getname_flags+0x9b/0xf0 include/linux/audit.h:322
> >  user_path_at_empty+0x2c/0x60 fs/namei.c:2928
> >  do_readlinkat+0xdd/0x310 fs/stat.c:499
> >  __do_sys_readlink fs/stat.c:532 [inline]
> >  __se_sys_readlink fs/stat.c:529 [inline]
> >  __x64_sys_readlink+0x78/0xc0 fs/stat.c:529
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Memory state around the buggy address:
> >  ffff888048611680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >  ffff888048611700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >ffff888048611780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >                                                        ^
> >  ffff888048611800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >  ffff888048611880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
> >
>
> #syz set subsystems: nilfs
>
> Although I cannot confirm this yet, it appears this is the same issue as =
below:
>
> https://syzkaller.appspot.com/bug?extid=3Dd79afb004be235636ee8
>
> If so, the following patch (the second in the series) that I just sent
> out today should fix this issue:
>
> https://lkml.kernel.org/r/20240623051135.4180-3-konishi.ryusuke@gmail.com
>
>
> Ryusuke Konishi

#syz dup: KASAN: slab-use-after-free Read in lru_add_fn

The issue doesn't seem to occur anymore after merging the above patch.
So I will close it as it's likely a common issue as expected.

Ryusuke Konishi
