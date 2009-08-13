From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: segctord problem
Date: Thu, 13 Aug 2009 16:10:04 +0900 (JST)
Message-ID: <20090813.161004.39219573.ryusuke@osrg.net>
References: <229792.17907.qm@web58802.mail.re1.yahoo.com>
	<20090812.122845.28893666.ryusuke@osrg.net>
	<875433.79601.qm@web58807.mail.re1.yahoo.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <875433.79601.qm-GGnPTbcu0TGB9c0Qi4KiSlZ8N9CAUha/QQ4Iyu8u01E@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org

Hi Eric,

Could you test with CONFIG_DEBUG_PREEMPT kernel option ?

You can turn on the option by checking the following config menu item:

  $ make menuconfig

   Kernel hacking --->
       [*] Debug preemtible kernel

With this option, kernel will detect preemption count underflows, and
I think this would help to identify the true cause of the problem.

Regards,
Ryusuke Konishi


On Wed, 12 Aug 2009 10:30:22 -0700 (PDT), Eric A wrote:
> I ran into the problem again.  It is definetely being caused by firefox.  I generally use uzbl, a webkit base browser, but after 5min of using firefox today, my syslog was filled with over 10 million lines!  Here's a sample:
> 
> Aug 12 12:53:39 gentoo klogd: BUG: scheduling while atomic: segctord/1274/0xfffffffe
> Aug 12 12:53:39 gentoo klogd: Modules linked in:
> Aug 12 12:53:39 gentoo klogd: Pid: 1274, comm: segctord Not tainted 2.6.31-rc5-git7 #1
> Aug 12 12:53:39 gentoo klogd: Call Trace:
> Aug 12 12:53:39 gentoo klogd:  [<ffffffff813c9821>] ? thread_return+0x4af/0x6ee
> Aug 12 12:53:39 gentoo klogd:  [<ffffffff8114431c>] ? nilfs_segctor_thread+0x33c/0x350
> Aug 12 12:53:39 gentoo klogd:  [<ffffffff81140760>] ? nilfs_construction_timeout+0x0/0x10
> Aug 12 12:53:39 gentoo klogd:  [<ffffffff810276d0>] ? __wake_up_common+0x50/0x80
> Aug 12 12:53:39 gentoo klogd:  [<ffffffff810481d0>] ? autoremove_wake_function+0x0/0x30
> Aug 12 12:53:39 gentoo klogd:  [<ffffffff81143fe0>] ? nilfs_segctor_thread+0x0/0x350
> Aug 12 12:53:39 gentoo klogd:  [<ffffffff81047e56>] ? kthread+0x96/0xa0
> Aug 12 12:53:39 gentoo klogd:  [<ffffffff8100c38a>] ? child_rip+0xa/0x20
> Aug 12 12:53:39 gentoo klogd:  [<ffffffff81047dc0>] ? kthread+0x0/0xa0
> Aug 12 12:53:39 gentoo klogd:  [<ffffffff8100c380>] ? child_rip+0x0/0x20
> Aug 12 12:53:39 gentoo klogd: BUG: scheduling while aaint7 #1
> Aug 12 12:53:39 gentoo klogd: <0x4af [<ff350
> Aug 12 12:53:39 gentoo klogd:  [<f0/0x10> [<ff0x30
> Aug 12 12:53:39 gentoo klogd: <0
> Aug 12 12:53:39 gentoo klogd:  fff8100ffff8104ff8100c380hedule
> Aug 12 12:53:39 gentoo klogd: Modulaint7 #1
> Aug 12 12:53:39 gentoo klogd: <0x4af [<ff350
> Aug 12 12:53:39 gentoo klogd:  [<f0/0x10
> Aug 12 12:53:39 gentoo klogd: > [<ff0x30
> Aug 12 12:53:39 gentoo klogd: <0
> Aug 12 12:53:39 gentoo klogd:  fff8100ffff8104ff8100c380hedule
> Aug 12 12:53:39 gentoo klogd: Moduain7 #1
> Aug 12 12:53:39 gentoo klogd: <0x4a [<ff350
> Aug 12 12:53:39 gentoo klogd:  [<f0/0x10
> Aug 12 12:53:39 gentoo klogd: > [<fff0x30
> Aug 12 12:53:39 gentoo klogd: <0
> Aug 12 12:53:39 gentoo klogd:  fff8100ffff8104ff8100c38hedule
> Aug 12 12:53:39 gentoo klogd: Modulainte7 #1
> Aug 12 12:53:39 gentoo klogd: <0x4af [<ff350
> Aug 12 12:53:39 gentoo klogd:  [<f0/0x10                                                           
> Aug 12 12:53:39 gentoo klogd: > [<ff0x30                                                           
> Aug 12 12:53:39 gentoo klogd: 0                                                                    
> Aug 12 12:53:39 gentoo klogd:  fff8100ffff810ff8100c38hedule
> Aug 12 12:53:39 gentoo klogd: Moduainte7 #1
> Aug 12 12:53:39 gentoo klogd: <0x4a [<ff350
> Aug 12 12:53:39 gentoo klogd:  [<f0/0x10> [<fff0x30
> Aug 12 12:53:39 gentoo klogd: <0
> Aug 12 12:53:39 gentoo klogd:  fff8100ffff8104ff8100c38hedule
> 
> .....
> 
> Aug 12 12:56:26 gentoo klogd: while <4>Pomm: Trace:ee
> Aug 12 12:56:26 gentoo klogd:  [<<4> [< [<fff/0x10
> Aug 12 12:56:26 gentoo klogd: 4> [<f0
> Aug 12 12:56:26 gentoo klogd:  read+0x0ead+0x96ld_riread+0x00
> Aug 12 12:56:26 gentoo klogd: while <4>Pomm: Trace:ee
> Aug 12 12:56:26 gentoo klogd:  [<<4> [< [<fffff/0x104> [<ff0
> Aug 12 12:56:26 gentoo klogd:  read+0x0ead+0x96/ld_riread+0x0/0
> Aug 12 12:56:26 gentoo klogd: <3while <4>Piomm: Trace:ee
> Aug 12 12:56:26 gentoo klogd:  <4> [< [<ff/0x10
> Aug 12 12:56:26 gentoo klogd: 4> [<f0
> Aug 12 12:56:26 gentoo klogd:  read+0xead+0x96/0ld_riread+0x0/00
> Aug 12 12:56:26 gentoo klogd: <while <4>Pomm: Trace:ee
> Aug 12 12:56:26 gentoo klogd:  [<<4> [< [<ffff/0x10
> Aug 12 12:56:26 gentoo klogd: 4> [<f0
> Aug 12 12:56:26 gentoo klogd:  read+0x0/ead+0x96/ld_riread+0x0/0
> 
> ....
> 
> Eric
> 
> 
> 
> ________________________________
> From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
> To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
> Sent: Tuesday, August 11, 2009 11:28:45 PM
> Subject: Re: [NILFS users] segctord problem
> 
> Hi!
> On Tue, 11 Aug 2009 18:28:05 -0700 (PDT), Eric A wrote:
> > I'm using the latest vanilla kernel (2.6.31-rc5-git7).  My distro is Gentoo with nilfs-utils-2.0.14.
> > 
> > Eric
> > 
> > 
> > 
> > ________________________________
> > From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> > To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
> > Sent: Tuesday, August 11, 2009 8:46:45 PM
> > Subject: Re: [NILFS users] segctord problem
> > 
> > Hi,
> > 
> > > I have been using nilfs as my rootfs for several weeks now and have been
> > > experiencing random problems.  X programs will be become unresponsive and top
> > > will show that segctord is using ~50%hi (100% of one core).
> > 
> > Which version of kernel and distro are you using?
> 
> According to your log, preemption count of the log-writer thread goes
> wrong; it must be equal or greater than 0, but your log shows it
> became -1 (0xffffffff) maybe due to some kind of bug in nilfs.
> 
> > Aug 11 17:00:59 gentoo klogd: BUG: scheduling while atomic: segctord/1312/0xffffffff
> 
> I'm looking at this problem, but I don't have no clue why this
> happened.
> 
> Is it reproducible after reboot?
> 
> Thanks,
> Ryusuke Konishi
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
