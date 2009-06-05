From: nezmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: Re: Pause intervals when copying/extracting an	archive
Date: Fri, 5 Jun 2009 22:32:56 +0300
Message-ID: <20090605193256.GA3663@nezmer.homelinux.org>
References: <20090516171555.GA21962@nezmer.homelinux.org>
	<20090517.122816.105794011.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090517.122816.105794011.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 17, 2009 at 12:28:16PM +0900, Ryusuke Konishi wrote:
> Hi,
> On Sat, 16 May 2009 20:15:55 +0300, nezmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> > Hi ,
> > 
> > Kernel : 2.6.30-rc5-git3 .
> > nilfs2 partition : 1GB USB flash disk .
> > 
> > I have a rar archive with 10 mp3 files in it . When I copy this file to
> > a nilfs2 partition the progress pauses(freezes) in certain intervals .
> > the same thing happens when I try to extract the archive . this 'bug'
> > causes the extraction time to jump from <2s (ext4,JFS,XFS) to 29s in
> > nilfs2 . Those intervals are 100% reproducible here . 
> > 
> > I have no idea how to get a detailed log of what's going on with nilfs2 . So If you need that log , Just tell me how can I get it .
> > 
> > Estimated calculation of pause intervals in MB :
> > 
> > unrar e file.rar #(60.5MB)
> > 12.732
> > 28.52
> > 42.028
> > 56.768
> > 
> > cp file.rar /media/nilfsTest/
> > 14.1
> > 28.1
> > 42.2
> > 56.2
> 
> Thank you for reporting the problem.  I'll look into this along with
> the reported mount problem on pen-drives.
> 
> If you can hit the keyboard in another terminal during the interval,
> please try the following dump feature:
> 
>  # echo 1 > /proc/sys/kernel/sysrq
> 
>  # echo d > /proc/sysrq-trigger
>  # dmesg > dmesg.out.1
>  (this shows all locks that are held)
> 
>  # echo t > /proc/sysrq-trigger
>  # dmesg > dmesg.out.2
>  (this will dump a list of current tasks and their stack)
> 
> 
> Note that, your kernel has to be built with the kernel option:
> 
>   CONFIG_MAGIC_SYSRQ=y
> 
> to enable this feature.
> 
> 
> Thanks,
> Ryusuke Konishi
Sorry for the late reply .

I tried to use deplock but I always get this :
SysRq : Show Locks Held
INFO: lockdep is turned off.

sysrq t works . I hope the attached file will be helpful .

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sys_t.txt"

SysRq : Show State
  task                PC stack   pid father
init          S 000000a7     0     1      0
 f702bac0 00000086 0954674d 000000a7 00000282 0000d789 00000000 09538fc4
 000000a7 f7030000 f702bb24 f702bac8 335a438a 000000a8 f7030000 f702bac8
 c03e6c37 f702bb34 c03e7e22 004c4b3e 00000000 00000000 f66d7f40 f73431e4
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194c89>] ? do_select+0x528/0x5d1
 [<c0194777>] ? do_select+0x16/0x5d1
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c01392c8>] ? clocksource_get_next+0xa/0x40
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0126960>] ? run_timer_softirq+0x1b9/0x22f
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c0126960>] ? run_timer_softirq+0x1b9/0x22f
 [<c013bc15>] ? tick_dev_program_event+0x48/0xcf
 [<c0196d6f>] ? __d_lookup+0x13f/0x141
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194f32>] ? core_sys_select+0x200/0x2fc
 [<c0194d51>] ? core_sys_select+0x1f/0x2fc
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c02a15d8>] ? copy_to_user+0x29/0x100
 [<c018a7b3>] ? cp_new_stat64+0xf5/0x107
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c01951c8>] ? sys_select+0x2f/0xb8
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
kthreadd      S 00000067     0     2      0
 f702ffcc 00000096 598a10db 00000067 00000000 00008d0e 00000000 598983cd
 00000067 f7030c50 c013008c 00000001 e34f1de4 c0512520 00000000 f702ffd4
 c03e6c37 00000000 c0130096 c012ffc1 00000000 c0103437 00000000 00000000
Call Trace:
 [<c013008c>] ? kthreadd+0xcb/0xdc
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0130096>] ? kthreadd+0xd5/0xdc
 [<c012ffc1>] ? kthreadd+0x0/0xdc
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
ksoftirqd/0   S 000000a7     0     3      2
 f703dfc4 00000082 fea1ce47 000000a7 f71c98a0 00002e07 00000000 fea1a040
 000000a7 f70318a0 00000000 ffff007b 00000000 00000000 00000000 f703dfcc
 c03e6c37 00000000 c0122f72 c0122ef8 c01300dd c013009d 00000000 c0103437
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0122f72>] ? ksoftirqd+0x7a/0xa4
 [<c0122ef8>] ? ksoftirqd+0x0/0xa4
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
watchdog/0    S 00000000     0     4      2
 f703ffc4 00000082 01c9b1ae 00000000 f70324f0 00000000 00000000 01c9b1ae
 00000000 f70324f0 00000000 00000296 c0150a38 00000000 00000000 f703ffcc
 c03e6c37 00000000 c0150a6f 00000063 c01300dd c013009d 00000000 c0103437
Call Trace:
 [<c0150a38>] ? watchdog+0x0/0x66
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0150a6f>] ? watchdog+0x37/0x66
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
events/0      S 000000a7     0     5      2
 f7041f6c 00000096 33685a10 000000a7 00000282 0000077a 00000000 33685296
 000000a7 f7033140 00000001 f701b22c 00000000 f701b200 f7041fa0 f7041f74
 c03e6c37 c02f75e2 c012d03f 00000000 00000002 00000000 c012cf61 f7033140
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02f75e2>] ? console_callback+0x0/0xf7
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c012cf61>] ? worker_thread+0x155/0x2e5
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
khelper       S 00000067     0     6      2
 f7043f6c 00000096 2b11517f 00000067 00000282 00000bc1 00000000 2b1145be
 00000067 f7033d90 00000001 f701b32c 00000000 f701b300 f7043fa0 f7043f74
 c03e6c37 c012c60a c012d03f 00000000 00000002 00000000 c012cf61 f7033d90
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012c60a>] ? __call_usermodehelper+0x0/0x60
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c012cf61>] ? worker_thread+0x155/0x2e5
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
async/mgr     S 00000003     0     7      2
 f7063f98 00000096 50be3ad2 00000003 f71c98a0 0004602f 00000000 50b9daa3
 00000003 f70349e0 00000000 00000000 f7063fb8 00000001 00000001 f7063fa0
 c03e6c37 00000000 c0135d06 c0135e06 00000000 c049fdf4 00000000 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0135d06>] ? async_manager_thread+0x46/0xd2
 [<c0135e06>] ? async_thread+0x0/0x234
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0135cc0>] ? async_manager_thread+0x0/0xd2
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
kintegrityd/0 S 00000000     0     8      2
 f706bf6c 00000096 02087470 00000000 f7035630 000014fa 00000000 02085f76
 00000000 f7035630 f706bfa0 00000000 c012ce0c f7049580 f706bfa0 f706bf74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f7035630
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
kblockd/0     S 000000a7     0     9      2
 f706df6c 00000096 8b9aece9 000000a7 00000282 0032abf3 00000000 8b6840f6
 000000a7 f7036280 00000001 f7049a2c 00000000 f7049a00 f706dfa0 f706df74
 c03e6c37 c028e7df c012d03f 00000000 00000002 00000000 c012cf61 f7036280
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c028e7df>] ? blk_unplug_work+0x0/0x37
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c012cf61>] ? worker_thread+0x155/0x2e5
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
kacpid        S 00000000     0    10      2
 f706ff6c 00000096 020b186f 00000000 f7036ed0 00001298 00000000 020b05d7
 00000000 f7036ed0 f706ffa0 00000000 c012ce0c f7049b80 f706ffa0 f706ff74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f7036ed0
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
kacpi_notify  S 00000000     0    11      2
 f7081f6c 00000096 04fb4eea 00000000 f7078000 0000367b 00000000 04fb186f
 00000000 f7078000 f7081fa0 00000000 c012ce0c f7049c80 f7081fa0 f7081f74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f7078000
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
ata/0         S 00000000     0    12      2
 f70b7f6c 00000096 04fcc043 00000000 f7078c50 00001093 00000000 04fcafb0
 00000000 f7078c50 f70b7fa0 00000000 c012ce0c f709b000 f70b7fa0 f70b7f74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f7078c50
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
ata_aux       S 00000000     0    13      2
 f70bdf6c 00000096 04fd1147 00000000 f70798a0 00001248 00000000 04fcfeff
 00000000 f70798a0 f70bdfa0 00000000 c012ce0c f709b100 f70bdfa0 f70bdf74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f70798a0
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
ksuspend_usbd S 00000001     0    14      2
 f70bff6c 00000096 8f9d382d 00000001 f707a4f0 00033f60 00000000 8f99f8cd
 00000001 f707a4f0 f70bffa0 c0342536 00000001 f709b200 f70bffa0 f70bff74
 c03e6c37 c0342536 c012d03f 00000000 00000002 00000000 c012cf61 f707a4f0
Call Trace:
 [<c0342536>] ? usb_autosuspend_work+0x0/0xc
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0342536>] ? usb_autosuspend_work+0x0/0xc
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c012cf61>] ? worker_thread+0x155/0x2e5
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
khubd         S 00000000     0    15      2
 f70cdf24 00000082 00000000 00000000 f707b140 00000046 f707b140 f70cdf20
 f707b140 f707b140 00000003 f7130000 f70cdfa8 f6b6ea00 00000003 f70cdf2c
 c03e6c37 f7130000 c033cfb1 f6b08180 0000000a f707b140 00000046 f707b140
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c033cfb1>] ? hub_thread+0xab3/0xf32
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c033c4fe>] ? hub_thread+0x0/0xf32
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
kseriod       S 00000002     0    16      2
 f70cff90 00000086 1749ede0 00000002 00000282 00052f31 00000000 1744beaf
 00000002 f707bd90 00000001 c067a4a0 f70cffb4 f6aa71a0 c067a484 f70cff98
 c03e6c37 c067a484 c0357ac8 f7030000 00000620 00000000 0504b718 00000282
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0357ac8>] ? serio_thread+0x2ba/0x35f
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c035780e>] ? serio_thread+0x0/0x35f
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
khungtaskd    S 000000a7     0    17      2
 f70dbf38 00000096 ac2d2e83 000000a7 c07e5d80 00000000 00000000 00000000
 00000000 f707c9e0 00000001 c07e5d80 f70dbf54 c07e5d80 c07e5d80 f70dbf40
 c03e6c37 00083df4 c03e6fa8 12a296aa 0000000f 00066934 c07e68ac f369d154
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<c0150c25>] ? watchdog+0x38/0x237
 [<c0150e0b>] ? watchdog+0x21e/0x237
 [<c0150c25>] ? watchdog+0x38/0x237
 [<c0150c43>] ? watchdog+0x56/0x237
 [<c0150bed>] ? watchdog+0x0/0x237
 [<c0150bed>] ? watchdog+0x0/0x237
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
pdflush       S 00000000     0    18      2
 f70edfa4 00000086 08a2a89c 00000000 00000000 00003517 00000000 08a27385
 00000000 f707d630 c03e8e68 00000000 f70edfc4 00000000 00000000 f70edfac
 c03e6c37 00000000 c01691c2 f707d630 f707d630 00000000 c01690fc c065f5e4
Call Trace:
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c01691c2>] ? pdflush+0xc6/0x1f2
 [<c01690fc>] ? pdflush+0x0/0x1f2
 [<c01690fc>] ? pdflush+0x0/0x1f2
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
pdflush       S 000000a7     0    19      2
 f70f7fa4 00000086 3a74159f 000000a7 00000000 000ac27f 00000000 3a695320
 000000a7 f707e280 c01691bd 00000001 f70f7fc4 00000000 00000000 f70f7fac
 c03e6c37 00000000 c01691c2 f707e280 f707e280 00000000 00000000 f70edfc4
Call Trace:
 [<c01691bd>] ? pdflush+0xc1/0x1f2
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c01691c2>] ? pdflush+0xc6/0x1f2
 [<c01690fc>] ? pdflush+0x0/0x1f2
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
kswapd0       S 00000000     0    20      2
 f6b59f1c 00000096 08fac2a9 00000000 f707eed0 000045b7 00000000 08fa7cf2
 00000000 f707eed0 f6b59fb4 c0682a00 f707eed0 c068b734 f6b59fb4 f6b59f24
 c03e6c37 c0682a00 c016cf47 1376ac0e 0000000f 00000000 f6b59f6c f6b59fa0
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c016cf47>] ? kswapd+0x55a/0x573
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c013f9ea>] ? trace_hardirqs_on_caller+0x106/0x14c
 [<c011b1fe>] ? T.864+0x5e/0x9b
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c03e69b1>] ? __schedule+0x1e2/0x460
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c016c9ed>] ? kswapd+0x0/0x573
 [<c016c9ed>] ? kswapd+0x0/0x573
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
aio/0         S 00000000     0    21      2
 f70dff6c 00000096 092238fc 00000000 f6b50000 00001dad 00000000 09221b4f
 00000000 f6b50000 f70dffa0 00000000 c012ce0c f6bff900 f70dffa0 f70dff74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f6b50000
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
xfs_mru_cache S 00000000     0    22      2
 f70e9f6c 00000096 092365c5 00000000 f6b50c50 000013bb 00000000 0923520a
 00000000 f6b50c50 f70e9fa0 00000000 c012ce0c f6ba8280 f70e9fa0 f70e9f74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f6b50c50
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
xfslogd/0     S 00000000     0    23      2
 f70ebf6c 00000096 09241964 00000000 f6b518a0 00001217 00000000 0924074d
 00000000 f6b518a0 f70ebfa0 00000000 c012ce0c f6ba8380 f70ebfa0 f70ebf74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f6b518a0
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
xfsdatad/0    S 00000000     0    24      2
 f70fff6c 00000096 0924cd86 00000000 f6b524f0 00001159 00000000 0924bc2d
 00000000 f6b524f0 f70fffa0 00000000 c012ce0c f6ba8480 f70fffa0 f70fff74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f6b524f0
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
xfsconvertd/0 S 00000000     0    25      2
 f70e5f6c 00000096 0931f3a4 00000000 f6b53140 00001956 00000000 0931da4e
 00000000 f6b53140 f70e5fa0 00000000 c012ce0c f6ba8580 f70e5fa0 f70e5f74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f6b53140
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
crypto/0      S 00000000     0    26      2
 f6b41f6c 00000096 09340bf3 00000000 f6b53d90 000040dc 00000000 0933cb17
 00000000 f6b53d90 f6b41fa0 00000000 c012ce0c f6ba8a80 f6b41fa0 f6b41f74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f6b53d90
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
exec-osm/0    S 00000000     0    30      2
 f7133f6c 00000096 00000000 00000000 f6b55630 00000046 f6b55630 f7133f68
 f6b55630 f6b55630 f7133fa0 00000000 c012ce0c f6b63480 f7133fa0 f7133f74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f6b55630
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
kjournald2    S 000000a6     0    31      2
 f6b17f8c 00000096 f0889177 000000a6 00000286 00001a05 00000000 f0887772
 000000a6 f6b56280 c02148eb 00000001 f7067800 f7067814 f7067ba8 f6b17f94
 c03e6c37 f70678f0 c02148f0 00000000 0000001f f7067b14 00000005 00000000
