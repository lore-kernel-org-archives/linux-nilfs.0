From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Crash...
Date: Fri, 24 Jul 2009 01:12:49 +0900 (JST)
Message-ID: <20090724.011249.110726474.ryusuke@osrg.net>
References: <9cdbb57f0907230555k768383c2ld1690d31cc6fff83@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <9cdbb57f0907230555k768383c2ld1690d31cc6fff83-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Thu, 23 Jul 2009 14:55:01 +0200, Andrea Gelmini wrote:
> Hi all,
>    thanks a lot for nilfs2.
>    I'm trying to migrate my /home on nilfs2, but I've got this problem
> doing rsync:
> 
> [ 4808.492544] ------------[ cut here ]------------
> [ 4808.492547] kernel BUG at fs/nilfs2/segment.c:744!
> [ 4808.492549] invalid opcode: 0000 [#1] SMP
> [ 4808.492551] last sysfs file: /sys/devices/virtual/block/dm-0/range
> [ 4808.492552] Modules linked in: nilfs2 reiserfs binfmt_misc rfcomm
> bridge stp llc bnep sco l2cap bluetooth rfkill kqemu video backlight
> output sbs sbshc pci_slot container battery ac loop snd_hda_codec_idt
> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
> snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
> snd_seq_midi_event snd_seq iTCO_wdt psmouse snd_timer snd_seq_device
> iTCO_vendor_support pcspkr serio_raw processor rtc_cmos rtc_core
> rtc_lib rt2860sta(C) snd joydev evdev button soundcore snd_page_alloc
> xfs exportfs sha256_generic usbhid hid sg sr_mod usb_storage
> usb_libusual sd_mod cdrom ata_generic pata_acpi pata_marvell ata_piix
> ohci1394 ieee1394 uhci_hcd ehci_hcd libata scsi_mod e1000e usbcore
> nls_base dm_snapshot thermal fan thermal_sys hwmon dm_mirror
> dm_region_hash dm_log
> [ 4808.492597]
> [ 4808.492599] Pid: 15705, comm: segctord Tainted: G         C
> (2.6.31-rc4g #6)
> [ 4808.492601] EIP: 0060:[<f8439ffe>] EFLAGS: 00010246 CPU: 1
> [ 4808.492611] EIP is at nilfs_segctor_scan_file+0xa5/0x19e [nilfs2]
> [ 4808.492613] EAX: 40000020 EBX: 00000000 ECX: 0000000e EDX: c16b5cc0
> [ 4808.492615] ESI: ef0b9500 EDI: dfe0f318 EBP: f4900dd0 ESP: f4900d5c
> [ 4808.492616]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [ 4808.492618] Process segctord (pid: 15705, ti=f4900000 task=e2448dc0
> task.ti=f4900000)
> [ 4808.492620] Stack:
> [ 4808.492621]  e52e42c0 f8449c98 e52e42c0 dfe0f2b8 dfe0f230 0000000e
> 00000000 c16b5cc0
> [ 4808.492624] <0> c1580340 c14b9c20 c19dc5a0 c170f300 c1a4e4e0
> c1996320 c18c9f80 c1950820
> [ 4808.492628] <0> c1951de0 c18c9660 c19f9420 c1817ea0 c194fb80
> f4900db0 f4900db0 d86ea228
> [ 4808.492632] Call Trace:
> [ 4808.492642]  [<f843abc8>] ? nilfs_segctor_do_construct+0x639/0x1dfe [nilfs2]
> [ 4808.492652]  [<f843c511>] ? nilfs_segctor_construct+0x35/0xae [nilfs2]
> [ 4808.492661]  [<f843ce6f>] ? nilfs_segctor_thread+0x138/0x2af [nilfs2]
> [ 4808.492670]  [<f843cad5>] ? nilfs_construction_timeout+0x0/0xa [nilfs2]
> [ 4808.492678]  [<f843cd37>] ? nilfs_segctor_thread+0x0/0x2af [nilfs2]
> [ 4808.492683]  [<c1038145>] ? kthread+0x69/0x6e
> [ 4808.492685]  [<c10380dc>] ? kthread+0x0/0x6e
> [ 4808.492688]  [<c10033e7>] ? kernel_thread_helper+0x7/0x10
> [ 4808.492690] Code: 8d 47 a0 89 55 9c 89 45 98 c7 45 f0 00 00 00 00
> c7 45 a0 00 00 00 00 c7 45 a4 00 00 00 00 eb 5e 8b 54 9d a8 8b 02 f6
> c4 08 75 04 <0f> 0b eb fe 8b 52 0c 89 55 94 89 d1 f6 01 02 74 21 8d 41
> 34 f0
> [ 4808.492711] EIP: [<f8439ffe>] nilfs_segctor_scan_file+0xa5/0x19e
> [nilfs2] SS:ESP 0068:f4900d5c
> [ 4808.492721] ---[ end trace b07556da5ec25007 ]---
> 
> Well, I'm using Ubuntu 9.04 with a vanilla kernel 2.6.31-rc4 with
> pulled "git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
> experimental".

Thank you for your report.

The log gives us really meaningful information.

First, I could identify the function which raised the assertion. 
( it's a page_buffers() call in nilfs_lookup_dirty_node_buffers() in
segment.c )

It also suggests that an inconsistent state in page cache of B-tree
nodes hit the function; the function found a dirty page, but the page
didn't have buffer heads which was supposed to be impossible for the
b-tree of nilfs.

I don't know yet why it can happen, but it's helpful to me in
narrowing down the cause.

> What other info can be useful to you? Instead of a giant attachment
> with .config, /proc/cpu, lspci and so on, I can provide all of this
> via web.
> 
> Thanks a lot for your work,
> Andrea

I will ask for your help if need arises.

Thanks,
Ryusuke Konishi
