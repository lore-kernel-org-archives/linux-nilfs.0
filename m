From: mail-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org
Subject: Re: continuous backup solution with nilfs
Date: Thu, 26 Mar 2009 02:06:50 +0100
Message-ID: <4701.84.133.208.102.1238029603.squirrel@ssl.its-beck.de>
References: <4577.84.133.242.204.1237943266.squirrel@ssl.its-beck.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4577.84.133.242.204.1237943266.squirrel-lZV7jZi4TBeO2lRZCxuEEg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi,

> I will now watch the nilfs2 device fill up to see what happens and will
> report back soon.

this went better than I thought. nilfs2 is still online, simply reporting
disk full. Linux RAID marked the remote loop device as faulty and
continued. I removed them with mdadm. losetup could unload them as well.
Nothing ugly happened.

What I learned in the process is that lscp is painfully slow when there
are many checkpoints to report. In my case, two weeks worth with one cp
every 5 secs (database traffic is really worst case for any filesystem)
took about 20 minutes to dump. 10 mb. This is nilfs-utils 2.0.6 - maybe
this is fixed in a later release? Anyway, my nilfs was running without
cleanerd and that has to have some downsides.

Space filled up very quickly, which leads me to a more realistic approach
in which the remote loop file will be added to do backup, then removed
again. Maybe once an hour or every ten minutes, or daily - depending on
how much space one can spend on backup and how much is moving on the
indestructible block device.

Of course it would be much much more efficient to have a block device
designed to do logging without loop and nilfs2 below, but I haven't seen
anything like that yet.

So for now, creating an indestructible block device is a fun thing to do
and provides a backup solution with features way beyond most backup
software out there.

Good:
 * incremental block-level backup
 * point-in-time recovery for both, single files and complete volume
 * works via network, so off-site is possible
 * real-time backup

Bad:
 * No cleanerd for this - have to replace volumes by hand
 * Much backup-space overhead
 * Probably lots of traffic
 * No warranty whatsoever, ymmv

So far,

Pierre Beck
