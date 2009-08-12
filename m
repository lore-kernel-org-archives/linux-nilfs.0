From: Eric A <eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: segctord problem
Date: Wed, 12 Aug 2009 10:30:22 -0700 (PDT)
Message-ID: <875433.79601.qm@web58807.mail.re1.yahoo.com>
References: <949415.6494.qm@web58808.mail.re1.yahoo.com>
	<877hx9g8p6.wl%jir@sekiba.com>
	<229792.17907.qm@web58802.mail.re1.yahoo.com>
	<20090812.122845.28893666.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1743857972=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090812.122845.28893666.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

--===============1743857972==
Content-Type: multipart/alternative; boundary="0-1573074304-1250098222=:79601"

--0-1573074304-1250098222=:79601
Content-Type: text/plain; charset=us-ascii

I ran into the problem again.  It is definetely being caused by firefox.  I generally use uzbl, a webkit base browser, but after 5min of using firefox today, my syslog was filled with over 10 million lines!  Here's a sample:

Aug 12 12:53:39 gentoo klogd: BUG: scheduling while atomic: segctord/1274/0xfffffffe
Aug 12 12:53:39 gentoo klogd: Modules linked in:
Aug 12 12:53:39 gentoo klogd: Pid: 1274, comm: segctord Not tainted 2.6.31-rc5-git7 #1
Aug 12 12:53:39 gentoo klogd: Call Trace:
Aug 12 12:53:39 gentoo klogd:  [<ffffffff813c9821>] ? thread_return+0x4af/0x6ee
Aug 12 12:53:39 gentoo klogd:  [<ffffffff8114431c>] ? nilfs_segctor_thread+0x33c/0x350
Aug 12 12:53:39 gentoo klogd:  [<ffffffff81140760>] ? nilfs_construction_timeout+0x0/0x10
Aug 12 12:53:39 gentoo klogd:  [<ffffffff810276d0>] ? __wake_up_common+0x50/0x80
Aug 12 12:53:39 gentoo klogd:  [<ffffffff810481d0>] ? autoremove_wake_function+0x0/0x30
Aug 12 12:53:39 gentoo klogd:  [<ffffffff81143fe0>] ? nilfs_segctor_thread+0x0/0x350
Aug 12 12:53:39 gentoo klogd:  [<ffffffff81047e56>] ? kthread+0x96/0xa0
Aug 12 12:53:39 gentoo klogd:  [<ffffffff8100c38a>] ? child_rip+0xa/0x20
Aug 12 12:53:39 gentoo klogd:  [<ffffffff81047dc0>] ? kthread+0x0/0xa0
Aug 12 12:53:39 gentoo klogd:  [<ffffffff8100c380>] ? child_rip+0x0/0x20
Aug 12 12:53:39 gentoo klogd: BUG: scheduling while aaint7 #1
Aug 12 12:53:39 gentoo klogd: <0x4af [<ff350
Aug 12 12:53:39 gentoo klogd:  [<f0/0x10> [<ff0x30
Aug 12 12:53:39 gentoo klogd: <0
Aug 12 12:53:39 gentoo klogd:  fff8100ffff8104ff8100c380hedule
Aug 12 12:53:39 gentoo klogd: Modulaint7 #1
Aug 12 12:53:39 gentoo klogd: <0x4af [<ff350
Aug 12 12:53:39 gentoo klogd:  [<f0/0x10
Aug 12 12:53:39 gentoo klogd: > [<ff0x30
Aug 12 12:53:39 gentoo klogd: <0
Aug 12 12:53:39 gentoo klogd:  fff8100ffff8104ff8100c380hedule
Aug 12 12:53:39 gentoo klogd: Moduain7 #1
Aug 12 12:53:39 gentoo klogd: <0x4a [<ff350
Aug 12 12:53:39 gentoo klogd:  [<f0/0x10
Aug 12 12:53:39 gentoo klogd: > [<fff0x30
Aug 12 12:53:39 gentoo klogd: <0
Aug 12 12:53:39 gentoo klogd:  fff8100ffff8104ff8100c38hedule
Aug 12 12:53:39 gentoo klogd: Modulainte7 #1
Aug 12 12:53:39 gentoo klogd: <0x4af [<ff350
Aug 12 12:53:39 gentoo klogd:  [<f0/0x10                                                           
Aug 12 12:53:39 gentoo klogd: > [<ff0x30                                                           
Aug 12 12:53:39 gentoo klogd: 0                                                                    
Aug 12 12:53:39 gentoo klogd:  fff8100ffff810ff8100c38hedule
Aug 12 12:53:39 gentoo klogd: Moduainte7 #1
Aug 12 12:53:39 gentoo klogd: <0x4a [<ff350
Aug 12 12:53:39 gentoo klogd:  [<f0/0x10> [<fff0x30
Aug 12 12:53:39 gentoo klogd: <0
Aug 12 12:53:39 gentoo klogd:  fff8100ffff8104ff8100c38hedule

.....

Aug 12 12:56:26 gentoo klogd: while <4>Pomm: Trace:ee
Aug 12 12:56:26 gentoo klogd:  [<<4> [< [<fff/0x10
Aug 12 12:56:26 gentoo klogd: 4> [<f0
Aug 12 12:56:26 gentoo klogd:  read+0x0ead+0x96ld_riread+0x00
Aug 12 12:56:26 gentoo klogd: while <4>Pomm: Trace:ee
Aug 12 12:56:26 gentoo klogd:  [<<4> [< [<fffff/0x104> [<ff0
Aug 12 12:56:26 gentoo klogd:  read+0x0ead+0x96/ld_riread+0x0/0
Aug 12 12:56:26 gentoo klogd: <3while <4>Piomm: Trace:ee
Aug 12 12:56:26 gentoo klogd:  <4> [< [<ff/0x10
Aug 12 12:56:26 gentoo klogd: 4> [<f0
Aug 12 12:56:26 gentoo klogd:  read+0xead+0x96/0ld_riread+0x0/00
Aug 12 12:56:26 gentoo klogd: <while <4>Pomm: Trace:ee
Aug 12 12:56:26 gentoo klogd:  [<<4> [< [<ffff/0x10
Aug 12 12:56:26 gentoo klogd: 4> [<f0
Aug 12 12:56:26 gentoo klogd:  read+0x0/ead+0x96/ld_riread+0x0/0

....

Eric



________________________________
From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Sent: Tuesday, August 11, 2009 11:28:45 PM
Subject: Re: [NILFS users] segctord problem

Hi!
On Tue, 11 Aug 2009 18:28:05 -0700 (PDT), Eric A wrote:
> I'm using the latest vanilla kernel (2.6.31-rc5-git7).  My distro is Gentoo with nilfs-utils-2.0.14.
> 
> Eric
> 
> 
> 
> ________________________________
> From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
> Sent: Tuesday, August 11, 2009 8:46:45 PM
> Subject: Re: [NILFS users] segctord problem
> 
> Hi,
> 
> > I have been using nilfs as my rootfs for several weeks now and have been
> > experiencing random problems.  X programs will be become unresponsive and top
> > will show that segctord is using ~50%hi (100% of one core).
> 
> Which version of kernel and distro are you using?

According to your log, preemption count of the log-writer thread goes
wrong; it must be equal or greater than 0, but your log shows it
became -1 (0xffffffff) maybe due to some kind of bug in nilfs.

> Aug 11 17:00:59 gentoo klogd: BUG: scheduling while atomic: segctord/1312/0xffffffff

I'm looking at this problem, but I don't have no clue why this
happened.

Is it reproducible after reboot?

Thanks,
Ryusuke Konishi
_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users



      
--0-1573074304-1250098222=:79601
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:'times new roman', 'new york', times, serif;font-size:12pt"><div>I ran into the problem again. &nbsp;It is definetely being caused by firefox. &nbsp;I generally use uzbl, a webkit base browser, but after 5min of using firefox today, my syslog was filled with over 10 million lines! &nbsp;Here's a sample:</div><div><br></div><div><div>Aug 12 12:53:39 gentoo klogd: BUG: scheduling while atomic: segctord/1274/0xfffffffe</div><div>Aug 12 12:53:39 gentoo klogd: Modules linked in:</div><div>Aug 12 12:53:39 gentoo klogd: Pid: 1274, comm: segctord Not tainted 2.6.31-rc5-git7 #1</div><div>Aug 12 12:53:39 gentoo klogd: Call Trace:</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;ffffffff813c982
 1&gt;] ? thread_return+0x4af/0x6ee</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;ffffffff8114431c&gt;] ? nilfs_segctor_thread+0x33c/0x350</div><div>Aug 12 12:53:39
 gentoo klogd: &nbsp;[&lt;ffffffff81140760&gt;] ? nilfs_construction_timeout+0x0/0x10</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;ffffffff810276d0&gt;] ? __wake_up_common+0x50/0x80</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;ffffffff810481d0&gt;] ? autoremove_wake_function+0x0/0x30</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;ffffffff81143fe0&gt;] ? nilfs_segctor_thread+0x0/0x350</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;ffffffff81047e56&gt;] ? kthread+0x96/0xa0</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;ffffffff8100c38a&gt;] ? child_rip+0xa/0x20</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;ffffffff81047dc0&gt;] ? kthread+0x0/0xa0</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;ffffffff8100c380&gt;] ? child_rip+0x0/0x20</div><div>Aug 12 12:53:3
 9 gentoo klogd: BUG: scheduling while aaint7 #1</div><div>Aug 12 12:53:39 gentoo klogd: &lt;0x4af [&lt;ff350</div><div>Aug 12 12:53:39 gentoo klogd:
 &nbsp;[&lt;f0/0x10&gt; [&lt;ff0x30</div><div>Aug 12 12:53:39 gentoo klogd: &lt;0</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;fff8100ffff8104ff8100c380hedule</div><div>Aug 12 12:53:39 gentoo klogd: Modulaint7 #1</div><div>Aug 12 12:53:39 gentoo klogd: &lt;0x4af [&lt;ff350</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;f0/0x10</div><div>Aug 12 12:53:39 gentoo klogd: &gt; [&lt;ff0x30</div><div>Aug 12 12:53:39 gentoo klogd: &lt;0</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;fff8100ffff8104ff8100c380hedule</div><div>Aug 12 12:53:39 gentoo klogd: Moduain7 #1</div><div>Aug 12 12:53:39 gentoo klogd: &lt;0x4a [&lt;ff350</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;f0/0x10</div><div>Aug 12 12:53:39 gentoo klogd: &gt; [&lt;fff0x30</div><div>Aug 12 12:53:39 gentoo klogd: &lt;0</div><div>
 Aug 12 12:53:39 gentoo klogd: &nbsp;fff8100ffff8104ff8100c38hedule</div><div>Aug 12 12:53:39 gentoo klogd: Modulainte7 #1</div><div>Aug 12 12:53:39 gentoo klogd:
 &lt;0x4af [&lt;ff350</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;f0/0x10 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div><div>Aug 12 12:53:39 gentoo klogd: &gt; [&lt;ff0x30 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div><div>Aug 12 12:53:39 gentoo klogd: 0 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;fff8100ffff810ff8100c38hedule</div><div>Aug 12 12:53:39 gentoo klogd: Moduainte7
 #1</div><div>Aug 12 12:53:39 gentoo klogd: &lt;0x4a [&lt;ff350</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;[&lt;f0/0x10&gt; [&lt;fff0x30</div><div>Aug 12 12:53:39 gentoo klogd: &lt;0</div><div>Aug 12 12:53:39 gentoo klogd: &nbsp;fff8100ffff8104ff8100c38hedule</div><div><br></div><div>....</div><div><br></div><div><div>Aug 12 12:56:26 gentoo klogd: while &lt;4&gt;Pomm: Trace:ee</div><div>Aug 12 12:56:26 gentoo klogd: &nbsp;[&lt;&lt;4&gt; [&lt; [&lt;fff/0x10</div><div>Aug 12 12:56:26 gentoo klogd: 4&gt; [&lt;f0</div><div>Aug 12 12:56:26 gentoo klogd: &nbsp;read+0x0ead+0x96ld_riread+0x00</div><div>Aug 12 12:56:26 gentoo klogd: while &lt;4&gt;Pomm: Trace:ee</div><div>Aug 12 12:56:26 gentoo klogd: &nbsp;[&lt;&lt;4&gt; [&lt; [&lt;fffff/0x104&gt; [&lt;ff0</div><div>Aug 12 12:56:26 gentoo klogd
 : &nbsp;read+0x0ead+0x96/ld_riread+0x0/0</div><div>Aug 12 12:56:26 gentoo klogd: &lt;3while &lt;4&gt;Piomm: Trace:ee</div><div>Aug 12 12:56:26 gentoo klogd:
 &nbsp;&lt;4&gt; [&lt; [&lt;ff/0x10</div><div>Aug 12 12:56:26 gentoo klogd: 4&gt; [&lt;f0</div><div>Aug 12 12:56:26 gentoo klogd: &nbsp;read+0xead+0x96/0ld_riread+0x0/00</div><div>Aug 12 12:56:26 gentoo klogd: &lt;while &lt;4&gt;Pomm: Trace:ee</div><div>Aug 12 12:56:26 gentoo klogd: &nbsp;[&lt;&lt;4&gt; [&lt; [&lt;ffff/0x10</div><div>Aug 12 12:56:26 gentoo klogd: 4&gt; [&lt;f0</div><div>Aug 12 12:56:26 gentoo klogd: &nbsp;read+0x0/ead+0x96/ld_riread+0x0/0</div><div><br></div><div>...</div><div><br></div><div>Eric</div></div></div><div style="font-family:times new roman, new york, times, serif;font-size:12pt"><br><div style="font-family:arial, helvetica, sans-serif;font-size:13px"><font size="2" face="Tahoma"><hr size="1"><b><span style="font-weight: bold;">From:</span></b> Ryusuke Konishi 
 &lt;ryusuke-sG5X7nlA6pw@public.gmane.org&gt;<br><b><span style="font-weight: bold;">To:</span></b> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org<br><b><span style="font-weight:
 bold;">Sent:</span></b> Tuesday, August 11, 2009 11:28:45 PM<br><b><span style="font-weight: bold;">Subject:</span></b> Re: [NILFS users] segctord problem<br></font><br>
Hi!<br>On Tue, 11 Aug 2009 18:28:05 -0700 (PDT), Eric A wrote:<br>&gt; I'm using the latest vanilla kernel (2.6.31-rc5-git7).&nbsp; My distro is Gentoo with nilfs-utils-2.0.14.<br>&gt; <br>&gt; Eric<br>&gt; <br>&gt; <br>&gt; <br>&gt; ________________________________<br>&gt; From: Jiro SEKIBA &lt;<a ymailto="mailto:jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org" href="mailto:jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org">jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org</a>&gt;<br>&gt; To: NILFS Users mailing list &lt;<a ymailto="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org" href="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a>&gt;<br>&gt; Sent: Tuesday, August 11, 2009 8:46:45 PM<br>&gt; Subject: Re: [NILFS users] segctord problem<br>&gt; <br>&gt; Hi,<br>&gt; <br>&gt; &gt; I have been using nilfs as my rootfs for several weeks now and have been<br>&gt; &gt; experiencing random problems.&nbsp; X programs will be be
 come unresponsive and top<br>&gt; &gt; will show that segctord is using ~50%hi (100% of one core).<br>&gt; <br>&gt; Which version of kernel and distro are you
 using?<br><br>According to your log, preemption count of the log-writer thread goes<br>wrong; it must be equal or greater than 0, but your log shows it<br>became -1 (0xffffffff) maybe due to some kind of bug in nilfs.<br><br>&gt; Aug 11 17:00:59 gentoo klogd: BUG: scheduling while atomic: segctord/1312/0xffffffff<br><br>I'm looking at this problem, but I don't have no clue why this<br>happened.<br><br>Is it reproducible after reboot?<br><br>Thanks,<br>Ryusuke Konishi<br>_______________________________________________<br>users mailing list<br><a ymailto="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org" href="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br><a href="https://www.nilfs.org/mailman/listinfo/users" target="_blank">https://www.nilfs.org/mailman/listinfo/users</a><br></div></div><div style="position:fixed"
 ></div></div><br>



      </body></html>
--0-1573074304-1250098222=:79601--


--===============1743857972==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1743857972==--

