Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5323BB48
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Jun 2026 02:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781837472; cv=pass; b=M4PRjCD7wbEwI26dTKIcw6zi6Btge4cBOyQ7lnvn6kefPwKbwQ4aklCh3GTfhYRigGsDsrxBAAXXwVaUp4P1VG04UnBnYr+Ru+7wknXM7qmFgtFBE8hQw5yQCxO0OA0MTEdNp5iGx2dl4poo7YdoTPKD17LiIxULVjBW4UP5QCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781837472; c=relaxed/simple;
	bh=/pF6IAQsbsB6biBpcJTygNf9FBzAka9y7NyP+LMTyHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hmzsu8kKbb1LTwtSAFyxjajZdNOWuw2FQ+3ABDUjxIuXBpfSq4EcxtYfzuEfHZD8NYMxuG9JlxxP3+hazLU+FJk998OhCRbQAtf8U4llDfPJvyUSmD15/VNO6zVvTeTzPG881K06TjZLyMSaRItTuJi5RE10fxj0U0NASUIJ+PI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WbcsDBmZ; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbcsDBmZ"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5ad583dc38eso268260e87.3
        for <linux-nilfs@vger.kernel.org>; Thu, 18 Jun 2026 19:51:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781837468; cv=none;
        d=google.com; s=arc-20240605;
        b=Qr1bbnLJlVVkveksFmX4JprOwCp8TMbnVPbx2z1ppgY0oX3PdwhzyCHYWaAk8dIzJv
         MCeYqgef4SdAm4H53qBgjc1RfmwR4QHYqXOWvs0v3uO4YblZ0daq0iNoR//FqB7az9l1
         YjdzQlkMl24nJAlG8rubS7CLNWemxNxcIHrN5/Qh3oInVLQvb0w/w3eYhCmSAmwIevtr
         NKHOBLaPDt0D/Bx7ix1PE0KuaHD5pi0LzVh6fuVCp1HnzLhtUSpfCgq1rpJaZiZu5bd+
         RdCrhItN2ZX1B1Q1Av34JanwgrksjcprGOsDNMEEPCuHVXQLKuyDS8Z1nKx6RtYO38/t
         qYgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uWW36nCv9sqYHu1n+3lHn89H574bRDDx/gpDcRweTgM=;
        fh=rPtp/CHhkH/qtCHU7bhVMhLHqcRwjOrHtl0HvtAf6/A=;
        b=loqCEfArZ170JmyFccfn2Y1EPUbxlbuEmAwurCrnHybsk33Wlzo+B7FDs7O2NHB1Cg
         OYAvHHWw4gouQ8NHaH9ucy8jqZX/cKQxmzqkVYfv3AjqMHrwwF/LTBJkBdNdQJ0eYuii
         XQdM/gTsabuHI6JYLefunA1U3i6v09p2Sgx7ZSl4vyqQkRqDa1QeqwxPYnCl2EOG0sl0
         hiK55z/uRYT2IPz3zpsXQGUHr9wSqTk7CGqhSWpYbAzJ+aYKbRFzka3ll5wD7WgEPDKk
         1/lXE5noXtcltnlOOiweDvJ0xgRZFGEmbLsHgSXtuZijHFX/l6R8PwPnfX92ktsoFHSb
         2YHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781837468; x=1782442268; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uWW36nCv9sqYHu1n+3lHn89H574bRDDx/gpDcRweTgM=;
        b=WbcsDBmZMqQR6orcq5dSn8eh8lXXM7iQ/eKEQstAUmS/D/n6Pf+xlZlcmOQ9i7g9qs
         HTUt9Y/UhzD2v5ergkYMKBBDAKCZJzs6Sf1ZikVpWuAKf4j9Wx4O+Vw0lgYNUHQNKwuI
         FW0gTi2PbldcHbtmpxleHleqg+EqljEwshDr9J6B9NcnpWhAW9Xysa2HalJ40dhwNV2G
         9EMjoH1BvyGBzn2H70jB+K23N87pL6oBnXGU1CravZiNPY4M/vsWtsZHajYmXBLQ+SJS
         3IGNEZ1Nrt+i7iuHDc9QmKrk6vmrAFvmHRQ5gXlVooY6Pi3du+C5GtKDe04DVY2chyND
         +BnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781837468; x=1782442268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uWW36nCv9sqYHu1n+3lHn89H574bRDDx/gpDcRweTgM=;
        b=nroYgyZ46xaE3hb4Bf+1tSFfi+/qNpWGzz5lHuzuUvdONpSquQ1jfPKEpixkfMBqZH
         dW1prsDixJEdBEtBDx3/jUxk3eVZ/74cnOr82OCRBIaVDNqZqYV9qD4uruD7MrshLfsN
         +oeaDZKTTWFQaV3/rQ7MdARZa8wIYsesgDo77xspqCRs8tgqPLozSN3bbt/g8BtCyoDL
         hlatlfJQmRa0gVJ3UADIYr5ClFDFL1Z8ppTgPmWw19p0AHRgJfom6H1m+jp4puLFK5SO
         6rydclJl6MSsg5POLuSIK7zg885HYf2SpRbvF0Cs30iuwa4QzChH+RJ9cBqUWIyOgfif
         MLYg==
