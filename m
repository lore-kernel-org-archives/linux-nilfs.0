From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [syzbot] WARNING in __folio_mark_dirty
Date: Thu, 28 Oct 2021 18:07:08 +0100
Message-ID: <YXrYvIo8YRnAOJCj@casper.infradead.org>
References: <0000000000003a5b5905cf6c5ee7@google.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Te+w3AB3S4i1K0MuH89t3Hz7sgB8PA4EkDTK3lPuI30=; b=lQc3SDvpg49wSCb9o0IoMceN9K
        +82iywQ4aPyvKXiFZv1F/XilI9oL8UrZCUgXt//5ZrFLWoMFQK5MS4BZXIXEEn4Qewd28l0FUStc3
        wo3GWth8m8QPyvZtMsPQe36jTOlej/i4MnAd6UUdU7M3M1N8K2pRTv15Up1bOMFP+RWtKo785BFHm
        BsB6wwsyz/z7nOHRv5tYDE+ou+sJtZ6m0LSRfd+Y+6R9qvpOLgEAruqtDisjLuWqXKRdUG15mR3uf
        EtQUKUGGXqDDWf1NuTSyMvEeWDbdWAUP3W3/ubgIqxgtvnkCvI+wd9kfOAGupr9iXBozprhOOMbpU
        69QYqVyg==;
Content-Disposition: inline
In-Reply-To: <0000000000003a5b5905cf6c5ee7-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+34ef28bb2aeb28724aa0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


I don't think this is something folio-related; I think it's a bug
in nilfs which is failing to hold one of the appropriate locks:

        WARN_ON_ONCE(debug_locks &&
                     (!lockdep_is_held(&inode->i_lock) &&
                      !lockdep_is_held(&inode->i_mapping->i_pages.xa_lock) &&
                      !lockdep_is_held(&inode->i_wb->list_lock)));

(or possibly it's fine for nilfs to not be holding one of those locks,
but if so then the condition needs to be updated to explain why it's
safe for nilfs to be not holding one of those locks)

On Thu, Oct 28, 2021 at 09:40:27AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    cf6c9d12750c Add linux-next specific files for 20211022
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=177967acb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=dd1cd3d631599df5
> dashboard link: https://syzkaller.appspot.com/bug?extid=34ef28bb2aeb28724aa0
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e79e9f300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12231f62b00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+34ef28bb2aeb28724aa0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> 
> NILFS (loop0): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6575 at include/linux/backing-dev.h:269 inode_to_wb include/linux/backing-dev.h:269 [inline]
> WARNING: CPU: 0 PID: 6575 at include/linux/backing-dev.h:269 folio_account_dirtied mm/page-writeback.c:2460 [inline]
> WARNING: CPU: 0 PID: 6575 at include/linux/backing-dev.h:269 __folio_mark_dirty+0xa7c/0xe30 mm/page-writeback.c:2509
> Modules linked in:
> CPU: 0 PID: 6575 Comm: segctord Not tainted 5.15.0-rc6-next-20211022-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:inode_to_wb include/linux/backing-dev.h:269 [inline]
> RIP: 0010:folio_account_dirtied mm/page-writeback.c:2460 [inline]
> RIP: 0010:__folio_mark_dirty+0xa7c/0xe30 mm/page-writeback.c:2509
> Code: ff ff ff 48 8d 78 70 e8 b2 77 ae 07 31 ff 89 c6 89 44 24 10 e8 45 a5 d7 ff 8b 44 24 10 85 c0 0f 85 49 fa ff ff e8 14 a3 d7 ff <0f> 0b e9 3d fa ff ff e8 08 a3 d7 ff e8 c3 78 ae 07 31 ff 41 89 c7
> RSP: 0018:ffffc900020078b8 EFLAGS: 00010093
> RAX: 0000000000000000 RBX: ffff88806b870378 RCX: 0000000000000000
> RDX: ffff88801b4fba80 RSI: ffffffff819fea3c RDI: 0000000000000003
> RBP: ffffea0001c92700 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff819fea2b R11: 0000000000000000 R12: 0000000000000293
> R13: ffff88806b870138 R14: 0000000000000001 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055d7235e1180 CR3: 000000001278d000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __set_page_dirty include/linux/pagemap.h:834 [inline]
>  mark_buffer_dirty+0x4e6/0x650 fs/buffer.c:1145
>  nilfs_btree_propagate_p fs/nilfs2/btree.c:1889 [inline]
>  nilfs_btree_propagate+0x4ae/0xea0 fs/nilfs2/btree.c:2085
>  nilfs_bmap_propagate+0x73/0x170 fs/nilfs2/bmap.c:337
>  nilfs_collect_dat_data+0x45/0xd0 fs/nilfs2/segment.c:625
>  nilfs_segctor_apply_buffers+0x14a/0x470 fs/nilfs2/segment.c:1009
>  nilfs_segctor_scan_file+0x47a/0x700 fs/nilfs2/segment.c:1048
>  nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1224 [inline]
>  nilfs_segctor_collect fs/nilfs2/segment.c:1494 [inline]
>  nilfs_segctor_do_construct+0x14f3/0x6c60 fs/nilfs2/segment.c:2036
>  nilfs_segctor_construct+0x7a7/0xb30 fs/nilfs2/segment.c:2372
>  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2480 [inline]
>  nilfs_segctor_thread+0x3c3/0xf90 fs/nilfs2/segment.c:2563
>  kthread+0x405/0x4f0 kernel/kthread.c:327
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