Call Trace:
 [<c02148eb>] ? kjournald2+0x1f9/0x217
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02148f0>] ? kjournald2+0x1fe/0x217
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c02146f2>] ? kjournald2+0x0/0x217
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
udevd         S 00000000     0    55      1
 f6a9bb54 00000086 0079a0ca 00000000 00f34194 00000000 00190834 0001828a
 00000046 f6a8a4f0 00000000 f7155368 00000000 00000000 00000000 f6a9bb5c
 c03e6c37 f6a9bbc8 c03e7e6e 00000000 c01ae5ac 00000000 f7155368 f715532c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01ae5ac>] ? inotify_poll+0x25/0x4b
 [<c03e79ac>] ? mutex_lock_nested+0x1d5/0x280
 [<c01ae5ac>] ? inotify_poll+0x25/0x4b
 [<c01ae5cc>] ? inotify_poll+0x45/0x4b
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c034eb79>] ? qh_completions+0x393/0x449
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0119520>] ? wakeup_preempt_entity+0x125/0x12b
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c018098b>] ? dma_pool_free+0xa3/0x108
 [<c0126b55>] ? lock_timer_base+0x19/0x34
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c0126c14>] ? mod_timer+0xa4/0xf4
 [<c0126c14>] ? mod_timer+0xa4/0xf4
 [<c034f594>] ? ehci_work+0x6c4/0x8af
 [<c03515e2>] ? ehci_irq+0xfd/0x1b0
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c03515e2>] ? ehci_irq+0xfd/0x1b0
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0122fcf>] ? irq_exit+0x33/0x66
 [<c0104564>] ? do_IRQ+0x37/0x79
 [<c0130557>] ? remove_wait_queue+0xc/0x31
 [<c0173544>] ? do_wp_page+0x262/0x5c4
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c01276ea>] ? sigprocmask+0x6c/0xc5
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c019458b>] ? sys_ppoll+0x2c/0x110
 [<c0127a58>] ? sys_rt_sigprocmask+0x84/0xce
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
kpsmoused     S 00000002     0   570      2
 f71edf6c 00000096 12224253 00000002 00000282 000170cb 00000000 1220d188
 00000002 f73cd630 00000001 f64f06ac c012ce0c f64f0680 f71edfa0 f71edf74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 00000000 00000000 f73cd630
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
scsi_eh_0     S 00000002     0   595      2
 f6453f94 00000082 1673c2b7 00000002 c03e8e68 0000066b 00000000 1673bc4c
 00000002 f71ceed0 c011b1c7 f7319400 c031e33b f71bc800 f6453fc0 f6453f9c
 c03e6c37 00000000 c031e391 0000893f 00000000 f71bc8d0 f71bc8c0 f71ceed0
Call Trace:
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c031e33b>] ? scsi_error_handler+0x0/0x376
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c031e391>] ? scsi_error_handler+0x56/0x376
 [<c031e33b>] ? scsi_error_handler+0x0/0x376
 [<c031e33b>] ? scsi_error_handler+0x0/0x376
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
usb-storage   D 000000a7     0   596      2
 f71e3df0 00000082 feea9e6f 000000a7 c0417180 003eaf64 00000000 feabef0b
 000000a7 f71c98a0 00000000 fea15001 00000000 7fffffff f71bcc78 f71e3df8
 c03e6c37 7fffffff c03e6fcd f71c98a0 00000000 f71bcc88 00000046 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c03e6db1>] ? wait_for_common+0x8d/0x111
 [<c03e6db8>] ? wait_for_common+0x94/0x111
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0340255>] ? usb_sg_wait+0xea/0x12b
 [<f90e6242>] ? usb_stor_bulk_transfer_sglist+0x74/0xc1 [usb_storage]
 [<f90e62b3>] ? usb_stor_bulk_srb+0x24/0x34 [usb_storage]
 [<f90e6433>] ? usb_stor_Bulk_transport+0x105/0x2c6 [usb_storage]
 [<f90e5e61>] ? usb_stor_invoke_transport+0x18/0x2c2 [usb_storage]
 [<f90e77f3>] ? usb_stor_control_thread+0x8c/0x1b5 [usb_storage]
 [<f90e78a3>] ? usb_stor_control_thread+0x13c/0x1b5 [usb_storage]
 [<f90e7767>] ? usb_stor_control_thread+0x0/0x1b5 [usb_storage]
 [<f90e7767>] ? usb_stor_control_thread+0x0/0x1b5 [usb_storage]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
usbhid_resume S 00000002     0   601      2
 f734bf6c 00000096 17ced5bf 00000002 00000282 007cabb6 00000000 17522a09
 00000002 f73b0000 00000001 f645feac c012ce0c f645fe80 f734bfa0 f734bf74
 c03e6c37 00000000 c012d03f 00000000 c011b1c7 f7302c80 00000000 f73b0000
Call Trace:
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
saa7134[0]    S 000000a7     0   675      2
 f73fdf04 00000082 bf271890 000000a7 c07e5d80 00000000 00000000 00000000
 00000000 f73ceed0 00000001 c07e5d80 f73fdf20 c07e5d80 c07e5d80 f73fdf0c
 c03e6c37 00067dfa c03e6fa8 f91900d7 c011550b 00066a72 c07e6794 c07e6794
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<f91900d7>] ? tvaudio_sleep+0x42/0x79 [saa7134]
 [<c011550b>] ? do_page_fault+0x193/0x234
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<f91900d7>] ? tvaudio_sleep+0x42/0x79 [saa7134]
 [<f91900d7>] ? tvaudio_sleep+0x42/0x79 [saa7134]
 [<f9190e12>] ? tvaudio_thread+0x2b6/0x73e [saa7134]
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102ca4>] ? restore_nocheck_notrace+0x0/0xe
 [<f9190b5c>] ? tvaudio_thread+0x0/0x73e [saa7134]
 [<f9190b5c>] ? tvaudio_thread+0x0/0x73e [saa7134]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
kjournald2    S f71bd958     0   755      2
 f73c5f8c 00000096 f71bd948 f71bd958 00000286 f71bd8f0 c03e9183 00000000
 00000046 f6a88000 c02148eb 00000001 f71bd800 f71bd814 f71bdba8 f73c5f94
 c03e6c37 f71bd8f0 c02148f0 00000000 000002f3 f71bdb14 00000005 00000000
Call Trace:
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c02148eb>] ? kjournald2+0x1f9/0x217
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02148f0>] ? kjournald2+0x1fe/0x217
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c02146f2>] ? kjournald2+0x0/0x217
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
crond         S c05125e0     0  1031      1
 f732feec 00000092 00000001 c05125e0 00000286 00000000 c0512630 f732ff40
 0000c350 f73b3140 0000000c f732fef4 f732ff40 00000001 0000000c f732fef4
 c03e6c37 f732ff10 c03e7f07 0000c350 00000001 00000000 f732ff40 f732ff88
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7f07>] ? do_nanosleep+0x7e/0xa8
 [<c0133992>] ? hrtimer_nanosleep+0xed/0x181
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c0133a7e>] ? sys_nanosleep+0x58/0x5a
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
syslog-ng     S 00000003     0  1041      1
 f7149f10 00200082 5c32c1f6 00000003 00000000 0000adf0 00000000 5c321406
 00000003 f73b18a0 c01211dd 00000001 00000000 f73b18a0 f73b19e0 f7149f18
 c03e6c37 00000000 c0121213 f7149f64 00000000 f71df5c0 00000004 00000000
Call Trace:
 [<c01211dd>] ? do_wait+0x258/0x3a4
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0121213>] ? do_wait+0x28e/0x3a4
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0121388>] ? sys_wait4+0x5f/0xad
 [<c01213fd>] ? sys_waitpid+0x27/0x2b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
syslog-ng     S 00000001     0  1042   1041
 f733bb70 00200086 c01392f8 00000001 00200286 00000000 c0512630 f733bb8c
 05f5e100 f73b6280 f733bbd4 f733bb78 f61b6641 000001bb f73b6280 f733bb78
 c03e6c37 f733bbe4 c03e7e22 05f5e100 00000000 00000000 e34f3f40 00000000
