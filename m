Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280F836B04B
	for <linux-nilfs@vger.kernel.org>; Fri, 27 Mar 2026 20:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774644522; cv=none; b=GzbpOuOAinhX15Z6KuOCAoj6XdVd/cuCgyVUVIzUQ/m+xzGus23JkzgWUdFeth+Ii2UWCzfq7x2i2aQHyVf/PdjY1QPvKbdiLjrrC51uCNFIZh6vc4vnW1AaTPtCToaS2LFiBG9u/sQFBTLAzIk8JYNFCyQDgBIaFqnP5kqPB0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774644522; c=relaxed/simple;
	bh=wBtzNLSwAI+k32c2NitafJMbXYq145tpDNi29AHdnXs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h6Tpo9NUb80aL5eN10mb97bN5PWP2EH9mrCS8cvO/+CTZ2EXcdg4CmS/9Wh6rSDiJ0hzQhENx7nexkG/9VHsgKcxa4yc7vFhve+Kw+I9ngcsWmXhPNaTUSGh0ZTfHZZpbVJqqPZy5fp1ybfDsV358SEeP0hNMi1E3zwg5mp28gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H2W+46G1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eykfMWwp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H2W+46G1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eykfMWwp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774644520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aTMBfsIT13rPhxEWQmmRNK2Vdt69GhmHv3BVvCdGZDk=;
	b=H2W+46G1LDgMraWWzjco/g/glrDNVFbKHS0Lzut6Uy5DCIknvCDeznipVhlJXB95RoauZo
	WTMmoMY5KL8nNTdgVk4EdXGAe1Rq7vGSeBeSUlnhFdfafHLXhsDZ8LjR67CRvHk2q0XnFG
	YhFgQud2N/MvjMmZ9Uy3T5KfB60FiIY=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-vUusUb_FMLKoZb9FuHrQnQ-1; Fri, 27 Mar 2026 16:48:38 -0400
X-MC-Unique: vUusUb_FMLKoZb9FuHrQnQ-1
X-Mimecast-MFC-AGG-ID: vUusUb_FMLKoZb9FuHrQnQ_1774644518
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-64eec61a0c2so5331195d50.1
        for <linux-nilfs@vger.kernel.org>; Fri, 27 Mar 2026 13:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774644518; x=1775249318; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aTMBfsIT13rPhxEWQmmRNK2Vdt69GhmHv3BVvCdGZDk=;
        b=eykfMWwpoYEzXOGhNKcJCj/mK87o5x8JZ4++ixv5AxhAd/ECjimkH7cqgVLLdM+xKd
         KgEPMTD9bZBk9ubpgyHeozHQJo7EQPH8xdfwhwGE1xcXVeNG3XxCE39LWJqyy2w6JHE9
         XpS43tu8OGJJIT4d3TulXDgqt/bUmAlujEQS6p1Y+TsK4ZBvCWo4GDedHb0XlSf2f5Bh
         uYc7LQBBzVTGr/AO0ewwUcaaqv4WVOetrwrbejXxDbv1OgCsUWj0ncMideGp5JkOO7wk
         /NIs3OxDMtle0pR8Ppo70eUCBrL+s1Q7zp8GYJC6jn6LfPRrUen4RNDcYsHvQSVzlVXp
         8qnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774644518; x=1775249318;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aTMBfsIT13rPhxEWQmmRNK2Vdt69GhmHv3BVvCdGZDk=;
        b=W37c/wibRr+icY8guPsXgbt9o3kxdFx0HVvfg1gHtNvrvd+Blx6/bdl0iMGp6SLD83
         xBO3ZxXvhu2CWXL5x5X7H6Vrl6h3jMNZWHMllkpgk7ofJwiYxfU86/Wv+bvadapLUEdL
         8Adl0VaJOArou4F9tNjsV3qnBGIvFPP0PU2VKmrzksKhcEat72Ui8mNe1Udy1TyTyHzK
         gWIDm5alE6nzAJPHqWJgw2J6/61Wi/cE+SV0yv0M1MuULX7idFYGy5m13ruBbEhkXaqp
         tV+sC+y9/OuZWJhhOzuBaUFOZ4nH3nWc6Eo1UxZ6uhp8rFaHW4gKnLapclwERjp9VsaW
         g1bw==
X-Forwarded-Encrypted: i=1; AJvYcCW6TwoIS/IGj1GgCrXnS1TS7Uyg4e4BNt1/2qfOymBq5oWvXvOF9X/6j6wnwqVwvwOxLKWM6bfyBvdqNw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFDTcdAuVycN5dlrLA+OHG/1pVqa1h1gXT6wn/cKFWGtWjlfL3
	Qx7mm1qTquUFwqYMwcLFviGlgy3pG7blYkeVbsAKt8w+FaeOEZ136FZ8m/SYMMKSGoC1JmU8nme
	lzuFFLyOhtgvgchUVIXfWa8I0fycITZDwR7ZW+7Cz0brR/1VS1bp9egNcnKky8rOR
