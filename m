From: mail-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org
Subject: Re: Dump tools for checkpoints
Date: Fri, 13 Mar 2009 18:33:08 +0100
Message-ID: <3214.84.133.153.87.1236965583.squirrel@ssl.its-beck.de>
References: <2883.84.133.202.72.1235869032.squirrel@ssl.its-beck.de>
	<20090308.143916.113539820.ryusuke@osrg.net>
	<20090313162609.GD7494@zaphod.leonweber.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090313162609.GD7494-Tv691C15nu5348sJH/KcYBvVK+yQ3ZXh@public.gmane.org>
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
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

> Is replication really a feature that a file system should implement? I
> think it should be implemented one layer below the fs. If one needs a
> replicated file system, there are things like drbd (distributed
> replicated block device).

yes, the task is similar to what drbd does. But for nightly incremental
backup, drbd would be overkill. It's called "RAID1 over network"! Rsync is
slow and consumes much CPU. Incremental backup software can't cope with
big files AFAIK. Nilfs could fill that gap perfectly.

- Have database / virtual machines / etc. on nilfs
- Do a nightly or hourly "nsync" to a remote mirror

Regards,

Pierre Beck