Call Trace:
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0163560>] ? __generic_file_aio_write_nolock+0x215/0x50f
 [<c0163bb7>] ? generic_file_aio_write+0x75/0xd8
 [<c0163bb7>] ? generic_file_aio_write+0x75/0xd8
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
dbus-daemon   S 00000097     0  1082      1
 f65e9b70 00000086 3014d32f 00000097 00000282 0000d8d2 00000000 3013fa5d
 00000097 f73c98a0 00000000 f64eb468 00000000 00000000 00000000 f65e9b78
 c03e6c37 f65e9be4 c03e7e6e eb472620 00000046 00000000 00000002 00000001
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03d6f87>] ? unix_poll+0x17/0x98
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c037616b>] ? sock_aio_write+0x123/0x143
 [<c0187a35>] ? do_readv_writev+0x117/0x178
 [<c0376048>] ? sock_aio_write+0x0/0x143
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
hald          S 000000a4     0  1098      1
 f730db70 00000086 bf61fa1c 000000a4 00000286 0002c976 00000000 bf5f30a6
 000000a4 f73c8000 f730dbd4 f730db78 ba080910 000000ab f73c8000 f730db78
 c03e6c37 f730dbe4 c03e7e22 01c961d7 00000000 00000000 f6795b8c 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c011bae6>] ? enqueue_task_fair+0xaf/0xbd
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c018098b>] ? dma_pool_free+0xa3/0x108
 [<c0126b55>] ? lock_timer_base+0x19/0x34
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c0126c14>] ? mod_timer+0xa4/0xf4
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c03515e2>] ? ehci_irq+0xfd/0x1b0
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1101      1
 f71d9b70 00000086 f9d9272e 00000056 f7196af8 0000e137 00000000 f9d845f7
 00000056 f73ca4f0 00000000 f6b11768 00000000 00000000 00000000 f71d9b78
 c03e6c37 f71d9be4 c03e7e6e 00000000 c01ae5ac 00000000 f73ca4f0 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01ae5ac>] ? inotify_poll+0x25/0x4b
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c01e6f79>] ? ext4_mark_iloc_dirty+0x300/0x475
 [<c01e7fe0>] ? ext4_mark_inode_dirty+0x5a/0x19d
 [<c01a419e>] ? __find_get_block_slow+0x82/0x105
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c0118d06>] ? __wake_up_common+0x42/0x65
 [<c0144f9f>] ? wake_futex+0x27/0x33
 [<c01466be>] ? do_futex+0x5ee/0x8f9
 [<c0173544>] ? do_wp_page+0x262/0x5c4
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0173544>] ? do_wp_page+0x262/0x5c4
 [<c0174762>] ? handle_mm_fault+0x155/0x5b0
 [<c0174986>] ? handle_mm_fault+0x379/0x5b0
 [<c0133e83>] ? down_read_trylock+0x55/0x5c
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1102      1
 f65e7df4 00000086 f9db2e05 00000056 00000286 00097f5e 00000000 f9d1aea7
 00000056 f73ce280 00000001 f65e7e40 f65e7e38 c0ceca6c f65e7e30 f65e7dfc
 c03e6c37 f65e7ef4 c0144eb2 00000000 f5d3ba60 00000000 00000050 f65e7f54
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144eb2>] ? futex_wait+0x3d2/0x44b
 [<c01e47dd>] ? ext4_file_write+0x48/0x163
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c018736f>] ? do_sync_write+0xcd/0xff
 [<c02a15d8>] ? copy_to_user+0x29/0x100
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c01ad603>] ? dnotify_parent+0x1f/0x5e
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c0187fbf>] ? sys_write+0x69/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1104      1
 f732de30 00000086 f6a49c27 00000056 c0510680 00011903 00000000 f6a38324
 00000056 f73cbd90 c05106c0 00000286 00000002 00005607 c1812680 f732de38
 c03e6c37 f732deb8 c02eef67 00000000 f73cbd90 c011a8c0 c0670c24 f65ebe4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1105      1
 f65ebe30 00000086 f6ab58d5 00000056 c0510680 000293cf 00000000 f6a8c506
 00000056 f73cb140 c05106c0 00000286 00000003 00005607 c1812680 f65ebe38
 c03e6c37 f65ebeb8 c02eef67 00000000 f73cb140 c011a8c0 f732de4c f65ede4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1106      1
 f65ede30 00000086 f6ab4ec8 00000056 c0510680 0006d277 00000000 f6a47c51
 00000056 f71cc9e0 c05106c0 00000286 00000004 00005607 c1812680 f65ede38
 c03e6c37 f65edeb8 c02eef67 00000000 f71cc9e0 c011a8c0 f65ebe4c f65efe4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1107      1
 f65efe30 00000086 f6ab43c4 00000056 c0510680 0006cbb0 00000000 f6a47814
 00000056 f71ca4f0 c05106c0 00000286 00000005 00005607 c1812680 f65efe38
 c03e6c37 f65efeb8 c02eef67 00000000 f71ca4f0 c011a8c0 f65ede4c f65f3e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1109      1
 f65f3e30 00000086 f6ab396f 00000056 c0510680 0006c5b8 00000000 f6a473b7
 00000056 f71c8000 c05106c0 00000286 00000007 00005607 c1812680 f65f3e38
 c03e6c37 f65f3eb8 c02eef67 00000000 f71c8000 c011a8c0 f65efe4c f65f5e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1110      1
 f65f5e30 00000086 f6ab2f16 00000056 c0510680 0006bf72 00000000 f6a46fa4
 00000056 f71cb140 c05106c0 00000286 00000008 00005607 c1812680 f65f5e38
 c03e6c37 f65f5eb8 c02eef67 00000000 f71cb140 c011a8c0 f65f3e4c f65f7e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1111      1
 f65f7e30 00000086 f6ab256c 00000056 c0510680 0006ba02 00000000 f6a46b6a
 00000056 f71cd630 c05106c0 00000286 00000009 00005607 c1812680 f65f7e38
 c03e6c37 f65f7eb8 c02eef67 00000000 f71cd630 c011a8c0 f65f5e4c f65f9e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1112      1
 f65f9e30 00000086 f6ab1a8a 00000056 c0510680 0006b377 00000000 f6a46713
 00000056 f71c8c50 c05106c0 00000286 0000000a 00005607 c1812680 f65f9e38
 c03e6c37 f65f9eb8 c02eef67 00000000 f71c8c50 c011a8c0 f65f7e4c f65fbe4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1113      1
 f65fbe30 00000086 f6ab0ff7 00000056 c0510680 0006ad7d 00000000 f6a4627a
 00000056 f73b0c50 c05106c0 00000286 0000000b 00005607 c1812680 f65fbe38
 c03e6c37 f65fbeb8 c02eef67 00000000 f73b0c50 c011a8c0 f65f9e4c f65fde4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1114      1
 f65fde30 00000086 f6ab0463 00000056 c0510680 0006a635 00000000 f6a45e2e
 00000056 f73b24f0 c05106c0 00000286 0000000c 00005607 c1812680 f65fde38
 c03e6c37 f65fdeb8 c02eef67 00000000 f73b24f0 c011a8c0 f65fbe4c f65ffe4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1115      1
 f65ffe30 00000086 f6aafa10 00000056 c0510680 0006a036 00000000 f6a459da
 00000056 f73b49e0 c05106c0 00000286 0000000d 00005607 c1812680 f65ffe38
 c03e6c37 f65ffeb8 c02eef67 00000000 f73b49e0 c011a8c0 f65fde4c f6601e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1116      1
 f6601e30 00000086 f6aaeebf 00000056 c0510680 00069931 00000000 f6a4558e
 00000056 f73b6ed0 c05106c0 00000286 0000000e 00005607 c1812680 f6601e38
 c03e6c37 f6601eb8 c02eef67 00000000 f73b6ed0 c011a8c0 f65ffe4c f6603e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1117      1
 f6603e30 00000086 f6aae419 00000056 c0510680 0006931d 00000000 f6a450fc
 00000056 f73b5630 c05106c0 00000286 0000000f 00005607 c1812680 f6603e38
 c03e6c37 f6603eb8 c02eef67 00000000 f73b5630 c011a8c0 f6601e4c f6605e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1118      1
 f6605e30 00000086 f6aad957 00000056 c0510680 00068cda 00000000 f6a44c7d
 00000056 f73b3d90 c05106c0 00000286 00000010 00005607 c1812680 f6605e38
 c03e6c37 f6605eb8 c02eef67 00000000 f73b3d90 c011a8c0 f6603e4c f6607e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1119      1
 f6607e30 00000086 f6aace32 00000056 c0510680 00068720 00000000 f6a44712
 00000056 f6b56ed0 c05106c0 00000286 00000011 00005607 c1812680 f6607e38
 c03e6c37 f6607eb8 c02eef67 00000000 f6b56ed0 c011a8c0 f6605e4c f6609e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1120      1
 f6609e30 00000086 f6aac314 00000056 c0510680 0006805e 00000000 f6a442b6
 00000056 f6b549e0 c05106c0 00000286 00000012 00005607 c1812680 f6609e38
 c03e6c37 f6609eb8 c02eef67 00000000 f6b549e0 c011a8c0 f6607e4c f660be4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1121      1
 f660be30 00000086 f6aab88c 00000056 c0510680 00067a75 00000000 f6a43e17
 00000056 f6a88c50 c05106c0 00000286 00000013 00005607 c1812680 f660be38
 c03e6c37 f660beb8 c02eef67 00000000 f6a88c50 c011a8c0 f6609e4c f660de4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0166f8c>] ? T.1105+0x5e/0x68
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0169f7e>] ? ____pagevec_lru_add+0x133/0x144
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1122      1
 f660de30 00000086 f6aaacc8 00000056 c0510680 00067313 00000000 f6a439b5
 00000056 f6a8eed0 c05106c0 00000286 00000014 00005607 c1812680 f660de38
 c03e6c37 f660deb8 c02eef67 00000000 f6a8eed0 c011a8c0 f660be4c f660fe4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1123      1
 f660fe30 00000086 f6aaa2e2 00000056 c0510680 00066d5d 00000000 f6a43585
 00000056 f6a8e280 c05106c0 00000286 00000015 00005607 c1812680 f660fe38
 c03e6c37 f660feb8 c02eef67 00000000 f6a8e280 c011a8c0 f660de4c f6611e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1124      1
 f6611e30 00000086 f6aa985a 00000056 c0510680 0006672e 00000000 f6a4312c
 00000056 f6a8bd90 c05106c0 00000286 00000016 00005607 c1812680 f6611e38
 c03e6c37 f6611eb8 c02eef67 00000000 f6a8bd90 c011a8c0 f660fe4c f6613e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1125      1
 f6613e30 00000086 f6aa8d8e 00000056 c0510680 00066138 00000000 f6a42c56
 00000056 f6618000 c05106c0 00000286 00000017 00005607 c1812680 f6613e38
 c03e6c37 f6613eb8 c02eef67 00000000 f6618000 c011a8c0 f6611e4c f6615e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1126      1
 f6615e30 00000086 f6aa81fc 00000056 c0510680 000659a7 00000000 f6a42855
 00000056 f6618c50 c05106c0 00000286 00000018 00005607 c1812680 f6615e38
 c03e6c37 f6615eb8 c02eef67 00000000 f6618c50 c011a8c0 f6613e4c f6617e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1127      1
 f6617e30 00000086 f6aa76b3 00000056 c0510680 00065264 00000000 f6a4244f
 00000056 f66198a0 c05106c0 00000286 00000019 00005607 c1812680 f6617e38
 c03e6c37 f6617eb8 c02eef67 00000000 f66198a0 c011a8c0 f6615e4c f6621e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1128      1
 f6621e30 00000086 f6aa6d13 00000056 c0510680 00064cd1 00000000 f6a42042
 00000056 f661a4f0 c05106c0 00000286 0000001a 00005607 c1812680 f6621e38
 c03e6c37 f6621eb8 c02eef67 00000000 f661a4f0 c011a8c0 f6617e4c f6623e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0166f8c>] ? T.1105+0x5e/0x68
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0169f7e>] ? ____pagevec_lru_add+0x133/0x144
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1129      1
 f6623e30 00000086 f6aa62ec 00000056 c0510680 00064747 00000000 f6a41ba5
 00000056 f661b140 c05106c0 00000286 0000001b 00005607 c1812680 f6623e38
 c03e6c37 f6623eb8 c02eef67 00000000 f661b140 c011a8c0 f6621e4c f6625e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1130      1
 f6625e30 00000086 f6aa57cb 00000056 c0510680 00064040 00000000 f6a4178b
 00000056 f661bd90 c05106c0 00000286 0000001c 00005607 c1812680 f6625e38
 c03e6c37 f6625eb8 c02eef67 00000000 f661bd90 c011a8c0 f6623e4c f6627e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1131      1
 f6627e30 00000086 f6aa4c20 00000056 c0510680 0006392e 00000000 f6a412f2
 00000056 f661c9e0 c05106c0 00000286 0000001d 00005607 c1812680 f6627e38
 c03e6c37 f6627eb8 c02eef67 00000000 f661c9e0 c011a8c0 f6625e4c f6629e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1132      1
 f6629e30 00000086 f6aa41c7 00000056 c0510680 00063322 00000000 f6a40ea5
 00000056 f661d630 c05106c0 00000286 0000001e 00005607 c1812680 f6629e38
 c03e6c37 f6629eb8 c02eef67 00000000 f661d630 c011a8c0 f6627e4c f662be4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1133      1
 f662be30 00000086 f6aa37bc 00000056 c0510680 00062d56 00000000 f6a40a66
 00000056 f661e280 c05106c0 00000286 0000001f 00005607 c1812680 f662be38
 c03e6c37 f662beb8 c02eef67 00000000 f661e280 c011a8c0 f6629e4c f662de4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1134      1
 f662de30 00000086 f6aa2aa1 00000056 c0510680 0006242d 00000000 f6a40674
 00000056 f661eed0 c05106c0 00000286 00000020 00005607 c1812680 f662de38
 c03e6c37 f662deb8 c02eef67 00000000 f661eed0 c011a8c0 f662be4c f662fe4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1135      1
 f662fe30 00000086 f6aa20a8 00000056 c0510680 00061e49 00000000 f6a4025f
 00000056 f6630000 c05106c0 00000286 00000021 00005607 c1812680 f662fe38
 c03e6c37 f662feb8 c02eef67 00000000 f6630000 c011a8c0 f662de4c f6639e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0166f8c>] ? T.1105+0x5e/0x68
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0169f7e>] ? ____pagevec_lru_add+0x133/0x144
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1136      1
 f6639e30 00000086 f6aa16b1 00000056 c0510680 0006186c 00000000 f6a3fe45
 00000056 f6630c50 c05106c0 00000286 00000022 00005607 c1812680 f6639e38
 c03e6c37 f6639eb8 c02eef67 00000000 f6630c50 c011a8c0 f662fe4c f663be4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1137      1
 f663be30 00000086 f6aa0bdb 00000056 c0510680 000611f1 00000000 f6a3f9ea
 00000056 f66318a0 c05106c0 00000286 00000023 00005607 c1812680 f663be38
 c03e6c37 f663beb8 c02eef67 00000000 f66318a0 c011a8c0 f6639e4c f663de4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1138      1
 f663de30 00000086 f6aa0112 00000056 c0510680 00060b5e 00000000 f6a3f5b4
 00000056 f66324f0 c05106c0 00000286 00000024 00005607 c1812680 f663de38
 c03e6c37 f663deb8 c02eef67 00000000 f66324f0 c011a8c0 f663be4c f663fe4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0166f8c>] ? T.1105+0x5e/0x68
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1139      1
 f663fe30 00000086 f6a9f734 00000056 c0510680 000605a3 00000000 f6a3f191
 00000056 f6633140 c05106c0 00000286 00000025 00005607 c1812680 f663fe38
 c03e6c37 f663feb8 c02eef67 00000000 f6633140 c011a8c0 f663de4c f6641e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1140      1
 f6641e30 00000086 f6a9ed6a 00000056 c0510680 0005ffe2 00000000 f6a3ed88
 00000056 f6633d90 c05106c0 00000286 00000026 00005607 c1812680 f6641e38
 c03e6c37 f6641eb8 c02eef67 00000000 f6633d90 c011a8c0 f663fe4c f6643e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1141      1
 f6643e30 00000086 f6a9e22f 00000056 c0510680 0005f8da 00000000 f6a3e955
 00000056 f66349e0 c05106c0 00000286 00000027 00005607 c1812680 f6643e38
 c03e6c37 f6643eb8 c02eef67 00000000 f66349e0 c011a8c0 f6641e4c f6645e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1142      1
 f6645e30 00000086 f6a9d6df 00000056 c0510680 0005f197 00000000 f6a3e548
 00000056 f6635630 c05106c0 00000286 00000028 00005607 c1812680 f6645e38
 c03e6c37 f6645eb8 c02eef67 00000000 f6635630 c011a8c0 f6643e4c f6647e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1143      1
 f6647e30 00000086 f6a9ccab 00000056 c0510680 0005eb71 00000000 f6a3e13a
 00000056 f6636280 c05106c0 00000286 00000029 00005607 c1812680 f6647e38
 c03e6c37 f6647eb8 c02eef67 00000000 f6636280 c011a8c0 f6645e4c f6649e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1144      1
 f6649e30 00000086 f6a9c255 00000056 c0510680 0005e511 00000000 f6a3dd44
 00000056 f6636ed0 c05106c0 00000286 0000002a 00005607 c1812680 f6649e38
 c03e6c37 f6649eb8 c02eef67 00000000 f6636ed0 c011a8c0 f6647e4c f664be4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1145      1
 f664be30 00000086 f6a9b79b 00000056 c0510680 0005de9f 00000000 f6a3d8fc
 00000056 f6650000 c05106c0 00000286 0000002b 00005607 c1812680 f664be38
 c03e6c37 f664beb8 c02eef67 00000000 f6650000 c011a8c0 f6649e4c f664de4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0166f8c>] ? T.1105+0x5e/0x68
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1146      1
 f664de30 00000086 f6a9ac98 00000056 c0510680 0005d774 00000000 f6a3d524
 00000056 f6650c50 c05106c0 00000286 0000002c 00005607 c1812680 f664de38
 c03e6c37 f664deb8 c02eef67 00000000 f6650c50 c011a8c0 f664be4c f664fe4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1147      1
 f664fe30 00000086 f6a9a1c2 00000056 c0510680 0005d0a7 00000000 f6a3d11b
 00000056 f66518a0 c05106c0 00000286 0000002d 00005607 c1812680 f664fe38
 c03e6c37 f664feb8 c02eef67 00000000 f66518a0 c011a8c0 f664de4c f6659e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1148      1
 f6659e30 00000086 f6a997af 00000056 c0510680 0005ca6f 00000000 f6a3cd40
 00000056 f66524f0 c05106c0 00000286 0000002e 00005607 c1812680 f6659e38
 c03e6c37 f6659eb8 c02eef67 00000000 f66524f0 c011a8c0 f664fe4c f665be4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1149      1
 f665be30 00000086 f6a98d35 00000056 c0510680 0005c3fb 00000000 f6a3c93a
 00000056 f6653140 c05106c0 00000286 0000002f 00005607 c1812680 f665be38
 c03e6c37 f665beb8 c02eef67 00000000 f6653140 c011a8c0 f6659e4c f665de4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1150      1
 f665de30 00000086 f6a9816f 00000056 c0510680 0005bc3e 00000000 f6a3c531
 00000056 f6653d90 c05106c0 00000286 00000030 00005607 c1812680 f665de38
 c03e6c37 f665deb8 c02eef67 00000000 f6653d90 c011a8c0 f665be4c f665fe4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1151      1
 f665fe30 00000086 f6a97642 00000056 c0510680 0005b517 00000000 f6a3c12b
 00000056 f66549e0 c05106c0 00000286 00000031 00005607 c1812680 f665fe38
 c03e6c37 f665feb8 c02eef67 00000000 f66549e0 c011a8c0 f665de4c f6661e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1152      1
 f6661e30 00000086 f6a96b14 00000056 c0510680 0005ade2 00000000 f6a3bd32
 00000056 f6655630 c05106c0 00000286 00000032 00005607 c1812680 f6661e38
 c03e6c37 f6661eb8 c02eef67 00000000 f6655630 c011a8c0 f665fe4c f6663e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0166f8c>] ? T.1105+0x5e/0x68
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1153      1
 f6663e30 00000086 f6a960a2 00000056 c0510680 0005a730 00000000 f6a3b972
 00000056 f6656280 c05106c0 00000286 00000033 00005607 c1812680 f6663e38
 c03e6c37 f6663eb8 c02eef67 00000000 f6656280 c011a8c0 f6661e4c f6665e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1154      1
 f6665e30 00000086 f6a95667 00000056 c0510680 0005a0d0 00000000 f6a3b597
 00000056 f6656ed0 c05106c0 00000286 00000034 00005607 c1812680 f6665e38
 c03e6c37 f6665eb8 c02eef67 00000000 f6656ed0 c011a8c0 f6663e4c f6667e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1155      1
 f6667e30 00000086 f6a94c5e 00000056 c0510680 00059ad2 00000000 f6a3b18c
 00000056 f6668000 c05106c0 00000286 00000035 00005607 c1812680 f6667e38
 c03e6c37 f6667eb8 c02eef67 00000000 f6668000 c011a8c0 f6665e4c f6671e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1156      1
 f6671e30 00000086 f6a94206 00000056 c0510680 00059465 00000000 f6a3ada1
 00000056 f6668c50 c05106c0 00000286 00000036 00005607 c1812680 f6671e38
 c03e6c37 f6671eb8 c02eef67 00000000 f6668c50 c011a8c0 f6667e4c f6673e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1157      1
 f6673e30 00000086 f6a93760 00000056 c0510680 00058da3 00000000 f6a3a9bd
 00000056 f66698a0 c05106c0 00000286 00000037 00005607 c1812680 f6673e38
 c03e6c37 f6673eb8 c02eef67 00000000 f66698a0 c011a8c0 f6671e4c f6675e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1158      1
 f6675e30 00000086 f6a92c25 00000056 c0510680 00058628 00000000 f6a3a5fd
 00000056 f666a4f0 c05106c0 00000286 00000038 00005607 c1812680 f6675e38
 c03e6c37 f6675eb8 c02eef67 00000000 f666a4f0 c011a8c0 f6673e4c f6677e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1159      1
 f6677e30 00000086 f6a92220 00000056 c0510680 00058038 00000000 f6a3a1e8
 00000056 f666b140 c05106c0 00000286 00000039 00005607 c1812680 f6677e38
 c03e6c37 f6677eb8 c02eef67 00000000 f666b140 c011a8c0 f6675e4c f6679e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1160      1
 f6679e30 00000086 f6a917e7 00000056 c0510680 000579f6 00000000 f6a39df1
 00000056 f666bd90 c05106c0 00000286 0000003a 00005607 c1812680 f6679e38
 c03e6c37 f6679eb8 c02eef67 00000000 f666bd90 c011a8c0 f6677e4c f667be4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1161      1
 f667be30 00000086 f6a90c97 00000056 c0510680 00057268 00000000 f6a39a2f
 00000056 f666c9e0 c05106c0 00000286 0000003b 00005607 c1812680 f667be38
 c03e6c37 f667beb8 c02eef67 00000000 f666c9e0 c011a8c0 f6679e4c f667de4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1162      1
 f667de30 00000086 f6a901ac 00000056 c0510680 00056ba9 00000000 f6a39603
 00000056 f666d630 c05106c0 00000286 0000003c 00005607 c1812680 f667de38
 c03e6c37 f667deb8 c02eef67 00000000 f666d630 c011a8c0 f667be4c f667fe4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0166f8c>] ? T.1105+0x5e/0x68
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0169f7e>] ? ____pagevec_lru_add+0x133/0x144
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1163      1
 f667fe30 00000086 f6a8f76d 00000056 c0510680 00056584 00000000 f6a391e9
 00000056 f666e280 c05106c0 00000286 0000003d 00005607 c1812680 f667fe38
 c03e6c37 f667feb8 c02eef67 00000000 f666e280 c011a8c0 f667de4c f4e05e4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c01672cc>] ? get_page_from_freelist+0x336/0x42f
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1520      1
 f4e05e30 00000086 f6a8ebef 00000056 c0510680 00055e9d 00000000 f6a38d52
 00000056 f4d818a0 c05106c0 00000286 00000000 00005607 c1812680 f4e05e38
 c03e6c37 f4e05eb8 c02eef67 00000000 f4d818a0 c011a8c0 f667fe4c f361fe4c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0145080>] ? futex_wake+0xd5/0xe6
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1561      1
 f3529e40 00000082 f79072c4 00000056 00000282 00004ec9 00000000 f79023fb
 00000056 f34e24f0 f4596090 00000246 f3411800 f3529f54 f3529ed0 f3529e48
 c03e6c37 f3529ec0 c018d9e2 00000000 f34e24f0 c0130395 f3411824 f3411824
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c018d9e2>] ? pipe_wait+0x45/0x5b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c018e16b>] ? pipe_read+0x2c1/0x426
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c018804c>] ? vfs_read+0x8b/0x154
 [<c01873a1>] ? do_sync_read+0x0/0xff
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
console-kit-d S 00000056     0  1918      1
 f361fe30 00000086 f6aba4aa 00000056 c0510680 00003102 00000000 f6ab73a8
 00000056 f37224f0 c05106c0 00000286 00000006 00005607 c1812680 f361fe38
 c03e6c37 f361feb8 c02eef67 00000000 f37224f0 c011a8c0 f4e05e4c c0670c24
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c02eef67>] ? vt_waitactive+0x55/0x9a
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02ef9b2>] ? vt_ioctl+0xa06/0x1a84
 [<c02eefac>] ? vt_ioctl+0x0/0x1a84
 [<c02e7f06>] ? tty_ioctl+0x74/0x81c
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0145080>] ? futex_wake+0xd5/0xe6
 [<c02e7e92>] ? tty_ioctl+0x0/0x81c
 [<c0192f55>] ? vfs_ioctl+0x15/0x4d
 [<c019310a>] ? do_vfs_ioctl+0x69/0x55b
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c0193654>] ? sys_ioctl+0x58/0x6d
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
hald-runner   S 00000057     0  1164   1098
 f6681b70 00000086 02e3e511 00000057 f73c8000 0000985d 00000000 02e34cb4
 00000057 f666eed0 c01335dc 00000001 00000000 00000000 00000000 f6681b78
 c03e6c37 f6681be4 c03e7e6e f5d3c620 00000046 00000000 00000002 00000001