X-Gm-Gg: ATEYQzwJyAkJyfsnqyRuZDZrJExWc8hawXPEwnpQOndarcvq9ylEoxdjshZiB4riLtX
	p+10MVI1y4H8vkaJwBpfumLf7Gjhl4P3RyGFaljsysZZfU+70DCqy4+zTy3MLPGcgD5bIcBWE4N
	Lpyg/CWSdC0axuflUlPu/NSD5Ab2uSbmHuLZ4DkHofFHjfRz34DtH/RhuqaxifROaEKtZPi9Euf
	dGf25WrXmaYMC4l2mWK55NNtGf7Sk6wpyrYsMwjGkbgBw/Keo5YIrBVW1a0MnF4Y9m8n47CBPsl
	Dz96IMm3oQrKFNNoEVw24rx4TMZEzKffUo50Sgr9kipoBn31wQbeHFhQh3Q3o5XknxFq+VMoNQj
	5I17XPYkfa/JTrIrJXXRGbeylMy8CovyVc7D7dHYhgHo/h18Samxj
X-Received: by 2002:a05:690c:e572:b0:79c:875c:c925 with SMTP id 00721157ae682-79c875cd80bmr7907687b3.47.1774644518121;
        Fri, 27 Mar 2026 13:48:38 -0700 (PDT)
X-Received: by 2002:a05:690c:e572:b0:79c:875c:c925 with SMTP id 00721157ae682-79c875cd80bmr7907407b3.47.1774644517673;
        Fri, 27 Mar 2026 13:48:37 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79cb7135c51sm726147b3.7.2026.03.27.13.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 13:48:37 -0700 (PDT)
Message-ID: <20daa05c9edd209798f64bb0b093c8fe35c0d2b0.camel@redhat.com>
Subject: Re: [BUG] nilfs2: slab-out-of-bounds read in nilfs_direct_propagate
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: Shuangpeng <shuangpeng.kernel@gmail.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: slava@dubeyko.com, konishi.ryusuke@gmail.com
Date: Fri, 27 Mar 2026 13:48:35 -0700
In-Reply-To: <08A3603A-ADB6-484C-9015-9AC1340E6FB8@gmail.com>
References: <08A3603A-ADB6-484C-9015-9AC1340E6FB8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43app2) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Shuangpeng,

On Fri, 2026-03-27 at 16:42 -0400, Shuangpeng wrote:
> Hi Kernel Maintainers,
>=20
> I hit the following KASAN report while testing current upstream kernel:
>=20
> KASAN: slab-out-of-bounds in nilfs_direct_propagate
>=20
> on commit: bbeb83d3182abe0d245318e274e8531e5dd7a948 (Mar 24 2026)
>=20
> The reproducer and .config files are here.
> https://gist.github.com/shuangpengbai/d1df8da98f957e101dd5d580b7f82215
>=20
>=20
> I=E2=80=99m happy to test debug patches or provide additional information=
.
>=20
> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>=20
>=20
> [   80.873778][ T8573] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   80.874653][ T8573] BUG: KASAN: slab-out-of-bounds in nilfs_direct_pro=
pagate (fs/nilfs2/direct.c:26 fs/nilfs2/direct.c:275)
> [   80.875485][ T8573] Read of size 8 at addr ffff888178c4bd38 by task se=
gctord/8573
> [   80.876255][ T8573]
> [   80.876511][ T8573] CPU: 1 UID: 0 PID: 8573 Comm: segctord Not tainted=
 7.0.0-rc5-00051-gbbeb83d3182a #35 PREEMPT(f
