From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Root file system has filled up, won't boot anymore
Date: Mon, 22 Jun 2009 03:48:47 +0900 (JST)
Message-ID: <20090622.034847.62046349.ryusuke@osrg.net>
References: <172291b30906210922i2089a389jbc9b664e6b9d7c00@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <172291b30906210922i2089a389jbc9b664e6b9d7c00-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, kristjan.eerik.kaseniit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Sun, 21 Jun 2009 19:22:33 +0300, Kristjan Eerik Kaseniit wrote:
> Hello,
> 
> I've installed gentoo on a NILFS2 formatted MMC SDHC card and have
> been using it as my root partition. I used it just fine until after
> a reboot I couldn't boot into the system (produces a kernel "BUG"
> with the message that it's got an unknown opcode) and from another
> install I cannot chroot into it (gives a segmentation fault), lscp
> doesn't finish but dies half way and both wcommands won't even
> produce output on a second try.  The problem that caused this seems
> to be that the whole file system is full - that's what all the
> commands tell me.
>
> How should I proceed? Can I free up some space or do I have to make a clean
> install?

Is there nilfs_cleanerd process?  If it does not exist, please invoke
it by hand:

 # nilfs_cleanerd /dev/sdb1

In this case, you also have to shutdown the cleanerd by hand before
you unmount the partition.

The cleanerd process may not start working until protection_period
elapses.  The protection period is set in /etc/nilfs_cleanerd.conf, so
you cannot rewrite it under disk full condition.  I'm considering to
add a new option which specifies the protecion period to help recovery
from this kind of stuck.

I think you should do recovery in the original (out of chroot)
environment because some files including syslog are always appended or
modified in the root filesystem, and you can modify the
nilfs_cleanerd.conf file there.


> I'm keeping the partition intact for a while (can boot off my harddrive) so
> I can get some debug info but first I need to know what is necessary to be
> helpful.
> Should I post the kernel message I get when I boot?

Please post the first BUG message if you can get it.  It may be
helpful to analyze the unknown problem.

Thanks,
Ryusuke Konishi