X-Forwarded-Encrypted: i=1; AFNElJ/sT+eRfNVfAxQMCbCmlvYn5nt/JlskFb2nu8la6YfNM0FcoRk89Ays8X4UYA7ZgDLg9+o2s9KLN0roNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx66CjL3wO+dv0u3iRb/macW6eOCT3R9YidziIhmwUpmgTuX401
	TMI0jez61Lc0ayo80qP43dvAf5OrhEaJEPK9inS8khvHYcv454rnZnOXBJFdCsinS2MNl5tlX1W
	Mvaq3X0DOtrr6QXrkOX3laxQITZFBXWY=
X-Gm-Gg: AfdE7clmWUws4rX9NlaAeuYnRzMXDdJ9PLFhBBiTj/Flc+/sk0SVpCmdyg7Duvy5AYU
	ox1FxnQxDjlBkgMDkBBpmlUH7rYiiv2n7cUYFlOFvn9CggtDgKeE8YzzOMqm4gclCx34qKLoST2
	/1FGFLXl+lqNuNpBL2S/qcBdWD+Qx/fyMJAziZiJPrMYMRMPzeSV4bd0Yva5KVSSHCt+Q9CAyRJ
	r3wtTxYN41bXkDPxpwy/Kn7cb2K3xaaw2En7A7SVlrpjLn3zs46pMj5vvH//LlNvULU264tiw==
X-Received: by 2002:a05:6512:3da9:b0:5ad:54be:c7ca with SMTP id
 2adb3069b0e04-5ad576e12demr334921e87.12.1781837468028; Thu, 18 Jun 2026
 19:51:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6a32ab13.d1b4d54b.11ef78.0031.GAE@google.com>
