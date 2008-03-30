From: Alexander Schier <alex-W0ZHf6uU1cg@public.gmane.org>
Subject: Re: Resolved? Was: Kernel Bug while deleting files
	(with rsync)
Date: Sun, 30 Mar 2008 11:29:55 +0200
Message-ID: <20080330092955.GA11598@laxu.de>
References: <20080327132327.GA3562@laxu.de> <20080328181211.GA19581@laxu.de>
	<20080328194039.GA28685@laxu.de>
	<20080330.140417.27795318.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080330.140417.27795318.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi!
On Sun, Mar 30, 2008 at 02:04:17PM +0900, Ryusuke Konishi wrote:
> Hi Alex,
> 
> > OK, it seems to work for me, after ...
> > -using a debian 2.6.24 kernel instead of a selfcompiled 2.6.22
> > -maybe the 2.6.22 had a different compiler than the nilfs2 module
No BUG since this.
> > at the moment rsync works perfectly.
> > 
> > I'll mail again, if it has the BUG again. Until then, it seems resolved.
> > ;)
> I see. I'll wait for your next report breathlessly. :)
Sorry, seems it was my mistake.

> So far, we haven't been able to reproduce the problem by tests
> in a similar fashion.
You must know, if this can be caused by wrong compiler only, or if the
bug may exist hidden in the Source, and was only triggered by this.
Another option may be, that my self-compiled kernel missed some option,
which nilfs uses, but does not depend on in Makefile?

You're the Coders, i can only guess and be happy it works fine with current
configuration.

> This might be caused by a defect of exclusion control.
> If so, it's hard to track it by phenomena.
> So, I'll think reviewing the source code of related parts
> during making kernel patches of NILFS.
keep improving ;)

Alex