Call Trace:
 [<c01335dc>] ? hrtimer_try_to_cancel+0x33/0x63
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03d6f87>] ? unix_poll+0x17/0x98
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0119520>] ? wakeup_preempt_entity+0x125/0x12b
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011bae6>] ? enqueue_task_fair+0xaf/0xbd
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c019534d>] ? pollwake+0x45/0x58
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0118d06>] ? __wake_up_common+0x42/0x65
 [<c03790b2>] ? sock_def_readable+0x3c/0x68
 [<c03d8416>] ? unix_stream_sendmsg+0x241/0x33d
 [<c03e8e1b>] ? _read_unlock+0x14/0x1c
 [<c03d8416>] ? unix_stream_sendmsg+0x241/0x33d
 [<c0196d2b>] ? __d_lookup+0xfb/0x141
 [<c037616b>] ? sock_aio_write+0x123/0x143
 [<c0173544>] ? do_wp_page+0x262/0x5c4
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0173544>] ? do_wp_page+0x262/0x5c4
 [<c0174762>] ? handle_mm_fault+0x155/0x5b0
 [<c0174986>] ? handle_mm_fault+0x379/0x5b0
 [<c0133e83>] ? down_read_trylock+0x55/0x5c
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
hald-addon-in S 000000a7     0  1195   1164
 f6a95b70 00000086 3365e8fa 000000a7 f3565630 000d0108 00000000 3358e7f2
 000000a7 f668c9e0 00000001 c050e1c0 00000000 00000000 00000000 f6a95b78
 c03e6c37 f6a95be4 c03e7e6e 00000046 f6b62a50 00000000 00000000 00000002
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c035e170>] ? evdev_poll+0x20/0x47
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c03a3c29>] ? ip_finish_output+0xf8/0x237
 [<c03a1df3>] ? ip_local_out+0x53/0x56
 [<c03a35d9>] ? ip_queue_xmit+0x12c/0x343
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011bae6>] ? enqueue_task_fair+0xaf/0xbd
 [<c0118fa5>] ? __wake_up+0x19/0x43
 [<f9370743>] ? oss_spin_lock_irqsave+0xc/0x10 [osscore]
 [<f937cf54>] ? do_inputintr+0x154/0x260 [osscore]
 [<c01392c8>] ? clocksource_get_next+0xa/0x40
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c01ad603>] ? dnotify_parent+0x1f/0x5e
 [<c018804c>] ? vfs_read+0x8b/0x154
 [<c035e5e7>] ? evdev_read+0x0/0x1b5
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
hald-addon-st S 000000a7     0  1225   1164
 f66adb70 00000086 89e010d9 000000a7 00000286 00001d44 00000000 89dff395
 000000a7 f6a898a0 f66adbd4 f66adb78 005e4e0a 000000a8 f6a898a0 f66adb78
 c03e6c37 f66adbe4 c03e7e22 001e559e 00000000 00000000 f3469b8d 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0292521>] ? blk_execute_rq+0x8f/0xce
 [<c02923e8>] ? blk_end_sync_rq+0x0/0x23
 [<c029851c>] ? cfq_set_request+0xb5/0x2ca
 [<c029851c>] ? cfq_set_request+0xb5/0x2ca
 [<c0298467>] ? cfq_set_request+0x0/0x2ca
 [<c0164608>] ? mempool_free+0x69/0x6f
 [<c01855ff>] ? kmem_cache_free+0x7a/0xdc
 [<c0164608>] ? mempool_free+0x69/0x6f
 [<c0164608>] ? mempool_free+0x69/0x6f
 [<c028f465>] ? __freed_request+0x85/0x8a
 [<c0320603>] ? scsi_execute+0xdd/0x141
 [<c0320603>] ? scsi_execute+0xdd/0x141
 [<c0320708>] ? scsi_execute_req+0xa1/0x13d
 [<c0320708>] ? scsi_execute_req+0xa1/0x13d
 [<c032083a>] ? scsi_test_unit_ready+0x96/0x1a0
 [<f92c4436>] ? sd_media_changed+0x92/0x192 [sd_mod]
 [<f92c4436>] ? sd_media_changed+0x92/0x192 [sd_mod]
 [<f92c4649>] ? sd_open+0x30/0x111 [sd_mod]
 [<c01a9e65>] ? __blkdev_get+0x130/0x31d
 [<c01a9e65>] ? __blkdev_get+0x130/0x31d
 [<c01aa0ac>] ? blkdev_open+0x53/0x89
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
hald-addon-st S 000000a7     0  1227   1164
 f66d1b70 00000086 8b4cb35b 000000a7 00000286 00090521 00000000 8b43ae3a
 000000a7 f66c8000 f66d1bd4 f66d1b78 005ce6bd 000000a8 f66c8000 f66d1b78
 c03e6c37 f66d1be4 c03e7e22 001df7df 00000000 00000000 f3571e89 f3469b8c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c03e6e0a>] ? wait_for_common+0xe6/0x111
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c03e6e0a>] ? wait_for_common+0xe6/0x111
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0292521>] ? blk_execute_rq+0x8f/0xce
 [<c02923e8>] ? blk_end_sync_rq+0x0/0x23
 [<c029851c>] ? cfq_set_request+0xb5/0x2ca
 [<c029851c>] ? cfq_set_request+0xb5/0x2ca
 [<c0298467>] ? cfq_set_request+0x0/0x2ca
 [<c01855ff>] ? kmem_cache_free+0x7a/0xdc
 [<c028f808>] ? blk_put_request+0x13/0x2e
 [<c0164608>] ? mempool_free+0x69/0x6f
 [<c028f465>] ? __freed_request+0x85/0x8a
 [<f9101310>] ? ide_cd_queue_pc+0xc2/0x157 [ide_cd_mod]
 [<f9101310>] ? ide_cd_queue_pc+0xc2/0x157 [ide_cd_mod]
 [<c01a8d7b>] ? bd_claim+0x4a/0x85
 [<c0185d28>] ? __dentry_open+0x177/0x224
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
hald-addon-st S 000000a7     0  1228   1164
 f66d3b70 00000086 8c3ae755 000000a7 00000286 00000000 00000000 00000000
 00000000 f66c8c50 f66d3bd4 f66d3b78 0056f414 000000a8 f66c8c50 f66d3b78
 c03e6c37 f66d3be4 c03e7e22 001db95f 00000000 00000000 f4dbdb8d 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c03e6e0a>] ? wait_for_common+0xe6/0x111
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c03e6e0a>] ? wait_for_common+0xe6/0x111
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0292521>] ? blk_execute_rq+0x8f/0xce
 [<c02923e8>] ? blk_end_sync_rq+0x0/0x23
 [<c029851c>] ? cfq_set_request+0xb5/0x2ca
 [<c029851c>] ? cfq_set_request+0xb5/0x2ca
 [<c0298467>] ? cfq_set_request+0x0/0x2ca
 [<c01855ff>] ? kmem_cache_free+0x7a/0xdc
 [<c028f808>] ? blk_put_request+0x13/0x2e
 [<c0164608>] ? mempool_free+0x69/0x6f
 [<c028f465>] ? __freed_request+0x85/0x8a
 [<f9101310>] ? ide_cd_queue_pc+0xc2/0x157 [ide_cd_mod]
 [<f9101310>] ? ide_cd_queue_pc+0xc2/0x157 [ide_cd_mod]
 [<c01a8d7b>] ? bd_claim+0x4a/0x85
 [<c0185d28>] ? __dentry_open+0x177/0x224
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
hald-addon-ac S 000000a7     0  1231   1164
 f66d7eec 00000092 33badaad 000000a7 00000286 003a0689 00000000 3380d424
 000000a7 f66c98a0 00000001 f66d7ef4 f66d7f40 00000001 00000001 f66d7ef4
 c03e6c37 f66d7f10 c03e7f07 0000c350 00000001 00000000 f66d7f40 f66d7f88
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7f07>] ? do_nanosleep+0x7e/0xa8
 [<c0133992>] ? hrtimer_nanosleep+0xed/0x181
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c0133a7e>] ? sys_nanosleep+0x58/0x5a
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
dhcpcd        S 00000005     0  1340      1
 f66fbb70 00000086 0a3c1466 00000005 00000286 00014134 00000000 0a3ad332
 00000005 f66cd630 f66fbbd4 f66fbb78 d6139f55 0000274e f66cd630 f66fbb78
 c03e6c37 f66fbbe4 c03e7e22 05f5e100 00000000 00000000 e34f3f40 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<f9020d7e>] ? rtl8139_start_xmit+0x62/0x11b [8139too]
 [<f9020dda>] ? rtl8139_start_xmit+0xbe/0x11b [8139too]
 [<f9020dda>] ? rtl8139_start_xmit+0xbe/0x11b [8139too]
 [<c0391924>] ? __qdisc_run+0xc6/0x1f6
 [<c0391924>] ? __qdisc_run+0xc6/0x1f6
 [<c038420d>] ? dev_queue_xmit+0xfd/0x48a
 [<c038420d>] ? dev_queue_xmit+0xfd/0x48a
 [<c0384226>] ? dev_queue_xmit+0x116/0x48a
 [<c012311a>] ? local_bh_enable+0x62/0xb8
 [<c0384226>] ? dev_queue_xmit+0x116/0x48a
 [<c0384148>] ? dev_queue_xmit+0x38/0x48a
 [<c03dc3b3>] ? packet_sendmsg+0x206/0x233
 [<f902151b>] ? rtl8139_interrupt+0xa4/0x438 [8139too]
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<f902151b>] ? rtl8139_interrupt+0xa4/0x438 [8139too]
 [<c0181ff8>] ? add_partial+0xe/0x53
 [<c0182f3e>] ? __slab_free+0x81/0x2f2
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
avahi-daemon  S 000000a4     0  1344      1
 f6aa1b70 00000086 85f36ffb 000000a4 00000286 0115d663 00000000 84dd9998
 000000a4 f66ceed0 f6aa1bd4 f6aa1b78 80e656cb 000000ac f66ceed0 f6aa1b78
 c03e6c37 f6aa1be4 c03e7e22 020afeb7 00000000 00000000 f6697b8c f732ff40
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c03be4bc>] ? udp_recvmsg+0x29f/0x2f2
 [<c0378297>] ? sock_common_recvmsg+0x3e/0x50
 [<c037696d>] ? sock_recvmsg+0xf7/0x112
 [<c019bec8>] ? mnt_drop_write+0x10/0xf1
 [<c018e1da>] ? pipe_read+0x330/0x426
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c018e1da>] ? pipe_read+0x330/0x426
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c03c5243>] ? inet_ioctl+0x21/0x6b
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
avahi-daemon  S 00000004     0  1345   1344
 f66f9d5c 00000096 9de77086 00000004 f66ceed0 00061830 00000000 9de15856
 00000004 f668d630 00000000 f66d57e0 f66d5500 7fffffff f66d5808 f66f9d64
 c03e6c37 7fffffff c03e6fcd 00000046 f5e56920 00000046 00000000 00000002
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c013051b>] ? prepare_to_wait+0x11/0x41
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03d7fec>] ? unix_stream_recvmsg+0x33c/0x525
 [<c03d7ff3>] ? unix_stream_recvmsg+0x343/0x525
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c0161f80>] ? find_get_page+0x5f/0x89
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c0188104>] ? vfs_read+0x143/0x154
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
portmap       S 00000005     0  1347      1
 f731fb70 00000086 24370770 00000005 f4cfcc00 000018d2 00000000 2436ee9e
 00000005 f668eed0 00000000 00000046 00000000 00000000 00000000 f731fb78
 c03e6c37 f731fbe4 c03e7e6e 00000046 00000000 00000000 00000001 c01305ba
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03a7f7e>] ? tcp_poll+0x18/0x13d
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c012311a>] ? local_bh_enable+0x62/0xb8
 [<c0384226>] ? dev_queue_xmit+0x116/0x48a
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0378bd3>] ? release_sock+0x26/0xba
 [<c03be816>] ? udp_sendmsg+0x2be/0x692
 [<c03be816>] ? udp_sendmsg+0x2be/0x692
 [<c0123062>] ? local_bh_enable_ip+0x60/0xb6
 [<c03be816>] ? udp_sendmsg+0x2be/0x692
 [<c01a4b0b>] ? block_write_end+0x34/0x6a
 [<c03c4c37>] ? inet_sendmsg+0x23/0x4d
 [<c0376aa4>] ? sock_sendmsg+0xda/0xf5
 [<c0162f7b>] ? generic_file_buffered_write+0x1af/0x31f
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c02a14c5>] ? copy_from_user+0x2b/0x115
 [<c0376bf0>] ? sys_sendmsg+0x131/0x232
 [<c016a04a>] ? put_page+0x50/0xdb
 [<c016a098>] ? put_page+0x9e/0xdb
 [<c0377e09>] ? sys_socketcall+0x95/0x25d
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
rpc.statd     S 00000004     0  1357      1
 f66a9ac0 00000086 aa1fb359 00000004 00000000 0001f7ea 00000000 aa1dbb6f
 00000004 f66cb140 c011b1fe 00000001 00000000 00000000 0000000a f66a9ac8
 c03e6c37 f66a9b34 c03e7e6e 00000000 00000002 00000000 c011b1c7 00000000
Call Trace:
 [<c011b1fe>] ? T.864+0x5e/0x9b
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c03e69b1>] ? __schedule+0x1e2/0x460
 [<c03bd538>] ? udp_poll+0x10/0xdd
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194c89>] ? do_select+0x528/0x5d1
 [<c0194777>] ? do_select+0x16/0x5d1
 [<c01335dc>] ? hrtimer_try_to_cancel+0x33/0x63
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0384226>] ? dev_queue_xmit+0x116/0x48a
 [<c012311a>] ? local_bh_enable+0x62/0xb8
 [<c0384226>] ? dev_queue_xmit+0x116/0x48a
 [<c0384148>] ? dev_queue_xmit+0x38/0x48a
 [<c03a3c29>] ? ip_finish_output+0xf8/0x237
 [<c0378bd3>] ? release_sock+0x26/0xba
 [<c01a44c2>] ? __find_get_block+0x63/0x116
 [<c01a419e>] ? __find_get_block_slow+0x82/0x105
 [<c01a4590>] ? __getblk+0x1b/0x28d
 [<c0196d6f>] ? __d_lookup+0x13f/0x141
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194f32>] ? core_sys_select+0x200/0x2fc
 [<c0194d51>] ? core_sys_select+0x1f/0x2fc
 [<c0161f94>] ? find_get_page+0x73/0x89
 [<c0172e3f>] ? __do_fault+0x17a/0x3cd
 [<c0172fb1>] ? __do_fault+0x2ec/0x3cd
 [<c029a29a>] ? _atomic_dec_and_lock+0x22/0x28
 [<c01951c8>] ? sys_select+0x2f/0xb8
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
ntpd          S 0000004a     0  1366      1
 f6697b70 00200086 0cc21d56 0000004a 00200286 000144ed 00000000 0cc0d869
 0000004a f6a8c9e0 f6697bd4 f6697b78 0cbb2284 000000d5 f6a8c9e0 f6697b78
 c03e6c37 f6697be4 c03e7e22 05f5e100 00000000 00000000 f6729b8d e34f3f40
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0378bd3>] ? release_sock+0x26/0xba
 [<c03be816>] ? udp_sendmsg+0x2be/0x692
 [<c03be816>] ? udp_sendmsg+0x2be/0x692
 [<c0123062>] ? local_bh_enable_ip+0x60/0xb6
 [<c03be816>] ? udp_sendmsg+0x2be/0x692
 [<c03c4c37>] ? inet_sendmsg+0x23/0x4d
 [<c0376aa4>] ? sock_sendmsg+0xda/0xf5
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c01392c8>] ? clocksource_get_next+0xa/0x40
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
login         S 00000000     0  1390      1
 f6733f24 00000082 00000002 00000000 00000000 00000246 c03e9183 c068a980
 c068a98c f6738000 c01211dd 00000001 00000000 f6738000 f6738140 f6733f2c
 c03e6c37 00000003 c0121213 f6733f78 00000003 00000000 00000004 00000000
Call Trace:
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c01211dd>] ? do_wait+0x258/0x3a4
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0121213>] ? do_wait+0x28e/0x3a4
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0121388>] ? sys_wait4+0x5f/0xad
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
login         S 0000003f     0  1391      1
 f672bf24 00000082 e7db7d3b 0000003f 00000000 00008cd1 00000000 e7daf06a
 0000003f f6738c50 c01211dd 00000001 00000000 f6738c50 f6738d90 f672bf2c
 c03e6c37 00000003 c0121213 f672bf78 00000003 00000000 00000004 00000000