In-Reply-To: <6a32ab13.d1b4d54b.11ef78.0031.GAE@google.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 19 Jun 2026 11:50:50 +0900
X-Gm-Features: AVVi8CeoSEm4ZL-GNnPDfnLRuq9PuUokO5zt1NBPtLIcttjeAnfJ8zgbLBheu6g
Message-ID: <CAKFNMokzM8WxptDjqtfNSY0yH3uS3z+-0ii8FJ0cKeUUO6-+pw@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] INFO: task hung in nilfs_segctor_thread (7)
To: syzbot <syzbot+155b515977fecb686986@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	slava@dubeyko.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 11:11=E2=80=AFPM syzbot
<syzbot+155b515977fecb686986@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    062871f1371b Merge tag 'pinctrl-v7.1-3' of git://git.kern=
e..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D16fa58ae58000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D4e828c596d7aa=
593
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D155b515977fecb6=
86986
> compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db=
3-1~exp1~20260514074407.73), Debian LLD 22.1.6
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1510f3d2580=
000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/e3dc965f9a88/dis=
k-062871f1.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/2f67e7ba9e6a/vmlinu=
x-062871f1.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/4ad13e1ccf55/b=
zImage-062871f1.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/f2ea87a290=
31/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+155b515977fecb686986@syzkaller.appspotmail.com
>
> INFO: task segctord:6131 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:segctord        state:D stack:28680 pid:6131  tgid:6131  ppid:2     =
 task_flags:0x200040 flags:0x00080000
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5388 [inline]
>  __schedule+0x1840/0x57a0 kernel/sched/core.c:7189
>  __schedule_loop kernel/sched/core.c:7268 [inline]
>  schedule+0x164/0x360 kernel/sched/core.c:7283
>  schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7340
>  rwsem_down_write_slowpath+0x87d/0x1080 kernel/locking/rwsem.c:1215
>  __down_write_common kernel/locking/rwsem.c:1347 [inline]
>  __down_write kernel/locking/rwsem.c:1356 [inline]
>  down_write+0x1bc/0x200 kernel/locking/rwsem.c:1626
>  nilfs_transaction_lock+0x24a/0x4b0 fs/nilfs2/segment.c:357
>  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2569 [inline]
>  nilfs_segctor_thread+0x6be/0xdb0 fs/nilfs2/segment.c:2684
>  kthread+0x389/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> Showing all locks held in the system:
> 1 lock held by khungtaskd/32:
>  #0:
> ffffffff8e95c780
>  (
> rcu_read_lock
> ){....}-{1:3}
> , at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
> , at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
> , at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
> 2 locks held by getty/5382:
>  #0:
> ffff888031f200a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x=
25/0x70 drivers/tty/tty_ldisc.c:243
>  #1:
> ffffc900032332e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0=
x45a/0x1380 drivers/tty/n_tty.c:2211
> 3 locks held by syz.0.17/6086:
> 2 locks held by syz.5.22/6114:
> 3 locks held by syz.2.19/6118:
> 3 locks held by syz.1.18/6126:
> 2 locks held by syz.3.20/6130:
> 3 locks held by syz.4.21/6132:
> 1 lock held by segctord/6131:
>  #0: ffff88805bb0c288 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_tra=
nsaction_lock+0x24a/0x4b0 fs/nilfs2/segment.c:357
> 2 locks held by syz-executor/6175:
> 1 lock held by syz-executor/6176:
> 7 locks held by syz.6.23/6349:
> 2 locks held by syz.7.24/6383:
> 3 locks held by syz.8.25/6380:
> 3 locks held by syz.9.26/6391:
> 1 lock held by syz.5.286/7133:
> 2 locks held by syz.0.288/7141:
> 1 lock held by syz.3.289/7140:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 32 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 05/09/2026
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:113
>  nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
>  __sys_info lib/sys_info.c:157 [inline]
>  sys_info+0x135/0x170 lib/sys_info.c:165
>  check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
>  watchdog+0xfd7/0x1030 kernel/hung_task.c:561
>  kthread+0x389/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 6126 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 05/09/2026
> RIP: 0010:hrtick_start+0x4a/0x250 kernel/sched/core.c:959
> Code: 00 00 41 bc 10 27 00 00 4c 0f 4d e6 4c 8d b7 e0 0d 00 00 4d 89 f7 4=
9 c1 ef 03 43 0f b6 04 2f 84 c0 0f 85 83 01 00 00 41 8b 2e <85> ed 74 46 83=
 cd 04 43 0f b6 04 2f 84 c0 0f 85 8a 01 00 00 89 ab
