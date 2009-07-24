From: Robertas Dumpis <robertas.dumpis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: lscp: Inappropriate ioctl for device
Date: Fri, 24 Jul 2009 18:56:34 +0300
Message-ID: <1248450994.15108.9.camel@robertodu>
References: <4A69D37E.9090000@epoch.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A69D37E.9090000-ZE272gM1l1AAvxtiuMwx3w@public.gmane.org>
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

Hi David,

I've had the same problem on Ubuntu 9.04.
It seems that an very old version (2.0.6 ???) of nilfs-tools is
installed by package manager and no update available through Ubuntu 9.04
update channel.

Downloading, compiling and installing latest version of nilfs-tools will
fix this issue.



Robertas

On Fri, 2009-07-24 at 08:30 -0700, David Fuller wrote:
> I just recently installed Ubuntu 9.04 and custom built the 2.6.30.2 kernel 
> with the nilfs options outlined on the site.
> 
> I am able to mount the partition with no errors.
> 
> I do an error as follows:
> 
> Jul 22 13:09:53 hostname nilfs_cleanerd[9470]: start
> Jul 22 13:09:53 hostname nilfs_cleanerd[9470]: cannot get segment usage 
> stat: Inappropriate ioctl for device
> Jul 22 13:09:53 hostname nilfs_cleanerd[9470]: shutdown
> 
> ...
> 
> Jul 22 13:13:12 hostname nilfs_cleanerd[9538]: start
> Jul 22 13:13:12 hostname kernel: [18500.590098] VFS: Can't find ext4 
> filesystem on dev sda1.
> Jul 22 13:13:12 hostname kernel: [18500.594342] segctord starting. 
> Construction interval = 5 seconds, CP frequency < 30 seconds
> Jul 22 13:13:12 hostname nilfs_cleanerd[9538]: cannot get segment usage 
> stat: Inappropriate ioctl for device
> Jul 22 13:13:12 hostname nilfs_cleanerd[9538]: shutdown
> Jul 22 13:14:51 hostname nilfs_cleanerd[9547]: start
> Jul 22 13:14:51 hostname kernel: [18599.765573] segctord starting. 
> Construction interval = 5 seconds, CP frequency < 30 seconds
> Jul 22 13:14:51 hostname nilfs_cleanerd[9547]: cannot get segment usage 
> stat: Inappropriate ioctl for device
> Jul 22 13:14:51 hostname nilfs_cleanerd[9547]: shutdown
> 
> 
> Also when I try to list the checkpoints, I get the following error:
> 
> lscp: Inappropriate ioctl for device
> 
> 
> Please advise.
> 
> 
> Thanks,
> --David F.
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