Call Trace:
 [<c01211dd>] ? do_wait+0x258/0x3a4
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0121213>] ? do_wait+0x28e/0x3a4
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0121388>] ? sys_wait4+0x5f/0xad
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
agetty        S 00000005     0  1392      1
 f6735e64 00000082 0957894b 00000005 00000000 00026b64 00000000 09551de7
 00000005 f673a4f0 00000000 f6692cc4 00000001 f6692800 7fffffff f6735e6c
 c03e6c37 7fffffff c03e6fcd 00000046 f66929e0 00000046 00000000 00000002
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c02ea432>] ? n_tty_read+0x14a/0x6f8
 [<c02ea6fb>] ? n_tty_read+0x413/0x6f8
 [<c02ecc25>] ? tty_ldisc_try+0xe/0x30
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02e6624>] ? tty_read+0x78/0xaa
 [<c02ea2e8>] ? n_tty_read+0x0/0x6f8
 [<c018804c>] ? vfs_read+0x8b/0x154
 [<c02e65ac>] ? tty_read+0x0/0xaa
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
agetty        S 00000005     0  1393      1
 f6737e64 00000082 095f2c34 00000005 00000000 0002a463 00000000 095c87d1
 00000005 f673b140 00000000 f676c4c4 00000001 f676c000 7fffffff f6737e6c
 c03e6c37 7fffffff c03e6fcd 00000046 f676c1e0 00000046 00000000 00000002
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c02ea432>] ? n_tty_read+0x14a/0x6f8
 [<c02ea6fb>] ? n_tty_read+0x413/0x6f8
 [<c02ecc25>] ? tty_ldisc_try+0xe/0x30
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02e6624>] ? tty_read+0x78/0xaa
 [<c02ea2e8>] ? n_tty_read+0x0/0x6f8
 [<c018804c>] ? vfs_read+0x8b/0x154
 [<c02e65ac>] ? tty_read+0x0/0xaa
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
agetty        S 00000005     0  1394      1
 f6769e64 00000082 0959f989 00000005 00000000 00025ef7 00000000 09579a92
 00000005 f673bd90 00000000 f6693cc4 00000001 f6693800 7fffffff f6769e6c
 c03e6c37 7fffffff c03e6fcd 00000046 f66939e0 00000046 00000000 00000002
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c02ea432>] ? n_tty_read+0x14a/0x6f8
 [<c02ea6fb>] ? n_tty_read+0x413/0x6f8
 [<c02ecc25>] ? tty_ldisc_try+0xe/0x30
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02e6624>] ? tty_read+0x78/0xaa
 [<c02ea2e8>] ? n_tty_read+0x0/0x6f8
 [<c018804c>] ? vfs_read+0x8b/0x154
 [<c02e65ac>] ? tty_read+0x0/0xaa
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
agetty        S 00000005     0  1395      1
 f7147e64 00000082 096195d1 00000005 00000000 002600be 00000000 093b9513
 00000005 f673c9e0 00000000 f676ccc4 00000001 f676c800 7fffffff f7147e6c
 c03e6c37 7fffffff c03e6fcd 00000046 f676c9e0 00000046 00000000 00000002
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c02ea432>] ? n_tty_read+0x14a/0x6f8
 [<c02ea6fb>] ? n_tty_read+0x413/0x6f8
 [<c02ecc25>] ? tty_ldisc_try+0xe/0x30
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02e6624>] ? tty_read+0x78/0xaa
 [<c02ea2e8>] ? n_tty_read+0x0/0x6f8
 [<c018804c>] ? vfs_read+0x8b/0x154
 [<c02e65ac>] ? tty_read+0x0/0xaa
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
rpc.mountd    S 00000004     0  1397      1
 f6731ac0 00000086 cb6dc101 00000004 f6b9d404 00031af3 00000000 cb6aa60e
 00000004 f673e280 00000000 00000046 00000000 00000000 00000005 f6731ac8
 c03e6c37 f6731b34 c03e7e6e 00000046 00000000 00000000 00000001 c01305ba
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03a7f7e>] ? tcp_poll+0x18/0x13d
 [<c03bd538>] ? udp_poll+0x10/0xdd
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194c89>] ? do_select+0x528/0x5d1
 [<c0194777>] ? do_select+0x16/0x5d1
 [<c01fd2ec>] ? ext4_ext_get_blocks+0x2b8/0xe2c
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c01fd0e6>] ? ext4_ext_get_blocks+0xb2/0xe2c
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c01fd0e6>] ? ext4_ext_get_blocks+0xb2/0xe2c
 [<c01537ac>] ? __rcu_process_callbacks+0x1fd/0x22e
 [<c01537fb>] ? rcu_process_callbacks+0x1e/0x1f
 [<c0196d6f>] ? __d_lookup+0x13f/0x141
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194f32>] ? core_sys_select+0x200/0x2fc
 [<c0194d51>] ? core_sys_select+0x1f/0x2fc
 [<c0161f94>] ? find_get_page+0x73/0x89
 [<c0172e3f>] ? __do_fault+0x17a/0x3cd
 [<c0172fb1>] ? __do_fault+0x2ec/0x3cd
 [<c01746e2>] ? handle_mm_fault+0xd5/0x5b0
 [<c01951c8>] ? sys_select+0x2f/0xb8
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
ntpd          S 000000a7     0  1410      1
 f6795b70 00200086 aac70bbc 000000a7 00200286 00000000 00000000 00000000
 00000000 f6a8b140 f6795bd4 f6795b78 28d8d6ba 000000ab f6a8b140 f6795b78
 c03e6c37 f6795be4 c03e7e22 00e4e1bf 00000000 00000000 f6aa1b8d f730db8c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c0118d06>] ? __wake_up_common+0x42/0x65
 [<c019534d>] ? pollwake+0x45/0x58
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0118d06>] ? __wake_up_common+0x42/0x65
 [<c03790b2>] ? sock_def_readable+0x3c/0x68
 [<c03d8416>] ? unix_stream_sendmsg+0x241/0x33d
 [<c03e8e1b>] ? _read_unlock+0x14/0x1c
 [<c03d8416>] ? unix_stream_sendmsg+0x241/0x33d
 [<c037616b>] ? sock_aio_write+0x123/0x143
 [<c01ad603>] ? dnotify_parent+0x1f/0x5e
 [<c0187a35>] ? do_readv_writev+0x117/0x178
 [<c0376048>] ? sock_aio_write+0x0/0x143
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
rpciod/0      S 00000005     0  1414      2
 f6797f6c 00000096 1cd2c89b 00000005 00000282 0000077f 00000000 1cd2c11c
 00000005 f66cbd90 00000001 f73091ac 00000000 f7309180 f6797fa0 f6797f74
 c03e6c37 f960e5f6 c012d03f 00000000 00000002 00000000 c012cf61 f66cbd90
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<f960e5f6>] ? xs_udp_connect_worker4+0x0/0x156 [sunrpc]
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c012cf61>] ? worker_thread+0x155/0x2e5
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
privoxy       S f66ce280     0  1416      1
 f66a3e1c 00000096 00000000 f66ce280 f66ce280 00000000 f67013bc 00000246
 00000000 f66ce280 f67013bc f66ce280 f6701380 7fffffff 00000000 f66a3e24
 c03e6c37 7fffffff c03e6fcd f67013bc 00000246 00000000 00000002 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c0378bd3>] ? release_sock+0x26/0xba
 [<c03a7af9>] ? inet_csk_accept+0xdd/0x1a7
 [<c03a7b61>] ? inet_csk_accept+0x145/0x1a7
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c03c52a9>] ? inet_accept+0x1c/0x96
 [<c0377c74>] ? sys_accept4+0xed/0x1ed
 [<c02a15d8>] ? copy_to_user+0x29/0x100
 [<c018a7b3>] ? cp_new_stat64+0xf5/0x107
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0377ddd>] ? sys_socketcall+0x69/0x25d
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
nfsd4         S f7309d3c     0  1423      2
 f67bbf6c 00000096 f7309d2c f7309d3c 00000282 f96d6d4b c03e9183 00000000
 00000046 f6688000 00000001 f7309d2c 00000000 f7309d00 f67bbfa0 f67bbf74
 c03e6c37 f96d6d4b c012d03f 00000000 00000002 00000000 c012cf61 f6688000
Call Trace:
 [<f96d6d4b>] ? laundromat_main+0x0/0x27f [nfsd]
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03e6c37>] ? schedule+0x8/0x17
 [<f96d6d4b>] ? laundromat_main+0x0/0x27f [nfsd]
 [<c012d03f>] ? worker_thread+0x233/0x2e5
 [<c012cf61>] ? worker_thread+0x155/0x2e5
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c012ce0c>] ? worker_thread+0x0/0x2e5
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
cupsd         S 00000000     0  1426      1
 f67bdef4 00200086 00000002 00000000 00000000 00200246 f66bb284 f73a6578
 f73a6588 f67398a0 c0172e3f 00000001 f71f6300 7fffffff f71f63cc f67bdefc
 c03e6c37 7fffffff c03e6fcd 00000000 f71f6310 00200046 00000000 00200046
Call Trace:
 [<c0172e3f>] ? __do_fault+0x17a/0x3cd
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c01af94f>] ? sys_epoll_wait+0x12b/0x289
 [<c01af9ed>] ? sys_epoll_wait+0x1c9/0x289
 [<c01af9f4>] ? sys_epoll_wait+0x1d0/0x289
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
lockd         S 00000005     0  1428      2
 f67d3ebc 00000096 1cd5780f 00000005 00000020 000028b0 00000000 1cd54f5f
 00000005 f67d8000 f67d8000 00000000 f67d3f54 f65d15a4 f65d15a0 f67d3ec4
 c03e6c37 7fffffff c03e6fcd 00000046 f6760da4 00000046 00000000 00000002
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<f961bb80>] ? svc_recv+0x4a5/0x707 [sunrpc]
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<c0126c14>] ? mod_timer+0xa4/0xf4
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<f966e9fc>] ? lockd+0x0/0x1c4 [lockd]
 [<f966ea8f>] ? lockd+0x93/0x1c4 [lockd]
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c03e69b1>] ? __schedule+0x1e2/0x460
 [<f966e9fc>] ? lockd+0x0/0x1c4 [lockd]
 [<f966e9fc>] ? lockd+0x0/0x1c4 [lockd]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
nfsd          S 00000005     0  1433      2
 f67bff00 00000086 1d83f5aa 00000005 c07e5d80 00abfa72 00000000 1cd7fb38
 00000005 f67dbd90 00000001 c07e5d80 f67bff1c c07e5d80 c07e5d80 f67bff08
 c03e6c37 0032b072 c03e6fa8 00000246 00000246 fffbc1f2 f4d07f1c c07e69c4
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<f96bc7d7>] ? nfsd+0x92/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
nfsd          S 00000005     0  1434      2
 f4c1ff00 00000086 1da3fe86 00000005 c07e5d80 0006c7f3 00000000 1d9d3693
 00000005 f67dc9e0 00000001 c07e5d80 f4c1ff1c c07e5d80 c07e5d80 f4c1ff08
 c03e6c37 0032b074 c03e6fa8 00000046 f6762da4 fffbc1f4 c07e69c4 f4c41f1c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<f96bc7d7>] ? nfsd+0x92/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
nfsd          S 00000005     0  1435      2
 f4c41f00 00000086 1da3e1c6 00000005 c07e5d80 00cb113b 00000000 1cd8d08b
 00000005 f67dd630 00000001 c07e5d80 f4c41f1c c07e5d80 c07e5d80 f4c41f08
 c03e6c37 0032b074 c03e6fa8 00000046 f6763da4 fffbc1f4 f4c1ff1c f4c81f1c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<f96bc7d7>] ? nfsd+0x92/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
nfsd          S 00000005     0  1436      2
 f4c81f00 00000086 1d969978 00000005 c07e5d80 00b2aa65 00000000 1ce3ef13
 00000005 f67de280 00000001 c07e5d80 f4c81f1c c07e5d80 c07e5d80 f4c81f08
 c03e6c37 0032b073 c03e6fa8 00000046 f6761da4 fffbc1f3 f4c41f1c f4ca1f1c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<f96bc7d7>] ? nfsd+0x92/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
nfsd          S 00000005     0  1437      2
 f4ca1f00 00000086 1d9680c4 00000005 c07e5d80 00bc7280 00000000 1cda0e44
 00000005 f67deed0 00000001 c07e5d80 f4ca1f1c c07e5d80 c07e5d80 f4ca1f08
 c03e6c37 0032b073 c03e6fa8 00000046 f6765da4 fffbc1f3 f4c81f1c f4cc7f1c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<f96bc7d7>] ? nfsd+0x92/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
nfsd          S 00000005     0  1438      2
 f4cc7f00 00000086 1d9667a3 00000005 c07e5d80 00bbbae3 00000000 1cdaacc0
 00000005 f6a8d630 00000001 c07e5d80 f4cc7f1c c07e5d80 c07e5d80 f4cc7f08
 c03e6c37 0032b073 c03e6fa8 00000046 f6766da4 fffbc1f3 f4ca1f1c f4ce7f1c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<f96bc7d7>] ? nfsd+0x92/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
nfsd          S 00000005     0  1439      2
 f4ce7f00 00000086 1d964cce 00000005 c07e5d80 00baf11a 00000000 1cdb5bb4
 00000005 f668e280 00000001 c07e5d80 f4ce7f1c c07e5d80 c07e5d80 f4ce7f08
 c03e6c37 0032b073 c03e6fa8 00000046 f6767da4 fffbc1f3 f4cc7f1c f4d07f1c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<f96bc7d7>] ? nfsd+0x92/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
