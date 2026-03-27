Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7879C3815E6
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Mar 2026 20:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774644994; cv=none; b=ilz8s7z9mTSMD1QdD6RizJk6vv77yH8/ok6GbascXoordIdm+D20fMOtyGdvHFfjq4InOudWDOBHEKteh+IIiuauY0XxsxBxeAldL/qS/QDsXbp7ZPraHM0Jlbqv6BVrj1hMUO1yTK6+u/frvD+DG5TkO2I6kVshoNLACqGXSZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774644994; c=relaxed/simple;
	bh=jvDRuLj86bmcJjwRJUzvwitsNOjN1jw2bJIx0bQPSTQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Ea2j16tRbZYIR3CFy+uCpgPINzcKT/bPfkl7C8IWBhgxX+Hptfq/SLj8O9LLJtPwz6I51e4E9mIqiAtgpbHqWvlkDaxA2Ny0cUTcBfxjNCUa+OHcG/B7ZqPJ4RZm2GhVrx1bSFsIlDYtH4REUoG/rRQw+rEpHa5G24AcUs5m4Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mLw8q0bI; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mLw8q0bI"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-89a05955720so30158186d6.2
        for <linux-nilfs@vger.kernel.org>; Fri, 27 Mar 2026 13:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774644991; x=1775249791; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=msiaPwMBa082NBMVa6riGn6R5/IAV25zTcAwcXTf8d4=;
        b=mLw8q0bIJm2ehJBXQ4TiGI/1mpOzD/kRl50Ew0uduAGAISOWgODnza5mGew6W4SMUW
         j7+ltxkG6GtrKGa91RLIAq3VE6vx8oRD+G4T8gJeYOcK5U20j58hxzpqRLk7rpyYOhbp
         3iD3CS7q2RI64ezxOkVQSR9lXfUUcQ4jHD0sgTqq1hONym54lLRXvHes6V1/MB0Un6QB
         ogYLNB9+C0gq948XxaUESAd+Xe2DKfoQskA0+ikljPfcovrIZoefYxZQEwGDSzYfVyQm
         6D8PvDdsGkfnchQuOOQ6SdtUSE6aWEZQK4fCZMBLeBaXljVOGlQ6+0Og3GEKWBOBrCZd
         dOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774644991; x=1775249791;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=msiaPwMBa082NBMVa6riGn6R5/IAV25zTcAwcXTf8d4=;
        b=JkcigJXp5Y+UlMsvTlfqafkTnluYhBooFrXVftEFfAEImmY+/ygJCnEx/Fp0sxhR9Y
         kc1EUCJeForZze4yHrky5lMaLubI5cFGdF3wTXhieypUb2YYOEv8hgdAI/x/NEnLU6YF
         IbM6HqvRjPV61GLAanSLRCw/yPNNQp38UmfYDfh1F40++14lF5aNn48rCzQT2K2nsi2z
         4R81PEWUXGuY0lMA3kikjOv47F7yaRLanZlo8J9F2S1K1D6GwPmVg26A5WXgtakXVWWW
         5uA4xW89RUic40Jq9S7q9Aj06C6DMCqvbZrS05xpq4R0Z9AGey+9NR1SfKTn4C6WPBle
         7VDw==
X-Gm-Message-State: AOJu0Yzovyd8TteXqUmTia5BVbq1C2KrKZG/5DSGnZIO9gX5qgX5LkFf
	lUy05SDmNJY2CvWuUOfVydAC15NDkA/Sc/Y4Pc7vRb+dXTEcy7fFv4IE
X-Gm-Gg: ATEYQzwAxvHjBVvqEZ/mE5U1+dK4VpGpXv7/jKk2ZIgBtsqqvqHdzBagWUNXrIXBpeY
	1htJD/O1SGKj2O2Rj0BzBTCRGFsyfRTZ9W7G1Vk5Np4tE9g+uFjD0eCNHWUxWoBCUSjGhD9/Pcq
	eCxa4qpfk1KalhuRcyxe+Ruz3gLDuGfxtxTfsv3qNXsCerhiR0BOJiV98H7vclI7/xJd7qYoCqr
	pt9kKq0CncjnYeH1KbWYGijcsQjbgclIu6dKw6cJofxYr+Tw4VjCo4+4IP/FO6u0q20njJgG5Ln
	tufnMI4NjA3Ap22qXyppnegdehrgEyscmdKJtW0ctsOy0Udu/V9nA+xbtMuQSSmqsVjCgq6qZir
	m3kTXwYhQ4IGQYjiMtkrnpxmGwe2JSPuXPcPkCQ/U41+w19XajMI5g/2aSI/zx+HF16Yi/NgHRi
	U9c+avu+iJjtyWkSIs8IHXt1zD+mCShnGvItzSfLlpXJJtMGldLTd1mjCkJ1xh0kJL
