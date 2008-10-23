From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleanerd crash
Date: Thu, 23 Oct 2008 15:16:30 +0900 (JST)
Message-ID: <20081023.151630.83293955.ryusuke@osrg.net>
References: <200810181333.55486.john@mib-infotech.co.nz>
	<20081018.130841.87825802.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081018.130841.87825802.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, john-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org

Hi John,

On Sat, 18 Oct 2008 13:08:41 +0900 (JST), Ryusuke Konishi wrote:
> On Sat, 18 Oct 2008 13:33:55 +1300, John Huttley wrote:
> > Hi,
> > 
> > I've updated to nilfs2-utils from git but I'm getting crashes. Eventually it 
> > locks up the filesystem.
> > 
> > The log has a lot of entries like this.
> > I'm not quite sure where the start is...
> 
> Thank you for this problem report.
> 
> It looks memory shortage. The memory allocation code of the nilfs2
> ioctl looks problematic.
> 
> OK, I'll try to make a few changes to moderate the problem.

I pushed a patch to the nilfs2-module git tree
( http://www.nilfs.org/git/ ).
I believe it will get rid of this problem.

After a series of tests, I will release an update version of the
nilfs2 module.

If you can try it, please let me know the result.

Regards,
Ryusuke Konishi

> > 
> > System is gentoo 2.6.26
> > 1Gb ram
> > X64 processor
> > 
> > 
> > 
> > Regards,
> > 
> > John
> > 
> > 
> > 
> > 17:05+13:00 [<ffffffff8029f4ca>] sys_ioctl+0x4a/0x80
> > 2008-10-18T13:17:05+13:00 [<ffffffff8020b54b>] 
> > system_call_after_swapgs+0x7b/0x80
> > 2008-10-18T13:17:05+13:00
> > 2008-10-18T13:17:05+13:00 Mem-info:
> > 2008-10-18T13:17:05+13:00 DMA per-cpu:
> > 2008-10-18T13:17:05+13:00 CPU    0: hi:    0, btch:   1 usd:   0
> > 2008-10-18T13:17:05+13:00 CPU    1: hi:    0, btch:   1 usd:   0
> > 2008-10-18T13:17:05+13:00 DMA32 per-cpu:
> > 2008-10-18T13:17:05+13:00 CPU    0: hi:  186, btch:  31 usd:   0
> > 2008-10-18T13:17:05+13:00 CPU    1: hi:  186, btch:  31 usd:   0
> > 2008-10-18T13:17:05+13:00 Active:90869 inactive:129468 dirty:3960 writeback:0 
> > unstable:0
> > 2008-10-18T13:17:05+13:00 free:2456 slab:22666 mapped:11236 pagetables:3523 
> > bounce:0
> > 2008-10-18T13:17:05+13:00 DMA free:3988kB min:28kB low:32kB high:40kB 
> > active:236kB inactive:1076kB present:7520kB pages_scanned:0 
> > all_unreclaimable? no
> > 2008-10-18T13:17:05+13:00 lowmem_reserve[]: 0 993 993 993
> > 2008-10-18T13:17:05+13:00 DMA32 free:5836kB min:4016kB low:5020kB high:6024kB 
> > active:363240kB inactive:516796kB present:1017196kB pages_scanned:0 
> > all_unreclaimable? no
> > 2008-10-18T13:17:05+13:00 lowmem_reserve[]: 0 0 0 0
> > 2008-10-18T13:17:05+13:00 DMA: 37*4kB 46*8kB 31*16kB 23*32kB 3*64kB 0*128kB 
> > 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3988kB
> > 2008-10-18T13:17:05+13:00 DMA32: 515*4kB 247*8kB 37*16kB 22*32kB 7*64kB 
> > 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5908kB
> > 2008-10-18T13:17:05+13:00 150687 total pagecache pages
> > 2008-10-18T13:17:05+13:00 Swap cache: add 6369, delete 5665, find 372/545
> > 2008-10-18T13:17:05+13:00 Free swap  = 2077216kB
> > 2008-10-18T13:17:05+13:00 Total swap = 2097140kB
> > 2008-10-18T13:17:05+13:00 261920 pages of RAM
> > 2008-10-18T13:17:05+13:00 5977 reserved pages
> > 2008-10-18T13:17:05+13:00 146602 pages shared
> > 2008-10-18T13:17:05+13:00 704 pages swap cached
> > 2008-10-18T13:17:11+13:00 nilfs_cleanerd: page allocation failure. order:5, 
> > mode:0x4050
> > 2008-10-18T13:17:11+13:00 Pid: 4940, comm: nilfs_cleanerd Not tainted 
> > 2.6.26-gentoo #2
> > 2008-10-18T13:17:11+13:00
> > 2008-10-18T13:17:11+13:00 Call Trace:
> > 2008-10-18T13:17:11+13:00 [<ffffffff80238179>] ? __printk_ratelimit+0x9/0x10
> > 2008-10-18T13:17:11+13:00 [<ffffffff8026d4a7>] 
> > __alloc_pages_internal+0x3f7/0x450
> > 2008-10-18T13:17:11+13:00 [<ffffffff8026d51b>] __alloc_pages+0xb/0x10
> > 2008-10-18T13:17:11+13:00 [<ffffffff8026d535>] __get_free_pages+0x15/0x60
> > 2008-10-18T13:17:11+13:00 [<ffffffff8028ec94>] __kmalloc+0xb4/0xe0
> > 2008-10-18T13:17:11+13:00 
> > [<ffffffffa00cd64d>] :nilfs2:nilfs_ioctl_wrap_copy+0x3d/0x160
> > 2008-10-18T13:17:11+13:00 
> > [<ffffffffa00ce7e0>] ? :nilfs2:nilfs_ioctl_do_delete_checkpoints+0x0/0x70
> > 2008-10-18T13:17:11+13:00 
> > [<ffffffffa00ce59a>] :nilfs2:nilfs_ioctl_prepare_clean_segments+0x7a/0x100
> > 2008-10-18T13:17:11+13:00 
> > [<ffffffffa00c8330>] :nilfs2:nilfs_clean_segments+0x90/0x2d0
> > 2008-10-18T13:17:11+13:00 [<ffffffff8026c654>] ? free_compound_page+0x14/0x20
> > 2008-10-18T13:17:11+13:00 [<ffffffff8026fda6>] ? put_compound_page+0x26/0x40
> > 2008-10-18T13:17:11+13:00 [<ffffffff802704c7>] ? put_page+0xe7/0xf0
> > 2008-10-18T13:17:11+13:00 [<ffffffff8028d86e>] ? kfree+0x9e/0xb0
> > 2008-10-18T13:17:11+13:00 [<ffffffffa00cd8bd>] :nilfs2:nilfs_ioctl+0x10d/0x810
> > 2008-10-18T13:17:11+13:00 [<ffffffff802a1fce>] ? locks_free_lock+0x3e/0x60
> > 2008-10-18T13:17:11+13:00 [<ffffffff8029f1aa>] vfs_ioctl+0x7a/0x90
> > 2008-10-18T13:17:11+13:00 [<ffffffff8029f233>] do_vfs_ioctl+0x73/0x2c0
> > 2008-10-18T13:17:11+13:00 [<ffffffff8029f4ca>] sys_ioctl+0x4a/0x80
> > 2008-10-18T13:17:11+13:00 [<ffffffff8020b54b>] 
> > system_call_after_swapgs+0x7b/0x80
> > 2008-10-18T13:17:11+13:00
> > 2008-10-18T13:17:11+13:00 Mem-info:
> > 2008-10-18T13:17:11+13:00 DMA per-cpu:
> > 2008-10-18T13:17:11+13:00 CPU    0: hi:    0, btch:   1 usd:   0
> > 2008-10-18T13:17:11+13:00 CPU    1: hi:    0, btch:   1 usd:   0
> > 2008-10-18T13:17:11+13:00 DMA32 per-cpu:
> > 2008-10-18T13:17:11+13:00 CPU    0: hi:  186, btch:  31 usd:   0
> > 2008-10-18T13:17:11+13:00 CPU    1: hi:  186, btch:  31 usd:   1
> > 2008-10-18T13:17:11+13:00 Active:91467 inactive:128931 dirty:3984 writeback:0 
> > unstable:0
> > 2008-10-18T13:17:11+13:00 free:2450 slab:22579 mapped:11381 pagetables:3586 
> > bounce:0
> > 2008-10-18T13:17:11+13:00 DMA free:4100kB min:28kB low:32kB high:40kB 
> > active:96kB inactive:1132kB present:7520kB pages_scanned:0 all_unreclaimable? 
> > no
> > 2008-10-18T13:17:11+13:00 lowmem_reserve[]: 0 993 993 993
> > 2008-10-18T13:17:11+13:00 DMA32 free:5700kB min:4016kB low:5020kB high:6024kB 
> > active:365772kB inactive:514592kB present:1017196kB pages_scanned:0 
> > all_unreclaimable? no
> > 2008-10-18T13:17:11+13:00 lowmem_reserve[]: 0 0 0 0
> > 2008-10-18T13:17:11+13:00 DMA: 47*4kB 62*8kB 29*16kB 22*32kB 3*64kB 0*128kB 
> > 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 4092kB
> > 2008-10-18T13:17:11+13:00 DMA32: 622*4kB 57*8kB 70*16kB 30*32kB 12*64kB 
> > 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5792kB
> > 2008-10-18T13:17:11+13:00 150339 total pagecache pages
> > 2008-10-18T13:17:11+13:00 Swap cache: add 6408, delete 5672, find 409/587
> > 2008-10-18T13:17:11+13:00 Free swap  = 2077212kB
> > 2008-10-18T13:17:11+13:00 Total swap = 2097140kB
> > 2008-10-18T13:17:11+13:00 261920 pages of RAM
> > 2008-10-18T13:17:11+13:00 5977 reserved pages
> > 2008-10-18T13:17:11+13:00 148748 pages shared
> > 2008-10-18T13:17:11+13:00 736 pages swap cached
> > 2008-10-18T13:17:11+13:00 nilfs_cleanerd: page allocation failure. order:5, 
> > mode:0x4050
> > 2008-10-18T13:17:11+13:00 Pid: 4940, comm: nilfs_cleanerd Not tainted 
> > 2.6.26-gentoo #2
> > 2008-10-18T13:17:11+13:00
> > 2008-10-18T13:17:11+13:00 Call Trace:
> > 2008-10-18T13:17:11+13:00 [<ffffffff80238179>] ? __printk_ratelimit+0x9/0x10
> > 2008-10-18T13:17:11+13:00 [<ffffffff8026d4a7>] 
> > __alloc_pages_internal+0x3f7/0x450
> > 2008-10-18T13:17:11+13:00 [<ffffffff8026d51b>] __alloc_pages+0xb/0x10
> > 2008-10-18T13:17:11+13:00 [<ffffffff8026d535>] __get_free_pages+0x15/0x60
> > 2008-10-18T13:17:11+13:00 [<ffffffff8028ec94>] __kmalloc+0xb4/0xe0
> > 2008-10-18T13:17:11+13:00 
> > [<ffffffffa00cd64d>] :nilfs2:nilfs_ioctl_wrap_copy+0x3d/0x160
> > 2008-10-18T13:17:11+13:00 
> > [<ffffffffa00ceb20>] ? :nilfs2:nilfs_ioctl_do_free_vblocknrs+0x0/0x60
> > 2008-10-18T13:17:11+13:00 
> > [<ffffffffa00ce5b6>] :nilfs2:nilfs_ioctl_prepare_clean_segments+0x96/0x100
> > 2008-10-18T13:17:11+13:00 
> > [<ffffffffa00c8330>] :nilfs2:nilfs_clean_segments+0x90/0x2d0
> > 2008-10-18T13:17:11+13:00 [<ffffffff8026c654>] ? free_compound_page+0x14/0x20
> > 2008-10-18T13:17:11+13:00 [<ffffffff8026fda6>] ? put_compound_page+0x26/0x40
> > 2008-10-18T13:17:11+13:00 [<ffffffff802704c7>] ? put_page+0xe7/0xf0
> > 2008-10-18T13:17:11+13:00 [<ffffffff8028d86e>] ? kfree+0x9e/0xb0
> > 2008-10-18T13:17:11+13:00 [<ffffffffa00cd8bd>] :nilfs2:nilfs_ioctl+0x10d/0x810
> > 2008-10-18T13:17:11+13:00 [<ffffffff802a1fce>] ? locks_free_lock+0x3e/0x60
> > 2008-10-18T13:17:11+13:00 [<ffffffff8029f1aa>] vfs_ioctl+0x7a/0x90
> > 2008-10-18T13:17:11+13:00 [<ffffffff8029f233>] do_vfs_ioctl+0x73/0x2c0
> > 2008-10-18T13:17:11+13:00 [<ffffffff8029f4ca>] sys_ioctl+0x4a/0x80
> > 2008-10-18T13:17:11+13:00 [<ffffffff8020b54b>] 
> > system_call_after_swapgs+0x7b/0x80
> > 2008-10-18T13:17:11+13:00
> > 2008-10-18T13:17:11+13:00 Mem-info:
> > 2008-10-18T13:17:11+13:00 DMA per-cpu:
> > 2008-10-18T13:17:11+13:00 CPU    0: hi:    0, btch:   1 usd:   0
> > 2008-10-18T13:17:11+13:00 CPU    1: hi:    0, btch:   1 usd:   0
> > 2008-10-18T13:17:11+13:00 DMA32 per-cpu:
> > 2008-10-18T13:17:11+13:00 CPU    0: hi:  186, btch:  31 usd:   0
> > 2008-10-18T13:17:11+13:00 CPU    1: hi:  186, btch:  31 usd:   0
> > 2008-10-18T13:17:11+13:00 Active:91467 inactive:128894 dirty:3984 writeback:0 
> > unstable:0
> > 2008-10-18T13:17:11+13:00 free:2518 slab:22579 mapped:11381 pagetables:3586 
> > bounce:0
> > 2008-10-18T13:17:11+13:00 DMA free:4100kB min:28kB low:32kB high:40kB 
> > active:96kB inactive:1132kB present:7520kB pages_scanned:0 all_unreclaimable? 
> > no
> > 2008-10-18T13:17:11+13:00 lowmem_reserve[]: 0 993 993 993
> > 2008-10-18T13:17:11+13:00 DMA32 free:5972kB min:4016kB low:5020kB high:6024kB 
> > active:365772kB inactive:514444kB present:1017196kB pages_scanned:0 
> > all_unreclaimable? no
> > 2008-10-18T13:17:11+13:00 lowmem_reserve[]: 0 0 0 0
> > 2008-10-18T13:17:11+13:00 DMA: 47*4kB 62*8kB 29*16kB 22*32kB 3*64kB 0*128kB 
> > 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 4092kB
> > 2008-10-18T13:17:11+13:00 DMA32: 623*4kB 61*8kB 73*16kB 32*32kB 13*64kB 
> > 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 6004kB
> > 2008-10-18T13:17:11+13:00 150314 total pagecache pages
> > 2008-10-18T13:17:11+13:00 Swap cache: add 6415, delete 5679, find 409/587
> > 2008-10-18T13:17:11+13:00 Free swap  = 2077184kB
> > 2008-10-18T13:17:11+13:00 Total swap = 2097140kB
> > 2008-10-18T13:17:11+13:00 261920 pages of RAM
> > 2008-10-18T13:17:11+13:00 5977 reserved pages
> > 2008-10-18T13:17:11+13:00 148731 pages shared
> > 2008-10-18T13:17:11+13:00 736 pages swap cached
