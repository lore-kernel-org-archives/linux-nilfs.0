From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: pp (protection period) mount option
Date: Sat, 28 Nov 2009 01:23:03 +0900 (JST)
Message-ID: <20091128.012303.54434171.ryusuke@osrg.net>
References: <4B0FE052.70307@unity-linux.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4B0FE052.70307-0RIiUExYzkzCfDggNXIi3w@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, david-0RIiUExYzkzCfDggNXIi3w@public.gmane.org

Hi!
On Fri, 27 Nov 2009 15:21:06 +0100, David Smid <david-0RIiUExYzkzCfDggNXIi3w@public.gmane.org> wrote:
> Hi,
> 
> I have two nilfs2 partitions and want to set different protection period for
> each of them. I know nilfs_cleanerd has an option -p which allows to override
> the protection period but using it would require to mount both partitions and
> launch their cleaner daemons manually or within a script.
> Since I want to use fstab I had to implement this option as a mount.nilfs2 extra
> option.
> 
> Not much was done to the kernel module: it just had to accept 'pp=' as a valid
> mount option.
> mount.nilfs2 was modified to parse this option and its value and to pass it to
> nilfs_cleanerd command line.
> 
> See the patches.
> 
> 
> Regards,
> 
> David Smid

Thank you for the patches.
I understood your intention.

One comment.  I don't like the dummy option is added to the kernel
code because protection_period is entirely independent with it.

Can you modify the patch so that mount.nilfs2 gets out the pp option
from the string passed to the mount system call?

A ready-made function, change_opt() would be available for that
purpose.

(only from extra_opts; mtab should include it to keep the value for
cleanerd_ctl, of course)

And, please inline patches in the mail; this makes it easy to comment
on them.

Thanks,
Ryusuke Konishi