X-Received: by 2002:a0c:f109:0:b0:89c:e726:8388 with SMTP id 6a1803df08f44-89ce8f35f78mr53657856d6.54.1774644991180;
        Fri, 27 Mar 2026 13:56:31 -0700 (PDT)
Received: from smtpclient.apple ([104.39.146.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf862cdfsm1659686d6.33.2026.03.27.13.56.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2026 13:56:30 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [BUG] nilfs2: slab-out-of-bounds read in nilfs_direct_propagate
From: Shuangpeng <shuangpeng.kernel@gmail.com>
In-Reply-To: <20daa05c9edd209798f64bb0b093c8fe35c0d2b0.camel@redhat.com>
Date: Fri, 27 Mar 2026 16:56:20 -0400
Cc: linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 slava@dubeyko.com,
 konishi.ryusuke@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <9F816FED-9966-4702-8A48-0F3F247A6B2B@gmail.com>
References: <08A3603A-ADB6-484C-9015-9AC1340E6FB8@gmail.com>
 <20daa05c9edd209798f64bb0b093c8fe35c0d2b0.camel@redhat.com>
To: Viacheslav Dubeyko <vdubeyko@redhat.com>
X-Mailer: Apple Mail (2.3864.400.21)



> On Mar 27, 2026, at 16:48, Viacheslav Dubeyko <vdubeyko@redhat.com> =
wrote:
>=20
> Hi Shuangpeng,
>=20
> On Fri, 2026-03-27 at 16:42 -0400, Shuangpeng wrote:
>> Hi Kernel Maintainers,
>>=20
>> I hit the following KASAN report while testing current upstream =
kernel:
>>=20
>> KASAN: slab-out-of-bounds in nilfs_direct_propagate
>>=20
>> on commit: bbeb83d3182abe0d245318e274e8531e5dd7a948 (Mar 24 2026)
>>=20
>> The reproducer and .config files are here.
>> =
https://gist.github.com/shuangpengbai/d1df8da98f957e101dd5d580b7f82215
>>=20
>>=20
>> I=E2=80=99m happy to test debug patches or provide additional =
information.
>>=20
>> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>>=20
>>=20
>> [   80.873778][ T8573] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [   80.874653][ T8573] BUG: KASAN: slab-out-of-bounds in =
nilfs_direct_propagate (fs/nilfs2/direct.c:26 fs/nilfs2/direct.c:275)
>> [   80.875485][ T8573] Read of size 8 at addr ffff888178c4bd38 by =
task segctord/8573
>> [   80.876255][ T8573]
>> [   80.876511][ T8573] CPU: 1 UID: 0 PID: 8573 Comm: segctord Not =
tainted 7.0.0-rc5-00051-gbbeb83d3182a #35 PREEMPT(f
>> [   80.876520][ T8573] Hardware name: QEMU Standard PC (i440FX + =
PIIX, 1996), BIOS 1.15.0-1 04/01/2014
>> [   80.876527][ T8573] Call Trace:
>> [   80.876531][ T8573]  <TASK>
>> [   80.876534][ T8573]  dump_stack_lvl (lib/dump_stack.c:122)
>> [   80.876544][ T8573]  print_report (mm/kasan/report.c:379 =
mm/kasan/report.c:482)
>> [   80.876608][ T8573]  kasan_report (mm/kasan/report.c:597)
>> [   80.876627][ T8573]  nilfs_direct_propagate (fs/nilfs2/direct.c:26 =
fs/nilfs2/direct.c:275)
>> [   80.876721][ T8573]  nilfs_bmap_propagate (fs/nilfs2/bmap.c:329)
>> [   80.876740][ T8573]  nilfs_segctor_apply_buffers =
(fs/nilfs2/segment.c:1010)
>> [   80.876752][ T8573]  nilfs_segctor_scan_file =
(fs/nilfs2/segment.c:1072)
>> [   80.876822][ T8573]  nilfs_segctor_do_construct =
(fs/nilfs2/segment.c:1223 fs/nilfs2/segment.c:1547 =
fs/nilfs2/segment.c:2122)
>> [   80.876964][ T8573]  nilfs_segctor_construct =
(fs/nilfs2/segment.c:2464)
>> [   80.876975][ T8573]  nilfs_segctor_thread (fs/nilfs2/segment.c:? =
fs/nilfs2/segment.c:2684)
>> [   80.877059][ T8573]  kthread (kernel/kthread.c:437)
>> [   80.877072][ T8573]  ret_from_fork (arch/x86/kernel/process.c:164)
>> [   80.877106][ T8573]  ret_from_fork_asm =
(arch/x86/entry/entry_64.S:255)
>> [   80.877118][ T8573]  </TASK>
>> [   80.877121][ T8573]
>> [   80.913570][ T8573] Allocated by task 8571 on cpu 1 at 80.799594s:
>> [   80.914266][ T8573]  kasan_save_track (mm/kasan/common.c:58 =
mm/kasan/common.c:78)
>> [   80.914762][ T8573]  __kasan_slab_alloc (mm/kasan/common.c:369)
>> [   80.915266][ T8573]  kmem_cache_alloc_lru_noprof =
(./include/linux/kasan.h:253 mm/slub.c:4538 mm/slub.c:4866 =
mm/slub.c:4885)
>> [   80.915870][ T8573]  nilfs_alloc_inode (fs/nilfs2/super.c:159)
>> [   80.916370][ T8573]  alloc_inode (fs/inode.c:?)
>> [   80.916825][ T8573]  iget5_locked (fs/inode.c:1390)
>> [   80.917312][ T8573]  nilfs_iget (fs/nilfs2/inode.c:562)
>> [   80.917775][ T8573]  nilfs_get_root_dentry (fs/nilfs2/super.c:915)
>> [   80.918328][ T8573]  nilfs_fill_super (fs/nilfs2/super.c:1099)
>> [   80.918837][ T8573]  nilfs_get_tree (fs/nilfs2/super.c:1229)
>> [   80.919328][ T8573]  vfs_get_tree (fs/super.c:1754)
>> [   80.919791][ T8573]  do_new_mount (fs/namespace.c:1194 =
fs/namespace.c:3763 fs/namespace.c:3839)
>> [   80.920264][ T8573]  __se_sys_mount (fs/namespace.c:4172 =
fs/namespace.c:4361 fs/namespace.c:4338)
>> [   80.920754][ T8573]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
>> [   80.921228][ T8573]  entry_SYSCALL_64_after_hwframe =
(arch/x86/entry/entry_64.S:130)
>> [   80.921870][ T8573]
>> [   80.922121][ T8573] The buggy address belongs to the object at =
ffff888178c4b930
>> [   80.922121][ T8573]  which belongs to the cache nilfs2_inode_cache =
of size 848
>> [   80.923593][ T8573] The buggy address is located 184 bytes to the =
right of
>> [   80.923593][ T8573]  allocated 848-byte region [ffff888178c4b930, =
ffff888178c4bc80)
>> [   80.925065][ T8573]
>> [   80.925315][ T8573] The buggy address belongs to the physical =
page:
>> [   80.926011][ T8573] page: refcount:0 mapcount:0 =
mapping:0000000000000000 index:0x0 pfn:0x178c48
>> [   80.926913][ T8573] head: order:2 mapcount:0 entire_mapcount:0 =
nr_pages_mapped:0 pincount:0
>> [   80.927770][ T8573] memcg:ffff888178c4bd01
>> [   80.928208][ T8573] flags: =
0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
>> [   80.928994][ T8573] page_type: f5(slab)
>> [   80.929411][ T8573] raw: 017ff00000000040 ffff88810dab5c80 =
dead000000000100 dead000000000122
>> [   80.930318][ T8573] raw: 0000000000000000 0000000800100010 =
00000000f5000000 ffff888178c4bd01
>> [   80.931195][ T8573] head: 017ff00000000040 ffff88810dab5c80 =
dead000000000100 dead000000000122
>> [   80.932076][ T8573] head: 0000000000000000 0000000800100010 =
00000000f5000000 ffff888178c4bd01
>> [   80.932957][ T8573] head: 017ff00000000002 ffffea0005e31201 =
00000000ffffffff 00000000ffffffff
>> [   80.933864][ T8573] head: ffffffffffffffff 0000000000000000 =
00000000ffffffff 0000000000000004
>> [   80.934742][ T8573] page dumped because: kasan: bad access =
detected
>> [   80.935400][ T8573] page_owner tracks the page as allocated
>> [   80.935991][ T8573] page last allocated via order 2, migratetype =
Reclaimable, gfp_mask 0xd2050(__GFP_RECLAIMABLE|_9
>> [   80.938243][ T8573]  post_alloc_hook =
(./include/linux/page_owner.h:? mm/page_alloc.c:1889)
>> [   80.938742][ T8573]  get_page_from_freelist (mm/page_alloc.c:? =
mm/page_alloc.c:3962)
>> [   80.939318][ T8573]  __alloc_frozen_pages_noprof =
(mm/page_alloc.c:5250)
>> [   80.939923][ T8573]  allocate_slab (mm/slub.c:3294 mm/slub.c:3481)
>> [   80.940398][ T8573]  refill_objects (mm/slub.c:7176)
>> [   80.940889][ T8573]  __pcs_replace_empty_main (mm/slub.c:2815 =
mm/slub.c:2834 mm/slub.c:4626)
>> [   80.941462][ T8573]  kmem_cache_alloc_lru_noprof (mm/slub.c:4718 =
mm/slub.c:4851 mm/slub.c:4885)
>> [   80.942092][ T8573]  nilfs_alloc_inode (fs/nilfs2/super.c:159)
>> [   80.942592][ T8573]  alloc_inode (fs/inode.c:?)
>> [   80.943045][ T8573]  iget5_locked (fs/inode.c:1390)
>> [   80.943502][ T8573]  nilfs_attach_btree_node_cache =
(fs/nilfs2/inode.c:632)
>> [   80.944120][ T8573]  nilfs_btree_convert_and_insert =
(fs/nilfs2/btree.c:1762 fs/nilfs2/btree.c:1902)
>> [   80.944749][ T8573]  nilfs_bmap_insert (fs/nilfs2/bmap.c:118 =
fs/nilfs2/bmap.c:149)
>> [   80.945263][ T8573]  nilfs_mdt_get_block (fs/nilfs2/mdt.c:46 =
fs/nilfs2/mdt.c:95 fs/nilfs2/mdt.c:258)
>> [   80.945821][ T8573]  nilfs_cpfile_create_checkpoint =
(fs/nilfs2/cpfile.c:? fs/nilfs2/cpfile.c:330)
>> [   80.946451][ T8573]  nilfs_segctor_do_construct =
(fs/nilfs2/segment.c:1250 fs/nilfs2/segment.c:1547 =
fs/nilfs2/segment.c:2122)
>> [   80.947065][ T8573] page last free pid 1 tgid 1 stack trace:
>> [  80.947665][ T8573]  __free_frozen_pages =
(./include/linux/page_owner.h:? mm/page_alloc.c:1433 =
mm/page_alloc.c:2978)
>> [   80.948197][ T8573]  free_contig_range (mm/page_alloc.c:7373)
>> [   80.948699][ T8573]  destroy_args (mm/debug_vm_pgtable.c:995)
>> [   80.949174][ T8573]  debug_vm_pgtable (mm/debug_vm_pgtable.c:?)
>> [   80.949695][ T8573]  do_one_initcall (init/main.c:?)
>> [   80.950213][ T8573]  do_initcall_level (init/main.c:1443)
>> [   80.950721][ T8573]  do_initcalls (init/main.c:1457)
>> [   80.951173][ T8573]  kernel_init_freeable (init/main.c:1696)
>> [   80.951714][ T8573]  kernel_init (init/main.c:1584)
>> [   80.952167][ T8573]  ret_from_fork (arch/x86/kernel/process.c:164)
>> [   80.952651][ T8573]  ret_from_fork_asm =
(arch/x86/entry/entry_64.S:255)
>> [   80.953151][ T8573]
>> [   80.953400][ T8573] Memory state around the buggy address:
>> [   80.954002][ T8573]  ffff888178c4bc00: 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00
>> [   80.954819][ T8573]  ffff888178c4bc80: fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc
>> [   80.955641][ T8573] >ffff888178c4bd00: fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc
>> [   80.956460][ T8573]                                         ^
>> [   80.957067][ T8573]  ffff888178c4bd80: fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc
>> [   80.957917][ T8573]  ffff888178c4be00: fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc
>> [   80.958920][ T8541] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>=20
> Thank you for the report. Could you please create an issue here [1]?
>=20

I created an issue here: https://github.com/nilfs-dev/nilfs2/issues/168

Please let me know if there is anything that I can help. Thank you!

> Thanks,
> Slava.
>=20
> [1] https://github.com/nilfs-dev/nilfs2/issues
>=20