nfsd          S 00000005     0  1440      2
 f4d07f00 00000086 1d9633bc 00000005 c07e5d80 00b9c87e 00000000 1cdc6b3e
 00000005 f66cc9e0 00000001 c07e5d80 f4d07f1c c07e5d80 c07e5d80 f4d07f08
 c03e6c37 0032b073 c03e6fa8 00000046 f658bda4 fffbc1f3 f4ce7f1c f67bff1c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<f961bb89>] ? svc_recv+0x4ae/0x707 [sunrpc]
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<f96bc7d7>] ? nfsd+0x92/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<f96bc745>] ? nfsd+0x0/0x133 [nfsd]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
famd          S 00000005     0  1443      1
 f67d7ac0 00000086 2437bc32 00000005 00000000 000eb7a0 00000000 24290492
 00000005 f67d8c50 24343028 ffe4a64b 00000000 00000000 00000004 f67d7ac8
 c03e6c37 f67d7b34 c03e7e6e 00000046 00000000 00000000 00000001 c01305ba
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03a7f7e>] ? tcp_poll+0x18/0x13d
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194c89>] ? do_select+0x528/0x5d1
 [<c0194777>] ? do_select+0x16/0x5d1
 [<c01335dc>] ? hrtimer_try_to_cancel+0x33/0x63
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0384226>] ? dev_queue_xmit+0x116/0x48a
 [<c012311a>] ? local_bh_enable+0x62/0xb8
 [<c0384226>] ? dev_queue_xmit+0x116/0x48a
 [<c0384148>] ? dev_queue_xmit+0x38/0x48a
 [<c03a3c29>] ? ip_finish_output+0xf8/0x237
 [<c0378bd3>] ? release_sock+0x26/0xba
 [<c03be4bc>] ? udp_recvmsg+0x29f/0x2f2
 [<c03be4bc>] ? udp_recvmsg+0x29f/0x2f2
 [<c0123062>] ? local_bh_enable_ip+0x60/0xb6
 [<c03be4bc>] ? udp_recvmsg+0x29f/0x2f2
 [<c0378297>] ? sock_common_recvmsg+0x3e/0x50
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194f32>] ? core_sys_select+0x200/0x2fc
 [<c0194d51>] ? core_sys_select+0x1f/0x2fc
 [<c0161f94>] ? find_get_page+0x73/0x89
 [<c0172e3f>] ? __do_fault+0x17a/0x3cd
 [<c0172fb1>] ? __do_fault+0x2ec/0x3cd
 [<c01746e2>] ? handle_mm_fault+0xd5/0x5b0
 [<c01951c8>] ? sys_select+0x2f/0xb8
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
mpd           S 000000a7     0  1450      1
 f66ffac0 00000086 deaa0496 000000a7 00000002 0000e83c 00000000 dea91c5a
 000000a7 f67da4f0 f4cf6a10 00000046 00000000 00000000 00000007 f66ffac8
 c03e6c37 f66ffb34 c03e7e6e c01305ba 00000046 00000000 f67da4f0 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c01884bd>] ? fget_light+0xaf/0xbc
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194c89>] ? do_select+0x528/0x5d1
 [<c0194777>] ? do_select+0x16/0x5d1
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c038ed1d>] ? sk_filter+0x9f/0xc2
 [<c03b9621>] ? tcp_v4_rcv+0x4a3/0x6b3
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c03b9621>] ? tcp_v4_rcv+0x4a3/0x6b3
 [<c039f6e9>] ? ip_local_deliver+0xfc/0x18f
 [<c039f6fd>] ? ip_local_deliver+0x110/0x18f
 [<c039f648>] ? ip_local_deliver+0x5b/0x18f
 [<c039f380>] ? ip_rcv+0x220/0x48d
 [<c0383265>] ? netif_receive_skb+0x1ee/0x41e
 [<c0383279>] ? netif_receive_skb+0x202/0x41e
 [<c0372b99>] ? dma_issue_pending_all+0x6/0xa9
 [<c0372bc6>] ? dma_issue_pending_all+0x33/0xa9
 [<c0372c22>] ? dma_issue_pending_all+0x8f/0xa9
 [<c0122dd6>] ? __do_softirq+0x92/0x173
 [<c0338d3c>] ? loopback_xmit+0x40/0x45
 [<c0383e2a>] ? dev_hard_start_xmit+0x161/0x340
 [<c0122ce5>] ? _local_bh_enable+0x43/0xa2
 [<c0384226>] ? dev_queue_xmit+0x116/0x48a
 [<c012311a>] ? local_bh_enable+0x62/0xb8
 [<c0384226>] ? dev_queue_xmit+0x116/0x48a
 [<c0384148>] ? dev_queue_xmit+0x38/0x48a
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194f32>] ? core_sys_select+0x200/0x2fc
 [<c0194d51>] ? core_sys_select+0x1f/0x2fc
 [<c037cc6f>] ? __kfree_skb+0xf/0x76
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01951c8>] ? sys_select+0x2f/0xb8
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
mpd           S 000000a7     0  1451      1
 f66a1df4 00000086 c5e2a685 000000a7 00000286 00000000 00000000 00000000
 00000000 f67db140 00000001 f66a1e40 f66a1e38 c0cec794 f66a1e30 f66a1dfc
 c03e6c37 f66a1ef4 c0144eb2 00000000 f9459008 00000000 f66a1e90 f937ca4d
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144eb2>] ? futex_wait+0x3d2/0x44b
 [<f937ca4d>] ? do_outputintr+0x1dd/0x430 [osscore]
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c013bc15>] ? tick_dev_program_event+0x48/0xcf
 [<c0122dd6>] ? __do_softirq+0x92/0x173
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c0122ce5>] ? _local_bh_enable+0x43/0xa2
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
mpd           S 000000a7     0  1452      1
 f73afdf4 00000086 feec5482 000000a7 00000286 00000c42 00000000 feec4840
 000000a7 f673eed0 00000001 f73afe40 f73afe38 c0cee8b0 f73afe30 f73afdfc
 c03e6c37 f73afef4 c0144eb2 00000000 00000000 00000000 00001388 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144eb2>] ? futex_wait+0x3d2/0x44b
 [<c0118d06>] ? __wake_up_common+0x42/0x65
 [<c0144f9f>] ? wake_futex+0x27/0x33
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c0122ce5>] ? _local_bh_enable+0x43/0xa2
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
mpd           S 000000a7     0  1478      1
 f4d27d7c 00000092 feec7fcd 000000a7 c07e5d80 00000000 00000000 00000000
 00000000 f66898a0 00000001 c07e5d80 f4d27d98 c07e5d80 c07e5d80 f4d27d84
 c03e6c37 00067293 c03e6fa8 00000046 f94c3014 00066ea0 c07e673c c07e673c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<f937087f>] ? oss_sleep+0xa3/0x179 [osscore]
 [<f937087f>] ? oss_sleep+0xa3/0x179 [osscore]
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<f937bc63>] ? find_output_space+0x1c3/0x6d0 [osscore]
 [<f9378e7a>] ? move_wrpointer+0xfa/0x130 [osscore]
 [<f937c4d2>] ? oss_audio_write+0x1f2/0x590 [osscore]
 [<c0145077>] ? futex_wake+0xcc/0xe6
 [<c0146133>] ? do_futex+0x63/0x8f9
 [<f9371e3f>] ? oss_cdev_write+0xcf/0xe0 [osscore]
 [<c0187e28>] ? vfs_write+0x8e/0x157
 [<f9371d70>] ? oss_cdev_write+0x0/0xe0 [osscore]
 [<c0187f97>] ? sys_write+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
zsh           S 00000001     0  1454   1390
 f66fdf94 00000082 00000002 00000001 00000000 00000046 00000246 f739e604
 f739e614 f673d630 c01277f1 00000001 bfe9d140 080dc4e0 bfe9d254 f66fdf9c
 c03e6c37 f66fdfac c0127801 00000000 00000000 f66fc000 c0102bd8 bfe9d140
Call Trace:
 [<c01277f1>] ? sys_rt_sigsuspend+0x98/0xbe
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0127801>] ? sys_rt_sigsuspend+0xa8/0xbe
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
screen        S 00000000     0  1463   1454
 f66a5fa0 00000082 00000000 00000000 c0127e5d 0806d670 0000000f 00000000
 00000012 f668b140 c0121f91 00000000 00000000 00000000 00000012 f66a5fa8
 c03e6c37 f66a4000 c0127753 c0102bd8 00000000 bfee2dd4 00000000 00000000
Call Trace:
 [<c0127e5d>] ? sys_rt_sigaction+0x5c/0x7d
 [<c0121f91>] ? alarm_setitimer+0x36/0x5c
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0127753>] ? sys_pause+0x10/0x16
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
screen        S 00000053     0  1464   1463
 f6687ac0 00000086 25f67698 00000053 c06709d0 0002944d 00000000 25f3e24b
 00000053 f6688c50 00000000 00000002 00000000 00000000 00000007 f6687ac8
 c03e6c37 f6687b34 c03e7e6e f6687b14 00000001 00000000 c06709e4 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c02ed183>] ? tty_ldisc_deref+0x43/0x69
 [<c02e6540>] ? tty_poll+0x5f/0x6c
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194c89>] ? do_select+0x528/0x5d1
 [<c0194777>] ? do_select+0x16/0x5d1
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c01392c8>] ? clocksource_get_next+0xa/0x40
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0153640>] ? __rcu_process_callbacks+0x91/0x22e
 [<c0153682>] ? __rcu_process_callbacks+0xd3/0x22e
 [<c0153682>] ? __rcu_process_callbacks+0xd3/0x22e
 [<c01537fb>] ? rcu_process_callbacks+0x1e/0x1f
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194f32>] ? core_sys_select+0x200/0x2fc
 [<c0194d51>] ? core_sys_select+0x1f/0x2fc
 [<c0118fa5>] ? __wake_up+0x19/0x43
 [<c01ad603>] ? dnotify_parent+0x1f/0x5e
 [<c01951c8>] ? sys_select+0x2f/0xb8
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
zsh           S 00000001     0  1465   1464
 f66f5f94 00000082 00000002 00000001 00000000 00000046 00000246 f739f684
 f739f694 f668bd90 c01277f1 00000001 bfa61300 080dc4e0 bfa61414 f66f5f9c
 c03e6c37 f66f5fac c0127801 00000000 00000000 f66f4000 c0102bd8 bfa61300
Call Trace:
 [<c01277f1>] ? sys_rt_sigsuspend+0x98/0xbe
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0127801>] ? sys_rt_sigsuspend+0xa8/0xbe
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
xinit         S 00000000     0  1518   1465
 f4de3f24 00000082 00000002 00000000 00000000 00000246 c03e9183 c068a980
 c068a98c f4d83140 c01211dd 00000001 00000000 f4d83140 f4d83280 f4de3f2c
 c03e6c37 00000003 c0121213 f4de3f78 00000003 00000000 00000004 00000000
Call Trace:
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c01211dd>] ? do_wait+0x258/0x3a4
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0121213>] ? do_wait+0x28e/0x3a4
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0121388>] ? sys_wait4+0x5f/0xad
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
X             S 000000a7     0  1519   1518
 f4de5ac0 00200086 f5486b88 000000a7 f4d85630 00000000 00000000 00000000
 00000000 f4d83d90 00000000 00000000 00000000 00000000 00000026 f4de5ac8
 c03e6c37 f4de5b34 c03e7e6e f4635b20 00200046 00000000 00000002 00000001
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03d6f87>] ? unix_poll+0x17/0x98
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194c89>] ? do_select+0x528/0x5d1
 [<c0194777>] ? do_select+0x16/0x5d1
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194f32>] ? core_sys_select+0x200/0x2fc
 [<c0194d51>] ? core_sys_select+0x1f/0x2fc
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c0121e28>] ? do_setitimer+0x22e/0x2ee
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c01951c8>] ? sys_select+0x2f/0xb8
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
ck-launch-ses S 00000000     0  1531   1518
 f3447f10 00000082 00000002 00000000 00000000 00000246 c03e9183 c068a980
 c068a98c f4d824f0 c01211dd 00000001 00000000 f4d824f0 f4d82630 f3447f18
 c03e6c37 00000000 c0121213 f3447f64 00000000 f34fce40 00000004 00000000
Call Trace:
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c01211dd>] ? do_wait+0x258/0x3a4
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0121213>] ? do_wait+0x28e/0x3a4
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0121388>] ? sys_wait4+0x5f/0xad
 [<c01213fd>] ? sys_waitpid+0x27/0x2b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
dbus-launch   S 00000053     0  1538      1
 f345dac0 00000086 25f68673 00000053 c06709d0 000ab5f4 00000000 25ebd07f
 00000053 f4d86280 00000000 00000002 00000000 00000000 00000006 f345dac8
 c03e6c37 f345db34 c03e7e6e f345db14 00000001 00000000 c06709e4 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c02ed183>] ? tty_ldisc_deref+0x43/0x69
 [<c02e6540>] ? tty_poll+0x5f/0x6c
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194c89>] ? do_select+0x528/0x5d1
 [<c0194777>] ? do_select+0x16/0x5d1
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0119520>] ? wakeup_preempt_entity+0x125/0x12b
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c019534d>] ? pollwake+0x45/0x58
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194f32>] ? core_sys_select+0x200/0x2fc
 [<c0194d51>] ? core_sys_select+0x1f/0x2fc
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c01746e2>] ? handle_mm_fault+0xd5/0x5b0
 [<c01951c8>] ? sys_select+0x2f/0xb8
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
dbus-daemon   S 000000a7     0  1539      1
 f345fb70 00000086 d985376d 000000a7 f71cbd90 00015a60 00000000 d983dd0d
 000000a7 f4d86ed0 00000000 f342dc68 00000000 00000000 00000000 f345fb78
 c03e6c37 f345fbe4 c03e7e6e eb504f20 00000046 00000000 00000002 00000001
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03d6f87>] ? unix_poll+0x17/0x98
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
xcompmgr      S 000000a7     0  1544   1531
 f3459b70 00000086 df945705 000000a7 c0194ba2 00003afa 00000000 df941c0b
 000000a7 f4d849e0 00000100 f3459e68 00000000 00000000 00000000 f3459b78
 c03e6c37 f3459be4 c03e7e6e f4539820 00000046 00000000 00000002 00000001
Call Trace:
 [<c0194ba2>] ? do_select+0x441/0x5d1
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03d6f87>] ? unix_poll+0x17/0x98
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c011bae6>] ? enqueue_task_fair+0xaf/0xbd
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194fa1>] ? core_sys_select+0x26f/0x2fc
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c01ad603>] ? dnotify_parent+0x1f/0x5e
 [<c0188104>] ? vfs_read+0x143/0x154
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
xscreensaver  S 000000a7     0  1545   1531
 f3461b70 00000086 b00229ba 000000a7 00000286 0003b145 00000000 affe7875
 000000a7 f4d80c50 f3461bd4 f3461b78 d9f8c679 000000a8 f4d80c50 f3461b78
 c03e6c37 f3461be4 c03e7e22 004c4757 00000000 00000000 f66d7f40 f3491b8c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c029dd11>] ? rb_insert_color+0xbd/0xe8
 [<c011bae6>] ? enqueue_task_fair+0xaf/0xbd
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c019534d>] ? pollwake+0x45/0x58
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c0174ad3>] ? handle_mm_fault+0x4c6/0x5b0
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
tilda         S 000000a7     0  1547   1531
 f3469b70 00000086 ec2aa9a7 000000a7 00000286 00000000 00000000 00000000
 00000000 f4d80000 f3469bd4 f3469b78 0fedd9f6 000000a8 f4d80000 f3469b78
 c03e6c37 f3469be4 c03e7e22 000927bf 00000000 00000000 f66d1b8c f345bb8c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c011bae6>] ? enqueue_task_fair+0xaf/0xbd
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c0118fa5>] ? __wake_up+0x19/0x43
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0126960>] ? run_timer_softirq+0x1b9/0x22f
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
tilda         S 0000003e     0  1573   1531
 f354be40 00000082 4795818b 0000003e 00000282 0000241c 00000000 47955d6f
 0000003e f34e18a0 f4596828 00000246 f3511e00 f354bf54 f354bed0 f354be48
 c03e6c37 f354bec0 c018d9e2 00000000 f34e18a0 c0130395 f3511e24 f3511e24
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c018d9e2>] ? pipe_wait+0x45/0x5b
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c018e16b>] ? pipe_read+0x2c1/0x426
 [<c0161f94>] ? find_get_page+0x73/0x89
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c018804c>] ? vfs_read+0x8b/0x154
 [<c01873a1>] ? do_sync_read+0x0/0xff
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
parcellite    S 000000a7     0  1548   1531
 f345bb70 00000086 f5485c2a 000000a7 00000286 000056ba 00000000 f5480570
 000000a7 f4d85630 f345bbd4 f345bb78 12c96d0a 000000a8 f4d85630 f345bb78
 c03e6c37 f345bbe4 c03e7e22 00078d97 00000000 00000000 f3469b8d f4da5f40
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0126960>] ? run_timer_softirq+0x1b9/0x22f
 [<c0119520>] ? wakeup_preempt_entity+0x125/0x12b
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c019534d>] ? pollwake+0x45/0x58
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194fa1>] ? core_sys_select+0x26f/0x2fc
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
deluged       ? 00000040     0  1549   1531
 f346df54 00000086 43e77b69 00000040 00000206 00002283 00000000 43e758e6
 00000040 f71ce280 f71ce3ac f7030000 f71ce280 00000011 f71ce3ac f346df5c
 c03e6c37 f7030000 c0121915 00000c34 00000008 f34b0c80 f71ce280 f346df84
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0121915>] ? do_exit+0x46a/0x63f
 [<c0121b17>] ? do_group_exit+0x2d/0x81
 [<c0121b7c>] ? sys_exit_group+0x11/0x14
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
amuled        S 000000a7     0  1550   1531
 f3493ac0 00000086 feea68d5 000000a7 00000282 00471c61 00000000 fea34c74
 000000a7 f71cbd90 f3493b24 f3493ac8 ff82e3c6 000000a7 f71cbd90 f3493ac8
 c03e6c37 f3493b34 c03e7e22 0000c350 00000000 00000000 f4dbdb8d f4da9e88
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194c89>] ? do_select+0x528/0x5d1
 [<c0194777>] ? do_select+0x16/0x5d1
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0378bd3>] ? release_sock+0x26/0xba
 [<c03be4bc>] ? udp_recvmsg+0x29f/0x2f2
 [<c03be4bc>] ? udp_recvmsg+0x29f/0x2f2
 [<c0123062>] ? local_bh_enable_ip+0x60/0xb6
 [<c0126b55>] ? lock_timer_base+0x19/0x34
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194f32>] ? core_sys_select+0x200/0x2fc
 [<c0194d51>] ? core_sys_select+0x1f/0x2fc
 [<c01527d2>] ? handle_fasteoi_irq+0x5f/0xa2
 [<c0104965>] ? handle_irq+0x15/0x30
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0122fcf>] ? irq_exit+0x33/0x66
 [<c0104564>] ? do_IRQ+0x37/0x79
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102ca4>] ? restore_nocheck_notrace+0x0/0xe
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c01951c8>] ? sys_select+0x2f/0xb8
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
amuled        S 0000003f     0  1676   1531
 f354fdf4 00000086 b172e7ed 0000003f 00000286 000014b2 00000000 b172d33b
 0000003f f3578000 00000001 f354fe40 f354fe38 c0ced1f0 f354fe30 f354fdfc
 c03e6c37 f354fef4 c0144eb2 00000000 00000000 00000000 00005a82 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144eb2>] ? futex_wait+0x3d2/0x44b
 [<c0145077>] ? futex_wake+0xcc/0xe6
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0145080>] ? futex_wake+0xd5/0xe6
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c02a15d8>] ? copy_to_user+0x29/0x100
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
amuled        S 000000a7     0  1677   1531
 f356fdf4 00000086 4dba42d3 000000a7 00000282 00000000 00000000 00000000
 00000000 f3578c50 000000a8 f356fdfc f356fe38 0000c350 000000a8 f356fdfc
 c03e6c37 f356fef4 c0144d40 0000c350 00000000 00000000 00000000 004c4b40
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144d40>] ? futex_wait+0x260/0x44b
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c0133b20>] ? ktime_get+0x11/0x31
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
amuled        S 000000a6     0  1678   1531
 f71b5df4 00000086 fae4e2f7 000000a6 00000282 00005182 00000000 fae49175
 000000a6 f357b140 000000a8 f71b5dfc f71b5e38 0000c350 000000a8 f71b5dfc
 c03e6c37 f71b5ef4 c0144d40 0000c350 00000000 00000000 f71b5e90 f937ca4d
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144d40>] ? futex_wait+0x260/0x44b
 [<f937ca4d>] ? do_outputintr+0x1dd/0x430 [osscore]
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c0133b20>] ? ktime_get+0x11/0x31
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
amuled        S 000000a6     0  1679   1531
 f3571df4 00000086 faa7e77f 000000a6 00000282 0000565b 00000000 faa79124
 000000a6 f35798a0 000000a8 f3571dfc f3571e38 0000c350 000000a8 f3571dfc
 c03e6c37 f3571ef4 c0144d40 0000c350 00000000 00000000 f3543c44 f3698000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144d40>] ? futex_wait+0x260/0x44b
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c0133b20>] ? ktime_get+0x11/0x31
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
amuled        S 000000a5     0  1680   1531
 f3573ac0 00000086 ceb4f5fe 000000a5 c0509460 00007bc2 00000000 ceb47a3c
 000000a5 f357a4f0 00000000 00000046 00000000 00000000 0000000c f3573ac8
 c03e6c37 f3573b34 c03e7e6e f467f520 f467f510 00000000 00000286 f3573e3c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c037ec57>] ? datagram_poll+0x17/0xc0
 [<c037ec57>] ? datagram_poll+0x17/0xc0
 [<c03bd538>] ? udp_poll+0x10/0xdd
 [<c01884bb>] ? fget_light+0xad/0xbc
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194c89>] ? do_select+0x528/0x5d1
 [<c0194777>] ? do_select+0x16/0x5d1
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c010fa24>] ? lapic_next_event+0x13/0x16
 [<c013ad8e>] ? clockevents_program_event+0x82/0x10b
 [<c013bc15>] ? tick_dev_program_event+0x48/0xcf
 [<c0378bd3>] ? release_sock+0x26/0xba
 [<c03be4bc>] ? udp_recvmsg+0x29f/0x2f2
 [<c03be4bc>] ? udp_recvmsg+0x29f/0x2f2
 [<c0123062>] ? local_bh_enable_ip+0x60/0xb6
 [<c03be4bc>] ? udp_recvmsg+0x29f/0x2f2
 [<c0378297>] ? sock_common_recvmsg+0x3e/0x50
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194f32>] ? core_sys_select+0x200/0x2fc
 [<c0194d51>] ? core_sys_select+0x1f/0x2fc
 [<c02a15d8>] ? copy_to_user+0x29/0x100
 [<c03776b2>] ? move_addr_to_user+0x4b/0x58
 [<c03779ce>] ? sys_recvfrom+0x11f/0x123
 [<c01466be>] ? do_futex+0x5ee/0x8f9
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c01466d0>] ? do_futex+0x600/0x8f9
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01951c8>] ? sys_select+0x2f/0xb8
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
amuled        S 000000a7     0  1683   1531
 f3583df4 00000086 da505d0e 000000a7 00000282 0033f1bd 00000000 da1c6b51
 000000a7 f357d630 000000a9 f3583dfc f3583e38 0000c350 000000a9 f3583dfc
 c03e6c37 f3583ef4 c0144d40 0000c350 00000000 00000000 4a1541c1 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144d40>] ? futex_wait+0x260/0x44b
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c0133b20>] ? ktime_get+0x11/0x31
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
amuled        S 000000a7     0  1685   1531
 f4da5eec 00000092 fd7f8e81 000000a7 00000286 00000000 00000000 00000000
 00000000 f357eed0 00000000 f4da5ef4 f4da5f40 00000001 00000000 f4da5ef4
 c03e6c37 f4da5f10 c03e7f07 0000c350 00000001 00000000 f4da5f40 f4da5f88
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7f07>] ? do_nanosleep+0x7e/0xa8
 [<c0133992>] ? hrtimer_nanosleep+0xed/0x181
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c0133a7e>] ? sys_nanosleep+0x58/0x5a
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
amuled        S 000000a7     0  1728   1531
 f4da9df4 00000086 ee418cf4 000000a7 00000282 0048682e 00000000 edf924c6
 000000a7 f34e49e0 000000a7 f4da9dfc f4da9e38 0000c350 000000a7 f4da9dfc
 c03e6c37 f4da9ef4 c0144d40 0000c350 00000000 00000000 f4da9e90 f937ca4d
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144d40>] ? futex_wait+0x260/0x44b
 [<f937ca4d>] ? do_outputintr+0x1dd/0x430 [osscore]
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c0133b20>] ? ktime_get+0x11/0x31
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
pidgin        S 000000a7     0  1551   1531
 f3495b70 00000086 f897dfcc 000000a7 00000286 00000000 00000000 00000000
 00000000 f66ca4f0 f3495bd4 f3495b78 8c3bc8bb 000000a8 f66ca4f0 f3495b78
 c03e6c37 f3495be4 c03e7e22 0025cbc7 00000000 00000000 f356fe88 00000000
