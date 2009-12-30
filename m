From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NILFS2 on an Intel X25-M SSD
Date: Thu, 31 Dec 2009 03:46:29 +0900 (JST)
Message-ID: <20091231.034629.85391956.ryusuke@osrg.net>
References: <4B3A5D1F.9010002@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4B3A5D1F.9010002-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: crmafra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Tue, 29 Dec 2009 20:48:47 +0100, "Carlos R. Mafra" wrote:
> Hi,
> 
> Thanks for your work with NILFS2 on the kernel. 
> 
> I've just bought an Intel 160 GB SSD drive and while I am waiting
> it to arrive I am reading about which filesystem is better to use
> with it.
> 
> As I was reading about it I found out about NILFS2 and I am almost 
> certain that I will try it on the SSD.
> 
> I plan to use the 160 GB as 10 GB to / and 150 GB to /home. As I am not sure
> grub will handle the NILFS2 on /boot, / will be ext4 and /home will be
> NILFS2.

Nilfs is applicable to / by putting nilfs2.ko in initrd, but I think
using nilfs for /home is a convenient choice.

> Is there any specific tweak in NILFS2 to use with an SSD? Would you
> reccomend using NILFS2 on a SSD right now?
>
> Is the issue mentioned here
> 
> https://www.nilfs.org/pipermail/users/2009-March/000514.html
> 
> about excessive writing in the GC already fixed?
> That is the most pressing fear I have about NILFS2 for the SSD.
>
> Regards,
> Carlos

Not yet, sorry.  I'm working on some performance optimization for high
speed drives espacially for SSD.  Revising GC is another priority, but
it would need some time.

The massive I/O by the current garbage collector may shorten the life
of SSD.  So, I don't recommend yet.

If you are not interested in snapshots, I think nilfs is not always a
good choice because high-end SSD drives are already doing lfs like
optimization internally.  Intel SSD exactly looks like this sort of
drives though I'm using nilfs on X25-M and X25-E ;)

> PS: If you would like to answer me with a Cc: to some mailing list
> so that others benefit from the information, feel free to do so if
> you wish.

Thanks,
Ryusuke Konishi