> RSP: 0018:ffffc90000a08a90 EFLAGS: 00000046
> RAX: 0000000000000000 RBX: ffff8880b873b080 RCX: 0000000000000392
> RDX: 00000000000000da RSI: 000000000017eda4 RDI: ffff8880b873b080
> RBP: 0000000000000000 R08: ffffffff902f890f R09: 1ffffffff205f121
> R10: dffffc0000000000 R11: fffffbfff205f122 R12: 000000000017eda4
> R13: dffffc0000000000 R14: ffff8880b873be60 R15: 1ffff110170e77cc
> FS:  00007f8ac9dd86c0(0000) GS:ffff8881253b9000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f775c7ec4b8 CR3: 0000000022337000 CR4: 0000000000350ef0
> Call Trace:
>  <IRQ>
>  enqueue_task+0x75/0x410 kernel/sched/core.c:2165
>  activate_task kernel/sched/core.c:2205 [inline]
>  ttwu_do_activate+0x1c8/0x650 kernel/sched/core.c:3725
>  ttwu_queue kernel/sched/core.c:3978 [inline]
>  try_to_wake_up+0x70e/0x1330 kernel/sched/core.c:4302
>  autoremove_wake_function+0x17/0x100 kernel/sched/wait.c:403
>  __wake_up_common kernel/sched/wait.c:108 [inline]
>  __wake_up_common_lock+0x13a/0x1f0 kernel/sched/wait.c:125
>  irq_work_single+0xe0/0x240 kernel/irq_work.c:221
>  irq_work_run_list kernel/irq_work.c:252 [inline]
>  irq_work_tick+0x238/0x2a0 kernel/irq_work.c:277
>  update_process_times+0x263/0x2f0 kernel/time/timer.c:2478
>  tick_sched_handle kernel/time/tick-sched.c:298 [inline]
>  tick_nohz_handler+0x3fb/0x730 kernel/time/tick-sched.c:319
>  __run_hrtimer kernel/time/hrtimer.c:1930 [inline]
>  __hrtimer_run_queues+0x371/0xa10 kernel/time/hrtimer.c:1994
>  hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2113
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
>  __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:10=
67
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1061
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:697
> RIP: 0010:console_trylock_spinning kernel/printk/printk.c:2039 [inline]
> RIP: 0010:vprintk_emit+0x45d/0x560 kernel/printk/printk.c:2478
> Code: 0f 84 44 ff ff ff e8 72 17 21 00 fb eb 44 e8 6a 17 21 00 e8 45 1c f=
e 09 4d 85 f6 74 94 e8 5b 17 21 00 fb 48 c7 c7 00 ed 94 8e <31> f6 ba 01 00=
 00 00 31 c9 41 b8 01 00 00 00 45 31 c9 53 e8 6b 19
> RSP: 0018:ffffc900035cee40 EFLAGS: 00000293
> RAX: ffffffff81a428d5 RBX: ffffffff81a4274f RCX: ffff888076f21f00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8e94ed00
> RBP: ffffc900035ceef0 R08: ffffffff902f88f7 R09: 1ffffffff205f11e
> R10: dffffc0000000000 R11: fffffbfff205f11f R12: 0000000000000000
> R13: 0000000000000040 R14: 0000000000000200 R15: 1ffff920006b9dcc
>  _printk+0xdd/0x130 kernel/printk/printk.c:2504
>  __nilfs_msg+0x373/0x450 fs/nilfs2/super.c:78
>  nilfs_sufile_updatev+0x21c/0x6d0 fs/nilfs2/sufile.c:186
>  nilfs_sufile_freev fs/nilfs2/sufile.h:93 [inline]
>  nilfs_free_segments fs/nilfs2/segment.c:1140 [inline]
>  nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1261 [inline]
>  nilfs_segctor_collect fs/nilfs2/segment.c:1547 [inline]
>  nilfs_segctor_do_construct+0x20dd/0x7bb0 fs/nilfs2/segment.c:2122
>  nilfs_segctor_construct+0x170/0x690 fs/nilfs2/segment.c:2462
>  nilfs_clean_segments+0x3ac/0xa50 fs/nilfs2/segment.c:2536
>  nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
>  nilfs_ioctl+0x2619/0x2780 fs/nilfs2/ioctl.c:1352
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8ac8f9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f8ac9dd8028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f8ac9216090 RCX: 00007f8ac8f9ce59
> RDX: 0000200000000640 RSI: 0000000040786e88 RDI: 0000000000000004
> RBP: 00007f8ac9032d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f8ac9216128 R14: 00007f8ac9216090 R15: 00007ffd4ee3dc58
>  </TASK>

#syz dup: INFO: task hung in nilfs_transaction_begin (2)

This issue has been fixed by commit 0e7a690fe435 ("nilfs2: reject
CLEAN_SEGMENTS ioctl with out-of-range segment numbers") which was
merged into the mainline this week.

I confirmed this by running the reported reproducer.

Ryusuke Konishi
