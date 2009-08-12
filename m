From: Eric A <eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: segctord problem
Date: Tue, 11 Aug 2009 21:12:01 -0700 (PDT)
Message-ID: <255429.87566.qm@web58802.mail.re1.yahoo.com>
References: <949415.6494.qm@web58808.mail.re1.yahoo.com>
	<877hx9g8p6.wl%jir@sekiba.com>
	<229792.17907.qm@web58802.mail.re1.yahoo.com>
	<20090812.122845.28893666.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1042219916=="
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

--===============1042219916==
Content-Type: multipart/alternative; boundary="0-390670354-1250050321=:87566"

--0-390670354-1250050321=:87566
Content-Type: text/plain; charset=us-ascii






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



      
--0-390670354-1250050321=:87566
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:'times new roman', 'new york', times, serif;font-size:12pt"><div><br></div><div style="font-family:times new roman, new york, times, serif;font-size:12pt"><br><div style="font-family:arial, helvetica, sans-serif;font-size:13px"><font size="2" face="Tahoma"><hr size="1"><b><span style="font-weight: bold;">From:</span></b> Ryusuke Konishi &lt;ryusuke-sG5X7nlA6pw@public.gmane.org&gt;<br><b><span style="font-weight: bold;">To:</span></b> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org<br><b><span style="font-weight: bold;">Sent:</span></b> Tuesday, August 11, 2009 11:28:45 PM<br><b><span style="font-weight: bold;">Subject:</span></b> Re: [NILFS users] segctord problem<br></font><br> Hi!<br>On Tue, 11 Aug 2009 18:28:05 
 -0700 (PDT), Eric A wrote:<br>&gt; I'm using the latest vanilla kernel (2.6.31-rc5-git7).&nbsp; My distro is Gentoo with nilfs-utils-2.0.14.<br>&gt; <br>&gt;
 Eric<br>&gt; <br>&gt; <br>&gt; <br>&gt; ________________________________<br>&gt; From: Jiro SEKIBA &lt;<a ymailto="mailto:jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org" href="mailto:jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org">jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org</a>&gt;<br>&gt; To: NILFS Users mailing list &lt;<a ymailto="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org" href="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a>&gt;<br>&gt; Sent: Tuesday, August 11, 2009 8:46:45 PM<br>&gt; Subject: Re: [NILFS users] segctord problem<br>&gt; <br>&gt; Hi,<br>&gt; <br>&gt; &gt; I have been using nilfs as my rootfs for several weeks now and have been<br>&gt; &gt; experiencing random problems.&nbsp; X programs will be become unresponsive and top<br>&gt; &gt; will show that segctord is using ~50%hi (100% of one core).<br>&gt; <br>&gt; Which version of kernel and distro are you using?<br><br>According to your lo
 g, preemption count of the log-writer thread goes<br>wrong; it must be equal or greater than 0, but your log shows it<br>became -1 (0xffffffff) maybe due to some kind
 of bug in nilfs.<br><br>&gt; Aug 11 17:00:59 gentoo klogd: BUG: scheduling while atomic: segctord/1312/0xffffffff<br><br>I'm looking at this problem, but I don't have no clue why this<br>happened.<br><br>Is it reproducible after reboot?<br><br>Thanks,<br>Ryusuke Konishi<br>_______________________________________________<br>users mailing list<br><a ymailto="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org" href="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br><a href="https://www.nilfs.org/mailman/listinfo/users" target="_blank">https://www.nilfs.org/mailman/listinfo/users</a><br></div></div><div style="position:fixed"></div></div><br>



      </body></html>
--0-390670354-1250050321=:87566--


--===============1042219916==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1042219916==--

