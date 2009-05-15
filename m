From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: users Digest, Vol 38, Issue 13
Date: Fri, 15 May 2009 09:21:43 +0900 (JST)
Message-ID: <20090515.092143.09779544.ryusuke@osrg.net>
References: <mailman.1.1242270001.16807.users@nilfs.org>
	<20090514193916.1d8e982e@simplux>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090514193916.1d8e982e@simplux>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, mniederle-RbZlAiThDcE@public.gmane.org
Cc: Milos Jana <milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi!
On Thu, 14 May 2009 19:39:16 +0200, "Michael Niederle" wrote:
> I'm evaluating nilfs as a replacement for the typical layered filesystem
> approach (unionfs, aufs) used in live-systems.
> 
> nilfs performs incredibly well! Its sequential write / random read philosophy
> is great for accessing pen-drives.

Thanks, but I suspect partially the writes are not done on your
pendrive ;-)
 
> I have only one big problem: I twice corrupted the nilfs-superblock (due to
> inproper shutdown) leading to a complete data loss each time.

Yeah, that is a headache.  Milos Jana has been reporting this issue
for long periods, but we haven't solved this yet.

What is your pendrive product?

I'd like to buy a pendrive to clarify the root cause of this problem.

BTW, could you try switching IO scheduler to "noop" ?
It can be done as follows:

 # cd /sys/block/sda/queue    
   ('sda' should be the device name of the pendrive)
 # cat scheduler
 anticipatory deadline [cfq] noop
 # echo noop > scheduler
 # cat scheduler
 anticipatory deadline cfq [noop]

I think this would help to narrow down the problem.

> The todo-list mentions that more copies of the superblock are needed. I
> strongly agree! I think this should be one of the top items on the todo-list.
> 
> Greetings, Michael

The latest nilfs already has secondary super block in tail of
partition.  But it looks insufficient for this pendrive problem.

I think ensuring write on unmount should come before that.

Regards,
Ryusuke Konishi
