From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: root nilfs
Date: Sun, 15 Mar 2009 23:21:30 +0100
Message-ID: <49BD7F6A.4000100@prnet.org>
References: <367e7ff90903151133s318863ake00311a709ea2f83@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <367e7ff90903151133s318863ake00311a709ea2f83-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

hi,

i am using nilfs as a root parition. i simply compiled the modules
normally and created and initrd that will load them before loading the
nilfs filesystem.

bye,
david arendt

ps sorry for everything in noncapital letters, but my keyboard driver
has some problems and i can't reboot the machine until a big video
render job is completed.

Roman Shtylman wrote:
> I am getting two SSD and would like to run NILFS as the root partition
> on them. I understand grub does not have support to boot into nilfs,
> so I will make an ext# /boot for that. My question is: what is the
> easiest way to compile in support for nilfs2 into the kernel? As I
> understand it, modules arn't enough when making an nilfs root and the
> kernel must support the filesystem without having to load modules (as
> it can't read the / which has the modules without knowing how to read
> the FS)
>
> Can anyone point me in the right direction on this?
>
> Thanks.
>
> ~Roman
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>   
