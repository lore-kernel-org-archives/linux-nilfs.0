From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()
Date: Tue, 15 Nov 2022 03:39:18 +0900
Message-ID: <CAKFNMomu3Sf4_QHOm=zXM-QiLaVxASpMqpjek0F3SQnXwje4KA@mail.gmail.com>
References: <20221114040441.1649940-1-zhangpeng362@huawei.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fBD1OWmrjBsMLFUG5eOKvkR0gk9oq/LI0JbXvTfwkno=;
        b=cJBaxGwNsvY2BSv/vJg95TnFLkko4G1FkWpSb5Tt4I/9qGPf9HHIv97U/7S81+yeAB
         m+T9P4pv7e24Vh6+TRBoXLcGlU9Utl6qWWlRQrs+PlnUhEq9+vdmbeibi5trIJb4HRJT
         cmRf1ni9QZ5aZuKns9eGU2rT6vmx7LnOGXF+rWzMTJ4REsM6VUM/qiX05zX3CfvYwgEZ
         1fxkzniGV3IMc9+TGS0HNG/xOcKAWUwvWJ6B457NHVTziU/yc/iRKtIeBRHDyzGr3XD/
         teqsw1WG04Tj0whZdCWzzz12jp3ytaOm62LxQngq+qDXHZXPsqYj/RM1VUZ+ToDm7IKg
         J+Kg==
In-Reply-To: <20221114040441.1649940-1-zhangpeng362-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peng Zhang <zhangpeng362-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, chi.minghao-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot+ebe05ee8e98f755f61d0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

