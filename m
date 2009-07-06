From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: can't start nilfs_cleanerd on root fs
Date: Mon, 06 Jul 2009 12:56:49 +0900 (JST)
Message-ID: <20090706.125649.101609242.ryusuke@osrg.net>
References: <mailman.1.1246762801.19752.users@nilfs.org>
	<20090706025104.GA6163@odysseus.gateway.2wire.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090706025104.GA6163-SsamVeerapxB2jdCq39ADS3k8SM3+oTIrE5yTffgRl4@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, psykojime-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org

Hi,
On Sun, 5 Jul 2009 21:51:04 -0500, James Erickson wrote:
> i have nilfs2 as my root partition also. the only thing that works for
> me is to call nilfs_cleanerd explicitly as root with no device. so as
> root i just call "/sbin/nilfs_cleanerd" and it starts on the root
> partititon. i don't know why this is but it is the only thing that works
> on my gentoo amd64 system. i would like for it to start at boot but it
> does not. maybe this will change in the future. good luck.

Could you try the patch I attached yesterday in the following mail ?

https://www.nilfs.org/pipermail/users/2009-July/000782.html

nilfs_cleanerd refers to /proc/mounts to find or check existing
mounts.  How does the root partition look like in /proc/mounts ?

Regards,
Ryusuke Konishi
