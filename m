From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: RE: Kernel panic in nilfs.
Date: Fri, 18 Jan 2013 10:23:30 +0400
Message-ID: <1358490210.2101.19.camel@slavad-ubuntu>
References: <053D39D3D76C474EB2D2A284AA6BA31832289350B1@COLOSSEXCH01.starsolutions.com>
	 <1358317724.2156.9.camel@slavad-ubuntu>
	 <053D39D3D76C474EB2D2A284AA6BA31832289353AE@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=GQMWBD0AaEoDHIgd2Hs36khknu+yeHbP6ydfKnmWC3w=;
	b=YqE1vV/C+CzcCWI40VAWLhvUX5tQPcKhdKXlZ9djaVihNvb98WxZ6krSpv7FLO3xR6oI1h1bqLL7hieS4OS67bwYy4cFJho4yNU/yAsHjVcgR6GRrVUapAZkE9/0LgNH;
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA31832289353AE-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, 2013-01-17 at 10:59 -0800, Zahid Chowdhury wrote:
> Hi Vyacheslav,
>   Thanks for your responses/help. My responses are below with "ZC>".
> 
> Zahid
> 
> -----Original Message-----
> From: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Vyacheslav Dubeyko
> Sent: Tuesday, January 15, 2013 10:29 PM
> To: Zahid Chowdhury
> Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Kernel panic in nilfs.
> 
> Hi Zahid,
> 
> On Tue, 2013-01-15 at 14:36 -0800, Zahid Chowdhury wrote:
> > Hello,
> >   I am running a Centos 5.5 (kernel 2.6.18-194.17.4.el5). I have used the
> > Centos distribution with the nilfs kernel module 2.0.22 to statically build
> > nilfs into the kernel (that's why I renamed 2.6.18-194.17.4.el5 to 2.6.18-194.17.4.el5SSI_NILFS). I have enabled netconsole as the box is mostly headless - the kernel panic messages below came up through netconsole. The garbage collection daemon is nilfs-utils 2.1.0. The processor is a Intel(R) Atom(TM) CPU D510 dual core with 2 contexts. The SSD is a Industrial Grade Apacer 16GB SLC. At the time the kernel panicked there many (> 100) soft-real time processes with nice levels of -19 running (the cleanerd runs at +19 nice level as we have found that otherwise it disturbs the soft real-time processes). These soft real-time processes also are memory hogs & cpu hogs (less than < a few % idle even with all the cores/contexts), such that less than a few K of memory is available (we will be f
 ixing the apps, but still nilfs should not panic the kernel) at anytime. We do allow overcommit and the all processes are at the normal oom_adj value of 0 except for critical processes like syslogd & klogd, sshd, crond, nilfs_cleanerd, ifplugd, dbus-daemon. Btw, we did much testing and no kernel panics occurred over weeks until I oom_adj the critical processes just today.
> > 
> > 
> > Has anybody seen the kernel panic messages I see below? Is there any fix for this in a Centos 5.5 kernel? Would upgrading to a newer nilfs module clear up this panic? Would upgrading to a newer kernel clear up this panic? Upgrading cleanerd? Any other suggestions/questions are very welcome. Thanks all.
> > 
> 
> First of all, I think that it makes sense to try to upgrade kernel and
> nilfs-utils. It needs to understand that your issue can be reproduced on
> actual state of NILFS2 code.
> 
> ZC> Actually, some of our apps cannot run on newer kernels, so we may not
> ZC> hit this panic situation in that scenario.
> 
> 
> Secondly, what value of vm.min_free_kbytes do you have in your system?
> Do you have in system log any error messages about page allocation
> failure?
> 
> 
> ZC> We have min_free_kbytes as the Centos 5.5 default of 3831. That is very
> ZC> low for the pool of reserved page frames. Thus, I will be bumping this
> ZC> to 32K or 64K. We also have the vm.lowmem_reserve_ratio set to 32,
> ZC> I am hoping to bump this to a higher number like "9" instead of "32".
> ZC> On previous runs of this load test we did have page allocation failures
> ZC> in the apps and oom_kill ran and nuked processes - in the kernel panic
> ZC> run we had no page allocation failures reported/oom, that is why I am
> ZC> worried. I will be setting panic on reboot, but it is scary when I see
> ZC> no messages and suddenly things panic - though a load test was running
> ZC> when the panic happened. Any other thoughts/suggestions are very
> ZC> welcome.
> 
> 
> Thirdly, I don't clearly understand currently how to try to reproduce
> your issue. Could you describe in more details what filesystem
> operations were before issue occurrence? Do you have any NILFS2-related
> error messages in your system log before kernel panic?
> 
> ZC> We have 90/10 reads to writes (sqlite) as most writes were moved to a memory
> ZC> filesystem as writes to NILFS creates 5:1 ratios in the size of the
> ZC> dat file to real space usage - do you know if this has been fixed on
> ZC> on a newer release of the kernel module and/or has the gc daemon been
> ZC> cleaned up? Also, the gc daemon uses most of the CPU bandwidth with
> ZC> a large dat file situation. No nilfs error messages in syslogd via
> ZC> klogd. I'm unsure if you can reproduce. Maybe download a Centos 5.5
> ZC> distro, compile in the nilfs module, I think the error messages on
> ZC> compile are easily fixable - the issue I had was with the Redhat
> ZC> signing method of there modules - please view the centos web-site on
> ZC> ways to deal with this. Then run CPU & Memory hogs with no ulimit
> ZC> protection (remember Cemtos ships with overcommit on). The hogs should
> ZC> do mostly reads. Cleanerd should be ioniced to the lowest priority and
> ZC> reniced to the lowest level. That should do it. Let me know if you have
> ZC> any problems.
> ZC> Regards.
> 