Call Trace:
 [<f897dfcc>] ? _nv012829rm+0x5f4/0xde6 [nvidia]
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c0378297>] ? sock_common_recvmsg+0x3e/0x50
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
qwit          S 000000a7     0  1552   1531
 f3491b70 00200086 d0777b74 000000a7 00200286 00000000 00000000 00000000
 00000000 f73c8c50 f3491bd4 f3491b78 f8673df2 000000a8 f73c8c50 f3491b78
 c03e6c37 f3491be4 c03e7e22 004bc287 00000000 00000000 f3461b8d f3583e88
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<f8b30079>] ? _nv004146rm+0x6c/0x34f [nvidia]
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c019534d>] ? pollwake+0x45/0x58
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0126960>] ? run_timer_softirq+0x1b9/0x22f
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
qwit          S 00000096     0  1777   1531
 f35efdf4 00200086 0d61c257 00000096 00200286 00006ba0 00000000 0d6156b7
 00000096 f35c8000 00000001 f35efe40 f35efe38 c0ced0ec f35efe30 f35efdfc
 c03e6c37 f35efef4 c0144eb2 00000000 00200246 00000000 00000000 c0660c50
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144eb2>] ? futex_wait+0x3d2/0x44b
 [<c018736f>] ? do_sync_write+0xcd/0xff
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c01ad603>] ? dnotify_parent+0x1f/0x5e
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c0187fbf>] ? sys_write+0x69/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
osmo          S 000000a7     0  1553   1531
 f34adb70 00200086 f0d92142 000000a7 00200286 00356459 00000000 f0a3bce9
 000000a7 f67d98a0 f34adbd4 f34adb78 2c73da3f 000000a8 f67d98a0 f34adb78
 c03e6c37 f34adbe4 c03e7e22 000f423f 00000000 00000000 f71b5e88 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c011bae6>] ? enqueue_task_fair+0xaf/0xbd
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c019534d>] ? pollwake+0x45/0x58
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c02a15d8>] ? copy_to_user+0x29/0x100
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
qstardict     S 00000080     0  1554   1531
 f34b3b70 00200086 d6bcf30f 00000080 f4d83d90 0001260b 00000000 d6bbcd04
 00000080 f668a4f0 f4de1c10 00200046 00000000 00000000 00000000 f34b3b78
 c03e6c37 f34b3be4 c03e7e6e eb473b20 00200046 00000000 00000002 00000001
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03d6f87>] ? unix_poll+0x17/0x98
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c019534d>] ? pollwake+0x45/0x58
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c0188104>] ? vfs_read+0x143/0x154
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
awesome       S 000000a7     0  1570   1531
 f3507ef4 00000086 e017d8f1 000000a7 c07e5d80 00000000 00000000 00000000
 00000000 f34e0c50 00000001 c07e5d80 f3507f10 c07e5d80 c07e5d80 f3507efc
 c03e6c37 0006705e c03e6fa8 00000000 f353c710 00066c9b c07e672c c0680298
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<c01af9f4>] ? sys_epoll_wait+0x1d0/0x289
 [<c01af9f4>] ? sys_epoll_wait+0x1d0/0x289
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
gnome-pty-hel S 0000003e     0  1571   1547
 f3519d5c 00000096 46c48708 0000003e f4d80000 000009d9 00000000 46c47d2f
 0000003e f34e0000 00000000 f34df460 f34df180 7fffffff f34df488 f3519d64
 c03e6c37 7fffffff c03e6fcd 00000046 f45ebb20 00000046 00000000 00000002
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c013051b>] ? prepare_to_wait+0x11/0x41
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03d7fec>] ? unix_stream_recvmsg+0x33c/0x525
 [<c03d7ff3>] ? unix_stream_recvmsg+0x343/0x525
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c02036e1>] ? ext4_discard_preallocations+0x2cf/0x358
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c0188104>] ? vfs_read+0x143/0x154
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
zsh           S 0000005f     0  1572   1547
 f3549e64 00000082 a992a873 0000005f c06709d0 000099c2 00000000 a9920eb1
 0000005f f34e3140 00000000 f34524c4 00000001 f3452000 7fffffff f3549e6c
 c03e6c37 7fffffff c03e6fcd 00000046 f34521e0 00000046 00000000 00000002
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c02ea432>] ? n_tty_read+0x14a/0x6f8
 [<c02ea6fb>] ? n_tty_read+0x413/0x6f8
 [<c02ecc25>] ? tty_ldisc_try+0xe/0x30
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c02e6624>] ? tty_read+0x78/0xaa
 [<c02ea2e8>] ? n_tty_read+0x0/0x6f8
 [<c018804c>] ? vfs_read+0x8b/0x154
 [<c0133e83>] ? down_read_trylock+0x55/0x5c
 [<c02e65ac>] ? tty_read+0x0/0xaa
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
zsh           S 00000040     0  1689   1391
 f4da1f94 00000082 7b8de542 00000040 00000000 001b3d2f 00000000 7b72a813
 00000040 f34e6ed0 c01277f1 00000001 bfff7920 080dc4e0 bfff7a34 f4da1f9c
 c03e6c37 f4da1fac c0127801 00000000 00000000 f4da0000 c0102bd8 bfff7920
Call Trace:
 [<c01277f1>] ? sys_rt_sigsuspend+0x98/0xbe
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0127801>] ? sys_rt_sigsuspend+0xa8/0xbe
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
gvfsd         S 00000053     0  1695      1
 f4dbfb70 00000086 2801094f 00000053 f4d86ed0 00011783 00000000 27fff1cc
 00000053 f34e3d90 f4d3c410 00000046 00000000 00000000 00000000 f4dbfb78
 c03e6c37 f4dbfbe4 c03e7e6e f4780c20 00000046 00000000 00000002 00000001
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03d6f87>] ? unix_poll+0x17/0x98
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c029dccc>] ? rb_insert_color+0x78/0xe8
 [<c011bae6>] ? enqueue_task_fair+0xaf/0xbd
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c019534d>] ? pollwake+0x45/0x58
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c01ad603>] ? dnotify_parent+0x1f/0x5e
 [<c0188104>] ? vfs_read+0x143/0x154
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
gvfs-fuse-dae S 00000040     0  1706      1
 f4d21df4 00000086 0e032db4 00000040 00000286 00096510 00000000 0df9c8a4
 00000040 f3563140 00000001 f4d21e40 f4d21e38 c0ced0ec f4d21e30 f4d21dfc
 c03e6c37 f4d21ef4 c0144eb2 00000000 00000000 00000000 00000000 004c4b40
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144eb2>] ? futex_wait+0x3d2/0x44b
 [<c0144f9f>] ? wake_futex+0x27/0x33
 [<c0145077>] ? futex_wake+0xcc/0xe6
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c0145080>] ? futex_wake+0xd5/0xe6
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c011b1fe>] ? T.864+0x5e/0x9b
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c011b1fe>] ? T.864+0x5e/0x9b
 [<c011b1c7>] ? T.864+0x27/0x9b
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c03e95d2>] ? error_code+0x6a/0x70
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
gvfs-fuse-dae S 00000093     0  1707      1
 f4d61de8 00000096 6313855c 00000093 00000282 000015be 00000000 63136f9e
 00000093 f3563d90 f8032317 00000001 f4d34c00 f4d34cb8 f4d61f54 f4d61df0
 c03e6c37 f4d61ec0 f803231c f4db2198 f4d61e60 f4d61f54 f4d34cc8 f4e03000
Call Trace:
 [<f8032317>] ? fuse_dev_read+0x2ec/0x530 [fuse]
 [<c03e6c37>] ? schedule+0x8/0x17
 [<f803231c>] ? fuse_dev_read+0x2f1/0x530 [fuse]
 [<c0187270>] ? do_sync_readv_writev+0xbe/0xf0
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<f8031c76>] ? fuse_dev_write+0x0/0x3b5 [fuse]
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c018804c>] ? vfs_read+0x8b/0x154
 [<c01873a1>] ? do_sync_read+0x0/0xff
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
gvfs-fuse-dae S 00000093     0  1708      1
 f4d59de8 00000096 624f7301 00000093 00000282 000015fe 00000000 624f5d03
 00000093 f35649e0 f8032317 00000001 f4d34c00 f4d34cb8 f4d59f54 f4d59df0
 c03e6c37 f4d59ec0 f803231c f4db2198 f4d59e60 f4d59f54 f4d34cc8 f4e03000
Call Trace:
 [<f8032317>] ? fuse_dev_read+0x2ec/0x530 [fuse]
 [<c03e6c37>] ? schedule+0x8/0x17
 [<f803231c>] ? fuse_dev_read+0x2f1/0x530 [fuse]
 [<c0187270>] ? do_sync_readv_writev+0xbe/0xf0
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<f8031c76>] ? fuse_dev_write+0x0/0x3b5 [fuse]
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c018804c>] ? vfs_read+0x8b/0x154
 [<c01873a1>] ? do_sync_read+0x0/0xff
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
gvfs-fuse-dae S 00000085     0  1709      1
 f4d9bb70 00000086 e7df4a3b 00000085 f4d86ed0 00015140 00000000 e7ddf8fb
 00000085 f3560000 f4d3c810 00000046 00000000 00000000 00000000 f4d9bb78
 c03e6c37 f4d9bbe4 c03e7e6e f4780920 00000046 00000000 00000002 00000001
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03d6f87>] ? unix_poll+0x17/0x98
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c011bae6>] ? enqueue_task_fair+0xaf/0xbd
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c019534d>] ? pollwake+0x45/0x58
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c0161f80>] ? find_get_page+0x5f/0x89
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c0188104>] ? vfs_read+0x143/0x154
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
deluged       S 000000a7     0  1714      1
 f4dbdb70 00200086 fcf87bc4 000000a7 00200286 003493e0 00000000 fcc3e7e4
 000000a7 f35618a0 f4dbdbd4 f4dbdb78 ffe41db3 000000a7 f35618a0 f4dbdb78
 c03e6c37 f4dbdbe4 c03e7e22 0000c350 00000000 00000000 f66d1b8c f66d3b8c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c038420d>] ? dev_queue_xmit+0xfd/0x48a
 [<c038420d>] ? dev_queue_xmit+0xfd/0x48a
 [<c0384226>] ? dev_queue_xmit+0x116/0x48a
 [<c012311a>] ? local_bh_enable+0x62/0xb8
 [<c0384226>] ? dev_queue_xmit+0x116/0x48a
 [<c0384148>] ? dev_queue_xmit+0x38/0x48a
 [<c03a3c29>] ? ip_finish_output+0xf8/0x237
 [<c03a1df3>] ? ip_local_out+0x53/0x56
 [<c03a35d9>] ? ip_queue_xmit+0x12c/0x343
 [<c0119520>] ? wakeup_preempt_entity+0x125/0x12b
 [<c0119520>] ? wakeup_preempt_entity+0x125/0x12b
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c018098b>] ? dma_pool_free+0xa3/0x108
 [<c01392c8>] ? clocksource_get_next+0xa/0x40
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0126960>] ? run_timer_softirq+0x1b9/0x22f
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c0126960>] ? run_timer_softirq+0x1b9/0x22f
 [<c013bc15>] ? tick_dev_program_event+0x48/0xcf
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
deluged       S 00000085     0  1767      1
 f4febdf4 00200086 6e790f24 00000085 00200286 001cebd4 00000000 6e5c2350
 00000085 f357bd90 00000001 f4febe40 f4febe38 c0cedf58 f4febe30 f4febdfc
 c03e6c37 f4febef4 c0144eb2 00000000 c0660b80 00000000 f357bd90 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144eb2>] ? futex_wait+0x3d2/0x44b
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c013bc15>] ? tick_dev_program_event+0x48/0xcf
 [<c0122dd6>] ? __do_softirq+0x92/0x173
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c0122ce5>] ? _local_bh_enable+0x43/0xa2
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
deluged       S 000000a7     0  1769      1
 f359fef4 00200086 fe1fe23a 000000a7 c07e5d80 00000000 00000000 00000000
 00000000 f357e280 00000001 c07e5d80 f359ff10 c07e5d80 c07e5d80 f359fefc
 c03e6c37 00067173 c03e6fa8 00000000 f4d3a210 00066e93 c07e6734 c07e6734
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fa8>] ? schedule_timeout+0xdf/0x165
 [<c0126e03>] ? process_timeout+0x0/0x5
 [<c01af9f4>] ? sys_epoll_wait+0x1d0/0x289
 [<c01af9f4>] ? sys_epoll_wait+0x1d0/0x289
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
deluged       S 00000042     0  1770      1
 f35a1df4 00200086 42852da2 00000042 00200286 00055288 00000000 427fdb1a
 00000042 f357c9e0 00000001 f35a1e40 f35a1e38 c0cec31c f35a1e30 f35a1dfc
 c03e6c37 f35a1ef4 c0144eb2 00000000 00000001 00000000 00000000 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144eb2>] ? futex_wait+0x3d2/0x44b
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c029a29a>] ? _atomic_dec_and_lock+0x22/0x28
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c01859b5>] ? filp_close+0x3e/0x5b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
deluged       S 0000006b     0  1773      1
 f35bbdf4 00200086 6446c3fe 0000006b 00200286 000030d1 00000000 6446932d
 0000006b f34e5630 00000001 f35bbe40 f35bbe38 c0cee87c f35bbe30 f35bbdfc
 c03e6c37 f35bbef4 c0144eb2 00000000 00000000 00000000 000360ce 00000000
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0144eb2>] ? futex_wait+0x3d2/0x44b
 [<c0118d06>] ? __wake_up_common+0x42/0x65
 [<c01afc3a>] ? ep_poll_callback+0x9b/0xc4
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0146160>] ? do_futex+0x90/0x8f9
 [<c01ad603>] ? dnotify_parent+0x1f/0x5e
 [<c0146a59>] ? sys_futex+0x90/0xef
 [<c0187fbf>] ? sys_write+0x69/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
