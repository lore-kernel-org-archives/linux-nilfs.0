From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Thu, 15 Jan 2009 20:48:26 +0900 (JST)
Message-ID: <20090115.204826.100013794.ryusuke@osrg.net>
References: <3313c4ab0901141404h97995dgf58282876b0ffd42@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <3313c4ab0901141404h97995dgf58282876b0ffd42-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Wed, 14 Jan 2009 23:04:30 +0100, "Milos Jana" wrote:
> Hi,
> After 2 weeks of successful using of NILFS on my pendrive I encountered this
> error:
> 
> milos@computer:~$ sudo mount /media/pendrive/
> [sudo] password for user:
> mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid
> argument
> 
> First, I thought there was something wrong with /etc/fstab entry, which
> looks like this:
> 
> /dev/sdb /media/pendrive nilfs2 noauto,user,rw 0 0
> 
> But it looked the same when drive was working fine, I also tried different
> parameters but it did not help. The last two lines from dmesg output made me
> even more worry:
<snip>
> 
> I'm using nilfs2-tools 2.0.3-1 on kernel 2.6.27-10, the error also occurs
> after upgrade to nilfs2-utils and nilfs kernel module 2.0.6.

Thanks for reporting the trouble.
 
> How can I recover this drive? I didn't create any checkpoints, afair the
> only thing I have done was to create the new filesystem using mkfs.nilfs2
> command.

Could you try the test version of fsck available in the follwing url?

https://www.nilfs.org/pipermail/users/2008-December/000350.html

The patch is against nilfs-utils, and it will generate
fsck0.nilfs2 in nilfs2-utils/sbin/mkfs directory.

 Patch Usage:
 $ cd nilfs-utils-2.0.6
 $ patch -p1 < path-to-fsck0.patch
 $ ./configure
 $ make
 $ sudo make install
 $ sudo fsck0.nilfs2 <device>

Regards,
Ryusuke
