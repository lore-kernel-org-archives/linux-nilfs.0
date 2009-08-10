From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: kernel oops on shrink_page_list (was Re: Crash...)
Date: Mon, 10 Aug 2009 15:54:20 +0900 (JST)
Message-ID: <20090810.155420.42596352.ryusuke@osrg.net>
References: <20090729.124638.38314632.ryusuke@osrg.net>
	<874osw14pz.wl%jir@sekiba.com>
	<20090729.140821.103585622.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090729.140821.103585622.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
Cc: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org

Hi,

Recently, I saw this oops rather frequently for the latest
nilfs2-module.git, which applied a bunch of patches backported from
2.6.31-rc.

So, I'm doing git bisect to find out the cause for the changes since
nilfs-2.0.15.  So far, nilfs-2.0.15 seems stable to me.

If you see this oops on the nilfs-2.0.15 or prior versions (or at
kernel-2.6.30), please let me know.


Thanks,
Ryusuke Konishi

On Wed, 29 Jul 2009 14:08:21 +0900 (JST), Ryusuke Konishi wrote:
> On Wed, 29 Jul 2009 13:40:56 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> > Hi,
> > 
> > At Wed, 29 Jul 2009 12:46:38 +0900 (JST),
> > Ryusuke Konishi wrote:
> > > 
> > > Hi,
> > > On Wed, 29 Jul 2009 11:49:12 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> > > > Hi, 
> > > > 
> > > > > I tried to reproduce the situation, but I can not reproduce the bug
> > > > > with rc4, rc4+experimental on debian/lenny. 
> > > > 
> > > >  Well, when I tried I got different kernel dump.
> > > > I don't know if it's related or not, but just in case.
> > > > 
> > > >  I got following with rc4 with device mapper, created nilfs2 filesystem on
> > > > it during rsync on the filesystem.
> > > 
> > > shrink_page_list() is a core memory management function to reclaim
> > > free pages.
> > > 
> > > Could you send me the disassembled source of mm/vmscan.o ?
> > > You cat get it by using objdump command:
> > 
> > Here is the corresponded dump of shrink_page_list:
> > 
> >      ee4:       85 c0                   test   %eax,%eax
> >      ee6:       0f 84 d1 02 00 00       je     11bd <shrink_page_list+0x559>
> >      eec:       f0 80 65 d8 ef          lock andb $0xef,-0x28(%rbp)
> >      ef1:       48 c7 c6 00 00 00 00    mov    $0x0,%rsi
> >      ef8:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
> >      eff:       31 c0                   xor    %eax,%eax
> >      f01:       e8 00 00 00 00          callq  f06 <shrink_page_list+0x2a2>
> >      f06:       e9 b6 01 00 00          jmpq   10c1 <shrink_page_list+0x45d>
> >      f0b:       49 8b 44 24 58          mov    0x58(%r12),%rax
> >      f10:       48 83 38 00             cmpq   $0x0,(%rax)
> >      f14:       0f 84 79 02 00 00       je     1193 <shrink_page_list+0x52f>
> >      f1a:       65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
> >      f21:       00 00 
> >      f23:       f6 40 16 80             testb  $0x80,0x16(%rax)
> > 
> > looks like <48> is cmpq at f10.
> 
> Thanks.
> 
> It looks like a part of the pageout() function inlined in the
> shrink_page_list().
> 
> static pageout_t pageout(struct page *page, struct address_space *mapping,
>                                                 enum pageout_io sync_writeback)
> {
> 	...
>         if (!is_page_cache_freeable(page))
>                 return PAGE_KEEP;
>         if (!mapping) {
>                 /*
>                  * Some data journaling orphaned pages can have
>                  * page->mapping == NULL while being dirty with clean buffers.
>                  */
>                 if (page_has_private(page)) {
>                         if (try_to_free_buffers(page)) {
>                                 ClearPageDirty(page);
>                                 printk("%s: orphaned page\n", __func__);
>                                 return PAGE_CLEAN;
>                         }
>                 }
>                 return PAGE_KEEP;
>         }
>         if (mapping->a_ops->writepage == NULL)
>                 return PAGE_ACTIVATE;
>        ...
> 
> The above ``a_ops->writepage'' causes the violative access.  According
> to your log, mapping->a_ops (= RAX) seems to store a meaningless value.
> 
> Maybe the mapping->a_ops is not set on the page.
> 
> Ok, I'll check if nilfs can cause this sort of problem.
> 
> Thanks,
> Ryusuke Konishi
> 
> > >  $ cd linux/mm
> > >  $ objdump -D vmscan.o > vmscan.s
> > > 
> > > The instruction in question is that has the code "<48>" in the
> > > following sequence.
> > > 
> > > > [405816.060688] Code: c0 0f 84 d1 02 00 00 f0 80 65 d8 ef 48 c7 c6 e0 b9 2a 81 48 c7 c7 26 fc 32 81 31 c0 e8 02 d0 1e 00 e9 b6 01 00 00 49 8b 44 24 58 <48> 83 38 00 0f 84 79 02 00 00 65 48 8b 04 25 00 b0 00 00 f6 40 
> > > 
> > > Cheers,
> > > Ryusuke Konishi 
> > >  
> > > > [405816.059174] general protection fault: 0000 [#1] SMP 
> > > > [405816.059205] last sysfs file: /sys/block/dm-0/removable
> > > > [405816.059233] CPU 0 
> > > > [405816.059255] Modules linked in: dm_mod nilfs2 ipv6 loop snd_hda_codec_realtek i2c_i801 i2c_core iTCO_wdt serio_raw snd_hda_intel snd_hda_codec pcspkr psmouse snd_pcm snd_timer snd button processor soundcore intel_agp snd_page_alloc evdev ext3 jbd mbcache raid10 raid456 raid6_pq async_xor async_memcpy async_tx xor raid1 raid0 multipath linear md_mod sg sr_mod sd_mod cdrom ahci libata scsi_mod tg3 libphy uhci_hcd ehci_hcd thermal fan thermal_sys
> > > > [405816.059462] Pid: 215, comm: kswapd0 Not tainted 2.6.31-rc4 #1 N8-S720XMZCUUA2
> > > > [405816.059504] RIP: 0010:[<ffffffff810a2ac0>]  [<ffffffff810a2ac0>] shrink_page_list+0x2ac/0x609
> > > > [405816.059554] RSP: 0018:ffff88016cec1a40  EFLAGS: 00010282
> > > > [405816.059579] RAX: e7d50c6d4d1428d2 RBX: ffffea0003f5fbb0 RCX: 0000000000000800
> > > > [405816.059621] RDX: 0000000000000002 RSI: 0000000000000001 RDI: 0000000000000000
> > > > [405816.059663] RBP: ffffea0003f5fbd8 R08: 0000000000000001 R09: ffff88016fc075c0
> > > > [405816.059705] R10: 00003ffffffff000 R11: ffff88007a26f880 R12: ffff8801506f41a8
> > > > [405816.059747] R13: 0000000000000001 R14: 000000000000e800 R15: ffff88016cec1e10
> > > > [405816.059789] FS:  0000000000000000(0000) GS:ffff880028028000(0000) knlGS:0000000000000000
> > > > [405816.059833] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > > > [405816.059858] CR2: 0000000001ae9618 CR3: 000000016c802000 CR4: 00000000000406f0
> > > > [405816.059900] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > [405816.059943] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > [405816.059985] Process kswapd0 (pid: 215, threadinfo ffff88016cec0000, task ffff88016f27f930)
> > > > [405816.060028] Stack:
> > > > [405816.060047]  0000000000000001 ffff88016cec1af0 0000000000000000 ffff88016cec1cb0
> > > > [405816.060078] <0> 0000000000000000 0000000000000017 0000000000000009 0000000000000001
> > > > [405816.060124] <0> ffffea00039702b8 ffffea0004aa0458 ffffea0004aa0810 ffffea0003970248
> > > > [405816.060185] Call Trace:
> > > > [405816.060208]  [<ffffffff8100c40e>] ? common_interrupt+0xe/0x13
> > > > [405816.060234]  [<ffffffff810a1cdb>] ? isolate_pages_global+0xa9/0x1f3
> > > > [405816.060262]  [<ffffffff810a338a>] ? shrink_list+0x2d8/0x5ec
> > > > [405816.060289]  [<ffffffff8110ac52>] ? proc_delete_inode+0x0/0x40
> > > > [405816.060317]  [<ffffffff8109f621>] ? determine_dirtyable_memory+0xd/0x1d
> > > > [405816.060345]  [<ffffffff8109f697>] ? get_dirty_limits+0x1d/0x256
> > > > [405816.060371]  [<ffffffff8100a54d>] ? __switch_to+0xae/0x266
> > > > [405816.060397]  [<ffffffff810a3921>] ? shrink_zone+0x283/0x335
> > > > [405816.060427]  [<ffffffffa0189217>] ? mb_cache_shrink_fn+0x26/0x117 [mbcache]
> > > > [405816.060456]  [<ffffffff810a3b14>] ? shrink_slab+0x141/0x153
> > > > [405816.060482]  [<ffffffff810a42ff>] ? kswapd+0x482/0x631
> > > > [405816.060507]  [<ffffffff810a1c32>] ? isolate_pages_global+0x0/0x1f3
> > > > [405816.060536]  [<ffffffff81053522>] ? autoremove_wake_function+0x0/0x2e
> > > > [405816.060564]  [<ffffffff810a3e7d>] ? kswapd+0x0/0x631
> > > > [405816.060588]  [<ffffffff810531d9>] ? kthread+0x84/0x8c
> > > > [405816.060614]  [<ffffffff8100caca>] ? child_rip+0xa/0x20
> > > > [405816.060639]  [<ffffffff81053155>] ? kthread+0x0/0x8c
> > > > [405816.060664]  [<ffffffff8100cac0>] ? child_rip+0x0/0x20
> > > > [405816.060688] Code: c0 0f 84 d1 02 00 00 f0 80 65 d8 ef 48 c7 c6 e0 b9 2a 81 48 c7 c7 26 fc 32 81 31 c0 e8 02 d0 1e 00 e9 b6 01 00 00 49 8b 44 24 58 <48> 83 38 00 0f 84 79 02 00 00 65 48 8b 04 25 00 b0 00 00 f6 40 
> > > > [405816.060819] RIP  [<ffffffff810a2ac0>] shrink_page_list+0x2ac/0x609
> > > > [405816.060847]  RSP <ffff88016cec1a40>
> > > > [405816.061045] ---[ end trace c44a8d41c1aab2f3 ]---
> > > > 
> > > > 
> > > > 
> > > > 
> > > > -- 
> > > > Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> > > > _______________________________________________
> > > > users mailing list
> > > > users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> > > > https://www.nilfs.org/mailman/listinfo/users
> > > _______________________________________________
> > > users mailing list
> > > users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> > > https://www.nilfs.org/mailman/listinfo/users
> > > 
> > > 
> > > 
> > 
> > 
> > -- 
> > Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> > _______________________________________________
> > users mailing list
> > users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> > https://www.nilfs.org/mailman/listinfo/users
