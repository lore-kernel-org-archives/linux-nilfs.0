Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5D330CD82
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Mar 2026 20:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774644139; cv=none; b=iTGHYtrCWtsA76dKIXcomy94Qxc7YxTCQJrw+yECVQnk1WIadk+WPNtCjIQieMVKGVhNOvmQ1voCavoy5IRZL2pWAtBbuVr9yla3YdAvVj+tx4Zl94Q6o8kVY6LDT6C8ulKcRXA6PM+FhEp992OfnvmG4hDs65Pa8EtG2xU6H/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774644139; c=relaxed/simple;
	bh=3+zzJ5Hn0D5dgqpN433mFFiHz8tDm+vwYZdp537HmeU=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=aEzbEGRPHfVX0V0EBmvlpsfRrz+bhOGN/tcAhx/7iN7XXXbHQp16VGnpJylTGYf4Rzzu1Q9qYTniFGNNONeEUFrICX410+T3es8Q5y0CMe7IUC22WOopDuNXZamTqxMuKjSoe0Tl3kZsYIMKF23GS1z6M0pw7wqCZhwE73Ttpxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nMWP5wOa; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nMWP5wOa"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-509134ab2d2so21276131cf.0
        for <linux-nilfs@vger.kernel.org>; Fri, 27 Mar 2026 13:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774644135; x=1775248935; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Im2rAsNlGnjUJjJF6X4/hxazyMY6yvLTadXuQ+1/hVE=;
        b=nMWP5wOa7J97fksGoXa9NY3qkdgIcFvvVKcd/FCg9sBtAuGXYHsY9fQvv0anmac4Bw
         C/HCOh6wpncJEWHaCvHqxBQgnPew1mhbGTH3qqFVC5vmbWIFuMh4dWqhjAakxu58zV4m
         27pqYFybs0YuJUAHjERNrU3zc7OjiudHYbmroHeUhv0YZTVusvujFlW6hqUgDCKP+CDJ
         mlXDlNKQw+nmoFg5NjSO6mNkXnwp1GLeeZh07vyqasGHdsO9eTaCoQdocx03HbC3R/lw
         2R/c6joNYIYpzqLhFuN/2VralPPmrNZjEYVpK1LYFCOlQxGhM+D9bG8OmNCAvdtsB7m9
         3ufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774644135; x=1775248935;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Im2rAsNlGnjUJjJF6X4/hxazyMY6yvLTadXuQ+1/hVE=;
        b=sljcpPWNlGTtHuTumMoViAyb6fR1SpAbyvwX3VC9/jNDPDIkla8yqWroraPecOWv2L
         vTplfsvOwix81OXmBWdu/P60cXvVbi6dkvLOfpk/oVoKCh848wU35ZX6lFcU7cEPjg0P
         lx78EHhBmxEcsHFyL7C+5EuDlfPpYisPaXaozzcn/WO3GIJmlbVGV7yvMaiVhpdesE9Z
         tw842Lc6xNAXWk7sVTN3gQIvjYV4UP/bJqm+biZ82PBfVAHsnXyXTPsa8loeo0Yy/jOa
         8UGyecz+eFvwb7FHJnT/P0dUmGgn5Ct1w8bD62oBAsqUkwbsg8/Z5P50p0DZEsT844XF
         CXRw==
X-Gm-Message-State: AOJu0YzC0Auhb9h6Vz+iiEmHpYPIoJkofn6B+uz2RruAIrcv4v2uJX5s
	G2AxJGmaftSgta+/IM1IhKJ8oLLYbcEVLIiqcPXOVy/i9T1uToqBwOE4IJyti4VT
