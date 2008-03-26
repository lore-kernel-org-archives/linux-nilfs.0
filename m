From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Kernel Bug while deleting files (with rsync)
Date: Wed, 26 Mar 2008 22:05:32 +0900 (JST)
Message-ID: <20080326.220532.62697306.ryusuke@osrg.net>
References: <20080325102553.GA10853@laxu.de>
	<1206445521.3131.60.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1206445521.3131.60.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [NILFS users] Kernel Bug while deleting files (with rsync)
Date: Tue, 25 Mar 2008 20:45:20 +0900
> On Tue, 2008-03-25 at 11:25 +0100, Alexander Schier wrote:
> > kernel BUG at /home/allo/nilfs-2.0.0/fs/page.c:436!
> <snip>
> > Yes, its 2.0.0 because of the 2.0.1 incompatiblity. If its in 2.0.1 fixed, disregard this ;).
> 
> Whoa, it seems to be a new bug!
> This one seems rather tough. :(
> 
> OK, I'll review it before releasing the version 2.0.2.
> Anyway, thanks for sending the log.

I couldn't find out the cause because the function called
BUG() was a cleanup routine, not that making the failure.

Instead of tweaking around, I added some code to get more
information about the page in inconsistent states without
sacrificing performance.

Please try v2.0.2 released shortly before.
If the bug will be reproduced, we would get some sort of clue.

Thanks,
Ryusuke Konishi
