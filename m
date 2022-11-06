From: wuhoipok-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [BUG] fs: nilfs2: Null dereference in nilfs_grab_buffer
Date: Sun, 06 Nov 2022 22:58:28 +0800
Message-ID: <45076368.fMDQidcC6G@jaydesktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GY8OIcpDFMeyi3P/xPcuWJEUxrB/1YMs6wsMdNRTnpY=;
        b=A9ctKFX/W95fM5kVKNAlzTL4u+QH1HQ3cZJOFcLQ7E6voPgL5n0DVXDVHN33MwBaex
         +ZSZc0ScyT0alzvfRrtVoPibZWWTvEkbMq+qIwDk0P+HoePNY9ej/0wG1g/j0QoR41g5
         LsJ4CX4XwECCzWdRuXQ4tFKYBhmvLNBLyq21dj71j+kt5HnRZysQzLeBbwM9ttjae4vf
         ElWjRevSoTI0F2huN+UKs3QydBI7dRhvxtx9rGuF4A9b5JJgZEXONwzJJ+CLpfn2VC9x
         RV9HBR7LFsHGqeh1ZxSYD6EaUtRYv6qZLiHo03uwsrNWhgrpLxzIm1oc4eeQfeRIFvUb
         KKeg==
List-ID: <linux-nilfs.vger.kernel.org>
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wuhoipok-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi, upon my investigation of a bug reported by syzbot with the following link.

https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24

By enabling event tracing running the c repro, touch_buffer(bh) would panic 
the kernel with handling NULL pointer dereference, it is because the 
buffer_header does not have a block device pointing to. The problem is that I 
do not know if this is a defined behaviour of buffer_header, I am 
inexperienced here. I would post the panic message down here.

[  155.995180][ T6861] loop0: detected capacity change from 0 to 2048
[  156.018325][ T6861] NILFS (loop0): broken superblock, retrying with spare 
superblock (blocksize = 1024)
[  156.089921][ T6861] Unable to handle kernel NULL pointer dereference at 
virtual address 0000000000000024
[  156.091476][ T6861] Mem abort info:
[  156.092114][ T6861]   ESR = 0x0000000096000006
[  156.096162][ T6861]   EC = 0x25: DABT (current EL), IL = 32 bits
[  156.100850][ T6861]   SET = 0, FnV = 0
[  156.104732][ T6861]   EA = 0, S1PTW = 0
[  156.108397][ T6861]   FSC = 0x06: level 2 translation fault
[  156.113937][ T6861] Data abort info:
[  156.120935][ T6861]   ISV = 0, ISS = 0x00000006
[  156.127581][ T6861]   CM = 0, WnR = 0
[  156.134563][ T6861] user pgtable: 4k pages, 48-bit VAs, 
pgdp=000000011353c000
[  156.141306][ T6861] [0000000000000024] pgd=080000010d35a003, 
p4d=080000010d35a003, pud=080000010ecfb003, pmd=0000000000000000
[  156.149362][ T6861] Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
[  156.155439][ T6861] Modules linked in:
[  156.160673][ T6861] CPU: 6 PID: 6861 Comm: repro Not tainted 6.1.0-rc3-
next-20221104 #38
[  156.164042][ T6861] Hardware name: linux,dummy-virt (DT)
[  156.169001][ T6861] pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[  156.174568][ T6861] pc : trace_event_raw_event_block_buffer+0x64/0xc0
[  156.180880][ T6861] lr : trace_event_raw_event_block_buffer+0x54/0xc0
[  156.184271][ T6861] sp : ffff80000fe73810
[  156.187185][ T6861] x29: ffff80000fe73810 x28: 0000000000000000 x27: 
00000000000000c0
[  156.191900][ T6861] x26: 0000000000000000 x25: 0000000000000000 x24: 
0000000000000000
[  156.197326][ T6861] x23: ffff0000cd36ce00 x22: ffff80000bd49000 x21: 
ffff80000bd49368
[  156.202531][ T6861] x20: ffff0000c00c6580 x19: ffff0000cdf172a0 x18: 
0000000000000000
[  156.208112][ T6861] x17: 0000000000000000 x16: 0000000000000519 x15: 
0000000000000001
[  156.212665][ T6861] x14: 0000000000000002 x13: 00000000000278a7 x12: 
0000000000100000
[  156.217123][ T6861] x11: 0000000000100000 x10: 0000000000000000 x9 : 
ffff80000ce98000
[  156.222096][ T6861] x8 : ffff80000fe73768 x7 : 0000000000000000 x6 : 
000000000de4379f
[  156.227209][ T6861] x5 : 0000000000000020 x4 : 000000000024ba04 x3 : 
0000000000000000
[  156.231371][ T6861] x2 : ffff0000d320ed9c x1 : 0000000000000000 x0 : 
ffff80000fe73838
[  156.236095][ T6861] Call trace:
[  156.240201][ T6861]  trace_event_raw_event_block_buffer+0x64/0xc0
[  156.243814][ T6861]  __traceiter_block_touch_buffer+0x38/0x54
[  156.246562][ T6861]  touch_buffer+0x128/0x1b0
[  156.249087][ T6861]  nilfs_grab_buffer+0xb8/0x200
[  156.251763][ T6861]  nilfs_mdt_submit_block+0x4c/0x470
[  156.254103][ T6861]  nilfs_mdt_read_block+0x44/0x154
[  156.256216][ T6861]  nilfs_mdt_get_block+0x58/0x520
[  156.258450][ T6861]  nilfs_sufile_read+0x104/0x220
[  156.260480][ T6861]  load_nilfs+0x25c/0x4e0
[  156.262535][ T6861]  nilfs_mount+0x3f0/0x624
[  156.264678][ T6861]  legacy_get_tree+0x30/0x60
[  156.266801][ T6861]  vfs_get_tree+0x28/0xf0
[  156.270048][ T6861]  path_mount+0x3dc/0xbb0
[  156.273158][ T6861]  __arm64_sys_mount+0x204/0x2dc
[  156.276088][ T6861]  invoke_syscall+0x48/0x114
[  156.279141][ T6861]  el0_svc_common.constprop.0+0xfc/0x11c
[  156.282159][ T6861]  do_el0_svc+0x2c/0xd0
[  156.285177][ T6861]  el0_svc+0x50/0x140
[  156.288452][ T6861]  el0t_64_sync_handler+0xf4/0x120
[  156.291375][ T6861]  el0t_64_sync+0x18c/0x190
[  156.294203][ T6861] Code: aa0003e2 b4000140 f9401a61 9100a3e0 (b9402421) 
[  156.298191][ T6861] ---[ end trace 0000000000000000 ]---
[  156.301621][ T6861] Kernel panic - not syncing: Oops: Fatal exception
[  156.304165][ T6861] SMP: stopping secondary CPUs
[  156.306561][ T6861] Kernel Offset: disabled
[  156.308120][ T6861] CPU features: 0x00000,00070084,6601720b
[  156.309695][ T6861] Memory Limit: none
[  156.311323][ T6861] Rebooting in 86400 seconds..

Any help would be appreciated, Thank you!