deluged       S 00000053     0  1775      1
 f3591ac0 00200086 22db9920 00000053 f35cd630 0005025e 00000000 22d696c2
 00000053 f34e6280 ffd99f9f fffefdfd 00000000 00000000 00000005 f3591ac8
 c03e6c37 f3591b34 c03e7e6e 00200046 00000000 00000000 00000001 c01305ba
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03a7f7e>] ? tcp_poll+0x18/0x13d
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194c89>] ? do_select+0x528/0x5d1
 [<c0194777>] ? do_select+0x16/0x5d1
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c01926b0>] ? send_sigio+0x18c/0x1cc
 [<c0180f60>] ? dma_pool_alloc+0x1d/0x2ed
 [<c01810a6>] ? dma_pool_alloc+0x163/0x2ed
 [<c01810a6>] ? dma_pool_alloc+0x163/0x2ed
 [<c03e8e1b>] ? _read_unlock+0x14/0x1c
 [<c01926b0>] ? send_sigio+0x18c/0x1cc
 [<c0355611>] ? uhci_alloc_td+0x12/0x39
 [<c01392c8>] ? clocksource_get_next+0xa/0x40
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c0194f32>] ? core_sys_select+0x200/0x2fc
 [<c0194d51>] ? core_sys_select+0x1f/0x2fc
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0153769>] ? __rcu_process_callbacks+0x1ba/0x22e
 [<c01537ac>] ? __rcu_process_callbacks+0x1fd/0x22e
 [<c01537ac>] ? __rcu_process_callbacks+0x1fd/0x22e
 [<c01537fb>] ? rcu_process_callbacks+0x1e/0x1f
 [<c0122dd6>] ? __do_softirq+0x92/0x173
 [<c01951c8>] ? sys_select+0x2f/0xb8
 [<c02a1050>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
gconfd-2      S 000000a2     0  1716      1
 f6729b70 00000086 445c3b86 000000a2 00000286 00013ce5 00000000 445afea1
 000000a2 f35624f0 f6729bd4 f6729b78 3f119996 000000a9 f35624f0 f6729b78
 c03e6c37 f6729be4 c03e7e22 01c965bf 00000000 00000000 f3571e88 f6697b8c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e22>] ? schedule_hrtimeout_range+0xd2/0x130
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c037908a>] ? sock_def_readable+0x14/0x68
 [<c03d8416>] ? unix_stream_sendmsg+0x241/0x33d
 [<c03e8e1b>] ? _read_unlock+0x14/0x1c
 [<c03d8416>] ? unix_stream_sendmsg+0x241/0x33d
 [<c037616b>] ? sock_aio_write+0x123/0x143
 [<c01392c8>] ? clocksource_get_next+0xa/0x40
 [<c01392f8>] ? clocksource_get_next+0x3a/0x40
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0126960>] ? run_timer_softirq+0x1b9/0x22f
 [<c03e8e68>] ? _spin_unlock_irq+0x20/0x23
 [<c0126960>] ? run_timer_softirq+0x1b9/0x22f
 [<c013bc15>] ? tick_dev_program_event+0x48/0xcf
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0133ae2>] ? ktime_get_ts+0x1d/0x4a
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
screen        S 000000a5     0  1717   1689
 f4daffa0 00000082 c3a307d6 000000a5 c0127e5d 00007aa7 00000000 c3a28d2f
 000000a5 f3560c50 c0121f91 00000000 00000000 00000000 00000012 f4daffa8
 c03e6c37 f4dae000 c0127753 c0102bd8 00000000 bfea81a4 00000000 00000000
Call Trace:
 [<c0127e5d>] ? sys_rt_sigaction+0x5c/0x7d
 [<c0121f91>] ? alarm_setitimer+0x36/0x5c
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0127753>] ? sys_pause+0x10/0x16
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
screen        R running      0  1718   1717
 f4d6ffa4 00000086 feed3130 000000a7 c02e65ac 00000de3 00000000 feed234d
 000000a7 f3565630 c01881bb f4d6ff98 00000006 09184d60 bfea70b8 f4d6ffac
 c03e6c37 f4d6e000 c0102cea 00000006 bfea70b8 00001000 09184d60 bfea70b8
Call Trace:
 [<c02e65ac>] ? tty_read+0x0/0xaa
 [<c01881bb>] ? sys_read+0x41/0x6b
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0102cea>] ? work_resched+0x5/0x2a
zsh           S 00000001     0  1719   1718
 f4d51f94 00000082 00000002 00000001 00000000 00000046 00000246 f3537c04
 f3537c14 f3566280 c01277f1 00000001 bff092b0 080dc4e0 bff093c4 f4d51f9c
 c03e6c37 f4d51fac c0127801 00000000 00000000 f4d50000 c0102bd8 bff092b0
Call Trace:
 [<c01277f1>] ? sys_rt_sigsuspend+0x98/0xbe
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0127801>] ? sys_rt_sigsuspend+0xa8/0xbe
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
gvfs-hal-volu S c05125e0     0  1861      1
 f36f3b70 00000086 00000001 c05125e0 00000282 c05125e0 00000282 00000282
 f35cc9e0 f35cc9e0 00000000 f36b3868 00000000 00000000 00000000 f36f3b78
 c03e6c37 f36f3be4 c03e7e6e 00000000 c01ae5ac 00000000 f36b3868 f36b382c
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01ae5ac>] ? inotify_poll+0x25/0x4b
 [<c03e79ac>] ? mutex_lock_nested+0x1d5/0x280
 [<c01ae5ac>] ? inotify_poll+0x25/0x4b
 [<c01ae5cc>] ? inotify_poll+0x45/0x4b
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c019534d>] ? pollwake+0x45/0x58
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0118d06>] ? __wake_up_common+0x42/0x65
 [<c03790b2>] ? sock_def_readable+0x3c/0x68
 [<c03d8416>] ? unix_stream_sendmsg+0x241/0x33d
 [<c03e8e1b>] ? _read_unlock+0x14/0x1c
 [<c03d8416>] ? unix_stream_sendmsg+0x241/0x33d
 [<c037616b>] ? sock_aio_write+0x123/0x143
 [<c01ad603>] ? dnotify_parent+0x1f/0x5e
 [<c01729c4>] ? might_fault+0x34/0x86
 [<c01729f5>] ? might_fault+0x65/0x86
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
gvfs-gphoto2- S 00000067     0  1864      1
 f36f7b70 00000086 59f384a4 00000067 f73c98a0 000165ee 00000000 59f21eb6
 00000067 f35ceed0 f36e9410 00000046 00000000 00000000 00000000 f36f7b78
 c03e6c37 f36f7be4 c03e7e6e eb473820 00000046 00000000 00000002 00000001
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7e6e>] ? schedule_hrtimeout_range+0x11e/0x130
 [<c01305ba>] ? add_wait_queue+0xf/0x30
 [<c03e9183>] ? _spin_lock_irqsave+0x65/0x6e
 [<c03d6f87>] ? unix_poll+0x17/0x98
 [<c019410b>] ? poll_schedule_timeout+0x26/0x3c
 [<c0194477>] ? do_sys_poll+0x2e1/0x3c9
 [<c0195251>] ? __pollwait+0x0/0xb7
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c0195308>] ? pollwake+0x0/0x58
 [<c011bae6>] ? enqueue_task_fair+0xaf/0xbd
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c011a7bb>] ? try_to_wake_up+0x77/0x17c
 [<c019534d>] ? pollwake+0x45/0x58
 [<c037c4eb>] ? skb_dequeue+0xf/0x47
 [<c037c519>] ? skb_dequeue+0x3d/0x47
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03d7eba>] ? unix_stream_recvmsg+0x20a/0x525
 [<c03762b4>] ? sock_aio_read+0x129/0x137
 [<c0161f80>] ? find_get_page+0x5f/0x89
 [<c018746e>] ? do_sync_read+0xcd/0xff
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c01ad603>] ? dnotify_parent+0x1f/0x5e
 [<c0188104>] ? vfs_read+0x143/0x154
 [<c01946c9>] ? sys_poll+0x5a/0xb4
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
su            S 00000057     0  1956   1719
 f36b1f10 00000082 d62a9472 00000057 00000000 001e8ccd 00000000 d60c07a5
 00000057 f37249e0 c01211dd 00000001 00000000 f37249e0 f3724b20 f36b1f18
 c03e6c37 00000003 c0121213 f36b1f64 00000003 00000000 00000006 00000000
Call Trace:
 [<c01211dd>] ? do_wait+0x258/0x3a4
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0121213>] ? do_wait+0x28e/0x3a4
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<c0121388>] ? sys_wait4+0x5f/0xad
 [<c01213fd>] ? sys_waitpid+0x27/0x2b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
zsh           R running      0  1958   1956
 00000002 dad28300 00000002 080d4920 f36f5f8c c0187e28 f36f5f98 c0133e83
 c01c0537 f3655f20 dad28300 fffffff7 080d4920 f36f5fac c0187f97 f36f5f98
 00000000 00000000 00000000 00000001 00000002 f36f4000 c0102bd8 00000001
Call Trace:
 [<c0187e28>] ? vfs_write+0x8e/0x157
 [<c0133e83>] ? down_read_trylock+0x55/0x5c
 [<c01c0537>] ? proc_reg_write+0x0/0x79
 [<c0187f97>] ? sys_write+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
segctord      D 000000a7     0  2053      2
 e3537d68 00000092 fea1ecf7 000000a7 f71c98a0 00000000 00000000 00000000
 00000000 f3723d90 c068afd4 c03e8eb8 00000000 7fffffff e3537ec4 e3537d70
 c03e6c37 7fffffff c03e6fcd f3723d90 00000000 e3537ed4 00000046 00000000
Call Trace:
 [<c03e8eb8>] ? _spin_unlock+0x14/0x1c
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e6fcd>] ? schedule_timeout+0x104/0x165
 [<c03e6db1>] ? wait_for_common+0x8d/0x111
 [<c03e6db8>] ? wait_for_common+0x94/0x111
 [<c011a8c0>] ? default_wake_function+0x0/0xc
 [<f8249250>] ? nilfs_segbuf_wait+0x1b/0x52 [nilfs2]
 [<f824b8e4>] ? nilfs_segctor_do_construct+0xa6b/0x18da [nilfs2]
 [<f824c922>] ? nilfs_segctor_construct+0x75/0x7e [nilfs2]
 [<f824d4eb>] ? nilfs_segctor_thread+0x10c/0x2d3 [nilfs2]
 [<f824cf5a>] ? nilfs_construction_timeout+0x0/0x5 [nilfs2]
 [<f824d3df>] ? nilfs_segctor_thread+0x0/0x2d3 [nilfs2]
 [<c01300dd>] ? kthread+0x40/0x69
 [<c013009d>] ? kthread+0x0/0x69
 [<c0103437>] ? kernel_thread_helper+0x7/0x10
nilfs_cleaner S 00000000     0  2054      1
 e34f3eec 00000092 00000246 00000000 00000286 00000000 c0512630 e34f3f40
 0000c350 f3725630 00000346 e34f3ef4 e34f3f40 00000001 00000346 e34f3ef4
 c03e6c37 e34f3f10 c03e7f07 0000c350 00000001 00000000 e34f3f40 e34f3f88
Call Trace:
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e7f07>] ? do_nanosleep+0x7e/0xa8
 [<c0133992>] ? hrtimer_nanosleep+0xed/0x181
 [<c0132f32>] ? hrtimer_wakeup+0x0/0x18
 [<c013389f>] ? hrtimer_start_range_ns+0x21/0x27
 [<c0133a7e>] ? sys_nanosleep+0x58/0x5a
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
zsh           S 000000a1     0  2114   1718
 f35a3f94 00000082 eea7e636 000000a1 00000000 0001e5fe 00000000 eea60038
 000000a1 f3720000 c01277f1 00000001 bf90b650 080dc4e0 bf90b764 f35a3f9c
 c03e6c37 f35a3fac c0127801 00000000 00000000 f35a2000 c0102bd8 bf90b650
Call Trace:
 [<c01277f1>] ? sys_rt_sigsuspend+0x98/0xbe
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0127801>] ? sys_rt_sigsuspend+0xa8/0xbe
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36
unrar         D 00000001     0  2334   2114
 dac7bce0 00000082 00000002 00000001 00000000 00000046 5391a7f0 f35f394c
 f35f395c f3726ed0 c03e8ad3 00000001 f35f3948 dac7bd14 f3726ed0 dac7bce8
 c03e6c37 fffe0001 c03e8adf f35f394c f35f3970 00000246 00000000 f35f3948
Call Trace:
 [<c03e8ad3>] ? rwsem_down_failed_common+0x73/0x168
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c03e8adf>] ? rwsem_down_failed_common+0x7f/0x168
 [<c03e8c03>] ? rwsem_down_read_failed+0x1a/0x23
 [<c03e8c13>] ? call_rwsem_down_read_failed+0x7/0xc
 [<c03e80b4>] ? down_read+0x71/0x8d
 [<f824dceb>] ? nilfs_transaction_begin+0x9d/0x115 [nilfs2]
 [<f824dceb>] ? nilfs_transaction_begin+0x9d/0x115 [nilfs2]
 [<f823b111>] ? nilfs_write_begin+0x26/0x90 [nilfs2]
 [<c03e6c37>] ? schedule+0x8/0x17
 [<c0162ee2>] ? generic_file_buffered_write+0x116/0x31f
 [<c0163560>] ? __generic_file_aio_write_nolock+0x215/0x50f
 [<c0163b97>] ? generic_file_aio_write+0x55/0xd8
 [<c0163bac>] ? generic_file_aio_write+0x6a/0xd8
 [<c018736f>] ? do_sync_write+0xcd/0xff
 [<c013811a>] ? getnstimeofday+0x4d/0x10a
 [<c0130395>] ? autoremove_wake_function+0x0/0x33
 [<c0282a70>] ? security_file_permission+0xc/0xd
 [<c01874fd>] ? rw_verify_area+0x5d/0xc2
 [<c01ad603>] ? dnotify_parent+0x1f/0x5e
 [<c0187e28>] ? vfs_write+0x8e/0x157
 [<c01872a2>] ? do_sync_write+0x0/0xff
 [<c0187f97>] ? sys_write+0x41/0x6b
 [<c0102bd8>] ? sysenter_do_call+0x12/0x36

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--LQksG6bCIzRHxTLp--
