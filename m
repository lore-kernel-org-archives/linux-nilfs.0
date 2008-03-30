From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Resolved? Was: Kernel Bug while deleting files
	(with rsync)
Date: Sun, 30 Mar 2008 14:04:17 +0900 (JST)
Message-ID: <20080330.140417.27795318.ryusuke@osrg.net>
References: <20080327132327.GA3562@laxu.de> <20080328181211.GA19581@laxu.de>
	<20080328194039.GA28685@laxu.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080328194039.GA28685-W0ZHf6uU1cg@public.gmane.org>
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
Content-Type: Text/Plain; charset="us-ascii"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, alex-W0ZHf6uU1cg@public.gmane.org

Hi Alex,

> OK, it seems to work for me, after ...
> -using a debian 2.6.24 kernel instead of a selfcompiled 2.6.22
> -maybe the 2.6.22 had a different compiler than the nilfs2 module
> 
> at the moment rsync works perfectly.
> 
> I'll mail again, if it has the BUG again. Until then, it seems resolved.
> ;)

I see. I'll wait for your next report breathlessly. :)

So far, we haven't been able to reproduce the problem by tests
in a similar fashion.

This might be caused by a defect of exclusion control.
If so, it's hard to track it by phenomena.
So, I'll think reviewing the source code of related parts
during making kernel patches of NILFS.

Cheers,
Ryusuke Konishi