X-Gm-Gg: ATEYQzz7KephET+4DkD9ZZs+kv1lcQdKph9C4gEY49u+ogFSHFgwKd1QuUyW7g/tSMQ
	fQ3Np7b75tEqyZNUPD8nlky5z8hDdTiassfM0/oy5XgciLU9OL0Tlsd7aLb3324tSDQcr4jafJt
	RHdOUZr6eXshmegFq/GF0aTNy0/Gk+2VxD4YF7RpqiVkT5TJwBtk8VdUMpb04/DgLLeg9frgVUQ
	gUFU+t+jpCEXkn5StAhbPXraksF0xs3UQiC6EAmdzJML/WMn/92MSxsGXN4f+TueFghtaAFgNYQ
	2KQGgrGIEoMhWEQ49ngi7jHifH8tuBhPAM35WCJgYrNeqcv/l821LUt+f5OLorMDg16iBKpx+7K
	ohdiN6eM3+hJYq/cgNvPi82h+B5naKLTNLp3lIQmRXHLmL4HX8RxyybouR5Zoc/6J87GuLV4C7B
	iJUP1umw4wWFU3Vk6zwaldGG4LH0dX/u2LujrlYAs2fcOaRjxpgIkSMjC4jRw=
X-Received: by 2002:a05:622a:345:b0:509:f36:496d with SMTP id d75a77b69052e-50ba395d137mr51358841cf.33.1774644135101;
        Fri, 27 Mar 2026 13:42:15 -0700 (PDT)