On Mon, Nov 14, 2022 at 12:39 PM Peng Zhang wrote:
>
> From: ZhangPeng <zhangpeng362-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> Syzbot reported a null-ptr-deref bug:
>
> NILFS (loop0): segctord starting. Construction interval = 5 seconds, CP
> frequency < 30 seconds
> general protection fault, probably for non-canonical address
> 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 1 PID: 3603 Comm: segctord Not tainted
> 6.1.0-rc2-syzkaller-00105-gb229b6ca5abb #0
> Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google
> 10/11/2022
> RIP: 0010:nilfs_palloc_commit_free_entry+0xe5/0x6b0
> fs/nilfs2/alloc.c:608
> Code: 00 00 00 00 fc ff df 80 3c 02 00 0f 85 cd 05 00 00 48 b8 00 00 00
> 00 00 fc ff df 4c 8b 73 08 49 8d 7e 10 48 89 fa 48 c1 ea 03 <80> 3c 02
> 00 0f 85 26 05 00 00 49 8b 46 10 be a6 00 00 00 48 c7 c7
> RSP: 0018:ffffc90003dff830 EFLAGS: 00010212
> RAX: dffffc0000000000 RBX: ffff88802594e218 RCX: 000000000000000d
> RDX: 0000000000000002 RSI: 0000000000002000 RDI: 0000000000000010
> RBP: ffff888071880222 R08: 0000000000000005 R09: 000000000000003f
> R10: 000000000000000d R11: 0000000000000000 R12: ffff888071880158
> R13: ffff88802594e220 R14: 0000000000000000 R15: 0000000000000004
> FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb1c08316a8 CR3: 0000000018560000 CR4: 0000000000350ee0
> Call Trace:
>  <TASK>
>  nilfs_dat_commit_free fs/nilfs2/dat.c:114 [inline]
>  nilfs_dat_commit_end+0x464/0x5f0 fs/nilfs2/dat.c:193
>  nilfs_dat_commit_update+0x26/0x40 fs/nilfs2/dat.c:236
>  nilfs_btree_commit_update_v+0x87/0x4a0 fs/nilfs2/btree.c:1940
>  nilfs_btree_commit_propagate_v fs/nilfs2/btree.c:2016 [inline]
>  nilfs_btree_propagate_v fs/nilfs2/btree.c:2046 [inline]
>  nilfs_btree_propagate+0xa00/0xd60 fs/nilfs2/btree.c:2088
>  nilfs_bmap_propagate+0x73/0x170 fs/nilfs2/bmap.c:337
>  nilfs_collect_file_data+0x45/0xd0 fs/nilfs2/segment.c:568
>  nilfs_segctor_apply_buffers+0x14a/0x470 fs/nilfs2/segment.c:1018
>  nilfs_segctor_scan_file+0x3f4/0x6f0 fs/nilfs2/segment.c:1067
>  nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1197 [inline]
>  nilfs_segctor_collect fs/nilfs2/segment.c:1503 [inline]
>  nilfs_segctor_do_construct+0x12fc/0x6af0 fs/nilfs2/segment.c:2045
>  nilfs_segctor_construct+0x8e3/0xb30 fs/nilfs2/segment.c:2379
>  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2487 [inline]
>  nilfs_segctor_thread+0x3c3/0xf30 fs/nilfs2/segment.c:2570
>  kthread+0x2e4/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:nilfs_palloc_commit_free_entry+0xe5/0x6b0
> fs/nilfs2/alloc.c:608
> Code: 00 00 00 00 fc ff df 80 3c 02 00 0f 85 cd 05 00 00 48 b8 00 00 00
> 00 00 fc ff df 4c 8b 73 08 49 8d 7e 10 48 89 fa 48 c1 ea 03 <80> 3c 02
> 00 0f 85 26 05 00 00 49 8b 46 10 be a6 00 00 00 48 c7 c7
> RSP: 0018:ffffc90003dff830 EFLAGS: 00010212
> RAX: dffffc0000000000 RBX: ffff88802594e218 RCX: 000000000000000d
> RDX: 0000000000000002 RSI: 0000000000002000 RDI: 0000000000000010
> RBP: ffff888071880222 R08: 0000000000000005 R09: 000000000000003f
> R10: 000000000000000d R11: 0000000000000000 R12: ffff888071880158
> R13: ffff88802594e220 R14: 0000000000000000 R15: 0000000000000004
> FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb1c08316a8 CR3: 0000000018560000 CR4: 0000000000350ee0
> ----------------
> Code disassembly (best guess), 7 bytes skipped:
>    0:   80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1)
>    4:   0f 85 cd 05 00 00       jne    0x5d7
>    a:   48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
>   11:   fc ff df
>   14:   4c 8b 73 08             mov    0x8(%rbx),%r14
>   18:   49 8d 7e 10             lea    0x10(%r14),%rdi
>   1c:   48 89 fa                mov    %rdi,%rdx
>   1f:   48 c1 ea 03             shr    $0x3,%rdx
> * 23:   80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1) <-- trapping
> instruction
>   27:   0f 85 26 05 00 00       jne    0x553
>   2d:   49 8b 46 10             mov    0x10(%r14),%rax
>   31:   be a6 00 00 00          mov    $0xa6,%esi
>   36:   48                      rex.W
>   37:   c7                      .byte 0xc7
>   38:   c7                      .byte 0xc7
>
> When maxlevelp is 1, there is a case where req->pr_desc_bh is NULL and
> blocknr is 0, because nilfs_dat_commit_alloc() will modify the blocknr
> of oldreq at one level higher to 0. And we don't have a NULL check on
> req->pr_desc_bh and req->pr_bitmap_bh in
> nilfs_palloc_commit_free_entry() function, so when req->pr_desc_bh is
> NULL and kmap() dereferences a NULL pointer, it leads to above crash.
> Fix this by adding a NULL check on req->pr_desc_bh and req->pr_bitmap_bh
> before nilfs_palloc_commit_free_entry() in nilfs_dat_commit_free().
>
> Reported-by: syzbot+ebe05ee8e98f755f61d0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> Fixes: bd8169efae8b ("nilfs2: add update functions of virtual block address to dat")
> Signed-off-by: ZhangPeng <zhangpeng362-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  fs/nilfs2/dat.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
> index 3b55e239705f..84ce050a8fa3 100644
> --- a/fs/nilfs2/dat.c
> +++ b/fs/nilfs2/dat.c
> @@ -111,6 +111,9 @@ static void nilfs_dat_commit_free(struct inode *dat,
>         kunmap_atomic(kaddr);
>
>         nilfs_dat_commit_entry(dat, req);
> +
> +       if (req->pr_desc_bh == NULL || req->pr_bitmap_bh == NULL)
> +               return;
>         nilfs_palloc_commit_free_entry(dat, req);
>  }
>
> --
> 2.25.1
>

Thank you for your help.

This patch actually fixes the NULL pointer dereference, and doesn't
seem to cause any regressions so far.
But, if de_blocknr is 0 in the first place, it assumes that
req->pr_desc_bh and req->pr_bitmap_bh are set properly in the
corresponding "prepare" operation, nilfs_dat_prepare_end(), so I'd
like to review in a little more detail why that is broken.

Thanks,
Ryusuke Konishi
