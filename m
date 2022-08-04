From: syzbot <syzbot+7381dc4ad60658ca4c05-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: Re: [syzbot] memory leak in kobject_set_name_vargs (5)
Date: Thu, 04 Aug 2022 15:00:29 -0700
Message-ID: <0000000000005022af05e5717ac8@google.com>
References: <00000000000098972c05e2117b39@google.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00000000000098972c05e2117b39-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    b44f2fd87919 Merge tag 'drm-next-2022-08-03' of git://anon..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=105fdbca080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=358668a360d9b702
dashboard link: https://syzkaller.appspot.com/bug?extid=7381dc4ad60658ca4c05
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c685ca080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120a0fe2080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7381dc4ad60658ca4c05-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

BUG: memory leak
unreferenced object 0xffff88810c35db80 (size 32):
  comm "syz-executor261", pid 3645, jiffies 4294950822 (age 25.990s)
  hex dump (first 32 bytes):
    6c 6f 6f 70 37 00 00 00 00 00 00 00 00 00 00 00  loop7...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814bf836>] kstrdup+0x36/0x70 mm/util.c:61
    [<ffffffff814bf8c3>] kstrdup_const+0x53/0x80 mm/util.c:84
    [<ffffffff8239c002>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
    [<ffffffff82492b6b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:257
    [<ffffffff82492fed>] kobject_add_varg lib/kobject.c:352 [inline]
    [<ffffffff82492fed>] kobject_init_and_add+0x6d/0xc0 lib/kobject.c:441
    [<ffffffff81e10e8a>] nilfs_sysfs_create_device_group+0x9a/0x3d0 fs/nilfs2/sysfs.c:991
    [<ffffffff81df964c>] init_nilfs+0x51c/0x680 fs/nilfs2/the_nilfs.c:637
    [<ffffffff81de57ab>] nilfs_fill_super fs/nilfs2/super.c:1047 [inline]
    [<ffffffff81de57ab>] nilfs_mount+0x51b/0x890 fs/nilfs2/super.c:1317
    [<ffffffff8164981b>] legacy_get_tree+0x2b/0x90 fs/fs_context.c:610
    [<ffffffff815e2c68>] vfs_get_tree+0x28/0x100 fs/super.c:1497
    [<ffffffff81626e27>] do_new_mount fs/namespace.c:3040 [inline]
    [<ffffffff81626e27>] path_mount+0xc37/0x1120 fs/namespace.c:3370
    [<ffffffff81627a5e>] do_mount fs/namespace.c:3383 [inline]
    [<ffffffff81627a5e>] __do_sys_mount fs/namespace.c:3591 [inline]
    [<ffffffff81627a5e>] __se_sys_mount fs/namespace.c:3568 [inline]
    [<ffffffff81627a5e>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
    [<ffffffff845cad15>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845cad15>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff88810c35db80 (size 32):
  comm "syz-executor261", pid 3645, jiffies 4294950822 (age 27.260s)
  hex dump (first 32 bytes):
    6c 6f 6f 70 37 00 00 00 00 00 00 00 00 00 00 00  loop7...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814bf836>] kstrdup+0x36/0x70 mm/util.c:61
    [<ffffffff814bf8c3>] kstrdup_const+0x53/0x80 mm/util.c:84
    [<ffffffff8239c002>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
    [<ffffffff82492b6b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:257
    [<ffffffff82492fed>] kobject_add_varg lib/kobject.c:352 [inline]
    [<ffffffff82492fed>] kobject_init_and_add+0x6d/0xc0 lib/kobject.c:441
    [<ffffffff81e10e8a>] nilfs_sysfs_create_device_group+0x9a/0x3d0 fs/nilfs2/sysfs.c:991
    [<ffffffff81df964c>] init_nilfs+0x51c/0x680 fs/nilfs2/the_nilfs.c:637
    [<ffffffff81de57ab>] nilfs_fill_super fs/nilfs2/super.c:1047 [inline]
    [<ffffffff81de57ab>] nilfs_mount+0x51b/0x890 fs/nilfs2/super.c:1317
    [<ffffffff8164981b>] legacy_get_tree+0x2b/0x90 fs/fs_context.c:610
    [<ffffffff815e2c68>] vfs_get_tree+0x28/0x100 fs/super.c:1497
    [<ffffffff81626e27>] do_new_mount fs/namespace.c:3040 [inline]
    [<ffffffff81626e27>] path_mount+0xc37/0x1120 fs/namespace.c:3370
    [<ffffffff81627a5e>] do_mount fs/namespace.c:3383 [inline]
    [<ffffffff81627a5e>] __do_sys_mount fs/namespace.c:3591 [inline]
    [<ffffffff81627a5e>] __se_sys_mount fs/namespace.c:3568 [inline]
    [<ffffffff81627a5e>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
    [<ffffffff845cad15>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845cad15>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff88810c35db80 (size 32):
  comm "syz-executor261", pid 3645, jiffies 4294950822 (age 28.520s)
  hex dump (first 32 bytes):
    6c 6f 6f 70 37 00 00 00 00 00 00 00 00 00 00 00  loop7...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814bf836>] kstrdup+0x36/0x70 mm/util.c:61
    [<ffffffff814bf8c3>] kstrdup_const+0x53/0x80 mm/util.c:84
    [<ffffffff8239c002>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
    [<ffffffff82492b6b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:257
    [<ffffffff82492fed>] kobject_add_varg lib/kobject.c:352 [inline]
    [<ffffffff82492fed>] kobject_init_and_add+0x6d/0xc0 lib/kobject.c:441
    [<ffffffff81e10e8a>] nilfs_sysfs_create_device_group+0x9a/0x3d0 fs/nilfs2/sysfs.c:991
    [<ffffffff81df964c>] init_nilfs+0x51c/0x680 fs/nilfs2/the_nilfs.c:637
    [<ffffffff81de57ab>] nilfs_fill_super fs/nilfs2/super.c:1047 [inline]
    [<ffffffff81de57ab>] nilfs_mount+0x51b/0x890 fs/nilfs2/super.c:1317
    [<ffffffff8164981b>] legacy_get_tree+0x2b/0x90 fs/fs_context.c:610
    [<ffffffff815e2c68>] vfs_get_tree+0x28/0x100 fs/super.c:1497
    [<ffffffff81626e27>] do_new_mount fs/namespace.c:3040 [inline]
    [<ffffffff81626e27>] path_mount+0xc37/0x1120 fs/namespace.c:3370
    [<ffffffff81627a5e>] do_mount fs/namespace.c:3383 [inline]
    [<ffffffff81627a5e>] __do_sys_mount fs/namespace.c:3591 [inline]
    [<ffffffff81627a5e>] __se_sys_mount fs/namespace.c:3568 [inline]
    [<ffffffff81627a5e>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
    [<ffffffff845cad15>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845cad15>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff88810c35db80 (size 32):
  comm "syz-executor261", pid 3645, jiffies 4294950822 (age 31.000s)
  hex dump (first 32 bytes):
    6c 6f 6f 70 37 00 00 00 00 00 00 00 00 00 00 00  loop7...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814bf836>] kstrdup+0x36/0x70 mm/util.c:61
    [<ffffffff814bf8c3>] kstrdup_const+0x53/0x80 mm/util.c:84
    [<ffffffff8239c002>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
    [<ffffffff82492b6b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:257
    [<ffffffff82492fed>] kobject_add_varg lib/kobject.c:352 [inline]
    [<ffffffff82492fed>] kobject_init_and_add+0x6d/0xc0 lib/kobject.c:441
    [<ffffffff81e10e8a>] nilfs_sysfs_create_device_group+0x9a/0x3d0 fs/nilfs2/sysfs.c:991
    [<ffffffff81df964c>] init_nilfs+0x51c/0x680 fs/nilfs2/the_nilfs.c:637
    [<ffffffff81de57ab>] nilfs_fill_super fs/nilfs2/super.c:1047 [inline]
    [<ffffffff81de57ab>] nilfs_mount+0x51b/0x890 fs/nilfs2/super.c:1317
    [<ffffffff8164981b>] legacy_get_tree+0x2b/0x90 fs/fs_context.c:610
    [<ffffffff815e2c68>] vfs_get_tree+0x28/0x100 fs/super.c:1497
    [<ffffffff81626e27>] do_new_mount fs/namespace.c:3040 [inline]
    [<ffffffff81626e27>] path_mount+0xc37/0x1120 fs/namespace.c:3370
    [<ffffffff81627a5e>] do_mount fs/namespace.c:3383 [inline]
    [<ffffffff81627a5e>] __do_sys_mount fs/namespace.c:3591 [inline]
    [<ffffffff81627a5e>] __se_sys_mount fs/namespace.c:3568 [inline]
    [<ffffffff81627a5e>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
    [<ffffffff845cad15>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845cad15>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff88810c35db80 (size 32):
  comm "syz-executor261", pid 3645, jiffies 4294950822 (age 31.040s)
  hex dump (first 32 bytes):
    6c 6f 6f 70 37 00 00 00 00 00 00 00 00 00 00 00  loop7...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814bf836>] kstrdup+0x36/0x70 mm/util.c:61
    [<ffffffff814bf8c3>] kstrdup_const+0x53/0x80 mm/util.c:84
    [<ffffffff8239c002>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
    [<ffffffff82492b6b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:257
    [<ffffffff82492fed>] kobject_add_varg lib/kobject.c:352 [inline]
    [<ffffffff82492fed>] kobject_init_and_add+0x6d/0xc0 lib/kobject.c:441
    [<ffffffff81e10e8a>] nilfs_sysfs_create_device_group+0x9a/0x3d0 fs/nilfs2/sysfs.c:991
    [<ffffffff81df964c>] init_nilfs+0x51c/0x680 fs/nilfs2/the_nilfs.c:637
    [<ffffffff81de57ab>] nilfs_fill_super fs/nilfs2/super.c:1047 [inline]
    [<ffffffff81de57ab>] nilfs_mount+0x51b/0x890 fs/nilfs2/super.c:1317
    [<ffffffff8164981b>] legacy_get_tree+0x2b/0x90 fs/fs_context.c:610
    [<ffffffff815e2c68>] vfs_get_tree+0x28/0x100 fs/super.c:1497
    [<ffffffff81626e27>] do_new_mount fs/namespace.c:3040 [inline]
    [<ffffffff81626e27>] path_mount+0xc37/0x1120 fs/namespace.c:3370
    [<ffffffff81627a5e>] do_mount fs/namespace.c:3383 [inline]
    [<ffffffff81627a5e>] __do_sys_mount fs/namespace.c:3591 [inline]
    [<ffffffff81627a5e>] __se_sys_mount fs/namespace.c:3568 [inline]
    [<ffffffff81627a5e>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
    [<ffffffff845cad15>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845cad15>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff88810c35db80 (size 32):
  comm "syz-executor261", pid 3645, jiffies 4294950822 (age 31.080s)
  hex dump (first 32 bytes):
    6c 6f 6f 70 37 00 00 00 00 00 00 00 00 00 00 00  loop7...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814bf836>] kstrdup+0x36/0x70 mm/util.c:61
    [<ffffffff814bf8c3>] kstrdup_const+0x53/0x80 mm/util.c:84
    [<ffffffff8239c002>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
    [<ffffffff82492b6b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:257
    [<ffffffff82492fed>] kobject_add_varg lib/kobject.c:352 [inline]
    [<ffffffff82492fed>] kobject_init_and_add+0x6d/0xc0 lib/kobject.c:441
    [<ffffffff81e10e8a>] nilfs_sysfs_create_device_group+0x9a/0x3d0 fs/nilfs2/sysfs.c:991
    [<ffffffff81df964c>] init_nilfs+0x51c/0x680 fs/nilfs2/the_nilfs.c:637
    [<ffffffff81de57ab>] nilfs_fill_super fs/nilfs2/super.c:1047 [inline]
    [<ffffffff81de57ab>] nilfs_mount+0x51b/0x890 fs/nilfs2/super.c:1317
    [<ffffffff8164981b>] legacy_get_tree+0x2b/0x90 fs/fs_context.c:610
    [<ffffffff815e2c68>] vfs_get_tree+0x28/0x100 fs/super.c:1497
    [<ffffffff81626e27>] do_new_mount fs/namespace.c:3040 [inline]
    [<ffffffff81626e27>] path_mount+0xc37/0x1120 fs/namespace.c:3370
    [<ffffffff81627a5e>] do_mount fs/namespace.c:3383 [inline]
    [<ffffffff81627a5e>] __do_sys_mount fs/namespace.c:3591 [inline]
    [<ffffffff81627a5e>] __se_sys_mount fs/namespace.c:3568 [inline]
    [<ffffffff81627a5e>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
    [<ffffffff845cad15>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845cad15>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
executing program
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
executing program
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory

