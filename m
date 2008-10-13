From: "Peter Smith" <smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: System crashed by cleanerd
Date: Mon, 13 Oct 2008 13:44:34 +0200
Message-ID: <474dca090810130444j1c3ab2a0rd5257f76153f63b@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0457639791=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============0457639791==
Content-Type: multipart/alternative; 
	boundary="----=_Part_129250_24865171.1223898274936"

------=_Part_129250_24865171.1223898274936
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi
I am a happy and long time user of nilfs2 but have just hit a major snag.

After mounting my existing Nilfs2 partition,  which has been in use for a
year,
as soon as cleanerd starts my entire system crashes.
(display, mouse and keyboard unresponsive, but can restart with Alt SysReq
B)

If I mount with -i option, to disable cleanerd, then I can access my Nilfs2
partition, with no crashes.
If I create/mount a new Nilfs2 partition and populate it with a large number
of files then
all works normally, including cleanerd.

So, seemingly, cleanerd has found something it does not like in my old
partition and this
causes it to abort.

My environment::-
Suse Linux 10.3
Kernel 2.6.22.18-0.2-default
nilfs-kmp-default-2.0.4_2.6.22.18_0.2-1
nilfs-utils-2.0.5-1
Core 2 Duo quad processor with 4 G memory

Nilfs partition size 4.6G
Files 51892
Checkpoints 31600

Below is an extract from /var/log/messages

regards, Peter

Oct 13 12:45:50 pluto kernel: segctord starting. Construction interval = 5
seconds, CP frequency < 30 seconds
Oct 13 12:45:50 pluto kernel: NILFS warning: mounting unchecked fs
Oct 13 12:45:50 pluto kernel: NILFS: recovery complete.
Oct 13 12:45:50 pluto nilfs_cleanerd[5332]: start
Oct 13 12:46:00 pluto kernel: ------------[ cut here ]------------
Oct 13 12:46:00 pluto kernel: kernel BUG at
/usr/src/packages/BUILD/nilfs-2.0.4/obj/default/cpfile.c:412!
Oct 13 12:46:00 pluto kernel: invalid opcode: 0000 [#1]
Oct 13 12:46:00 pluto kernel: SMP
Oct 13 12:46:00 pluto kernel: last sysfs file:
/devices/pci0000:00/0000:00:19.0/irq
Oct 13 12:46:00 pluto kernel: Modules linked in: nilfs2 nls_iso8859_1
nls_cp437 vfat fat vboxdrv snd_pcm_oss snd_mixer_oss snd_seq iptable_filter
ip_tables ip6table_filter ip6_tables x_tables i915 drm ipv6
cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq
speedstep_lib microcode firmware_class binfmt_misc coretemp hwmon reiserfs
loop dm_mod e1000 snd_cmipci snd_hda_intel gameport snd_opl3_lib snd_hwdep
snd_mpu401_uart snd_pcm snd_rawmidi ohci1394 snd_seq_device snd_timer
rtc_cmos i2c_i801 ieee1394 snd sr_mod rtc_core cdrom usb_storage rtc_lib
soundcore intel_agp i2c_core e1000e button usblp agpgart snd_page_alloc
ide_core sg ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan
thermal processor pata_marvell ahci libata scsi_mod
Oct 13 12:46:00 pluto kernel: CPU:    3
Oct 13 12:46:00 pluto kernel: EIP:    0060:[<f9c64780>]    Tainted: G      N
VLI
Oct 13 12:46:00 pluto kernel: EFLAGS: 00210202   (2.6.22.18-0.2-default #1)
Oct 13 12:46:00 pluto kernel: EIP is at
nilfs_cpfile_delete_checkpoints+0x23a/0x437 [nilfs2]
Oct 13 12:46:00 pluto kernel: eax: fff8d9c0   ebx: 00000000   ecx:
00000000   edx: 00000001
Oct 13 12:46:00 pluto kernel: esi: 00008044   edi: 00000000   ebp:
00000000   esp: e74a1d28
Oct 13 12:46:00 pluto kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss:
0068
Oct 13 12:46:00 pluto kernel: Process nilfs_cleanerd (pid: 5332, ti=e74a0000
task=c331eab0 task.ti=e74a0000)
Oct 13 12:46:00 pluto kernel: Stack: e74a1d78 defb41f4 c139ada0 0000000c
00000000 001157ff 0000061b 00000000
Oct 13 12:46:00 pluto kernel:        000006f4 d745358c fff8d000 00000000
00000000 00000008 00008044 0000000d
Oct 13 12:46:00 pluto kernel:        00000000 00008044 00008044 00000000
ecf7fc50 ee1cb8d0 0000824f 00000000
Oct 13 12:46:00 pluto kernel: Call Trace:
Oct 13 12:46:00 pluto kernel:  [<f9c687d4>]
nilfs_ioctl_do_delete_checkpoints+0x3d/0x52 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c67d4a>] nilfs_ioctl_wrap_copy+0xc8/0x124
[nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c6853c>]
nilfs_ioctl_prepare_clean_segments+0x57/0xca [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c68797>]
nilfs_ioctl_do_delete_checkpoints+0x0/0x52 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c635ca>] nilfs_clean_segments+0x71/0x250
[nilfs2]
Oct 13 12:46:00 pluto kernel:  [<c01607b4>] __handle_mm_fault+0x5e4/0xa83
Oct 13 12:46:00 pluto kernel:  [<f9c689ac>]
nilfs_ioctl_do_get_bdescs+0x5d/0x86 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c67d9c>]
nilfs_ioctl_wrap_copy+0x11a/0x124 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c67dec>] nilfs_ioctl+0x0/0x6f9 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c68286>] nilfs_ioctl+0x49a/0x6f9 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c6894f>]
nilfs_ioctl_do_get_bdescs+0x0/0x86 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c67dec>] nilfs_ioctl+0x0/0x6f9 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c67dec>] nilfs_ioctl+0x0/0x6f9 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<c017b238>] do_ioctl+0x88/0xa0
Oct 13 12:46:00 pluto kernel:  [<c014ecf0>] audit_syscall_entry+0x105/0x13e
Oct 13 12:46:00 pluto kernel:  [<c017b487>] vfs_ioctl+0x237/0x249
Oct 13 12:46:00 pluto kernel:  [<c017b4e5>] sys_ioctl+0x4c/0x67
Oct 13 12:46:00 pluto kernel:  [<c0104ea2>] syscall_call+0x7/0xb
Oct 13 12:46:00 pluto kernel:  [<c02c0000>] unix_wait_for_peer+0x34/0x93
Oct 13 12:46:00 pluto kernel:  =======================
Oct 13 12:46:00 pluto kernel: Code: 31 d2 f7 f1 8b 44 24 48 81 e3 ff 0f 00
00 31 ed f7 f1 8b 44 24 28 69 d2 c0 00 00 00 31 c9 01 d8 01 d0 eb 1c 8b 10
f6 c2 01 74 04 <0f> 0b eb fe f6 c2 02 75 06 83 ca 02 45 89 10 41 05 c0 00 00
00
Oct 13 12:46:00 pluto kernel: EIP: [<f9c64780>]
nilfs_cpfile_delete_checkpoints+0x23a/0x437 [nilfs2] SS:ESP 0068:e74a1d28
Oct 13 12:46:00 pluto kernel: note: nilfs_cleanerd[5332] exited with
preempt_count 1
Oct 13 12:46:00 pluto kernel: BUG: scheduling while atomic:
nilfs_cleanerd/0x10000001/5332
Oct 13 12:46:00 pluto kernel:  [<c02c45de>] __sched_text_start+0x5e/0x7c5
Oct 13 12:46:00 pluto kernel:  [<c0120304>] __cond_resched+0x18/0x29
Oct 13 12:46:00 pluto kernel:  [<c02c4dab>] cond_resched+0x26/0x31
Oct 13 12:46:00 pluto kernel:  [<c0137c31>] down_read+0x8/0x17
Oct 13 12:46:00 pluto kernel:  [<c01475e0>] acct_collect+0x31/0x159
Oct 13 12:46:00 pluto kernel:  [<c01278fc>] do_exit+0x1b0/0x719
Oct 13 12:46:00 pluto kernel:  [<c0106989>] die+0x1e6/0x1ee
Oct 13 12:46:00 pluto kernel:  [<c0106bb0>] do_invalid_op+0x0/0x8a
Oct 13 12:46:00 pluto kernel:  [<c0106c31>] do_invalid_op+0x81/0x8a
Oct 13 12:46:00 pluto kernel:  [<f9c64780>]
nilfs_cpfile_delete_checkpoints+0x23a/0x437 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<c015a3de>] activate_page+0x81/0xa7
Oct 13 12:46:00 pluto kernel:  [<c015a598>] mark_page_accessed+0x1c/0x30
Oct 13 12:46:00 pluto kernel:  [<f9c5540a>] nilfs_get_page_block+0x79/0x93
[nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c55dcd>]
nilfs_mdt_get_page_block+0x59/0xfa [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c55c59>]
nilfs_mdt_put_page_block+0x13/0x1b [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c55f64>] nilfs_mdt_submit_block+0xf6/0xff
[nilfs2]
Oct 13 12:46:00 pluto kernel:  [<c02c65b2>] error_code+0x72/0x80
Oct 13 12:46:00 pluto kernel:  [<f9c64780>]
nilfs_cpfile_delete_checkpoints+0x23a/0x437 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c687d4>]
nilfs_ioctl_do_delete_checkpoints+0x3d/0x52 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c67d4a>] nilfs_ioctl_wrap_copy+0xc8/0x124
[nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c6853c>]
nilfs_ioctl_prepare_clean_segments+0x57/0xca [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c68797>]
nilfs_ioctl_do_delete_checkpoints+0x0/0x52 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c635ca>] nilfs_clean_segments+0x71/0x250
[nilfs2]
Oct 13 12:46:00 pluto kernel:  [<c01607b4>] __handle_mm_fault+0x5e4/0xa83
Oct 13 12:46:00 pluto kernel:  [<f9c689ac>]
nilfs_ioctl_do_get_bdescs+0x5d/0x86 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c67d9c>]
nilfs_ioctl_wrap_copy+0x11a/0x124 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c67dec>] nilfs_ioctl+0x0/0x6f9 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c68286>] nilfs_ioctl+0x49a/0x6f9 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c6894f>]
nilfs_ioctl_do_get_bdescs+0x0/0x86 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c67dec>] nilfs_ioctl+0x0/0x6f9 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<f9c67dec>] nilfs_ioctl+0x0/0x6f9 [nilfs2]
Oct 13 12:46:00 pluto kernel:  [<c017b238>] do_ioctl+0x88/0xa0
Oct 13 12:46:00 pluto kernel:  [<c014ecf0>] audit_syscall_entry+0x105/0x13e
Oct 13 12:46:00 pluto kernel:  [<c017b487>] vfs_ioctl+0x237/0x249
Oct 13 12:46:00 pluto kernel:  [<c017b4e5>] sys_ioctl+0x4c/0x67
Oct 13 12:46:00 pluto kernel:  [<c0104ea2>] syscall_call+0x7/0xb
Oct 13 12:46:00 pluto kernel:  [<c02c0000>] unix_wait_for_peer+0x34/0x93
Oct 13 12:46:00 pluto kernel:  =======================

-- 
This is Linux land. On quiet nights you can hear the Windows machines
rebooting.

------=_Part_129250_24865171.1223898274936
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi<br>I am a happy and long time user of nilfs2 but have just hit a major snag.<br><br>After mounting my existing Nilfs2 partition,&nbsp; which has been in use for a year, <br>as soon as cleanerd starts my entire system crashes.<br>
(display, mouse and keyboard unresponsive, but can restart with Alt SysReq B)<br><br>If I mount with -i option, to disable cleanerd, then I can access my Nilfs2 partition, with no crashes.<br>If I create/mount a new Nilfs2 partition and populate it with a large number of files then<br>
all works normally, including cleanerd.<br><br>So, seemingly, cleanerd has found something it does not like in my old partition and this<br>causes it to abort.<br><br>My environment::-<br>Suse Linux 10.3<br>Kernel 2.6.22.18-0.2-default<br>
nilfs-kmp-default-2.0.4_2.6.22.18_0.2-1<br>nilfs-utils-2.0.5-1<br>Core 2 Duo quad processor with 4 G memory<br><br>Nilfs partition size 4.6G<br>Files 51892<br>Checkpoints 31600<br><br>Below is an extract from /var/log/messages<br>
<br>regards, Peter<br><br>Oct 13 12:45:50 pluto kernel: segctord starting. Construction interval = 5 seconds, CP frequency &lt; 30 seconds<br>Oct 13 12:45:50 pluto kernel: NILFS warning: mounting unchecked fs<br>Oct 13 12:45:50 pluto kernel: NILFS: recovery complete.<br>
Oct 13 12:45:50 pluto nilfs_cleanerd[5332]: start<br>Oct 13 12:46:00 pluto kernel: ------------[ cut here ]------------<br>Oct 13 12:46:00 pluto kernel: kernel BUG at /usr/src/packages/BUILD/nilfs-2.0.4/obj/default/cpfile.c:412!<br>
Oct 13 12:46:00 pluto kernel: invalid opcode: 0000 [#1]<br>Oct 13 12:46:00 pluto kernel: SMP <br>Oct 13 12:46:00 pluto kernel: last sysfs file: /devices/pci0000:00/0000:00:19.0/irq<br>Oct 13 12:46:00 pluto kernel: Modules linked in: nilfs2 nls_iso8859_1 nls_cp437 vfat fat vboxdrv snd_pcm_oss snd_mixer_oss snd_seq iptable_filter ip_tables ip6table_filter ip6_tables x_tables i915 drm ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib microcode firmware_class binfmt_misc coretemp hwmon reiserfs loop dm_mod e1000 snd_cmipci snd_hda_intel gameport snd_opl3_lib snd_hwdep snd_mpu401_uart snd_pcm snd_rawmidi ohci1394 snd_seq_device snd_timer rtc_cmos i2c_i801 ieee1394 snd sr_mod rtc_core cdrom usb_storage rtc_lib soundcore intel_agp i2c_core e1000e button usbl
 p agpgart snd_page_alloc ide_core sg ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan thermal processor pata_marvell ahci libata scsi_mod<br>
Oct 13 12:46:00 pluto kernel: CPU:&nbsp;&nbsp;&nbsp; 3<br>Oct 13 12:46:00 pluto kernel: EIP:&nbsp;&nbsp;&nbsp; 0060:[&lt;f9c64780&gt;]&nbsp;&nbsp;&nbsp; Tainted: G&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; N VLI<br>Oct 13 12:46:00 pluto kernel: EFLAGS: 00210202&nbsp;&nbsp; (2.6.22.18-0.2-default #1)<br>Oct 13 12:46:00 pluto kernel: EIP is at nilfs_cpfile_delete_checkpoints+0x23a/0x437 [nilfs2]<br>
Oct 13 12:46:00 pluto kernel: eax: fff8d9c0&nbsp;&nbsp; ebx: 00000000&nbsp;&nbsp; ecx: 00000000&nbsp;&nbsp; edx: 00000001<br>Oct 13 12:46:00 pluto kernel: esi: 00008044&nbsp;&nbsp; edi: 00000000&nbsp;&nbsp; ebp: 00000000&nbsp;&nbsp; esp: e74a1d28<br>Oct 13 12:46:00 pluto kernel: ds: 007b&nbsp;&nbsp; es: 007b&nbsp;&nbsp; fs: 00d8&nbsp; gs: 0033&nbsp; ss: 0068<br>
Oct 13 12:46:00 pluto kernel: Process nilfs_cleanerd (pid: 5332, ti=e74a0000 task=c331eab0 task.ti=e74a0000)<br>Oct 13 12:46:00 pluto kernel: Stack: e74a1d78 defb41f4 c139ada0 0000000c 00000000 001157ff 0000061b 00000000 <br>
Oct 13 12:46:00 pluto kernel:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 000006f4 d745358c fff8d000 00000000 00000000 00000008 00008044 0000000d <br>Oct 13 12:46:00 pluto kernel:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 00000000 00008044 00008044 00000000 ecf7fc50 ee1cb8d0 0000824f 00000000 <br>
Oct 13 12:46:00 pluto kernel: Call Trace:<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c687d4&gt;] nilfs_ioctl_do_delete_checkpoints+0x3d/0x52 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c67d4a&gt;] nilfs_ioctl_wrap_copy+0xc8/0x124 [nilfs2]<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c6853c&gt;] nilfs_ioctl_prepare_clean_segments+0x57/0xca [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c68797&gt;] nilfs_ioctl_do_delete_checkpoints+0x0/0x52 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c635ca&gt;] nilfs_clean_segments+0x71/0x250 [nilfs2]<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c01607b4&gt;] __handle_mm_fault+0x5e4/0xa83<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c689ac&gt;] nilfs_ioctl_do_get_bdescs+0x5d/0x86 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c67d9c&gt;] nilfs_ioctl_wrap_copy+0x11a/0x124 [nilfs2]<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c67dec&gt;] nilfs_ioctl+0x0/0x6f9 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c68286&gt;] nilfs_ioctl+0x49a/0x6f9 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c6894f&gt;] nilfs_ioctl_do_get_bdescs+0x0/0x86 [nilfs2]<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c67dec&gt;] nilfs_ioctl+0x0/0x6f9 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c67dec&gt;] nilfs_ioctl+0x0/0x6f9 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c017b238&gt;] do_ioctl+0x88/0xa0<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c014ecf0&gt;] audit_syscall_entry+0x105/0x13e<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c017b487&gt;] vfs_ioctl+0x237/0x249<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c017b4e5&gt;] sys_ioctl+0x4c/0x67<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c0104ea2&gt;] syscall_call+0x7/0xb<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c02c0000&gt;] unix_wait_for_peer+0x34/0x93<br>Oct 13 12:46:00 pluto kernel:&nbsp; =======================<br>Oct 13 12:46:00 pluto kernel: Code: 31 d2 f7 f1 8b 44 24 48 81 e3 ff 0f 00 00 31 ed f7 f1 8b 44 24 28 69 d2 c0 00 00 00 31 c9 01 d8 01 d0 eb 1c 8b 10 f6 c2 01 74 04 &lt;0f&gt; 0b eb fe f6 c2 02 75 06 83 ca 02 45 89 10 41 05 c0 00 00 00 <br>
Oct 13 12:46:00 pluto kernel: EIP: [&lt;f9c64780&gt;] nilfs_cpfile_delete_checkpoints+0x23a/0x437 [nilfs2] SS:ESP 0068:e74a1d28<br>Oct 13 12:46:00 pluto kernel: note: nilfs_cleanerd[5332] exited with preempt_count 1<br>Oct 13 12:46:00 pluto kernel: BUG: scheduling while atomic: nilfs_cleanerd/0x10000001/5332<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c02c45de&gt;] __sched_text_start+0x5e/0x7c5<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c0120304&gt;] __cond_resched+0x18/0x29<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c02c4dab&gt;] cond_resched+0x26/0x31<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c0137c31&gt;] down_read+0x8/0x17<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c01475e0&gt;] acct_collect+0x31/0x159<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c01278fc&gt;] do_exit+0x1b0/0x719<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c0106989&gt;] die+0x1e6/0x1ee<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c0106bb0&gt;] do_invalid_op+0x0/0x8a<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c0106c31&gt;] do_invalid_op+0x81/0x8a<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c64780&gt;] nilfs_cpfile_delete_checkpoints+0x23a/0x437 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c015a3de&gt;] activate_page+0x81/0xa7<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c015a598&gt;] mark_page_accessed+0x1c/0x30<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c5540a&gt;] nilfs_get_page_block+0x79/0x93 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c55dcd&gt;] nilfs_mdt_get_page_block+0x59/0xfa [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c55c59&gt;] nilfs_mdt_put_page_block+0x13/0x1b [nilfs2]<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c55f64&gt;] nilfs_mdt_submit_block+0xf6/0xff [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c02c65b2&gt;] error_code+0x72/0x80<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c64780&gt;] nilfs_cpfile_delete_checkpoints+0x23a/0x437 [nilfs2]<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c687d4&gt;] nilfs_ioctl_do_delete_checkpoints+0x3d/0x52 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c67d4a&gt;] nilfs_ioctl_wrap_copy+0xc8/0x124 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c6853c&gt;] nilfs_ioctl_prepare_clean_segments+0x57/0xca [nilfs2]<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c68797&gt;] nilfs_ioctl_do_delete_checkpoints+0x0/0x52 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c635ca&gt;] nilfs_clean_segments+0x71/0x250 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c01607b4&gt;] __handle_mm_fault+0x5e4/0xa83<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c689ac&gt;] nilfs_ioctl_do_get_bdescs+0x5d/0x86 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c67d9c&gt;] nilfs_ioctl_wrap_copy+0x11a/0x124 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c67dec&gt;] nilfs_ioctl+0x0/0x6f9 [nilfs2]<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c68286&gt;] nilfs_ioctl+0x49a/0x6f9 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c6894f&gt;] nilfs_ioctl_do_get_bdescs+0x0/0x86 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c67dec&gt;] nilfs_ioctl+0x0/0x6f9 [nilfs2]<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;f9c67dec&gt;] nilfs_ioctl+0x0/0x6f9 [nilfs2]<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c017b238&gt;] do_ioctl+0x88/0xa0<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c014ecf0&gt;] audit_syscall_entry+0x105/0x13e<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c017b487&gt;] vfs_ioctl+0x237/0x249<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c017b4e5&gt;] sys_ioctl+0x4c/0x67<br>Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c0104ea2&gt;] syscall_call+0x7/0xb<br>
Oct 13 12:46:00 pluto kernel:&nbsp; [&lt;c02c0000&gt;] unix_wait_for_peer+0x34/0x93<br>Oct 13 12:46:00 pluto kernel:&nbsp; =======================<br clear="all"><br>-- <br>This is Linux land. On quiet nights you can hear the Windows machines rebooting.<br>

</div>

------=_Part_129250_24865171.1223898274936--

--===============0457639791==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0457639791==--