> [   80.876520][ T8573] Hardware name: QEMU Standard PC (i440FX + PIIX, 19=
96), BIOS 1.15.0-1 04/01/2014
> [   80.876527][ T8573] Call Trace:
> [   80.876531][ T8573]  <TASK>
> [   80.876534][ T8573]  dump_stack_lvl (lib/dump_stack.c:122)
> [   80.876544][ T8573]  print_report (mm/kasan/report.c:379 mm/kasan/repo=
rt.c:482)
> [   80.876608][ T8573]  kasan_report (mm/kasan/report.c:597)
> [   80.876627][ T8573]  nilfs_direct_propagate (fs/nilfs2/direct.c:26 fs/=
nilfs2/direct.c:275)
> [   80.876721][ T8573]  nilfs_bmap_propagate (fs/nilfs2/bmap.c:329)
> [   80.876740][ T8573]  nilfs_segctor_apply_buffers (fs/nilfs2/segment.c:=
1010)
> [   80.876752][ T8573]  nilfs_segctor_scan_file (fs/nilfs2/segment.c:1072=
)
> [   80.876822][ T8573]  nilfs_segctor_do_construct (fs/nilfs2/segment.c:1=
223 fs/nilfs2/segment.c:1547 fs/nilfs2/segment.c:2122)
> [   80.876964][ T8573]  nilfs_segctor_construct (fs/nilfs2/segment.c:2464=
)
> [   80.876975][ T8573]  nilfs_segctor_thread (fs/nilfs2/segment.c:? fs/ni=
lfs2/segment.c:2684)
> [   80.877059][ T8573]  kthread (kernel/kthread.c:437)
> [   80.877072][ T8573]  ret_from_fork (arch/x86/kernel/process.c:164)
> [   80.877106][ T8573]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> [   80.877118][ T8573]  </TASK>
> [   80.877121][ T8573]
> [   80.913570][ T8573] Allocated by task 8571 on cpu 1 at 80.799594s:
> [   80.914266][ T8573]  kasan_save_track (mm/kasan/common.c:58 mm/kasan/c=
ommon.c:78)
> [   80.914762][ T8573]  __kasan_slab_alloc (mm/kasan/common.c:369)
> [   80.915266][ T8573]  kmem_cache_alloc_lru_noprof (./include/linux/kasa=
n.h:253 mm/slub.c:4538 mm/slub.c:4866 mm/slub.c:4885)
> [   80.915870][ T8573]  nilfs_alloc_inode (fs/nilfs2/super.c:159)
> [   80.916370][ T8573]  alloc_inode (fs/inode.c:?)
> [   80.916825][ T8573]  iget5_locked (fs/inode.c:1390)
> [   80.917312][ T8573]  nilfs_iget (fs/nilfs2/inode.c:562)
> [   80.917775][ T8573]  nilfs_get_root_dentry (fs/nilfs2/super.c:915)
> [   80.918328][ T8573]  nilfs_fill_super (fs/nilfs2/super.c:1099)
> [   80.918837][ T8573]  nilfs_get_tree (fs/nilfs2/super.c:1229)
> [   80.919328][ T8573]  vfs_get_tree (fs/super.c:1754)
> [   80.919791][ T8573]  do_new_mount (fs/namespace.c:1194 fs/namespace.c:=
3763 fs/namespace.c:3839)
> [   80.920264][ T8573]  __se_sys_mount (fs/namespace.c:4172 fs/namespace.=
c:4361 fs/namespace.c:4338)
> [   80.920754][ T8573]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
> [   80.921228][ T8573]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/en=
try_64.S:130)
> [   80.921870][ T8573]
> [   80.922121][ T8573] The buggy address belongs to the object at ffff888=
178c4b930
> [   80.922121][ T8573]  which belongs to the cache nilfs2_inode_cache of =
size 848
> [   80.923593][ T8573] The buggy address is located 184 bytes to the righ=
t of
> [   80.923593][ T8573]  allocated 848-byte region [ffff888178c4b930, ffff=
888178c4bc80)
> [   80.925065][ T8573]
> [   80.925315][ T8573] The buggy address belongs to the physical page:
> [   80.926011][ T8573] page: refcount:0 mapcount:0 mapping:00000000000000=
00 index:0x0 pfn:0x178c48
> [   80.926913][ T8573] head: order:2 mapcount:0 entire_mapcount:0 nr_page=
s_mapped:0 pincount:0
> [   80.927770][ T8573] memcg:ffff888178c4bd01
> [   80.928208][ T8573] flags: 0x17ff00000000040(head|node=3D0|zone=3D2|la=
stcpupid=3D0x7ff)
> [   80.928994][ T8573] page_type: f5(slab)
> [   80.929411][ T8573] raw: 017ff00000000040 ffff88810dab5c80 dead0000000=
00100 dead000000000122
> [   80.930318][ T8573] raw: 0000000000000000 0000000800100010 00000000f50=
00000 ffff888178c4bd01
> [   80.931195][ T8573] head: 017ff00000000040 ffff88810dab5c80 dead000000=
000100 dead000000000122
> [   80.932076][ T8573] head: 0000000000000000 0000000800100010 00000000f5=
000000 ffff888178c4bd01
> [   80.932957][ T8573] head: 017ff00000000002 ffffea0005e31201 00000000ff=
ffffff 00000000ffffffff
> [   80.933864][ T8573] head: ffffffffffffffff 0000000000000000 00000000ff=
ffffff 0000000000000004
> [   80.934742][ T8573] page dumped because: kasan: bad access detected
> [   80.935400][ T8573] page_owner tracks the page as allocated
> [   80.935991][ T8573] page last allocated via order 2, migratetype Recla=
imable, gfp_mask 0xd2050(__GFP_RECLAIMABLE|_9
> [   80.938243][ T8573]  post_alloc_hook (./include/linux/page_owner.h:? m=
m/page_alloc.c:1889)
> [   80.938742][ T8573]  get_page_from_freelist (mm/page_alloc.c:? mm/page=
_alloc.c:3962)
> [   80.939318][ T8573]  __alloc_frozen_pages_noprof (mm/page_alloc.c:5250=
)
> [   80.939923][ T8573]  allocate_slab (mm/slub.c:3294 mm/slub.c:3481)
> [   80.940398][ T8573]  refill_objects (mm/slub.c:7176)
> [   80.940889][ T8573]  __pcs_replace_empty_main (mm/slub.c:2815 mm/slub.=
c:2834 mm/slub.c:4626)
> [   80.941462][ T8573]  kmem_cache_alloc_lru_noprof (mm/slub.c:4718 mm/sl=
ub.c:4851 mm/slub.c:4885)
> [   80.942092][ T8573]  nilfs_alloc_inode (fs/nilfs2/super.c:159)
> [   80.942592][ T8573]  alloc_inode (fs/inode.c:?)
> [   80.943045][ T8573]  iget5_locked (fs/inode.c:1390)
> [   80.943502][ T8573]  nilfs_attach_btree_node_cache (fs/nilfs2/inode.c:=
632)
> [   80.944120][ T8573]  nilfs_btree_convert_and_insert (fs/nilfs2/btree.c=
:1762 fs/nilfs2/btree.c:1902)
> [   80.944749][ T8573]  nilfs_bmap_insert (fs/nilfs2/bmap.c:118 fs/nilfs2=
/bmap.c:149)
> [   80.945263][ T8573]  nilfs_mdt_get_block (fs/nilfs2/mdt.c:46 fs/nilfs2=
/mdt.c:95 fs/nilfs2/mdt.c:258)
> [   80.945821][ T8573]  nilfs_cpfile_create_checkpoint (fs/nilfs2/cpfile.=
c:? fs/nilfs2/cpfile.c:330)
> [   80.946451][ T8573]  nilfs_segctor_do_construct (fs/nilfs2/segment.c:1=
250 fs/nilfs2/segment.c:1547 fs/nilfs2/segment.c:2122)
> [   80.947065][ T8573] page last free pid 1 tgid 1 stack trace:
> [  80.947665][ T8573]  __free_frozen_pages (./include/linux/page_owner.h:=
? mm/page_alloc.c:1433 mm/page_alloc.c:2978)
> [   80.948197][ T8573]  free_contig_range (mm/page_alloc.c:7373)
> [   80.948699][ T8573]  destroy_args (mm/debug_vm_pgtable.c:995)
> [   80.949174][ T8573]  debug_vm_pgtable (mm/debug_vm_pgtable.c:?)
> [   80.949695][ T8573]  do_one_initcall (init/main.c:?)
> [   80.950213][ T8573]  do_initcall_level (init/main.c:1443)
> [   80.950721][ T8573]  do_initcalls (init/main.c:1457)
> [   80.951173][ T8573]  kernel_init_freeable (init/main.c:1696)
> [   80.951714][ T8573]  kernel_init (init/main.c:1584)
> [   80.952167][ T8573]  ret_from_fork (arch/x86/kernel/process.c:164)
> [   80.952651][ T8573]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> [   80.953151][ T8573]
> [   80.953400][ T8573] Memory state around the buggy address:
> [   80.954002][ T8573]  ffff888178c4bc00: 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
> [   80.954819][ T8573]  ffff888178c4bc80: fc fc fc fc fc fc fc fc fc fc f=
c fc fc fc fc fc
> [   80.955641][ T8573] >ffff888178c4bd00: fc fc fc fc fc fc fc fc fc fc f=
c fc fc fc fc fc
> [   80.956460][ T8573]                                         ^
> [   80.957067][ T8573]  ffff888178c4bd80: fc fc fc fc fc fc fc fc fc fc f=
c fc fc fc fc fc
> [   80.957917][ T8573]  ffff888178c4be00: fc fc fc fc fc fc fc fc fc fc f=
c fc fc fc fc fc
> [   80.958920][ T8541] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20

Thank you for the report. Could you please create an issue here [1]?

Thanks,
Slava.

[1] https://github.com/nilfs-dev/nilfs2/issues

