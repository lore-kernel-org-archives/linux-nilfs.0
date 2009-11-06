From: Andrew Benton <b3nton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_cleanerd won't run on root
Date: Fri, 06 Nov 2009 11:43:59 +0000
Message-ID: <4AF40BFF.2080301@gmail.com>
References: <4AF30E2C.1030104@gmail.com> <87639oqkfb.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <87639oqkfb.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
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

On 06/11/09 05:41, Jiro SEKIBA wrote:
> Hi, Andrew
>
> Which distribution are you using?
> What version of kernel and nilfs module are in the distro?
> How is your /proc/mounts like?
>
> It looks like you are using a bit older version.
> Older version of nilfs2-utils had the similar problem,
> but latest version would not have the issue.
>

I'm using nilfs-utils-2.0.14. The kernel is a vanilla 2.6.31.4 self
compiled with no modules (everything compiled in). The system is self
compiled (based on Linux From Scratch).
/proc/mounts is a symbolic link pointing at /proc/self/mounts.
/proc/self is a symbolic link pointing at /proc/1511 so /proc/mounts is
actually pointing at /proc/1511/mounts

andy:~$ cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / nilfs2 rw,relatime 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
tmpfs /dev tmpfs rw,relatime,mode=755 0 0
devpts /dev/pts devpts rw,relatime,gid=4,mode=620 0 0
shm /dev/shm tmpfs rw,relatime 0 0
/dev/sda1 /mnt/windows ntfs ro,relatime,uid=0,gid=0,umask=00,nls=default,errors=continue,mft_zone_multiplier=1 0 0
/dev/sda7 /home reiserfs rw,relatime 0 0
/dev/sda3 /mnt/lfs btrfs rw,relatime 0 0
andy:~$
