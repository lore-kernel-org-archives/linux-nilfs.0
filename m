From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: segctord problem
Date: Wed, 12 Aug 2009 12:28:45 +0900 (JST)
Message-ID: <20090812.122845.28893666.ryusuke@osrg.net>
References: <949415.6494.qm@web58808.mail.re1.yahoo.com>
	<877hx9g8p6.wl%jir@sekiba.com>
	<229792.17907.qm@web58802.mail.re1.yahoo.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <229792.17907.qm-f9L/0AEUy02B9c0Qi4KiSlZ8N9CAUha/QQ4Iyu8u01E@public.gmane.org>
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