Thank you for additional details.

Currently, I am fixing two bugs in NILFS2 (flush kernel thread issue and
issue with bad btree node messages). I guess that these bugs can be a
reason of your issue. So, you can check your issue reproducibility after
fix of these bugs. If you will reproduce your issue without changing
then I will investigate your issue more deeply.

With the best regards,
Vyacheslav Dubeyko.

> Thanks,
> Vyacheslav Dubeyko.
> 
> > 
> > Zahid
> > 
> > P.S.: Panic flow over netconsole into syslogd - sorry for so many lines, alas Solaris syslogd seems to wrap early:
> > 
> > Jan 15 12:22:38  ------------[ cut here ]------------
> > Jan 15 12:22:38  kernel BUG at fs/nilfs2/page.c:317!
> > Jan 15 12:22:38  invalid opcode: 0000 [#1]
> > Jan 15 12:22:38  SMP
> > Jan 15 12:22:38
> > Jan 15 12:22:38  last sysfs file: /devices/pci0000:00/0000:00:1c.0/0000:02:00.0/irq
> > Jan 15 12:22:38  Modules linked in:
> > Jan 15 12:22:38   netconsole
> > Jan 15 12:22:38   autofs4
> > Jan 15 12:22:38   dme1737
> > Jan 15 12:22:38   hwmon_vid
> > Jan 15 12:22:38   hidp
> > Jan 15 12:22:38   l2cap
> > Jan 15 12:22:38   bluetooth
> > Jan 15 12:22:38   sunrpc
> > Jan 15 12:22:38   bridge
> > Jan 15 12:22:38   ip_nat_ftp
> > Jan 15 12:22:38   ip_conntrack_ftp
> > Jan 15 12:22:38   ip_conntrack_netbios_ns
> > Jan 15 12:22:38   iptable_mangle
> > Jan 15 12:22:38   iptable_filter
> > Jan 15 12:22:38   ipt_MASQUERADE
> > Jan 15 12:22:38   xt_tcpudp
> > Jan 15 12:22:38   iptable_nat
> > Jan 15 12:22:38   ip_nat
> > Jan 15 12:22:38   ip_conntrack
> > Jan 15 12:22:38   nfnetlink
> > Jan 15 12:22:38   ip_tables
> > Jan 15 12:22:38   x_tables
> > Jan 15 12:22:38   loop
> > Jan 15 12:22:38   dm_mirror
> > Jan 15 12:22:38   dm_multipath
> > Jan 15 12:22:38   scsi_dh
> > Jan 15 12:22:38   video
> > Jan 15 12:22:38   backlight
> > Jan 15 12:22:38   sbs
> > Jan 15 12:22:38   power_meter
> > Jan 15 12:22:38   hwmon
> > Jan 15 12:22:38   i2c_ec
> > Jan 15 12:22:38   dell_wmi
> > Jan 15 12:22:38   wmi
> > Jan 15 12:22:38   button
> > Jan 15 12:22:38   battery
> > Jan 15 12:22:38   asus_acpi
> > Jan 15 12:22:38   ac
> > Jan 15 12:22:38   lp
> > Jan 15 12:22:38   snd_hda_intel
> > Jan 15 12:22:38   snd_seq_dummy
> > Jan 15 12:22:38   sg
> > Jan 15 12:22:38   snd_seq_oss
> > Jan 15 12:22:38   snd_seq_midi_event
> > Jan 15 12:22:38   snd_seq
> > Jan 15 12:22:38   snd_seq_device
> > Jan 15 12:22:38   snd_pcm_oss
> > Jan 15 12:22:38   snd_mixer_oss
> > Jan 15 12:22:38   snd_pcm
> > Jan 15 12:22:38   snd_timer
> > Jan 15 12:22:38   snd_page_alloc
> > Jan 15 12:22:38   parport_pc
> > Jan 15 12:22:38   e1000e
> > Jan 15 12:22:38   pcspkr
> > Jan 15 12:22:38   snd_hwdep
> > Jan 15 12:22:38   serio_raw
> > Jan 15 12:22:38   parport
> > Jan 15 12:22:38   i2c_i801
> > Jan 15 12:22:38   i2c_core
> > Jan 15 12:22:38   snd
> > Jan 15 12:22:38   soundcore
> > Jan 15 12:22:38   dm_raid45
> > Jan 15 12:22:38   dm_message
> > Jan 15 12:22:38   dm_region_hash
> > Jan 15 12:22:38   dm_log
> > Jan 15 12:22:38   dm_mod
> > Jan 15 12:22:38   dm_mem_cache
> > Jan 15 12:22:38   usb_storage
> > Jan 15 12:22:38   ata_piix
> > Jan 15 12:22:38   libata
> > Jan 15 12:22:38   sd_mod
> > Jan 15 12:22:38   scsi_mod
> > Jan 15 12:22:38   ext3
> > Jan 15 12:22:38   jbd
> > Jan 15 12:22:38   uhci_hcd
> > Jan 15 12:22:38   ohci_hcd
> > Jan 15 12:22:38   ehci_hcd
> > Jan 15 12:22:38
> > Jan 15 12:22:38  CPU:    0
> > Jan 15 12:22:38  EIP:    0060:[<c04c078b>]    Not tainted VLI
> > Jan 15 12:22:38  EFLAGS: 00010246   (2.6.18-194.17.4.el5SSI_NILFS #1)
> > Jan 15 12:22:38  EIP is at nilfs_copy_page+0x29/0x198
> > Jan 15 12:22:38  eax: 80010029   ebx: c1329100   ecx: 00000000   edx: c135de00
> > Jan 15 12:22:38  esi: 00000000   edi: f6df3f30   ebp: f6df3cf4   esp: f7a14ca8
> > Jan 15 12:22:38  ds: 007b   es: 007b   ss: 0068
> > Jan 15 12:22:38  Process nilfs_cleanerd (pid: 1653, ti=f7a14000 task=f79c4000 task.ti=f7a14000)
> > Jan 15 12:22:38
> > Jan 15 12:22:38  Stack:
> > Jan 15 12:22:38  ec2e8000
> > Jan 15 12:22:38  e0461000
> > Jan 15 12:22:38  c135de00
> > Jan 15 12:22:38  c1585d00
> > Jan 15 12:22:38  f6df3f30
> > Jan 15 12:22:38  c0458ba8
> > Jan 15 12:22:38  c135de00
> > Jan 15 12:22:38  c1329100
> > Jan 15 12:22:38
> > Jan 15 12:22:38
> > Jan 15 12:22:38  f6df3f30
> > Jan 15 12:22:38  f6df3cf4
> > Jan 15 12:22:38  c04c0ff2
> > Jan 15 12:22:38  00001f8e
> > Jan 15 12:22:38  00000005
> > Jan 15 12:22:38  00001f7c
> > Jan 15 12:22:38  0000000e
> > Jan 15 12:22:38  00000000
> > Jan 15 12:22:38
> > Jan 15 12:22:38
> > Jan 15 12:22:38  c1407240
> > Jan 15 12:22:38  c12b5ac0
> > Jan 15 12:22:38  c152afe0
> > Jan 15 12:22:38  c1462ae0
> > Jan 15 12:22:38  c1408c20
> > Jan 15 12:22:38  c135de00
> > Jan 15 12:22:38  c11fdda0
> > Jan 15 12:22:38  c1503320
> > Jan 15 12:22:38
> > Jan 15 12:22:38  Call Trace:
> > Jan 15 12:22:38   [<c0458ba8>]
> > Jan 15 12:22:38  find_lock_page+0x1a/0x7e
> > Jan 15 12:22:38   [<c04c0ff2>]
> > Jan 15 12:22:38  nilfs_copy_back_pages+0xbb/0x1e7
> > Jan 15 12:22:38   [<c04d2f3b>]
> > Jan 15 12:22:38  nilfs_commit_gcdat_inode+0x83/0xa8
> > Jan 15 12:22:38   [<c04cc0de>]
> > Jan 15 12:22:38  nilfs_segctor_complete_write+0x1dd/0x301
> > Jan 15 12:22:38   [<c04cd337>]
> > Jan 15 12:22:38  nilfs_segctor_do_construct+0x1011/0x1384
> > Jan 15 12:22:38   [<c045dbea>]
> > Jan 15 12:22:38  __set_page_dirty_nobuffers+0xb0/0xd3
> > Jan 15 12:22:38   [<c04c17f3>]
> > Jan 15 12:22:38  nilfs_mdt_mark_block_dirty+0x41/0x47
> > Jan 15 12:22:38   [<c04cd8c1>]
> > Jan 15 12:22:38  nilfs_segctor_construct+0x82/0x261
> > Jan 15 12:22:38   [<c04ceada>]
> > Jan 15 12:22:38  nilfs_clean_segments+0xa9/0x1c4
> > Jan 15 12:22:38   [<c04d26e2>]
> > Jan 15 12:22:38  nilfs_ioctl+0x444/0x57d
> > Jan 15 12:22:38   [<c0465900>]
> > Jan 15 12:22:38  free_pgd_range+0x108/0x190
> > Jan 15 12:22:38   [<c04d229e>]
> > Jan 15 12:22:38  nilfs_ioctl+0x0/0x57d
> > Jan 15 12:22:38   [<c048620d>]
> > Jan 15 12:22:38  do_ioctl+0x1c/0x5d
> > Jan 15 12:22:38   [<c04867a1>]
> > Jan 15 12:22:38  vfs_ioctl+0x47b/0x4d3
> > Jan 15 12:22:38   [<c041eef6>]
> > Jan 15 12:22:38  enqueue_task+0x29/0x39
> > Jan 15 12:22:38   [<c0486841>]
> > Jan 15 12:22:38  sys_ioctl+0x48/0x5f
> > Jan 15 12:22:38   [<c0404f17>]
> > Jan 15 12:22:38  syscall_call+0x7/0xb
> > Jan 15 12:22:38   =======================
> > Jan 15 12:22:38  Code:
> > Jan 15 12:22:38  00
> > Jan 15 12:22:38  c3
> > Jan 15 12:22:38  55
> > Jan 15 12:22:38  57
> > Jan 15 12:22:38  56
> > Jan 15 12:22:38  89
> > Jan 15 12:22:38  ce
> > Jan 15 12:22:38  53
> > Jan 15 12:22:38  89
> > Jan 15 12:22:38  c3
> > Jan 15 12:22:38  83
> > Jan 15 12:22:38  ec
> > Jan 15 12:22:38  18
> > Jan 15 12:22:38  89
> > Jan 15 12:22:38  54
> > Jan 15 12:22:38  24
> > Jan 15 12:22:38  08
> > Jan 15 12:22:38  8b
> > Jan 15 12:22:38  00
> > Jan 15 12:22:38  f6
> > Jan 15 12:22:38  c4
> > Jan 15 12:22:38  10
> > Jan 15 12:22:38  74
> > Jan 15 12:22:38  08
> > Jan 15 12:22:38  0f
> > Jan 15 12:22:38  0b
> > Jan 15 12:22:38  3b
> > Jan 15 12:22:38  01
> > Jan 15 12:22:38  22
> > Jan 15 12:22:38  1b
> > Jan 15 12:22:38  66
> > Jan 15 12:22:38  c0
> > Jan 15 12:22:38  8b
> > Jan 15 12:22:38  54
> > Jan 15 12:22:38  24
> > Jan 15 12:22:38  08
> > Jan 15 12:22:38  8b
> > Jan 15 12:22:38  02
> > Jan 15 12:22:38  f6
> > Jan 15 12:22:38  c4
> > Jan 15 12:22:38  08
> > Jan 15 12:22:38  75
> > Jan 15 12:22:38  08
> > Jan 15 12:22:38  f>
> > Jan 15 12:22:38  0b
> > Jan 15 12:22:38  3d
> > Jan 15 12:22:38  01
> > Jan 15 12:22:38  22
> > Jan 15 12:22:38  1b
> > Jan 15 12:22:38  66
> > Jan 15 12:22:38  c0
> > Jan 15 12:22:38  8b
> > Jan 15 12:22:38  03
> > Jan 15 12:22:38  8b
> > Jan 15 12:22:38  7c
> > Jan 15 12:22:38  24
> > Jan 15 12:22:38  08
> > Jan 15 12:22:38  f6
> > Jan 15 12:22:38  c4
> > Jan 15 12:22:38  08
> > Jan 15 12:22:38  8b
> > Jan 15 12:22:38  6f
> > Jan 15 12:22:38  0c
> > Jan 15 12:22:38  75
> > Jan 15 12:22:38
> > Jan 15 12:22:38  EIP: [<c04c078b>]
> > Jan 15 12:22:38  nilfs_copy_page+0x29/0x198
> > Jan 15 12:22:38   SS:ESP 0068:f7a14ca8
> > Jan 15 12:22:38
> > Jan 15 12:22:38  Kernel panic - not syncing: Fatal exception
> > Jan 15 12:22:38
> > ~
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