Received: from smtpclient.apple ([104.39.146.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50bb2e11b4fsm3830911cf.23.2026.03.27.13.42.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2026 13:42:14 -0700 (PDT)
From: Shuangpeng <shuangpeng.kernel@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: [BUG] nilfs2: slab-out-of-bounds read in nilfs_direct_propagate
Message-Id: <08A3603A-ADB6-484C-9015-9AC1340E6FB8@gmail.com>
Date: Fri, 27 Mar 2026 16:42:04 -0400
Cc: slava@dubeyko.com,
 konishi.ryusuke@gmail.com
To: linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.3864.400.21)

Hi Kernel Maintainers,

I hit the following KASAN report while testing current upstream kernel:

KASAN: slab-out-of-bounds in nilfs_direct_propagate

on commit: bbeb83d3182abe0d245318e274e8531e5dd7a948 (Mar 24 2026)

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/d1df8da98f957e101dd5d580b7f82215


I=E2=80=99m happy to test debug patches or provide additional =
information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>


[   80.873778][ T8573] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   80.874653][ T8573] BUG: KASAN: slab-out-of-bounds in =
nilfs_direct_propagate (fs/nilfs2/direct.c:26 fs/nilfs2/direct.c:275)
[   80.875485][ T8573] Read of size 8 at addr ffff888178c4bd38 by task =
segctord/8573
[   80.876255][ T8573]
[   80.876511][ T8573] CPU: 1 UID: 0 PID: 8573 Comm: segctord Not =
tainted 7.0.0-rc5-00051-gbbeb83d3182a #35 PREEMPT(f
[   80.876520][ T8573] Hardware name: QEMU Standard PC (i440FX + PIIX, =
1996), BIOS 1.15.0-1 04/01/2014
[   80.876527][ T8573] Call Trace:
[   80.876531][ T8573]  <TASK>
[   80.876534][ T8573]  dump_stack_lvl (lib/dump_stack.c:122)
[   80.876544][ T8573]  print_report (mm/kasan/report.c:379 =
mm/kasan/report.c:482)
[   80.876608][ T8573]  kasan_report (mm/kasan/report.c:597)
[   80.876627][ T8573]  nilfs_direct_propagate (fs/nilfs2/direct.c:26 =
fs/nilfs2/direct.c:275)
[   80.876721][ T8573]  nilfs_bmap_propagate (fs/nilfs2/bmap.c:329)
[   80.876740][ T8573]  nilfs_segctor_apply_buffers =
(fs/nilfs2/segment.c:1010)
[   80.876752][ T8573]  nilfs_segctor_scan_file =
(fs/nilfs2/segment.c:1072)
[   80.876822][ T8573]  nilfs_segctor_do_construct =
(fs/nilfs2/segment.c:1223 fs/nilfs2/segment.c:1547 =
fs/nilfs2/segment.c:2122)
[   80.876964][ T8573]  nilfs_segctor_construct =
(fs/nilfs2/segment.c:2464)
[   80.876975][ T8573]  nilfs_segctor_thread (fs/nilfs2/segment.c:? =
fs/nilfs2/segment.c:2684)
[   80.877059][ T8573]  kthread (kernel/kthread.c:437)
[   80.877072][ T8573]  ret_from_fork (arch/x86/kernel/process.c:164)
[   80.877106][ T8573]  ret_from_fork_asm =
(arch/x86/entry/entry_64.S:255)
[   80.877118][ T8573]  </TASK>
[   80.877121][ T8573]
[   80.913570][ T8573] Allocated by task 8571 on cpu 1 at 80.799594s:
[   80.914266][ T8573]  kasan_save_track (mm/kasan/common.c:58 =
mm/kasan/common.c:78)
[   80.914762][ T8573]  __kasan_slab_alloc (mm/kasan/common.c:369)
[   80.915266][ T8573]  kmem_cache_alloc_lru_noprof =
(./include/linux/kasan.h:253 mm/slub.c:4538 mm/slub.c:4866 =
mm/slub.c:4885)
[   80.915870][ T8573]  nilfs_alloc_inode (fs/nilfs2/super.c:159)
[   80.916370][ T8573]  alloc_inode (fs/inode.c:?)
[   80.916825][ T8573]  iget5_locked (fs/inode.c:1390)
[   80.917312][ T8573]  nilfs_iget (fs/nilfs2/inode.c:562)
[   80.917775][ T8573]  nilfs_get_root_dentry (fs/nilfs2/super.c:915)
[   80.918328][ T8573]  nilfs_fill_super (fs/nilfs2/super.c:1099)
[   80.918837][ T8573]  nilfs_get_tree (fs/nilfs2/super.c:1229)
[   80.919328][ T8573]  vfs_get_tree (fs/super.c:1754)
[   80.919791][ T8573]  do_new_mount (fs/namespace.c:1194 =
fs/namespace.c:3763 fs/namespace.c:3839)
[   80.920264][ T8573]  __se_sys_mount (fs/namespace.c:4172 =
fs/namespace.c:4361 fs/namespace.c:4338)
[   80.920754][ T8573]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
[   80.921228][ T8573]  entry_SYSCALL_64_after_hwframe =
(arch/x86/entry/entry_64.S:130)
[   80.921870][ T8573]
[   80.922121][ T8573] The buggy address belongs to the object at =
ffff888178c4b930
[   80.922121][ T8573]  which belongs to the cache nilfs2_inode_cache of =
size 848
[   80.923593][ T8573] The buggy address is located 184 bytes to the =
right of
[   80.923593][ T8573]  allocated 848-byte region [ffff888178c4b930, =
ffff888178c4bc80)
[   80.925065][ T8573]
[   80.925315][ T8573] The buggy address belongs to the physical page:
[   80.926011][ T8573] page: refcount:0 mapcount:0 =
mapping:0000000000000000 index:0x0 pfn:0x178c48
[   80.926913][ T8573] head: order:2 mapcount:0 entire_mapcount:0 =
nr_pages_mapped:0 pincount:0
[   80.927770][ T8573] memcg:ffff888178c4bd01
[   80.928208][ T8573] flags: =
0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
[   80.928994][ T8573] page_type: f5(slab)
[   80.929411][ T8573] raw: 017ff00000000040 ffff88810dab5c80 =
dead000000000100 dead000000000122
[   80.930318][ T8573] raw: 0000000000000000 0000000800100010 =
00000000f5000000 ffff888178c4bd01
[   80.931195][ T8573] head: 017ff00000000040 ffff88810dab5c80 =
dead000000000100 dead000000000122
[   80.932076][ T8573] head: 0000000000000000 0000000800100010 =
00000000f5000000 ffff888178c4bd01
[   80.932957][ T8573] head: 017ff00000000002 ffffea0005e31201 =
00000000ffffffff 00000000ffffffff
[   80.933864][ T8573] head: ffffffffffffffff 0000000000000000 =
00000000ffffffff 0000000000000004
[   80.934742][ T8573] page dumped because: kasan: bad access detected
[   80.935400][ T8573] page_owner tracks the page as allocated
[   80.935991][ T8573] page last allocated via order 2, migratetype =
Reclaimable, gfp_mask 0xd2050(__GFP_RECLAIMABLE|_9
[   80.938243][ T8573]  post_alloc_hook (./include/linux/page_owner.h:? =
mm/page_alloc.c:1889)
[   80.938742][ T8573]  get_page_from_freelist (mm/page_alloc.c:? =
mm/page_alloc.c:3962)
[   80.939318][ T8573]  __alloc_frozen_pages_noprof =
(mm/page_alloc.c:5250)
[   80.939923][ T8573]  allocate_slab (mm/slub.c:3294 mm/slub.c:3481)
[   80.940398][ T8573]  refill_objects (mm/slub.c:7176)
[   80.940889][ T8573]  __pcs_replace_empty_main (mm/slub.c:2815 =
mm/slub.c:2834 mm/slub.c:4626)
[   80.941462][ T8573]  kmem_cache_alloc_lru_noprof (mm/slub.c:4718 =
mm/slub.c:4851 mm/slub.c:4885)
[   80.942092][ T8573]  nilfs_alloc_inode (fs/nilfs2/super.c:159)
[   80.942592][ T8573]  alloc_inode (fs/inode.c:?)
[   80.943045][ T8573]  iget5_locked (fs/inode.c:1390)
[   80.943502][ T8573]  nilfs_attach_btree_node_cache =
(fs/nilfs2/inode.c:632)
[   80.944120][ T8573]  nilfs_btree_convert_and_insert =
(fs/nilfs2/btree.c:1762 fs/nilfs2/btree.c:1902)
[   80.944749][ T8573]  nilfs_bmap_insert (fs/nilfs2/bmap.c:118 =
fs/nilfs2/bmap.c:149)
[   80.945263][ T8573]  nilfs_mdt_get_block (fs/nilfs2/mdt.c:46 =
fs/nilfs2/mdt.c:95 fs/nilfs2/mdt.c:258)
[   80.945821][ T8573]  nilfs_cpfile_create_checkpoint =
(fs/nilfs2/cpfile.c:? fs/nilfs2/cpfile.c:330)
[   80.946451][ T8573]  nilfs_segctor_do_construct =
(fs/nilfs2/segment.c:1250 fs/nilfs2/segment.c:1547 =
fs/nilfs2/segment.c:2122)
[   80.947065][ T8573] page last free pid 1 tgid 1 stack trace:
[   80.947665][ T8573]  __free_frozen_pages =
(./include/linux/page_owner.h:? mm/page_alloc.c:1433 =
mm/page_alloc.c:2978)
[   80.948197][ T8573]  free_contig_range (mm/page_alloc.c:7373)
[   80.948699][ T8573]  destroy_args (mm/debug_vm_pgtable.c:995)
[   80.949174][ T8573]  debug_vm_pgtable (mm/debug_vm_pgtable.c:?)
[   80.949695][ T8573]  do_one_initcall (init/main.c:?)
[   80.950213][ T8573]  do_initcall_level (init/main.c:1443)
[   80.950721][ T8573]  do_initcalls (init/main.c:1457)
[   80.951173][ T8573]  kernel_init_freeable (init/main.c:1696)
[   80.951714][ T8573]  kernel_init (init/main.c:1584)
[   80.952167][ T8573]  ret_from_fork (arch/x86/kernel/process.c:164)
[   80.952651][ T8573]  ret_from_fork_asm =
(arch/x86/entry/entry_64.S:255)
[   80.953151][ T8573]
[   80.953400][ T8573] Memory state around the buggy address:
[   80.954002][ T8573]  ffff888178c4bc00: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00
[   80.954819][ T8573]  ffff888178c4bc80: fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc
[   80.955641][ T8573] >ffff888178c4bd00: fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc
[   80.956460][ T8573]                                         ^
[   80.957067][ T8573]  ffff888178c4bd80: fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc
[   80.957917][ T8573]  ffff888178c4be00: fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc
[   80.958920][ T8541] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Best,
Shuangpeng

