From: nilfs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org
Subject: Re: Dump tools for checkpoints
Date: Fri, 13 Mar 2009 17:42:20 +0100
Message-ID: <2893.84.133.153.87.1236962534.squirrel@ssl.its-beck.de>
References: <2883.84.133.202.72.1235869032.squirrel@ssl.its-beck.de>
	<20090308.143916.113539820.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090308.143916.113539820.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

> Basically I believe this is possible, but one problem is how to
> realize rollback of the remote nilfs which will become required when
> allowing user's updates or garbage collection on the remote device
> after synchronization.

let's call them master / slave, I'm confused which one is remote :)

I assume only the master is writable and slaves don't do any changes or
cleaning.

Require that all checkpoints from last sync to present are still existing.
Upon dump on master, cleanerd has to be suspended and may resume after
dump. Does that make things easier?

By the way: When I completely disable cleanerd on the master, wouldn't it
be possible to define a byte-range on the block device which makes up the
difference between two checkpoints and copy that to the slaves?

Regards,

Pierre Beck
