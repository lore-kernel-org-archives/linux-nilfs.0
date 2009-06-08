From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [SPAM] Write hang on ARM based target
Date: Tue, 09 Jun 2009 01:49:19 +0900 (JST)
Message-ID: <20090609.014919.79903506.ryusuke@osrg.net>
References: <BAEFA5609CC3AB4BAE1625CAD4C27E5C01900F8D@tdpost.td.tandbergdata.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <BAEFA5609CC3AB4BAE1625CAD4C27E5C01900F8D-qPLjlnsG5hmCmmEZ8mJCX5vx1ZQ4fP860E9HWUfgJXw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, WDunphy-/3AnZwnt+WyVkR+q5Y5grQ@public.gmane.org

Hi!
On Mon, 8 Jun 2009 09:46:52 -0600, "Dunphy, Bill" wrote:
> Greetings,
>  
> I'm attempting to get NILFS up and running on a Marvell DB-88F6281-BP-A
> (ARM) and have experienced a consistent hang during data transfer.  This
> target board is running a 2.6.22.18 kernel and I've tested it against
> NILFS versions 2.0.12, 2.0.14 and the latest git pull (6/4/09).  I've
> eliminated the garbage collector and and have enabled full debugging for
> log capture.  The failure is not immediate or at a fixed point -
> typically in the 1-2GB neighborhood of writing variably sized files.
> This same exercise (a simple recursive local copy) works flawlessly on
> my host Ubuntu i86 machine as well as on the target with an ext3 file
> system.
>  
> Is there a specific kernel feature that I might be missing and need to
> enable?  A kernel version sensitivity?  Is this log information
> something you would be interested in seeing?  If so, how verbose would
> you like it or better still, how would you like me to collect it?

Thanks for reporting.

What will happen if you trigger SysRq when you meet the hang?

 # echo t > /proc/sysrq-trigger

I don't know whether the arm kernel codes is supporting sysrq, but we
may get the stack dump of the nilfs task hung at some lock.  If it
works, it would help us to narrow down the problem.

Also, you can know the progress of segment writer by specifying the
following debug options,

 # echo "-vvv segment -vv seginfo" > /proc/fs/nilfs2/debug_option

This feature is only available on the nilfs2 out-of-tree module built
with CONFIG_NILFS_DEBUG=y option.

Could you try either of these?

Thanks in advance,
Ryusuke Konishi
