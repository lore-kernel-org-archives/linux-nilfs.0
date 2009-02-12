From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Cleanerd performance,
 and symlinks issue observations
Date: Thu, 12 Feb 2009 15:01:45 +0900 (JST)
Message-ID: <20090212.150145.08434473.ryusuke@osrg.net>
References: <591bc86b0902081603v6159621fo46daf555b5f6f7f2@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <591bc86b0902081603v6159621fo46daf555b5f6f7f2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, san-UZOCzndLCy9BDgjK7y7TUQ@public.gmane.org

Hi,
On Mon, 9 Feb 2009 02:03:59 +0200, Alex Bitney wrote:
> Hello,
> 
> I am using nilfs on root filesystem, too, on 8G SSD drive (Acer Aspire
> One). While converting filesystem to nilfs, I used tar, and upon
> extraction received 0-length files instead of symlinks in /etc/rc2.d
> and similar directories. After that, I started using CPIO and problem
> has gone. So, maybe this is TAR issue, not nilfs, some rare
> conditions..

We found tar makes 0-length files during expansion, but we didn't yet
see them after extraction completed.
It needs more tests or much easy way to reproduce the problem.
 
> Regarding performance of cleanerd. Correct me, if I'm wrong. It seems
> to circularly scan the whole filesystem. For some busy parts of the
> filesystem it works slower, for parts which will become unused it is
> faster. In my /var/log/debug it reports total number of clean segments
> each time after cleanup iteration, and it seems that this number is
> not increased when nilfs works harder (it means data remains in
> place). In the same time I observe intensive write operations. My
> question is: why write segments if they are not going to be freed?
> Saying "write operations" i mean really hard I/O, long 20mb/sec
> reading, followed by long 15mb/sec writing. Maybe this is how SSD
> disks work.. but system is unresponsive during this operation.

Yes, I don't think the current GC method is enough.
Honesty, it is unfinished and should be revised to cleverly select
segments to be cleaned.

Actually, the kernel code of nilfs can clean segments in any order.
So, the above problem mainly depends on the implementation level of
the current userland cleaner program.  Other GC strategy should be
developed especially for SSD, I think.
 
> Several people here already asked for cleanerd GC overview. I have no
> ACM access and I don't know whether that document contains it. Could
> you please share some details with this mailing list. Or, forget it,
> I'm going to read the sources.

ACM papar does not include information on GC.
Sorry for this. I heard that that mail is not yet responded.
I'll make time to answer the mail.
 
> I would like to thank you for your great work, too ;)
> 
> Regards,
> Sanoff.

Thanks for cheering, thanks.

Ryusuke
